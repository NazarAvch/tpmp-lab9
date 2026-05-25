import Foundation

protocol UserDefaultsProtocol {
    func saveUser(_ user: User)
    func loadUser() -> User?
    func clearUser()
}
