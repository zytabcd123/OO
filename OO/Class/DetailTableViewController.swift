//
//  DetailTableViewController.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit
import CoreData

///朋友圈详情界面
class DetailTableViewController: UITableViewController {

    var bottonView : InputView!
    var entity : FriendDetailEntity?
    var comments = [ComEntity]()
    var fid : NSNumber?
    
    override func viewDidAppear(animated: Bool) {
        
        bottonView.view.hidden = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        bottonView.view.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 53, 0)
        
        if var c = self.entity?.com?.allObjects as? [ComEntity] {

            c.sortInPlace({ (a: ComEntity, b: ComEntity) -> Bool in
                
                return a.ctime!.doubleValue < b.ctime!.doubleValue
            })
            comments = c
            self.tableView.reloadData()
        }
        
        if let p = self.entity?.photos {
            if let type = self.entity?.type?.integerValue {
                if type == 1 && p.count > 0 {
                
                    let rBt = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "backButtontClick")
                    rBt.tintColor = RGBA(61, g: 155, b: 0, a: 1)
                    self.navigationItem.leftBarButtonItem = rBt
                }
            }
        }
        
        bottonView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("InputView") as! InputView
        bottonView.view.frame = CGRectMake(0, kHeight() - 53, kWidth(), 269)
        bottonView.currentUser = entity?.user
        bottonView.entity = entity
        bottonView.faceButton.addTarget(self, action: "faceButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        bottonView.avatar.addTarget(self, action: "faceButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.view.addSubview(bottonView.view)
        
        bottonView.updateCommentBlock = { () -> () in
        
            if var c = self.entity?.com?.allObjects as? [ComEntity] {
                
                c.sortInPlace({ (a: ComEntity, b: ComEntity) -> Bool in
                    
                    return a.ctime!.doubleValue < b.ctime!.doubleValue
                })
                self.comments = c
                self.tableView.reloadData()
            }
        }
        
    }
    
    func backButtontClick() {
        
        if self.navigationController?.childViewControllers.count > 1{
            
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            
            self .dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func faceButtonAction(bt : UIButton) {
        
        bottonView.faceButton.selected = !bottonView.faceButton.selected
        if bottonView.inputField.isFirstResponder() {
            bottonView.inputField.resignFirstResponder()
        }
        if bottonView.faceButton.selected {
            
            if !bottonView.hasData {
                bottonView.myDataSource = getAllUsers()
                bottonView.myCollectionView.reloadData()
            }
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.bottonView.view.frame = CGRectMake(0, kHeight() - ZHHeight(self.bottonView.view), kWidth(), ZHHeight(self.bottonView.view))
            })
        }else {
        
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                
                self.bottonView.view.frame = CGRectMake(0, kHeight() - 53, kWidth(), ZHHeight(self.bottonView.view))
            })
        }
    }
    
    func likeButtonAction() {

        self.showActionSheet(actions: ["全部赞","全部删除"]) { (idx) -> Void in
            
            if idx == 0 {
                
                if let users = getAllUsers() {
                    
                    let s = users.filter({ (u : UserEntity) -> Bool in
                        
                        var has = true
                        if let zs = self.entity?.zan?.allObjects as? [ZanEntity]{
                            
                            for z in zs {
                                if z.user?.uid == u.uid {
                                    has = false
                                    break
                                }
                            }
                        }
                        return has
                    })
                    
                    print(s)
                    if s.count > 0 {
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        for u in s {
                            let e = NSEntityDescription.insertNewObjectForEntityForName("ZanEntity", inManagedObjectContext: delegate.managedObjectContext) as! ZanEntity
                            e.user = u
                            e.friend = self.entity
                        }
                        delegate.saveContext()
                        self.tableView.reloadData()
                    }
                }
            }else if idx == 1 {
                
                if let zs = self.entity?.zan?.allObjects as? [ZanEntity] {
                    
                    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    for z in zs {
                        delegate.managedObjectContext.deleteObject(z)
                    }
                    delegate.saveContext()
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension DetailTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        }else if section == 1 {
        
            if let c = entity?.zan?.count {
                return c > 0 ? 1 : 0
            }
            return 0
        }
        return comments.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            if let e = entity {

                let w = kWidth() - 60 - 35
                let fh = e.type!.integerValue == 2 ? 50 : 0
                if e.type!.integerValue == 2 {
                    return 100 + textHeight(e.content, maxWidth: w, minHeight: 21, font: UIFont.systemFontOfSize(15)) + CGFloat(fh)
                }
                return 100 + textHeight(e.content, photos: e.photos, maxWidth: w, minHeight: 21, font: UIFont.systemFontOfSize(15))
            }
            return 100
        }else if indexPath.section == 1 {

            if let z = entity?.zan {
                
                let numOfARow = Int(abs((kWidth() - 20 - 36)/40))
                if z.count <= numOfARow {//1行
                    return 55
                }else {
                    return 55 + CGFloat(40*(z.count/numOfARow))
                }
            }
            return 0
        }else {
            
            let e = comments[indexPath.row]
            let w = kWidth() - 110
            return 50 + textHeight(e.comment, maxWidth: w, minHeight: 17, font: UIFont.systemFontOfSize(14))
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCellID", forIndexPath: indexPath) as! DetailCell

            cell.entity = entity
            return cell
        
        }else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LikeCellID", forIndexPath: indexPath) as! LikeCell

            cell.list = entity?.zan
            cell.likeBt.addTarget(self, action: "likeButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCellID", forIndexPath: indexPath) as! CommentCell
        cell.comView.hidden = indexPath.row != 0
        
        cell.entity = comments[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {

            let e = comments[indexPath.row]
            
            bottonView.rename = e.user?.name
            bottonView.inputField.placeholder = "回复:" + e.user!.name!
            bottonView.inputField.becomeFirstResponder()
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 2 {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 {

            if comments.count > indexPath.item {
                
                self.showActionSheet(actions: ["删除评论","修改时间"], didSelectBlock: { (idx) -> Void in
                    
                    if idx == 0 {
                        let m = self.comments[indexPath.row]
                        
                        self.comments.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                        
                        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        delegate.managedObjectContext.deleteObject(m)
                        do {
                            try delegate.managedObjectContext.save()
                        }catch {
                            print(error)
                        }
                    }else if idx == 1 {
                        
                        ZHDatePicker.showDatePicker(NSDate(), pickerStateBlock: { (state) -> Void in
                            
                            
                            }) { (d) -> Void in
                                
                                let e = self.comments[indexPath.row]
                                e.ctime = d.timeIntervalSince1970
                                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                do {
                                    try delegate.managedObjectContext.save()
                                }catch {
                                    print(error)
                                }
                                
                                if var c = self.entity?.com?.allObjects as? [ComEntity] {
                                    
                                    c.sortInPlace({ (a: ComEntity, b: ComEntity) -> Bool in
                                        
                                        return a.ctime!.doubleValue < b.ctime!.doubleValue
                                    })
                                    self.comments = c
                                    self.tableView.reloadData()
                                }
                        }
                    }
                })
            }
        }
    }
    
}