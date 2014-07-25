//
//  DetailViewController.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var resetPinButton : UIButton? = nil
    var password: String? = nil
    var login: String? = nil
    var HUD : MBProgressHUD? = nil
    
    @IBOutlet var passwordField : UITextField? = nil
    @IBOutlet var loginField : UITextField? = nil

    @IBOutlet var copyLoginButton : UIButton? = nil
    @IBOutlet var copyPasswordButton : UIButton? = nil
    
    @IBAction func resetPin(sender : UIButton) {
        var pinCtr = PinViewController(nibName: "PinViewController", bundle: nil)
        pinCtr.isEdit = true
        self.presentViewController(pinCtr, animated: true, completion: nil)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        self.password = "default"
        self.login = "default"
    }

    @IBAction func loginCopy(sender : UIButton) {
        var pboard = UIPasteboard.generalPasteboard()
        pboard.string = self.login
        
        dispatch_async(dispatch_get_main_queue(), {
            if let hud = self.HUD {
                hud.removeFromSuperview()
                self.HUD = nil
            }
            
            self.createHud("账户拷贝成功.")
            
            self.HUD!.showAnimated(true,
                whileExecutingBlock: {
                    println("start animation")
                    sleep(1)
                }, completionBlock: {
                    println("animation finish")
                    if let hud = self.HUD {
                        hud.removeFromSuperview()
                        self.HUD = nil
                    }
                }
            )
        })
    }
    
    @IBAction func passwordCopy(sender : UIButton) {
        var pboard = UIPasteboard.generalPasteboard()
        pboard.string = self.password
        
        dispatch_async(dispatch_get_main_queue(), {
            if let hud = self.HUD {
                hud.removeFromSuperview()
                self.HUD = nil
            }
            
            self.createHud("密码拷贝成功.")
            
            self.HUD!.showAnimated(true,
                whileExecutingBlock: {
                    println("start animation")
                    sleep(1)
                }, completionBlock: {
                    println("animation finish")
                    if let hud = self.HUD {
                        hud.removeFromSuperview()
                        self.HUD = nil
                    }
                }
            )
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.copyLoginButton!.layer.cornerRadius = 5
        self.copyLoginButton!.layer.borderWidth = 1
        self.copyLoginButton!.layer.borderColor = UIColor.blueColor().CGColor
        
        self.copyPasswordButton!.layer.cornerRadius = 5
        self.copyPasswordButton!.layer.borderWidth = 1
        self.copyPasswordButton!.layer.borderColor = UIColor.blueColor().CGColor
        
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.resetPinButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
    	self.loginField!.text = self.login?
        self.passwordField!.text = self.password?
    }
    
    func createHud(title: String) {
        self.HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(self.HUD!)
        self.HUD!.dimBackground = true;
        self.HUD!.labelText = title
    }
}
