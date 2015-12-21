//
//  FriendDetailEntity.swift
//  
//
//  Created by ZhangYuting on 15/8/14.
//
//

import Foundation
import CoreData

class FriendDetailEntity: NSManagedObject {

    @NSManaged var content: String?
    @NSManaged var ctime: NSNumber?
    @NSManaged var fid: NSNumber?
    @NSManaged var type: NSNumber?
    @NSManaged var forwardContent: String?
    @NSManaged var com: NSSet?
    @NSManaged var photos: NSSet?
    @NSManaged var user: UserEntity?
    @NSManaged var zan: NSSet?
    @NSManaged var forwardPhoto: PhotoEntity?
}
