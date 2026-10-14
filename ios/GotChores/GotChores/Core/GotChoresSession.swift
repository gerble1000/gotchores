import Foundation

public final class GotChoresSession: ObservableObject {
    public static let shared = GotChoresSession()
    
    @Published public var isPaired: Bool = false
    @Published public var householdName: String = ""
    @Published public var childName: String = ""
    @Published public var deviceToken: String = ""
    @Published public var points: Int = 0
    @Published public var parentPinHash: String? = nil
    @Published public var isParentUnlocked: Bool = false
    
    private let defaults = UserDefaults.standard
    
    public init() {
        self.isPaired = defaults.bool(forKey: "gc_is_paired")
        self.householdName = defaults.string(forKey: "gc_household_name") ?? ""
        self.childName = defaults.string(forKey: "gc_child_name") ?? ""
        self.deviceToken = defaults.string(forKey: "gc_device_token") ?? ""
        self.points = defaults.integer(forKey: "gc_points")
        self.parentPinHash = defaults.string(forKey: "gc_parent_pin_hash")
    }
    
    public func savePairing(household: String, child: String, token: String, pinHash: String?) {
        self.isPaired = true
        self.householdName = household
        self.childName = child
        self.deviceToken = token
        self.parentPinHash = pinHash
        
        defaults.set(true, forKey: "gc_is_paired")
        defaults.set(household, forKey: "gc_household_name")
        defaults.set(child, forKey: "gc_child_name")
        defaults.set(token, forKey: "gc_device_token")
        if let pinHash = pinHash {
            defaults.set(pinHash, forKey: "gc_parent_pin_hash")
        }
    }
    
    public func setParentPin(_ pin: String) {
        let hash = GotChoresSession.hashPin(pin)
        self.parentPinHash = hash
        defaults.set(hash, forKey: "gc_parent_pin_hash")
    }
    
    public func checkParentPin(_ pin: String) -> Bool {
        guard let hash = parentPinHash else { return false }
        return hash == GotChoresSession.hashPin(pin)
    }
    
    public func updatePoints(_ newPoints: Int) {
        self.points = newPoints
        defaults.set(newPoints, forKey: "gc_points")
    }
    
    public func clear() {
        self.isPaired = false
        self.householdName = ""
        self.childName = ""
        self.deviceToken = ""
        self.points = 0
        self.parentPinHash = nil
        self.isParentUnlocked = false
        
        defaults.removeObject(forKey: "gc_is_paired")
        defaults.removeObject(forKey: "gc_household_name")
        defaults.removeObject(forKey: "gc_child_name")
        defaults.removeObject(forKey: "gc_device_token")
        defaults.removeObject(forKey: "gc_points")
        defaults.removeObject(forKey: "gc_parent_pin_hash")
    }
    
    public static func hashPin(_ pin: String) -> String {
        // Simple consistent SHA256 pin hashing matching Android Session.hashPasscode
        let data = Data(pin.utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &digest)
        }
        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
}
import CommonCrypto
