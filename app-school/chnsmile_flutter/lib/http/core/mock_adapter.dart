import 'package:chnsmile_flutter/constant/hi_constant.dart';
import 'package:chnsmile_flutter/http/core/hi_net_adapter.dart';
import 'package:chnsmile_flutter/http/request/hi_base_request.dart';

class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
    return Future<HiNetResponse>.delayed(const Duration(milliseconds: 1000), () {
      return HiNetResponse(data: handleMock(request), statusCode: 200);
    });
  }

  handleMock(HiBaseRequest request) {
    // if (request.path() == HiConstant.salaryList) {
    //   return salary_list;
    // } else {
      return null;
    // }
  }
}

var weekly_conest_list = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "这周大家去哪里吃饭啊",
        "content": "去找一个好吃的地方",
        "type": 0,
        "department": "教育部",
        "status": "未参加"
      },
      {
        "id": "1482245176813539330",
        "title": "这周大家去哪里吃饭啊1",
        "content": "去找一个好吃的地方1",
        "type": 0,
        "department": "教育部",
        "status": "未参加"
      },
      {
        "id": "1482245176813539330",
        "title": "这周大家去哪里吃饭啊2",
        "content": "去找一个好吃的地方2",
        "type": 1,
        "department": "教育部",
        "status": "已参加"
      }
    ]}
};

var repair_list = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "formNo": "DK201123923442",
        "repairName": "电脑桌子",
        "type": 0,
        "repairTime": "2022-01-15",
        "status": "已备案"
      },
      {
        "id": "1482245176813539330",
        "formNo": "DK201123923442",
        "repairName": "电脑桌子",
        "type": 1,
        "repairTime": "2022-01-15",
        "status": "未发出"
      },
      {
        "id": "1482245176813539330",
        "formNo": "DK201123923442",
        "repairName": "电脑桌子",
        "type": 2,
        "repairTime": "2022-01-15",
        "status": "审批中"
      },
      {
        "id": "1482245176813539330",
        "formNo": "DK201123923442",
        "repairName": "电脑桌子",
        "type": 3,
        "repairTime": "2022-01-15",
        "status": "已拒绝"
      }
    ],
    "rainbow": [
      1
    ]
  }
};

var class_transfer = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "DK201123923442",
        "publicTime": "2022-01-15 14:56:04",
        "status": "确认"
      },
      {
        "id": "1482245176813539330",
        "title": "DK201123923442",
        "publicTime": "2022-01-15 14:56:04",
        "status": "确认"
      },
      {
        "id": "1482245176813539330",
        "title": "DK201123923442",
        "publicTime": "2022-01-15 14:56:04",
        "status": "确认"
      },
      {
        "id": "1482245176813539330",
        "title": "DK201123923442",
        "publicTime": "2022-01-15 14:56:04",
        "status": "确认"
      },
      {
        "id": "1482245176813539330",
        "title": "DK201123923442",
        "publicTime": "2022-01-15 14:56:04",
        "status": "未确认"
      },
    ],
    "rainbow": [
      1
    ]
  }
};

var salary_list = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "2022年1月份工资单",
        "publicOrgId": "1265476890672672808",
        "publicOrgName": "财务部",
        "publicTime": "2022-01-15 14:56:04",
        "salary_base": "2000",
        "salary_gangwei": "2000",
        "salary_jiangjin": "2000",
        "salary_benyue": "2000",
        "salary_huoshi": "2000",
        "salary_wuxian": "2000",
        "salary_chuchai": "2000",
        "salary_niaodu": "2000",
        "salary_qita": "2000"
      },
      {
        "id": "1482245176813539330",
        "title": "2022年2月份工资单",
        "publicOrgId": "1265476890672672808",
        "publicOrgName": "财务部1",
        "publicTime": "2022-01-15 14:56:04",
        "salary_base": "2000",
        "salary_gangwei": "3000",
        "salary_jiangjin": "4000",
        "salary_benyue": "3000",
        "salary_huoshi": "3000",
        "salary_wuxian": "4000",
        "salary_chuchai": "2000",
        "salary_niaodu": "2000",
        "salary_qita": "2000"
      },
      {
        "id": "1482245176813539330",
        "title": "2022年3月份工资单",
        "publicOrgId": "1265476890672672808",
        "publicOrgName": "财务部2",
        "publicTime": "2022-01-16 14:56:04",
        "salary_base": "2000",
        "salary_gangwei": "3000",
        "salary_jiangjin": "4000",
        "salary_benyue": "3000",
        "salary_huoshi": "3000",
        "salary_wuxian": "4000",
        "salary_chuchai": "2000",
        "salary_niaodu": "2000",
        "salary_qita": "2000"
      }
    ],
    "rainbow": [
      1
    ]
  }
};

