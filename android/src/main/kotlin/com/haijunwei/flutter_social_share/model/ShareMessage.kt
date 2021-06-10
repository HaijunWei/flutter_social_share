package com.haijunwei.flutter_social_share.model

import java.util.HashMap

/**
 *
 * @CreateDate:     2021/6/10 13:56
 * @Description:
 * @Author:         LOPER7
 * @Email:          loper7@163.com
 */
data class ShareMessage(
        var platform:Int?=0,
        var mediaType:Int?=0,
        var url:String?="",
        var text:String?="",
        var title:String?="",
        var thumb:String?="",
        var image:String?=""
){
    fun toMap(): Map<String, Any?> {
        val toMapResult: MutableMap<String, Any?> = HashMap()
        toMapResult["platform"] = platform
        toMapResult["mediaType"] = mediaType
        toMapResult["url"] = url
        toMapResult["text"] = text
        toMapResult["title"] = title
        toMapResult["thumb"] = thumb
        toMapResult["image"] = image
        return toMapResult
    }

    companion object {
        fun fromMap(map: Map<String?, Any?>?): ShareMessage {
            val fromMapResult = ShareMessage()
            if (map.isNullOrEmpty()) return fromMapResult
            fromMapResult.platform = map["platform"] as? Int
            fromMapResult.mediaType = map["mediaType"] as? Int
            fromMapResult.url = map["url"] as?  String
            fromMapResult.text = map["text"] as? String
            fromMapResult.title = map["title"] as? String
            fromMapResult.thumb = map["thumb"] as? String
            fromMapResult.image = map["image"] as?  String
            return fromMapResult
        }
    }
}