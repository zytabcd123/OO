//
//  ZHConfig.swift
//  ehuangli_swift
//
//  Created by ZhangYuting on 15/4/17.
//  Copyright (c) 2015 zyt. All rights reserved.
//

import Foundation
import UIKit
import CoreData


// MARK: APP常用色值
func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) ->UIColor{
    
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

let ZHColorBackground = RGBA(173,g: 195,b: 216,a: 1)
let ZHColorBlue = RGBA(51,g: 118,b: 255,a: 1)
let ZHColorDarkBlue = RGBA(30,g: 67,b: 185,a: 1)





// MARK: 坐标系
func kWidth () ->CGFloat{
    
    return UIScreen.mainScreen().bounds.size.width;
}

func kHeight () ->CGFloat{
    
    return UIScreen.mainScreen().bounds.size.height;
}

func ZHX (view : UIView) ->CGFloat{
    
    return view.frame.origin.x;
}

func ZHY (view : UIView) ->CGFloat{
    
    return view.frame.origin.y;
}

func ZHWidth (view : UIView) ->CGFloat{
    
    return view.frame.size.width;
}

func ZHHeight (view : UIView) ->CGFloat{
    
    return view.frame.size.height;
}









// MARK: 时间相关函数
///yyyy-MM-dd
let zh_timeFormatStr1 : String = "yyyy-MM-dd"
///yyyy-MM-dd EEEE
let zh_timeFormatStr2 : String = "yyyy-MM-dd EEEE"
///MM月dd日 aHH:mm
let zh_timeFormatStr3 : String = "M月dd日 aHH:mm"

func zh_formatTime (date : NSDate, format : String) ->String{
    
    let dateFormat : NSDateFormatter = NSDateFormatter()
    dateFormat.locale = NSLocale(localeIdentifier: "zh_CN")
    dateFormat.dateFormat = format
    
    return dateFormat.stringFromDate(date)
}

func zh_formatTimeInterval (time : Double?, format : String) ->String {
    
    if let t = time {
    
        let date = NSDate(timeIntervalSince1970: t)
        
        let dateFormat : NSDateFormatter = NSDateFormatter()
        dateFormat.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormat.dateFormat = format
        
        return dateFormat.stringFromDate(date)
    }
    return ""
}

func zh_formatTimeInterval (time : NSString?, format : String) ->String {
    
    if let t = time {

        let date = NSDate(timeIntervalSince1970: t.doubleValue)
        
        let dateFormat : NSDateFormatter = NSDateFormatter()
        dateFormat.locale = NSLocale(localeIdentifier: "zh_CN")
        dateFormat.dateFormat = format
        
        return dateFormat.stringFromDate(date)
    }

    return ""
}

func zh_formatTimeInterval (timeInterval : Double?) -> String {
    
    if timeInterval == nil{
        return ""
    }
    
    let formdate = NSDate(timeIntervalSince1970: timeInterval!)
    let date = NSDate()
    
    let gregorian = NSCalendar(calendarIdentifier: NSGregorianCalendar)
    let unitflags: NSCalendarUnit = [NSCalendarUnit.NSMonthCalendarUnit, NSCalendarUnit.NSDayCalendarUnit]
    
    let dateFormat = NSDateFormatter()
    dateFormat.locale = NSLocale(localeIdentifier: "zh_CN")

    let com1 = gregorian?.components(unitflags, fromDate: formdate)
    let com2 = gregorian?.components(unitflags, fromDate: date)

    if com1?.month == com2?.month && com1?.day == com2?.day {
        
        dateFormat.dateFormat = "HH:mm"
        return "今天 \(dateFormat.stringFromDate(formdate))"
        
    }else if com1?.month == com2?.month && com1?.day == (com2!.day-1) {
        
        dateFormat.dateFormat = "HH:mm"
        return "昨天 \(dateFormat.stringFromDate(formdate))"
    }else {
        
        dateFormat.dateFormat = "yyyy-MM-dd"
        return "\(dateFormat.stringFromDate(formdate))"
    }
}

func zh_getCurrentTime (format : String) ->String{
    
    let dateFormat : NSDateFormatter = NSDateFormatter()
    dateFormat.locale = NSLocale(localeIdentifier: "zh_CN")
    dateFormat.dateFormat = format
    
    return dateFormat.stringFromDate(NSDate())
}

func zh_getCurrentTimeInterval() -> NSTimeInterval {
    
    return NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970
}


extension UIViewController {
    
    /**
     显示actionSheet
     
     - parameter title:          标题
     - parameter msg:            信息
     - parameter actions:        按钮
     - parameter didSelectBlock: 按钮回调，idx为actions数组的下标
     */
    func showActionSheet(title: String? = nil, msg: String? = nil, actions: NSArray, didSelectBlock: ((idx: Int) -> Void)? = nil){
        
        if #available(iOS 8.0, *) {
        
            let actionSheet = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (ac) -> Void in
                
                if didSelectBlock != nil {
                    
                    didSelectBlock!(idx : -1)
                }
                actionSheet.dismissViewControllerAnimated(true, completion: nil)
            }
            actionSheet.addAction(cancel)
            
            for (idx, str) in actions.enumerate(){
                
                let action = UIAlertAction(title: (str as! String), style: UIAlertActionStyle.Default) { (ac) -> Void in
                    
                    print("\(idx),\(str)")
                    if didSelectBlock != nil {
                        
                        didSelectBlock!(idx : idx)
                    }
                }
                actionSheet.addAction(action)
            }
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }else {
        
            let t = title ?? "" + "\n" + (msg ?? "")
            let ac = UIActionSheet(title: t, delegate: nil, cancelButtonTitle: nil, destructiveButtonTitle: nil)
            for (_, str) in actions.enumerate(){
                
                ac.addButtonWithTitle(str as? String)
            }
            ac.addButtonWithTitle("取消")
            ac.showInView(UIApplication.sharedApplication().keyWindow!)
            
            ac.rac_buttonClickedSignal().subscribeNext { (x) -> Void in
                
                let xx = x.integerValue
                let s = ac.buttonTitleAtIndex(xx)
                if s == "取消" {
                    
                    ac.dismissWithClickedButtonIndex(xx, animated: false)
                    if didSelectBlock != nil {
                        
                        didSelectBlock!(idx : -1)
                    }
                }else {
                    
                    if didSelectBlock != nil {
                        
                        didSelectBlock!(idx : xx)
                    }
                }
            }
        }

    }
    
    /**
     显示Alertview
     
     - parameter title:          警告标题
     - parameter msg:            警告内容
     - parameter actions:        警告操作按钮
     - parameter didSelectBlock: 按钮回调，idx为actions数组的下标
     */
    func showAlert(title: String? = nil, msg: String? = nil, actions: NSArray, didSelectBlock: ((idx: Int) -> Void)? = nil){
        
        if #available(iOS 8.0, *) {
        
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            
            for (idx, str) in actions.enumerate(){
                
                let action = UIAlertAction(title: str as? String, style: UIAlertActionStyle.Default) { (ac) -> Void in
                    
                    print("\(idx),\(str)")
                    if didSelectBlock != nil {
                        
                        didSelectBlock!(idx : idx)
                    }
                }
                alert.addAction(action)
            }
            
            self.presentViewController(alert, animated: true, completion: nil)

        }else {
        
            let ac = UIAlertView(title: title, message: msg, delegate: nil, cancelButtonTitle: nil)
            for (_, str) in actions.enumerate(){
                
                ac.addButtonWithTitle(str as? String)
            }
            ac.show()
            
            ac.rac_buttonClickedSignal().subscribeNext { (x) -> Void in
                
                let xx = x.integerValue
                if didSelectBlock != nil {
                    
                    didSelectBlock!(idx : xx)
                }
            }
        }
    }
}


