//
//  ReleaseTableViewController.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit
import CoreData

///发布朋友圈
class ReleaseTableViewController: UITableViewController {

    var user : UserEntity?
    @IBOutlet weak var contentTextView : UITextView!
    @IBOutlet weak var timeBt : UIButton!
    @IBOutlet weak var myCollectionView : UICollectionView!

    var photos = [NSData]()
    var editTime : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = v

    }
    
    
    @IBAction func timeButtongAction(bt : UIButton) {
        
        self.view.endEditing(true)
        ZHDatePicker.showDatePicker(NSDate(), pickerStateBlock: { (state) -> Void in
            
            
            }) { (d) -> Void in
                
                self.editTime = d
                self.timeBt.setTitle("时间选择：\(zh_formatTime(d, format: zh_timeFormatStr3))", forState: UIControlState.Normal)
        }
        
    }
    
    @IBAction func releaseButtongAction() {
        
        if user == nil {
            showAlert("当前用户不存在", actions: ["确定"])
            return
        }
        if contentTextView.text.characters.count > 0 || photos.count > 0 {
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = delegate.managedObjectContext
            let e = NSEntityDescription.insertNewObjectForEntityForName("FriendDetailEntity", inManagedObjectContext: context) as! FriendDetailEntity
            
            e.fid = countOfEntity("FriendDetailEntity")
            if contentTextView.text.characters.count > 0 {
                e.content = contentTextView.text
            }
            e.type = 1
            e.com = NSSet()
            e.zan = NSSet()
            e.photos = NSSet()
            if let d = self.editTime {
                e.ctime = d.timeIntervalSince1970
            }else {
                e.ctime = NSDate().timeIntervalSince1970
            }
            e.user = user
            
            if photos.count > 0 {
                for d in photos {
                    
                    let pe = NSEntityDescription.insertNewObjectForEntityForName("PhotoEntity", inManagedObjectContext: context) as! PhotoEntity
                    pe.photo = d
                    pe.pid = countOfEntity("PhotoEntity")
                    pe.friend = e
                }
            }
            
            delegate.saveContext()
            
            self.navigationController?.popViewControllerAnimated(true)
            print(e)
        }else {
            showAlert("无法发布", actions: ["确定"])
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}


/**
*
*/
extension ReleaseTableViewController: UICollectionViewDelegateFlowLayout {
    
    @IBAction func addPhotoAction(bt : UIButton) {
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.showActionSheet(actions: ["相册","拍照"]){ (idx) -> Void in
            
            if idx == 0 {
                
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(imagePicker, animated: true, completion: nil)
            }else if idx == 1 {
                
                let imagePicker = UIImagePickerController();
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ReleaseUserCellID", forIndexPath: indexPath) as! UserCell
        if photos.count > indexPath.item {
            
            cell.avatarView.image = UIImage(data: photos[indexPath.item])
            cell.nameLabel.hidden = true
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        showActionSheet(actions: ["删除"]) { (idx) -> Void in
            
            if idx == 0 {
                
                self.photos.removeAtIndex(indexPath.item)
                collectionView.deleteItemsAtIndexPaths([indexPath])
            }
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(60, 60)
    }
}

///图片上传
extension ReleaseTableViewController: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        UIApplication.sharedApplication().keyWindow!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        UIApplication.sharedApplication().keyWindow!.rootViewController!.dismissViewControllerAnimated(true, completion: nil)
        let data = UIImageJPEGRepresentation(image, 0.7)
        if let d = data {
            self.photos.append(d)
            self.myCollectionView.reloadData()
        }
    }
}

