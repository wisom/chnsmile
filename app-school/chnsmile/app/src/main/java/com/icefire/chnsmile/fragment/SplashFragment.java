package com.icefire.chnsmile.fragment;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Process;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.method.LinkMovementMethod;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.blankj.utilcode.util.ActivityUtils;
import com.blankj.utilcode.util.IntentUtils;
import com.blankj.utilcode.util.Utils;
import com.icefire.chnsmile.MainApplication;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.activity.SplashActivity;
import com.icefire.chnsmile.activity.WebViewActivity;
import com.icefire.chnsmile.core.ConfigurationManager;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.LibraryInit;
import com.icefire.chnsmile.core.Router;
import com.icefire.chnsmile.ui.UrlClickSpan;
import com.icefire.chnsmile.ui.dialog.dialog.MiddleConfirmDialog;

public class SplashFragment extends Fragment {

    private MiddleConfirmDialog quitDialog;
    private SplashActivity mActivity;
    private RelativeLayout mLLprotocol;
    private TextView mTextContent1;
    private TextView mTextContent2;
    private RelativeLayout mRLGuide;
    private Button mButtonNow;
    private ViewPager mVpGuide;

    private int[] mGuideRes = new int[]{
            R.drawable.guide_01, R.drawable.guide_02, R.drawable.guide_03, R.drawable.guide_04
    };


    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mActivity = (SplashActivity) getActivity();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View rootView = View.inflate(getContext(), R.layout.fragment_splash, null);
        initView(rootView);
        return rootView;
    }

    private void initView(View rootView) {
        mRLGuide = rootView.findViewById(R.id.load_rl_guide_container);
        mTextContent1 = rootView.findViewById(R.id.load_protocol_content1);
        mTextContent2 = rootView.findViewById(R.id.load_protocol_content3);
        mLLprotocol = rootView.findViewById(R.id.load_protocol_container);
        mVpGuide = rootView.findViewById(R.id.load_guide_viewPager);
        mButtonNow = rootView.findViewById(R.id.load_guide_start);
        setupText1();
        setupText2();

        mButtonNow.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ConfigurationManager.instance().setBoolean(Constants.PREF_KEY_FIRST_ENTER, false);
                mActivity.startAppActivity();
            }
        });

        rootView.findViewById(R.id.load_protocol_agree).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                agree();
            }
        });
        rootView.findViewById(R.id.load_protocol_disagree).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                disAgree();
            }
        });
    }

    private void setupText1() {
        String content = mTextContent1.getText().toString();
        int firstStart = content.indexOf("《");
        int firstEnd = content.indexOf("》");
        int secondStart = content.indexOf("《", firstEnd + 1);
        int secondEnd = content.indexOf("》", firstEnd + 1);

        SpannableString spannableString = new SpannableString(content);
        ForegroundColorSpan foregroundColorSpan = new ForegroundColorSpan(getResources().getColor(R.color.ui_brand_color));
        UrlClickSpan firstClickSpan = new UrlClickSpan(Constants.PERSONAL_POLICY);
        UrlClickSpan secondClickSpan = new UrlClickSpan(Constants.AGREEMENT);

        spannableString.setSpan(firstClickSpan, firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(foregroundColorSpan, firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        spannableString.setSpan(secondClickSpan, secondStart, secondEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(foregroundColorSpan, secondStart, secondEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        mTextContent1.setText(spannableString);
        mTextContent1.setMovementMethod(LinkMovementMethod.getInstance());
    }

    private void setupText2() {
        String content = mTextContent2.getText().toString();
        int firstStart = content.indexOf("《");
        int firstEnd = content.indexOf("》");

        SpannableString spannableString = new SpannableString(content);
        ForegroundColorSpan foregroundColorSpan = new ForegroundColorSpan(getResources().getColor(R.color.ui_brand_color));
        UrlClickSpan firstClickSpan = new UrlClickSpan(Constants.PERSONAL_POLICY);

        spannableString.setSpan(firstClickSpan, firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);
        spannableString.setSpan(foregroundColorSpan, firstStart, firstEnd + 1, Spanned.SPAN_INCLUSIVE_INCLUSIVE);

        mTextContent2.setText(spannableString);
        mTextContent2.setMovementMethod(LinkMovementMethod.getInstance());
    }

    private void agree() {
        // 初始化
        ConfigurationManager.instance().setBoolean(Constants.PREF_KEY_PROTOCOL_STATUS, true);
        LibraryInit.initAllLibrary(MainApplication.application);
        // 进入引导页面
        if (ConfigurationManager.instance().getBoolean(Constants.PREF_KEY_FIRST_ENTER)) {
            showGuide();
        } else {
            mActivity.startAppActivity();
        }
    }

    private void showGuide() {
        mLLprotocol.setVisibility(View.GONE);
        mRLGuide.setVisibility(View.VISIBLE);
        mVpGuide.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (position == mGuideRes.length - 1) {//最后一页
                    mButtonNow.setVisibility(View.VISIBLE);
                } else {
                    mButtonNow.setVisibility(View.GONE);
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        mVpGuide.setAdapter(new GuidePageAdapter());

    }

    private void disAgree() {
        quitDialog = new MiddleConfirmDialog(getActivity(), 0, getString(R.string.dialog_prototal_content), null,
                getString(R.string.dialog_prototal_calcel), getString(R.string.dialog_prototal_ok), false, false, false,
                new MiddleConfirmDialog.MiddleConfirmCallback() {
                    @Override
                    public void onLeftClick(String content) {
                        if (quitDialog != null) {
                            quitDialog.dismiss();
                        }
                        //杀掉当前进程
//                        Process.killProcess(Process.myPid());
                    }

                    @Override
                    public void onRightClick(String content) {
                        if (quitDialog != null) {
                            quitDialog.dismiss();
                        }
                        String url = Constants.PERSONAL_POLICY;
                        Router.open("smile://" + Constants.SP_WEBVIEW + "?url=" + url);
//                        try {
//                            Uri uri = Uri.parse(Constants.PERSONAL_POLICY);
//                            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
//                            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                            Utils.getApp().startActivity(intent);
//                        } catch (Exception e) {
//                            e.printStackTrace();
//                        }
                    }

                    @Override
                    public void onCancel() {

                    }
                });
        quitDialog.setLeftButtonColor(getContext().getResources().getColor(R.color.ui_brand_color));
        quitDialog.show();
    }


    private class GuidePageAdapter extends PagerAdapter {

        @Override
        public int getCount() {
            return mGuideRes.length;
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }

        @Override
        public Object instantiateItem(ViewGroup container, int position) {
            ImageView iv = new ImageView(mActivity);
            iv.setScaleType(ImageView.ScaleType.FIT_XY);
            container.addView(iv);
            iv.setImageResource(mGuideRes[position]);
            return iv;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }
    }


}
