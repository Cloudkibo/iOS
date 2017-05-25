//
//  MyStatusDetailsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 25/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class MyStatusDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var messages:NSMutableArray!
    
    @IBOutlet weak var tblMyStatus: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        messages=NSMutableArray()
        messages.add(["picID":"1","time":"1 hour ago","viewCount":"2"])
        messages.add(["picID":"2","time":"just now","viewCount":"0"])
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        else{
            if(messages.count>0)
            {
                return messages.count
            }
            else{
                return 1
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
