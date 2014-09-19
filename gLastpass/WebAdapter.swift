//
//  WebAdapter.swift
//  gLastpass
//
//  Created by gxw on 14/9/18.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class WebAdapter: NSObject {
    var httpServer: HTTPServer!
    var portalCtr: PortalViewController!
    
    class var sharedInstance:WebAdapter {
        get {
            struct HttpStatic {
                static var instance: WebAdapter? = nil
                static var token: dispatch_once_t = 0
            }
            
            dispatch_once(&HttpStatic.token) {
                HttpStatic.instance = WebAdapter()
                HttpStatic.instance?.httpServer = HTTPServer()
            }
            
            return HttpStatic.instance!
        }
    }
    
    func configuration() {
        DDLog.addLogger(DDTTYLogger.sharedInstance())
        var httpServer = WebAdapter.sharedInstance
        
        self.httpServer.setType("_http._tcp.")
        var docRoot: String?
        docRoot = NSBundle.mainBundle().pathForResource("index", ofType: "html", inDirectory: "Web")?.stringByDeletingLastPathComponent
        
        self.httpServer.setDocumentRoot(docRoot)
        self.httpServer.setConnectionClass(MyHTTPConnection)
    }
    
    func starServer() {
        var error: NSError?
        
        if (self.httpServer.start(&error)) {
            println("Started HTTP Server on port \(self.httpServer.listeningPort())")
        } else {
            println("ERROR: Started HTTP Server on port FAILED")
        }
    }
    
    func stopServer() {
        self.httpServer.stop()
    }
}
