//
//  WebViewController.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 04/04/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var WebsiteView: WKWebView!

    // define a variable
    var urlData : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(urlData)
        guard let url = URL(string: self.urlData) else { return }
        self.WebsiteView.load(URLRequest(url: url))
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
