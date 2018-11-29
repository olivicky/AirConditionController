import UIKit
import SwiftyJSON
import PKHUD

private let reuseIdentifier = "Cell"

class LumiTouchProgramCollectionCollectionViewController: UICollectionViewController {
    var device : Device!
    var plan : [[Int]] = [[]]
    @IBOutlet weak var caricaButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func caricaButtonTapped(_ sender: UIBarButtonItem) {
        HUD.show(.labeledProgress(title: nil, subtitle: "Invio comando in corso"))
        _ = LumiProvider.request(.sendDeviceAction(alias: self.device.alias, password: device.password, uuid: device.uid, command: 4, day: nil, hour: nil, minutes: nil, cap: nil, setPointBenessere: nil, setPointEco: nil, mode: nil, minTemperature: nil, maxTemperatura: nil, notificationPeriod: nil, enableMobileNotification: nil, enableBotNotification: nil, temperature: nil, timeOn: nil, planning: plan)) {
            result in
            switch result {
            case let .success(response):
                do{
                    let json = try JSON(data: response.data)
                    let resp = json["response"].boolValue
                    if(resp ){
                        HUD.flash(.labeledSuccess(title: nil, subtitle: "Comando Inviato"), delay: 2.0)
                        _ = self.navigationController?.popViewController(animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExternalCell", for: indexPath) as! ExternalCollectionViewCell
        
        switch indexPath.section {
        
            case 0: cell.dayLabel.text = "Lunedi"
            cell.dayIndex = 0
            case 1: cell.dayLabel.text = "Martedi"
            cell.dayIndex = 1
            case 2: cell.dayLabel.text = "Mercoledi"
            cell.dayIndex = 2
            case 3: cell.dayLabel.text = "Giovedi"
            cell.dayIndex = 3
            case 4: cell.dayLabel.text = "Venerdi"
            cell.dayIndex = 4
            case 5: cell.dayLabel.text = "Sabato"
            cell.dayIndex = 5
            case 6: cell.dayLabel.text = "Domenica"
            cell.dayIndex = 6
        default:
            cell.dayLabel.text = ""
        }
        cell.backgroundColor = UIColor.white
        cell.parentClass = self
        cell.dailyPlan = plan[indexPath.section]
        cell.type = device.type
        cell.coll.reloadData()
        // Configure the cell
        return cell
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    //Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
 

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    


}
