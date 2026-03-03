// Liked routes from community (Heart tab) – persisted ids + display model
import Foundation

struct LikedRouteItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let imageUrl: String?
    let draftId: UUID?  // if from user's draft
}

enum ProfileLikedStore {
    private static let key = "ProfileLikedStore_ids"

    static var likedIds: [String] {
        get { UserDefaults.standard.stringArray(forKey: key) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    static func isLiked(id: String) -> Bool { likedIds.contains(id) }
    static func toggle(id: String) {
        var ids = likedIds
        if ids.contains(id) { ids.removeAll { $0 == id } }
        else { ids.append(id) }
        likedIds = ids
    }

    /// Liked items for Heart tab grid (mix of community mock + any saved draft ids).
    static func likedItems(allDrafts: [DraftItem]) -> [LikedRouteItem] {
        let ids = likedIds
        var items: [LikedRouteItem] = []
        for id in ids {
            if let uuid = UUID(uuidString: id), let draft = allDrafts.first(where: { $0.id == uuid }) {
                items.append(LikedRouteItem(
                    id: draft.id.uuidString,
                    title: draft.title,
                    subtitle: draft.source.tagLabel,
                    imageUrl: nil,
                    draftId: draft.id
                ))
            } else {
                items.append(mockCommunityItem(id: id))
            }
        }
        if items.isEmpty {
            return mockDefaultLiked()
        }
        return items
    }

    private static func mockCommunityItem(id: String) -> LikedRouteItem {
        LikedRouteItem(
            id: id,
            title: "Community Route",
            subtitle: "Discovery",
            imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400",
            draftId: nil
        )
    }

    private static func mockDefaultLiked() -> [LikedRouteItem] {
        [
            LikedRouteItem(id: "liked_1", title: "Alpine Loop", subtitle: "Colorado", imageUrl: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400", draftId: nil),
            LikedRouteItem(id: "liked_2", title: "Coastal Trail", subtitle: "Big Sur", imageUrl: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400", draftId: nil),
        ]
    }
}
