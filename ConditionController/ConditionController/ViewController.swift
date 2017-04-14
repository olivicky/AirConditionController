///Users/rinaldo/Documents/AirConditionController/ConditionController/ConditionController/ViewController.swift
//  ViewController.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 03/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var heightButtonBoxConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthButtonBoxConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthLogoConstraint: NSLayoutConstraint!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if(AppSetup.sharedState.readyDevicesCounter == 0)
//        {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirstActivationTableViewController") as? FirstActivationTableViewController
//            {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
//        }
        
        
        let logo = UIImage(named: "domiwii")
        let imageView = UIImageView(image: logo)
        
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 110,height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        self.navigationItem.titleView = titleView
        
        
        
        self.view.backgroundColor = UIColor.white
        
        // 2
        gradientLayer.frame = self.view.bounds
        
        // 3
        let color1 = UIColor.gray.cgColor as CGColor
        let color2 = UIColor.white.cgColor as CGColor
        gradientLayer.colors = [color1, color2]
        gradientLayer.startPoint = CGPoint(x: 0.0,y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,y: 0.5)
        
        // 4
        gradientLayer.locations = [0.0, 1.0]

        // 5
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.view.layoutIfNeeded()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

