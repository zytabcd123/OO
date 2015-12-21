//
//  DetailCell.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var upView : UIImageView!
    @IBOutlet weak var avatarView : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var contentLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    
    var entity : FriendDetailEntity? = nil {
        
        didSet{
        
            if let e = entity {
                
                avatarView.image = UIImage(data: e.user!.avatar!)
                nameLabel.text = e.user!.name
                timeLabel.text = zh_formatTimeInterval(e.ctime?.doubleValue, format: zh_timeFormatStr3)
                
                
                var h = CGFloat(0)
                if let s = e.content {
                    let size = NSString(string: s).boundingRectWithSize(CGSizeMake(kWidth()-95, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15)], context: nil).size
                    h = size.height
                }
                h = h > 0 ? h + 8 : h + 5
                contentLabel.text = e.content
                contentLabel.alignTopLeft()
                let z = entity?.zan?.count
                let c = entity?.com?.count
                if z > 0 || c > 0 {
                    upView.hidden = false
                }else {
                    upView.hidden = true
                }
                
                //转发
                if e.type!.integerValue == 2 {
                    
                    let fv = UIView(frame: CGRect(x: ZHX(contentLabel), y: ZHY(contentLabel) + h, width: kWidth() - 92, height: 50))
                    fv.backgroundColor = RGBA(242, g: 242, b: 244, a: 1)
                    self.contentView.addSubview(fv)
                    
                    let fi = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
                    fi.contentMode = UIViewContentMode.ScaleAspectFill
                    fi.image = UIImage(data: e.forwardPhoto!.photo!)
                    fv.addSubview(fi)
                    
                    let fc = UILabel(frame: CGRect(x: 50, y: 5, width: ZHWidth(fv) - 60, height: 40))
                    fc.textColor = UIColor.blackColor()
                    fc.font = UIFont.systemFontOfSize(14)
                    fc.text = e.forwardContent
                    fc.textAlignment = NSTextAlignment.Left
                    fc.numberOfLines = 2
                    fv.addSubview(fc)
                    
                    return
                }
                
                //图文
                if let p = entity?.photos?.allObjects {

                    if p.count <= 0 {
                        return
                    }
                    if p.count == 1 {
                        let img = UIImage(data: (p.first as! PhotoEntity).photo!)!
                        let imgView = UIImageView(frame: CGRectMake(ZHX(contentLabel), ZHY(contentLabel) + h, img.size.width/img.size.height*180, 180))
                        imgView.contentMode = UIViewContentMode.ScaleToFill
                        imgView.image = img
                        self.contentView.addSubview(imgView)
                        return
                    }
                    
                    let row = p.count <= 3 ? 1 : (p.count/3 + 1)
                    for r in 1...row {
                        for i in 0...2 {
                            
                            let idx = 3*(r-1) + i
                            if idx > p.count-1 {
                                return
                            }
                            
                            let img = UIImage(data: (p[idx] as! PhotoEntity).photo!)!
                            
                            let x = ZHX(contentLabel) + CGFloat(i*90) + CGFloat(i*5)
                            let y = ZHY(contentLabel) + h + CGFloat((r-1)*90) + CGFloat((r-1)*5)
                            let imgView = UIImageView(image: img)
                            imgView.frame = CGRectMake(x, y, 90, 90)
                            imgView.contentMode = UIViewContentMode.ScaleAspectFill
                            imgView.layer.masksToBounds = true
                            self.contentView.addSubview(imgView)
                        }
                    }
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
