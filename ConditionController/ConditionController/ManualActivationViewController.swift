//
//  ManualActivationViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 26/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit
import PKHUD

//protocol ManualActivationViewControllerDelegate
//{
//    func manualActivationProcessCompleted(viewController: ManualActivationViewController, isManualActivationEnded isEnded: Bool)
//}

class ManualActivationViewController: UITableViewController {

    
    //var delegate: ManualActivationViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        // Do any additional setup after loading the view.
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ManualActivationViewController.activationComplete))
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func activationComplete(){
//       self.delegate.manualActivationProcessCompleted(viewController: self, isManualActivationEnded: true)
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.alertController(indexPath: indexPath)

    }
    
//    func checkSelected(){
//        let selectedRows = self.tableView
////        if(selectedRows? == 7){
////            self.navigationItem.rightBarButtonItem?.isEnabled = true
////        }
//    }
    
    
    //Private methods
    func alertController(indexPath: IndexPath){
        
        var tit = ""
        var msg = ""
        
        switch indexPath.row {
        case 0:
            tit = "Verifica OFF"
            msg = "Avvicina il telecomando al dispositivo e premi il pulsante OFF"
        case 1:
            tit = "Verifica acceso estate"
            msg = "imposta il telecomando in modalità ACCESO, Estate, Temperatura 18°, Velocità 1"
        case 2:
            tit = "Verifica acceso estate max"
            msg = "imposta il telecomando in modalità ACCESO, Estate, Temperatura 18°, Velocità 4"
        case 3:
            tit = "Verifica acceso inverno"
            msg = "imposta il telecomando in modalità ACCESO, Inverno, Temperatura 28°, Velocità 1"
        case 4:
            tit = "Verifica acceso inverno max"
            msg = "imposta il telecomando in modalità ACCESO, Inverno, Temperatura 28°, Velocità 1"
        case 5:
            tit = "Verifica acceso ventilatore"
            msg = "imposta il telecomando in modalità ACCESO, Ventilatore, Velocità 1"
        case 6:
            tit = "Verifica acceso ventilatore max"
            msg = "imposta il telecomando in modalità ACCESO, Ventilatore, Velocità 4"
        case 7:
            tit = "Verifica acceso deumidificatore"
            msg = "imposta il telecomando in modalità ACCESO, Deumidificatore, Temperatura 18°, Velocità 1"
        case 8:
            tit = "Verifica acceso deumidificatore max"
            msg = "imposta il telecomando in modalità ACCESO, Deumidificatore, Temperatura 18°, Velocità 4"
        default:
            tit = "Verifica manuale"
            msg = "Vuoi procedere alla verifica manuale?"
        }
        
        
        // 1.
        let alertController = UIAlertController(
            title: tit,
            message: msg,
            preferredStyle: UIAlertControllerStyle.alert)
        
        // 2.
        let startAction = UIAlertAction(
        title: "OK", style: UIAlertActionStyle.default) {
            (action) -> Void in

                self.sendRequest(indexPath: indexPath)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // 3.
        alertController.addAction(cancel)
        alertController.addAction(startAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func sendRequest(indexPath: IndexPath){
        var code : Int!
        
        switch indexPath.row {
        case 0:
            code = 0
        case 1:
            code = 2
        case 2:
            code = 1
        case 3:
            code = 4
        case 4:
            code = 3
        case 5:
            code = 7
        case 6:
            code = 8
        case 7:
            code = 5
        case 8:
            code = 6
        default:
            code = 0
        }
        
        
        // Show spinner
        HUD.show(.progress)
        _ = DomiWiiDeviceProvider.request(.manualActivationCommand(commandCode: String(code))) { result in
            switch result {
            case .success(_):
                    //self.tableView.deselectRow(at: indexPath, animated: true)
                    let cell = self.tableView.cellForRow(at: indexPath)
                    cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    //self.checkSelected()
                    // Hide spinner
                    HUD.hide(afterDelay: 2.0)
            case .failure(_):
                self.showAlert("Errore", message: "Comando non inviato correttamente, controllare connessione con dispositivo")
                // Hide spinner
                HUD.hide(afterDelay: 2.0)
                
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
