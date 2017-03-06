//
//  FirstActivationTableViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 06/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit
import Moya_ObjectMapper



class FirstActivationTableViewController: UITableViewController {


    @IBOutlet weak var ssdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var swich: UISwitch!
    @IBOutlet weak var ipStaticoTextField: UITextField!
    @IBOutlet weak var maskTextField: UITextField!
    @IBOutlet weak var ipRouterTextField: UITextField!
    @IBOutlet weak var dnsPrimarioTextField: UITextField!
    var devicesList = [ConditionerDevice]()
    var receivedDeviceModelData : Bool = false
    var parentFirstSettingsController : FirstSettingsTableViewController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.isEnabled = false
//        ssdTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)) , for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)), for: .editingChanged)
        ipStaticoTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)), for: .editingChanged)
        maskTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)), for: .editingChanged)
        ipRouterTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)), for: .editingChanged)
        dnsPrimarioTextField.addTarget(self, action: #selector(FirstActivationTableViewController.checkFields(sender:)), for: .editingChanged)
        self.ssdTextField.text = Util.getSSID()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkFields(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
        if(self.swich.isOn){
            if ((ipStaticoTextField.text?.isEmpty)! || (maskTextField.text?.isEmpty)! || (ipRouterTextField.text?.isEmpty)! || (dnsPrimarioTextField.text?.isEmpty)!){
                doneButton.isEnabled = false
                return
            }
        }else if ((ssdTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! ) {
            doneButton.isEnabled = false
            return
        }
        
        
        // enable your button if all conditions are met
        doneButton.isEnabled = true
    }

    @IBAction func toggleswitchValueChange(_ sender: UISwitch) {
        if(swich.isOn){
            self.doneButton.isEnabled = false
        }
        tableView.reloadData()
    }


//    // MARK: - Table view data source
//
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
//        
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row != 0 && self.swich.isOn == false {
            return 0.0
        }
        
        return 44.0
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let guideViewController = segue.destination as! GuideNetworkViewController
        guideViewController.deviceList = self.devicesList
        guideViewController.homeNetworkSSID = self.ssdTextField.text!
        guideViewController.homeNetworkPassword = self.passwordTextField.text!
        guideViewController.isFromFirstActivation = true
        if(swich.isOn){
            guideViewController.ipStatico = self.ipStaticoTextField.text!
            guideViewController.mask = self.maskTextField.text!
            guideViewController.ipRouter = self.ipRouterTextField.text!
            guideViewController.dnsPrimario = self.dnsPrimarioTextField.text!
        }
        
    }
    
    
    

}
