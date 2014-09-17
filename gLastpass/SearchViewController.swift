//
//  SearchViewController.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate,UISearchDisplayDelegate {
    
    var listCtr : ListViewController? = nil
    var dataArray : Array<Account> = Array<Account>()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let baseName = "baseCell";
        let nib = UINib(nibName: "BaseCell", bundle: nil)
        self.searchDisplayController?.searchResultsTableView.registerNib(nib, forCellReuseIdentifier: baseName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        self.dataArray.removeAll()
        
        var searchTextWithoutSpace = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let dataSource = Grubby.sharedInstance.dataSource
        for (key, category) in dataSource {
            for account in category.accounts {
                var urlStr = account.url
                var nameStr = account.name
                
                if ((urlStr.lowercaseString.rangeOfString(searchTextWithoutSpace) != nil) || (nameStr.lowercaseString.rangeOfString(searchTextWithoutSpace) != nil )) {
                	self.dataArray.append(account)
                }
            }
        }
		
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar!) {
    	self.listCtr!.cancelSearch()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let baseName = "baseCell";
        let cell = tableView!.dequeueReusableCellWithIdentifier(baseName, forIndexPath: indexPath!) as BaseCell
        
        var account = self.dataArray[indexPath!.row]
        cell.name!.text = account.name
        
        var passwordUrl = NSURL(string: account.url)
        var logoUrl: String
        if let port = passwordUrl.port {
            logoUrl = "\(passwordUrl.scheme)://\(passwordUrl.host):\(port)/favicon.ico"
        } else {
            logoUrl = "\(passwordUrl.scheme)://\(passwordUrl.host)/favicon.ico"
        }
        cell.logo!.setImageWithURL(NSURL(string: logoUrl), placeholderImage: UIImage(named: "bg"))
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        self.listCtr!.cancelSearch()
        
        var account = self.dataArray[indexPath!.row]
        self.listCtr!.showSearchResult(account)
    }
}
