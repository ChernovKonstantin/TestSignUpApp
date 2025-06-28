import SwiftUI

@main
struct TestTask: App {
    
    private let diContainer: DIContainer

    private var rootViewModel: RootView.RootViewModel {
        return RootView.RootViewModel(
            diContainer: diContainer
        )
    }
    
    init() {
        let apiService = APIServiceImpl()
        let userService = UsersServiceImpl(apiService: apiService)
        let reachabilityService = ReachabilityServiceImpl()
        let validationService = ValidationServiceImpl()
        
        let services = DIServices.Services(
            usersService: userService,
            reachabilityService: reachabilityService,
            validationService: validationService
        )
        
        diContainer = DIContainerImpl(
            services: services
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: rootViewModel)
        }
    }
}