extension UILabel {
    
    func alignTopLeft() {
        
//        for _ in 0...self.numberOfLines {
            if let s = self.text {
                self.text = "\(s)\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\\n\n\n\n\\n\n\n\\n\n\n\\n\n\n\\n\n\n\n\\n\n\n\n\n\\n\n\n\n\\n\n\n\n"
            }
//        }
//        print(self.text)
    }
}


func textHeight(text : String?, maxWidth : CGFloat, minHeight : CGFloat, font : UIFont) ->CGFloat {
    
    if let s = text {
        
        let size = NSString(string: s).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
        
        return size.height > minHeight ? size.height - minHeight : 0
    }
    
    return CGFloat(0)
}

func textHeight(text : String?, photos : NSSet?, maxWidth : CGFloat, minHeight : CGFloat, font : UIFont) ->CGFloat {
    
    var ph = CGFloat(0)
    if let p = photos {
        
        switch p.count {
        case 1 :
            ph = 180
        case 2,3 :
            ph = 90
        case 4,5,6 :
            ph = 185
        case 7,8,9 :
            ph = 280
        default :
            ph = 0
        }
    }
    
    if let s = text {
        
        let size = NSString(string: s).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
        
        return size.height > minHeight ? size.height - minHeight + ph : ph
    }else {
        
        ph = (ph - 21) > 0 ? (ph - 21) : 0
    }
    
    return ph
}




















// MARK: 数据库相关
func countOfEntity(entityName : String) -> Int {
    
    let request = NSFetchRequest(entityName: entityName)
    request.returnsObjectsAsFaults = false
    
    return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext.countForFetchRequest(request, error: nil)
}

func getAllUsers() -> [UserEntity]? {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let entity = NSEntityDescription.entityForName("UserEntity", inManagedObjectContext: delegate.managedObjectContext)
    
    let request = NSFetchRequest()
    request.returnsObjectsAsFaults = false
    request.entity = entity
    
    do {
        let u = try delegate.managedObjectContext.executeFetchRequest(request) as! [UserEntity]
        return u
    }catch {
        print(error)
        return nil
    }
}

func getDefaultUser() -> UserEntity? {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let entity = NSEntityDescription.entityForName("UserEntity", inManagedObjectContext: delegate.managedObjectContext)
    
    let request = NSFetchRequest()
    let uid = NSUserDefaults.standardUserDefaults().integerForKey("defaultUser")
    request.predicate = NSPredicate(format: "uid contains '\(uid)'")
    request.returnsObjectsAsFaults = false
    request.entity = entity
    
    do {
        let u = try delegate.managedObjectContext.executeFetchRequest(request) as! [UserEntity]
        
        return u.first
    }catch {
        print(error)
        return nil
    }
}

func getUserFrindList() ->[FriendDetailEntity]? {
    
    if let u = getDefaultUser() {
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let entity = NSEntityDescription.entityForName("FriendDetailEntity", inManagedObjectContext: delegate.managedObjectContext)
        
        let request = NSFetchRequest()
        request.predicate = NSPredicate(format: "user.uid contains '\(u.uid!)'")
        request.returnsObjectsAsFaults = false
        request.entity = entity
        
        do {
            let s = try delegate.managedObjectContext.executeFetchRequest(request) as? [FriendDetailEntity]
            
            return s
        }catch {
            print(error)
            return nil
        }
    }
    return nil
}