var official_document = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生",
        "content": "哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容",
        "type": 1,
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicOrgId": null,
        "publicOrgName": null,
        "publicTime": "2022-01-15 14:56:04.000",
        "cancelTime": null,
        "status": 1,
        "readStatus": 1,
        "readTime": "2022-01-19 10:36:39.000",
        "userOperateType": 0,
        "urgencyType": 0
      },
      {
        "id": "1481303029054316545",
        "title": "123",
        "content": "<p>123</p>",
        "type": 1,
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicOrgId": null,
        "publicOrgName": null,
        "publicTime": "2022-01-15 14:55:29.000",
        "cancelTime": null,
        "status": 1,
        "readStatus": 1,
        "readTime": "2022-01-18 23:12:11.000",
        "userOperateType": 0,
        "urgencyType": 0
      }
    ],
    "rainbow": [
      1
    ]
  }
};

var vacation_list = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生几名学生",
        "content": "哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容哈哈哈我是内容",
        "type": 1,
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicOrgId": null,
        "publicOrgName": null,
        "publicTime": "2022-01-15 14:56:04.000",
        "cancelTime": null,
        "status": 1,
        "readStatus": 1,
        "readTime": "2022-01-19 10:36:39.000",
        "userOperateType": 0,
        "urgencyType": 0
      },
      {
        "id": "1481303029054316545",
        "title": "123",
        "content": "<p>123</p>",
        "type": 1,
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicOrgId": null,
        "publicOrgName": null,
        "publicTime": "2022-01-15 14:55:29.000",
        "cancelTime": null,
        "status": 1,
        "readStatus": 1,
        "readTime": "2022-01-18 23:12:11.000",
        "userOperateType": 0,
        "urgencyType": 0
      }
    ],
    "rainbow": [
      1
    ]
  }
};

var school_notify_list = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "测试",
        "content": "<p>哈哈哈我是内容</p>",
        "type": 1,
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicOrgId": null,
        "publicOrgName": null,
        "publicTime": "2022-01-15 14:56:04.000",
        "cancelTime": null,
        "status": 1,
        "readStatus": 1,
        "readTime": "2022-01-19 10:36:39.000",
        "userOperateType": 0,
        "urgencyType": 0
      },
      {
        "id": "1481303029054316545",
        "title": "123",
        "content": "<p>123</p>",
        "type": 1,
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicOrgId": null,
        "publicOrgName": null,
        "publicTime": "2022-01-15 14:55:29.000",
        "cancelTime": null,
        "status": 1,
        "readStatus": 1,
        "readTime": "2022-01-18 23:12:11.000",
        "userOperateType": 0,
        "urgencyType": 0
      }
    ],
    "rainbow": [
      1
    ]
  }
};


var profile_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "studentInfo": {
      "avator":"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F55%2F34%2F61%2F553461a1d8bb07b1026a7eeff17319e0.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1644212806&t=9f8a50e2e9a22cfc352ca60186b2aa5d",
      "name":"陈思思11",
      "sex":1,
      "opentime":"2015-07-08",
      "schoolname":"微校22教育",
      "headmaster":"陈老师",
      "classname":"五年级一班"
    },
    "familyInfo": {
      "avator":"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F55%2F34%2F61%2F553461a1d8bb07b1026a7eeff17319e0.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1644212806&t=9f8a50e2e9a22cfc352ca60186b2aa5d",
      "name":"陈思思老爸",
      "sex":1,
      "opentime":"2015-07-08",
      "schoolname":"微校22教育",
      "headmaster":"陈老师",
      "classname":"五年级一班"
    },
    "msg": "SUCCESS"}
};

