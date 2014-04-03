##XCore Driver for 4x4 Matrix Keypads
This project provides an XCore driver module for interfacing to scanned 4x4 matrix keypads.  It is written in the XC language and has been tested on the XMOS [startKIT](http://www.xmos.com/startkit).  The repository also contains an example program that uses the keypad to edit and enter a 4 digit lock combination.  The example also incorporates a [SparkFun Serial 7 Segment Display](https://github.com/teachop/xcore_seven_seg).

###Introduction
The driver is a task function that scans a 4x4 (hex) keypad by driving 4 columns one at a time and reading the 4 row results.  Key presses are translated into key codes that are specified in the config_keypad header.  The task uses a timer to generate the scanning tick, and also to provide timing for debounce, pause, and auto-repeat features.

The driver will reject multiple simultaneous key presses.

Application clients use the driver by means of an [interface](https://www.xmos.com/support/documentation/xtools?subcategory=Programming%20in%20C%20and%20XC&component=app_interfaces_example) API.  This is an XCore XC message passing inter-task communication feature.  The interface feature notification is used to alert the client application when a key has been pressed.

###Driver API
- **keyPressed()** - notification event indicating to the client that a key press is available.  The key buffering is 1 level deep, the next key press will replace any unread key press.
- **getKey()** - returns a waiting key press, or 0 if there isn't one.  This call also clears notification.
