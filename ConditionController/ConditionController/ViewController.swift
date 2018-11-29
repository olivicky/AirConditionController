import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var heightButtonBoxConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthButtonBoxConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthLogoConstraint: NSLayoutConstraint!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = UIScreen.main.bounds.size
        
        
        if size.width == 320{
            
            heightButtonBoxConstraint.constant = 150
            
            widthButtonBoxConstraint.constant = 200
            heightLogoConstraint.constant = 200
            
            widthLogoConstraint.constant = 230
            
            
        }
    }
    
    @IBAction func configuraSistemaTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let lumiWiiButton = UIAlertAction(title: "Lumi - Condizionatore", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "ConfiguraSistemaLumiWiiSegueIdentifier",  sender: LumiTouchViewController.self)
        })
        
        let  deviceButton = UIAlertAction(title: "Altri dispositivi", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "ConfiguraSistemaLumiHomeSegueIdentifier",  sender: LumiTouchViewController.self)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(lumiWiiButton)
        alertController.addAction(deviceButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

