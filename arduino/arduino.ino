
/*
   This program uses an Arduino for a closed-loop control of TWO brushless DC-motors. 
   Motor motion is detected by a quadrature encoder.
   Two inputs per motor named STEP and DIR allow changing the target position.
   Serial port prints current position and target position every second.
   Serial input can be used to feed a new location for the servo (no CR LF).
   
   Pins used: please read defines and code below

   Please note PID gains kp, ki, kd need to be tuned to each different setup. 
   
  
   */
//#define DEBUG
#include <CmdMessenger.h>  // CmdMessenger

#include <PID_v1.h>

#define encoder1PinA  3
#define encoder1PinB  2
#define PWM1          5
#define CWCCW1        7
#define CWCCW1B       6
#define led           13
#define encsteps      8300
#define forwards      1
#define backwards     -1

//8043
//8298

double kp=1,ki=0,kd=0.0;
double input=0, output=0, setpoint=0, prevoutput=0, prevsetpoint=0, pins[40], tails[40];
int transoutput = 0, orientation = forwards, override = 0, nosent = 0, pinindex = 0, tailindex = 0, sdtype, curtail = 0, curpin = 0;
String msg;
PID myPID(&input, &output, &setpoint,kp,ki,kd, DIRECT);
// Attach a new CmdMessenger object to the default Serial port
CmdMessenger cmdMessenger = CmdMessenger(Serial);


volatile long encoder1Pos = 0, prevencoderpos = 0;


long previousMillis = 0;        // will store last time LED was updated

long target1=0;  // destination location at any moment


//for motor control ramps 1.4
bool newStep = false;
bool oldStep = false;
bool dir = false;
byte skip=0;
bool ledState                   = 0;   // Current state of Led
bool overrideplus = false;
bool overridemin = false;
bool overridestop = false;
bool atTarget = true;
bool PINS = false;
bool TAILS = false; 
bool REVTAILS = false;
bool donit = false;

int posit                         = 0;   // Position

// This is the list of recognized commands. These can be commands that can either be sent or received. 
// In order to receive, attach a callback function to these events
enum
{
  kSetLed              , // Command to request led to be set in specific state
  kStatus              , // Command to report status
  kPosition            , // Position
  kQuery               , // prints out current encoder, output and setpoint values
  kTuning              , // Set PID tuning
  kGetTuning              , // Get PID tuning
  kDirection              , // change fence direction
  kGetDirection           , // check fence direction
  kSetHome               , // zero encodePos
  kAtHome               , 
  kOverride               ,
  kAuto                  , 
  kSetPins              ,       
  kSetTails              ,    
  kNextTail              ,    
  kPrevTail               ,        
  kNextPin              ,    
  kPrevPin              ,     
  kGetPins              ,  
  kGetTails              ,  
  kSetRevTails          ,

};
// Callbacks define on which received commands we take action
void attachCommandCallbacks()
{
  // Attach callback methods
  cmdMessenger.attach(OnUnknownCommand);
  cmdMessenger.attach(kSetLed, OnSetLed);
  cmdMessenger.attach(kPosition, OnPositionChanged);
  cmdMessenger.attach(kQuery, OnQuery);
  cmdMessenger.attach(kTuning, OnTuning);
  cmdMessenger.attach(kGetTuning, OnGetTuning);
  cmdMessenger.attach(kDirection, OnDirection);
  cmdMessenger.attach(kGetDirection, OnGetDirection);
  cmdMessenger.attach(kSetHome, OnSetHome);
  cmdMessenger.attach(kAtHome, OnAtHome);
  cmdMessenger.attach(kOverride, OnOverride);
  cmdMessenger.attach(kAuto, OnAuto);
  cmdMessenger.attach(kSetPins, OnSetPins);
  cmdMessenger.attach(kSetTails, OnSetTails);
  cmdMessenger.attach(kNextTail, OnNextTail);
  cmdMessenger.attach(kPrevTail, OnPrevTail);
  cmdMessenger.attach(kNextPin, OnNextPin);
  cmdMessenger.attach(kPrevPin, OnPrevPin);
  cmdMessenger.attach(kGetPins, OnGetPins);
  cmdMessenger.attach(kGetTails, OnGetTails);
  cmdMessenger.attach(kSetRevTails, OnSetRevTails);
}

// Called when a received command has no attached function
void OnUnknownCommand()
{
  cmdMessenger.sendCmd(kStatus,"Command without attached callback");
}

