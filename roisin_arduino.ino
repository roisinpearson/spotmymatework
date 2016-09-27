#include <Adafruit_GFX.h>
#include <gfxfont.h>

#include <RGBmatrixPanel.h>


#define CLK 8  // MUST be on PORTB! (Use pin 11 on Mega)
#define OE  9
#define LAT 10
#define A   A0
#define B   A1
#define C   A2
#define D   A3

RGBmatrixPanel matrix(A, B, C, D, CLK, LAT, OE, false);
char pos[20];
String str = "";

void setup() {
  Serial.begin(9600); 
  matrix.begin();
  matrix.fillRect(0, 0, 32, 32, matrix.Color333(0, 0, 0));
}

void loop() {
   //matrix.fillRect(0, 0, 32, 32, matrix.Color333(0, 0, 0));
  
    if(Serial.available()){

      Serial.readBytesUntil('x', pos, 20);

      
      //string txt = 
      //matrix.println(txt);
    }

    for(int i = 0; i < 10; i++){
      if(!(pos[i*2] == 0 && pos[i*2+1] == 0))
        matrix.fillCircle(pos[i*2], pos[i*2+1], 2, matrix.Color333(2, 0, 7));
    }

    delay(5000);
}



