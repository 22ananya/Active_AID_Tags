# Test powering and output

from machine import Pin, PWM
from time import sleep_us
import time
from machine import lightsleep, deepsleep
import sys

def af():
    timeout = time.time() + 20 # 20 second timeout

    neg = Pin(4, Pin.OUT)
    led = Pin("LED", Pin.OUT)

    pos = PWM(Pin(0, mode=Pin.OUT))
    T = 5000 # time period of switching in us

    neg.value(0)
    led.value(0.2)

    duty1 = 65025//2
    fr  = 1000
    pos.freq(fr)
    pos.duty_u16(duty1)

    while time.time() < timeout:
        continue
        
    led.value(0)
    Pin(0, Pin.OUT).value(0)
    deepsleep(10000)
    return

#sys.exit()
# go to deepsleep!
#deepsleep(10000)


if __name__ == '__main__':
    print('was run directly')
    af()
else:
    print('imported')