//---------------------------------------------------------
// Matrix keypad driver header
// by teachop
//

#ifndef __KEYPAD_H__
#define __KEYPAD_H__

// driver interface
interface keypad_if {

    // returns a key
    [[clears_notification]] uint32_t getKey(void);

    // signal key was pressed
    [[notification]] slave void keyPressed(void);

};

[[combinable]]
void keypad_task(out port drive, in port sense, interface keypad_if server dvr);


#endif //__KEYPAD_H__