// Callback function that sets led on or off
void OnSetLed()
{
  
  // Read led state argument, interpret string as boolean
  ledState = cmdMessenger.readBoolArg();
  // Set led
  digitalWrite(led, ledState?HIGH:LOW);
  // Send back status that describes the led state
  cmdMessenger.sendCmd(kStatus,(int)ledState);
}
void OnPositionChanged()
{
  target1=cmdMessenger.readFloatArg()*encsteps/350;
  setpoint=target1;
  atTarget = false;
  OnQuery();
  //cmdMessenger.sendCmdStart(kPosition);
  //cmdMessenger.sendCmdArg("Position");
  //cmdMessenger.sendCmdArg(int(target1));
  //cmdMessenger.sendCmdEnd();
  
}
void OnQuery()
{
  cmdMessenger.sendCmdStart(kQuery);
  cmdMessenger.sendCmdArg(encoder1Pos);
  cmdMessenger.sendCmdArg(transoutput);
  cmdMessenger.sendCmdArg(output);
  cmdMessenger.sendCmdArg(setpoint);
  cmdMessenger.sendCmdArg(curpin);
  cmdMessenger.sendCmdArg(PINS);
  cmdMessenger.sendCmdArg(curtail);
  cmdMessenger.sendCmdArg(TAILS);
  cmdMessenger.sendCmdEnd();
  prevencoderpos = encoder1Pos;
  prevoutput = output;
  prevsetpoint = setpoint;
}
void OnTuning()
{
  kp = cmdMessenger.readFloatArg();
  ki = cmdMessenger.readFloatArg();
  kd = cmdMessenger.readFloatArg();
  myPID.SetTunings(kp,ki,kd);
  OnGetTuning();
  
}
void OnGetTuning()
{
  cmdMessenger.sendCmdStart(kGetTuning);
  cmdMessenger.sendCmdArg(kp);
  cmdMessenger.sendCmdArg(ki);
  cmdMessenger.sendCmdArg(kd);
  cmdMessenger.sendCmdEnd();
  
}

void OnDirection()
{ 
  orientation = cmdMessenger.readInt16Arg();
  if (orientation >= 0) {orientation = forwards;}
  else {orientation = backwards;}
  OnGetDirection();
  
}

void OnGetDirection()
{ 
  cmdMessenger.sendCmdStart(kGetDirection);
  cmdMessenger.sendCmdArg(orientation);
  cmdMessenger.sendCmdEnd();
  
}

void OnSetHome()
{ 
  target1=0;
  setpoint=target1;
  encoder1Pos = 0;
  prevsetpoint=setpoint;
  prevoutput=output;
  prevencoderpos=encoder1Pos;
  
  OnAtHome();
  
}

void OnAtHome()
{ 
  cmdMessenger.sendCmdStart(kAtHome);
  cmdMessenger.sendCmdArg("AtHome");
  cmdMessenger.sendCmdEnd();
  OnQuery();
  
}

void OnOverride()
{
  cmdMessenger.sendCmdStart(kOverride);
  cmdMessenger.sendCmdArg("Forced Move");

  override = cmdMessenger.readInt16Arg();
  if (override < 0) {
    overridemin = true;
    cmdMessenger.sendCmdArg("Forwards");
  }
  else if (override > 0) {
    overrideplus = true;
    cmdMessenger.sendCmdArg("Backwards");
  }
  
  else { overridestop = true;
    cmdMessenger.sendCmdArg("Stand Still");
  }
  cmdMessenger.sendCmdEnd();
  
}
void OnAuto() {
  overrideplus = false;
  overridemin = false;
  overridestop = false;
}

void OnSetPins()
{ 

  sdtype = cmdMessenger.readInt16Arg();
  if (sdtype == 1) {
    donit = false;
    nosent = 0;
    msg = "type1";

    while (!donit) {
     pins[nosent] = cmdMessenger.readFloatArg();
     if (pins[nosent] == -99) {
      donit = true;
     }
      nosent += 1;
    }
    nosent -= 1;

 }
   if (sdtype == 2) {
    donit = false;
    msg = "type2";
    while (!donit) {
     pins[nosent] = cmdMessenger.readFloatArg();
     if (pins[nosent] == -99) {
      donit = true;
      pins[nosent] = 0;
     }
      nosent += 1;
     }
    nosent -= 1;
    

 }
 pinindex = 0;
 PINS = true;
 TAILS = false;
 REVTAILS = false;
 // OnGetPins();
  
}

void OnSetTails()

