package com.haijunwei.flutter_social_share

import android.content.Context
import android.graphics.BitmapFactory
import androidx.annotation.NonNull
import cn.jiguang.share.android.api.*
import cn.jiguang.share.android.model.BaseResponseInfo
import cn.jiguang.share.android.model.UserInfo
import cn.jiguang.share.android.utils.JsonUtil
import cn.jiguang.share.qqmodel.QQ
import cn.jiguang.share.qqmodel.QZone
import cn.jiguang.share.wechat.Wechat
import cn.jiguang.share.wechat.WechatFavorite
import cn.jiguang.share.wechat.WechatMoments
import cn.jiguang.share.weibo.SinaWeibo
import cn.jiguang.share.weibo.SinaWeiboMessage
import com.haijunwei.flutter_social_share.model.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.ByteArrayOutputStream
import java.io.FileInputStream
import java.util.*


class FlutterSocialSharePlugin : FlutterPlugin, MethodCallHandler, ActivityAware, JShare {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activityBinding: ActivityPluginBinding? = null
    private var context: Context? = null

    companion object {
        fun registerWith(registrar: Registrar) {
            if (registrar.activity() == null) {
                // If a background flutter view tries to register the plugin, there will be no activity from the registrar,
                // we stop the registering process immediately because the ImagePicker requires an activity.
                return
            }
            val plugin = FlutterSocialSharePlugin()
            Messages.setup(registrar.messenger(), plugin)
        }
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_social_share")
        channel.setMethodCallHandler(this)
        Messages.setup(flutterPluginBinding.binaryMessenger, this)
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun initialize(options: SocialShareInitOption?, result: com.haijunwei.flutter_social_share.Result<Any?>?) {

        var config = PlatformConfig()
        options?.apply {
            config.setWechat(weChatAppId, weChatAppSecret)
            config.setQQ(qqAppId, qqAppKey)
            config.setSinaWeibo(sinaWeiboAppKey, sinaWeiboAppSecret, sinaRedirectUri)
        }
        JShareInterface.init(context, config)
        result?.success(null)
    }

    override fun share(options: ShareMessage?, result: com.haijunwei.flutter_social_share.Result<Any?>?) {

        val platform = options?.platform?.let {
            when (it) {
                SocialShare.SharePlatform.WECHAT -> Wechat.Name
                SocialShare.SharePlatform.WECHAT_CIRCLE -> WechatMoments.Name
                SocialShare.SharePlatform.WECHAT_FAVORITES -> WechatFavorite.Name
                SocialShare.SharePlatform.QQ -> QQ.Name
                SocialShare.SharePlatform.QQ_ZONE -> QZone.Name
                SocialShare.SharePlatform.SINA_WEIBO -> SinaWeibo.Name
                SocialShare.SharePlatform.SINA_WEIBO_CONTACT -> SinaWeiboMessage.Name
                else -> ""
            }
        }

        val shareType = options?.mediaType?.let {
            when (it) {
                SocialShare.Media.TEXT -> Platform.SHARE_TEXT
                SocialShare.Media.IMAGE -> Platform.SHARE_IMAGE
                SocialShare.Media.URL -> Platform.SHARE_WEBPAGE
                else -> Platform.SHARE_TEXT
            }
        }

        val shareParams = ShareParams()
        shareParams.shareType = shareType ?: 1
        when (shareType) {
            Platform.SHARE_TEXT -> {
                shareParams.text = options.text
            }
            Platform.SHARE_IMAGE -> {
                shareParams.imageData =  BitmapFactory.decodeFile(options.image)
            }
            Platform.SHARE_WEBPAGE -> {
                shareParams.title = options.title
                shareParams.text = options.text
                shareParams.url = options.url
                shareParams.imageData =  BitmapFactory.decodeFile(options.thumb)
            }
        }

        JShareInterface.share(platform, shareParams, object : PlatActionListener {
            override fun onComplete(p0: Platform?, p1: Int, p2: HashMap<String, Any>?) {

                activityBinding?.activity?.runOnUiThread { result?.success(null)}
            }

            override fun onCancel(p0: Platform?, p1: Int) {
                activityBinding?.activity?.runOnUiThread {result?.error(Throwable("share canceled"))}
            }

            override fun onError(p0: Platform?, p1: Int, p2: Int, p3: Throwable?) {
                activityBinding?.activity?.runOnUiThread { result?.error(p3 ?: Throwable("${p0?.name} share error"))}
            }
        })
    }

    override fun authorization(options: GetUserInfoOption?, result: com.haijunwei.flutter_social_share.Result<GetUserInfoResult?>?) {

        val platform = options?.platform?.let {
            when (it) {
                SocialShare.AuthPlatform.WECHAT -> Wechat.Name
                SocialShare.AuthPlatform.QQ -> QQ.Name
                SocialShare.AuthPlatform.SINA -> SinaWeibo.Name
                else -> ""
            }
        }


        if (!JShareInterface.isSupportAuthorize(platform)) {
            activityBinding?.activity?.runOnUiThread { result?.error(Throwable("该平台暂不支持授权"))}
            return
        }

        val authListener = object : AuthListener {
            override fun onComplete(platform: Platform?, action: Int, data: BaseResponseInfo?) {
                when (action) {
                    Platform.ACTION_USER_INFO -> {
                        val auth = data as UserInfo
                        val info = GetUserInfoResult()
                        info.name = auth.name
                        info.iconUrl = auth.imageUrl
                        info.openId = auth.openid
                        info.gender = auth.gender
                        info.userOriginalResponse = JsonUtil().fromJson(auth.originData)


                        activityBinding?.activity?.runOnUiThread {result?.success(info)}
                    }
                    else -> {
                        activityBinding?.activity?.runOnUiThread { result?.error(Throwable("${platform?.name} authorization error"))}
                    }
                }
            }

            override fun onCancel(p0: Platform?, p1: Int) {
                activityBinding?.activity?.runOnUiThread { result?.error(Throwable("authorization canceled"))}
            }

            override fun onError(p0: Platform?, p1: Int, p2: Int, p3: Throwable?) {
                activityBinding?.activity?.runOnUiThread {result?.error(p3 ?: Throwable("${p0?.name} authorization error"))}
            }
        }

            if (JShareInterface.isAuthorize(platform)) {
                JShareInterface.getUserInfo(platform, authListener)
            } else {
                JShareInterface.authorize(platform, object : AuthListener {
                    override fun onComplete(p0: Platform, p1: Int, p2: BaseResponseInfo?) {
                        if (p1 == Platform.ACTION_AUTHORIZING) {
                            JShareInterface.getUserInfo(p0.name, authListener)
                        }
                    }

                    override fun onCancel(p0: Platform?, p1: Int) {
                        authListener.onCancel(p0, p1)
                    }

                    override fun onError(p0: Platform?, p1: Int, p2: Int, p3: Throwable?) {
                        authListener.onError(p0, p1, p2, p3)
                    }

                })
        }
    }

}
