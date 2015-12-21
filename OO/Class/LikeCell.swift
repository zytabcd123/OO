//
//  LikeCell.swift
//  OO
//
//  Created by ovfun on 15/12/21.
//  Copyright © 2015年 @天意. All rights reserved.
//

import UIKit

class LikeCell: UITableViewCell {

    @IBOutlet weak var bgView : UIView!
    @IBOutlet weak var likeBt : UIButton!

    var list : NSSet? = NSSet(){
            
        didSet{
            
            if let s = list?.allObjects {
                let numOfARow = Int(abs((kWidth() - 20 - 36)/40))
                let row = s.count <= numOfARow ? 1 : (s.count/numOfARow + 1)
                
                for r in 1...row {
                    for i in 0...numOfARow {

                        let idx = numOfARow*(r-1) + i
                        if idx > s.count-1 {
                            return
                        }
                        
                        let e = s[idx] as! ZanEntity
                        let img = UIImageView(image: UIImage(data: e.user!.avatar!))
                        
                        let x = 36 + i*35 + i*5
                        let y = 8 + (r-1)*35 + (r-1)*5
                        img.frame = CGRectMake(CGFloat(x), CGFloat(y), 35, 35)
                        self.bgView.addSubview(img)
                    }
                }
            }
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
