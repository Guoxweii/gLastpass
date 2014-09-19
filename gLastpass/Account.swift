//
//  Account.swift
//  gLastpass
//
//  Created by gxw on 14/6/5.
//  Copyright (c) 2014年 bstar. All rights reserved.
//

class Account: NSObject {
    var name: String
    var url: String
    var login: String
    var password: String
    var category: Group
    
    init(name: String, url: String, login: String, password: String, category: Group) {
        self.name = name
        self.url = url
        self.login = login
        self.password = password
        self.category = category
    }
}
