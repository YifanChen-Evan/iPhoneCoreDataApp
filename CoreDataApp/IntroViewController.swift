//
//  IntroViewController.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 04/04/2022.
//

import UIKit
import AVFoundation
import CoreData

class IntroViewController: UIViewController {
    
    // outlets
    @IBOutlet var playerButton: UIButton!
    
    @IBOutlet weak var audioPlayerBox: UIView!
    
    @IBOutlet weak var playerImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var profileRoundedCornerButton: UIButton!
    
    @IBOutlet weak var socialRoundedCornerButton: UIButton!
    
    // action (to play a background music)
    @IBAction func didTapButton() {
        if let play = audioPlayer, play.isPlaying {
            
            // stop playback
            audioPlayer?.stop()
        } else {
            // set up audio and play
            let urlString = Bundle.main.path(forResource: "Outside", ofType: "mp3")
            
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else {
                    return
                }
                
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                
                guard let play = audioPlayer else {
                    return
                }
                
                audioPlayer?.play()

            } catch {
                print("Something Went Wrong")
            }
        }
    }

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pEntity: NSEntityDescription! = nil
    var pManagedObject : Player! = nil
    
    // create a music player
    var audioPlayer : AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField.text = pManagedObject.name
        playerImageView.image = getImage(name: pManagedObject.id!)
        introTextView.text = pManagedObject.intro
        
        // display button style
        playerButton.setBackgroundImage(UIImage(named: "audioPlayer"), for: .normal)
        
        profileRoundedCornerButton.layer.cornerRadius = 15
        profileRoundedCornerButton.layer.borderWidth = 2
        profileRoundedCornerButton.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
        
        socialRoundedCornerButton.layer.cornerRadius = 15
        socialRoundedCornerButton.layer.borderWidth = 2
        socialRoundedCornerButton.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
        
        audioPlayerBox.layer.cornerRadius = 15
        audioPlayerBox.layer.borderWidth = 2
        audioPlayerBox.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
        audioPlayerBox.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        audioPlayerBox.layer.shadowOpacity = 0.8
    }

    func getImage(name:String) -> UIImage!{
        // get the absolute path to the image in documents
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = docPath.appendingPathComponent(name)

        return UIImage(contentsOfFile: filePath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // check if the segue is correct and to show profile website
        if segue.identifier == "segue3" {
            
            // Get the new view controller using segue.destination.
            let destController = segue.destination as! WebViewController
            
            destController.urlData = pManagedObject.profileUrl!
        }
        
        // check if the segue is correct and to show social media website
        if segue.identifier == "segue4" {
            
            // Get the new view controller using segue.destination.
            let destController = segue.destination as! WebViewController
            
            destController.urlData = pManagedObject.socialUrl!
        }

    }
}
