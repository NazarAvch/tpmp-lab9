import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isRegistering = false

    var body: some View {
        VStack {
            Text(isRegistering ? "Регистрация" : "Вход")
                .font(.largeTitle)
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            SecureField("Пароль", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if isRegistering {
                TextField("Имя", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(isRegistering ? "Зарегистрироваться" : "Войти") {
                if isRegistering {
                    let user = User(email: email, password: password, name: name)
                    UserDefaultsStorage.shared.saveUser(user)
                    isLoggedIn = true
                } else {
                    if let user = UserDefaultsStorage.shared.loadUser(), user.email == email && user.password == password {
                        isLoggedIn = true
                    }
                }
            }
            .padding()
            Button(isRegistering ? "Уже есть аккаунт? Войти" : "Нет аккаунта? Регистрация") {
                isRegistering.toggle()
            }
        }
        .padding()
    }
}

