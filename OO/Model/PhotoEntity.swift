//
//  PhotoEntity.swift
//  
//
//  Created by ZhangYuting on 15/8/24.
//
//

import Foundation
import CoreData

class PhotoEntity: NSManagedObject {

    @NSManaged var photo: NSData?
    @NSManaged var pid: NSNumber?
    @NSManaged var friend: FriendDetailEntity?
    @NSManaged var forward: FriendDetailEntity?
}
