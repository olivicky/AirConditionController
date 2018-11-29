import UIKit
import PKHUD

protocol GuideNetworkViewControllerDelegate
{
    func startDeviceControlCompleted(isCompletedCorrect isCorrect: Bool)
}


class GuideNetworkViewController: UIViewController {
    
    let LumiSSID = "Domi"
    var homeNetworkSSID : String! = nil
    var homeNetworkPassword : String! = nil
    var ipStatico : String?
    var mask : String?
    var ipRouter : String?
    var dnsPrimario : String?
    var deviceList = [ConditionerDevice]()
    var isFromFirstActivation = false
    var delegate: DeviceActivationTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(GuideNetworkViewController.checkLumiNetworkConnection), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLumiNetworkConnection(){
        if(Util.getSSID() != nil){
            
            if(Util.getSSID()?.hasPrefix(LumiSSID))!{
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DeviceActivationTableViewController") as? DeviceActivationTableViewController
//            {
//                vc.conditionerDeviceList = self.deviceList
//                vc.homeNetworkPassword = self.homeNetworkPassword
//                vc.homeNetworkSSID = self.homeNetworkSSID
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        
            self.startDeviceControl()
            }
       }
    }
    
    func startDeviceControl(){
        // Show spinner
        HUD.show(.progress)
        
        _ = LumiDeviceProvider.request(.startControlMode()) { result in
            switch result {
            case let .success(response):
                if(self.isFromFirstActivation){
                    self.registerDevice(ssidHomeNetwork: self.homeNetworkSSID, password: self.homeNetworkPassword, ipStatico: self.ipStatico, mask: self.mask, ipRouter: self.ipRouter, dnsPrimario: self.dnsPrimario)
                }
                else{
                    if(self.delegate != nil){
                        self.delegate?.startDeviceControlCompleted(isCompletedCorrect: true)
                    }
                    // Hide spinner
                    HUD.hide(afterDelay: 2.0)
                    self.navigationController?.popViewController(animated: true)
                }
                
            //self.tableView.reloadData()
            case let .failure(_):
                //                guard let error = error as? CustomStringConvertible else {
                //                    break
                //                }
                // Hide spinner
                HUD.hide(afterDelay: 2.0)
                self.showAlert("Errore", message: "Controllare connessione con dispositivo")
                
                
                
            }
        }
    }
    
    func registerDevice(ssidHomeNetwork: String, password: String, ipStatico: String?, mask: String?, ipRouter : String?, dnsPrimario : String?){
        _ = LumiDeviceProvider.request(.activateDevice(ssidHomeNetwork: ssidHomeNetwork, password: password, ipStatico: (ipStatico != nil ? ipStatico! : "0"), mask: (mask != nil ? mask!: "0"), ipRouter: (ipRouter != nil ? ipRouter! : "0"), dnsPrimario: (dnsPrimario != nil ? dnsPrimario!: "0"))) { result in
            switch result {
            case .success(_):
                // Hide spinner
                HUD.hide(afterDelay: 2.0)
                let alertController = UIAlertController(title: "Success", message: "Complimenti hai registrato correttamente la Wi-Fi", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true) })
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                
            //self.tableView.reloadData()
            case .failure(_):
                //                guard let error = error as? CustomStringConvertible else {
                //                    break
                //                }
                // Hide spinner
                HUD.hide(afterDelay: 2.0)
                self.showAlert("Errore", message: "Controllare connessione con dispositivo")
                
            }
        }
    }
    
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
