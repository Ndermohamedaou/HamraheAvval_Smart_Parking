# PAYA PMS


 

A future app for security mode!!

## At fist add this permissions on Android manifest:

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
    
    # FCM Notification in raw and JSON

Authorization is required, it's server key from Firebase:
(If does't work, go to Firebase console)

`key=AAAAF5agqKM:APA91bEo9GrUBvO-05F-vt9j0vE-xE_m9yZM81zjyVGk2iUIxvD0M9dv9kwPoUkAALIxAr1JLvzo0tZSKHjxqIIjswlgwg29usM0LcZF0oP7bt7Mx46TKxabyt7V5rIUEWC-_e4onE8v`

Content-type will be `application/json`

Body: 

`"to"` is destination of user device token  

```json
{
"to": "",
 "notification" : {
  "sound" : "default",
  "title" : "TITLE",
  "body" :  "BODY",
  "content_available" : true,
  "priority" : "high"
 }
}
```

