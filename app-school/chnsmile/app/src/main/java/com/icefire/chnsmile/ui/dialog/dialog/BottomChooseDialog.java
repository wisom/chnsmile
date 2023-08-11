package com.icefire.chnsmile.ui.dialog.dialog;

import android.content.Context;
import android.content.DialogInterface;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;
import com.icefire.chnsmile.ui.dialog.base.UIBottomDialog;

import java.util.List;


public class BottomChooseDialog extends UIBottomDialog implements DialogInterface.OnCancelListener {

    private final BottomChooseCallback mCallback;
    private final String mFooter;
    private  String mTitle;
    private final List<String> mItems;

    /**
     * @param context
     * @param footer   脚文案
     * @param items    选项文案列表
     * @param callback
     */
    public BottomChooseDialog(@NonNull Context context, String footer, List<String> items, BottomChooseCallback callback) {
        this(context,null,footer,items,callback);
    }

    /**
     * @param context
     * @param title    标题文案
     * @param footer   脚文案
     * @param items    选项文案列表
     * @param callback
     */
    public BottomChooseDialog(@NonNull Context context,String title, String footer, List<String> items, BottomChooseCallback callback) {
        super(context);
        mTitle = title;
        mFooter = footer;
        mItems = items;
        mCallback = callback;
        setOnCancelListener(this);
    }



    @Override
    protected View createContentView() {
        final View rootView = LayoutInflater.from(mContext).inflate(R.layout.ui_bottomview_simplestring, null);
        final TextView titleView = (TextView) rootView.findViewById(R.id.ui_bottom_choose_tv_title);
        final View titleLine = (View) rootView.findViewById(R.id.ui_bottom_choose_view_title__line);

        if (TextUtils.isEmpty(mTitle)) {
            titleView.setVisibility(View.GONE);
            titleLine.setVisibility(View.GONE);
        } else {
            titleView.setVisibility(View.VISIBLE);
            titleLine.setVisibility(View.VISIBLE);
            titleView.setText(mTitle);
        }

        //配置footer
        final TextView footerView = (TextView) rootView.findViewById(R.id.ui_bottom_choose_tv_footer);
        View.OnClickListener viewListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (v == footerView) {
                    //点击 footer
                    if (mCallback != null) {
                        mCallback.onFooterClick(footerView.getText().toString());
                    }
                    dismiss();
                }
            }
        };

        rootView.setOnClickListener(viewListener);
        if (TextUtils.isEmpty(mFooter)) {
            footerView.setVisibility(View.GONE);
        } else {
            footerView.setText(mFooter);
            footerView.setOnClickListener(viewListener);
        }

        //配置选项列表
        ListView listView = (ListView) rootView.findViewById(R.id.ui_bottom_choose_listview);
        listView.setAdapter(new ArrayAdapter(mContext, R.layout.ui_bottomview_textitem, mItems));
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (mCallback != null) {
                    mCallback.onItemClick(position, ((TextView) view).getText().toString());
                }
                dismiss();
            }
        });

        return rootView;
    }

    @Override
    public void onCancel(DialogInterface dialog) {
        if (mCallback != null) {
            mCallback.onCancel();
        }
    }

    public interface BottomChooseCallback {
        /**
         * footer 点击回调
         *
         * @param content footer内容
         */
        void onFooterClick(String content);

        /**
         * 选项点击回调
         *
         * @param index       从上到下顺序，index 从 0 开始
         * @param itemContent 选项内容
         */
        void onItemClick(int index, String itemContent);

        /**
         * 点击后退 或 点击内容外部阴影区域
         */
        void onCancel();
    }

}
