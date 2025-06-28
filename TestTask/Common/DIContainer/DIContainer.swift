protocol DIContainer {
    
    var services: DIServices.Services { get }
    
}

enum DIServices {
    
    final class Services {
        
        let usersService: UsersService
        let reachabilityService: ReachabilityService
        let validationService: ValidationService
        
        init(
            usersService: UsersService,
            reachabilityService: ReachabilityService,
            validationService: ValidationService
        ) {
            self.usersService = usersService
            self.reachabilityService = reachabilityService
            self.validationService = validationService
        }
    }
}
