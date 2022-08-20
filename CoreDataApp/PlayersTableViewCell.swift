//
//  PlayersTableViewCell.swift
//  CoreDataApp
//
//  Created by 橙子🍊 on 05/04/2022.
//

import UIKit

class PlayersTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerPosition: UILabel!
    @IBOutlet weak var playerNumber: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var collectBtn: UIButton!
    
    var clickCollect: (() -> Void)?
    
    override func awakeFromNib() {
        collectBtn.addTarget(self, action: #selector(clickCollectAction(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func clickCollectAction(sender: UIButton) -> Void {
        clickCollect!()
    }
}
