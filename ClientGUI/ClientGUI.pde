/*
 
 BoopClient 1.0.7
 A chat client for booping.
 
 Changelog: 
 - Added support for custom servers and ports via the info.txt document
 - Key input is now restricted to eliminate junk charecters (i.e. Shift or Caps Lock getting typed in msgs)
 - Added CHANGESERVER & CHANGEPORT commands
 - Added EXIT command
 - Switched message directionality to match the majority of messaging programs
 - Added colors BLACK, GREY, & WHITE
 - Moved colors to an internal IntDict to allow quick modification and simple assignment (Just 2 for loops instead of ~24 if-else statments)
 - Added a trim call to allow formatting of the rgb command like this: "Hello World!|rgb(255, 30, 240)"
 - Included both 64-bit & 34-bit program binaries
 - Improved code readability by adding some extra comments and adding spacing arround operators where applicable
 - Added display in top corner of what server and port is being connected to
 - Updated rainbow to make more sense
 - Changed countdown to use seconds
 
 */

//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import processing.net.*;

// NETWORK
Client myClient;
//Server localServer;
DisposeHandler dh;
int port = 10001;

// PLACEHOLDERS
String str = "start typing...";
String typing = "Loading BoopClient...";
String inString ="";

// REGULATORS
int messagesHeight = 0;
int lastTypeFrame= 0;
int typingFrameLimit = 250;
int rainbowStep = 0;
int largeWindowAdjust = 0;
Boolean isTyping = false;

// USER SETTINGS
String version = "1.0.7"; // IF YOU UPDATE THIS, UPDATE LATESTCLIENT ON SERVER AS WELL
String username;
String mode;
String server;
boolean rainbowMode = false;
color modeColor;

// LISTS
ArrayList<message> messages = new ArrayList<message>();
ArrayList<String> usersOnline = new ArrayList<String>();
IntDict colorsDict;

//*****************************//
//       SETUP  FUNCTION       //
//*****************************//

