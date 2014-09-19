//
//  PortalViewController.swift
//  gLastpass
//
//  Created by gxw on 14/9/18.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class PortalViewController: UIViewController {
    @IBOutlet weak var urlWrapper: UIView!
    @IBOutlet weak var urlLabel: UILabel!
    
    var HUD : MBProgressHUD? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None

        self.title = "数据上传"
        
        urlWrapper.layer.cornerRadius = 5
        urlWrapper.layer.borderWidth = 0.1
        urlWrapper.layer.borderColor = urlWrapper.backgroundColor?.CGColor
        
        WebAdapter.sharedInstance.portalCtr = self
        WebAdapter.sharedInstance.starServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        WebAdapter.sharedInstance.starServer()
        var urlStr: String!
        urlStr = "http://" + NetWork.currentIpAddress() + ":\(WebAdapter.sharedInstance.httpServer.listeningPort())"
        urlLabel.text = urlStr
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        WebAdapter.sharedInstance.stopServer()
    }
    
    func createHud(title: String) {
        self.HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(self.HUD!)
        self.HUD!.dimBackground = true;
        self.HUD!.labelText = title
        self.HUD!.yOffset = -120.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
