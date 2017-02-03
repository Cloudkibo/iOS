//
//  ArchivedChatsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 03/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class ArchivedChatsViewController: UIViewController {

    @IBOutlet weak var tblArchivedChats: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblArchivedChats.dequeueReusableCell(withIdentifier: "ArchivedChatsCell")! as UITableViewCell
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 103
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
