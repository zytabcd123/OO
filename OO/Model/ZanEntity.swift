//
//  ZanEntity.swift
//  
//
//  Created by ZhangYuting on 15/8/14.
//
//

import Foundation
import CoreData

class ZanEntity: NSManagedObject {

    @NSManaged var user: UserEntity?
    @NSManaged var friend: FriendDetailEntity?
}
