//
//  WxInfo.swift
//  chnsmile_ios
//
//  Created by jianbin li on 2023/6/17.
//

import Foundation
import HandyJSON

class WxInfo: BaseModel {
    var openid: String?
    var nickname: String?
    var sex: Int?
    var city: String?
    var country: String?
    var headimgurl: String?
    var unionid: String?
    var account: String?
    var province: String?
    var privilege: [String] = []
}
