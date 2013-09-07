BUGS:

-Address this: If the application is foremost and visible when the system delivers the notification, no alert is shown, no icon is badged, and no sound is played. However, the application:didReceiveLocalNotification: is called if the application delegate implements it. The UILocalNotification instance is passed into this method, and the delegate can check its properties or access any custom data from the userInfo dictionary.

-view summary of alert when tapping on the medication -- or maybe take out the edit button and have tap go to edit? Since this would also solve:

  --Text goes past the label when editing and there are a lot of days.

  --when going back to the edit alert page you can't actually edit (have to click "done" and then "edit" again). Fix by either defaulting to done or allowing edit.

-Don't save alert if user presses back (only save if user presses save). Would be nice to also show a message if the user goes back with changes and without saving.