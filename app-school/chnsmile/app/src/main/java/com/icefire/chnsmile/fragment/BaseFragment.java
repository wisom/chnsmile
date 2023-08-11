package com.icefire.chnsmile.fragment;

import android.os.Bundle;
import androidx.fragment.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public abstract class BaseFragment extends Fragment {

	private final int layoutResId;

	public BaseFragment(int layoutResId) {
		this.layoutResId = layoutResId;
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		View rootView = inflater.inflate(layoutResId, container, false);

		if (!rootView.isInEditMode()) {
			initComponents(rootView);
		}

		return rootView;
	}

	@SuppressWarnings("unchecked")
	protected final <T extends View> T findView(View v, int id) {
		T result = null;
		if (v != null) {
			result = (T) v.findViewById(id);
		}
		return result;
	}

	protected abstract void initComponents(View rootView);
}
