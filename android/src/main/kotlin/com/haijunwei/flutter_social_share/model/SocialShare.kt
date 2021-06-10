package com.haijunwei.flutter_social_share.model

/**
 *
 * @CreateDate:     2021/6/10 14:02
 * @Description:
 * @Author:         LOPER7
 * @Email:          loper7@163.com
 */
object SocialShare {

    object Media {
        val TEXT = 0
        val IMAGE = 1
        val URL = 2
    }

    object SharePlatform {
        val WECHAT = 1
        val WECHAT_CIRCLE = 2
        val WECHAT_FAVORITES = 3
        val QQ = 4
        val QQ_ZONE = 5
        val SINA_WEIBO = 6
        val SINA_WEIBO_CONTACT = 7
    }

    object AuthPlatform {
        val WECHAT = 0
        val QQ = 1
        val SINA = 2
    }

}