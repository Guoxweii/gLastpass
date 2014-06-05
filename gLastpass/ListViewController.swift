//
//  ListViewController.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UIActionSheetDelegate {
    @IBOutlet var resetButton : UIButton = nil
    @IBOutlet var searchButton : UIButton = nil
    
    var searchCtr : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    @IBAction func search(sender : UIButton) {
        
        self.navigationController.view.addSubview(self.searchCtr.view)
    }
    
    @IBAction func resetDataSource(sender : UIButton) {
//        let actionSheet = UIActionSheet(title: "",delegate: self, cancelButtonTitle: "取消",destructiveButtonTitle: "重置")
//        actionSheet.actionSheetStyle = UIActionSheetStyle.Default
//        actionSheet.showInView(self.view)
        
    	Grubby.sharedInstance.resetDataSource()
        
		var mainCtr = DataImportViewController(nibName: "DataImportViewController", bundle: nil)
        self.navigationController.setViewControllers([mainCtr],animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "账户列表"
        
        let baseName = "baseCell";
        let nib = UINib(nibName: "BaseCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: baseName)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.resetButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchButton)
        
        self.searchCtr.listCtr = self
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
        
        var passwordUrl = NSURL(string: accounts[indexPath!.row].url)
        var logoUrl: String
        if passwordUrl.port == nil {
            logoUrl = "\(passwordUrl.scheme)://\(passwordUrl.host)/favicon.ico"
        } else {
            logoUrl = "\(passwordUrl.scheme)://\(passwordUrl.host):\(passwordUrl.port)/favicon.ico"
        }
        cell.logo.setImageWithURL(NSURL(string: logoUrl), placeholderImage: UIImage(named: "bg"))
        
    	return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let dataSource = Grubby.sharedInstance.dataSource
        var keys = Array<String>()
        for (key, category) in dataSource {
            keys.append(key)
        }
        var currentKey = keys[indexPath!.section]
        var category = dataSource[currentKey] as Category
        var accounts = category.accounts
        
        var detailCtr = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailCtr.title = accounts[indexPath!.row].name
        detailCtr.login = accounts[indexPath!.row].login
        detailCtr.password = accounts[indexPath!.row].password
        self.navigationController.pushViewController(detailCtr, animated: true)
    }
    
    func cancelSearch() {
    	self.searchCtr.view.removeFromSuperview()
    }
    
    func showSearchResult(account: Account) {
        var detailCtr = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailCtr.title = account.name
        detailCtr.login = account.login
        detailCtr.password = account.password
        self.navigationController.pushViewController(detailCtr, animated: true)
    }
}
