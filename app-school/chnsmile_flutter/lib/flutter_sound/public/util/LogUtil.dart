/// Log工具类：打印日志相关
///
/// @author zony
/// @time 2022/4/7 14:49
class LogUtil {
  /// 默认日志TAG
  static const String _TAG_DEF = "LogUtil: ";

  /// 是否打开输出日志，true：log输出
  static bool debuggable = true;

  /// 日志TAG
  static String TAG = _TAG_DEF;

  /// 运行在Release环境时，inProduction为true；
  /// 当App运行在Debug和Profile环境时，inProduction为false。
  static const bool inProduction = bool.fromEnvironment("dart.vm.product");

  ///
  /// 初始化log
  ///
  /// [isOpenLog] 是否打开日志
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:45
  static void init({bool isOpenLog = false, String tag = _TAG_DEF}) {
    debuggable = isOpenLog;
    TAG = tag;
  }

  ///
  /// 打印INFO日志
  ///
  /// [object] 打印object内容
  /// [tag] tag标识
  /// @author zony
  /// @time 2022/4/7 14:47
  static void i(Object object, {String tag = _TAG_DEF}) {
    if (debuggable) {
      _printLog(tag, '  i  ', object);
    }
  }

  static void e(Object object, {String tag}) {
    if (debuggable) {
      _printLog(tag, '  e  ', object);
    }
  }

  static void v(Object object, {String tag}) {
    if (debuggable) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void d(String tag, Object object) {
    if (debuggable) {
      _printLog(tag, '  d  ', object);
    }
  }

  // static void d(Object object, {String tag}) {
  //   if (debuggable) {
  //     _printLog(tag, '  d  ', object);
  //   }
  // }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = StringBuffer();
    sb.write((tag == null || tag.isEmpty) ? TAG : tag);
    sb.write(stag);
    sb.write(object);
    print(sb.toString());
  }
}
