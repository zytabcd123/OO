//
//  UserEntity.swift
//  
//
//  Created by ZhangYuting on 15/8/14.
//
//

import Foundation
import CoreData

@objc
protocol UserEntityDelegate : NSObjectProtocol{
    
    optional func entityHasChanged(obj : AnyObject?, m : UserEntity?)
}

class UserEntity: NSManagedObject {

    @NSManaged var avatar: NSData?
    @NSManaged var name: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var detail: NSSet?
    @NSManaged var com: NSSet?
    @NSManaged var zan: NSSet?
}
