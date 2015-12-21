//
//  CommentCell.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var comView : UIImageView!
    @IBOutlet weak var avatarView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var contentLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    
    var entity : ComEntity? = nil {
        
        didSet{
            
            if let img = entity?.user?.avatar {
                avatarView.image = UIImage(data: img)
            }
            if let r = entity?.rename {
            
                let range = (entity!.comment! as NSString).rangeOfString(r)
                let att = NSMutableAttributedString(string: entity!.comment!)
                att.addAttribute(NSForegroundColorAttributeName, value: RGBA(67, g: 84, b: 133, a: 1), range: range)
                att.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14), range: range)
                contentLabel.attributedText = att
            }else {
                
                contentLabel.text = entity?.comment
            }


            
            nameLabel.text = entity?.user?.name
            timeLabel.text = zh_formatTimeInterval(entity?.ctime?.doubleValue, format: zh_timeFormatStr3)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
