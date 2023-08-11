class QuestionType {
  String content;//单选、多选、填空
  String imgRes;//图标资源地址
  int type;//0=单选、1=多选、2=填空

  QuestionType( {
    this.content, this.imgRes,this.type,
  });
}