import UIKit

private let reuseIdentifier = "StatisticaCell"

class LumiTouchStatisticaCollectionViewController: UICollectionViewController {
    
    var device : Device!
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatisticaCell", for: indexPath) as! StatisticaCollectionViewCell
        
        let calendar = Calendar.current
        var dayOfWeek = calendar.component(.weekday, from: Date()) - calendar.firstWeekday
        if dayOfWeek < 0 {
            dayOfWeek += 7
        }
        
        if indexPath.section == 0{
            var consValue = 0
            if(self.device.consumption.count > 0){
                consValue = self.device.consumption[indexPath.row]
            }
            let hh = consValue/60
            let mm = consValue % 60
            var timeH = String(hh)
            var timeM = String(mm)
            if(timeH.count < 2){
                timeH="0"+timeH
            }
            if(timeM.count < 2){
                timeM="0"+timeM;
            }
            
            if(device.type == .LumiTouch){
                cell.temp.text = timeH + ":" + timeM
            }
            else {
                cell.temp.text = String(consValue)
            }
            
            
            if(consValue != 0 && consValue <= 15   ){
                cell.image?.image = UIImage(named: "min100")
                
            }else if (consValue != 0 && consValue > 15 && consValue < 20){
                
                cell.image?.image = UIImage(named: "med100")
                
            }else if (consValue != 0 && consValue > 26 ){
                cell.image?.image = UIImage(named: "max100")
                
            }else{
                cell.image?.image = UIImage(named: "min100")
            }
            
            switch(indexPath.row){
            case 0: cell.day.text = "LUN"
            case 1: cell.day.text = "MAR"
            case 2: cell.day.text = "MER"
            case 3: cell.day.text = "GIO"
            case 4: cell.day.text = "VEN"
            case 5: cell.day.text = "SAB"
            case 6: cell.day.text = "DOM"
            default:
                cell.day.text = ""
            }
            
            if(indexPath.row == dayOfWeek){
                cell.backgroundColor = UIColor(displayP3Red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 0.5)
            }
            
        }
        
        else if indexPath.section == 1{
            let consValue : Int
            if(device.type == .LumiTouch){
                consValue = self.device.daily_temperature[indexPath.row]
            }
            else {
                consValue = self.device.daily_timeron[indexPath.row]
            }
            
            let hh = consValue/60
            let mm = consValue % 60
            var timeH = String(hh)
            var timeM = String(mm)
            if(timeH.count < 2){
                timeH="0"+timeH
            }
            if(timeM.count < 2){
                timeM="0"+timeM;
            }
            
            if(device.type == .LumiTouch){
                cell.temp.text = String(consValue) + "°"
                
            }
            else {
                cell.temp.text = timeH + ":" + timeM
            }
            
            
            
            if(consValue != -1 && consValue <= 15   ){
                cell.image?.image = UIImage(named: "min100")

            }else if (consValue != -1 && consValue > 15 && consValue < 20){

                cell.image?.image = UIImage(named: "med100")

            }else if (consValue != -1 && consValue > 26 ){
                cell.image?.image = UIImage(named: "max100")

            }else{

            }

            switch(indexPath.row){
                case 0: cell.day.text = "LUN"
                case 1: cell.day.text = "MAR"
                case 2: cell.day.text = "MER"
                case 3: cell.day.text = "GIO"
                case 4: cell.day.text = "VEN"
                case 5: cell.day.text = "SAB"
                case 6: cell.day.text = "DOM"
            default:
                cell.day.text = ""
            }
            
            if(indexPath.row == dayOfWeek){
                cell.backgroundColor = UIColor(displayP3Red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 0.5)
            }

        }
//        else {
//           cell.image?.image = UIImage(named: String(self.device.daily_temperature[indexPath.row]))
        
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

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StatisticheHeader", for: indexPath) as! StatisticheHeaderCollectionReusableView
            
            if (indexPath.section == 0){
                if(device.type == .LumiTouch){
                    header.headerLabel.text = "Periodo di funzionamento"
                }
                else
                {
                    header.headerLabel.text = "Energia assorbita (Wh)"
                }
            }
            else {
                if(device.type == .LumiTouch){
                    header.headerLabel.text = "Temperatura media giornaliera"
                }
                else
                {
                    header.headerLabel.text = "Tempo di funzionamento"
                }
            }
            return header
        default:
            fatalError("Unexpected element kind")
            
        }
    }
    
    

}



extension LumiTouchStatisticaCollectionViewController : UICollectionViewDelegateFlowLayout{

    
    func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    sizeForItemAt indexPath: IndexPath) -> CGSize {
    //2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = collectionView.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
}

func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
}

// 4
func collectionView(_ collectionView: UICollectionView,
                    layout collectionViewLayout: UICollectionViewLayout,
                    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
}

}
