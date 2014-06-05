//
//  ListViewController.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "账户列表"
        
        let baseName = "baseCell";
        let nib = UINib(nibName: "BaseCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: baseName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return Grubby.sharedInstance.dataSource.count
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let dataSource = Grubby.sharedInstance.dataSource
        
        var keys = Array<String>()
        for (key, category) in dataSource {
			keys.append(key)
        }
        var currentKey = keys[section]
        
		var category = dataSource[currentKey] as Category
        return category.accounts.count
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        let dataSource = Grubby.sharedInstance.dataSource
        
        var keys = Array<String>()
        for (key, category) in dataSource {
            keys.append(key)
        }
    	return keys[section]
    }
    

    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let baseName = "baseCell";
    	let cell = self.tableView.dequeueReusableCellWithIdentifier(baseName, forIndexPath: indexPath) as BaseCell
    	
        let dataSource = Grubby.sharedInstance.dataSource
        var keys = Array<String>()
        for (key, category) in dataSource {
            keys.append(key)
        }
        var currentKey = keys[indexPath!.section]
        var category = dataSource[currentKey] as Category
        var accounts = category.accounts
        
        cell.name.text = accounts[indexPath!.row].name
        
    	return cell
    }
}
