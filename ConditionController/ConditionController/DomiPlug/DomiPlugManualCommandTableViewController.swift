import UIKit
import SwiftyJSON
import PKHUD

class LumiPlugManualCommandTableViewController: UITableViewController {

    var device: Device!
    
    @IBOutlet weak var timerOnLabel: UILabel!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func applicaButtonTapped(_ sender: Any) {
        HUD.show(.labeledProgress(title: nil, subtitle: "Invio comando in corso"))
        _ = LumiProvider.request(.sendDeviceAction(alias: device.alias, password: device.password, uuid: device.uid, command: 10, day: nil, hour: nil, minutes: nil, cap: nil, setPointBenessere: nil, setPointEco: nil, mode: nil, minTemperature: nil, maxTemperatura: nil, notificationPeriod: nil, enableMobileNotification: nil, enableBotNotification: nil, temperature: nil, timeOn: Int(self.timerOnLabel.text!)!, planning: nil)) {
            result in
            switch result {
            case let .success(response):
                do{
                    let json = try JSON(data: response.data)
                    let resp = json["response"].boolValue
                    if(resp ){
                        HUD.flash(.labeledSuccess(title: nil, subtitle: "Comando Inviato"), delay: 2.0)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        HUD.hide()
                        self.showAlert("Errore", message: "Impostazioni non effettuate")
                    }
                } catch {}
                
                
            //self.tableView.reloadData()
            case let .failure(_):
                //                guard let error = error as? CustomStringConvertible else {
                //                    break
                //                }
                self.showAlert("Errore", message: "Impostazioni non effettuate")
            }
        }
    }
    
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func timerOnValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        
        timerOnLabel.text = "\(currentValue)"
    }


}