void setup() {
  size(300, 500);
  surface.setResizable(true);
  dh = new DisposeHandler(this);

  // LOAD SETTINGS
  String[] info = new String[4];
  if (loadStrings("info.txt") == null) {
    info[0] = "SetYourNameBro";
    info[1] = "rgb(0,30,60)";
    info[2] = "54.208.53.64";
    info[3] = "10001";
    saveStrings("info.txt", info);
  } else {
    info = loadStrings("info.txt");
  }
  
  try {
    username = info[0];
    mode = info[1];
    server = info[2];
    port = int(info[3]);
  } catch(ArrayIndexOutOfBoundsException e) {
    username = (info[0] != null) ? info[0] : "InfoLoadError";
    mode = (info[1] != null) ? info[1] : "rgb(0,30,60)";
    server = (info[2] != null) ? info[2] : "54.208.53.64";
    port = int((info[3] != null) ? info[3] : "10001");
    saveStrings("info.txt", info);
  }
  
  colorsDict = new IntDict();
  colorsDict.set("RED", color(#FF0000));
  colorsDict.set("ORANGE", color(#FFA500));
  colorsDict.set("YELLOW", color(#FFFF00));
  colorsDict.set("GREEN", color(#00FF00));
  colorsDict.set("DARKGREEN", color(#006441));
  colorsDict.set("BLUE", color(#0000FF));
  colorsDict.set("LIGHTBLUE", color(#75D6FF));
  colorsDict.set("DARKBLUE", color(#04144C));
  colorsDict.set("MAROON", color(#7D0A2D));
  colorsDict.set("PINK", color(#FF1493));
  colorsDict.set("PURPLE", color(#800080));
  colorsDict.set("BLACK", color(#000000));
  colorsDict.set("GREY", color(#B4B4B4));
  colorsDict.set("WHITE", color(#FFFFFF));
  setModeColor();
  
  //myClient = new Client(this, "54.208.53.64", port); // CONNECT TO SERVER & SEND INITIAL MESSAGE
  //myClient = new Client(this, "localhost", port); // FOR TESTNG PURPOSES ONLY
  myClient = new Client(this, server, port);
  myClient.write(username + " has connected!|BGBLUE|weight(5)");
  typing="Hello, " + username + "!"; // GREET USER
}



//*****************************//
//        DRAW FUNCTION        //
//*****************************//

void draw() {
  modeBG();

  if (frameCount - lastTypeFrame > typingFrameLimit && isTyping == true) {
    myClient.write(username + "|NOTTYPING");
    isTyping = false;
  }

  textAlign(LEFT);
  fill(0, 255, 0);
  if (myClient.available() > 0) { // Get messages, store in ArrayList
    String str = myClient.readString();
    //println(str);
    messages.add(new message(str));
    myClient.clear();
  }

  for (int i=0; i<messages.size(); i++) { // Message Positioning
    if (i > 0) {
      if (messages.get(i).text == null) {
        messages.remove(i);
      } else {
        messages.get(i).display(int(messages.get(i-1).y + messages.get(i-1).h + 10));
        messagesHeight += messages.get(i).h;
        messages.get(i).update();
      }
    } else {
      messages.get(i).display(30);
      messagesHeight += messages.get(i).h;
      messages.get(i).update();
    }
  }

  if (messagesHeight + messages.size()*15 > height && messages.size() > 0) {
    //messagesHeight -= messages.get(0).h;
    messages.remove(0);
  }
  messagesHeight = 0;

  noStroke(); // Extended GUI Control
  if (width > 400) {
    largeModeDisplay();
  } else {
    largeWindowAdjust = 0;
  }
  noStroke();

  if (mode.equals("dark")) { // Typefield Background
    fill(81);
  } else if (mode.equals("light")) {
    fill(190);
  } else {
    fill(red(modeColor), green(modeColor), blue(modeColor));
  }
  rect(-10, height-30, width + 10, 30);

  if (mode.equals("dark") || mode.equals("light")) { // Typefield Text
    fill(0);
  } else {
    if ((red(modeColor) + green(modeColor) + blue(modeColor))/3 < 100) {
      fill(255);
    } else {
      fill(0);
    }
  }
  if (textWidth(str)<width-20) {
    text(str, 12, height-10);
  } else {
    text(str, 12-textWidth(str) + width-20, height-10);
  }
  textAlign(CENTER);

  if (mode.equals("dark")) { // Notification Bar Background
    fill(43, 124, 149);
  } else if (mode.equals("light")) {
    fill(43, 124, 199);
  } else {
    if (red(modeColor) > 0 && green(modeColor) > 0 && blue(modeColor) > 0) {
      fill(red(modeColor)*1.2, green(modeColor)*1.2, blue(modeColor)*1.2);
    } else if (red(modeColor) == 0 && green(modeColor) == 0 && blue(modeColor) == 0) {
      fill(red(modeColor), green(modeColor), blue(modeColor));
    } else if (red(modeColor) > 0) {
      fill(red(modeColor) + 50, 43, 124);
    } else if (green(modeColor) > 0) {
      fill(43, green(modeColor) + 50, 124);
    } else if (blue(modeColor) > 0) {
      fill(124, 43, blue(modeColor) + 50);
    }
  }
  rect(-10, -10, width + 20, 30);

  fill(255); // Notification Bar Text
  if (mode.equals("dark") || mode.equals("light") || (red(modeColor) + green(modeColor) + blue(modeColor))/3 < 100) {
    fill(255);
  } else {
    fill(10);
  }
  textSize(12);
  text(typing, width/2, 15);
  textAlign(LEFT);
  if(textWidth(server + ":" + str(port)) + 18 <= width/2 - textWidth(typing)/2) text(server + ":" + str(port), 5, 15);
  textSize(11);
}



// Disconnect Event
public class DisposeHandler {
  DisposeHandler(PApplet pa) {
    pa.registerMethod("dispose", this);
  }

  public void dispose() {      
    myClient.write(username + "|DISCONNECT");
  }
}
