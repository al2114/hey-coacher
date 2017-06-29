#include "mbed.h"
#include "ble/BLE.h"

#define THRESHOLD_PRESS 0.08
#define TIME_BETWEEN_TOUCH 0.05
#define TIME_BETWEEN_CYCLE 0.1

#define LEFT_PUSH 1
#define RIGHT_PUSH 2
#define LEFT_SWIPE 3
#define RIGHT_SWIPE 4

/* Four capacitive touch inputs; active low
 * Two on the left, two on the right, all in one row */
DigitalIn touch1(P0_12);
DigitalIn touch2(P0_13);
DigitalIn touch3(P0_14);
DigitalIn touch4(P0_15);

/* One pressure sensor input */
AnalogIn press(P0_1);

/* One haptic input */
/* PwmOut  haptic(P0_16); */

/* Choose custom GATT UUIDS and profile name */
uint16_t customServiceUUID  = 0xA000;
uint16_t readCharUUID       = 0xA001;
const static char     DEVICE_NAME[] = "Touch Signal";
static const uint16_t uuid16_list[] = {0xA000}; /* Custom UUID, FFFF is reserved for development */

/* Variable used to search for inputs every 0.3 seconds and prevent connection timeout */
static volatile bool triggerSensorPolling = false;

/* Ouput variable */
uint8_t readSignal = 0;

/* Set up custom read characteristic*/
ReadOnlyGattCharacteristic<uint8_t> readChar(readCharUUID, &readSignal, GattCharacteristic::BLE_GATT_CHAR_PROPERTIES_NOTIFY);

/* Set up custom service */
GattCharacteristic *characteristics[] = {&readChar};
GattService        customService(customServiceUUID, characteristics, sizeof(characteristics) / sizeof(GattCharacteristic *));

/* Restart advertising when phone app disconnects */
void disconnectionCallback(const Gap::DisconnectionCallbackParams_t *){
    BLE::Instance(BLE::DEFAULT_INSTANCE).gap().startAdvertising();
}

void periodicCallback(void){
    /* Note that the periodicCallback() executes in interrupt context, so it is safer to do
     * heavy-weight sensor polling from the main thread. */
    triggerSensorPolling = true;
}

/* Initialization callback */
void bleInitComplete(BLE::InitializationCompleteCallbackContext *params){
    BLE &ble          = params->ble;
    ble_error_t error = params->error;
    if(error != BLE_ERROR_NONE){
        return;
    }
    ble.gap().onDisconnection(disconnectionCallback);
    /* Setup advertising */
    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::BREDR_NOT_SUPPORTED | GapAdvertisingData::LE_GENERAL_DISCOVERABLE); /* BLE only, no classic BT */
    ble.gap().setAdvertisingType(GapAdvertisingParams::ADV_CONNECTABLE_UNDIRECTED); /* Advertising type */
    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LOCAL_NAME, (uint8_t *)DEVICE_NAME, sizeof(DEVICE_NAME)); /* Add name */
    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LIST_16BIT_SERVICE_IDS, (uint8_t *)uuid16_list, sizeof(uuid16_list)); /* UUID's broadcast in advertising packet */
    ble.gap().setAdvertisingInterval(300); /* 300 ms */
    /* Add custom service */
    ble.addService(customService);
    /* Start advertising */
    ble.gap().startAdvertising();
}

void pressed(){
    /* Check which side of capacitive touch pad is being touched */
    if((touch1 == 0 || touch2 == 0) && (touch3 == 1 && touch4 == 1)){
        /* Left push
         * Success buzz */
        readSignal = LEFT_PUSH;
    }
    else if((touch3 == 0 || touch4 == 0) && (touch1 == 1 && touch2 == 1)){
        /* Right push
         * Success buzz */
        readSignal = RIGHT_PUSH;
    }
    /* If both sides are pressed, there is an error */
    else{
        /* Failure buzz */
        wait(TIME_BETWEEN_CYCLE);
    }
}

