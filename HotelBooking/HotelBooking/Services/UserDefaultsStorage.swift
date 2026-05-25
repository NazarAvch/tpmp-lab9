import Foundation

class UserDefaultsStorage: UserDefaultsProtocol {
    static let shared = UserDefaultsStorage()
    private let defaults = UserDefaults.standard
    private let userKey = "loggedInUser"
    
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            defaults.set(encoded, forKey: userKey)
        }
    }
    
    func loadUser() -> User? {
        guard let data = defaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else { return nil }
        return user
    }
    
    func clearUser() {
        defaults.removeObject(forKey: userKey)
    }
}