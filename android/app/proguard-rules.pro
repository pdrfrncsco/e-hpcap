# Ignorar avisos de classes em falta do androidx.window
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**

# Ignorar avisos do Tink (usado por plugins de storage seguro)
-dontwarn com.google.crypto.tink.**

# Manter as classes que o R8 está a tentar remover mas que são necessárias por reflexão
-keep class androidx.window.extensions.** { *; }
-keep class androidx.window.sidecar.** { *; }
