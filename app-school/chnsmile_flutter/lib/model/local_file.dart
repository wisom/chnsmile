class LocalFile {
  String path;
  String name;
  int size;
  String suffix;
  bool isAdd;

  LocalFile({this.path = "", this.name = "", this.size = 0, this.suffix = "", this.isAdd = false}); // 格式

  @override
  String toString() {
    return '$path - $name - $size - $suffix';
  }
}
