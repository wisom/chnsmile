package com.icefire.chnsmile.ui.dialog;

import android.app.Activity;
import android.app.Dialog;

import androidx.annotation.ColorInt;

import com.icefire.chnsmile.ui.dialog.dialog.BottomChooseDialog;
import com.icefire.chnsmile.ui.dialog.dialog.HomeAdDialog;
import com.icefire.chnsmile.ui.dialog.dialog.MiddleConfirmDialog;
import com.icefire.chnsmile.ui.dialog.dialog.MiddleLoadingDialog;
import com.icefire.chnsmile.ui.dialog.dialog.MuchCharacterDialog;
import com.icefire.chnsmile.ui.dialog.view.HomeView;

import java.util.List;

public class UINormalDialogManager {

    /**
     * 显示加载框
     * @param activity
     * @return
     */
    public static Dialog makeLoadingDialog(Activity activity) {
        return makeLoadingDialog(activity, "加载中");
    }

    public static Dialog makeLoadingDialog(Activity activity, String message) {
        return makeLoadingDialog(activity, message, true);
    }

    /**
     * 加载中对话框，ui类似toast
     *
     * @param activity
     * @param message
     * @param cancelable
     * @return
     */
    public static Dialog makeLoadingDialog(Activity activity, String message, boolean cancelable) {
        if (activity == null) {
            return null;
        }
        MiddleLoadingDialog dialog = new MiddleLoadingDialog(activity, message, cancelable);
        return dialog;
    }


    /**
     * 常规弹窗单按钮  重载方法
     *
     * @param activity activity
     * @param title    标题,为空不展示标题
     * @param content  内容,为空不展示内容
     * @param button   按钮文案
     * @param listener 监听
     * @return
     */
    public static Dialog showSingle(Activity activity, String title, String content, String button, SingleClickListener listener) {
        return showSingle(activity, title, content, button, false, listener);
    }

    /**
     * 常规弹窗 单按钮弹窗重载方法
     *
     * @param activity       activity
     * @param title          标题,为空不展示标题
     * @param content        内容,为空不展示内容
     * @param button         按钮文案,为空不展示按钮
     * @param backCancelable 点击外部 是否关闭弹窗
     * @param clickListener  点击监听
     * @return
     */
    public static Dialog showSingle(Activity activity, String title, String content,
                                    String button, boolean backCancelable, final SingleClickListener clickListener) {
        MiddleConfirmDialog dialog = new MiddleConfirmDialog(activity, title, content, null, button, backCancelable, new MiddleConfirmDialog.MiddleConfirmCallback() {
            @Override
            public void onLeftClick(String content) {

            }

            @Override
            public void onRightClick(String content) {
                if (clickListener != null) {
                    clickListener.onClicked();
                }
            }

            @Override
            public void onCancel() {

            }
        });

        dialog.show();

        return dialog;
    }

    /**
     * 常规弹窗带字体颜色 重载方法
     *
     * @param activity           activity
     * @param title              标题,为空不展示标题
     * @param content            内容,为空不展示内容
     * @param leftButton         左边按钮文案,为空不展示按钮
     * @param rightButton        右边按钮文案,为空不展示按钮
     * @param listener           点击监听
     * @param leftButtonColorId  左边按钮颜色
     * @param rightButtonColorId 右边按钮颜色
     * @return
     */
    public static Dialog show(Activity activity, String title, String content, String leftButton,
                              String rightButton, ClickListener listener, @ColorInt int leftButtonColorId, @ColorInt int rightButtonColorId) {
        return show(activity, title, content, leftButton, rightButton, true, listener
                , true, leftButtonColorId, rightButtonColorId);
    }

    /**
     * 常规弹窗缺省默认值 重载方法
     *
     * @param activity    activity
     * @param title       标题,为空不展示标题
     * @param content     内容,为空不展示内容
     * @param leftButton  左边按钮文案,为空不展示按钮
     * @param rightButton 右边按钮文案,为空不展示按钮
     * @param listener    点击监听
     * @return
     */
    public static Dialog show(Activity activity, String title, String content, String leftButton, String rightButton, ClickListener listener) {
        return show(activity, title, content, leftButton, rightButton, true, listener, true, 0, 0);
    }

    /**
     * 常规弹窗
     *
     * @param activity              activity
     * @param title                 标题,为空不展示标题
     * @param content               内容,为空不展示内容
     * @param leftButton            左边按钮文案,为空不展示按钮
     * @param rightButton           右边按钮文案,为空不展示按钮
     * @param backCancelable        点击外部 是否关闭弹窗
     * @param clickListener         点击监听
     * @param cancelByClickedButton 点击按钮是否关闭弹窗
     * @param leftButtonColorId     左边按钮颜色
     * @param rightButtonColorId    右边按钮颜色
     * @return
     */
    public static Dialog show(Activity activity, String title, String content,
                              String leftButton, String rightButton, boolean backCancelable, final ClickListener clickListener, final boolean cancelByClickedButton,
                              @ColorInt int leftButtonColorId, @ColorInt int rightButtonColorId) {
        MiddleConfirmDialog dialog = new MiddleConfirmDialog(activity, title, content, leftButton, rightButton, backCancelable, cancelByClickedButton, new MiddleConfirmDialog.MiddleConfirmCallback() {
            @Override
            public void onLeftClick(String content) {
                if (clickListener != null) {
                    clickListener.onLeftClicked();
                }
            }

            @Override
            public void onRightClick(String content) {
                if (clickListener != null) {
                    clickListener.onRightClicked();
                }
            }

            @Override
            public void onCancel() {

            }
        });
        if (rightButtonColorId != 0) {
            dialog.setRightButtonColor(rightButtonColorId);
        }
        if (leftButtonColorId != 0) {
            dialog.setLeftButtonColor(leftButtonColorId);
        }
        dialog.show();
        return dialog;
    }