var growth_file_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "studentInfo": {
      "avator":"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F55%2F34%2F61%2F553461a1d8bb07b1026a7eeff17319e0.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1644212806&t=9f8a50e2e9a22cfc352ca60186b2aa5d",
      "name":"陈思思11",
      "sex":1,
      "opentime":"2015-07-08",
      "schoolname":"微校22教育",
      "headmaster":"陈老师",
      "classname":"五年级一班"
    },
    "behaviorList":[
      {
        "behaviortype": 1,
        "behaviorcont": "今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬",
        "creatime": "2021-10-04",
        "teachername": "周道",
        "teachertitle": "班主任"
      },
      {
        "behaviortype": 2,
        "behaviorcont": "小杜今天表现很不错呢",
        "creatime": "2021-10-02",
        "teachername": "周道",
        "teachertitle": "班主任"
      },
      {
        "behaviortype": 3,
        "behaviorcont": "小杜今天表现很不错呢",
        "creatime": "2021-10-03",
        "teachername": "周道",
        "teachertitle": "班主任"
      },
      {
        "behaviortype": 4,
        "behaviorcont": "小杜今天表现很不错呢",
        "creatime": "2021-10-04",
        "teachername": "周道",
        "teachertitle": "班主任"
      }
    ],
    "msg": "SUCCESS"}
};

var school_teacher_performance_list = {
  "success": true,
  "code": 200,
  "message": "请求成功",
  "data": {
    "pageNo": 1,
    "pageSize": 20,
    "totalPage": 1,
    "totalRows": 2,
    "rows": [
      {
        "id": "1482245176813539330",
        "title": "初二年级二班全体在校表现",
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicTime": "2022-01-15 14:56:04.000"
      },
      {
        "id": "1482245176813539331",
        "title": "初三年级二班全体在校表现",
        "publicUserId": "1265476890672672808",
        "publicUserName": "超级管理员",
        "publicTime": "2022-01-15 14:56:04.000"
      }
    ],
    "rainbow": [
      1
    ]
  }
};

var school_performance_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "studentInfo": {
      "avator":"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fup.enterdesk.com%2Fedpic%2F55%2F34%2F61%2F553461a1d8bb07b1026a7eeff17319e0.jpg&refer=http%3A%2F%2Fup.enterdesk.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1644212806&t=9f8a50e2e9a22cfc352ca60186b2aa5d",
      "name":"陈思思",
      "sex":1,
      "opentime":"2015-07-08",
      "schoolname":"微校教育",
      "headmaster":"陈老师",
      "classname":"五年级一班"
    },
    "behaviorList":[
      {
        "behaviortype": 1,
        "behaviorcont": "今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬今天小杜同学的作业做的很不错，表扬",
        "creatime": "2021-10-04",
        "teachername": "周道",
        "teachertitle": "班主任"
      },
      {
        "behaviortype": 2,
        "behaviorcont": "小杜今天表现很不错呢",
        "creatime": "2021-10-02",
        "teachername": "周道",
        "teachertitle": "班主任"
      },
      {
        "behaviortype": 3,
        "behaviorcont": "小杜今天表现很不错呢",
        "creatime": "2021-10-03",
        "teachername": "周道",
        "teachertitle": "班主任"
      },
      {
        "behaviortype": 4,
        "behaviorcont": "小杜今天表现很不错呢",
        "creatime": "2021-10-04",
        "teachername": "周道",
        "teachertitle": "班主任"
      }
    ],
    "msg": "SUCCESS"}
};

