/*

 BoopClient 1.0.5.6
 A chat client for booping.
 
 Changelog:
 
 --- Previous Version
 - Client now detects if there isn't an info.txt file and automatically generates one instead of crashing
 - Added |countdown() command (ex: countdown(100) -- message disappears in 100 ticks)
 - Made |VERSION command more reliant on server response
 - Made |CLEAR and |FLUSH position next message correctly
 - Added disappearing message indicating that messages have been cleared
 - Added DARKBLUE color for bg and tc
 - Added update() method for messages class -> allows removal of individual messages without disrupting display method
 
 --- New Version
 - Added light and dark modes
 - Added |MODE command (ex: light|MODE)
 - Decreased brightness of bottom typing bar for dark mode to match theme
 
 To-do:
 - Other things probably
 
 */

import processing.net.*;

Client myClient;

String str = "start typing...";
String inString ="";
String typing = "Loading BoopClient...";
Boolean isTyping = false;

DisposeHandler dh;

int messagesHeight = 0;

int lastTypeFrame= 0;
int typingFrameLimit = 250;

String version = "1.0.5.6"; // IF YOU UPDATE THIS, UPDATE LATESTCLIENT ON SERVER AS WELL
String username;
String mode;

boolean rainbowMode = false;
int rainbowStep = 0;

ArrayList<message> messages = new ArrayList<message>();

void setup() {
  size(300, 500);
  surface.setResizable(true);
  dh = new DisposeHandler(this);

  if (loadStrings("info.txt").length == 2) {
    String info[] = loadStrings("info.txt");
    username = info[0];
    mode = info[1];
  } else {
    String[] info = new String[2];
    info[0]="SetYourNameBro";
    info[1]="dark";
    saveStrings("info.txt", info);
    username = info[0];
    mode = info[1];
  }

  myClient = new Client(this, "54.208.53.64", 10001);
  myClient.write(username + " has connected!|BGBLUE|weight(5)");
  typing="Hello, "+username+"!";
}

void draw() {
  if (mode.equals("dark")) {
    background(21);
  } else if (mode.equals("light")) {
    background(220);
  }

  if (frameCount - lastTypeFrame > typingFrameLimit && isTyping==true) {
    myClient.write(username+"|NOTTYPING");
    isTyping = false;
  }

  textAlign(LEFT);
  fill(0, 255, 0);
  if (myClient.available() > 0) { 
    String str = myClient.readString();
    messages.add(new message(str));
    myClient.clear();
  }

  for (int i=0; i<messages.size(); i++) {
    if (i > 0) {
      if (messages.get(i).text == null) {
        messages.remove(i);
      } else {
        messages.get(i).display(int(messages.get(i-1).y+messages.get(i-1).h+10));
        messagesHeight+=messages.get(i).h;
        messages.get(i).update();
      }
    } else {
      messages.get(i).display(30);
      messagesHeight+=messages.get(i).h;
      messages.get(i).update();
    }
  }

  if (messagesHeight+messages.size()*15 > height && messages.size() > 0) {
    //messagesHeight -= messages.get(0).h;
    messages.remove(0);
  }
  messagesHeight = 0;

  noStroke();
  if (mode.equals("dark")) {
    fill(81);
  } else if (mode.equals("light")) {
    fill(190);
  }
  rect(-10, height-30, width+10, 30);

  fill(0);
  text(str, 12, height-10);
  textAlign(CENTER);

  if (mode.equals("dark")) {
    fill(43, 124, 149);
  } else if (mode.equals("light")) {
    fill(43, 124, 199);
  }
  rect(-10, -10, width+20, 30);

  fill(255);
  textSize(12);
  text(typing, width/2, 15);
  textSize(11);
  textAlign(LEFT);
}

