// MARK: - GPX Parser — Extract ALL <trkpt> under <trkseg>. No name filter, no first+last only. English only.
import Foundation
import CoreLocation

struct GPXParseResult {
    /// Every track point in order (1.3 km with 500 points → 500 entries). Use for MapPolyline so the line curves.
    var coordinates: [CLLocationCoordinate2D]
    var elevations: [Double]
    var distances: [Double]
    var totalDistanceMeters: Double { distances.last ?? 0 }
}

final class GPXParser: NSObject {
    private var coordinates: [CLLocationCoordinate2D] = []
    private var elevations: [Double] = []
    private var currentLat: Double?
    private var currentLon: Double?
    private var currentEle: Double?
    private var inTrkpt = false
    private var inEle = false
    private var eleBuffer = ""

    /// Parses GPX and returns every <trkpt> in <trkseg> as a single array (all points, not just milestone or named waypoints).
    func parse(data: Data) -> GPXParseResult? {
        coordinates = []
        elevations = []
        currentLat = nil
        currentLon = nil
        currentEle = nil
        inTrkpt = false
        inEle = false
        eleBuffer = ""

        let parser = XMLParser(data: data)
        parser.delegate = self
        guard parser.parse() else { return nil }
        buildDistances()
        let dists = distancesFromCoordinates()
        return GPXParseResult(
            coordinates: coordinates,
            elevations: elevations,
            distances: dists
        )
    }

    func parse(string: String) -> GPXParseResult? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(data: data)
    }

    func parse(url: URL) -> GPXParseResult? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return parse(data: data)
    }

    private func buildDistances() {
        while elevations.count < coordinates.count {
            elevations.append(elevations.last ?? 0)
        }
        if elevations.count > coordinates.count {
            elevations = Array(elevations.prefix(coordinates.count))
        }
    }

    /// Cumulative distance in meters from start to each point.
    private func distancesFromCoordinates() -> [Double] {
        var dists: [Double] = [0]
        for i in 1..<coordinates.count {
            let a = coordinates[i - 1], b = coordinates[i]
            let d = CLLocation(latitude: a.latitude, longitude: a.longitude)
                .distance(from: CLLocation(latitude: b.latitude, longitude: b.longitude))
            dists.append((dists.last ?? 0) + d)
        }
        return dists
    }
}

extension GPXParser: XMLParserDelegate {
    private static func localName(_ elementName: String) -> String {
        if let last = elementName.split(separator: ":").last { return String(last) }
        return elementName
    }

    /// Iterate every <trkpt> under <trkseg>; do not use <wpt> or filter by name. Each trkpt → one append.
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        let name = Self.localName(elementName)
        if name == "trkpt" {
            inTrkpt = true
            if let lat = Double(attributeDict["lat"] ?? ""), let lon = Double(attributeDict["lon"] ?? "") {
                currentLat = lat
                currentLon = lon
                currentEle = nil
            }
        } else if name == "ele" && inTrkpt {
            inEle = true
            eleBuffer = ""
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let name = Self.localName(elementName)
        if name == "trkpt" {
            if let lat = currentLat, let lon = currentLon {
                coordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
                elevations.append(currentEle ?? 0)
            }
            currentLat = nil
            currentLon = nil
            currentEle = nil
            inTrkpt = false
        } else if name == "ele" {
            inEle = false
            if let ele = Double(eleBuffer.trimmingCharacters(in: .whitespacesAndNewlines)) {
                currentEle = ele
            }
            eleBuffer = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if inEle { eleBuffer += string }
    }
}
