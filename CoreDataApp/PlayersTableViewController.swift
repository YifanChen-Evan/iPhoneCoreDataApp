//
//  PlayersTableViewController.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 04/04/2022.
//

import UIKit
import CoreData

class PlayersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // define core data objects (context)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // define core data objects (managed object)
    var pManagedObject : Player! = nil
    
    // define core data objects (entity)
    var pEntity : NSEntityDescription! = nil
    
    // define core data objects (fetch results controller)
    var frc : NSFetchedResultsController<NSFetchRequestResult>! = nil
    
    var sectionArr: [String: [String: Any]] = [:]
    var titleArr: [String] = []
    
    // define core data functions
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        // define predicates and sorters
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleArr = []
        sectionArr = [:]
        do {
            try frc.performFetch()
            if frc.sections![0].numberOfObjects == 0 {
                let playersData = Players(fromXMLFile: "players.xml")
                playersData.savePlayers()
            }
            
            frc.sections![0].objects?.forEach({ item in
                let itemK = item as! Player
                if (titleArr.contains(itemK.position!)) {
                    var dict = sectionArr[itemK.position!]!
                    var list = dict["list"] as! [Player]
                    list.append(itemK)
                    dict["list"] = list
                    sectionArr[itemK.position!]! = dict
                } else {
                    sectionArr[itemK.position!] = ["select": true,"list": [itemK]]
                    titleArr.append(itemK.position!)
                }
            })
            tableView.reloadData()
        } catch {
            print("Core Data Cannot Fetch")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // frc gets the data from "Player" class
        frc = NSFetchedResultsController(fetchRequest: makeRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
            if frc.sections![0].numberOfObjects == 0 {
                let playersData = Players(fromXMLFile: "players.xml")
                playersData.savePlayers()
            }
            
            frc.sections![0].objects?.forEach({ item in
                let itemK = item as! Player
                if (titleArr.contains(itemK.position!)) {
                    var dict = sectionArr[itemK.position!]!
                    var list = dict["list"] as! [Player]
                    list.append(itemK)
                    dict["list"] = list
                    sectionArr[itemK.position!]! = dict
                } else {
                    sectionArr[itemK.position!] = ["select": true,"list": [itemK]]
                    titleArr.append(itemK.position!)
                }
            })
        } catch {
            print("Core Data Cannot Fetch")
        }

    }
    
    // call a function to reload tableView after modifing information
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return titleArr.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       let str = titleArr[section]
        let dict = sectionArr[str]!
        if (dict["select"] as! Bool) {
            return (dict["list"] as! [Player]).count
        } else {
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45))
        view.text = "  \(titleArr[section])"
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickSection(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        view.tag = 200+section
        return view
    }
    
    @objc func clickSection(sender: UITapGestureRecognizer) {
        let str = titleArr[sender.view!.tag-200]
        var dict = sectionArr[str]!
        dict["select"] = !(dict["select"] as! Bool)
        sectionArr[str] = dict
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayersTableViewCell
        
        let dict = sectionArr[titleArr[indexPath.section]]!
        pManagedObject = (dict["list"] as! [Player])[indexPath.row] as? Player
        
        // Configure the cell...
        
        // show player's name
        cell.playerName!.text = pManagedObject.name
        
        // show player's birthday
        cell.birthday.text = pManagedObject.dateOfBirth
        
        // show player's position
        cell.playerPosition!.text = pManagedObject.position
        
        // show player's number
        cell.playerNumber!.text = pManagedObject.number
        
        // make the imageView display player's image
        cell.playerImageView.image = getImage(name: pManagedObject.id ?? "")
        
        // favorite button
        cell.collectBtn.isSelected = pManagedObject.collect
        
        cell.clickCollect = { [self]() in
            let dict = sectionArr[titleArr[indexPath.section]]!
            let obj = (dict["list"] as! [Player])[indexPath.row] as? Player
             obj?.collect = !obj!.collect
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                print("Core Data Cannot Fetch")
            }
            
            // define core data objects (context)
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // define core data objects (managed object)
            var pEntity: NSEntityDescription! = nil

            // define core data objects (entity)
            pEntity = NSEntityDescription.entity(forEntityName: "Collect", in: context)
            
            let collect = Collect(entity: pEntity, insertInto: context)
            collect.id = obj?.id
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                print("Core Data Cannot Fetch")
            }
        }
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //delete the row from the data source
            pManagedObject = frc.object(at: indexPath) as? Player
            
            if pManagedObject.image != nil{
                deleteImage(name: pManagedObject.image!)
            }
            context.delete(pManagedObject)
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                print("Core Data Cannot Fetch")
            }
            
            titleArr = []
            sectionArr = [:]
            do {
                try frc.performFetch()
                if frc.sections![0].numberOfObjects == 0 {
                    let playersData = Players(fromXMLFile: "players.xml")
                    playersData.savePlayers()
                }
                
                frc.sections![0].objects?.forEach({ item in
                    let itemK = item as! Player
                    if (titleArr.contains(itemK.position!)) {
                        var dict = sectionArr[itemK.position!]!
                        var list = dict["list"] as! [Player]
                        list.append(itemK)
                        dict["list"] = list
                        sectionArr[itemK.position!]! = dict
                    } else {
                        sectionArr[itemK.position!] = ["select": true,"list": [itemK]]
                        titleArr.append(itemK.position!)
                    }
                })
                tableView.reloadData()
            } catch {
                print("Core Data Cannot Fetch")
            }
        }
    }
    
    func getImage(name:String)->UIImage!{
        // get the absolute path to the image in documents
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)

        return UIImage(contentsOfFile: filePath)
    }

    func deleteImage(name:String){
        // get the absolute path to the image in documents
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        // get filemanage
        let fm = FileManager.default
        
        // delete
        do {
            try fm.removeItem(atPath: filePath)
        } catch {
            
        }
    }

    // actions
    
    // show AddPlayerViewController screen
    @IBAction func showAdd(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "Add") as? AddPlayerViewController else {print("push to add player fail")
            return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // show NBA game list screen
    @IBAction func showNBA(_ sender: Any) {
        guard let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "NBA") as? NBAViewController else {print("push to NBA fail")
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // check if the segue between First Screen and Second Screen named "segue1"
        if segue.identifier == "segue1" {
            
            // Get the new view controller using segue.destination.
            let destController = segue.destination as! DetailsViewController
            
            // find indexPath of sender
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            
            let dict = sectionArr[titleArr[indexPath!.section]]!
            let obj = (dict["list"] as! [Player])[indexPath!.row] as? Player
            
            // Pass the selected object to the new view controller.
            pManagedObject = obj
            print(pManagedObject.id)
            print(pManagedObject.image)
            // push data
            destController.pManagedObject = pManagedObject
        }

    }
    

}
