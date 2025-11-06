import SwiftUI

struct RootView: View {
    // TODO: Cette partie sera vue en classe pour l'expliquer comme il faut
    @State private var isAuthenticated = false
    
    var body: some View {
        if (isAuthenticated) {
            HomeView()
        } else {
            LoginView(isAuthentificated: $isAuthenticated)
        }
    }
}

#Preview {
    RootView()
}
