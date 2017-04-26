//
//  DevicesViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 05/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import PKHUD

class DevicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let devicesCellIdentifier = "DevicesCellIdentifier"
    var itemToUpdate : Device! = nil
    let realm = try! Realm()
    var devicesArray : [String] = [String]()
    weak var timer: Timer?
    var timerDispatchSourceTimer : DispatchSourceTimer?
//    var devices = [Device( alias: "Cucina", password: "admin", temperature: "23", hum: "30"), Device( alias: "Soggiorno", password: "admin", temperature: "22", hum: "10"), Device(alias: "Corridoio", password: "admin", temperature: "19", hum: "50")]
    var devices : Results<Device>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        devices = realm.objects(Device.self)
        devices.forEach({devicesArray.append($0.uid) })
        // Do any additional setup after loading the view.
        self.getDevicesMetadata()
        startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() 
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.getDevicesMetadata()
            }
            
        } else {
            // Fallback on earlier versions
            timerDispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timerDispatchSourceTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(60))
            timerDispatchSourceTimer?.setEventHandler{
                self.getDevicesMetadata()
                
            }
            timerDispatchSourceTimer?.resume()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        //timerDispatchSourceTimer?.suspend() // if you want to suspend timer
        timerDispatchSourceTimer?.cancel()
    }
    
    // if appropriate, make sure to stop your timer in `deinit`
    deinit {
        stopTimer()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: devicesCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        let device = devices[row]
        cell.textLabel?.text = devices[row].alias
        cell.detailTextLabel?.text  = device.temperature + "° " + device.humidity + "%"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        self.itemToUpdate = self.devices[indexPath.row]
        let edit = UITableViewRowAction(style: .normal, title: "Modifica") { action, index in
            let editMenu = UIAlertController(title: nil, message: "Seleziona cosa vuoi modificare", preferredStyle: .actionSheet)
            
            let aliasAction = UIAlertAction(title: "Alias", style: UIAlertActionStyle.default, handler: self.editAlias)
            let passwordAction = UIAlertAction(title: "Password", style: UIAlertActionStyle.default, handler: self.editPassword)
            let resetAction = UIAlertAction(title: "Reset Device", style: UIAlertActionStyle.default, handler: self.resetDevice)
            let cancelAction = UIAlertAction(title:"Annulla", style: UIAlertActionStyle.cancel, handler: nil)
            
            editMenu.addAction(aliasAction)
            editMenu.addAction(passwordAction)
            editMenu.addAction(resetAction)
            editMenu.addAction(cancelAction)
            
            
            self.present(editMenu, animated: true, completion: nil)
        }
        edit.backgroundColor = UIColor(colorLiteralRed: 32.0/255.0, green: 148.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        
        let delete = UITableViewRowAction(style: .destructive, title: "Rimuovi") { action, index in
        
            try! self.realm.write {
                let row = indexPath.row
                let item = self.devices[row]
                self.realm.delete(item)
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        
        }
        
        return [delete, edit]
    }
    
    
    
    
    //Private methods
    func editPassword(alert: UIAlertAction!){
        // 1.
        var oldPasswordTextField: UITextField?
        var newPasswordTextField: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "Modifica Password",
            message: "Inserisci la vecchia e la nuova password",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let changePasswordAction = UIAlertAction(
        title: "Modifica", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            var isOk = true
            
            if let oldPassword = oldPasswordTextField?.text {
                if(oldPassword.isEmpty) {
                    isOk = false
                    self.errorHighlightTextField(textField: oldPasswordTextField!)
                }
            }
            
            if let newPassword = newPasswordTextField?.text {
                if(newPassword.isEmpty) {
                    isOk = false
                    self.errorHighlightTextField(textField: newPasswordTextField!)
                }
            }
            
            if(isOk){
                self.sendRequest(password: (oldPasswordTextField?.text)!, newPassword: newPasswordTextField!.text!, alias: self.itemToUpdate.alias, newAlias: self.itemToUpdate.alias)
            }
            
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // 4.
        alertController.addTextField(configurationHandler: {
            (oldPassword) -> Void in
            oldPasswordTextField = oldPassword
            oldPasswordTextField!.placeholder = "Vecchia password"
            oldPassword.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })
        
        alertController.addTextField(configurationHandler: {
            (newPassword) -> Void in
            newPasswordTextField = newPassword
            //newPasswordTextField!.secureTextEntry = true
            newPasswordTextField!.placeholder = "Nuova password"
            newPassword.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })

    
        // 5.
        alertController.addAction(cancel)
        alertController.addAction(changePasswordAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Private methods
    func editAlias(alert: UIAlertAction!){
        // 1.
        var nuovoAlias: UITextField?
        var password: UITextField?
        
        // 2.
        let alertController = UIAlertController(
            title: "Modifica Alias",
            message: "Inserisci il nuovo alias da attribuire al condizionatore",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 3.
        let changePasswordAction = UIAlertAction(
        title: "Modifica", style: UIAlertActionStyle.default) {
            (action) -> Void in
            
            var isOk = true
            
            if let newAlias = nuovoAlias?.text {
                if( newAlias.isEmpty){
                    isOk = false
                    self.errorHighlightTextField(textField: nuovoAlias!)
                }
            }
        
            if let newPassword = password?.text {
                if(newPassword.isEmpty) {
                    isOk = false
                    self.errorHighlightTextField(textField: password!)
                }
            }
            
            if(isOk){
                self.sendRequest(password: (password?.text)!, newPassword: (password?.text)!, alias: self.itemToUpdate.alias, newAlias: (nuovoAlias?.text)!)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // 4.
        alertController.addTextField(configurationHandler: {
            (alias) -> Void in
            nuovoAlias = alias
            nuovoAlias!.placeholder = "Nuovo alias"
            alias.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })
        
        alertController.addTextField(configurationHandler: {
            (passwordIns) -> Void in
            password = passwordIns
            //newPasswordTextField!.secureTextEntry = true
            password!.placeholder = "password"
            passwordIns.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        })
        
        
        // 5.
        alertController.addAction(cancel)
        alertController.addAction(changePasswordAction)
        
        alertController.actions[1].isEnabled = false

        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textChanged(_ sender: Any) {
//        let tf = sender as! UITextField
//        var resp : UIResponder! = tf
//        while !(resp is UIAlertController) { resp = resp.next }
//        let alert = resp as! UIAlertController
//        
//        alert.actions[1].isEnabled = (tf.text != "")
        
        guard let alertController = self.presentedViewController as? UIAlertController,
            let username = alertController.textFields?.first?.text,
            let password = alertController.textFields?.last?.text,
            let submitAction = alertController.actions.last
            else
        {
            return
        }
        
        submitAction.isEnabled = username.characters.count > 0 &&
            password.characters.count > 0
    }
    
    //Private methods
    func resetDevice(alert: UIAlertAction!){
        _ = DomiWiiProvider.request(.resetDevice(alias: self.itemToUpdate.alias, password: self.itemToUpdate.password)) { result in
            switch result {
            case let .success(response):
                let json = JSON(data: response.data)
                let resp = json["response"].stringValue
                let code = json["code"].stringValue
                if(Int(code)! > 0 ){
                    self.showAlert("Perfetto", message: resp)
                    self.getDevicesMetadata()
                }
                else{
                    self.showAlert("Errore", message: "Dispositivo non resettato")
                }
                
                
                
            //
            case .failure(_):
            //                guard let error = error as? CustomStringConvertible else {
            //                    break
            //                }
            self.showAlert("Errore", message: "Comando non inviato")
            }
        }
    }
    
    
    func sendRequest(password: String, newPassword: String, alias: String, newAlias: String){
        _ = DomiWiiProvider.request(.updateDeviceProp(password: password, newPassword: newPassword, alias: alias, newAlias: newAlias)) { result in
            switch result {
            case let .success(response):
                let json = JSON(data: response.data)
                let resp = json["response"].stringValue
                let code = json["code"].stringValue
                if(Int(code)! > 0 ){
                    self.showAlert("Perfetto", message: "Comando inviato correttamente")
                    
                    try! self.realm.write {
                        self.itemToUpdate.alias = newAlias
                        self.itemToUpdate.password = newPassword
                    }
                    self.tableView.reloadData()
                }
                else{
                    self.showAlert("Errore", message: resp)
                }
                
                
            //self.tableView.reloadData()
            case .failure(_): break
            //                guard let error = error as? CustomStringConvertible else {
            //                    break
            //                }
            self.showAlert("Errore", message: "Comando non inviato")
            }
        }
    }
    
    func getDevicesMetadata(){
        // Show spinner
        //HUD.show(.progress)
        _ = DomiWiiProvider.request(.devicesMetadata(aliases: devicesArray)) { result in
            switch result {
            case let .success(response):
                do {
                    let item: ControlledDevices? = try response.mapObject(ControlledDevices.self)
                    if let item = item {
                        // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                        for device in item.controlledDevicesList
                        {
                            try! self.realm.write {
                                self.realm.create(Device.self, value: ["uid": device.uid, "alias": device.alias, "temperature": device.temperature, "humidity": device.humidity], update: true)
                                // the book's `title` property will remain unchanged.
                            }
                        }
                    }
                    // Hide spinner
                    //HUD.hide(afterDelay: 2.0)
                    self.tableView.reloadData()
                } catch {
                    
                    // Hide spinner
                    //HUD.hide(afterDelay: 2.0)
                    //self.showAlert("GitHub Fetch", message: "Unable to fetch from GitHub")
                }
            //self.tableView.reloadData()
            case let .failure(_): break
            //                guard let error = error as? CustomStringConvertible else {
            //                    break
            //                }
            //self.showAlert("GitHub Fetch", message: error.description)
            
            //HUD.hide(afterDelay: 2.0)
            }
        }
    }
    
    func errorHighlightTextField(textField: UITextField){
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
    
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
        let path = self.tableView.indexPathForSelectedRow!
        let irViewController = segue.destination as! IRControllerViewController
        irViewController.conditionerItem = devices[path.row]
    }
    

}
