//
//  Category.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

class Group: NSObject {
    var name: String
    var accounts: Array<Account>
    
    init(name: String) {
    	self.name = name
        self.accounts = Array<Account>()
    }
}