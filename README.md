## DESCRIPTION

Plugin used to obtain the status of an incoming notification in Android and iOS

## HOW TO USE

- Use stream value
    ```dart
    StreamBuilder(
        stream: NotificationMode().stream,
        ...
    )
    ```

- Use Future function
    ```dart
    try {
        final bool? notificationModel = await NotificationMode().isDeviceMuted();
        ...
    } on PlatformException catch (error) {
        debugPrint(error.toString());
    }
    ```