    /**
     * 插图弹窗 缺省默认值 重载方法
     *
     * @param activity              activity
     * @param title                 标题,为空不展示标题
     * @param content               内容,为空不展示内容
     * @param iconResId             图片资源id
     * @param leftButton            左边按钮文案,为空不展示按钮
     * @param rightButton           右边按钮文案,为空不展示按钮
     * @param backCancelable        点击外部 是否关闭弹窗
     * @param showClose             是否展示关闭按钮
     * @param cancelByClickedButton 点击按钮是否关闭弹窗
     * @param clickListener         监听
     * @return
     */
    public static MiddleConfirmDialog showWithIcon(Activity activity, String title, String content, int iconResId, String leftButton, String rightButton,
                                                   boolean backCancelable, boolean showClose, final boolean cancelByClickedButton, final ClickListener clickListener) {
        return showWithIcon(activity, title, content, iconResId, leftButton, rightButton, backCancelable, showClose, cancelByClickedButton, 0, 0, clickListener);
    }

    /**
     * 插图弹窗
     *
     * @param activity              activity
     * @param title                 标题,为空不展示标题
     * @param content               内容,为空不展示内容
     * @param iconResId             图片资源id
     * @param leftButton            左边按钮文案,为空不展示按钮
     * @param rightButton           右边按钮文案,为空不展示按钮
     * @param backCancelable        点击外部 是否关闭弹窗
     * @param showClose             是否展示关闭按钮
     * @param cancelByClickedButton 点击按钮是否关闭弹窗
     * @param leftButtonColorId     左边按钮颜色
     * @param rightButtonColorId    右边按钮颜色
     * @param clickListener         监听
     * @return
     */
    public static MiddleConfirmDialog showWithIcon(Activity activity, String title, String content,
                                                   int iconResId, String leftButton, String rightButton,
                                                   boolean backCancelable, boolean showClose, final boolean cancelByClickedButton,
                                                   @ColorInt int leftButtonColorId, @ColorInt int rightButtonColorId
            , final ClickListener clickListener) {
        MiddleConfirmDialog dialog = new MiddleConfirmDialog(activity, iconResId, title, content, leftButton, rightButton, backCancelable,
                cancelByClickedButton, showClose, new MiddleConfirmDialog.MiddleConfirmCallback() {
            @Override
            public void onLeftClick(String content) {
                if (clickListener != null) {
                    clickListener.onLeftClicked();
                }
            }

            @Override
            public void onRightClick(String content) {
                if (clickListener != null) {
                    clickListener.onRightClicked();
                }
            }

            @Override
            public void onCancel() {

            }
        });
        if (rightButtonColorId != 0) {
            dialog.setRightButtonColor(rightButtonColorId);
        }
        if (leftButtonColorId != 0) {
            dialog.setLeftButtonColor(leftButtonColorId);
        }
        dialog.show();

        return dialog;
    }

    /**
     * 营销广告 点击
     *
     * @param activity           activity
     * @param list               list
     * @param clickListener      clickListener
     * @param pageChangeListener pageChangeListener
     * @return dialog
     */
    public static HomeAdDialog showAdDialog(Activity activity, List<String> list, HomeAdDialog.OnClickListener clickListener,
                                            HomeView.OnPageChangeListener pageChangeListener) {
        HomeAdDialog homeAdDialog = new HomeAdDialog(activity, list, clickListener, pageChangeListener);
        homeAdDialog.show();
        return homeAdDialog;
    }

    /**
     * 多文字弹窗,如果只有一个主button，建议用竖着的
     *
     * @param activity
     * @param title                        标题
     * @param content                      内容
     * @param subButton                    左边或上面按钮文案
     * @param button                       右边或下面按钮文案
     * @param isHorizontal                 是否是水平按钮布局
     * @param showClose                    是否展示关闭按钮
     * @param muchCharacterConfirmCallback 回调
     * @return
     */
    public static MuchCharacterDialog showMuchCharacterDialog(Activity activity, String title, String content, String subButton, String button,
                                                              boolean isHorizontal, boolean showClose,
                                                              MuchCharacterDialog.MuchCharacterConfirmCallback muchCharacterConfirmCallback) {
        MuchCharacterDialog dialog = new MuchCharacterDialog(activity, title, content, subButton, button, isHorizontal, showClose, true, muchCharacterConfirmCallback);
        dialog.show();
        return dialog;
    }


    public static BottomChooseDialog showBottomChooseDialog(Activity activity, String title, String footer, List<String> items, BottomChooseDialog.BottomChooseCallback callback) {
        BottomChooseDialog dialog = new BottomChooseDialog(activity, title, footer, items,callback);
        dialog.show();
        return dialog;
    }

    public static abstract class ClickListener {
        public void onLeftClicked() {
        }

        public abstract void onRightClicked();
    }

    public static interface SingleClickListener {
        void onClicked();
    }
}
