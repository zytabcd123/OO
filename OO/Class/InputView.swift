//
//  InputView.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit
import CoreData


class InputView: UIViewController {

    var updateCommentBlock : (() -> ())?

    @IBOutlet weak var inputField : UITextField!
    @IBOutlet weak var faceButton : UIButton!
    @IBOutlet weak var avatar : UIButton!

    @IBOutlet weak var myCollectionView : UICollectionView!

    var hasData = false
    var myDataSource : [UserEntity]?
    
    var rename : String?
    var entity : FriendDetailEntity?
    var currentUser : UserEntity? = {
        
        return nil
        }() {
            
        didSet{
            
            self.avatar.setImage(UIImage(data: currentUser!.avatar!), forState: UIControlState.Normal)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputField.layer.masksToBounds = true
        inputField.layer.cornerRadius = 5.0
        inputField.layer.borderWidth = 1.0
        inputField.layer.borderColor = RGBA(224, g: 224, b: 225, a: 1).CGColor
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillShowNotification, object: nil).subscribeNext { (info) -> Void in
            
            let dic : NSDictionary = info.userInfo
            let h = dic["UIKeyboardBoundsUserInfoKey"]?.CGRectValue.size.height
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.view.frame = CGRectMake(0, kHeight() - 91 - h!, kWidth(), 91 + h!)
            })
        }

        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIKeyboardWillHideNotification, object: nil).subscribeNext { (info) -> Void in
            
            if self.inputField.text == nil || self.inputField.text?.characters.count <= 0{
                self.rename = nil
                self.inputField.placeholder = "评论"
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.view.frame = CGRectMake(0, kHeight() - 53, kWidth(), ZHHeight(self.view))
            })
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




/**
*
*/
extension InputView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let s = myDataSource {
            
            return s.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InputUserCellID", forIndexPath: indexPath) as! UserCell
        if let s = myDataSource {
            if s.count > indexPath.item {
                
                let entity = s[indexPath.item]
                cell.avatarView.image = UIImage(data: entity.avatar!)
                cell.nameLabel.text = entity.name
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.showActionSheet(actions: ["设置为当前评论用户","点赞"]) { (idx) -> Void in
            
            if idx == 0 {
                
                self.currentUser = self.myDataSource?[indexPath.item]
            }else if idx == 1 {
                
                let u = self.myDataSource?[indexPath.item]
                if let s = self.entity?.zan?.allObjects {
                    for user in s {
                        
                        if u?.uid == (user as! ZanEntity).user?.uid {
                            print("点赞过")
                            return
                        }
                    }
                }
                
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let e = NSEntityDescription.insertNewObjectForEntityForName("ZanEntity", inManagedObjectContext: delegate.managedObjectContext) as! ZanEntity
                e.user = u
                e.friend = self.entity
                delegate.saveContext()
                self.updateCommentBlock?()
            }
        }        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(50, 50)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }

    
    
}


/**
*  UITextFieldDelegate
*/
extension InputView : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if let s = textField.text {
            
            if s.characters.count <= 0 {
                return true
            }
            
            //发表评论
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let e = NSEntityDescription.insertNewObjectForEntityForName("ComEntity", inManagedObjectContext: delegate.managedObjectContext) as! ComEntity
            e.user = self.currentUser
            e.friend = self.entity
            e.ctime = NSDate().timeIntervalSince1970
            e.cid = countOfEntity("ComEntity")
            if let r = rename {
                e.comment = "回复" + r + ":" + s
            }else {
                e.comment = s
            }
            e.rename = rename
            delegate.saveContext()
            
            self.inputField.text = nil
            self.rename = nil
            self.inputField.placeholder = "评论"
            
            //回调通知界面更新
            self.updateCommentBlock?()
        }
        
        return true
    }
}
