//
//  EditTableViewController.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {

    @IBOutlet weak var avatarView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    var user = getDefaultUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let u = user {
            print(u)
            avatarView.image = UIImage(data: u.avatar!)
            nameLabel.text = u.name
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
            
        case "UserCollectionViewControllerID":
            let rvc = segue.destinationViewController as! UserCollectionViewController
            rvc.selectDefaultUser = true
            rvc.selectDefaultUserBlock = { (u : UserEntity) -> () in
                
                self.user = u
                self.avatarView.image = UIImage(data: u.avatar!)
                self.nameLabel.text = u.name
            }
            
        case "ReleaseTableViewControllerID":
            let rvc = segue.destinationViewController as! ReleaseTableViewController
            rvc.user = self.user
            
        case "ForwardTableViewControllerID":
            let rvc = segue.destinationViewController as! ForwardTableViewController
            rvc.user = self.user
            
        default: break
        }

        
        
    }
}
