import Foundation 
 
protocol UserDefaultsProtocol { 
    func saveUser(_ user: User) 
    func loadUser() -
    func clearUser() 
} 
