import UIKit

class FAQViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var index : String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdf = Bundle.main.url(forResource: ("FAQ" + index), withExtension: "pdf")
        {
            webView.loadRequest(URLRequest(url: pdf))
        }
    }
}
