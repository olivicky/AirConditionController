import UIKit
import PKHUD
import SwiftyJSON
import RealmSwift
import MKMagneticProgress
import RKPieChart


class LumiTouchViewController: UIViewController {

    let realm = try! Realm()
    var touch: Device!
    var timerDispatchSourceTimer : DispatchSourceTimer?
    weak var timer: Timer?
    @IBOutlet weak var generalSettingsButton: UIButton!
    @IBOutlet weak var statisticaConsumuButton: UIButton!
    @IBOutlet weak var programmaSettimanaleButton: UIButton!
    @IBOutlet weak var comandoDispositivoButton: UIButton!
    @IBOutlet weak var tempRingView: MKMagneticProgress!
    @IBOutlet weak var timeChartContainer: UIView!
    var chartView : RKPieChartView!
    var chartItemArray = [RKPieChartItem]()
    
    @IBOutlet weak var stagioneLabel: UILabel!
    @IBOutlet weak var setPointLabel: UILabel!
    @IBOutlet weak var impiantoLabel: UILabel!
    @IBOutlet weak var funzioneLabel: UILabel!
    @IBOutlet weak var erroreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
 
        self.getDeviceMetadata()
        startTimer()
    }
    
    func startTimer() {
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.getDeviceMetadata()
            }
            
        } else {
            // Fallback on earlier versions
            timerDispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timerDispatchSourceTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(60))
            timerDispatchSourceTimer?.setEventHandler{
                self.getDeviceMetadata()
                
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
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private methods
    func getDeviceMetadata(){
        // Show spinner
//        HUD.show(.progress)
        _ = LumiProvider.request(.devicesMetadata(aliases: [self.touch.uid])) { result in
            switch result {
            case let .success(response):
                do {
                    let item: ControlledDevices? = try response.mapObject(ControlledDevices.self)
                    if let item = item {
                        // Presumably, you'd parse the JSON into a model object. This is just a demo, so we'll keep it as-is.
                        let device = item.controlledDevicesList[0]
                        
                            try! self.realm.write {
                                self.realm.create(Device.self, value: ["uid": device.uid, "temperature": device.temperature, "humidity": device.humidity, "_consumption": device._consumption, "_daily_temperature":device._daily_temperature, "_daily_timeron":device._daily_timeron, "timerOn": device.timerOn, "power_active": device.power_active, "power_reactive": device.power_reactive, "day": device.day, "hh": device.hh, "mm": device.mm, "set_point_benessere": device.set_point_benessere, "set_point_eco" :device.set_point_eco, "_planning": device._planning, "mode": device.mode, "_status": device._status, "set_point": device.set_point, "min_temperature" : device.min_temperature, "max_temperature": device.max_temperature, "max_power": device.max_power, "enableBotNotification": device.enableBotNotification, "enableMobileNotification": device.enableMobileNotification, "faulty": device.faulty, "is_running": device.is_running], update: true)
                            }
                        self.createDiagrams(device: device)
                        
                    }
                    // Hide spinner
                    
                    //HUD.hide(afterDelay: 2.0)
                } catch {
                    
                    // Hide spinner
                    //HUD.hide(afterDelay: 2.0)
                    //self.showAlert("GitHub Fetch", message: "Unable to fetch from GitHub")
                }
            //self.tableView.reloadData()
            case let .failure(error):
                //                guard let error = error as? CustomStringConvertible else {
                //                    break
                //                }
                self.showAlert("LumiTouch", message: error.errorDescription!)
                
                //HUD.hide(afterDelay: 2.0)
            }
        }
    }
    
    
    @IBAction func commandoButtonTapped(_ sender: Any) {
        var command : Int = 0;
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let manualeButton = UIAlertAction(title: "Manuale", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "manualCommandSegue",  sender: LumiTouchViewController.self)
        })
        
        let  spentoButton = UIAlertAction(title: "Spento", style: .default, handler: { (action) -> Void in
            command = 2
            self.sendCommand(command: command)
        })
        
        let programmaButton = UIAlertAction(title: "Programma", style: .default, handler: { (action) -> Void in
            command = 3
            self.sendCommand(command: command)
        })
        
        let protezioneButton = UIAlertAction(title: "Protezione", style: .default, handler: { (action) -> Void in
            command = 6
            self.sendCommand(command: command)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(manualeButton)
        alertController.addAction(spentoButton)
        alertController.addAction(programmaButton)
        alertController.addAction(protezioneButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func sendCommand(command: Int){
        HUD.show(.labeledProgress(title: nil, subtitle: "Invio comando in corso"))
        _ = LumiProvider.request(.sendDeviceAction(alias: self.touch.alias, password: self.touch.password, uuid: self.touch.uid, command: command, day: nil, hour: nil, minutes: nil, cap: nil, setPointBenessere: nil, setPointEco: nil, mode: nil, minTemperature: nil, maxTemperatura: nil, notificationPeriod: nil, enableMobileNotification: nil, enableBotNotification: nil, temperature: nil, timeOn: nil, planning: nil)) {
            
            result in
            switch result {
            case let .success(response):
                do{
                    let json = try JSON(data: response.data)
                    let resp = json["response"].boolValue
                    if(resp ){
                        HUD.flash(.labeledSuccess(title: nil, subtitle: "Comando Inviato"), delay: 2.0)
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
                HUD.hide()
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
    
    func createDiagrams(device: Device){
        chartItemArray.removeAll()
        tempRingView.progressShapeColor = UIColor.blue
        tempRingView.backgroundShapeColor = UIColor.white
        tempRingView.titleColor = UIColor.red
        tempRingView.percentColor = UIColor.black
        
        tempRingView.lineWidth = 10
        tempRingView.orientation = .bottom
        tempRingView.lineCap = .round
        tempRingView.clockwise = true
        tempRingView.spaceDegree = 45.0
        tempRingView.percentLabelFormat = "%.0f °C%"
        
        if device.mode != -1{
            self.generalSettingsButton.isEnabled = true
        }
        let temp = Int(device.temperature)!
        if( temp <= 25 && temp > 22 ){
            self.tempRingView.progressShapeColor = UIColor.yellow
            self.tempRingView.setProgress(progress: 0.60, animated: true)
            
        }else if(temp > 25 ){
            self.tempRingView.progressShapeColor = UIColor.red
            self.tempRingView.setProgress(progress: 0.80, animated: true)
        }else{
            self.tempRingView.progressShapeColor = UIColor.blue
            self.tempRingView.setProgress(progress: 0.30, animated: true)
        }
        self.tempRingView.percentLabel.text = String(temp) + "°C"
        
        tempRingView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        tempRingView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        tempRingView.centerXAnchor.constraint(equalTo: self.tempRingView.centerXAnchor).isActive = true
        tempRingView.centerYAnchor.constraint(equalTo: self.tempRingView.centerYAnchor).isActive = true
        
        var timeH = String(device.hh)
        var timeM = String(device.mm)
        if(timeH.count < 2){
            timeH="0"+timeH
        }
        if(timeM.count < 2){
            timeM="0"+timeM;
        }
        let time = timeH + ":" + timeM
        
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time)!
        let hourOfDay = calendar.component(.hour, from: date) - 1
        let endHourOfDay = (hourOfDay + (device.timerOn / 60))
        
        
        if device.status == .MANUAL {
            let rangeHour = hourOfDay...endHourOfDay
            var item : RKPieChartItem
            for i in 0...23 {
                
                if rangeHour.contains(i) {
                    item = RKPieChartItem(ratio: 4, color: UIColor.green, title:"")
                }
                else {
                    item  = RKPieChartItem(ratio: 4, color: UIColor.gray, title:"")
                }
                
                chartItemArray.append(item)
            }
        }
        else if device.status == .AUTO {
            
            var item : RKPieChartItem
            
            let plans = device.planning[device.day]
            for i in 0...23 {
                if(i == hourOfDay){
                    item = RKPieChartItem(ratio: 4, color: UIColor.lightGray, title:"")
                }
                else
                if plans[i] == 1{
                    item = RKPieChartItem(ratio: 4, color: UIColor.blue, title:"")
                }
                else if plans[i] == 2 {
                    item  = RKPieChartItem(ratio: 4, color: UIColor.red, title:"")
                }
                else {
                    item  = RKPieChartItem(ratio: 4, color: UIColor.gray, title:"")
                }
                
                chartItemArray.append(item)
            }
        }
        else {
            var item : RKPieChartItem
            for i in 0...23 {
                if(i == hourOfDay){
                    item = RKPieChartItem(ratio: 4, color: UIColor.lightGray, title:"")
                }
                else{
                    item  = RKPieChartItem(ratio: 4, color: UIColor.gray, title:"")
                }
                
                chartItemArray.append(item)
            }
        }

        
        
        var giorno : String
        
        switch(device.day){
        case 0: giorno = "LUN"
        case 1: giorno = "MAR"
        case 2: giorno = "MER"
        case 3: giorno = "GIO"
        case 4: giorno = "VEN"
        case 5: giorno = "SAB"
        case 6: giorno = "DOM"
        default:
            giorno = ""
        }
        
        let orario = timeH + ":" + timeM + "\n " + giorno
        
        if(chartView == nil){
            chartView = RKPieChartView(items:chartItemArray, centerTitle:orario )
        }
        else{
            
            chartView.upatedItems = chartItemArray
            chartView.centerTitle = orario
        }
        
        
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 12
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = true
        chartView.isAnimationActivated = false
        self.timeChartContainer.addSubview(chartView)
        
        chartView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.timeChartContainer.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: self.timeChartContainer.centerYAnchor).isActive = true
        
        
        //Label settings
        if device.season == .INVERNO{
            self.stagioneLabel.text = "Inverno"
        }
        else if device.season == .ESTATE{
            self.stagioneLabel.text = "Estate"
        }
        else{
            self.stagioneLabel.text = ""
        }
        
        if device.set_point == 0{
            self.setPointLabel.text = "NO"
        }
        else {
            self.setPointLabel.text = String(device.set_point) + "°C"
        }
        
        
        self.funzioneLabel.text = device.status.getStringValue()
        
        if device.faulty != -1 {
            self.erroreLabel.text = "code " + "\(device.faulty)"
        }
        else{
            self.erroreLabel.text = "nessuno"
        }
        
        var timerOnH = String(device.timerOn/60)
        var timerOnM = String(device.timerOn % 60)
        
        if(timerOnH.count < 2){
            timerOnH="0"+timerOnH
        }
        if(timerOnM.count < 2){
            timerOnM="0"+timerOnM;
        }
        self.timerLabel.text = timerOnH + ":" + timerOnM
        
        if device.is_running!{
            self.impiantoLabel.text = "ON"
        }
        else {
            self.impiantoLabel.text = "OFF"
        }
        
        
        
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "impostazioniLumiTouchSegue"){
            (segue.destination as! LumiTouchSettingsTableViewController).device = self.touch
        }
        else if(segue.identifier == "manualCommandSegue"){
            (segue.destination as! LumiTouchManualCommandTableViewController).device = self.touch
        }
        else if(segue.identifier == "programmaSegue"){
            (segue.destination as! LumiTouchProgramCollectionCollectionViewController).plan = self.touch.planning
            (segue.destination as! LumiTouchProgramCollectionCollectionViewController).device = self.touch
        }
        else if(segue.identifier == "statisticaSegue"){
            (segue.destination as! LumiTouchStatisticaCollectionViewController).device = self.touch
        }
    }

}
