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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None

        self.title = "数据上传"
        
        urlWrapper.layer.cornerRadius = 5
        urlWrapper.layer.borderWidth = 0.1
        urlWrapper.layer.borderColor = urlWrapper.backgroundColor?.CGColor
        
        
        WebAdapter.starServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        WebAdapter.starServer()
        var urlStr: String!
        urlStr = "http://" + NetWork.currentIpAddress() + ":\(WebAdapter.sharedInstance.listeningPort())"
        urlLabel.text = urlStr
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        WebAdapter.stopServer()
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
