# V2Ray Dan Pro

کلاینت Flutter برای اتصال امن V2Ray/Xray با تمرکز ویژه روی دور زدن فیلترینگ شدید (ایران).

## ویژگی‌های ضد فیلترینگ پیاده‌سازی‌شده در این پروژه

- **VLESS + REALITY**: هندشیک TLS واقعی به یک دامنه‌ی معتبر (مثل microsoft.com) — `config_builder_service.dart`
- **Hysteria2 / TUIC**: تونل روی QUIC برای مقابله با Throttling — `config_builder_service.dart`
- **TLS Fragment**: شکستن ClientHello برای فریب DPI — `config_builder_service.dart`
- **Mux (Multiplexing)**: کاهش الگوی قابل‌تشخیص ترافیک
- **Auto Fallback Chain**: سوییچ خودکار بین نودها در صورت بلاک شدن — `v2ray_service.dart`
- **DNS over HTTPS**: مقابله با DNS Poisoning — `config_builder_service.dart`
- **Smart Ping/Sort**: تست واقعی TCP connect برای تشخیص نودهای فیلترشده — `ping_service.dart`
- **کپی لاگ (تکی/گروهی)**: `clipboard_service.dart`

## نکته‌ی مهم درباره‌ی هسته‌ی native

لایه‌ی native (Kotlin) برای اتصال به **sing-box** ساخته شده و در مسیر زیر قرار دارد:

```
android/app/src/main/kotlin/com/v2raydan/app/
├── MainActivity.kt        # MethodChannel handler (start/stop/queryStats)
└── SingBoxVpnService.kt   # android.net.VpnService + اجرای libbox
```

### مراحل تکمیل (چون libbox.aar را نمی‌توان از طرف من تولید/توزیع کرد):

1. ریپوی رسمی sing-box را کلون کن:
   ```bash
   git clone https://github.com/SagerNet/sing-box
   ```
2. طبق دستورالعمل خودشان (پوشه‌ی `mobile` یا با `gomobile bind`) فایل `libbox.aar` را برای Android بساز.
3. فایل ساخته‌شده را در `android/app/libs/libbox.aar` کپی کن (پوشه‌ی `libs` را خودت بساز).
4. در `SingBoxVpnService.kt` متدهای `PlatformInterface` را دقیقاً مطابق نسخه‌ی API که build کردی تطبیق بده — ممکن است بین نسخه‌های sing-box این اینترفیس کمی تغییر کند.
5. `flutter run` را اجرا کن؛ هنگام اولین اتصال، دیالوگ سیستمی اندروید برای اجازه‌ی VPN نمایش داده می‌شود.

### جریان کامل ارتباط

```
HomeScreen (Dart)
   → ConnectionProvider.connect()
   → V2RayService._startNativeTunnel(config)
   → MethodChannel('v2ray_dan/tunnel').invokeMethod('start', {config})
   → MainActivity.kt → VpnService.prepare() → SingBoxVpnService
   → Libbox.newService(configJson) → BoxService.start()
```

آمار آپلود/دانلود نیز با `queryStats` به همین شکل از `TrafficStatsService` (Dart) به `SingBoxVpnService.queryStats()` (Kotlin) می‌رسد.

## اجرا

```bash
flutter pub get
flutter run
```
