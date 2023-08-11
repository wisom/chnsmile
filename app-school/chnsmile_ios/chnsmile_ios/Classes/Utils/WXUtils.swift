//
//  Wx.swift
//  login
//
//  Created by fx on 2023/6/16.
//

import UIKit
import RxSwift

let WX_APPID = "wx0ea0d374ca33b2d9"
let WX_SECRET = "782cbc50274a1a18ab8660f6efc81bd2"
let WX_UNIVERSALLINK = "https://yun3.csmiledu.com/"

let WX_TOKEN = "WX_TOKEN"
let WX_OPENID = "WX_OPENID"
let WX_REFRESHTOKEN = "WX_REFRESHTOKEN"

class WXUtils: NSObject , WXApiDelegate {
    
    static let shared = WXUtils.init()
    
    private override init() {}
    
    let disposeBag = DisposeBag()
    
    var userId:Int=0

    //注册appid
    func registerApp() {
        WXApi.registerApp(WX_APPID, universalLink: WX_UNIVERSALLINK)
    }
    
    //是否安装微信
    func isWXApp() -> Bool {
        return WXApi.isWXAppInstalled();
    }
    
    //微信登录
    func wxLogin(userIdentity:Int) {
        userId = userIdentity
        let token = UserDefaults.standard.string(forKey: WX_TOKEN)
        if (token != nil && !token!.isEmpty) {
            let openId = UserDefaults.standard.string(forKey: WX_OPENID)
            accessTokenUsable(access_token: token!, openId: openId!) { [unowned self] ok in
                if ok {
                    self.getWechatUserInfo(access_token: token!, openId: openId!)
                } else {
                    let refreshToken = UserDefaults.standard.string(forKey: WX_REFRESHTOKEN)
                    self.refreshAccessToken(refreshToken: refreshToken!)
                }
            }
        } else {
            wxLoginReq()
        }
    }
    
    //微信登录请求
    func wxLoginReq() {
        let req = SendAuthReq()
        //用于保持请求和回调的状态，授权请求或原样带回
        req.state = "wx_oauth_authorization_state";
        //授权作用域：获取用户个人信息
        req.scope = "snsapi_userinfo";
        DispatchQueue.main.async {
            WXApi.send(req)
        }
    }

    //微信发送请求
    func onReq(_ req: BaseReq) {
        print( "\n\n----openID:"+req.openID)
    }

    //微信请求返回结果
    func onResp(_ resp: BaseResp) {
        if resp.isKind(of: SendAuthResp.self) {
            let res = resp as? SendAuthResp
            if res?.state == "wx_oauth_authorization_state" || res?.errCode == 0 {
                self.getWechatAccessToken(code: res!.code!)
            }
        }
    }
    
    //判断本地的access_token是否可用
    func accessTokenUsable(access_token: String, openId: String, complete: @escaping(Bool) -> Void) {
        Api.shared.getWxCheckLocation(accessToken: access_token, openId: openId).subscribeOnSuccess { data in
            if let data = data?.data {
                if data {
                    complete(true)
                } else {
                    complete(false)
                }
            }
        }.disposed(by: disposeBag)
    }

    
    //使用refresh_token刷新access_token
    func refreshAccessToken(refreshToken: String) {
        Api.shared.getWxUpdateToken(refreshToken: refreshToken).subscribeOnSuccess { [unowned self] data in
            if let data = data?.data {
                //保存 refresh_token、access_token、openid到本地
                UserDefaults.standard.set(data.accessToken, forKey: WX_TOKEN)
                UserDefaults.standard.set(data.openid, forKey: WX_OPENID)
                UserDefaults.standard.set(data.refreshToken, forKey: WX_REFRESHTOKEN)
                
                self.getWechatUserInfo(access_token: data.accessToken, openId: data.openid)
            }
        }.disposed(by: disposeBag)

    }

    //获取access_token和openid
    func getWechatAccessToken(code:String)  {
        
        Api.shared.getWxToken(code: code).subscribeOnSuccess { [unowned self] data in
            if let data = data?.data {
                //保存 refresh_token、access_token、openid到本地
                UserDefaults.standard.set(data.accessToken, forKey: WX_TOKEN)
                UserDefaults.standard.set(data.openid, forKey: WX_OPENID)
                UserDefaults.standard.set(data.refreshToken, forKey: WX_REFRESHTOKEN)
                
                self.getWechatUserInfo(access_token: data.accessToken, openId: data.openid)
            }
        }.disposed(by: disposeBag)
    }
    
    //绑定用户信息
    func getWechatUserInfo(access_token:String, openId:String)  {
        Api.shared.getWxInfo(accessToken: access_token, openId: openId).subscribeOnSuccess { [unowned self] data in
            if let data = data?.data {
                // 保存WxInfo
                PreferenceUtil.setWxInfo(data)
                if (data.account == nil  || data.account == "") {
                    AppDelegate.shared.toWxBd()
                } else {
                    wxBind(access_token: access_token, openId: openId, account: data.account!, password: nil)
                }
               
            }
        }.disposed(by: disposeBag)
    }
    

    func wxBind(access_token:String, openId:String, account:String, password:String?) {
        Api.shared.wxLogin(accessToken: access_token, openId: openId, account: account, userIdentity: userId, password: password).subscribeOnSuccess {[unowned self] data in
            if let loginData = data?.data {
                //登录成功
                print("login success:\(loginData)")
                // 保存token
                PreferenceUtil.setUserToken(loginData)
                // 保存account
                PreferenceUtil.userAccount(account);
                
                // 更新微信信息
                let wxInfo = PreferenceUtil.getWxInfo()
                if let info = wxInfo {
                    info.account=account
                    PreferenceUtil.setWxInfo(info)
                }
                // 家长用户接口
                self.getUserInfo()
            
            }
        }.disposed(by: disposeBag)
    }
    
    
    func getUserInfo() {
        Api.shared.getUserInfo().subscribeOnSuccess { data in
            if let data = data?.data {
                print("user info:\(data)")
                // 保存用户信息
                PreferenceUtil.setUserInfo(data)
                // 加载im
                self.loadIM(data)
            }
        }.disposed(by: disposeBag)
    }
    
    func loadIM(_ user: User) {
        TUILogin.login(user.id, userSig: user.imUserSign) {
            //把登录成功的事件通知到AppDelegate
            ToastUtil.hideLoading()
            AppDelegate.shared.toHome()
        } fail: { code, message in
            ToastUtil.short("IM初始化失败")
            ToastUtil.hideLoading()
            AppDelegate.shared.toHome()
        }

    }
    
    
    func wxUnBind() {
        let account = UserDefaults.standard.string(forKey: KEY_USER_ACCOUNT)
        let openId = UserDefaults.standard.string(forKey: WX_OPENID)
        if(openId==nil||openId==""){
            return
        }
        Api.shared.getWxUnBind(account: account ?? "", openId: openId ?? "").subscribeOnSuccess { data in
            if let data = data?.data {
                if data {
                    ToastUtil.short("微信解绑成功")
                    UserDefaults.standard.removeObject(forKey: WX_OPENID)
                    UserDefaults.standard.removeObject(forKey: WX_TOKEN)
                    UserDefaults.standard.removeObject(forKey: WX_REFRESHTOKEN)
                    UserDefaults.standard.removeObject(forKey: KEY_WX_INFO)
                    UserDefaults.standard.synchronize()
                } else {
                    ToastUtil.short("微信解绑失败")
                }
            }
        }.disposed(by: disposeBag)
    }
    
}
