//
//  Grubby.swift
//  gLastpass
//
//  Created by gxw on 14/6/4.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

//import Cocoa

class Grubby: NSObject {
    
    var dataSource : String? = nil
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
    }
    
    func parse(passInfo: String) {
    	AppInfo.sharedInstance.store_password_info(passInfo)
        
//        var elements : Array = passInfo.split("\n")
    }
}
