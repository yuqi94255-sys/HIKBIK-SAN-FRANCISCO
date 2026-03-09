// MARK: - Navigation Engine — Snapped location, elevation progress, turn instructions. GPX-driven.
import Foundation
import CoreLocation
import SwiftUI

struct TurnInstruction {
    var icon: String
    var text: String
    var distanceToTurnMeters: Double
}

final class NavigationEngine: ObservableObject {
    @Published var snappedCoordinate: CLLocationCoordinate2D?
    @Published var progressDistanceMeters: Double = 0
    @Published var currentElevation: Double = 0
    @Published var currentInstruction: TurnInstruction?
    @Published var isOffRoute: Bool = false

    private var coordinates: [CLLocationCoordinate2D] = []
    private var elevations: [Double] = []
    private var distances: [Double] = []
    private let offRouteThresholdMeters: Double = 25
    private let turnAngleThresholdDegrees: Double = 120

    var totalDistanceMeters: Double { distances.last ?? 0 }

    func load(result: GPXParseResult) {
        coordinates = result.coordinates
        elevations = result.elevations
        distances = result.distances
    }

    func update(userLocation: CLLocation?) {
        guard let loc = userLocation, !coordinates.isEmpty else {
            snappedCoordinate = nil
            return
        }
        let coord = loc.coordinate
        let (index, t, distToPath) = nearestSegment(from: coord)
        isOffRoute = distToPath > offRouteThresholdMeters

        guard index >= 0, index < coordinates.count else {
            snappedCoordinate = coord
            return
        }

        let segStart = distances[index]
        let segEnd = index + 1 < distances.count ? distances[index + 1] : segStart
        progressDistanceMeters = segStart + t * max(0, segEnd - segStart)

        let snappedLat = coordinates[index].latitude + t * (coordinates[index + 1].latitude - coordinates[index].latitude)
        let snappedLon = coordinates[index].longitude + t * (coordinates[index + 1].longitude - coordinates[index].longitude)
        snappedCoordinate = CLLocationCoordinate2D(latitude: snappedLat, longitude: snappedLon)

        currentElevation = elevation(at: progressDistanceMeters)
        currentInstruction = nextTurnInstruction(progressMeters: progressDistanceMeters)
    }

    /// Returns (segment index, t in [0,1], distance from point to segment).
    private func nearestSegment(from point: CLLocationCoordinate2D) -> (index: Int, t: Double, distanceMeters: Double) {
        var bestIndex = 0
        var bestT: Double = 0
        var bestDist = Double.greatestFiniteMagnitude

        for i in 0..<(coordinates.count - 1) {
            let a = coordinates[i], b = coordinates[i + 1]
            let (d, t) = distanceToSegment(from: point, segmentStart: a, segmentEnd: b)
            if d < bestDist {
                bestDist = d
                bestIndex = i
                bestT = t
            }
        }
        return (bestIndex, bestT, bestDist)
    }

    private func distanceToSegment(from point: CLLocationCoordinate2D, segmentStart a: CLLocationCoordinate2D, segmentEnd b: CLLocationCoordinate2D) -> (Double, Double) {
        let dx = b.longitude - a.longitude
        let dy = b.latitude - a.latitude
        let t = max(0, min(1, (dx * (point.longitude - a.longitude) + dy * (point.latitude - a.latitude)) / (dx * dx + dy * dy + 1e-20)))
        let px = a.latitude + t * (b.latitude - a.latitude)
        let py = a.longitude + t * (b.longitude - a.longitude)
        let dist = CLLocation(latitude: point.latitude, longitude: point.longitude)
            .distance(from: CLLocation(latitude: px, longitude: py))
        return (dist, t)
    }

    private func elevation(at distanceMeters: Double) -> Double {
        guard !distances.isEmpty, !elevations.isEmpty else { return 0 }
        if distanceMeters <= 0 { return elevations[0] }
        if distanceMeters >= (distances.last ?? 0) { return elevations.last ?? 0 }
        guard let i = distances.firstIndex(where: { $0 >= distanceMeters }), i > 0 else { return elevations[0] }
        let d0 = distances[i - 1], d1 = distances[i]
        let frac = (d1 - d0) > 0 ? (distanceMeters - d0) / (d1 - d0) : 0
        return elevations[i - 1] + frac * (elevations[i] - elevations[i - 1])
    }

    /// When path angle between consecutive segments is less than 120°, emit a turn. Returns next turn ahead of user.
    private func nextTurnInstruction(progressMeters: Double) -> TurnInstruction? {
        guard coordinates.count >= 3, distances.count == coordinates.count else { return nil }
        var bestTurnIndex = -1
        for i in 1..<(coordinates.count - 1) {
            guard distances[i] > progressMeters else { continue }
            let v0 = (coordinates[i].latitude - coordinates[i - 1].latitude, coordinates[i].longitude - coordinates[i - 1].longitude)
            let v1 = (coordinates[i + 1].latitude - coordinates[i].latitude, coordinates[i + 1].longitude - coordinates[i].longitude)
            let dot = v0.0 * v1.0 + v0.1 * v1.1
            let len0 = sqrt(v0.0 * v0.0 + v0.1 * v0.1) + 1e-10
            let len1 = sqrt(v1.0 * v1.0 + v1.1 * v1.1) + 1e-10
            let angleDeg = acos(max(-1, min(1, dot / (len0 * len1)))) * 180 / .pi
            if angleDeg < turnAngleThresholdDegrees {
                bestTurnIndex = i
                break
            }
        }

        guard bestTurnIndex >= 0 else { return nil }
        let distToTurn = distances[bestTurnIndex] - progressMeters
        if distToTurn <= 0 { return nil }

        let a = coordinates[bestTurnIndex - 1]
        let b = coordinates[bestTurnIndex]
        let c = coordinates[bestTurnIndex + 1]
        let bearingIn = atan2(b.longitude - a.longitude, b.latitude - a.latitude) * 180 / .pi
        let bearingOut = atan2(c.longitude - b.longitude, c.latitude - b.latitude) * 180 / .pi
        var delta = (bearingOut - bearingIn).truncatingRemainder(dividingBy: 360)
        if delta > 180 { delta -= 360 }
        if delta < -180 { delta += 360 }

        let (icon, text): (String, String)
        if delta > -30 && delta <= 30 {
            icon = "⬆️"; text = "Straight"
        } else if delta > 30 && delta <= 90 {
            icon = "↗️"; text = "Bear right"
        } else if delta > 90 && delta <= 150 {
            icon = "➡️"; text = "Turn right"
        } else if delta > 150 || delta <= -150 {
            icon = "⬇️"; text = "Turn around"
        } else if delta > -150 && delta <= -90 {
            icon = "⬅️"; text = "Turn left"
        } else {
            icon = "↖️"; text = "Bear left"
        }
        return TurnInstruction(icon: icon, text: text, distanceToTurnMeters: distToTurn)
    }
}
