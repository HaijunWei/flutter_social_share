package com.haijunwei.flutter_social_share.model

import java.util.HashMap

/**
 *
 * @CreateDate:     2021/6/10 11:26
 * @Description:
 * @Author:         LOPER7
 * @Email:          loper7@163.com
 */
data class SocialShareInitOption(
        var appKey: String?="",
        var sinaWeiboAppKey: String?="",
        var sinaWeiboAppSecret: String?="",
        var sinaRedirectUri: String?="",
        var qqAppId: String?="",
        var qqAppKey: String?="",
        var weChatAppId: String?="",
        var weChatAppSecret: String?="",
        var universalLink: String?=""
){
    fun toMap(): Map<String, Any?> {
        val toMapResult: MutableMap<String, Any?> = HashMap()
        toMapResult["appKey"] = appKey
        toMapResult["sinaWeiboAppKey"] = sinaWeiboAppKey
        toMapResult["sinaWeiboAppSecret"] = sinaWeiboAppSecret
        toMapResult["sinaRedirectUri"] = sinaRedirectUri
        toMapResult["qqAppId"] = qqAppId
        toMapResult["qqAppKey"] = qqAppKey
        toMapResult["weChatAppId"] = weChatAppId
        toMapResult["weChatAppSecret"] = weChatAppSecret
        toMapResult["universalLink"] = universalLink
        return toMapResult
    }

    companion object {
        fun fromMap(map: Map<String?, Any?>?): SocialShareInitOption {
            val fromMapResult = SocialShareInitOption()
            if (map.isNullOrEmpty()) return fromMapResult
            fromMapResult.appKey = map["appKey"] as? String
            fromMapResult.sinaWeiboAppKey = map["sinaWeiboAppKey"] as? String
            fromMapResult.sinaWeiboAppSecret = map["sinaWeiboAppSecret"] as?  String
            fromMapResult.sinaRedirectUri = map["sinaRedirectUri"] as? String
            fromMapResult.qqAppId = map["qqAppId"] as? String
            fromMapResult.qqAppKey = map["qqAppKey"] as? String
            fromMapResult.weChatAppId = map["weChatAppId"] as?  String
            fromMapResult.weChatAppSecret = map["weChatAppSecret"] as? String
            fromMapResult.universalLink = map["universalLink"] as? String

            return fromMapResult
        }
    }
}