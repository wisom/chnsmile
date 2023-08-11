/*
 * Copyright (C) 2011-2016 Husor Inc.
 * All Rights Reserved.
 */
package com.icefire.chnsmile.fragment;

import android.view.View;
import android.widget.AdapterView;
import android.widget.Toast;

import com.icefire.chnsmile.views.AbstractAdapter;
import com.icefire.chnsmile.views.PullToRefreshListView;

public abstract class BaseListViewFragment<T> extends BaseFragment {

    public static int PAGE_SIZE = 20;
    public View mRootView;
    public PullToRefreshListView listView;

    public int listTotalSize;

    public boolean isRefresh = false;
    public boolean isLoadMore;
    public int page = 1;
    public AbstractAdapter<T> adapter;

    public BaseListViewFragment(int layoutResId) {
        super(layoutResId);
    }

    public void setListViewListener() {
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                onBaseItemClick(parent, view, position, id);
            }
        });

        listView.setOnRefreshListener(new PullToRefreshListView.OnRefreshListener() {
            @Override
            public void onRefresh() {
                onBaseRefresh();
            }
        });

        listView.setOnLoadListener(new PullToRefreshListView.OnLoadMoreListener() {
            @Override
            public void onLoadMore() {
                onBaseLoadMore();
            }
        });

    }

    public void setOnItemClickListener() {
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                onBaseItemClick(parent, view, position, id);
            }
        });
    }

    public void onBaseItemClick(AdapterView<?> parent, View view, int position, long id) {
    }

    public void loadDataComplete() {
        if (listView == null) {
            return;
        }
        if (isLoadMore) {
            listView.onLoadMoreComplete();
        } else {
            listView.onRefreshComplete();
        }
    }

    public void onBaseRefresh() {
        if (null != adapter) {
            adapter.clear();
        }
        isRefresh = true;
        isLoadMore = false;
        pageReset();
    }

    public void onBaseLoadMore() {
        isRefresh = false;
        isLoadMore = true;
        pagePlusOne();
    }

    public void resetRefreshState() {
        isRefresh = !isRefresh;
    }

    public void pagePlusOne() {
        page++;
    }

    public void pageReset() {
        page = 1;
    }

    public int getPagePlusNum() {
        return page == 0 ? 0 : 1;
    }

    public int getListViewHeaderCount() {
        return listView.getHeaderViewsCount();
    }

    public void updateCanLoadMoreState() {
        if (listView != null)
            listView.setCanLoadMore(isHasNextPage());
    }

    public boolean isHasNextPage() {
        return listView.getCount() - (listView.getHeaderViewsCount() + listView.getFooterViewsCount()) < listTotalSize ? true : false;
    }

    public void setDoRefreshOnUIChanged(boolean isRefresh) {
        if (listView != null) {
            listView.setDoRefreshOnUIChanged(true);
        }
    }

    public void setCanRefresh(boolean pCanRefresh) {
        if (listView != null) {
            listView.setCanRefresh(pCanRefresh);
        }
    }

    public void setCanLoadMore(boolean pCanLoadMore) {
        if (listView != null) {
            listView.setCanLoadMore(pCanLoadMore);
        }
    }

    public int getActualClickPosition(int clickPosition) {
        return clickPosition - listView.getHeaderViewsCount();
    }

    public int getActualClickPosition1(int clickPosition) {
        return clickPosition + listView.getHeaderViewsCount();
    }

    protected void showShortToast(int pResId) {
        showShortToast(getString(pResId));
    }

    protected void showLongToast(String pMsg) {
        Toast.makeText(getActivity(), pMsg, Toast.LENGTH_LONG).show();
    }

    protected void showShortToast(String pMsg) {
        Toast.makeText(getActivity(), pMsg, Toast.LENGTH_SHORT).show();
    }
}
