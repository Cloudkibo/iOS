//
//  GroupInfoCells.swift
//  kiboApp
//
//  Created by Cloudkibo on 27/10/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit

class GroupInfoCell:SWTableViewCell {

    @IBOutlet weak var btnAddPatricipants: UIButton!

    @IBOutlet weak var btnExportChat: UIButton!
    @IBOutlet weak var profilePicParticipants: UIImageView!
    @IBOutlet weak var lbl_participant_name: UILabel!
    
    @IBOutlet weak var lbl_participant_status: UILabel!
    
    @IBOutlet weak var lbl_groupAdmin: UILabel!
    @IBOutlet weak var btn_exitGroup: UIButton!
    @IBOutlet weak var btnClearChat: UIButton!
}