void keyPressed() {
  if (key == ENTER) {
    if (str.equals("start typing...")) {
    } else if (str.equals("|CLEAR")) {
      messages.clear();
      messages.add(new message("Messages cleared!|bgrgb(0,0,75)|weight(5)|countdown(500)"));
    } else if (str.equals("|RAINBOW")) {
      rainbowMode ^= true;
    } else if (str.contains("|CHANGENAME")) {
      String[] temp = {str.substring(0, str.indexOf("|"))};
      saveStrings("info.txt", temp);
      myClient.write(username+" has changed their name to "+temp[0]+"!|BGORANGE|weight(5)|NC");
      username = temp[0];
    } else if (str.contains("|MODE")) {
      String[] temp = {username, str.substring(0, str.indexOf("|"))};
      saveStrings("info.txt", temp);
      mode = temp[1];
    } else {
      if (str.equals("|VERSION")) {
        str = "Client Version: "+version+str;
      }
      myClient.write(username+": "+str);
    }

    str = "start typing...";
  } else if (keyCode == SHIFT||keyCode == CONTROL||keyCode == ALT) {
  } else if (key == BACKSPACE) {
    if (str.length()>1) {
      if (str == "start typing...") {
      } else {
        str = str.substring(0, str.length()-1);
      }
    } else if (str.length()==1) {
      str = "start typing...";
    } else {
    }
  } else {
    if (str == "start typing...") {
      str="";
    }
    str = str+key;
    if (frameCount - lastTypeFrame > typingFrameLimit) {
      myClient.write(username+"|TYPING");
      lastTypeFrame = frameCount;
      isTyping = true;
    }
  }
}

color[] rainbow = {color(255, 0, 0), color(255, 165, 0), color(255, 255, 0), color(0, 255, 0), color(0, 0, 255), color(128, 0, 128)};
color[] rainbowText = {color(255), color(255), color(0), color(255), color(255), color(255)};

class message { 
  float x, y; 
  float w = width-20;
  float h;
  color tc;
  color bg;
  int weight = 1;
  int lines;
  String text;
  int countdown = -1;


