//
//  UserCollectionViewController.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit
import CoreData

private let UserCellID = "UserCellID"
private let UserHeadID = "UserHeadID"

///用户界面
class UserCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UserEntityDelegate,UITextFieldDelegate {

    var selectDefaultUserBlock : ((user : UserEntity) -> ())?
    var selectDefaultUser = false
    
    var myDataSource = getAllUsers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let s = myDataSource {
        
            return s.count
        }
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(UserCellID, forIndexPath: indexPath) as! UserCell
        if let s = myDataSource {
            if s.count > indexPath.item {
                
                let entity = s[indexPath.item]
                cell.avatarView.image = UIImage(data: entity.avatar!)
                cell.nameLabel.text = entity.name
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if selectDefaultUser {
            
            let entity = myDataSource![indexPath.item]
            NSUserDefaults.standardUserDefaults().setInteger(entity.uid!.integerValue, forKey: "defaultUser")
            selectDefaultUserBlock?(user: entity)

            if self.navigationController?.childViewControllers.count > 1{
                
                self.navigationController?.popViewControllerAnimated(true)
            }else {
                
                self .dismissViewControllerAnimated(true, completion: nil)
            }
        }else {
            
            self.showAlert("删除用户", msg: "同时会删除改用户发出的所有朋友圈、点赞和评论相关数据", actions: ["确定","取消"], didSelectBlock: { (idx) -> Void in
                
                if idx == 0 {
                    
                    if let s = self.myDataSource {
                        if s.count > indexPath.item {
                            let e = self.myDataSource![indexPath.item]
                            
                            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            delegate.managedObjectContext.deleteObject(e)
                            delegate.saveContext()
                            
                            self.myDataSource?.removeAtIndex(indexPath.item)
                            collectionView.deleteItemsAtIndexPaths([indexPath])
                        }
                    }
                }
            })
        }

    }
    

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let head = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: UserHeadID, forIndexPath: indexPath) as! UserHeadView
        
        head.delegate = self
        
        return head
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSizeMake(kWidth(), 100)
    }
    
    
    func entityHasChanged(obj: AnyObject?, m: UserEntity?) {
        
        if let e = m {
            
            myDataSource?.append(e)
            self.collectionView!.reloadData()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}




