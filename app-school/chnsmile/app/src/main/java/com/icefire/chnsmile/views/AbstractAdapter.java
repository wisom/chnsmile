package com.icefire.chnsmile.views;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

public abstract class AbstractAdapter<T> extends BaseAdapter {

	protected LayoutInflater inflater;
	protected Context context;
	protected List<T> datas;
	protected final int itemLayoutId;

	public AbstractAdapter(Context context, List<T> datas, int itemLayoutId) {
		this.context = context;
		this.inflater = LayoutInflater.from(context);
		this.datas = datas;
		this.itemLayoutId = itemLayoutId;
	}
	
	public void setData(List<T> datas) {
		this.datas = datas.equals(Collections.emptyList()) ? new ArrayList<T>() : datas;
		notifyDataSetInvalidated();
	}
	
	public void addData(List<T> datas) {
		this.datas.addAll(datas);
		notifyDataSetChanged();
	}
	
	public void clear() {
		datas.clear();
		notifyDataSetInvalidated();
	}
	
	@Override
	public int getCount() {
		return datas.size();
	}

	@Override
	public T getItem(int position) {
		return datas.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder = getViewHolder(position, convertView, parent);
		convert(viewHolder, getItem(position), position);
		return viewHolder.getConvertView();
	}

	private ViewHolder getViewHolder(int position, View convertView, ViewGroup parent) {
		return ViewHolder.get(context, convertView, parent, itemLayoutId, position);
	}

	public abstract void convert(ViewHolder holder, T item, int position);

}
