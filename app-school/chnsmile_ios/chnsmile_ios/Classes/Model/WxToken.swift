//
//  WxToken.swift
//  chnsmile_ios
//
//  Created by jianbin li on 2023/6/17.
//

import Foundation
import HandyJSON

class WxToken: BaseModel {
    var accessToken: String!
    var refreshToken: String!
    var openid: String!
    var scope: String!
    var unionid: String!
    var expiresIn: Int!
}
