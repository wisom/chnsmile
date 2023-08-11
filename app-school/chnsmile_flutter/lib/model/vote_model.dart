import 'package:chnsmile_flutter/model/vote.dart';

class VoteModel {
    int total;
    List<Vote> list;

    VoteModel.fromJson(Map<String, dynamic> json) {
      total = json['totalRows'];
      if (json['rows'] != null) {
        list = List<Vote>.empty(growable: true);
        json['rows'].forEach((v) {
          list.add(Vote.fromJson(v));
        });
      }
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['total'] = total;
      data['list'] = list.map((v) => v.toJson()).toList();
      return data;
    }
}

