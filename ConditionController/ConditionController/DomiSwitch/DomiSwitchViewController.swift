import UIKit
import PKHUD
import SwiftyJSON


class LumiSwitchViewController: UIViewController {

    var touch: Device!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        HUD.show(.labeledProgress(title: nil, subtitle: "Invio comando in corso"))
        _ = LumiProvider.request(.sendDeviceAction(alias: self.touch.alias, password: self.touch.password, uuid: self.touch.uid, command: 9, day: nil, hour: nil, minutes: nil, cap: nil, setPointBenessere: nil, setPointEco: nil, mode: nil, minTemperature: nil, maxTemperatura: nil, notificationPeriod: nil, enableMobileNotification: nil, enableBotNotification: nil, temperature: nil, timeOn: nil, planning: nil)) {
            
            result in
            switch result {
            case let .success(response):
                do{
                    let json = try JSON(data: response.data)
                    let resp = json["response"].boolValue
                    if(resp ){
                        HUD.flash(.labeledSuccess(title: nil, subtitle: "Comando Inviato"), delay: 2.0)
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
                HUD.hide()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
