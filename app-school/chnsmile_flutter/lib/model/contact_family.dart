class ContactFamily {
  String classId;
  String userId;
  String studentId;

  ContactFamily(this.classId, this.userId,this.studentId);

  @override
  bool operator == (Object other) {
    ContactFamily o = other;
    return userId == o.userId && classId == o.classId && studentId == o.studentId;
  }

  @override
  int get hashCode {
    return classId.hashCode + userId.hashCode + studentId.hashCode;
  }

  @override
  String toString() {
    return '$classId - $userId - $studentId';
  }

}