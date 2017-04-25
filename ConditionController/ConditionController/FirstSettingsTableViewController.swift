//
//  FirstSettingsTableViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 27/12/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit
import PKHUD


class FirstSettingsTableViewController: UIViewController {

    var devicesList = [ConditionerDevice]()
    var receivedDeviceModelData : Bool = false
    @IBOutlet weak var setWifiButton: UIButton!
    @IBOutlet weak var setConditionerButton: UIButton!
    @IBOutlet weak var updateConditionerButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var heightLogoConstraint: NSLayoutConstraint!
    let gradientLayer = CAGradientLayer()
    @IBOutlet weak var widthLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightButtonBoxConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var weightButtonBoxConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        
        let logo = UIImage(named: "domiwii")
        let imageView = UIImageView(image: logo)
        
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 110,height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        self.navigationItem.titleView = titleView
        
        
        
        self.view.backgroundColor = UIColor.white
        
        // 2
        gradientLayer.frame = self.view.bounds
        
        // 3
        let color1 = UIColor.gray.cgColor as CGColor
        let color2 = UIColor.white.cgColor as CGColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.0,y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,y: 0.5)
        
        // 4
        gradientLayer.locations = [0.0, 1.0]
        
        // 5
        self.view.layer.insertSublayer(gradientLayer, at: 0)

        self.getConditionerList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = UIScreen.main.bounds.size
        
        
        if size.width == 320{
            
            heightButtonBoxConstraint.constant = 150
            
            weightButtonBoxConstraint.constant = 200
            heightLogoConstraint.constant = 200
            
            widthLogoConstraint.constant = 230
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private methods
    func getConditionerList(){
        // Show spinner
        HUD.show(.progress)
        _ = DomiWiiProvider.request(.conditionerList()) { result in
            switch result {
            case let .success(response):
                do {
                    let item: ConditionerDeviceList? = try response.mapObject(ConditionerDeviceList.self)
                    if let item = item {
                        // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                        self.devicesList = item.conditionerDeviceList
                        self.receivedDeviceModelData = true
                        if(self.devicesList.count > 0){
//                            let idx_path = IndexPath(row: 2, section: 0)
//                            let cell = self.tableView.cellForRow(at: idx_path)
//                            cell?.selectionStyle = UITableViewCellSelectionStyle.none
//                            cell?.textLabel?.textColor = UIColor.gray
                            self.updateConditionerButton.isEnabled = false
                            
                        }
                        //else{
//                            let idx_path1 = IndexPath(row: 0, section: 0)
//                            let cell1 = self.tableView.cellForRow(at: idx_path1)
//                            cell1?.selectionStyle = UITableViewCellSelectionStyle.none
//                            cell1?.textLabel?.textColor = UIColor.gray
//                            let idx_path2 = IndexPath(row: 1, section: 0)
//                            let cell2 = self.tableView.cellForRow(at: idx_path2)
//                            cell2?.selectionStyle = UITableViewCellSelectionStyle.none
//                            cell2?.textLabel?.textColor = UIColor.gray
//                            let idx_path4 = IndexPath(row: 3, section: 0)
//                            let cell4 = self.tableView.cellForRow(at: idx_path4)
//                            cell4?.selectionStyle = UITableViewCellSelectionStyle.none
//                            cell4?.textLabel?.textColor = UIColor.gray

  //                      }
                    } else {
                        //self.showAlert("GitHub Fetch", message: "Unable to fetch from GitHub")
                    }
                    // Hide spinner
                    HUD.hide(afterDelay: 2.0)
                    
                } catch {
                    self.receivedDeviceModelData = false
                    // Hide spinner
                    HUD.hide(afterDelay: 2.0)
                    //self.showAlert("GitHub Fetch", message: "Unable to fetch from GitHub")
                }
            //self.tableView.reloadData()
            case let .failure(error):
            //                guard let error = error as? CustomStringConvertible else {
            //                    break
            //                }
            self.showAlert("DomiWii", message: error.errorDescription!)
            self.receivedDeviceModelData = false
                HUD.hide(afterDelay: 2.0)
            }
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        _ = DomiWiiDeviceProvider.request(.endControlMode()) { result in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)

            case .failure(_):
                self.showAlert("Errore", message: "Comando non inviato correttamente, controllare connessione con dispositivo")
                return
                
            }
        }
     
    }
    

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        self.getConditionerList()
    }
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(indexPath.row == 0){
//            self.performSegue(withIdentifier: "impostaWifiIdentifier", sender: self)
//        }
//        else if(indexPath.row == 1){
//            self.performSegue(withIdentifier: "impostaCondizionatoreIdentifier", sender: self)
//        }
//    }

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
        if(segue.identifier == "impostaWifiIdentifier"){
            (segue.destination as! FirstActivationTableViewController).parentFirstSettingsController = self
        }
        else if(segue.identifier == "impostaCondizionatoreIdentifier"){
            (segue.destination as! DeviceActivationTableViewController).conditionerDeviceList = self.devicesList
        }
    }
    

}
