//
//  User.swift
//  BagCam
//
//  Created by Pankaj Patel on 17/02/21.
//

import CoreData

var _user: User!

/// User
class User: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var email: String
    
    func initWith(_ dict: [String: Any]) {
        id = dict.string("id")
        email = dict.string("email")
    }
    
    class func getUser() -> User? {
        let fetch: NSFetchRequest<User> = NSFetchRequest<User>()
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "User", in: CoreDatabaseManager.shared.viewContext)
        fetch.entity = entity
        do {
            let arrUser = try CoreDatabaseManager.shared.viewContext.fetch(fetch)
            return arrUser.first
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
    
    class func createOrUpdateUser(_ dict: [String: Any]) {
        if let user = self.getUser() {
            user.initWith(dict)
            _user = user
        } else {
            /// Creating new user for the first time
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: CoreDatabaseManager.shared.viewContext) as! User
            user.initWith(dict)
            _user = user
        }
        CoreDatabaseManager.shared.saveContext()
    }
}
