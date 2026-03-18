// Collections (folders) for Profile – e.g. "2026 夏日溯溪計畫", "日本滑雪路線"
import Foundation

struct ProfileCollection: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var draftIds: [UUID]
    var createdAt: Date
    /// PHAsset localIdentifier for custom cover image (from route photos / photo library).
    var coverImageIdentifier: String?

    enum CodingKeys: String, CodingKey {
        case id, name, draftIds, createdAt, coverImageIdentifier
    }

    init(id: UUID = UUID(), name: String, draftIds: [UUID] = [], createdAt: Date = Date(), coverImageIdentifier: String? = nil) {
        self.id = id
        self.name = name
        self.draftIds = draftIds
        self.createdAt = createdAt
        self.coverImageIdentifier = coverImageIdentifier
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        draftIds = try c.decode([UUID].self, forKey: .draftIds)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        coverImageIdentifier = try c.decodeIfPresent(String.self, forKey: .coverImageIdentifier)
    }
}

enum ProfileCollectionsStore {
    private static let key = "ProfileCollections"

    static func loadAll() -> [ProfileCollection] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ProfileCollection].self, from: data) else { return [] }
        return decoded.sorted { $0.createdAt > $1.createdAt }
    }

    static func saveAll(_ items: [ProfileCollection]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func append(_ item: ProfileCollection) {
        var list = loadAll()
        list.insert(item, at: 0)
        saveAll(list)
    }

    static func update(id: UUID, name: String? = nil, draftIds: [UUID]? = nil, coverImageIdentifier: String? = nil) {
        var list = loadAll()
        guard let idx = list.firstIndex(where: { $0.id == id }) else { return }
        if let name = name { list[idx].name = name }
        if let draftIds = draftIds { list[idx].draftIds = draftIds }
        if let cover = coverImageIdentifier { list[idx].coverImageIdentifier = cover }
        saveAll(list)
    }

    static func addDraft(_ draftId: UUID, toCollectionId collectionId: UUID) {
        var list = loadAll()
        guard let idx = list.firstIndex(where: { $0.id == collectionId }) else { return }
        if !list[idx].draftIds.contains(draftId) {
            list[idx].draftIds.append(draftId)
            saveAll(list)
        }
    }

    static func remove(id: UUID) {
        var list = loadAll()
        list.removeAll { $0.id == id }
        saveAll(list)
    }
}
