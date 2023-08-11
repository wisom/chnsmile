import 'package:chnsmile_flutter/widget/empty_view.dart';
import 'package:chnsmile_flutter/widget/select_attach.dart';
import 'package:flutter/material.dart';
import 'package:hi_base/view_util.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool isEmpty;
  final bool cover;
  final Function onRefreshClick;
  final String emptyString;

  const LoadingContainer(
      {Key key, this.isLoading, this.child, this.emptyString = "暂时没有相关内容", this.isEmpty = false, this.cover = true, this.onRefreshClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [child, isLoading ? _loadingView : _emptyView],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
  }

  Widget get _emptyView {
    return isEmpty ? EmptyView(emptyString: emptyString, onRefreshClick: onRefreshClick) : Container();
  }

  Widget get _loadingView {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
              ),
            ),
            hiSpace(height: 8),
            const Text('加载中...', style: TextStyle(fontSize: 13, color: Colors.black54))
          ],
        )
    );
  }
}
