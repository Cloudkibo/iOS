//
//  ContactsListCell.swift
//  Chat
//
//  Created by Cloudkibo on 23/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit

class PendingRequestsListCell:UITableViewCell {
    
    @IBOutlet weak var labelFriendName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    
    /*
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var btnGreenDot: UIButton!
    
    @IBOutlet weak var ImgChatArrow: UIImageView!

    @IBOutlet weak var imgChatLock: UIImageView!
    
    @IBOutlet weak var profilePic: UIImageView!
*/
    
    
   override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}