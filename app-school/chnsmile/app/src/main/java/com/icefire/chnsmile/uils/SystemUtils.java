package com.icefire.chnsmile.uils;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.StrictMode;
import android.text.TextUtils;

import com.blankj.utilcode.util.EncryptUtils;
import com.blankj.utilcode.util.FileUtils;
import com.blankj.utilcode.util.LogUtils;
import com.blankj.utilcode.util.UriUtils;
import com.icefire.chnsmile.MainApplication;
import com.icefire.chnsmile.core.Constants;
import com.tencent.smtt.export.external.TbsCoreSettings;
import com.tencent.smtt.sdk.QbSdk;
import com.tencent.smtt.sdk.TbsDownloader;
import com.tencent.smtt.sdk.TbsListener;

import java.io.File;
import java.util.HashMap;

public final class SystemUtils {

    private static final String PICTURES_FOLDER_NAME = "Pictures";
    private static final String VIDEOS_FOLDER_NAME = "Videos";
    private static final String DOCUMENTS_FOLDER_NAME = "Documents";
    private static final String AUDIO_FOLDER_NAME = "Music";
    private static final String APPLICATIONS_FOLDER_NAME = "Applications";
    private static final String RINGTONES_FOLDER_NAME = "Ringtones";
    private static int x5Count = 0;
    private static boolean isInitTbs;

    public static void initX5(Context context) {
        isInitTbs = QbSdk.canLoadX5(context);
        if (!isInitTbs || QbSdk.getTbsVersion(context) < 46007) {
            com.icefire.chnsmile.uils.FileUtils.copyAssets(context, "046007_x5.tbs.apk", com.icefire.chnsmile.uils.FileUtils.getTBSFileDir(context).getPath() + "/046007_x5.tbs.apk");
        }
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put(TbsCoreSettings.TBS_SETTINGS_USE_SPEEDY_CLASSLOADER, true);
        map.put(TbsCoreSettings.TBS_SETTINGS_USE_DEXLOADER_SERVICE, true);
        QbSdk.initTbsSettings(map);
//        QbSdk.setNeedInitX5FirstTime(true);
//        QbSdk.setDownloadWithoutWifi(true);
        LogUtils.e("qbversion: " + QbSdk.getTbsVersion(context));
        boolean canLoadX5 = QbSdk.canLoadX5(context);
        LogUtils.e("canLoadX5: " + canLoadX5+"|TbsVersion:"+QbSdk.getTbsVersion(context));
        if (canLoadX5) {
            return;
        }

        QbSdk.setTbsListener(new TbsListener() {
            @Override
            public void onDownloadFinish(int i) {

            }

            @Override
            public void onInstallFinish(int i) {
                LogUtils.e("onInstallFinish: " + i);
                int tbsVersion = QbSdk.getTbsVersion(context);
                LogUtils.e("tbsVersion: " + tbsVersion);
            }

            @Override
            public void onDownloadProgress(int i) {

            }
        });
        QbSdk.reset(context);
        QbSdk.installLocalTbsCore(context, 46007, com.icefire.chnsmile.uils.FileUtils.getTBSFileDir(context).getPath() + "/046007_x5.tbs.apk");




//        //搜集本地tbs内核信息并上报服务器，服务器返回结果决定使用哪个内核。
//        QbSdk.PreInitCallback cb = new QbSdk.PreInitCallback() {
//            @Override
//            public void onViewInitFinished(boolean b) {
//                //x5內核初始化完成的回调，为true表示x5内核加载成功，否则表示x5内核加载失败，会自动切换到系统内核。
//                LogUtils.d(" onViewInitFinished is " + b);
//                if (!b && !QbSdk.getIsSysWebViewForcedByOuter()) { //使用系统内核可能是x5内核在之前未安装成功，重新安装
//                    //判断是否是x5内核未下载成功，存在缓存 重置化sdk，这样就清除缓存继续下载了
//                    LogUtils.d(" onViewInitFinished2 is " + b);
//                    QbSdk.reset(context);
//                    //开始下载x5内核
//                    TbsDownloader.startDownload(context);
//                }
//            }
//
//            @Override
//            public void onCoreInitFinished() {
//                LogUtils.d(" onCoreInitFinished");
//            }
//        };
//        //x5内核初始化接口
//        QbSdk.initX5Environment(context, cb);
//        QbSdk.setTbsListener(new TbsListener() {
//            @Override
//            public void onDownloadFinish(int i) {
//                LogUtils.d(" onDownloadFinish is " + i);
//                if ((i >= 127 || i == -134) && x5Count <= 3) {
//                    x5Count++;
//                    QbSdk.reset(context);
//                    //开始下载x5内核
//                    TbsDownloader.startDownload(context);
//                }
//            }
//
//            @Override
//            public void onInstallFinish(int i) {
//                LogUtils.d(" onInstallFinish is " + i);
//            }
//
//            @Override
//            public void onDownloadProgress(int i) {
//                LogUtils.d(" onDownloadProgress is " + i);
//            }
//        });
    }

