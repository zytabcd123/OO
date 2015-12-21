//
//  HUD.swift
//  Education
//
//  Created by ovfun on 15/12/9.
//  Copyright © 2015年 牛至网. All rights reserved.
//

import Foundation

struct HUD {
    
    private static var hud: MBProgressHUD?
    
    static func showInKeyWindow(mode: MBProgressHUDMode = .Indeterminate, title: String? = nil, delayHide: NSTimeInterval? = nil) {
        
        if hud == nil {
            
            hud = MBProgressHUD(window: UIApplication.sharedApplication().keyWindow)
        }
        hud?.hide(false)
        
        UIApplication.sharedApplication().keyWindow?.addSubview(hud!)
        hud?.mode = mode
        hud?.labelText = title
        hud?.show(true)
        
        if let d = delayHide {
            
            HUD.hide(true, delayHide: d)
        }
    }
    
    static func showInView(view: UIView, mode: MBProgressHUDMode = .Indeterminate, title: String? = nil, delayHide: NSTimeInterval? = nil) {
        
        if hud == nil {
            
            hud = MBProgressHUD(view: view)
        }
        hud?.hide(false)
        
        view.addSubview(hud!)
        hud?.mode = mode
        hud?.labelText = title
        hud?.show(true)
        
        if let d = delayHide {
            
            HUD.hide(true, delayHide: d)
        }
    }
    
    static func hide(animat: Bool = true, delayHide: NSTimeInterval? = nil) {
        
        hud?.hide(animat, afterDelay: delayHide ?? 0)
    }
}

extension UIView {
    
    func showHUD(mode: MBProgressHUDMode = .Indeterminate, title: String? = nil, delayHide: NSTimeInterval? = nil) {
        
        HUD.showInView(self, mode: mode, title: title, delayHide: delayHide)
    }
}

extension UIViewController {
    
    func showHUD(mode: MBProgressHUDMode = .Indeterminate, title: String? = nil, delayHide: NSTimeInterval? = nil) {
        
        HUD.showInView(self.view, mode: mode, title: title, delayHide: delayHide)
    }
}