{ 
  sdtype = cmdMessenger.readInt16Arg();
  if (sdtype == 1) {
    donit = false;
    nosent = 0;
    msg = "type1";

    while (!donit) {
     tails[nosent] = cmdMessenger.readFloatArg();
     if (tails[nosent] == -99) {
      donit = true;
     }
      nosent += 1;
    }
    nosent -= 1;

 }
   if (sdtype == 2) {
    donit = false;
    msg = "type2";
    while (!donit) {
     tails[nosent] = cmdMessenger.readFloatArg();
     if (tails[nosent] == -99) {
      donit = true;
      pins[nosent] = 0;
     }
      nosent += 1;
     }
    nosent -= 1;
    

 }
  tailindex = 0;
  TAILS = true;
  REVTAILS = false;
  PINS = false;
}

void OnNextTail() {
  if (REVTAILS == false) {
    if (tails[tailindex] > 0 ) {
      if (tailindex < curtail) {tailindex = curtail + 1;}
      target1 = tails[tailindex];
      curtail = tailindex;
      setpoint=target1;
      atTarget = false;
      OnQuery();
      tailindex += 1;
      if (tails[tailindex] == 0 ) {tailindex -= 1;}
    }
  }
    if (REVTAILS == true) {
    if (tails[tailindex] < 0 ) {
      if (tailindex < curtail) {tailindex = curtail + 1;}
      target1 = tails[tailindex];
      curtail = tailindex;
      setpoint=target1;
      atTarget = false;
      OnQuery();
      tailindex += 1;
      if (tails[tailindex] == 0 ) {tailindex -= 1;}
    }
  }
}

void OnPrevTail() {
   if (tailindex > curtail) {tailindex = curtail -1;}
   target1 = tails[tailindex];
   setpoint=target1;
   curtail = tailindex;
    atTarget = false;
    OnQuery();
   if (tailindex > 0 ) {
    tailindex -= 1;
  }
}

void OnNextPin() {
  if (pins[pinindex] > 0 ) {
    if (pinindex < curpin) {pinindex = curpin + 1 ;}
    target1 = pins[pinindex];
    curpin = pinindex;
    pinindex += 1;
    if (pins[pinindex] == 0 ) {pinindex -= 1;}
    setpoint=target1;
    atTarget = false;
    OnQuery();
  }
}

void OnPrevPin() {
   if (pinindex > curpin) {pinindex = curpin -1;}
   target1 = pins[pinindex];
   setpoint=target1;
   curpin = pinindex;
    atTarget = false;
    OnQuery();
   if (pinindex > 0 ) {
    pinindex -= 1;
  }
}

void OnGetPins() {
  //msg += "AA";
  cmdMessenger.sendCmdStart(kGetPins);
  pinindex = 0;
  
  //cmdMessenger.sendCmdArg(msg);
  while (pins[pinindex] > 0) {
    cmdMessenger.sendCmdArg(pins[pinindex]);
    pinindex = pinindex + 1;
  }

  cmdMessenger.sendCmdArg(0);
  cmdMessenger.sendCmdEnd();
  pinindex = 0;
}

void OnGetTails() {
  //msg += "AA";
  cmdMessenger.sendCmdStart(kGetTails);
  tailindex = 0;
  if (REVTAILS == false) {
  //cmdMessenger.sendCmdArg(msg);
   
    while (tails[tailindex] > 0) {
      cmdMessenger.sendCmdArg(tails[tailindex]);
      tailindex = tailindex + 1;
    }
  }
  if (REVTAILS == true) {
  
    while (tails[tailindex] < 0) {
      cmdMessenger.sendCmdArg(tails[tailindex]);
      tailindex = tailindex + 1;
    }
  }
  cmdMessenger.sendCmdArg(0);
  cmdMessenger.sendCmdEnd();
  tailindex = 0;
}
void OnSetRevTails()

{ 
  sdtype = cmdMessenger.readInt16Arg();
  if (sdtype == 1) {
    donit = false;
    nosent = 0;
    msg = "type1";

    while (!donit) {
     tails[nosent] = cmdMessenger.readFloatArg();
     if (tails[nosent] == 99) {
      donit = true;
     }
      nosent += 1;
    }
    nosent -= 1;

 }
   if (sdtype == 2) {
    donit = false;
    msg = "type2";
    while (!donit) {
     tails[nosent] = cmdMessenger.readFloatArg();
     if (tails[nosent] == 99) {
      donit = true;
      pins[nosent] = 0;
     }
      nosent += 1;
     }
    nosent -= 1;
    

 }
  tailindex = 0;
  REVTAILS = true;
  TAILS = true;
  PINS = false;
}


