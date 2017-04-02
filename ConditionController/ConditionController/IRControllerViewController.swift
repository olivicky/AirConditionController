//
//  IRControllerViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 08/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit
import SwiftyJSON

class IRControllerViewController: UIViewController {
    
    var modalities = [ "summer", "winter", "humidity", "fan", "auto"];
    var fanLevel = ["fan_level_1", "fan_level_2", "fan_level_3", "fan_level_4"];
    
    @IBOutlet weak var conditionerTitle: UINavigationItem!
    @IBOutlet weak var fanLevelImageView: UIImageView!
    @IBOutlet weak var onOffButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var fanButton: UIButton!
    @IBOutlet weak var temperatureLabel: UILabel!
    var conditionerItem: Device!
    var isStateOn = false;
    var temperature = 21 {
        didSet {
            self.updateButton()
        }
    }
    var confort = 3 {
        didSet {
            self.updateButton()
        }
    }
    var modeState = 1
    {
        didSet {
            self.updateConfort()
        }
    }
    var fanState = 1
    var setConfort : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        temperatureLabel.text = String(temperature) + "°";
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.conditionerTitle.title = self.conditionerItem.alias
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onOffButtonTapped(_ sender: AnyObject) {
        if(isStateOn){
            self.onOffButton.setImage(UIImage(named: "off"), for: UIControlState.normal)
            self.fanButton.isEnabled = false;
            self.upButton.isEnabled = false;
            self.downButton.isEnabled = false;
            self.modeButton.isEnabled = false;
            isStateOn = false
        }
        else{
            self.onOffButton.setImage(UIImage(named: "on"), for: UIControlState.normal)
            self.fanButton.isEnabled = true;
            self.upButton.isEnabled = true;
            self.downButton.isEnabled = true;
            self.modeButton.isEnabled = true;
            isStateOn = true
        }
    }

    @IBAction func upButtonTapped(_ sender: AnyObject) {
        if(!setConfort){
            self.temperature += 1;
            self.temperatureLabel.text = String(temperature) + "°";
        }
        else{
            self.confort += 1
            self.temperatureLabel.text = String(confort)
        }
    }
    
    @IBAction func downButtonTapped(_ sender: AnyObject) {
        if(!setConfort){
            self.temperature -= 1;
            self.temperatureLabel.text = String(temperature) + "°";
        }
        else{
            self.confort -= 1
            self.temperatureLabel.text = String(confort)
        }
        
    }
    
    
    @IBAction func modeButtonTapped(_ sender: AnyObject) {
        if(modeState == 5){
            modeState = 0;
        }
        
        self.modeButton.setImage(UIImage(named: modalities[modeState]), for: UIControlState.normal)
        self.modeState += 1;
    }
    
    @IBAction func fanButtonTapped(_ sender: AnyObject) {
        if(fanState == 4){
            fanState = 0
        }
        self.fanLevelImageView.image = UIImage(named: fanLevel[fanState])
        self.fanState += 1;
    }
    
    func updateButton(){
        if(temperature == 16 || (modeState == 5 && confort == 1)){
            self.downButton.isEnabled = false
        }
        else{
            self.downButton.isEnabled = true
        }
        
        if(temperature == 27 || (modeState == 5 && confort == 5)){
            self.upButton.isEnabled = false
        }
        else{
            self.upButton.isEnabled = true
        }
        
    }
    
    func updateConfort(){
        if(modeState == 5){
            self.temperatureLabel.text = String(confort)
            self.setConfort = true
        }
        else{
            self.temperatureLabel.text = String(temperature) + "°"
            self.setConfort = false
        }
    }
    
    
     @IBAction func sendButtonTapped(_ sender: AnyObject) {
        
        let modalita = self.isStateOn ?  String(modeState) : "0"
        let speed : String? = (self.modeState != 0 && self.modeState != 5 && self.isStateOn) ? String(self.fanState) : nil
        let temperature : String? = (self.modeState != 0 && self.modeState != 5 && self.isStateOn) ? String(self.temperature) : nil
        let confort : String? = (self.modeState == 5 && self.isStateOn) ? String(self.confort) : nil
        
        _ = DomiWiiProvider.request(.sendConditionerAction(alias: conditionerItem.alias, mode: modalita, speed: speed, temperature: temperature, confort: confort)) { result in
            switch result {
            case let .success(response):
                let json = JSON(data: response.data)
                    let resp = json["response"].boolValue
                    if(resp){
                        self.showAlert("Perfetto", message: "Comando inviato correttamente")
                    }
                    else{
                        self.showAlert("Errore", message: "Comando non inviato")
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
