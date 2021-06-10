package com.haijunwei.flutter_social_share.model

import java.util.HashMap

/**
 *
 * @CreateDate:     2021/6/10 13:56
 * @Description:
 * @Author:         LOPER7
 * @Email:          loper7@163.com
 */
data class GetUserInfoOption(
        var platform:Int?=0
){
    fun toMap(): Map<String, Any?> {
        val toMapResult: MutableMap<String, Any?> = HashMap()
        toMapResult["platform"] = platform
        return toMapResult
    }

    companion object {
        fun fromMap(map: Map<String?, Any?>?): GetUserInfoOption {
            val fromMapResult = GetUserInfoOption()
            if (map.isNullOrEmpty()) return fromMapResult
            fromMapResult.platform = map["platform"] as? Int
            return fromMapResult
        }
    }
}