var homework_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "list": [
      {
        "teacherName": "teacher2",
        "attachFile": "https://t7.baidu.com/it/u=4016051664,233821456&fm=193&f=GIF",
        "teacherId": 41,
        "content": "测试作业内容1测试作业内容1测试作业内容1测试作业内容1测试作业内容1测试作业内容1测试作业内容1测试作业内容1测试作业内容1",
        "datetime": "2014-07-15 01:03:04"
      },
      {
        "teacherName": "teacher",
        "attachFile": "https://aod.cos.tx.xmcdn.com/storages/446c-audiofreehighqps/B8/5E/GKwRIaIFqwotAB9WSgEKQOco.m4a",
        "teacherId": 41,
        "content": "测试作业内容1测试",
        "datetime": "2014-07-15 01:03:04"
      },
      {
        "teacherName": "teacher2",
        "attachFile": "https://aod.cos.tx.xmcdn.com/storages/446c-audiofreehighqps/B8/5E/GKwRIaIFqwotAB9WSgEKQOco.m4a",
        "teacherId": 41,
        "content": "测试作业内容3测试作业内容3测试作业内容3测试作业内容3",
        "datetime": "2014-07-15 01:03:04"
      },
      {
        "teacherName": "teacher2",
        "attachFile": "https://t7.baidu.com/it/u=4016051664,233821456&fm=193&f=GIF",
        "teacherId": 41,
        "content": "测试作业内容4",
        "datetime": "2014-07-15 01:03:04"
      },
      {
        "teacherName": "teacher2",
        "attachFile": "https://aod.cos.tx.xmcdn.com/storages/446c-audiofreehighqps/B8/5E/GKwRIaIFqwotAB9WSgEKQOco.m4a",
        "teacherId": 41,
        "content": "测试作业内容5",
        "datetime": "2014-07-15 01:03:04"
      },
      {
        "teacherName": "teacher2",
        "attachFile": "attachFile/default.txt",
        "teacherId": 41,
        "content": "测试作业内容6",
        "datetime": "2014-07-15 01:03:04"
      }
    ],
    "msg": "SUCCESS"}
};

var home_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "schoolIntro": "通知是啥阿的发送到发送到发送到发送到发通知是啥阿的发送到发送到发送到发送到发通知是啥阿的发送到发送到发送到发送到发通知是啥阿的发送到发送到发送到发送到发。",
    "bannerList": [{
      "id": 11,
      "url": "https://www.baidu.com",
      "cover": "https://t7.baidu.com/it/u=2006997523,200382512&fm=193&f=GIF",
      "creatime": "2021-10-10 23:38:06"
    },{
      "id": 12,
      "url": "https://www.163.com",
      "cover": "https://t7.baidu.com/it/u=2298720277,4251451766&fm=193&f=GIF",
      "creatime": "2021-10-10 23:38:06"
    }, {
      "id": 13,
      "url": "https://www.162.com",
      "cover": "https://t7.baidu.com/it/u=3379862688,946992288&fm=193&f=GIF",
      "creatime": "2021-10-10 23:38:06"
    }],
    "categoryList": [{
      "id": 11,
      "url": "https://www.baidu.com",
      "cover": "https://t7.baidu.com/it/u=2006997523,200382512&fm=193&f=GIF",
      "title": "标题"
    },{
      "id": 12,
      "url": "https://www.163.com",
      "cover": "https://t7.baidu.com/it/u=2298720277,4251451766&fm=193&f=GIF",
      "title": "标题"
    }, {
      "id": 13,
      "url": "https://www.162.com",
      "cover": "https://t7.baidu.com/it/u=3379862688,946992288&fm=193&f=GIF",
      "title": "标题"
    },{
      "id": 14,
      "url": "https://www.161.com",
      "cover": "https://t7.baidu.com/it/u=3379862688,946992288&fm=193&f=GIF",
      "title": "标题"
    }],
    "msg": "SUCCESS"}
};

var news_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "list": [{
      "id": 11,
      "schoolid": 1000,
      "publishid": 1000,
      "title": "国庆万岁",
      "author": "教导处",
      "url": "https://www.baidu.com",
      "intro": "即日国庆即日国庆即日国庆即日国庆即日国庆即日国庆即日国庆即日国庆",
      "logoimg": "https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF",
      "pageviews": 0,
      "creatime": "2021-10-10 23:38:06"
    }, {
      "id": 9,
      "schoolid": 1000,
      "publishid": 1000,
      "title": "测试文章8",
      "author": "教导处",
      "intro": "好好学习",
      "logoimg": "",
      "url": "https://www.163.com",
      "pageviews": 0,
      "creatime": "2021-10-10 23:37:17"
    }, {
      "id": 8,
      "schoolid": 1000,
      "publishid": 1000,
      "title": "测试文章7",
      "author": "天天好新闻2",
      "intro": "好好学习",
      "logoimg": "",
      "pageviews": 0,
      "creatime": "2021-10-10 23:16:07"
    }, {
      "id": 7,
      "schoolid": 1000,
      "publishid": 1000,
      "title": "测试文章6",
      "author": "天天好新闻",
      "intro": "学习",
      "logoimg": "https://chnsmile.icefire.cc/uploads/20211010/fd5749424ca2dc688dfff0841cea33e2.png",
      "pageviews": 0,
      "creatime": "2021-10-10 23:15:28"
    }],
    "msg": "SUCCESS"}
};

