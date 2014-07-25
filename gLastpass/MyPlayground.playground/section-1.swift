// Playground - noun: a place where people can play

import Cocoa

var str : String? = "Hello, playground"

var dataSource : NSMutableDictionary  = NSMutableDictionary()

dataSource = ["gxw": [1,2,3,4]]


str!.componentsSeparatedByString(" ")

//split<String, String>(str, " ")

func show(title: String) -> String {
    return title
}

show(str!)

var block = { (title : String) -> String in
    			return title
            }
let title = "gxw test"
block(title)

var array = [23,1,234,456,25]
sort(&array, <)

var url = "http://192.168.37.241/password.html"
var webUrl = NSURL(string: url)
var htmlData = NSData(contentsOfURL: webUrl)
htmlData.length




