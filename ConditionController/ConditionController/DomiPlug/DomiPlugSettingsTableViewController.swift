import UIKit
import SwiftyJSON
import PKHUD

class LumiPlugSettingsTableViewController: UITableViewController {

    var device: Device!
    
    
    
    @IBOutlet weak var orarioLabel: UILabel!

    var timer : Timer?
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.getTimeOfDate), userInfo: nil, repeats: true)
        
        addButton.isEnabled = true

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        getTimeOfDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func getTimeOfDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE HH:mm"
        self.orarioLabel.text = dateFormatter.string(from: Date())
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func applicaButtonTapped(_ sender: Any) {
        let calendar = Calendar.current
        let hourOfDay = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        var dayOfWeek = calendar.component(.weekday, from: Date()) - calendar.firstWeekday
        if dayOfWeek < 0 {
            dayOfWeek += 7
        }
        HUD.show(.labeledProgress(title: nil, subtitle: "Invio comando in corso"))
        _ = LumiProvider.request(.sendDeviceAction(alias: device.alias, password: device.password, uuid: device.uid, command: 8, day: dayOfWeek, hour: hourOfDay, minutes: minutes, cap: nil, setPointBenessere: nil, setPointEco: nil, mode: nil, minTemperature: nil, maxTemperatura: nil, notificationPeriod: 2, enableMobileNotification: nil, enableBotNotification: nil, temperature: nil, timeOn: nil, planning: nil)) {
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
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 5
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
