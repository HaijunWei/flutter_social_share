package com.haijunwei.flutter_social_share

import com.haijunwei.flutter_social_share.model.GetUserInfoOption
import com.haijunwei.flutter_social_share.model.GetUserInfoResult
import com.haijunwei.flutter_social_share.model.ShareMessage
import com.haijunwei.flutter_social_share.model.SocialShareInitOption
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import java.util.*

/** Generated class from Pigeon.  */
object Messages {
    /** Sets up an instance of `PhotoPicker` to handle messages through the `binaryMessenger`.  */
    fun setup(binaryMessenger: BinaryMessenger?, api: JShare?) {
        run {
            initialize(binaryMessenger,api)
            share(binaryMessenger,api)
            authorization(binaryMessenger,api)

        }
    }

    private fun initialize(binaryMessenger: BinaryMessenger?, api: JShare?){
        val channel = BasicMessageChannel(binaryMessenger!!, "com.haijunwei.SocialShare.initialize", StandardMessageCodec())
        if (api == null) {
            channel.setMessageHandler(null)
            return
        }
        channel.setMessageHandler { message: Any?, reply: BasicMessageChannel.Reply<Any> ->
            val wrapped: MutableMap<String, Any> = HashMap()
            try {
                val input = SocialShareInitOption.fromMap(message as Map<String?, Any?>?)
                api.initialize(input, object : Result<Any?> {
                    override fun success(result: Any?) {
                        val map:MutableMap<String, Any?> = HashMap()
                        map["message"] = "success"
                        wrapped["result"] = map
                        reply.reply(wrapped)
                    }

                    override fun error(throwable: Throwable) {
                        wrapped["error"] = wrapError(throwable)
                        reply.reply(wrapped)
                    }
                })
            } catch (exception: Error) {
                wrapped["error"] = wrapError(exception)
                reply.reply(wrapped)
            } catch (exception: RuntimeException) {
                wrapped["error"] = wrapError(exception)
                reply.reply(wrapped)
            }
        }
    }

    private fun share(binaryMessenger: BinaryMessenger?, api: JShare?){
        val channel = BasicMessageChannel(binaryMessenger!!, "com.haijunwei.SocialShare.share", StandardMessageCodec())
        if (api == null) {
            channel.setMessageHandler(null)
            return
        }

        channel.setMessageHandler { message: Any?, reply: BasicMessageChannel.Reply<Any> ->
            val wrapped: MutableMap<String, Any> = HashMap()
            try {
                val input = ShareMessage.fromMap(message as Map<String?, Any?>?)
                api.share(input, object : Result<Any?> {
                    override fun success(result: Any?) {
                        val map:MutableMap<String, Any?> = HashMap()
                        map["message"] = "success"
                        wrapped["result"] = map
                        reply.reply(wrapped)
                    }

                    override fun error(throwable: Throwable) {
                        wrapped["error"] = wrapError(throwable)
                        reply.reply(wrapped)
                    }
                })
            } catch (exception: Error) {
                wrapped["error"] = wrapError(exception)
                reply.reply(wrapped)
            } catch (exception: RuntimeException) {
                wrapped["error"] = wrapError(exception)
                reply.reply(wrapped)
            }
        }
    }

    private fun authorization(binaryMessenger: BinaryMessenger?, api: JShare?){
        val channel = BasicMessageChannel(binaryMessenger!!, "com.haijunwei.SocialShare.getSocialUserInfo", StandardMessageCodec())
        if (api == null) {
            channel.setMessageHandler(null)
            return
        }

        channel.setMessageHandler { message: Any?, reply: BasicMessageChannel.Reply<Any> ->
            val wrapped: MutableMap<String, Any> = HashMap()
            try {
                val input = GetUserInfoOption.fromMap(message as Map<String?, Any?>?)
                api.authorization(input, object : Result<GetUserInfoResult?> {
                    override fun success(result: GetUserInfoResult?) {
                        wrapped["result"] = result?.toMap()!!
                        reply.reply(wrapped)
                    }

                    override fun error(throwable: Throwable) {
                        wrapped["error"] = wrapError(throwable)
                        reply.reply(wrapped)
                    }
                })
            } catch (exception: Error) {
                wrapped["error"] = wrapError(exception)
                reply.reply(wrapped)
            } catch (exception: RuntimeException) {
                wrapped["error"] = wrapError(exception)
                reply.reply(wrapped)
            }
        }
    }
}

private fun wrapError(exception: Throwable): Map<String, Any?> {
    val errorMap: MutableMap<String, Any?> = HashMap()
    errorMap["message"] = exception.toString()
    errorMap["code"] = exception.javaClass.simpleName
    errorMap["details"] = null
    return errorMap
}


interface Result<T> {
    fun success(result: T)

    fun error(throwable:Throwable)
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface JShare {
    fun initialize(options: SocialShareInitOption?, result: Result<Any?>?)
    fun share(options: ShareMessage?, result: Result<Any?>?)
    fun authorization(options: GetUserInfoOption?, result: Result<GetUserInfoResult?>?)
}