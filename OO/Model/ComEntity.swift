//
//  ComEntity.swift
//  
//
//  Created by ZhangYuting on 15/8/14.
//
//

import Foundation
import CoreData

class ComEntity: NSManagedObject {

    @NSManaged var cid: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var ctime: NSNumber?
    @NSManaged var rename: String?
    @NSManaged var user: UserEntity?
    @NSManaged var friend: FriendDetailEntity?
}
