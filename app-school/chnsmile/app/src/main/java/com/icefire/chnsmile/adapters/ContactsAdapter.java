package com.icefire.chnsmile.adapters;

import android.app.Dialog;
import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.icefire.chnsmile.R;
import com.icefire.chnsmile.model.Contact;
import com.icefire.chnsmile.ui.HawImageView;
import com.icefire.chnsmile.views.AbstractAdapter;
import com.icefire.chnsmile.views.ViewHolder;

import java.util.List;

public class ContactsAdapter extends AbstractAdapter<Contact> {

    private Dialog dialog;
    private int type;

    public ContactsAdapter(Context context, List<Contact> datas, int itemLayoutId) {
        super(context, datas, itemLayoutId);
    }

    @Override
    public void convert(ViewHolder holder, final Contact item, int position) {
        View view = holder.getView(R.id.layout_view);
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onItemClick(item);
            }
        });

        holder.setText(R.id.text_name, item.classGradeName + item.courseName + "-" + item.teacherName);
        if (!TextUtils.isEmpty(item.avator)) {
            holder.setImageByUrl(R.id.avator, item.avator);
        }

    }

    protected void onItemClick(Contact course){
    }
}