var notify_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "list": [
      {
        "id": 203,
        "notifytype": 0,
        "notifytitle": "今天的通知",
        "notifycontent": "今天通知各位明天不上课",
        "notifylevel": 0,
        "creatime": "2021-10-08 21:06:15",
        "creadepartment": "教育部",
        "realname": "测试校管理员"
      },
      {
        "id": 204,
        "notifytype": 0,
        "notifytitle": "今天的通知",
        "notifycontent": "今天通知各位明天不上课",
        "notifylevel": 0,
        "creatime": "2021-10-08 21:06:15",
        "creadepartment": "教育部",
        "realname": "测试校管理员"
      },
      {
        "id": 205,
        "notifytype": 0,
        "notifytitle": "今天的通知",
        "notifycontent": "今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课今天通知各位明天不上课",
        "notifylevel": 0,
        "creatime": "2021-10-08 21:06:15",
        "creadepartment": "教育部",
        "realname": "测试校管理员"
      },
      {
        "id": 206,
        "notifytype": 0,
        "notifytitle": "今天的通知",
        "notifycontent": "今天通知各位明天不上课",
        "notifylevel": 0,
        "creatime": "2021-10-08 21:06:15",
        "creadepartment": "教育部",
        "realname": "测试校管理员"
      }
    ],
    "msg": "SUCCESS"}
};

var transcript_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "list": [
      {
        "examinfo": "2021年上半9月月考试",
        "examtime": "2021-09-15",
        "examyear": "2021",
        "examday": "09/15",
        "examscore": [
          {
            "course": "语文",
            "totalscore": 85
          },
          {
            "course": "数学",
            "totalscore": 73
          }
        ]
      },
      {
        "examinfo": "2021年上半学校随堂考试",
        "examtime": "2021-09-15",
        "examyear": "2021",
        "examday": "09/15",
        "examscore": [
          {
            "course": "语文",
            "totalscore": 90
          },
          {
            "course": "数学",
            "totalscore": 85
          },
          {
            "course": "英语",
            "totalscore": 73
          }
        ]
      }
    ],
    "msg": "SUCCESS"}
};

var vote_detail = {
  "statusCode": 200,
  "msg": "SUCCESS",
  "data": {
    "id": 8,
    "votetitle": "关于秋游样投票",
    "votedesc": "关于秋游样投票",
    "votetype": 0,
    "starttime": "2021-11-02 11:00",
    "endtime": "2021-11-11 11:00",
    "isstop": 1,
    "options": [{
      "id": 26,
      "voteid": 8,
      "votelabel": "A",
      "votename": "北京",
    }, {
      "id": 27,
      "voteid": 8,
      "votelabel": "B",
      "votename": "南京",
    }, {
      "id": 28,
      "voteid": 8,
      "votelabel": "C",
      "votename": "苏州",
    }, {
      "id": 29,
      "voteid": 8,
      "votelabel": "D",
      "votename": "徐州",
    }],
    "votecount": 0
  }
};

var vote_list = {
  "statusCode": 200,
  "data": {"code": 0,
    "list": [{
      "id": 8,
      "votetitle": "关于秋游样投票",
      "votedesc": "关于秋游样投票",
      "votetype": 0,
      "starttime": "2021-11-02 11:00",
      "endtime": "2021-11-11 11:00",
      "votecount": 0,
      "isstop": 0
    }, {
      "id": 5,
      "votetitle": "投票测试2",
      "votedesc": "该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目该投票是为了检验投票项目",
      "votetype": 0,
      "starttime": "2021-10-05 19:15",
      "endtime": "2021-10-06 13:15",
      "votecount": 2,
      "isstop": 1
    }],
    "msg": "SUCCESS"}
};
