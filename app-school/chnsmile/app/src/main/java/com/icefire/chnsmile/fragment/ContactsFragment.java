package com.icefire.chnsmile.fragment;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.widget.ListView;

import androidx.arch.core.executor.ArchTaskExecutor;

import com.baoyz.swipemenulistview.SwipeMenuListView;
import com.icefire.chnsmile.R;
import com.icefire.chnsmile.adapters.ContactsAdapter;
import com.icefire.chnsmile.core.Constants;
import com.icefire.chnsmile.core.Router;
import com.icefire.chnsmile.core.network.ApiResponse;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.core.network.JsonCallback;
import com.icefire.chnsmile.model.Contact;
import com.icefire.chnsmile.ui.TitleView;
import com.icefire.chnsmile.views.PullToRefreshListView;

import java.util.List;

public class ContactsFragment extends BaseListViewFragment<Contact> {

    public ContactsFragment() {
        super(R.layout.fragment_contacts);
    }

    @Override
    protected void initComponents(View v) {
        TitleView titleView = findView(v, R.id.title_view);
        titleView.setOnRightTextClick(new TitleView.RightTextClickCallBack() {
            @Override
            public void onRightClick() {
                Router.open("/sp/test");
            }
        });

        listView = (PullToRefreshListView) v.findViewById(R.id.pullLV_common_list_Container);
        listView.setAutoLoadMore(true);
        listView.setFooterDividersEnabled(false);
        listView.setDoRefreshOnUIChanged(true);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        setListViewListener();
        getContactList();
    }

    private void getContactList() {
        ApiService.get(Constants.SERVER_URL_TEACHER_CONTACT).execute(new JsonCallback<List<Contact>>() {
            @SuppressLint("RestrictedApi")
            @Override
            public void onSuccess(ApiResponse<List<Contact>> response) {
                ArchTaskExecutor.getMainThreadExecutor().execute(new Runnable() {
                    @Override
                    public void run() {
                        loadDataComplete();

                        // 显示数据
                        if (adapter == null) {
                            adapter = new ContactsAdapter(getActivity(), response.body, R.layout.item_contacts_list) {
                                @Override
                                protected void onItemClick(Contact course) {
                                    ContactsFragment.this.onItemClick(course);
                                }
                            };
                        } else {
                            if (isLoadMore) {
                                // 加载更多
                                adapter.addData(response.body);
                            } else {
                                // 下拉刷新
                                adapter.setData(response.body);
                            }
                        }
                        listView.setAdapter(adapter);
                        // 是否能加载更多
//                listTotalSize = result.datas.totalCount;
                        updateCanLoadMoreState();
                        listView.setDoRefreshOnUIChanged(false);
                    }
                });

            }

            @Override
            public void onError(ApiResponse<List<Contact>> response) {
                super.onError(response);
            }
        });
    }

    @Override
    public void onBaseRefresh() {
        super.onBaseRefresh();
        getContactList();
    }

    @Override
    public void onBaseLoadMore() {
        super.onBaseLoadMore();
        getContactList();
    }

    public void onItemClick(Contact contact) {

    }
}
