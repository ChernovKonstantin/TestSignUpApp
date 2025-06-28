final class DIContainerImpl: DIContainer {
    
    let services: DIServices.Services
    
    init(
        services: DIServices.Services
    ) {
        self.services = services
    }
}
