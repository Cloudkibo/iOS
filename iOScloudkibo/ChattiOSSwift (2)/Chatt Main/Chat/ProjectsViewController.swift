//
//  ProjectsViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    @IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForProjects : UITableView!
        
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.green
        // Do any additional setup after loading the view.
    }
    
    
   /* required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    required init?(coder aDecoder: NSCoder)
{
    
        super.init(coder: aDecoder)
    }
    
    @IBAction func unwindToChat (_ segueSelected : UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        if (indexPath.row%2 == 0){
            return tblForProjects.dequeueReusableCell(withIdentifier: "ProjectCell")! as UITableViewCell
        } else {
            return tblForProjects.dequeueReusableCell(withIdentifier: "ProjectCell1")! as UITableViewCell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
