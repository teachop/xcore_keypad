##Example for XCore Matric Keypad Driver
Implement a 4 digit lock combination to demonstrate the keypad driver.  Customize the config_keypad header to match your hardware.  As written, the keypad is a fairly standard phone style of 4x4 matrix.  The number in the lock can be changed by direct entry, incrementing / decrementing, clearing, etc.  Pressing "*" is the ENTER key to see if the combination is correct.

A serial 4 digit 7 segment display is used to show the lock combination value.

###Required Modules
For an xCore xC application, the required modules are listed in the Makefile:
- USED_MODULES = module_seven_seg module_keypad

###Wiring
The display uses a single pin for serial data.  The demo wires this to a 4-wide port LSB, but normally this would be a single output port pin.  The matrix requires two 4-wide ports, one output to drive the columns, one input to read the rows.  Internall pull-downs in the startKIT CPU are used to keep the keys off when not pressed.
- **XS1_PORT_4E**  Column driver, j7.22, 24, 16, 18
- **XS1_PORT_4D**  Row inputs, j7.9, 13, 12, 14
- **XS1_PORT_4C**  TXD UART transmit, j7.5, [6, 7, 8]
