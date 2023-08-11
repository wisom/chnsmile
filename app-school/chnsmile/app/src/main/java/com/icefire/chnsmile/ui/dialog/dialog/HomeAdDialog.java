package com.icefire.chnsmile.ui.dialog.dialog;

import android.content.Context;
import android.content.DialogInterface;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;

import com.icefire.chnsmile.R;
import com.icefire.chnsmile.ui.dialog.base.UIMiddleDialog;
import com.icefire.chnsmile.ui.dialog.view.HomeView;

import java.util.List;


public class HomeAdDialog extends UIMiddleDialog implements DialogInterface.OnDismissListener {

    private final OnClickListener mOnClickListener;
    private final List<String> mAdInfos;
    private final HomeView.OnPageChangeListener mOnPageChangeListener;
    private HomeView mCCCXHomeView;

    public HomeAdDialog(@NonNull Context context, List<String> adInfos, OnClickListener onClickListener, HomeView.OnPageChangeListener onPageChangeListener) {
        super(context);
        mAdInfos = adInfos;
        mOnClickListener = onClickListener;
        mOnPageChangeListener = onPageChangeListener;
        setOnDismissListener(this);
    }


    @Override
    protected View createContentView() {
        View rootView = LayoutInflater.from(mContext).inflate(R.layout.ui_dialog_main_ad, null);
        mCCCXHomeView = rootView.findViewById(R.id.ui_hav);


        mCCCXHomeView.setOnPageChangeListener(mOnPageChangeListener);

        mCCCXHomeView.setData(mAdInfos);
        mCCCXHomeView.setOnItemClickListener(new HomeView.ClickListener() {
            @Override
            public void onclick(int index, String adInfo) {
                mOnClickListener.onItemClick(index, adInfo);
                if (mAdInfos != null && mAdInfos.size() == 1) {
                    dismiss();
                }
            }
        });


        rootView.findViewById(R.id.iv_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });


        return rootView;
    }

    @Override
    public void onDismiss(DialogInterface dialog) {
        if (mOnClickListener != null) {
            mOnClickListener.onClose();
        }
        mCCCXHomeView.stopTask();
    }

    public interface OnClickListener {
        /**
         * 点击关闭
         */
        void onClose();

        /**
         * 点击item
         *
         * @param index
         * @param adInfo
         */
        void onItemClick(int index, String adInfo);
    }
}
