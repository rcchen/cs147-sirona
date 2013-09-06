BUGS:

-when going back to the edit alert page you can't actually edit (have to click "done" and then "edit" again). Fix by either defaulting to done or allowing edit.

-Text goes past the label when editing and there are a lot of days.

-If no dosage specified, don't show the label on the home screen

-If just 1 time a day, have label say "1 time" not "1 times"

-Adding the next alarm in a week from now for some times that shouldn't be added that much.

-Address this: If the application is foremost and visible when the system delivers the notification, no alert is shown, no icon is badged, and no sound is played. However, the application:didReceiveLocalNotification: is called if the application delegate implements it. The UILocalNotification instance is passed into this method, and the delegate can check its properties or access any custom data from the userInfo dictionary.