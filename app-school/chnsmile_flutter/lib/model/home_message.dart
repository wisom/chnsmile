class HomeMessage {
  String name;
  String page;
  int unCountMessage;
  String iconPath;
  String tag;  // 跟后台的权限标识
  String tag2; // 跟后台的未读标识

  HomeMessage(this.name, this.iconPath, this.page,{ this.tag = "", this.tag2 = "", this.unCountMessage = 0});
}
