from machine import Pin
from machine import lightsleep, deepsleep
from actual_func2 import af

# Define the pin that would be checked to see if the program should run.
# In this case it's GP0, connect a button between it and GND.

start = Pin(5, Pin.IN, Pin.PULL_UP)

if start():
    # reduce clock speed to lower power usage
    cf = 18000000
    machine.freq(cf)
    # delay execution to allow capacitor to charge
    lightsleep(10000) # sleep time milliseconds
    af()
    #print('Done')
    
else:
    print('No run')
    

        
