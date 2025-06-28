final class MockDIContainer: DIContainer {
    
    let services: DIServices.Services
    
    init() {
        let apiService = APIServiceImpl()
        let userService = UsersServiceImpl(apiService: apiService)
        let reachabilityService = ReachabilityServiceImpl()
        let validationService = ValidationServiceImpl()
        
        services = DIServices.Services(
            usersService: userService,
            reachabilityService: reachabilityService,
            validationService: validationService
        )
    }
}

extension DIContainer where Self == MockDIContainer {
    
    static var preview: DIContainer {
        return MockDIContainer()
    }
}
