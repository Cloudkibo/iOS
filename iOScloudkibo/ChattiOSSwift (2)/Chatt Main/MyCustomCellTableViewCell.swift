//
//  MyCustomCellTableViewCell.swift
//  PKSwipeTableViewCell
//
//  Created by Pradeep Kumar Yadav on 16/04/16.
//  Copyright © 2016 iosbucket. All rights reserved.
//

import UIKit

class MyCustomCellTableViewCell: PKSwipeTableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRightViewInCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ strToSet:String) {
        self.lblTitle.text = strToSet
    }
    
    func addRightViewInCell() {
        
        //Create a view that will display when user swipe the cell in right
        let viewCall = UIView()
        viewCall.backgroundColor = UIColor.lightGray
        viewCall.frame = CGRect(x: 0, y: 0,width: self.frame.height+20,height: self.frame.height)
        //Add a label to display the call text
        let lblCall = UILabel()
        lblCall.text  = "Call"
        lblCall.font = UIFont.systemFont(ofSize: 15.0)
        lblCall.textColor = UIColor.yellow
        lblCall.textAlignment = NSTextAlignment.center
        lblCall.frame = CGRect(x: 0,y: self.frame.height - 20,width: viewCall.frame.size.width,height: 20)
        //Add a button to perform the action when user will tap on call and add a image to display
        let btnCall = UIButton(type: UIButtonType.custom)
        btnCall.frame = CGRect(x: (viewCall.frame.size.width - 40)/2,y: 5,width: 40,height: 40)
        btnCall.setImage(UIImage(named: "call"), for: UIControlState())
        btnCall.addTarget(self, action: #selector(MyCustomCellTableViewCell.callButtonClicked), for: UIControlEvents.touchUpInside)

        viewCall.addSubview(btnCall)
        viewCall.addSubview(lblCall)
        //Call the super addRightOptions to set the view that will display while swiping
        super.addRightOptionsView(viewCall)
    }
    
    
    func callButtonClicked(){
        //Reset the cell state and close the swipe action
        self.resetCellState()
    }

}
