//
//  UserHeadView.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit
import CoreData

class UserHeadView: UICollectionReusableView {
    
    @IBOutlet weak var avatarBt : UIButton!
    @IBOutlet weak var nameField : UITextField!
    var delegate : UserEntityDelegate?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    @IBAction func addAvatar(bt : UIButton) {
        
        self.endEditing(true)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.showActionSheet(actions: ["相册","拍照"]){ (idx) -> Void in
            
            if idx == 0 {
                
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.allowsEditing = true
                
                UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(imagePicker, animated: true, completion: nil)
            }else if idx == 1 {
                
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addUser() {
        
        if self.avatarBt.selected {
            if let img = avatarBt.imageView?.image{
                if let n = nameField.text {
                    
                    let d = UIImageJPEGRepresentation(img, 0.7)
                    
                    let context = appDelegate.managedObjectContext
                    let e = NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: context) as! UserEntity
                    e.name = n
                    e.avatar = d
                    e.uid = countOfEntity("UserEntity")
                    e.detail = NSSet()
                    e.com = NSSet()
                    e.zan = NSSet()
                    if e.uid == 1 {
                        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "defaultUser")
                    }
                    appDelegate.saveContext()
                    print(e)
                    
                    self.delegate?.entityHasChanged!(self, m: e)
                    
                    self.avatarBt.setImage(nil, forState: UIControlState.Normal)
                    self.avatarBt.selected = false
                    self.nameField.text = nil
                }
            }
        }
        
        
    }

}


///图片上传
extension UserHeadView: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        UIApplication.sharedApplication().keyWindow!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        UIApplication.sharedApplication().keyWindow!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
        self.avatarBt.setImage(image, forState: UIControlState.Normal)
        self.avatarBt.selected = true
    }
}