import 'package:chnsmile_flutter/model/contact_select.dart';

class ListUtils {

  static List<ContactSelect> selecters = [];

  static void cleanSelecter() {
    selecters.clear();
  }

  /// 是否选择了层级floor
  static bool isSelectFloor() {
    bool founded = false;
    for (var element in selecters) {
      if (element.floor != null) {
        founded = true;
      }
    }
    return founded;
  }

  /// 组织是否存在
  static bool containDep(String depId) {
    bool founded = false;
    for (var element in selecters) {
      if (element.isDep && depId == element.id) {
        founded = true;
      }
    }
    return founded;
  }

  /// 人员是否存在
  static bool containContact(String id) {
    bool founded =false;
    for (var element in selecters) {
      if (id == element.id) {
        founded = true;
      }
    }
    return founded;
  }

  static void addOrRemoveContact(ContactSelect item) {
    bool founded =false;
    for (var element in selecters) {
      if (item.id == element.id) {
        founded = true;
      }
    }

    if (founded) {
      print("founded==");
      selecters.remove(item);
    } else {
      print("no founded==");
      selecters.add(item);
    }
  }

  static void swapList<E>(List<E> list,int index1,int index2) {
    E e1 = list[index1];
    E e2 = list[index2];
    list[index1] = e2;
    list[index2] = e1;
  }
}