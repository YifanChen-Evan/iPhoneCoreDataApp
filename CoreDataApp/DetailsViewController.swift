//
//  DetailsViewController.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 04/04/2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    // outlets
    @IBOutlet weak var collectBtn: UIButton!

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var introRoundedCornerButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity: NSEntityDescription! = nil
    var pManagedObject : Player! = nil
    var frc : NSFetchedResultsController <NSFetchRequestResult>! = nil
    
    func makeRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        
        // define predicates and sorters
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        
        return request
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getInformation()
        
        // display button style
        introRoundedCornerButton.layer.cornerRadius = 15
        introRoundedCornerButton.layer.borderWidth = 2
        introRoundedCornerButton.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
        
        collectBtn.isSelected = pManagedObject.collect
        
        collectBtn.addTarget(self, action: #selector(clickCollectAction(sender:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func clickCollectAction(sender: UIButton) -> Void {
       
        pManagedObject.collect = !pManagedObject.collect
        
        do {
            try context.save()
            collectBtn.isSelected = pManagedObject.collect
        } catch {
            print("Core Data Cannot Fetch")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInformation()
    }
    
    func getInformation(){
        logoImageView.image = UIImage(named:"logo.png")
        nameLabel.text = pManagedObject.name
        fromLabel.text = pManagedObject.from
        positionLabel.text = pManagedObject.position
        dobLabel.text = pManagedObject.dateOfBirth
        numLabel.text = pManagedObject.number
        heightLabel.text = pManagedObject.height
        weightLabel.text = pManagedObject.weight
        playerImageView.image = getImage(name: pManagedObject.id ?? "")
    }
    
    func getImage(name:String) -> UIImage!{
        // get the absolute path to the image in documents
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        return UIImage(contentsOfFile: filePath)
    }
    
    func putImage(name:String){
        
        // file manager
        let fm = FileManager.default
        
        // get the path to where you want to save
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        // get the image data
        let playerImage = playerImageView.image
        let imageData = playerImage?.pngData()
        
        // fm to create the file
        fm.createFile(atPath: filePath, contents: imageData, attributes: nil)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "segue2"{
             // Get the new view controller using segue.destination.
             let destController = segue.destination as! IntroViewController
             print(self.pManagedObject.id)
             print(self.pManagedObject.image)
             destController.pManagedObject = self.pManagedObject
         }
         
         // pass data from edit screen (AddPlayerViewController) to detail screen
         if segue.identifier == "segue6"{
             // Get the new view controller using segue.destination.
             let destController = segue.destination as! AddPlayerViewController
             
             destController.pManagedObject = self.pManagedObject
         }
     }

}
