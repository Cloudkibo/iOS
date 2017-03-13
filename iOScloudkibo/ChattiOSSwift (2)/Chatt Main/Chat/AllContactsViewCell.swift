//
//  AllContactsViewCell.swift
//  kiboApp
//
//  Created by Cloudkibo on 03/06/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit

class AllContactsCell:UITableViewCell {

    @IBOutlet weak var btnGreenDot: UIButton!
    @IBOutlet weak var inviteToCloudKibo: UIButton!
    @IBOutlet weak var labelNamePrivate: UILabel!

    @IBOutlet weak var labelStatusPrivate: UILabel!
    
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_contactName: UILabel!
    
    @IBOutlet weak var profileAvatar: UIImageView!
    

    @IBOutlet weak var lbl_phone: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var img_avatar: UIImageView!
    
    
    @IBOutlet weak var lbl_new_name: UILabel!
    @IBOutlet weak var lbl_new_subtitle: UILabel!
    @IBOutlet weak var btn_lbl_blockContact: UILabel!
}
