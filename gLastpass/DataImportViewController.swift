//
//  DataImportViewController.swift
//  gLastpass
//
//  Created by gxw on 14/6/4.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class DataImportViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var urlTextfield : UITextField = nil
    var HUD : MBProgressHUD? = nil

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     	self.title = "数据导入"
        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        dispatch_async(dispatch_get_main_queue(), {
            self.createHud("loading...")
            self.HUD!.show(true)
        })
        
        self.fetchDataFromUrl()
        return true
    }

    func fetchDataFromUrl() {
        var url = self.urlTextfield.text
    	let grubby = Grubby.sharedInstance
        
        grubby.dataImportCtr = self
        grubby.fetchDataFromUrl("\(url)")
    }
    
    func showInfoWithValidUrl() {
        dispatch_async(dispatch_get_main_queue(), {
            if self.HUD {
                self.HUD!.removeFromSuperview()
                self.HUD = nil
             }
            
            self.createHud("url地址错误.")
            
            self.HUD!.showAnimated(true,
                    whileExecutingBlock: {
                        println("start animation")
                        sleep(1)
                	}, completionBlock: {
                        println("animation finish")
                        if self.HUD {
                            self.HUD!.removeFromSuperview()
                            self.HUD = nil
                        }
                	}
            )
        })
    }
    
    func createHud(title: String) {
        self.HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(self.HUD!)
        self.HUD!.dimBackground = true;
        self.HUD!.labelText = title
        self.HUD!.yOffset = -120.0
    }
    
    func fetchDataComplete() {
        dispatch_async(dispatch_get_main_queue(), {
            if self.HUD {
                self.HUD!.removeFromSuperview()
                self.HUD = nil
            }
        })
        
        if Grubby.sharedInstance.dataSource.count > 0 {
        	let listCtr = ListViewController(nibName: "ListViewController", bundle: nil)
            self.navigationController.setViewControllers([listCtr],animated: true)
        }
    }
}