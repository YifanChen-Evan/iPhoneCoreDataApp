//
//  XMLPlayersParser.swift
//  Player Data
//
//  Created by 橙子🍊 on 09/03/2022.
//

import Foundation

class XMLPlayersParser : NSObject, XMLParserDelegate {
    
    // property + init
    var name : String
    init(name:String) {
        self.name = name
    }
    
    // define variables seperately to store the data from xml tags
    var pName, pFrom, pPosition, pDateOfBirth, pNumber, pImage, pHeight, pWeight, pIntro, pProfileUrl, pSocialUrl: String!
    
    // define variable array list named "tags" to store all tags in order
    var tags = ["name", "from", "position", "dateOfBirth", "number", "image", "height", "weight", "intro", "profileUrl", "socialUrl"]
    
    // define variable to spy on data
    var elementId = -1
    var passData = false
    
    // define variable named "playerData" by "DefaultPlayer" class
    var playerData = [DefaultPlayer]()
    
    // define variable named "parser" to analyze structure
    var parser : XMLParser!
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // check if elementId is in tags
        if tags.contains(elementName) {
            passData = true
            switch elementName {
                case "name" : elementId = 0
                case "from" : elementId = 1
                case "position" : elementId = 2
                case "dateOfBirth" : elementId = 3
                case "number" : elementId = 4
                case "image" : elementId = 5
                case "height" : elementId = 6
                case "weight" : elementId = 7
                case "intro" : elementId = 8
                case "profileUrl" : elementId = 9
                case "socialUrl" : elementId = 10
                
            default:
                break
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // check passData and elementId
        if passData {
            switch elementId {
                case 0 : pName = string
                case 1 : pFrom = string
                case 2 : pPosition = string
                case 3 : pDateOfBirth = string
                case 4 : pNumber = string
                case 5 : pImage = string
                case 6 : pHeight = string
                case 7 : pWeight = string
                case 8 : pIntro = string
                case 9 : pProfileUrl = string
                case 10 : pSocialUrl = string
                
            default:
                break
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        // check the tags and block the spies
        if tags.contains(elementName) {
            passData = false
            elementId = -1
        }

        // find <person>
        if elementName == "person" {
            
            // get data and store them in "playerData" variable
            playerData.append(DefaultPlayer(name: pName, from: pFrom, position: pPosition, dateOfBirth: pDateOfBirth, number: pNumber, image: pImage, height: pHeight, weight: pWeight, intro: pIntro, profileUrl: pProfileUrl, socialUrl: pSocialUrl))
        }
    }
    
    // start parsing
    func startParsing(){
        //get to the xml file
        let bundlePath = Bundle.main.bundleURL
        let xmlPath = URL(fileURLWithPath: self.name, relativeTo: bundlePath)
        
        parser = XMLParser(contentsOf: xmlPath)
        parser.delegate = self
        parser.parse()
    }
}
