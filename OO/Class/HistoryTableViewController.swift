//
//  HistoryTableViewController.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit
import CoreData

///历史记录
class HistoryTableViewController: UITableViewController {

    var list : [FriendDetailEntity]?

    override func viewWillAppear(animated: Bool) {
        
        list = getUserFrindList()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let s = list {
            return s.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCellID", forIndexPath: indexPath) as! HistoryCell

        if let s = list {
            if s.count > indexPath.item {
                
                let entity = s[indexPath.item]
                cell.avatarView.image = UIImage(data: entity.user!.avatar!)
                cell.nameLabel.text = entity.user!.name
                cell.contentLabel.text = entity.content
                cell.timeLabel.text = zh_formatTimeInterval(entity.ctime?.doubleValue, format: zh_timeFormatStr3)
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let s = list {
            if s.count > indexPath.item {
                
                let e = s[indexPath.item]
                let dvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailTableViewController") as! DetailTableViewController
                dvc.fid = e.fid
                dvc.entity = e
                self.navigationController?.pushViewController(dvc, animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if let s = list {
            if s.count > indexPath.item {

                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate

                let m = s[indexPath.row]
                delegate.managedObjectContext.deleteObject(m)
                do {
                    try delegate.managedObjectContext.save()
                }catch {
                    print(error)
                }
                
                self.list?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            }
        }

    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        
    }

}
