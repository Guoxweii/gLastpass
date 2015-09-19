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
        
        self.createHud()
        
        WebAdapter.sharedInstance.portalCtr = self
        WebAdapter.sharedInstance.starServer()
        Grubby.sharedInstance.portalCtr = self
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
    
    func showHub(title: String) {
        dispatch_async(dispatch_get_main_queue(), {
            self.HUD!.labelText = title
            self.HUD!.show(true)
        })
    }
    
    func createHud() {
        self.HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(self.HUD!)
        self.HUD!.dimBackground = true;
        self.HUD!.yOffset = -120.0
    }
    
    func showInfoWithErrorData() {
        dispatch_async(dispatch_get_main_queue(), {
            self.HUD!.labelText = "数据错误."
            self.HUD!.hide(true, afterDelay: 5)
        })
    }
    
    func fetchDataComplete() {
        dispatch_async(dispatch_get_main_queue(), {
            self.HUD!.labelText = "导入成功，3秒后跳转"
            
            print(Grubby.sharedInstance.dataSource, terminator: "")

            if Grubby.sharedInstance.dataSource.count > 0 {
                let listCtr = ListViewController(nibName: "ListViewController", bundle: nil)
                self.navigationController?.setViewControllers([listCtr],animated: true)
            }
        })
        
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
