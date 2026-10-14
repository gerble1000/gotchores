import Foundation

// MARK: - Core Models matching GotChores Android & Backend APIs

public struct HouseholdDto: Codable, Identifiable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct ChildDto: Codable, Identifiable {
    public let id: Int
    public let name: String
    public let username: String
    public let role: String?
    public let avatar: String?
    
    public init(id: Int, name: String, username: String, role: String? = nil, avatar: String? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.role = role
        self.avatar = avatar
    }
}

public struct PairRequest: Codable {
    public let code: String
    public let token: String
    
    public init(code: String, token: String) {
        self.code = code
        self.token = token
    }
}

public struct PairResponse: Codable {
    public let success: Bool
    public let message: String?
    public let token: String?
    public let deviceToken: String?
    public let deviceId: Int?
    public let parentPinHash: String?
    public let household: HouseholdDto?
    public let child: ChildDto?
    public let snapshot: SyncDto?
    
    enum CodingKeys: String, CodingKey {
        case success, message, token
        case deviceToken = "device_token"
        case deviceId = "device_id"
        case parentPinHash = "parent_pin_hash"
        case household, child, snapshot
    }
}

public struct ChoreItem: Codable, Identifiable, Equatable {
    public let id: String
    public let choreId: Int
    public let assignmentId: Int?
    public let title: String
    public let description: String?
    public let icon: String?
    public let rewardPoints: Int
    public let dueDate: String?
    public let dueTime: String?
    public let proofRequired: Bool
    public let isOptional: Bool
    public var assignmentStatus: String?
    public var completedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case choreId = "chore_id"
        case assignmentId = "assignment_id"
        case title, description, icon
        case rewardPoints = "reward_points"
        case dueDate = "due_date"
        case dueTime = "due_time"
        case proofRequired = "proof_required"
        case isOptional = "is_optional"
        case assignmentStatus = "assignment_status"
        case completedAt = "completed_at"
    }
}

public struct RewardItem: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let description: String?
    public let icon: String?
    public let pointsRequired: Int
    public let claimedToday: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, icon
        case pointsRequired = "points_required"
        case claimedToday = "claimed_today"
    }
}

public struct MemberItem: Codable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let username: String
    public let role: String?
    public let avatar: String?
    public let isEmojiAvatar: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, username, role, avatar
        case isEmojiAvatar = "is_emoji_avatar"
    }
}

public struct CompletedChoreItem: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let icon: String?
    public let rewardPoints: Int
    public let approvedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, icon
        case rewardPoints = "reward_points"
        case approvedAt = "approved_at"
    }
}

public struct NotificationItem: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String
    public let message: String
    public let type: String?
    public let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, message, type
        case createdAt = "created_at"
    }
}

public struct SyncDto: Codable {
    public let success: Bool
    public let points: Int?
    public let totalEarned: Int?
    public let chores: [ChoreItem]?
    public let optionalChores: [ChoreItem]?
    public let rewards: [RewardItem]?
    public let completedToday: [CompletedChoreItem]?
    public let members: [MemberItem]?
    public let notifications: [NotificationItem]?
    public let serverTime: Int64?
    
    enum CodingKeys: String, CodingKey {
        case success, points
        case totalEarned = "total_earned"
        case chores
        case optionalChores = "optional_chores"
        case rewards
        case completedToday = "completed_today"
        case members, notifications
        case serverTime = "server_time"
    }
}

public struct CompleteResponse: Codable {
    public let success: Bool
    public let message: String?
    public let assignmentId: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case assignmentId = "assignment_id"
    }
}

public struct ClaimResponse: Codable {
    public let success: Bool
    public let message: String?
    public let choreId: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case choreId = "chore_id"
    }
}

public struct RewardClaimResponse: Codable {
    public let success: Bool
    public let message: String?
    public let claimId: Int?
    
    enum CodingKeys: String, CodingKey {
        case success, message
        case claimId = "claim_id"
    }
}
