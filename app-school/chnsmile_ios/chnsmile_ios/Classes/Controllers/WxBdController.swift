//
//  WxBdController.swift
//  chnsmile_ios
//
//  Created by jianbin li on 2023/6/24.
//

import UIKit

class WxBdController: BaseTitleController {
    
    
    @IBOutlet weak var accountTf: UITextField!
    
    @IBOutlet weak var pwdTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle("绑定账户")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func wxBindBtn(_ sender: UIButton) {
        
        // 获取账号
        let account = accountTf.text!.trim()!
        if account.isEmpty {
            print("account is null")
            ToastUtil.short("请输入账号")
            return
        }
        
    
        //获取密码
        let password = pwdTf.text!.trim()!
        if password.isEmpty {
            ToastUtil.short("请输入密码")
            return
        }
        
        let token = UserDefaults.standard.string(forKey: WX_TOKEN)
        let openid = UserDefaults.standard.string(forKey: WX_OPENID)
        
        WXUtils.shared.wxBind(access_token: token ?? "", openId: openid ?? "", account: account, password: password)
        
    }

    
}

