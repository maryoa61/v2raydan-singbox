// packages/v2ray_dan/android/src/main/kotlin/com/v2ray/dan/V2RayCoreManager.kt
package com.v2ray.dan

import com.github.nekolr.singbox.Singbox

class V2RayCoreManager {
    // اجرای هسته با کانفیگ JSON تولید شده در دارت
    fun startCore(configJson: String): Boolean {
        return try {
            Singbox.start(configJson)
            true
        } catch (e: Exception) {
            // در صورت بروز خطا در اجرا، لاگ یا هندلینگ خطا اینجا قرار می‌گیرد
            false
        }
    }

    // متوقف کردن ایمن هسته
    fun stopCore() {
        Singbox.stop()
    }
}
