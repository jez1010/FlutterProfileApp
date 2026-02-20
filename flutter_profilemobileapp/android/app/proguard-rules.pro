# 1. Keep your specific data models from being renamed
# This ensures Supabase can map JSON keys to your class fields
-keep class com.example.flutter_profilemobileapp.** { *; }

# 2. Prevent R8 from breaking the handshake with Supabase/JSON
-keep class * implements java.io.Serializable { *; }
-keepclassmembers class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# 3. Standard Flutter framework rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# 4. Ignore Google Play Core library missing classes (The R8 error we solved)
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**