class FundManagerItemParam {
  String itemId;
  String expendName;
  double price;
  double amount;
  double count;
  String unit;
  String remark;


  FundManagerItemParam({this.itemId, this.expendName, this.price, this.amount,
      this.count, this.unit, this.remark});

  FundManagerItemParam.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    expendName = json['expendName'];
    price = json['price'];
    count = json['count'];
    amount = json['amount'];
    unit = json['unit'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['expendName'] = expendName;
    data['price'] = price;
    data['count'] = count;
    data['amount'] = amount;
    data['unit'] = unit;
    data['remark'] = remark;
    return data;
  }
}
