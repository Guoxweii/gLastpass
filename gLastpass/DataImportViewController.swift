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
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.HUD = MBProgressHUD(view: self.view)
        self.view.addSubview(self.HUD!)
        self.HUD!.dimBackground = true;
        self.HUD!.labelText = "loading...."
        self.HUD!.yOffset = -120.0
        self.HUD!.show(true)
        
        self.fetchDataFromUrl()
        return true
    }

    func fetchDataFromUrl() {
    	let grubby = Grubby.INSTANCE
        var url = self.urlTextfield.text
        grubby.fetchDataFromUrl("\(url)")
    }
}