  message (String in) {
    if (mode.equals("dark")) {
      tc = color(0, 255, 0);
      bg = color(10);
    } else if (mode.equals("light")) {
      tc = color(101);
      bg = color(205);
    }


    if (in.contains("|CONFIRMONLINE")) {
      myClient.write(username + " joined the chat!|BGBLUE|weight(5)");
    }

    if (in.contains("|FLUSH")) {
      messages.clear();
      messages.add(new message("Messages flushed!|bgrgb(0,0,75)|weight(5)|countdown(500)"));
    } else if (in.contains("|TYPING")) {
      typing=in.substring(0, in.indexOf("|"))+" is typing...";
    } else if (in.contains("|NOTTYPING")) {
      typing="Hello, "+username+"!";
    } else { 
      if (in.contains(username+":")) {
        x = 0;
      } else {
        x = 20;
      }

      if (in.contains("|BGBLUE")) {
        bg=color(0, 0, 255);
        tc=color(255);
      } else if (in.contains("|BGRED")) {
        bg=color(255, 0, 0);
        tc=color(255);
      } else if (in.contains("|BGLIGHTBLUE")) {
        bg=color(117, 214, 255);
        tc=color(255);
      } else if (in.contains("|BGDARKBLUE")) {
        bg=color(4, 20, 76);
        tc=color(255);
      } else if (in.contains("|BGORANGE")) {
        bg=color(255, 165, 0);
        tc=color(255);
      } else if (in.contains("|BGPINK")) {
        bg=color(255, 20, 147);
        tc=color(255);
      } else if (in.contains("|BGMAROON")) {
        bg=color(125, 10, 45);
        tc=color(255);
      } else if (in.contains("|BGGREEN")) {
        bg=color(0, 255, 0);
        tc=color(255);
      } else if (in.contains("|BGDARKGREEN")) {
        bg=color(0, 100, 65);
        tc=color(255);
      } else if (in.contains("|BGYELLOW")) {
        bg=color(255, 255, 0);
        tc=color(0);
      } else if (in.contains("|BGPURPLE")) {
        bg=color(128, 0, 128);
        tc=color(255);
      } else if (in.contains("|bgrgb(")) {
        String storage = in;
        int r = int(in.substring(in.indexOf("(")+1, in.indexOf(",")));
        storage = in.substring(in.indexOf(",")+1);
        int g = int(storage.substring(0, storage.indexOf(",")));
        int b = int(storage.substring(storage.indexOf(",")+1, storage.indexOf(")")));
        bg = color(r, g, b);
        tc = color(255-(r+g+b)/3);
      }

      if (in.contains("|BLUE")) {
        tc=color(0, 0, 255);
      } else if (in.contains("|RED")) {
        tc=color(255, 0, 0);
      } else if (in.contains("|LIGHTBLUE")) {
        tc=color(117, 214, 255);
      } else if (in.contains("|DARKBLUE")) {
        tc=color(4, 20, 76);
      } else if (in.contains("|ORANGE")) {
        tc=color(255, 165, 0);
      } else if (in.contains("|PINK")) {
        tc=color(255, 20, 147);
      } else if (in.contains("|MAROON")) {
        tc=color(125, 10, 45);
      } else if (in.contains("|GREEN")) {
        tc=color(0, 255, 0);
      } else if (in.contains("|DARKGREEN")) {
        tc=color(0, 100, 65);
      } else if (in.contains("|YELLOW")) {
        tc=color(255, 255, 0);
      } else if (in.contains("|PURPLE")) {
        tc=color(128, 0, 128);
      } else if (in.contains("|rgb(")) {
        String storage = in;
        int r = int(in.substring(in.indexOf("(")+1, in.indexOf(",")));
        storage = in.substring(in.indexOf(",")+1);
        int g = int(storage.substring(0, storage.indexOf(",")));
        int b = int(storage.substring(storage.indexOf(",")+1, storage.indexOf(")")));
        tc = color(r, g, b);
      }

      if (in.contains("|weight(")) {
        String storage = in.substring(in.indexOf("|weight"));
        weight = int(storage.substring(storage.indexOf("(")+1, storage.indexOf(")")));
      }

      if (in.contains("|countdown(")) {
        String storage = in.substring(in.indexOf("|countdown"));
        countdown = int(storage.substring(storage.indexOf("(")+1, storage.indexOf(")")));
      }

      if (in.contains("|CAPS")) {
        text = in.substring(0, in.indexOf("|")).toUpperCase();
      } else if (in.contains("|")) {
        text = in.substring(0, in.indexOf("|"));
      } else {
        text=in;
      }

      if (rainbowMode == true) {
        bg = rainbow[rainbowStep];
        tc = rainbowText[rainbowStep];
        rainbowStep = (rainbowStep+1)%6;
      }
    }

    if (mode.equals("light")) {
      tc = color(10);
      bg = color(red(bg)+50, green(bg)+50, blue(bg)+50);
    }
  }

  void display(int pos) {
    if (text == null) {
    } else {
      w = width-20; 
      lines = int((text.length()*6.5)/w);
      h = 30+lines*20;
      y = pos;
      pushStyle();
      rectMode(CORNER);
      fill(bg);
      if (mode.equals("dark")) {
        stroke(red(bg)/2, green(bg)/2, blue(bg)/2);
      } else if (mode.equals("light")) {
        stroke(red(bg)/1.25, green(bg)/1.25, blue(bg)/1.25);
      }

      strokeWeight(weight);
      rect(x, y, w, h);

      fill(tc);
      text(text, x+8, y+10, w-20, h-10);
      popStyle();
    }
  }

  void update() {
    if (countdown > 0) {
      countdown--;
    }

    if (countdown == 0 && messages.size() > 1) {
      messages.remove(this);
    }
  }
}

public class DisposeHandler {
  DisposeHandler(PApplet pa) {
    pa.registerMethod("dispose", this);
  }

  public void dispose() {      
    myClient.write(username+"|DISCONNECT");
  }
}
