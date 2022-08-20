//
//  Players.swift
//  Player Data
//
//  Created by 橙子🍊 on 09/03/2022.
//

import Foundation

// define a class called "Players"
class Players {
    
    // define a variable array list named "data" to store the name, from, position, dateOfBirth, number, image of each player
    // data is an array of an array of Player objects
    var data : [DefaultPlayer]!
    
    init(fromXMLFile file:String) {
        //make data from the XML using a parser
        let parser = XMLPlayersParser(name: file)
        parser.startParsing()
        self.data = parser.playerData
    }
    
    func savePlayers(){
        for i in 0..<self.data.count{
            data[i].savePlayer()
        }
    }
    
}
