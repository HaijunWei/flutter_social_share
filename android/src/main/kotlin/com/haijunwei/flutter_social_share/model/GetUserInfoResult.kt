package com.haijunwei.flutter_social_share.model

import java.util.HashMap

/**
 *
 * @CreateDate:     2021/6/10 14:27
 * @Description:
 * @Author:         LOPER7
 * @Email:          loper7@163.com
 */
data class GetUserInfoResult(
        var name: String? = "",
        var iconUrl: String? = "",
        var gender:Int?=0,
        var openId: String? = "",
        var userOriginalResponse:String?=""
) {
    fun toMap(): Map<String, Any?> {
        val toMapResult: MutableMap<String, Any?> = HashMap()
        toMapResult["name"] = name
        toMapResult["iconUrl"] = iconUrl
        toMapResult["openId"] = openId
        toMapResult["gender"] = gender
        toMapResult["userOriginalResponse"] = userOriginalResponse

        return toMapResult
    }

    companion object {
        fun fromMap(map: Map<String?, Any?>?): GetUserInfoResult {
            val fromMapResult = GetUserInfoResult()
            if (map.isNullOrEmpty()) return fromMapResult
            fromMapResult.name = map["name"] as? String
            fromMapResult.iconUrl = map["iconUrl"] as? String
            fromMapResult.openId = map["openId"] as? String
            fromMapResult.gender = map["gender"] as? Int
            fromMapResult.userOriginalResponse = map["userOriginalResponse"] as? String
            return fromMapResult
        }
    }
}