//-----------------------------------------------------------
// XCore Matrix Keypad Driver Test Application
// by teachop
//
// Enter a combination lock number with the keypad.
//

#include <xs1.h>
#include <timer.h>
#include <stdint.h>
#include "seven_seg.h"
#include "keypad.h"

#define COMBINATION 1234


// ---------------------------------------------------------
// lock_task - combination lock
//
void lock_task(interface keypad_if client keypad, interface seven_seg_if client display) {
    uint8_t yes[] = "YES ";
    uint8_t oops[]= "OOpS";
    uint32_t counter = 0;

    // initial display, no decimal places, use leading zeros
    display.setValue(counter,0,1);

    while (1) {
        select {
        case keypad.keyPressed():
            // key-press notification, go get it
            uint32_t pressed = keypad.getKey();
            uint32_t counter_was = counter;
            if ( ('0'<=pressed) && ('9'>=pressed) ) {
                // insert digits
                counter = 10*(counter%1000) + (pressed-'0');
            } else switch ( pressed ) {
            case 'A': // up by 1
                counter = (9999>counter)? counter+1 : 9999;
                break;
            case 'B': // down by 1
                counter = (0<counter)? counter-1 : 0;
                break;
            case 'C': // up by 100
                counter = (9900>counter)? counter+100 : 9999;
                break;
            case 'D': // down by 100
                counter = (99<counter)? counter-100 : 0;
                break;
            case '#': // clear
                counter = 0;
                break;
            case '*': // enter
                display.setText(COMBINATION==counter? yes:oops);
                break;
            }
            if ( counter != counter_was ) {
                display.setValue( counter, 0, 1 );
            }
            break;
        }
    }
}


// ---------------------------------------------------------
// main - xCore keypad matrix test
//
out port drive_pins= XS1_PORT_4E; // j7.22, 24, 16, 18
in port sense_pins = XS1_PORT_4D; // j7.9, 13, 12, 14
port txd_pin       = XS1_PORT_4C; // j7.5, [6, 7, 8]

int main() {
    interface seven_seg_if display;
    interface keypad_if keypad;

    set_port_pull_down(sense_pins);

    par {
        lock_task(keypad, display);
        keypad_task(drive_pins, sense_pins, keypad);
        seven_seg_task(txd_pin, display);
    }

    return 0;
}
