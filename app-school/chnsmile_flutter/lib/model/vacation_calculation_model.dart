class VacationCalculationModel {
  String dateStart;
  String dateEnd;
  String hours;

  VacationCalculationModel({this.dateStart, this.dateEnd, this.hours});

  VacationCalculationModel.fromJson(Map<String, dynamic> json) {
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    hours = json['hours'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['hours'] = this.hours;
    return data;
  }
}
