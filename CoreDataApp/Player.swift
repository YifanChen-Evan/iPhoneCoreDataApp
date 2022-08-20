//
//  Player.swift
//  Player Data
//
//  Created by 橙子🍊 on 09/03/2022.
//

import Foundation
import UIKit
import CoreData

// define a class called DefaultPlayer
class DefaultPlayer {
    // properties
    var name : String
    var from : String
    var position : String
    var dateOfBirth : String
    var number : String
    var image : String
    var height : String
    var weight : String
    var intro : String
    var profileUrl : String
    var socialUrl : String
    
    // to initialize the class "Player"
    init() {
        self.name = "name"
        self.from = "from"
        self.position = "position"
        self.dateOfBirth = "date"
        self.number = "num"
        self.image = "player.png"
        self.height = "height"
        self.weight = "weight"
        self.intro = "intro"
        self.profileUrl = "profileUrl"
        self.socialUrl = "socialUrl"
    }
    
    init(name:String, from:String, position:String, dateOfBirth:String, number:String, image:String, height:String, weight:String, intro:String, profileUrl:String, socialUrl:String) {
        self.name = name
        self.from = from
        self.position = position
        self.dateOfBirth = dateOfBirth
        self.number = number
        self.image = image
        self.height = height
        self.weight = weight
        self.intro = intro
        self.profileUrl = profileUrl
        self.socialUrl = socialUrl
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity: NSEntityDescription! = nil
    
    func savePlayer(){
        //create a new managed object
        pEntity = NSEntityDescription.entity(forEntityName: "Player", in: context)
        
        let pManagedObject = Player(entity: pEntity, insertInto: context)
        
        let uuid =  UUID().uuidString;
        
        //update managed object with text from fields
        pManagedObject.id = uuid
        pManagedObject.name = self.name
        pManagedObject.from = self.from
        pManagedObject.position = self.position
        pManagedObject.dateOfBirth = self.dateOfBirth
        pManagedObject.number = self.number
        pManagedObject.image = self.image
        pManagedObject.height = self.height
        pManagedObject.weight = self.weight
        pManagedObject.intro = self.intro
        pManagedObject.profileUrl = self.profileUrl
        pManagedObject.socialUrl = self.socialUrl
        
        let image =  UIImage(named: self.image, in: Bundle.main, with:nil)
        let fm = FileManager.default
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(uuid)
        let imageData = image?.pngData()
        
        fm.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
        //save
        do {
            try context.save()
        } catch {
            print("Core Data Cannot Save")
        }
    }
}
