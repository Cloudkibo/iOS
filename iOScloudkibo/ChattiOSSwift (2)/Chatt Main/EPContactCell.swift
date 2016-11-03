//
//  EPContactCell.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 13/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

class EPContactCell: UITableViewCell {

    @IBOutlet weak var contactTextLabel: UILabel!
    @IBOutlet weak var contactDetailTextLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactInitialLabel: UILabel!
    @IBOutlet weak var contactContainerView: UIView!
    
    var contact: EPContact?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.None
        contactContainerView.layer.masksToBounds = true
        contactContainerView.layer.cornerRadius = contactContainerView.frame.size.width/2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateInitialsColorForIndexPath(indexpath: NSIndexPath) {
        //Applies color to Initial Label
        let colorArray = [EPGlobalConstants.Colors.amethystColor,EPGlobalConstants.Colors.asbestosColor,EPGlobalConstants.Colors.emeraldColor,EPGlobalConstants.Colors.peterRiverColor,EPGlobalConstants.Colors.pomegranateColor,EPGlobalConstants.Colors.pumpkinColor,EPGlobalConstants.Colors.sunflowerColor]
        let randomValue = (indexpath.row + indexpath.section) % colorArray.count
        contactInitialLabel.backgroundColor = colorArray[randomValue]
    }
 
    func updateContactsinUI(contact: EPContact, indexPath: NSIndexPath, subtitleType: SubtitleCellValue) {
        
          self.contact = contact
       /* if(contact.isKiboContact())
        {
            
            self.userInteractionEnabled=false
            self.contactDetailTextLabel.textColor=UIColor.grayColor()
            self.contactDetailTextLabel.text="Not a kibo contact"
        }*/
        //else{
            self.contactTextLabel?.text = contact.displayName()
           
        //}
        
      
        
        
        
        
        //Update all UI in the cell here
        updateSubtitleBasedonType(subtitleType, contact: contact)
        if contact.thumbnailProfileImage != nil {
            self.contactImageView?.image = contact.thumbnailProfileImage
            self.contactImageView.hidden = false
            self.contactInitialLabel.hidden = true
        } else {
            
            
            //UNCOMMENT IF U WISH TO SHOW INITIALS IN ABSENCE OF AVTATAR
            
            ///////self.contactInitialLabel.text = contact.contactInitials()
            ///////updateInitialsColorForIndexPath(indexPath)
            /////self.contactImageView.hidden = true
            /////self.contactInitialLabel.hidden = false
        }
    }
    
    func updateSubtitleBasedonType(subtitleType: SubtitleCellValue , contact: EPContact) {
        self.userInteractionEnabled=true
        switch subtitleType {
            
        case SubtitleCellValue.PhoneNumber:
            let phoneNumberCount = contact.phoneNumbers.count
            if phoneNumberCount == 1  {
                
                if !contact.isKiboContact(){
                    self.contactDetailTextLabel.text = "Not a kibo contact"
                    self.userInteractionEnabled=false
                }
                else
                {
                self.contactDetailTextLabel.text = "\(contact.phoneNumbers[0].phoneNumber)"
                }
            }
            else if phoneNumberCount > 1 {
                
                if !contact.isKiboContact(){
                    self.contactDetailTextLabel.text = "Not a kibo contact"
                    self.userInteractionEnabled=false
                }
                else
                {
                self.contactDetailTextLabel.text = "\(contact.phoneNumbers[0].phoneNumber) and \(contact.phoneNumbers.count-1) more"
                }
            }
            else {
                self.contactDetailTextLabel.text = EPGlobalConstants.Strings.phoneNumberNotAvaialable
            }
        case SubtitleCellValue.Email:
            let emailCount = contact.emails.count
        
            if emailCount == 1  {
                self.contactDetailTextLabel.text = "\(contact.emails[0].email)"
            }
            else if emailCount > 1 {
                self.contactDetailTextLabel.text = "\(contact.emails[0].email) and \(contact.emails.count-1) more"
            }
            else {
                self.contactDetailTextLabel.text = EPGlobalConstants.Strings.emailNotAvaialable
            }
        case SubtitleCellValue.Birthday:
            self.contactDetailTextLabel.text = contact.birthdayString
        case SubtitleCellValue.Organization:
            self.contactDetailTextLabel.text = contact.company! as String
        }
    }
}
