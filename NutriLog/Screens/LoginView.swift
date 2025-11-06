import SwiftUI
import LocalAuthentication
import Foundation

struct LoginView: View {
    
    @Binding var isAuthentificated: Bool
    
    var body: some View {
        if (isAuthentificated) {
            HomeView()
        } else {
            VStack {
                Spacer()
                Image("AppLogo")
                    .resizable()
                    .frame(width: 300, height: 300)
                Button(action: signIn) {
                    Label("Se connecter", systemImage: "faceid")
                }.buttonStyle(.borderedProminent).buttonBorderShape(.roundedRectangle).foregroundStyle(Color("loginBg"))
                Spacer()
            }.frame(maxWidth: .infinity).background(Color("loginBg"))
        }
        
    }
    
    func signIn() {
        let context = LAContext()
        var error: NSError?
        
        if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)) {
            let reason = "We need to unlock data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if let error {
                    print (error)
                    return
                }
                if (success) {
                    print("Authenticated.")
                    isAuthentificated = success
                }
            }
        }
        
    }

}

#Preview {
    LoginView(isAuthentificated: .init(get: { false }, set: { _ in }))
}



