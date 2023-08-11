package com.icefire.chnsmile.ui.dialog.view;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;


import androidx.annotation.NonNull;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import com.bumptech.glide.Glide;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.uils.ViewUtil;

import java.util.ArrayList;
import java.util.List;

public class HomeView extends RelativeLayout {

    private ViewPager mViewPager;
    private ViewGroup mCircleContainer;
    private List<String> mImgList;
    private int mPosition;
    private View adContainer;
    /**
     * 广告宽度占屏幕宽度比例
     */
    private static final float AD_WIDTH_RATIO = 0.72F;
    /**
     * 广告高度占广告宽度比例
     */
    private static final float AD_HEIGHT_RATIO = 1.333F;

    private ArrayList<View> mCircleViewList = new ArrayList<View>();
    /**
     * 等待时长
     */
    private static final long WAITING_TIME = 3000;

    private Handler mHandler = new Handler(Looper.getMainLooper());

    private Runnable task = new Runnable() {
        @Override
        public void run() {
            int position = mPosition;
            position++;

            mViewPager.setCurrentItem(position);
            mHandler.postDelayed(task, WAITING_TIME);
        }
    };
    private ClickListener mListener;
    private boolean isInit;
    private List<String> mAdInfos;
    private OnPageChangeListener mOnPageChangeListener;

    public HomeView(Context context) {
        this(context, null);
    }

    public HomeView(Context context, AttributeSet attrs) {
        super(context, attrs);

        initView(context);
    }

    private void initView(Context context) {
        isInit = true;
        //创建viewPager 和 下面角标的view
        ViewGroup rootView = (ViewGroup) LayoutInflater.from(context).inflate(R.layout.ui_ad_view, null);
        //考虑设置数据的操作在布局没出来之前设置
        mViewPager = rootView.findViewById(R.id.ui_ad_viewpager);
        mCircleContainer = rootView.findViewById(R.id.ui_ad_bottom_circle_container);
        adContainer = rootView.findViewById(R.id.ui_ad_container);

        addView(rootView);
        setData(mAdInfos);
        initAdWindowSize();
    }

    /**
     * 设置化广告宽高
     */
    private void initAdWindowSize() {
        try {
            DisplayMetrics dm = getResources().getDisplayMetrics();
            int width = (int) (dm.widthPixels * AD_WIDTH_RATIO);
            if (width > 0) {
                int height = (int) (width * AD_HEIGHT_RATIO);
                ViewGroup.LayoutParams layoutParams = adContainer.getLayoutParams();
                layoutParams.width = width;
                layoutParams.height = height;
                adContainer.setLayoutParams(layoutParams);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置数据
     *
     * @param adInfos 图片列表
     */
    public void setData(List<String> adInfos) {
        if (adInfos == null || adInfos.size() == 0) {
            return;
        }

        mAdInfos = adInfos;


        ArrayList<String> imgsList = new ArrayList<>();
        for (String adInfo : adInfos) {
            imgsList.add(adInfo);
        }


        if (!isInit) {
            return;
        }

        mHandler.removeCallbacks(task);

        mImgList = imgsList;

        //添加圆圈控件
        if (imgsList.size() == 1) {
            //如果只有一张图片，圆圈不显示
            mCircleContainer.setVisibility(View.INVISIBLE);
        }

        initCircle();

        //设置数据
        MyViewPagerAdapter mViewPagerAdapter = new MyViewPagerAdapter();
        mViewPager.setAdapter(new MyViewPagerAdapter());
        mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                mPosition = position;
                changeColor(mPosition);
                if (mOnPageChangeListener != null) {
                    final int processPosition = position % mImgList.size();
                    mOnPageChangeListener.onChange(position, mAdInfos.get(processPosition));
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        //第一次显示的埋点
        if (mOnPageChangeListener != null) {
            mOnPageChangeListener.onChange(0, mAdInfos.get(0));
        }


        mViewPager.setCurrentItem(mImgList.size() * 100, false);
        changeColor(0);

        if (mImgList.size() > 1) {
            startTask();
        }
    }

    /**
     * 开启任务
     */
    private void startTask() {
        mHandler.postDelayed(task, WAITING_TIME);
    }

    /**
     * 停止全部任务和延时任务
     */
    public void stopTask() {
        mHandler.removeCallbacksAndMessages(null);
    }

    /**
     * 切换圆圈状态
     *
     * @param position
     */
    private void changeColor(int position) {
        position = position % mImgList.size();
        if (mCircleViewList == null) {
            return;
        }
        for (View circleView : mCircleViewList) {
            circleView.setSelected(false);
        }

        View view = mCircleViewList.get(position);
        if (view != null) {
            view.setSelected(true);
        }

    }

    /**
     * s
     * 根据数据初始化圆圈
     */
    private void initCircle() {
        mCircleContainer.removeAllViews();
        mCircleViewList.clear();

        for (int i = 0; i < mImgList.size(); i++) {
            View view = new View(getContext());
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewUtil.dp2px(7), ViewUtil.dp2px(7));
            layoutParams.leftMargin = ViewUtil.dp2px(4);
            layoutParams.rightMargin = ViewUtil.dp2px(4);
            view.setLayoutParams(layoutParams);
            view.setBackgroundResource(R.drawable.ui_ad_circle_bg);
            mCircleContainer.addView(view);
            mCircleViewList.add(view);
        }
    }


    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        int action = ev.getAction();
        if (action == MotionEvent.ACTION_UP || action == MotionEvent.ACTION_CANCEL
                || action == MotionEvent.ACTION_OUTSIDE) {
            startTask();
        } else if (action == MotionEvent.ACTION_DOWN) {
            stopTask();
        }
        return super.dispatchTouchEvent(ev);
    }

    private class MyViewPagerAdapter extends PagerAdapter {

        @Override
        public int getCount() {
            return mImgList == null ? 0 : mImgList.size() == 1 ? 1 : Integer.MAX_VALUE;
        }

        @Override
        public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
            return view == object;
        }

        @NonNull
        @Override
        public Object instantiateItem(@NonNull ViewGroup container, int position) {
            final int processPosition = position % mImgList.size();
            //创建图片布局

            View view = LayoutInflater.from(getContext()).inflate(R.layout.ui_dialog_img_view,null,false);
            ImageView imageView = view.findViewById(R.id.ui_dialog_img);
//
            try {
                Glide.with(imageView).load(mImgList.get(processPosition)).centerCrop().into(imageView);
            } catch (Exception e) {
                e.printStackTrace();
            }
            imageView.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    mListener.onclick(processPosition, mAdInfos.get(processPosition));
                }
            });

            container.addView(view);


            //加载图片资源
            return view;
        }

        @Override
        public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
            container.removeView((View) object);
        }

    }

    public void setOnItemClickListener(ClickListener listener) {
        mListener = listener;
    }

    public void setOnPageChangeListener(OnPageChangeListener onPageChangeListener) {
        mOnPageChangeListener = onPageChangeListener;
    }

    public interface ClickListener {
        /**
         * 点击的index  和 携带的数据
         *
         * @param index
         * @param adInfo
         */
        void onclick(int index, String adInfo);
    }

    /**
     * 页面变化的监听回调
     */
    public interface OnPageChangeListener {
        void onChange(int index, String adInfo);
    }
}