// Install Pin change interrupt for a pin, can be called multiple times
void pciSetup(byte pin) 
{
    *digitalPinToPCMSK(pin) |= bit (digitalPinToPCMSKbit(pin));  // enable pin
    PCIFR  |= bit (digitalPinToPCICRbit(pin)); // clear any outstanding interrupt
    PCICR  |= bit (digitalPinToPCICRbit(pin)); // enable interrupt for the group 
}

void setup() { 
  
  pinMode(encoder1PinA, INPUT_PULLUP); //digitalWrite(encoder0PinA, HIGH); 
  pinMode(encoder1PinB, INPUT_PULLUP);// digitalWrite(encoder0PinB, HIGH);  
  //attachInterrupt(encoder0PinA, doEncoderMotor0, CHANGE);  // encoder pin on interrupt 0 - pin 2
  //attachInterrupt(encoder0PinB, doEncoderMotor0, CHANGE);    
  pciSetup(encoder1PinA);
  pciSetup(encoder1PinB);
  //pinMode(led, OUTPUT);
  
  

  
  TCCR1B = TCCR1B & 0b11111000 | 1; // set  Hz PWM
  Serial.begin (9600);
  // Adds newline to every command
  cmdMessenger.printLfCr();
  // Attach my application's user-defined callback methods
  attachCommandCallbacks();

  // Send the status to the PC that says the Arduino has booted
  // Note that this is a good debug function: it will let you also know 
  // if your program had a bug and the arduino restarted  
  cmdMessenger.sendCmd(kStatus,"Arduino has started!");

  // set pin for blink LED
  pinMode(led, OUTPUT);
  //Setup the pid 
  //help();
  myPID.SetMode(AUTOMATIC);
  myPID.SetSampleTime(1);
  myPID.SetOutputLimits(-255,255);
  //pinMode(13,OUTPUT); digitalWrite(13,HIGH); // disable motor brake
  pinMode(CWCCW1,OUTPUT); pinMode(CWCCW1B,OUTPUT); analogWrite(PWM1,0);

  // step pin interrupts on rising edge
  //attachInterrupt(0, countStep      , RISING);  // step0  input on interrupt 1 - pin 2
  

} 

void loop(){
    
    input = encoder1Pos; 
    setpoint=target1;

    myPID.Compute();
    if (overrideplus) { output = 255;}
    if (overridemin) { output = -255;}
    if (overridestop) { output = 0;}
    // interpret received data as an integer (no CR LR): provision for manual testing over the serial port
    //if(Serial.available()) process_line(); // it may induce a glitch to move motion, so use it sparingly 
    cmdMessenger.feedinSerialData();
    transoutput = abs(output)*(255-200)/255 + 200;
    if(output<0) transoutput = -transoutput; 
    pwmOut(transoutput); 
    if(millis() % 1000 == 0 && ( setpoint != prevsetpoint || output != prevoutput || encoder1Pos != prevencoderpos)) OnQuery();


}
 
void pwmOut(int out) {
  // if(abs(out)<10) digitalWrite(13,LOW); else digitalWrite(13,HIGH); // brake, compensate dead-band
   if (orientation == forwards) {
     if(out>=0) { digitalWrite(CWCCW1,HIGH); digitalWrite(CWCCW1B,LOW); } 
     else { digitalWrite(CWCCW1, LOW); digitalWrite(CWCCW1B,HIGH);  }
     analogWrite(PWM1, abs(out) );
   }
   else {
     if(out<0) { digitalWrite(CWCCW1,HIGH); digitalWrite(CWCCW1B,LOW); } 
     else { digitalWrite(CWCCW1, LOW); digitalWrite(CWCCW1B,HIGH);  }
     analogWrite(PWM1, abs(out) );
   }
   if (encoder1Pos == setpoint && overrideplus == false && overridemin == false ) {
      analogWrite(PWM1, 0 );
   }
    if (overridestop) {  analogWrite(PWM1, 0 );  }
    }
  



  
  
const int QEM [16] = {0,-1,1,2,1,0,2,-1,-1,2,0,1,2,1,-1,0};               // Quadrature Encoder Matrix
static unsigned char New, Old;

  ISR (PCINT2_vect) // handle pin change interrupt for D0 to D7 here
 { 
  Old = New;
  New = ((PIND & 4 )/4)+ ((PIND & 8)/4); //
  encoder1Pos+= QEM [Old * 4 + New];
  //Serial.println(encoder1Pos);
  
}




