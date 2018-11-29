import UIKit
import SwiftyJSON
import RealmSwift


class AddDeviceTableViewController: UITableViewController {

    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.isEnabled = false
        //        ssdTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)) , for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)), for: .editingChanged)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFields(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        if ((aliasTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! ){
            addButton.isEnabled = false
            return
        }
        
        
        // enable your button if all conditions are met
        addButton.isEnabled = true
    }

    @IBAction func addButtonTapped(_ sender: AnyObject) {
        _ = LumiProvider.request(.checkDevice(alias: self.aliasTextField.text!, password: self.passwordTextField.text!)) { result in
            switch result {
            case let .success(response):
                do{
                    let json = try JSON(data: response.data)
                    let resp = json["response"].boolValue
                    if(resp ){
                        let device: Device = try response.mapObject(Device.self)
                        device.alias = self.aliasTextField.text!
                        device.password = self.passwordTextField.text!
                        device.uid = self.aliasTextField.text!
                        
                        try! self.realm.write {
                            self.realm.add(device, update: true)
                        }
                        
                        var devNot = NotificationModel()
                        devNot.uiid = device.uid
                        devNot.password = device.password
                        devNot.registrationId = (UIApplication.shared.delegate as! AppDelegate).token
                        
                        let controlledNotificationDevice = ControlledNotificationDevices(device: devNot)
                        
                        _ = LumiProvider.request(.subscribeDevicesNotification(devices: controlledNotificationDevice)) { result in
                            switch result {
                            case let .success(response):
                                do{
                                    let json = try JSON(data: response.data)
                                    let resp = json["code"].stringValue
                                    if(resp == "1" ){
                                        self.showAlert("Add Device", message: "Dispositivo aggiunto correttamente")
                                        
                                    }
                                    else{
                                        self.showAlert("Errore", message: "Dispositivo non aggiunto")
                                    }
                                } catch {}
                                
                                
                            //self.tableView.reloadData()
                            case let .failure(_):
                                //                guard let error = error as? CustomStringConvertible else {
                                //                    break
                                //                }
                                self.showAlert("Errore", message: "Dispositivo non aggiunto")
                            }
                        }
                        
                    }
                    else{
                        self.showAlert("Errore", message: "Dispositivo non aggiunto")
                    }
                } catch {}
                
                
            //self.tableView.reloadData()
            case let .failure(_):
                //                guard let error = error as? CustomStringConvertible else {
                //                    break
                //                }
                self.showAlert("Errore", message: "Dispositivo non aggiunto")
            }
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
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
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in 
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
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
