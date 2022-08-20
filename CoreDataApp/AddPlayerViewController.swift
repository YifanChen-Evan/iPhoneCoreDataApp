//
//  AddPlayerViewController.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 04/04/2022.
//

import UIKit
import CoreData

class AddPlayerViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // define all varibles again in AddPersonViewController screen
    
    // define core data objects (context)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // define core data objects (managed object)
    var pManagedObject : Player! = nil
    
    // define core data objects (entity)
    var pEntity : NSEntityDescription! = nil
    
    // define core data objects (fetch results controller)
    var frc : NSFetchedResultsController <NSFetchRequestResult>! = nil
    
    // outlets
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBOutlet weak var imageTextField: UITextField!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var fromTextField: UITextField!
    
    @IBOutlet weak var positionTextField: UITextField!
    
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBOutlet weak var numTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var profileTextField: UITextField!
    
    @IBOutlet weak var socialTextField: UITextField!
    
    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var pickRoundedCornerButton: UIButton!
    
    // action to save
    @IBAction func addUpdateAction(_ sender: Any) {
        if pManagedObject == nil {
            save()
            navigationController?.popToRootViewController(animated: true)
        } else {
            update()
            navigationController?.viewWillAppear(true)
            
            // after pressing "Add/Update" button, it will reture the PlayersTableViewController screen
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    // create a position option
    let position = ["Center-Forward", "Forward", "Forward-Center", "Forward-Guard", "Guard", "Guard-Forward"]
    var picker: UIPickerView!
    var clickText: UITextField!
    
    // create a date picker
    var datePicker: UIDatePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        positionTextField.delegate = self
        dobTextField.delegate = self
    
        //creat position options
        picker = UIPickerView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:200))
        picker.dataSource = self
        picker.delegate = self
        
        //creat date picker
        datePicker = UIDatePicker(frame: CGRect(x:(UIScreen.main.bounds.size.width-300)/2, y:0, width: 320, height:200))
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // fallback on earlier versions
            
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // setup the TFs
        if pManagedObject != nil {
            imageTextField.text = pManagedObject.image
            nameTextField.text = pManagedObject.name
            fromTextField.text = pManagedObject.from
            positionTextField.text = pManagedObject.position
            dobTextField.text = pManagedObject.dateOfBirth
            numTextField.text = pManagedObject.number
            heightTextField.text = pManagedObject.height
            weightTextField.text = pManagedObject.weight
            profileTextField.text = pManagedObject.profileUrl
            socialTextField.text = pManagedObject.socialUrl
            introTextView.text = pManagedObject.intro
            // get image
            getImage(name: pManagedObject.id!)
        }
        
    }
    
    // date picker response method
    @objc func dateChanged(datePicker : UIDatePicker){
        //Update reminder time text box
        let formatter = DateFormatter()
        //Date style
        formatter.dateFormat = "MM/dd/yyyy"
        self.clickText?.text = formatter.string(from: datePicker.date)
    }
    
    // define functions to deal with data
    
    // define a "update" function to update information
    func update() {
        
        // update the pManagedObject
        pManagedObject.image = imageTextField.text
        pManagedObject.name = nameTextField.text
        pManagedObject.from = fromTextField.text
        pManagedObject.position = positionTextField.text
        pManagedObject.dateOfBirth = dobTextField.text
        pManagedObject.number = numTextField.text
        pManagedObject.height = heightTextField.text
        pManagedObject.weight = weightTextField.text
        pManagedObject.profileUrl = profileTextField.text
        pManagedObject.socialUrl = socialTextField.text
        pManagedObject.intro = introTextView.text
        
        // save id in order to match UIImage
        pManagedObject.id = imageTextField.text
        
        let image = pickedImageView.image
        if image != nil{
            putImage(name: pManagedObject.id!)
        }
        
        do {
            try context.save()
        } catch {
            print("Core Data Cannot Save")
        }

    }
    
    // define a "save" function to save information
    func save() {
        //create a new managed object
        pEntity = NSEntityDescription.entity(forEntityName: "Player", in: context)
        pManagedObject = Player(entity: pEntity, insertInto: context)
        
        saveImage(name: imageTextField.text!)
        
        // update the pManagedObject
        pManagedObject.image = imageTextField.text
        pManagedObject.name = nameTextField.text
        pManagedObject.from = fromTextField.text
        pManagedObject.position = positionTextField.text
        pManagedObject.dateOfBirth = dobTextField.text
        pManagedObject.number = numTextField.text
        pManagedObject.height = heightTextField.text
        pManagedObject.weight = weightTextField.text
        pManagedObject.profileUrl = profileTextField.text
        pManagedObject.socialUrl = socialTextField.text
        pManagedObject.intro = introTextView.text
        
        // save id in order to match UIImage
        pManagedObject.id = imageTextField.text
        
        do {
            try context.save()
        }
        catch {
            print("Core Data Context Cannot Save")
        }
        
        
    }
    
    // define a "saveImage" function to work with images
    func saveImage(name:String) {
        
        // get the file manager
        let fm = FileManager.default
        
        // find the location to Documents to save the file
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        print(path)
        
        // get the image data
        let imageData = pickedImageView.image?.pngData()
        
        // fm create the file
        fm.createFile(atPath: path, contents: imageData, attributes: nil)
    }
    
    // define a "getImage" function to work with images
    func getImage(name:String) {
        
        // find the location to Documents to save the file
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        
        // get the image from the file and place it to image view
        pickedImageView.image = UIImage(contentsOfFile: path)
    }
    
    // save the image from imageView to documents
    func putImage(name:String){

        // file manager
        let fm = FileManager.default
        
        // get the path to where you want to save
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)
        
        // get the image data
        let image = pickedImageView.image
        let imageData = image?.pngData()
        
        // fm to create the file
        fm.createFile(atPath: filePath, contents: imageData, attributes: nil)
    }

    // image picker code
    
    // define a variable named "imagePicker"
    let imagePicker = UIImagePickerController()
    
    // actions
    @IBAction func pickedImageAction(_ sender: Any) {
        // make the attributes of imagePicker
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
        }
        
        // present the picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    // call a "imagePickerController" function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // extract image from info dictionary
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        // place image to image view
        pickedImageView.image = image
        
        // finish the picker
        dismiss(animated: true, completion: nil)
    }
    
    // call a function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.positionTextField {
            textField.inputView = picker
            picker.removeFromSuperview()
            self.clickText = textField
            picker.reloadAllComponents()
        }
        if textField == self.dobTextField {
            textField.inputView = datePicker
            datePicker.removeFromSuperview()
            self.clickText = textField
        }
        return true
    }
    
    var selectCount : Int? = 0
    var selectRow : String? = nil
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if clickText == self.positionTextField {
            selectCount = self.position.count
        }
        return selectCount!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int) -> String?{
        if clickText == self.positionTextField {
            selectRow = position[row]
        }
        return selectRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if clickText == self.positionTextField {
            self.positionTextField.text = position[row]
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
