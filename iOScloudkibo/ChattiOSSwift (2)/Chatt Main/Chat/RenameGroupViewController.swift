//
//  RenameGroupViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 27/04/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class RenameGroupViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var tblRenameGroup: UITableView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renameGroup(groupid:String,newname:String)
    {
        
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
