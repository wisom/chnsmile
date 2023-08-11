//
//  Service.swift
//  chnsmile_ios
//
//  Created by chao on 2022/2/5.
//

import Foundation
import Moya

enum Service {
    case origin(phone: String, isStaff: Int)
    case login(phone: String?, password: String?, userIdentity: Int?)
    case getUserInfo
    case getUnReadNum
    case uploadCid(cid: String?)
    case wxToken(code: String)//type 无效，0-行政版 1-校园版
    case wxCheckLocation(accessToken: String, openId: String)
    case wxUpdateToken(refreshToken: String)
    case wxInfo(accessToken: String, openId: String)
    case wxLogin(accessToken: String, openId: String, account: String, userIdentity: Int, password:String?)
    case wxUnbinding(account: String, openId: String)
}

// MARK: - 实现TargetType协议
extension Service: TargetType {
    
    /// 返回网址
    var baseURL: URL {
        switch self {
        case .origin, .wxToken, .wxUpdateToken, .wxInfo, .wxLogin, .wxCheckLocation, .wxUnbinding:
            return URL(string: ENDPOINT2)!
        default:
            let url = UserDefaults.standard.object(forKey: KEY_URL)
            return URL(string: url as! String)!
        }
    }
    
    /// 返回请求路径
    var path: String {
        switch self {
        case .origin:
            return "platformRegionUser/default/list"
        case .login:
            return "app-api/mobileLogin"
        case .getUserInfo:
            return "app-api/getLoginUser"
        case .getUnReadNum:
            return "app-api/app/user/tab/unReadNum"
        case .uploadCid:
            return "app-api/app/user/push/bindCidAndAlias"
        case .wxToken:
            return "api/wx-auth/getAccessToken"
        case .wxCheckLocation:
            return "api/wx-auth/verifyAccessToken"
        case .wxUpdateToken:
            return "api/wx-auth/refreshToken"
        case .wxInfo:
            return "api/wx-auth/getWxUserInfo"
        case .wxLogin:
            return "api/wx-auth/wxLogin"
        case .wxUnbinding:
            return "api/wx-auth/unbindingWx"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .uploadCid, .wxLogin:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let phone, password: let password, userIdentity: let userIdentity):
            return HttpUtil.jsonRequestParamters(["phone": phone, "password": password, "userIdentity": userIdentity])
        case .uploadCid(cid: let cid):
            return HttpUtil.jsonRequestParamters(["cid": cid!, "brand": "IOS"])
        case .origin(phone: let phone, isStaff: let isStaff):
            return HttpUtil.getRequestParamters(["account": phone, "isStaff": isStaff])
        case .wxToken(code: let code):
            return HttpUtil.getRequestParamters(["code": code, "type":1])
        case .wxCheckLocation(accessToken: let accessToken, openId: let openId):
            return HttpUtil.getRequestParamters(["accessToken": accessToken, "openId":openId, "type":1])
        case .wxUpdateToken(refreshToken: let refreshToken):
            return HttpUtil.getRequestParamters(["refreshToken": refreshToken, "type":1])
        case .wxInfo(accessToken: let accessToken, openId: let openId):
            return HttpUtil.getRequestParamters(["accessToken": accessToken, "openId":openId, "type":1])
        case .wxLogin(accessToken: let accessToken, openId: let openId, account: let account, userIdentity: let userIdentity,password: let password):
            return HttpUtil.jsonRequestParamters(["accessToken": accessToken, "openId": openId, "account": account, "type":1, "userIdentity": userIdentity, "password":password])
        case .wxUnbinding(account: let account, openId: let openId):
            return HttpUtil.getRequestParamters(["account": account, "openId":openId, "type":1])
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers: Dictionary<String, String> = [:]
    
        // 内容的类型
        headers["Content-Type"] = "application/json"
        if PreferenceUtil.isLogin() {
            // 登陆了
            let user = PreferenceUtil.userId()
            let token = PreferenceUtil.userToken()

            if DEBUG {
                //打印token
                print("Service headers user:\(user),token:\(token)")
            }

            //传递登录标识
            headers["Authorization"] = (token != nil) ? "Bearer " + token!  : ""
        }
        return headers
    }
    
    /// 返回测试相关的路径
    var sampleData: Data {
        return Data()
    }
}
