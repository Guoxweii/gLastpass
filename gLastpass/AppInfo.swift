//
//  AppInfo.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

//import Cocoa

class AppInfo: NSObject {
    class var sharedInstance:AppInfo {
        get {
            struct Static {
                static var instance : AppInfo? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) { Static.instance = AppInfo() }
            
            return Static.instance!
    	}
    }
    
    func current_password_info() -> String {
		let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey("password_info") as String!
    }
    
    func store_password_info(info: String) {
        NSUserDefaults.standardUserDefaults().setObject(info, forKey: "password_info")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
