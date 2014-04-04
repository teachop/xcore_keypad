##XCore Driver for 4x4 Matrix Keypads
This project provides an XCore driver module for interfacing to scanned 4x4 matrix keypads.  It is written in the XC language and has been tested on the XMOS [startKIT](http://www.xmos.com/startkit).  The repository also contains an example program that uses the keypad to edit and enter a 4 digit lock combination.  The example also incorporates a [SparkFun Serial 7 Segment Display](https://github.com/teachop/xcore_seven_seg).

###Introduction
The driver is a task function that scans a 4x4 keypad (example known to work [here](http://www.amazon.com/Universial-Switch-Keypad-Keyboard-Arduino/dp/B008A30NW4)) by driving 4 columns one at a time and reading the 4 row results.  Key presses are translated into key codes that are specified in the config_keypad header.

Note that the driver is designed to reject multiple simultaneous key presses - no valid key will be detected until only one key is down.

Application clients use the driver by means of an XC [interface](https://www.xmos.com/support/documentation/xtools?subcategory=Programming%20in%20C%20and%20XC&component=app_interfaces_example) API.  This is an XCore message passing inter-task communication feature.  An interface feature called **notification** is used to generate a data-read events for the client application when a valid key press has been detected.

###Timing
The driver task uses a timer resource to generate the scanning tick, and also to provide a timebase for switch debounce, pause, and auto-repeat features.  If a key continues to be held down after the initial key press event, the driver will first pause (640 milliseconds) and then generate rapid key repeats (160 milliseconds) similar to a computer keyboard.

Debounce is accomplished by timing and its operation guarantees a minimum delay between keystrokes of 64 milliseconds.

###Driver API
- **keyPressed()** - notification event indicating to the client that a key press is available.
- **getKey()** - returns a waiting key press, or 0 if there isn't one.  This call also clears notification.  The key buffering is 1 level deep.  If a second key press were to become available before the prior one is read, it will replace the unread key press.
