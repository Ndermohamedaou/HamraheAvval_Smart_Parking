# PAYA PMS


 

A future app for security mode!!

## Permissions on Android manifest:

- To access successfully to Internet:

  - ``````xml
    <uses-permission android:name="android.permission.INTERNET" />
    ``````

- To System alert window Realtime render:

  - `````xml
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
    `````

- To access in the local storage in both subtitle or videos:

  - ```xml
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    ```

- Use Biometric mobile users assets :

  - ```xml
    <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
    ```
- FCM Manifest for click and continue and Message event bsae :
  - ```xml
     <intent-filter>
        <action android:name="FLUTTER_NOTIFICATION_CLICK" />
            <category android:name="android.intent.category.DEFAULT" />
        </intent-filter>

      <intent-filter>
            <action android:name="com.google.firebase.MESSAGING_EVENT"/>
      </intent-filter>
      ```
      
- In AppDelegate.swift
  - ```swift
      import UIKit
      import Flutter

      @UIApplicationMain
      @objc class AppDelegate: FlutterAppDelegate {
        override func application(
          _ application: UIApplication,
          didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
          GeneratedPluginRegistrant.register(with: self)
          if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          }
          return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
      }
     ```
     
- In `android:name=".Application"`
  - ```kt
    package com.example.payausers
    import io.flutter.app.FlutterApplication
    import io.flutter.plugin.common.PluginRegistry
    import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
    import io.flutter.view.FlutterMain
    import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

    class Application: FlutterApplication(), PluginRegistrantCallback {

        override fun onCreate () {
            super.onCreate()
            FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
            FlutterMain.startInitialization(this);
        }

        override fun registerWith(registry: PluginRegistry?){
        }
     }
     ```
    
## FCM Notification in raw and JSON

URL is: https://fcm.googleapis.com/fcm/send

Authorization is required, it's server key from Firebase:
(If does't work, go to Firebase console)

`key=AAAAF5agqKM:APA91bEo9GrUBvO-05F-vt9j0vE-xE_m9yZM81zjyVGk2iUIxvD0M9dv9kwPoUkAALIxAr1JLvzo0tZSKHjxqIIjswlgwg29usM0LcZF0oP7bt7Mx46TKxabyt7V5rIUEWC-_e4onE8v`

Content-type will be `application/json`

Body: 

`"to"` is destination of user device token  

```json
{
"to": "fMqFpF9lTMmisolKb7YX6Y:APA91bGPwa4reTo-A74m--jUuoLq1BsmQJ8-hEGRb8RNqUIRSdJkjDfJb8DyljOkhxo2cEAXF6AM0rp22FTNMv7yvlPz63KAU9U61BBF7oFdKEnTmvU08-zsUF6Zy2LTT_w49LXyc4xO", // Device Token 
 "notification" : {
  "sound" : "default",
  "body" :  "Notif",
  "title" : "Title",
  "content_available" : true,
  "priority" : "high"
 },
 "data": {
     "click_action": "FLUTTER_NOTIFICATION_CLICK",
     "sound": "default",
     "status": "done",
     "target": "2" // Target2 is reserve result
                   // Target3 is plate result
 }
}
```

