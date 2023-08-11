package com.icefire.chnsmile.uils;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;


public class ViewUtil {
    private static final String TAG = "ViewUtil";

    public static String value(TextView textView) {
        if (textView == null) {
            return "";
        }
        return textView.getText().toString();
    }

    public static boolean isEmtyp(TextView textView) {
        if (textView == null) {
            return true;
        }
        return TextUtils.isEmpty(textView.getText().toString());
    }


    public static void setText(TextView view, String content) {
        if (view == null) {
            return;
        }
        view.setText(content);
    }

    public static void setText(TextView view, int content) {
        if (view == null) {
            return;
        }
        view.setText(content+"");
    }

    public static void setText(View rootView, int textViewID, String content) {
        if (rootView == null) {
            return;
        }
        ((TextView) rootView.findViewById(textViewID)).setText(content);
    }

    public static void setTextAndShow(TextView view, String content) {
        if (view == null) {
            return;
        }
        view.setText(content);
        view.setVisibility(View.VISIBLE);
    }


    public static void setTextResID(TextView view, int resID) {
        if (view == null) {
            return;
        }
        if (resID <= 0) {
            view.setText("");
        }else {
            view.setText(resID);
        }
    }


    public static void setImage(ImageView view, String url) {
        if (view == null) {
            return;
        }

    }

    public static void gone(View... views) {
        for (View v : views) {
            if (v == null) {
                continue;
            }
            v.setVisibility(View.GONE);
        }
    }

    public static void gone(View rootView, int id) {
        if (rootView == null) {
            return;
        }
        gone(rootView.findViewById(id));
    }

    public static void clear(TextView... views) {
        if (views == null) {
            return;
        }
        for (TextView textView : views) {
            setText(textView, "");
        }
    }

    public static void visible(View... views) {
        for (View v : views) {
            if (v == null) {
                continue;
            }
            v.setVisibility(View.VISIBLE);
        }
    }

    public static void invisible(View... views) {
        for (View v : views) {
            if (v == null) {
                continue;
            }
            v.setVisibility(View.INVISIBLE);
        }
    }

    public static void enable(View... views) {
        setEnable(true, views);
    }

    public static void disable(View... views) {
        setEnable(false, views);
    }

    private static void setEnable(boolean enable, View... views) {
        for (View v : views) {
            if (v == null) {
                continue;
            }
            v.setEnabled(enable);
        }
    }

    public static <T extends View> T f(View root, int idRes) {
        if (root == null) {
            return null;
        }
        return (T) root.findViewById(idRes);
    }

    public static Rect getTextBounds(Paint paint, String content) {
        if (TextUtils.isEmpty(content)) {
            return new Rect();
        }
        Rect rect = new Rect();
        paint.getTextBounds(content, 0, content.length(), rect);
        return rect;
    }

    public static int getTextHeight(Paint paint, String content) {
        Rect rect = getTextBounds(paint, content);
        return rect.height();
    }


    public static int getTextWidth1(Paint paint, String content) {
        Rect rect = getTextBounds(paint, content);
        return rect.width();
    }

    public static int dp2px(float dipValue) {
        float m = Resources.getSystem().getDisplayMetrics().density;
        return (int) (dipValue * m + 0.5f);
    }

    public static int px2dp(float pxValue) {
        float m = Resources.getSystem().getDisplayMetrics().density;
        return (int) (1.0* pxValue / m + 0.5f);
    }

    public static void setVisibility(View view, int i) {
        if (view != null) {
            view.setVisibility(i);
        }
    }

    public static void setCompoundTopDrawable(Context ctx, int drawableId, TextView tv){
        if(drawableId <=0 || tv == null){
            return;
        }
        Drawable drawable = ctx.getResources().getDrawable(drawableId);
        drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
        tv.setCompoundDrawables(null, drawable, null, null);
    }

    public static void setCompoundLeftDrawable(Context ctx, int drawableId, TextView tv){
        if(drawableId <=0 || tv == null){
            return;
        }
        Drawable drawable = ctx.getResources().getDrawable(drawableId);
        drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
        tv.setCompoundDrawables(drawable, null, null, null);
    }
}