/* Three out of four of the switches need to be touched in the correct order */
void swiped_right(){
    /* Assign bool variable that turns true if no error: if true, then there is a swipe */
    bool checkSwipe = false;
    /* Variables used for polling */
    int i, j;
    /* If the leftmost switch is touched, check if the next one is touched */
    if(touch1 == 0){
        /* If both left switches are touched, only one of the right switches need to be touched */
        if(touch2 == 0){
            /* Variables i and j are used for polling in a while loop 5 times to search for a touch
             * If the required input is sensed it exits the while loop to sense the next input or make checkSwipe true
             * Every time there is no input i or j increments
             * If no input is sensed and i = 5 or j = 5, then it exits the while loop to keep checkSwipe false */
            i = 5;
            while(i > 0){
                wait(TIME_BETWEEN_TOUCH);
                /* If one of the right switches are touched next, then checkSwipe is true */
                if(touch3 == 0 || touch4 == 0){
                    checkSwipe = true;
                    i = 0;
                }
                else{
                    i--;
                }
            }
        }
        else{
            i = 5;
            while(i > 0){
                wait(TIME_BETWEEN_TOUCH);
                /* If only the leftmost switch is touched, check if the other left switch is touched */
                if(touch2 == 0){
                    j = 5;
                    while(j > 0){
                        wait(TIME_BETWEEN_TOUCH);
                        /* If both left switches are touched, only one of the right switches need to be touched for checkSwipe to be true */
                        if(touch3 == 0 || touch4 == 0){
                            checkSwipe = true;
                            j = 0;
                        }
                        else{
                            j--;
                        }
                    }
                    i = 0;
                }
                /* If the leftmost switch is touched and the third switch after, only the rightmost switch needs to be touched */
                else if(touch3 == 0){
                    j = 5;
                    while(j > 0){
                        wait(TIME_BETWEEN_TOUCH);
                        /* If the rightmost switch is touched, checkSwipe becomes true */
                        if(touch4 == 0){
                            checkSwipe = true;
                            j = 0;
                        }                                  
                        else{
                            j--;
                        }
                    }
                }          
                else{
                    i--;
                }
            }
        }
    }
    /* If only the second switchs is touched, the two right switches need to be touched */
    else{
        i = 5;
        while(i > 0){
            wait(TIME_BETWEEN_TOUCH);
            /* If the third switch is touched, check if the rightmost switch is touched */
            if(touch3 == 0){
                j = 5;
                while(j > 5){
                    wait(TIME_BETWEEN_TOUCH);
                    /* If the rightmost switch is touched, checkSwipe becomes true */
                    if(touch4 == 0){
                        checkSwipe = true;
                        j = 0;
                    }                    
                    else{
                        j--;
                    }
                }
                i = 0;
            }  
            else{
                i--;
            }
        }
    }
    /* If checkSwipe is true, then there was a swipe gesture */
    if(checkSwipe){
        /* Right swipe
         * Success buzz */
        readSignal = RIGHT_SWIPE;
    }
    /* If checkswipe is false, then there was an error */
    else{
        /* Failure buzz */
        wait(TIME_BETWEEN_CYCLE);
    }
}

/* Three out of four of the switches need to be touched in the correct order
 * Same as swiped_right except in opposite direction */
void swiped_left(){
    bool checkSwipe = false;
    int i, j;
    if(touch4 == 0){
        if(touch3 == 0){
            i = 5;
            while(i > 0){
                wait(TIME_BETWEEN_TOUCH);
                if(touch2 == 0 || touch1 == 0){
                    checkSwipe = true;
                    i = 0;
                }
                else{
                    i--;
                }
            }
        }
        else{
            i = 5;
            while(i > 0){
                wait(TIME_BETWEEN_TOUCH);
                if(touch3 == 0){
                    j = 5;
                    while(j > 0){
                        wait(TIME_BETWEEN_TOUCH);
                        if(touch2 == 0 || touch1 == 0){
                            checkSwipe = true;
                            j = 0;
                        }
                        else{
                            j--;
                        }
                    }
                    i = 0;
                }
                else if(touch2 == 0){
                    j = 5;
                    while(j > 0){
                        wait(TIME_BETWEEN_TOUCH);
                        if(touch1 == 0){
                            checkSwipe = true;
                            j = 0;
                        }
                        else{
                            j--;
                        }
                    }
                }
                else{
                    i--;
                }
            }
        }
    }
    else{
        i = 5;
        while(i > 0){
            wait(TIME_BETWEEN_TOUCH);
            if(touch2 == 0){
                j = 5;
                while(j > 5){
                    wait(TIME_BETWEEN_TOUCH);
                    if(touch1 == 0){
                        checkSwipe = true;
                        j = 0;
                    }
                    else{
                        j--;
                    }
                }
                i = 0;
            }
            else{
                i--;
            }
        }
    }
    if(checkSwipe){
        /* Left swipe
         * Success buzz */
        readSignal = LEFT_SWIPE;
    }
    else{
        /* Failure buzz */
        wait(TIME_BETWEEN_CYCLE);
    }
}

/* Main loop */
int main(){
    
    /* Setup of recurring interrupt to look for inputs every 0.3 seconds */
    Ticker ticker;
    ticker.attach(periodicCallback, 0.3);
    
    /* Initialise BLE */
    BLE& ble = BLE::Instance(BLE::DEFAULT_INSTANCE);
    ble.init(bleInitComplete);
    
    /* SpinWait for initialization to complete. This is necessary because the
     * BLE object is used in the main loop below. */
    while(ble.hasInitialized() == false){/* Spin loop */}

    /* Infinite loop waiting for BLE interrupt events */
    while(1){
        /* Check for trigger from periodicCallback() */
        if(triggerSensorPolling && ble.getGapState().connected){
            triggerSensorPolling = false;
            /* Check if touch pad is pressed beyond threshold for pressing gesture */
            if(press > THRESHOLD_PRESS){
                pressed();
            }
            /* Check if touch pad is touched on one side for swiping gesture
             * A touch on the left side would potentially be a right swipe */
            else if((touch1 == 0 || touch2 == 0) && (touch3 == 1 && touch4 == 1)){
                swiped_right();
            }
            /* A touch on the right side would potentially be a left swipe */
            else if((touch4 == 0 || touch3 == 0) && (touch2 == 1 && touch1 == 1)){
                swiped_left();
            }
            /* Input is not sent via Bluetooth if 0
             * If not 0, send and reset to 0 for next input cycle */
            if(readSignal != 0){
                ble.updateCharacteristicValue(readChar.getValueHandle(), &readSignal, 1);
                readSignal = 0;
                wait(TIME_BETWEEN_CYCLE);
            }
        }
        else{
            ble.waitForEvent(); /* Low power wait for event */
        }
    }
}