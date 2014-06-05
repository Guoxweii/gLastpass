//
//  Grubby.swift
//  gLastpass
//
//  Created by gxw on 14/6/4.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

//import Cocoa

class Grubby: NSObject {
    
    var dataSource: Dictionary<String, Category> = Dictionary<String, Category>()
    var dataImportCtr : DataImportViewController? = nil
    
    class var sharedInstance:Grubby {
        get {
            struct Static {
                static var instance : Grubby? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = Grubby() }
            
            return Static.instance!
    	}
    }

    func fetchDataFromUrl(url: String) {
        var webUrl = NSURL(string: url)
        var htmlData = NSData(contentsOfURL: webUrl)
        if htmlData.length <= 0 {
        	self.dataImportCtr!.showInfoWithValidUrl()
            return
        }
        
        var doc = TFHpple(HTMLData: htmlData)
        var elements : Array = doc.searchWithXPathQuery("//pre")
        if elements.count == 0 {
            self.dataImportCtr!.showInfoWithValidUrl()
            return
        }
        
        var passInfo : String? = elements[0].text
        self.parse(passInfo!)
		self.dataImportCtr!.fetchDataComplete()
    }
    
    func parse(passInfo: String) {
    	AppInfo.sharedInstance.store_password_info(passInfo)
        var elements = passInfo.componentsSeparatedByString("\n")
        
        if(elements.count < 2) {
        	return
        }
        
        self.dataSource.removeAll()
        elements.removeAtIndex(0)
        
        for element in elements {
            var elementArray = element.componentsSeparatedByString(",")
            
            if elementArray.count < 7 {
                continue
            }
            
            var groupName = elementArray[5]
            
            if groupName.isEmpty {
                groupName = "未分组"
            }
            var lineObject : Category? = self.dataSource[groupName]
        
            if lineObject == nil {
                lineObject = Category(name: groupName)
                self.dataSource[groupName] = lineObject
            }
        
            var account = Account(name: elementArray[4], url: elementArray[0], login: elementArray[1], password: elementArray[2], category: lineObject!)
            lineObject!.accounts.append(account)
        }
    }
}
