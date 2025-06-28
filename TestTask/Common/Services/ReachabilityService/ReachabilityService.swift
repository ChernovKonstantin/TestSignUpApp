import Combine
import Network

protocol ReachabilityService {
    
    var connectionStatusPublisher: Published<NWPath.Status>.Publisher { get }
    var connectionStatus: NWPath.Status { get }
    func checkCurrentStatus()
}
