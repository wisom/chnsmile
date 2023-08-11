//
//  FlutterBridgeLogout.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/15.
//

import UIKit

class FlutterBridgeLogout: FlutterBridgeBaseAPI {

    ///方法名
    override class func apiName() -> String {
        return "logout"
    }
    
    ///具体API的操作
    override class func processWithAPI(call: FlutterMethodCall, result: @escaping FlutterResult){
        AppDelegate.shared.logout()
        
        result("{\"data\": 1}")
    }
    
}


class FlutterBridgeWxUnBind: FlutterBridgeBaseAPI {

    ///方法名
    override class func apiName() -> String {
        return "WxUnBind"
    }
    
    ///具体API的操作
    override class func processWithAPI(call: FlutterMethodCall, result: @escaping FlutterResult){
        WXUtils.shared.wxUnBind()
        result("{\"data\": 1}")
    }
    
}
