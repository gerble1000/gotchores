import Foundation

public final class GotChoresApi {
    public static let shared = GotChoresApi()
    public var baseUrl = "https://gotchores.net/api"
    
    private let session = URLSession.shared
    
    public init() {}
    
    public func pairWithCode(code: String, token: String = UUID().uuidString) async throws -> PairResponse {
        guard let url = URL(string: "\(baseUrl)/pair.php") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let reqBody = PairRequest(code: code, token: token)
        request.httpBody = try JSONEncoder().encode(reqBody)
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(PairResponse.self, from: data)
    }
    
    public func fetchSync(deviceToken: String) async throws -> SyncDto {
        guard let url = URL(string: "\(baseUrl)/sync.php") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(deviceToken, forHTTPHeaderField: "X-Device-Token")
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(SyncDto.self, from: data)
    }
    
    public func completeChore(deviceToken: String, assignmentId: Int, comment: String = "") async throws -> CompleteResponse {
        guard let url = URL(string: "\(baseUrl)/complete.php") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(deviceToken, forHTTPHeaderField: "X-Device-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "assignment_id": assignmentId,
            "comment": comment
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(CompleteResponse.self, from: data)
    }
    
    public func claimReward(deviceToken: String, rewardId: Int) async throws -> RewardClaimResponse {
        guard let url = URL(string: "\(baseUrl)/claim-reward.php") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(deviceToken, forHTTPHeaderField: "X-Device-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Int] = ["reward_id": rewardId]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(RewardClaimResponse.self, from: data)
    }
}
