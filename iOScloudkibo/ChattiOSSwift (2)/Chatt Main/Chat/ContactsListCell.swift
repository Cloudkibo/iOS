//
//  ContactsListCell.swift
//  Chat
//
//  Created by Cloudkibo on 23/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit

class ContactsListCell:UITableViewCell {
    
    
    @IBOutlet weak var participantsCollection: UICollectionView!
    @IBOutlet weak var statusPrivate: UILabel!
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var btnGreenDot: UIButton!
    
    @IBOutlet weak var ImgChatArrow: UIImageView!

    @IBOutlet weak var imgChatLock: UIImageView!
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var contactNamePublic: UILabel!
    @IBOutlet weak var btnGreenPublic: UIButton!
    @IBOutlet weak var statusPublic: UILabel!
    
    @IBOutlet weak var lbltimePrivate: UILabel!
    @IBOutlet weak var newMsg: UIButton!
    @IBOutlet weak var countNewmsg: UILabel!
    @IBOutlet weak var btnBroadcastLists: UIButton!
    @IBOutlet weak var btnNewGroupOutlet: UIButton!
    @IBOutlet weak var lbl_participantsNumberFromOne: UITextView!
    
    /* override func awakeFromNib() {
    @IBOutlet weak var contactNamePublic: UILabel!
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }*/

}