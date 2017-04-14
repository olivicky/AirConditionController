//
//  DeviceActivationTableViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 22/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit
import SwiftyJSON
import PKHUD



class DeviceActivationTableViewController: UITableViewController, ModelListViewControllerDelegate, GuideNetworkViewControllerDelegate {

    @IBOutlet weak var modelLabel: UILabel!
    let DomiWiiSSID = "DomiWii_"
    var conditionerListIsEmpty : Bool = true
    var homeNetworkSSID : String! = nil
    var homeNetworkPassword : String! = nil
    var conditionerDeviceList = [ConditionerDevice]()
    var selectedConditionerItem : ConditionerDevice!
    var delayTime = 1.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(DeviceActivationTableViewController.register))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.startDeviceControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func register(){
        self.registerDevice(counter: 0)
        HUD.show(.progress)
    }
    
    func registerDevice(counter: Int){
        
        if(counter < 8){
            var count = counter
            let codes = self.selectedConditionerItem.codes[counter]
            let paramsJSON = JSON(codes.codes)
            var paramsString = paramsJSON.debugDescription
            paramsString = paramsString.replacingOccurrences(of: "\n", with: "")
            paramsString = paramsString.replacingOccurrences(of: " ", with: "")
            paramsString = paramsString.replacingOccurrences(of: "[", with: "")
            paramsString = paramsString.replacingOccurrences(of: "]", with: "")
          //  paramsString = paramsString + "?"
        
        _ = DomiWiiDeviceProvider.request(.registerDevice(count: String(counter), codes: paramsString)) { result in
            switch result {
            case .success(_):
               let when = DispatchTime.now() + self.delayTime // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    count += 1
                    self.registerDevice(counter: count)
                }
            case .failure(_):
                self.showAlert("Errore", message: "Dispositivo non registrato, controllare connessione con dispositivo")
                HUD.hide(afterDelay: 2.0)
                return
                
            }
        }
        }
        else{
            HUD.hide(afterDelay: 2.0)
            return
        }
    }
    
    func startDeviceControl(){
        if(Util.getSSID() != nil){
            
            if(Util.getSSID()?.hasPrefix(DomiWiiSSID))!{
        
        
        // Show spinner
        HUD.show(.progress)
        _ = DomiWiiDeviceProvider.request(.startControlMode()) { result in
            switch result {
            case .success(_):
                // Hide spinner
                HUD.hide(afterDelay: 2.0)
                self.startDeviceControlCompleted(isCompletedCorrect: true)
            case .failure(_):
                // Hide spinner
                HUD.hide(afterDelay: 2.0)
                self.showAlert("Errore", message: "Controllare connessione con dispositivo")
                
            }
        }
            }else{
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuideNetworkViewController") as? GuideNetworkViewController
                {
                    vc.delegate = self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "GuideNetworkViewController") as? GuideNetworkViewController
            {
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    //ModelListViewControllerDelegate
    func modelListSelectedItem(viewController: ModelListViewController, didFinishSelectedItem item: ConditionerDevice?){
        self.conditionerListIsEmpty = false
        self.modelLabel.text = item?.model
        let indexPath = IndexPath(row: 0, section: 2)
        var cell = self.tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.default
        cell?.textLabel?.textColor = UIColor.black
        cell?.isUserInteractionEnabled = true
        self.tableView.reloadRows(at: [indexPath], with: .none)
        let indexPathToDisable = IndexPath(row: 0, section:1)
        cell = self.tableView.cellForRow(at: indexPathToDisable)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.textLabel?.textColor = UIColor.gray
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.selectedConditionerItem = item
    }
    		
    //GuideNetworkViewControllerDelegate
    func startDeviceControlCompleted(isCompletedCorrect isCorrect: Bool){
        var indexPathToEnable = IndexPath(row: 0, section:0)
        var cell = self.tableView.cellForRow(at: indexPathToEnable)
        cell?.selectionStyle = UITableViewCellSelectionStyle.gray
        cell?.textLabel?.textColor = UIColor.black
        cell?.isUserInteractionEnabled = true
        
        indexPathToEnable = IndexPath(row: 0, section:1)
        cell = self.tableView.cellForRow(at: indexPathToEnable)
        cell?.selectionStyle = UITableViewCellSelectionStyle.gray
        cell?.textLabel?.textColor = UIColor.black
        cell?.isUserInteractionEnabled = true
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
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        if( (indexPath.section == 0) && (indexPath.row == 0)){
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModelListViewController") as? ModelListViewController
//            {
//                vc.delegate = self
//                vc.devicesList = self.conditionerDeviceList
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
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
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ModelLisViewControllerIdentifier"
        {
            let vc = segue.destination as! ModelListViewController
            vc.delegate = self
            vc.devicesList = self.conditionerDeviceList
        }
    }
    

}
