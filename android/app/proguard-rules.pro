# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your model classes
-keep class com.example.store_go.models.** { *; }

# Ignore warnings for missing Play Core classes
-dontwarn com.google.android.play.core.**

# Don't warn about Pusher client
-dontwarn org.slf4j.impl.StaticLoggerBinder

# GetX related
-keep class get.** { *; }

# Handle image picker and related packages
-keep class io.flutter.plugins.imagepicker.** { *; }

# For Dio HTTP client
-keep class io.flutter.plugins.urllauncher.** { *; }

# For serialization if you're using json_serializable or built_value
-keepattributes *Annotation*, InnerClasses
-keep class kotlin.Metadata { *; }

# For native libraries
-keepclasseswithmembernames class * {
    native <methods>;
}