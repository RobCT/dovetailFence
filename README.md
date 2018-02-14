## About the Project
This is a DIY project to build a precision dovetail fence for a table router. It uses a dc motor and reduction gearing to drive a 6mm threaded rod leadscrew and an optical sensor strip and quadrature encoder sensor from a junked printer. It uses the positional data from the encoder in a closed loop feedback system (PID) to accurately position the fence.
It is of interest to woodworkers with a technical bias.

### What's here
The repository is a collection of files from the various tools that were use to create the fence.
I wont call this a Beta as it is not that well worked out even. All I will say is that I made it and it works and produces some beautiful work but it is not a worked up description. So in summary there are:

#### an arduino sketch built using the arduino IDE. The target device is an arduino UNO. It depends in the PID and cmdMessenger libraries for arduino.

#### qml projects built using Qt Creator the Qt IDE. There is one for a desktop computer (in my case Ubuntu 64 bit but should work on any if re-built with the appropriate tool chain and processor type) and one for an android device (target android v5 because that was what I had but again can be re-built for any)

   The Qt projects are used to design the joint profile and to control the fence actions by communicating with the arduino using bluetooth

#### various other bits and pieces I used to make an arduino add on pcb for a bluetooth chip and some gcode for making the gear train on cnc.

There is also a part assembly drawing image in docs showing the mechanical side of things.