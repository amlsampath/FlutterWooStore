# Retrofit annotations and interfaces
-keepattributes Signature
-keepattributes *Annotation*

-keep interface retrofit2.** { *; }
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# PayHere Classes
-keep class lk.payhere.** { *; }
-keep interface lk.payhere.androidsdk.PayhereSDK { *; }
-keep interface u2.c { *; }
-keep class lk.payhere.androidsdk.models.PaymentMethodResponse { *; }
-keep class lk.payhere.androidsdk.models.** { *; }
-keep class lk.payhere.androidsdk.** { *; }

# Keep Conscrypt and SSL-related classes
-keep class org.conscrypt.** { *; }
-keep class org.conscrypt.Conscrypt { *; }
-keep class org.conscrypt.OpenSSLProvider { *; }
-keep class com.android.org.conscrypt.** { *; }
-keep class org.apache.harmony.xnet.provider.jsse.** { *; }
-dontwarn org.conscrypt.**
-dontwarn com.android.org.conscrypt.**
-dontwarn org.apache.harmony.xnet.provider.jsse.**

# Keep SSL-related attributes
-keepattributes Exceptions, InnerClasses, Signature, Deprecated, SourceFile, LineNumberTable, *Annotation*, EnclosingMethod 