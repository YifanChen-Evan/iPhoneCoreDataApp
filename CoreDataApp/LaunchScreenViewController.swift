//
//  LaunchScreenViewController.swift
//  Player Data
//
//  Created by 橙子🍊 on 14/03/2022.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 340, height: 175))
        imageView.image = UIImage(named: "NBA.png")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {self.animate()})
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = size - self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
        })
        
        UIView.animate(withDuration: 1.5, animations: {self.imageView.alpha = 0})
    }

}
