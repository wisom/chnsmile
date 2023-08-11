package com.icefire.chnsmile.model;

import java.io.Serializable;

public class User implements Serializable {

    public String id;     //会员号
    public String imUserSign;   //im 的标识
    public String account;
    public String nickName;
    public String name;
    public String avatar;
    public String birthday;
    public String sex;
    public String email;
    public String tel;
    public int defaultIdentity; // 1: 家长 2: 教师
    public String schoolId;
    public String lastChildId; // studentId
    public String baseUrl; // 基本URL

}
