//---------------------------------------------------------
// Matrix keypad driver
// by teachop
//

#include <xs1.h>
#include <stdint.h>
#include "keypad.h"

#define __KEYPAD_C__
#include "config_keypad.h"


// ---------------------------------------------------------
// decode - translate scan bitmap into key codes
//
static uint32_t decode(uint32_t keys) {
    uint32_t result = 0;

    if ( keys ) {
        uint32_t mask = 1;
        for ( uint32_t key_index=0; 16>key_index; ++key_index ) {
            if ( keys & mask ) {
                if ( 0 == (keys^mask) ) {
                    // only one pressed
                    result = key_map[key_index];
                }
                break;
            }
            mask <<=1;
        }
    }

    return result;
}

// ---------------------------------------------------------
// keypad_task - Matrix keypad driver
//
void keypad_task(out port drive, in port sense, interface keypad_if server dvr) {
    uint32_t scan = 0;
    uint32_t pressed = 0;
    uint32_t none_on = 1;
    uint32_t hold_off = 0;
    uint32_t key_state = 0;

    uint32_t tick_rate = 2*1000*100;
    timer tick;
    uint32_t next_tick;
    tick :> next_tick;

    drive <: (1<<scan);

    while( 1 ) {
        select {
        case dvr.getKey() -> uint32_t return_val:
            return_val = key_state;
            key_state = 0; // delete after reading
            break;

        case tick when timerafter(next_tick) :> void:
            // timer tick event, matrix-style keypads need scanned
            next_tick += tick_rate;
            // sample inputs after 1 tick to settle
            uint32_t key_in;
            sense :> key_in;
            pressed = (pressed<<4) | key_in;
            // completed scan of keypad
            if ( ++scan >= 4 ) {
                hold_off = (!pressed && (8<hold_off))? 8 : (hold_off? hold_off-1 : 0);
                if ( !hold_off ) {
                    uint32_t valid_key = decode(pressed);
                    if ( valid_key ) {
                        key_state = valid_key;
                        dvr.keyPressed();
                        hold_off = none_on? 80 : 20;
                        none_on = 0;
                    }
                }
                none_on = none_on || !pressed;
                pressed = scan = 0;
            }
            // drive column for next sample reading tick
            drive <: (1<<scan);
            break;
        }
    }

}
