package com.icefire.chnsmile.uils;

import android.os.Bundle;
import android.text.TextUtils;


import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.icefire.chnsmile.MainApplication;
import com.icefire.chnsmile.R;

import java.util.HashMap;
import java.util.Map;

public class MyFragmentManager {

    private String lastFragmentTag;

    private FragmentManager mFragmentManager;
    private Fragment currentFragment;

    public MyFragmentManager(FragmentActivity context) {
        this.mFragmentManager = context.getSupportFragmentManager();
    }

    public MyFragmentManager(Fragment fragment) {
        this.mFragmentManager = fragment.getChildFragmentManager();
    }

    public void switchFragment(Fragment fragment) {
        if (currentFragment != fragment) {
            // 判断传入的fragment是不是当前的currentFragment
            FragmentTransaction transaction = mFragmentManager.beginTransaction();
            if (currentFragment != null) {
                // 不是则隐藏
                transaction.hide(currentFragment);
            }
            // 然后将传入的fragment赋值给currentFragment
            currentFragment = fragment;

            // 判断传入的fragment是否已经被add()过
            if (!fragment.isAdded()) {
                transaction.add(R.id.ll_main, fragment).show(fragment).commit();
            } else {
                transaction.show(fragment).commit();
            }
        }
    }

    public void switchFragment(String key, Bundle bundle) {
        Fragment fragment = mFragmentManager.findFragmentByTag(key);
        if (fragment == null) {
            fragment = Fragment.instantiate(MainApplication.application, key, bundle);
        }
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        ft.replace(R.id.ll_main, fragment, key);
        ft.commitAllowingStateLoss();
        mFragmentManager.executePendingTransactions();
    }

    public void switchFragmentWithoutCache(boolean addBackStack, String key, Bundle bundle) {
        Fragment fragment = Fragment.instantiate(MainApplication.application, key, bundle);
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        ft.replace(R.id.ll_main, fragment, key);
        if (addBackStack) {
            ft.addToBackStack(null);
        }
        ft.commitAllowingStateLoss();
        mFragmentManager.executePendingTransactions();
    }

    public void switchFragmentWithoutCache(boolean addBackStack, String key, Bundle bundle, int enterAnimation, int exitAnimation, int popEnterAnimation, int popExitAnimation) {
        Fragment fragment = Fragment.instantiate(MainApplication.application, key, bundle);
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        ft.setCustomAnimations(enterAnimation, exitAnimation, popEnterAnimation, popExitAnimation);
        ft.replace(R.id.ll_main, fragment, key);
        if (addBackStack) {
            ft.addToBackStack(null);
        }
        ft.commitAllowingStateLoss();
        mFragmentManager.executePendingTransactions();
    }


    public void switchFragment(String key, Bundle bundle, int enterAnimation, int exitAnimation, int popEnterAnimation, int popExitAnimation) {
        switchFragment(true, key, bundle, enterAnimation, exitAnimation, popEnterAnimation, popExitAnimation);
    }

    public void switchFragment(boolean addBackStack, String key, Bundle bundle, int enterAnimation, int exitAnimation, int popEnterAnimation, int popExitAnimation) {
        Fragment fragment = mFragmentManager.findFragmentByTag(key);
        if (fragment == null) {
            fragment = Fragment.instantiate(MainApplication.application, key, bundle);
        }
        FragmentTransaction ft = mFragmentManager.beginTransaction();
        ft.setCustomAnimations(enterAnimation, exitAnimation, popEnterAnimation, popExitAnimation);
        ft.replace(R.id.ll_main, fragment, key);
        if (addBackStack) {
            ft.addToBackStack(key);
        }
        ft.commitAllowingStateLoss();
        mFragmentManager.executePendingTransactions();
    }

    public void switchFragmentWithCache(String key, Bundle bundle) {
        switchFragmentWithCache(key, bundle, true);
    }

    public void switchFragmentWithCache(String key, Bundle bundle, boolean isAnalysePageStart) {
        if (lastFragmentTag == null || !TextUtils.equals(lastFragmentTag, key)) {

            FragmentTransaction ft = mFragmentManager.beginTransaction();
            if (lastFragmentTag != null) {
                ft.hide(mFragmentManager.findFragmentByTag(lastFragmentTag));
            }

            Fragment fragment = mFragmentManager.findFragmentByTag(key);
            if (fragment == null) {
                fragment = Fragment.instantiate(MainApplication.application, key, bundle);
                ft.add(R.id.ll_main, fragment, key);
            } else {
                ft.show(fragment);
            }

            lastFragmentTag = key;

            ft.commitAllowingStateLoss();
            mFragmentManager.executePendingTransactions();
        }
    }

    //用于切换相同Fragment
    public void switchSameFragmentWithCache(String key, String fragmentName, Bundle bundle) {
        if (lastFragmentTag == null || !TextUtils.equals(lastFragmentTag, key)) {

            FragmentTransaction ft = mFragmentManager.beginTransaction();
            if (lastFragmentTag != null) {
                ft.hide(mFragmentManager.findFragmentByTag(lastFragmentTag));
            }

            Fragment fragment = mFragmentManager.findFragmentByTag(key);
            if (fragment == null) {
                fragment = Fragment.instantiate(MainApplication.application, fragmentName, bundle);
                ft.add(R.id.ll_main, fragment, key);
            } else {
                ft.show(fragment);
            }
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("page", fragmentName.substring(fragmentName.lastIndexOf(".") + 1));
            map.put("tab", key);

            lastFragmentTag = key;
            ft.commitAllowingStateLoss();
            mFragmentManager.executePendingTransactions();
        }
    }

    public void removeFragment(String tag) {
        Fragment fragment = mFragmentManager.findFragmentByTag(tag);
        if (fragment != null) {
            FragmentTransaction ft = mFragmentManager.beginTransaction();
            ft.remove(fragment);
            ft.commitAllowingStateLoss();
            mFragmentManager.executePendingTransactions();
        }
    }

    public void detachLastFragment() {
        if (lastFragmentTag == null || mFragmentManager.findFragmentByTag(lastFragmentTag) == null) {
            return;
        }

        FragmentTransaction ft = mFragmentManager.beginTransaction();
        Fragment fragment = mFragmentManager.findFragmentByTag(lastFragmentTag);
        ft.detach(fragment);
        lastFragmentTag = null;
        ft.commitAllowingStateLoss();
        mFragmentManager.executePendingTransactions();
    }

    public Fragment getFragment(String key) {
        return mFragmentManager.findFragmentByTag(key);
    }

    public String getLastFragmentTag() {
        return lastFragmentTag;
    }

    public int getBackStackEntryCount() {
        return mFragmentManager.getBackStackEntryCount();
    }

    public String getBackStackEntryName(int Index) {
        return mFragmentManager.getBackStackEntryAt(Index).getName();
    }
}
