//
//  DataManager.swift
//  Coredata-Demo
//
//  Created by Deepak Tanwar on 01/06/23.
//

import Foundation
import CoreData
import UIKit


/*we are using curd operation here*/


struct DataManager {
    
    
    private var context : NSManagedObjectContext  {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func create(data : UserData){
        //User is our coredata entity
        let userinfo   = User(context: context)
        /*User entity attributes*/
        userinfo.name  =    data.fullname
        userinfo.email =    data.email
        userinfo.image =    data.img
        userinfo.password = data.pwd
        userinfo.addedon = Date()
        /*saving data via savecontext*/
         saveContext()
    }
    
    func read() -> [User] {
        var userData : [User] = []
        do {
                let request = User.fetchRequest()
                let sort = NSSortDescriptor(key: "addedon", ascending: false)
                request.sortDescriptors = [sort]
            userData =   try context.fetch(request)
        } catch  {
            print("Error while fetching data", error)
        }
        return userData
    }
    
    func update(data : UserData, entityUser : User){
        entityUser.name = data.fullname
        entityUser.email = data.email
        entityUser.password = data.pwd
        entityUser.image = data.img
        saveContext()
    }
    
    func delete(user : User){
        if deleteImage(imageName: user.image!){
            context.delete(user)
            saveContext()
        }
    }
    
    func deleteImage(imageName : String) -> Bool {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL  = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName + ".png")
            do {
                try FileManager.default.removeItem(at: imageURL)
            } catch  {
                print("remove image from directory", error)
            }
            return true
        }
        return false
    }
    
    private func saveContext(){
        do {
            try context.save()
            print("data saved successfuly")
        } catch  {
            print("User saving error:", error)
        }
    }
    
    
}
