//
//  ExternalCollectionViewCell.swift
//  ConditionController
//
//  Created by Vincenzo Olivito on 06/09/2018.
//  Copyright © 2018 vincenzoOlivito. All rights reserved.
//

import UIKit

class ExternalCollectionViewCell: UICollectionViewCell {
    
    var dailyPlan : [Int] = []
    var parentClass : DomiTouchProgramCollectionCollectionViewController!
    var dayIndex : Int = -1
    var type : DeviceType = .DomiTouch
    @IBOutlet weak var coll: UICollectionView!
    @IBOutlet weak var dayLabel: UILabel!
    fileprivate let itemsPerRow: CGFloat = 4
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    
    @IBAction func caricaProgrammaTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let lunediButton = UIAlertAction(title: "Lunedi", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[0]
            self.dailyPlan = self.parentClass.plan[0]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
        })
        
        let martediButton = UIAlertAction(title: "Martedi", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[1]
            self.dailyPlan = self.parentClass.plan[1]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
        })
        
        let mercolediButton = UIAlertAction(title: "Mercoledi", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[2]
            self.dailyPlan = self.parentClass.plan[2]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
        })
        
        let giovediButton = UIAlertAction(title: "Giovedi", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[3]
            self.dailyPlan = self.parentClass.plan[3]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
        })
        
        let venerdiButton = UIAlertAction(title: "Venerdi", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[4]
            self.dailyPlan = self.parentClass.plan[4]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
        })
        
        let sabatoButton = UIAlertAction(title: "Sabato", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[5]
            self.dailyPlan = self.parentClass.plan[5]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
        })
        
        let domenicaButton = UIAlertAction(title: "Domenica", style: .default, handler: { (action) -> Void in
            self.parentClass.plan[self.dayIndex] = self.parentClass.plan[6]
            self.dailyPlan = self.parentClass.plan[6]
            DispatchQueue.main.async(execute: {
                self.coll.reloadData()
            })
            
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(lunediButton)
        alertController.addAction(martediButton)
        alertController.addAction(mercolediButton)
        alertController.addAction(giovediButton)
        alertController.addAction(venerdiButton)
        alertController.addAction(sabatoButton)
        alertController.addAction(domenicaButton)
        alertController.addAction(cancelButton)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

extension ExternalCollectionViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InternalCell", for: indexPath) as! InternalCellCollectionViewCell
        
        //cell.backgroundColor = UIColor.gray
        cell.hourLabel.text = "\(indexPath.row )" + ":00" ;
        
        if dailyPlan[indexPath.row] == 1{
            cell.backgroundColor = UIColor.blue
        }
        else if dailyPlan[indexPath.row] == 2{
            cell.backgroundColor = UIColor.red
        }
        else{
            cell.backgroundColor = UIColor.gray
        }
        // Configure the cell
        return cell
    }
    
    
    
}

extension ExternalCollectionViewCell: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InternalCell", for: indexPath) as! InternalCellCollectionViewCell
        if(dailyPlan[indexPath.row] == 0){
                parentClass.plan[dayIndex][indexPath.row] = 1
                dailyPlan[indexPath.row] = 1
                cell.backgroundColor = UIColor.blue
         }
        else if dailyPlan[indexPath.row] == 1{
            if type == .DomiTouch{
                parentClass.plan[dayIndex][indexPath.row] = 2
                dailyPlan[indexPath.row] = 2
                cell.backgroundColor = UIColor.red
            }
            else {
                parentClass.plan[dayIndex][indexPath.row] = 0
                dailyPlan[indexPath.row] = 0
                cell.backgroundColor = UIColor.gray
            }
        }
        else if dailyPlan[indexPath.row] == 2{
            parentClass.plan[dayIndex][indexPath.row] = 0
            dailyPlan[indexPath.row] = 0
            cell.backgroundColor = UIColor.gray
        }
        
        self.coll.reloadData()
        
    }
}

extension ExternalCollectionViewCell : UICollectionViewDelegateFlowLayout{
    
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 40)
    }
    
    //3
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
