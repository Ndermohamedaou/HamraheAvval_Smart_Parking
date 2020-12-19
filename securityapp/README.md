# Security App

A future app for security mode!!

## If you want run this app on:

- **AVD**: 

  Android Virtual Device Localhost mean:

  `http://10.0.2.2:8000`

- **Physical** **Device**: 

  - API will run with:

    `php artisan serv --host 0.0.0.0 --port 8000`

  - Client side run:

    - Physical Device Localhost 

    ​	`IP of your workstation like http://192.168.1.51:8000`

  - iOS localhost:

    - iOS Localhost 

      `http://127.0.0.1:8000`

### Main permission in AndroidManifest.xml

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