//
//  RenameGroupViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 27/04/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class RenameGroupViewController: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate {

    
    var oldgroupname=""
    @IBOutlet weak var btnCancel: UIBarButtonItem!
   // @IBOutlet weak var tblRenameGroup: UITableView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var txtFieldGroupName: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changingText(_ sender: UITextField) {
        1
        if(oldgroupname==sender.text! || oldgroupname==sender.text!=="")
        {
            btnDone.isEnabled=false
        }
        else{
            btnDone.isEnabled=true
        }
    }
    func renameGroup(groupid:String,newname:String)
    {
        var url=Constants.MainUrl+Constants.updateGroupName
        
        let request = Alamofire.request("\(url)", method: .post, parameters:["group_name":newname, "unique_id":groupid],encoding: JSONEncoding.default,headers:header).responseJSON { response in
        
            print("Update GRoup name called")
            if(response.result.isSuccess)
            {
                print("group name chabged success")
                sqliteDB.updateGroupname(groupid:String,newname:String)
                
            }
        }
    }
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