    public static File getApplicationStorageDirectory() {
        File externalStorageDirectory = getSDDataStorageDirectory();
        File result = null;
        if (externalStorageDirectory != null) {
            result = externalStorageDirectory;
        } else {
            result = MainApplication.context.getFilesDir();
        }
        return result;
    }

    public static File getSDDataStorageDirectory() {
        return MainApplication.context.getExternalCacheDir();
    }

    public static File getSaveDirectory(byte fileType) {
        File parentFolder = getApplicationStorageDirectory();

        String folderName = null;

        switch (fileType) {
            case Constants.FILE_TYPE_AUDIO:
                folderName = AUDIO_FOLDER_NAME;
                break;
            case Constants.FILE_TYPE_PICTURES:
                folderName = PICTURES_FOLDER_NAME;
                break;
            case Constants.FILE_TYPE_VIDEOS:
                folderName = VIDEOS_FOLDER_NAME;
                break;
            case Constants.FILE_TYPE_DOCUMENTS:
                folderName = DOCUMENTS_FOLDER_NAME;
                break;
            case Constants.FILE_TYPE_APPLICATIONS:
                folderName = APPLICATIONS_FOLDER_NAME;
                break;
            case Constants.FILE_TYPE_RINGTONES:
                folderName = RINGTONES_FOLDER_NAME;
                break;
            default: // We will treat anything else like documents (unknown types)
                folderName = DOCUMENTS_FOLDER_NAME;
        }

        return createFolder(parentFolder, folderName);
    }

    public static boolean isDocumentFileExist(String filePath) {
        return FileUtils.isFileExists(getDocumentPath(filePath));
    }

    public static String getDocumentDir() {
        return SystemUtils.getSaveDirectory(Constants.FILE_TYPE_DOCUMENTS).getAbsolutePath();
    }

    public static File getDocumentPath(String filePath) {
        return new File(SystemUtils.getSaveDirectory(Constants.FILE_TYPE_DOCUMENTS), getDocumentName(filePath));
    }

    public static File getTempDir(String dir) {
        return new File(SystemUtils.getSaveDirectory(Constants.FILE_TYPE_DOCUMENTS), dir);
    }

    public static String getDocumentName(String filePath) {
        String extension = FileUtils.getFileExtension(filePath);
        return EncryptUtils.encryptMD5ToString(filePath) + "." + extension;
    }

    public static File getImagePath(String name) {
        return new File(SystemUtils.getSaveDirectory(Constants.FILE_TYPE_PICTURES), name);
    }

    public static File getImageRandomFile() {
        return getImagePath(System.currentTimeMillis() + ".jpg");
    }

    private static File createFolder(File parentDir, String folderName) {
        try {
            File f = new File(parentDir, folderName);
            FileUtils.createOrExistsDir(f);
            return f;
        } catch (Throwable e) {
            throw new RuntimeException("Unable to setup system folder", e);
        }
    }

    public static void shareFile(Context context, String path) {
        if (TextUtils.isEmpty(path)) {
            return;
        }

        checkFileUriExposure();

        Uri uri = UriUtils.file2Uri(new File(path));
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.putExtra(Intent.EXTRA_STREAM, uri);  //传输图片或者文件 采用流的方式
        intent.setType("*/*");   //分享文件
        context.startActivity(Intent.createChooser(intent, "分享"));
    }

    public static Intent getShareTextImageIntent(final String content, final File imageFile) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.putExtra(Intent.EXTRA_TEXT, "content");
        intent.putExtra(Intent.EXTRA_STREAM, UriUtils.file2Uri(imageFile));
        intent.setType("image/*");
        intent = Intent.createChooser(intent, "content");
        return getIntent(intent, true);
    }

    public static Intent getShareTextIntent(final String content) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_TEXT, content);
        intent = Intent.createChooser(intent, "分享");
        return getIntent(intent, true);
    }

    private static Intent getIntent(final Intent intent, final boolean isNewTask) {
        return isNewTask ? intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) : intent;
    }

    private static void checkFileUriExposure() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(builder.build());
            builder.detectFileUriExposure();
        }
    }
}
