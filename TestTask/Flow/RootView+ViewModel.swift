import SwiftUI
import Network
import Combine

extension RootView {
    
    final class RootViewModel: ObservableObject {
        
        @Published var instnetStatus: NWPath.Status?
        
        private let diContainer: DIContainer
        private var cancellables = Set<AnyCancellable>()
        
        init(
            diContainer: DIContainer
        ) {
            self.diContainer = diContainer
            setupBinding()
        }

        private func setupBinding() {
            diContainer.services.reachabilityService
                .connectionStatusPublisher
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.instnetStatus = self.diContainer.services.reachabilityService.connectionStatus
                }
                .store(in: &cancellables)
        }
        
        func checkInternetStatus() {
            diContainer.services.reachabilityService.checkCurrentStatus()
        }
        
        func createUsersView() -> some View {
            UsersView(viewModel: UsersView.UsersViewModel(diContainer: diContainer))
        }
        
        func createSignUpView() -> some View {
            SignUpView(viewModel: SignUpView.SignUpViewModel(diContainer: diContainer))
        }
    }
}
