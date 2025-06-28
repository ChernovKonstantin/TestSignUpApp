import Combine
import Network

final class ReachabilityServiceImpl: ReachabilityService {

    var connectionStatusPublisher: Published<NWPath.Status>.Publisher { $status }
    var connectionStatus: NWPath.Status { status }

    @Published private var status: NWPath.Status = .satisfied
    private let monitorQueue = DispatchQueue.init(label: "monitor queue", qos: .userInitiated)
    private let monitor = NWPathMonitor()

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.status = path.status
            }
        }
        monitor.start(queue: monitorQueue)
    }
    
    func checkCurrentStatus() {
           let monitor = NWPathMonitor()
           monitor.pathUpdateHandler = { [weak self] path in
               DispatchQueue.main.async {
                   self?.status = path.status
                   monitor.cancel()
               }
           }
           monitor.start(queue: monitorQueue)
       }
}
