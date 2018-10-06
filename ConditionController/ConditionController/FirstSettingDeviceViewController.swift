//
//  FirstSettingDeviceViewController.swift
//  
//
//  Created by Vincenzo Olivito on 27/08/2018.
//

import UIKit

class FirstSettingDeviceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func completeConfigurationTapped(_ sender: Any) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "impostaWifiIdentifier"){
            //(segue.destination as! FirstActivationTableViewController).parentFirstSettingsController = self
        }
    }

}
