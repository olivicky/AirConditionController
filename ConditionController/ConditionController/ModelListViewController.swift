//
//  ModelListViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 16/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit

protocol ModelListViewControllerDelegate
{
    func modelListSelectedItem(viewController: ModelListViewController, didFinishSelectedItem item: ConditionerDevice?)
}

class ModelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var progressView = UIView()
    var delegate: ModelListViewControllerDelegate!
    var selectedConditionerModel : ConditionerDevice!
    var selectedConditionerIndex : Int = -1
    let devicesCellIdentifier = "ConditionerDeviceCellIdentifier"
    var devicesList = [ConditionerDevice]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(ModelListViewController.registerModel))
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func registerModel(){
        //TO-DO prendere il codice del condizionatore e passarlo alla funzione di registrazione self.selectedConditionerModel.code
        self.delegate.modelListSelectedItem(viewController: self, didFinishSelectedItem: self.selectedConditionerModel)
        self.navigationController?.popViewController(animated: true)
        
//            _ = DomiWiiDeviceProvider.request(.saveDevice()) { result in
//                switch result {
//                case let .success(response): break
//                    self.delegate.modelListSelectedItem(viewController: self, didFinishSelectedItem: self.selectedConditionerModel)
//                    
//                    
//                //self.tableView.reloadData()
//                case let .failure(_):
//                    //                guard let error = error as? CustomStringConvertible else {
//                    //                    break
//                    //                }
//                    self.showAlert("Errore", message: "Controllare connessione con dispositivo")
//                    
//                }
//            }
        
        
    }
    
    
    
    //UITableViewDelegate UiTableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: devicesCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        if(row == selectedConditionerIndex){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        cell.textLabel?.text = devicesList[row].model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let item = self.devicesList[indexPath.row]
        self.selectedConditionerModel = item
        
        if(indexPath.row != selectedConditionerIndex){
            tableView.beginUpdates()
            self.selectedConditionerIndex = indexPath.row
            self.tableView.reloadData()
            tableView.endUpdates()
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
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
