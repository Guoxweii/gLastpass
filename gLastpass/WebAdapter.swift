//
//  WebAdapter.swift
//  gLastpass
//
//  Created by gxw on 14/9/18.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class WebAdapter: NSObject {
    
    class var sharedInstance:HTTPServer {
        get {
            struct HttpStatic {
                static var instance: HTTPServer? = nil
                static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&HttpStatic.token) { HttpStatic.instance = HTTPServer() }
            
            return HttpStatic.instance!
        }
    }
    
    class func configuration() {
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        
        sharedInstance.setType("_http._tcp.")
        
        var webPath: String
        webPath = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("Web")
        sharedInstance.setDocumentRoot(webPath)
        println("the web path is \(webPath)")
    }
    
    class func starServer() {
        var error: NSError?
        
        if (sharedInstance.start(&error)) {
            println("Started HTTP Server on port \(sharedInstance.listeningPort())")
        } else {
            println("ERROR: Started HTTP Server on port FAILED")
        }
    }
    
    class func stopServer() {
        sharedInstance.stop()
    }
}
