package com.icefire.chnsmile.core;

import android.content.Context;

import com.blankj.utilcode.util.DeviceUtils;
import com.blankj.utilcode.util.LogUtils;
import com.icefire.chnsmile.core.network.ApiResponse;
import com.icefire.chnsmile.core.network.ApiService;
import com.icefire.chnsmile.core.network.JsonCallback;
import com.icefire.chnsmile.manager.AccountManager;
import com.icefire.chnsmile.model.UnReadNotice;
import com.igexin.sdk.GTIntentService;
import com.igexin.sdk.PushManager;
import com.igexin.sdk.message.GTCmdMessage;
import com.igexin.sdk.message.GTNotificationMessage;
import com.igexin.sdk.message.GTTransmitMessage;

import org.greenrobot.eventbus.EventBus;

import java.util.HashMap;

public class GTService extends GTIntentService {

    static final String TAG = "GTService";

    @Override
    public void onReceiveServicePid(Context context, int pid) {
        LogUtils.d(TAG, "onReceiveServicePid -> " + pid);
    }

    // 处理透传消息
    @Override
    public void onReceiveMessageData(Context context, GTTransmitMessage msg) {
        String appid = msg.getAppid();
        String taskid = msg.getTaskId();
        String messageid = msg.getMessageId();
        byte[] payload = msg.getPayload();
        String pkg = msg.getPkgName();
        String cid = msg.getClientId();

        // 第三方回执调用接口，actionid范围为90000-90999，可根据业务场景执行
        boolean result = PushManager.getInstance().sendFeedbackMessage(context, taskid, messageid, 90001);
        LogUtils.d(TAG, "call sendFeedbackMessage = " + (result ? "success" : "failed"));

        LogUtils.d(TAG, "onReceiveMessageData -> " + "appid = " + appid + "\ntaskid = " + taskid + "\nmessageid = " + messageid + "\npkg = " + pkg
                + "\ncid = " + cid);

        if (payload == null) {
            LogUtils.e(TAG, "receiver payload = null");
        } else {
            String data = new String(payload);
            LogUtils.d(TAG, "receiver payload = " + data);


        }

        LogUtils.d(TAG, "----------------------------------------------------------------------------------------------");
    }

    // 接收 cid
    @Override
    public void onReceiveClientId(Context context, String clientid) {
        LogUtils.e(TAG, "onReceiveClientId -> " + "clientid = " + clientid);
        ConfigurationManager.instance().setString(Constants.PREF_KEY_GETUI_CID, clientid);
        if (AccountManager.isLogined()) {
            ApiService.post(Constants.SERVER_URL_BINDCID)
                    .addParam("cid", clientid)
                    .addParam("brand", DeviceUtils.getManufacturer())
                    .execute(new JsonCallback<String>() {
                        @Override
                        public void onSuccess(ApiResponse<String> response) {
                            LogUtils.i("绑定成功:" + response.message);
                            if (response.code != 200) {
//                            ConfigurationManager.instance().remove(Constants.PREF_KEY_GETUI_CID);
                            }
                        }

                        @Override
                        public void onError(ApiResponse<String> response) {
                            LogUtils.e("绑定失败:" + response.message);
                        }
                    });
//        EventBus.getDefault().postSticky(new Client(clientid));
        }
    }

    // cid 离线上线通知
    @Override
    public void onReceiveOnlineState(Context context, boolean online) {
        LogUtils.d(TAG, "onReceiveOnlineState -> " + (online ? "online" : "offline"));
    }

    // 各种事件处理回执
    @Override
    public void onReceiveCommandResult(Context context, GTCmdMessage cmdMessage) {
        LogUtils.d(TAG, "onReceiveCommandResult -> " + cmdMessage);


    }

    // 通知到达，只有个推通道下发的通知会回调此方法
    @Override
    public void onNotificationMessageArrived(Context context, GTNotificationMessage message) {
        LogUtils.d(TAG, "onNotificationMessageArrived -> " + "appid = " + message.getAppid() + "\ntaskid = " + message.getTaskId() + "\nmessageid = "
                + message.getMessageId() + "\npkg = " + message.getPkgName() + "\ncid = " + message.getClientId() + "\ntitle = "
                + message.getTitle() + "\ncontent = " + message.getContent());
        FlutterPluginNative.getInstance().triggerUnRead(new HashMap());
        EventBus.getDefault().post(new UnReadNotice());
    }

    // 通知点击，只有个推通道下发的通知会回调此方法
    @Override
    public void onNotificationMessageClicked(Context context, GTNotificationMessage message) {
        LogUtils.d(TAG, "onNotificationMessageClicked -> " + "appid = " + message.getAppid() + "\ntaskid = " + message.getTaskId() + "\nmessageid = "
                + message.getMessageId() + "\npkg = " + message.getPkgName() + "\ncid = " + message.getClientId() + "\ntitle = "
                + message.getTitle() + "\ncontent = " + message.getContent());
    }
}
