
import Foundation
import SystemConfiguration.CaptiveNetwork
import Contacts
#if !RX_NO_MODULE
import RxSwift
#endif

protocol ShareViewModelType {
    var SSID: Observable<String>! { get }
}

class ShareViewModel: NSObject {

    override init() {
        super.init()
    }
    
    var SSID: Observable<String>! {
        return Observable.create { observer in
            DispatchQueue.global(qos: .userInitiated).async {
                if let ifs = CNCopySupportedInterfaces() {
                    for i in 0..<CFArrayGetCount(ifs) {
                        let name = CFArrayGetValueAtIndex(ifs, i)
                        let rec = unsafeBitCast(name, to: AnyObject.self)
                        let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                        if unsafeInterfaceData != nil {
                            let data = unsafeInterfaceData! as! Dictionary<String, AnyObject>
                            observer.onNext(data["SSID"] as! String)
                            observer.onCompleted()
                        }
                    }
                }
            }
            
            return Disposables.create {
                print("Disposed")
            }
        }
    }
    
    private func ownerName() -> String? {
        let name = UIDevice.current.name.lowercased()
        let device = UIDevice.current.model.lowercased()
        
        if name.contains(device) {
            return name.replacingOccurrences(of: device, with: "").replacingOccurrences(of: "'", with: "").trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        return nil
    }
}
