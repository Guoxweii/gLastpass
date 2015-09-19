//
//  ListViewController.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UIActionSheetDelegate {
    @IBOutlet var resetButton : UIButton? = nil
    @IBOutlet var searchButton : UIButton? = nil
    
    var searchCtr : SearchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func search(sender : UIButton) {
        self.searchCtr.view.frame = self.navigationController?.view.frame as CGRect!
        self.navigationController?.view.addSubview(self.searchCtr.view)
    }
    
    @IBAction func resetDataSource(sender : UIButton) {
        let myActionSheet = UIActionSheet()
        myActionSheet.delegate = self;
        myActionSheet.addButtonWithTitle("重置")
        myActionSheet.addButtonWithTitle("取消")
        myActionSheet.cancelButtonIndex = 1
        myActionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            Grubby.sharedInstance.resetDataSource()
            
            let portalCtr = PortalViewController(nibName: "PortalViewController", bundle: nil)
            self.navigationController?.setViewControllers([portalCtr], animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "账户列表"
        
        let baseName = "baseCell";
        let nib = UINib(nibName: "BaseCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: baseName)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.resetButton!)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchButton!)
        
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44;
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let dataSource = Grubby.sharedInstance.dataSource
        
        var keys = Array<String>()
        for (key, category) in dataSource {
			keys.append(key)
        }
        let currentKey = keys[section]
        
		let category = dataSource[currentKey] as Group!
        return category.accounts.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dataSource = Grubby.sharedInstance.dataSource
        
        var keys = Array<String!>()
        for (key, category) in dataSource {
            keys.append(key)
        }
    	return keys[section]
    }
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell {
        let baseName = "baseCell";
    	let cell = self.tableView.dequeueReusableCellWithIdentifier(baseName, forIndexPath: indexPath!) as! BaseCell
    	
        let dataSource = Grubby.sharedInstance.dataSource
        var keys = Array<String>()
        for (key, category) in dataSource {
            keys.append(key)
        }
        let currentKey = keys[indexPath!.section]
        let category = dataSource[currentKey] as Group!
        var accounts = category.accounts

        cell.name!.text = accounts[indexPath!.row].name

        let passwordUrl = NSURL(string: accounts[indexPath!.row].url)
        var logoUrl: String
        logoUrl = fetchIcoUrl(passwordUrl!)

        cell.logo!.setImageWithURL(NSURL(string: logoUrl), placeholderImage: UIImage(named: "bg"))
        
    	return cell
    }
    
    func fetchIcoUrl(url: NSURL) -> String {
        var icoUrl = ""
        
//        if (url.scheme != nil) {
        	icoUrl += url.scheme
            icoUrl += "://"
//        }

        if let host = url.host {
            icoUrl += host
        }
        
        if let port = url.port {
            icoUrl += ":"
            let portString = "\(port)"
        	icoUrl += portString
        }
        
        icoUrl += "/favicon.ico"
        
        return icoUrl
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dataSource = Grubby.sharedInstance.dataSource
        var keys = Array<String>()
        for (key, _) in dataSource {
            keys.append(key)
        }
        let currentKey = keys[indexPath.section]
        let category = dataSource[currentKey] as Group!
        var accounts = category.accounts
        
        let detailCtr = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailCtr.title = accounts[indexPath.row].name
        detailCtr.login = accounts[indexPath.row].login
        detailCtr.password = accounts[indexPath.row].password
        self.navigationController?.pushViewController(detailCtr, animated: true)
    }
    
    func cancelSearch() {
    	self.searchCtr.view.removeFromSuperview()
    }
    
    func showSearchResult(account: Account) {
        let detailCtr = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailCtr.title = account.name
        detailCtr.login = account.login
        detailCtr.password = account.password
        self.navigationController?.pushViewController(detailCtr, animated: true)
    }
}
