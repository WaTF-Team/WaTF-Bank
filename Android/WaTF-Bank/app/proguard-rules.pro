# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-dontwarn okio.**
-keep class net.sqlcipher.** { *; }
-dontwarn net.sqlcipher.**


# Parcel library
-keep interface org.parceler.Parcel
-keep @org.parceler.Parcel class * { *; }
-keep class **$$Parcelable { *; }

-keep class com.tisconet.softlaunch.mba.model.undercon.** { *; }
-keepclassmembers class com.tisconet.softlaunch.mba.model.undercon.** { *; }

-optimizationpasses 5
-dontpreverify
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-keepattributes *Annotation*

-verbose

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View
-keep public class * extends android.app.Fragment
-keep public class * extends android.support.v4.Fragment

-keepattributes InnerClasses,SourceFile,LineNumberTable,Signature,EnclosingMethod,*Annotation*

-dontwarn android.support.v4.app.**
-dontwarn android.support.v4.content.**
-dontwarn android.support.v4.net.**
-dontwarn android.support.v4.os.*
-dontwarn android.support.v4.view.**
-dontwarn android.support.v4.widget.**
-dontwarn org.bouncycastle.**


-dontwarn com.tisconet.softlaunch.mba.activity.SplashScreen
-dontwarn com.tisconet.softlaunch.mba.fragment.transfer.TransferBankAccountFragment
-dontwarn com.tisconet.softlaunch.mba.model.TransferBankPagerModel_2
-dontwarn com.tisconet.softlaunch.mba.model.TransferServiceModel
-dontwarn com.tisconet.softlaunch.mba.model.**
-dontwarn com.tisconet.softlaunch.mba.CommonResponseModel
-dontwarn com.fasterxml.jackson.databind.**

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclassmembers class * extends android.content.Context {
    public void *(android.view.View);
    public void *(android.view.MenuItem);
}


-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}



-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

-keep public class com.google.android.gms.* { public *; }
-dontwarn com.google.android.gms.**



# --------------------------------------------------------------------
# REMOVE all Log messages except warnings and errors
# --------------------------------------------------------------------

#-assumenosideeffects class android.util.Log {
#    public static boolean isLoggable(java.lang.String, int);
#    public static int v(...);
#    public static int i(...);
#    public static int w(...);
#    public static int d(...);
#    public static int e(...);
#}
#
#-assumenosideeffects class com.tisconet.scb.util.UtilLog {
#    public static *** d(...);
#    public static *** v(...);
#    public static *** w(...);
#    public static *** i(...);
#    public static *** e(...);
#    public static *** logModel(...);
#}
#
#-assumenosideeffects class com.tisconet.utility.UtilLog {
#    public static *** d(...);
#    public static *** v(...);
#    public static *** w(...);
#    public static *** i(...);
#    public static *** e(...);
#    public static *** logModel(...);
#}

-keep class io.realm.annotations.RealmModule
-keep @io.realm.annotations.RealmModule class *
-keep class io.realm.internal.Keep
-keep @io.realm.internal.Keep class *
-dontwarn javax.**
-dontwarn io.realm.**
-keep class io.realm.** { *; }
-keep class com.tisconet.softlaunch.mba.realm.model.** { *; }
-keepclassmembers public class * extends io.realm.RealmObject

-keep class org.bouncycastle.** { *; }
-keep class com.squareup.okhttp.** { *; }
-keep class retrofit.** { *; }
-keep interface com.squareup.okhttp.** { *; }

-dontwarn com.squareup.okhttp.**
-dontwarn okio.**
-dontwarn retrofit.**
-dontwarn rx.**

-keepclasseswithmembers class * {
    @retrofit.http.* <methods>;
}

# If in your rest service interface you use methods with Callback argument.
-keepattributes Exceptions

# If your rest service methods throw custom exceptions, because you've defined an ErrorHandler.
-keepattributes Signature

-dontwarn io.chirp.**
-dontwarn org.jdom2.**
-dontwarn org.apache.**
-dontwarn com.google.firebase.**

-keep class com.google.gson.** {
    *;
}



-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

-keep class org.apache.commons.lang3.StringUtils { *; }
-keep public class org.apache.commons.lang3.StringUtils { public protected static *; }
-keepclassmembers public class org.apache.commons.lang3.StringUtils { *; }
-keepnames public class org.apache.commons.lang3.StringUtils { *; }

-keep class me.dm7.barcodescanner.zbar.** {*;}
-keepclassmembers class me.dm7.barcodescanner.zbar.** {*;}

-keep class net.sourceforge.zbar.** {*;}
-keepclassmembers class net.sourceforge.zbar.** {*;}
