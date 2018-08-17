/*
 
 BoopServer 1.1.1
 A server for booping.
 
 */

//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import processing.net.*;

// SERVER
Server myServer;
DisposeHandler dh;
int port = 10001;
String msg;
String str = "start typing...";
boolean myServerRunning = true;

// VERSIONS
String version = "1.1.1";
String latestClient = "1.0.6";

// REGULATORS
float timer = 1; // Make multiple timers a possibility in future by using array
int logLimit = 50; // Log every 50 messages
int messagesPos = 0;
int pingClock = 500; // Check if users are online every 5 seconds
boolean shutdown = false;
Boolean logging = true;
Boolean userTimer = false; // Eventually turn timer system into object-based thing. Store usernames & refence who started what timer, etc. Also personal timers.

// LISTS
ArrayList<String> messages = new ArrayList<String>();
ArrayList<User> users = new ArrayList<User>();



//*****************************//
//       SETUP  FUNCTION       //
//*****************************//

void setup() {
  size(500, 300);

  surface.setResizable(true);
  myServer = new Server(this, port);
  dh = new DisposeHandler(this);

  startupUI();
}



//*****************************//
//        DRAW FUNCTION        //
//*****************************//

void draw() {
  frameRate(100);
  basicUI();

  if (myServerRunning == true) {
    Client sender = myServer.available();
    if (sender != null && sender.available() > 0) {
      msg = sender.readString();
      matchTerms(msg, sender);
    }

    messagesUI();
  } else {
    stopServerUI();
  }

  // Change amount of messages displayed based on window size
  if (messages.size()-messagesPos > int((height- 66)/12) && messages.size() > 0 && users.size() > 0) {
    messagesPos += 1;
  } else if (messages.size()-messagesPos > int((height-32)/12) && messages.size() > 0 && users.size() == 0) {
    messagesPos += 1;
  }

  // Update log every so often
  if (messages.size()-50 >= logLimit) {
    logMessages();
  }

  //*****************************//
  // TIMER MANAGEMENT & RESPONSE //
  //*****************************//

  if (timer > 0) { // Decrease timer with each tick
    timer--;
  } else if (timer == 0 && shutdown == true) { // Begin shutdown process
    shutdown = false;
    myServerRunning = false;
    timer = 300;
  } else if (timer == 0 && myServerRunning == false) { // Stop server
    stopServer();
  } else if (timer == 0 && userTimer == true) { // Announce end of timer started by user
    userTimer = false;
    myServer.write("Timer has ended!|BGRED|weight(5)");
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | Timer has ended!|BGRED|weight(5)");
  }

  if (pingClock > 0) { // Decrease pingClock with each tick
    pingClock--;
  } else if (pingClock == 0) {
    for (int i=0; i<users.size(); i++) {
      users.get(i).verifyOnline(); // Find if a user is online
    }
    pingClock = 500; // Start process over again
  }
} // END OF DRAW FUNCTION



//********************************//
// MOUSE AND KEYBOARD INTERACTION //
//********************************//

void keyPressed() {
  if (key=='~') { // SHUTDOWN
    shutdown = true;
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | SERVER-SIDE SHUTDOWN INITIATED");
    myServer.write("STOPPING SERVER (3 seconds) • COMMAND EXECUTED BY CONSOLE|BGRED|weight(5)");
  } else if (key == ENTER) { // CONSOLE SENDING MESSAGE
    if (str.equals("start typing...")) {
    } else if (str.contains("|KICK")) {
      String person = str.substring(0, str.indexOf("|"));
      myServer.write("[SERVER] "+person+" has been kicked by Console!|BGRED|weight(5)");
      messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | [SERVER] "+person+" has been kicked by Console!|BGRED|weight(5)");

      for (int i=0; i<users.size(); i++) {
        if (users.get(i).getName().equals(person)) {
          users.remove(i);
        }
      }
    } else { // GENERAL MESSAGES
      myServer.write("[SERVER] "+str+"|BGPINK|weight(5)");
      messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | [SERVER] "+str+"|BGPINK|weight(5)");
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
    }
  } else {
    if (str == "start typing...") {
      str="";
    }
    str = str+key;
  }
}

void mouseClicked() {
  if (mouseX >= 10 && mouseX <= 15 && mouseY >= 5 && mouseY <= 10) { // SHUTDOWN
    shutdown = true;
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | SERVER-SIDE SHUTDOWN INITIATED");
    myServer.write("STOPPING SERVER (3 seconds) • COMMAND EXECUTED BY CONSOLE|BGRED|weight(5)");
  } else if (mouseX >= 27 && mouseX <= 32 && mouseY >= 5 && mouseY <= 10) { // FLUSH
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | SERVER-SIDE FLUSH INITIATED");
    myServer.write("|FLUSH");
  } else if (mouseX >= 44 && mouseX <= 49 && mouseY >= 5 && mouseY <= 10) { // PING
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | SERVER-SIDE PING INITIATED");
    for (int i=0; i<users.size(); i++) {
      users.get(i).verifyOnline();
    }
    pingClock = 500;
  }
}



//*****************************//
//       USER  INTERFACE       //
//*****************************//

void startupUI() {
  pushStyle();
  background(0, 100, 155);
  rectMode(CORNERS);

  fill(200);
  stroke(255);
  strokeWeight(10);
  rect(width/2-25, height/2-40, width/2+25, height/2+40);

  fill(40);
  stroke(95);
  strokeWeight(5);
  rect(width/2-150, height/2-25, width/2-100, height/2+25);
  rect(width/2+150, height/2-25, width/2+100, height/2+25);
  popStyle();
}

void basicUI() {
  pushStyle();
  background(21);
  fill(255);
  textAlign(CENTER);

  noStroke();
  if (mouseX >= 10 && mouseX <= 15 && mouseY >= 5 && mouseY <= 10) {
    fill(100, 0, 0);
  } else {
    fill(255, 0, 0);
  }
  rect(10, 5, 5, 5); // S (Stop server)

  if (mouseX >= 27 && mouseX <= 32 && mouseY >= 5 && mouseY <= 10) {
    fill(0, 100, 0);
  } else {
    fill(0, 255, 0);
  }
  rect(27, 5, 5, 5); // F (Flush chat)

  if (mouseX >= 44 && mouseX <= 49 && mouseY >= 5 && mouseY <= 10) {
    fill(0, 0, 100);
  } else {
    fill(0, 0, 255);
  }
  rect(44, 5, 5, 5); // P (Ping all users)

  textSize(10);
  fill(255);
  text("s    f    p", 0, 10, 60, 15); // Text for buttons s=Stop, f=Flush, p=Ping
  textSize(12);

  if (users.size() > 0) {
    text("BoopServer Version "+version, 0, 10, .8*width, 15);

    stroke(155);
    line(.03*width, 25, .77*width, 25); // Underline title text

    pushMatrix();
    translate(-5, 5);
    noStroke();
    fill(255, 175);
    rect(.8*width, 0, .2*width, 27+users.size()*15, 5); // Online list

    fill(10);
    text("Users Online", .9*width, 15);

    stroke(100);
    strokeWeight(1);
    line(.82*width, 19, .98*width, 19); // Underline Users Online text

    textAlign(LEFT);

    int pos = 0;
    for (User u : users) {
      text(u.getName(), .82*width, 35+pos); // Display usernames
      pos += 15;
    }
    popMatrix();

    noStroke();
    fill(81);
    rect(0, height-30, width, 30); // Text area for console messages

    fill(255);
    text(str, 12, height-10); // Console typing
  } else {
    text("BoopServer Version "+version, 0, 15, width, 15);
  }
  popStyle();
}

void messagesUI() {
  for (int i=messagesPos; i<messages.size(); i++) {
    text(messages.get(i), 10, (i-messagesPos)*12+44);
  }
}

void stopServerUI() {
  pushStyle();
  fill(200, 0, 0, 100);
  stroke(20);
  strokeWeight(15);
  rect(0, 0, width, height);

  fill(255);
  textAlign(CENTER);
  textSize(20);
  text("Shutting down in "+(1+round(timer)/100)+" seconds...", 0, 40, width, 40);
  popStyle();
}



//*****************************//
//        TEXT ANALYSIS        //
//*****************************//

int findFirstNum(String input) {
  int location = -1;
  char[] possible = {'.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};
  for (int i=0; i<input.length(); i++) {
    for (int o=0; o<possible.length; o++) {
      if (input.charAt(i) == (possible[o])) {
        location = i;
        break;
      }
    }
    if (location != -1) {
      break;
    }
  }
  return location;
}

void matchTerms(String in, Client thisClient) { // Eventually move some responses over to an array, also make one function to add text to messages and write to server
  if (in.contains("|TYPING")||in.contains("|NOTTYPING")) {
    myServer.write(in);
  } else if (in.contains("connected!|")) { // LOGIN
    users.add(new User(thisClient, in.substring(0, in.indexOf(" has")))); // Add new user with client object and name
    thisClient.write(online(thisClient)+"|CONFIRMONLINE");
  } else if (in.contains("|NC")) { // NAMECHANGE
    for (int i=0; i<users.size(); i++) {
      if (users.get(i).getClient().equals(thisClient)) {
        users.get(i).setName(in.substring(in.indexOf("to ")+3, in.indexOf("!"))); // Alter user's stored name
      }
    }
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in);
    myServer.write(in);
  } else if (in.contains("|ONLINE")) { // LIST OF ONLINE USERS
    thisClient.write(online(thisClient));
  } else if (in.contains("|DISCONNECT")) { // DISCONNECT EVENT (REPLACE LATER)
    myServer.write(in.substring(0, in.indexOf("|"))+" has disconnected!|BGRED|weight(5)");
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in.substring(0, in.indexOf("|"))+" has disconnected!|BGRED|weight(5)");
    for (int i=0; i<users.size(); i++) {
      if (users.get(i).getClient().equals(thisClient)) { // Match who disconnected to remove them from online list
        pingClock = 500;
        users.remove(i);
      }
    }
  } else if (in.contains("|STOP")) { // INITIATE SHUTDOWN
    timer = 200;
    shutdown = true;
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | STOPPING SERVER (2 seconds) • COMMAND EXECUTED BY IP: "+thisClient.ip()+"|BGRED|weight(5)");
    myServer.write("STOPPING SERVER (2 seconds) • COMMAND EXECUTED BY IP: "+thisClient.ip()+"|BGRED|weight(5)");
  } else if (in.contains("|VERSION")) {
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in);
    thisClient.write(in.substring(in.indexOf(":")+2, in.indexOf("|"))+" • Server Version: "+version+" • Latest Client: "+latestClient+"|BGBLUE|weight(5)");
  } else if (in.contains("|COMMANDS")) {
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in);
    thisClient.write("Commands must be preceeded by shift+\\. Commands: bgrgb(r,g,b)  rgb(r,g,b)  VERSION  STOP  MATH  NC  timer(ms)  FLUSH  weight(pixels)  countdown(ms)  UC  LC|BGRGB(0,0,0)");
  }else if (in.contains("|msg(")){
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in);
    String target = in.substring(in.indexOf("(")+1,in.indexOf(")"));
    String from = in.substring(0,in.indexOf(":"));
    String msg = in.substring(in.indexOf(":")+1, in.indexOf("|"));
    for (User targetClient:users){
      if (target.equals(targetClient.getName())){
        targetClient.getClient().write("["+from+" -> You]"+msg+"|bgrgb(50,50,50)|weight(5)");
      }
    }
    
  }else if (in.contains("|timer(")) {
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in);
    myServer.write(in.substring(0, in.indexOf(":"))+" has started a timer for "+round(int(in.substring(in.indexOf("(")+1, in.indexOf(")")))/frameRate)+" seconds!|BGORANGE|weight(5)");
    userTimer = true;
    timer = int(in.substring(in.indexOf("(")+1, in.indexOf(")")));
  } else if (in.contains("|MATH")) {
    try {
      if (in.contains("*") || in.contains("times") || in.contains("multiply") || in.contains("product") || in.contains("x") || in.contains("(")) {
        String math1 = in.replace(" ", "").replace("times", "*").replace("multiply", "*").replace("product", "*").replace("x", "*").replace("(", "*").replace(")", "").substring(in.indexOf(":")+1);
        int n = math1.indexOf("*");
        int firstDigit = findFirstNum(math1);
        String num1 = math1.substring(firstDigit, n);
        String num2 = math1.substring(n+1, math1.indexOf("|"));
        thisClient.write("Received: "+in.substring(in.indexOf(":")+1, in.indexOf("|"))+"••• The answer is: "+parseFloat(num1)+" * "+parseFloat(num2)+" = "+(parseFloat(num1)*parseInt(num2))+"|BGDARKGREEN|weight(5)");
      }

      if (in.contains("/") || in.contains("divided by") || in.contains("divide") || in.contains("quotient") || in.contains("\\")) {
        String math1 = in.replace(" ", "").replace("divided by", "/").replace("divide", "/").replace("quotient", "/").replace("\\", "/").substring(in.indexOf(":")+1);
        int n = math1.indexOf("/");
        int firstDigit = findFirstNum(math1);
        String num1 = math1.substring(firstDigit, n);
        String num2 = math1.substring(n+1, math1.indexOf("|"));
        thisClient.write("Received: "+in.substring(in.indexOf(":")+1, in.indexOf("|"))+"••• The answer is: "+parseFloat(num1)+" / "+parseFloat(num2)+" = "+(parseFloat(num1)/parseInt(num2))+"|BGDARKGREEN|weight(5)");
      }

      if (in.contains("+") || in.contains("plus") || in.contains("add") || in.contains("sum")) {
        String math1 = in.replace(" ", "").replace("plus", "+").replace("add", "+").replace("sum", "+").substring(in.indexOf(":")+1);
        int n = math1.indexOf("+");
        int firstDigit = findFirstNum(math1);
        String num1 = math1.substring(firstDigit, n);
        String num2 = math1.substring(n+1, math1.indexOf("|"));
        thisClient.write("Received: "+in.substring(in.indexOf(":")+1, in.indexOf("|"))+"••• The answer is: "+parseFloat(num1)+" + "+parseFloat(num2)+" = "+(parseFloat(num1)+parseInt(num2))+"|BGDARKGREEN|weight(5)");
      }

      if (in.contains("-") || in.contains("minus") || in.contains("subtract")) {
        String math1 = in.replace(" ", "").replace("minus", "-").replace("subtract", "-").substring(in.indexOf(":")+1);
        int n = math1.indexOf("-");
        int firstDigit = findFirstNum(math1);
        String num1 = math1.substring(firstDigit, n);
        String num2 = math1.substring(n+1, math1.indexOf("|"));
        println(num1+" "+num2);
        thisClient.write("Received: "+in.substring(in.indexOf(":")+1, in.indexOf("|"))+"••• The answer is: "+parseFloat(num1)+" - "+parseFloat(num2)+" = "+(parseFloat(num1)-parseInt(num2))+"|BGDARKGREEN|weight(5)");
      }
    } 
    catch (StringIndexOutOfBoundsException e) { 
      System.out.println("Met a math-related error!");
      thisClient.write("Something went wrong. Please try again with different formatting.|BGRED|weight(5)");
    }
  } else if (in.contains(":") || in.contains("joined")) {
    messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | "+in);
    myServer.write(in);
  }
}

String online(Client c) {
  String usernames = "";
  for (User u : users) {

    String currentName;
    if (u.getClient().equals(c)) {
      currentName = "You ("+u.getName()+")";
    } else {
      currentName = u.getName();
    }

    if (usernames == "") {
      usernames = currentName;
    } else {
      usernames += ", "+currentName;
    }
  }
  return "Users Online: "+usernames+"|BGMAROON|weight(5)";
}



//*****************************//
//       USER DEFINITION       //
//*****************************//

public class User {
  Client myClient;
  String name;

  User(Client c, String id) {
    myClient = c;
    name = id;
  }

  String getName() {
    return name;
  }

  void setName(String str) {
    name = str;
  }

  Client getClient() {
    return myClient;
  }

  void verifyOnline() {
    if (!myClient.active()) {
      messages.add(month()+"/"+day()+"/"+year()+" | "+hour()+":"+minute()+":"+second()+" | Detected disconnect: "+name+" has lost connection");
      myServer.write(name+" has lost connection|BGRED|weight(5)");
      users.remove(this); // Remove user is not found to be active
    }
  }
}



//*****************************//
//       MESSAGE LOGGING       //
//*****************************//

void logMessages() {
  if (logging == true) { // Implement way to disable logging later
    String[] list = new String[messages.size()];
    for (int i=messagesPos*19; i<messages.size(); i++) {
      list[i] = messages.get(i);
    }

    saveStrings("logs/"+year()+"/"+month()+"/"+day()+"/"+hour()+"."+minute()+"."+second()+".txt", list);
  }
} 



//*****************************//
//      SHUTDOWN  SCRIPTS      //
//*****************************//

void stopServer() {
  logMessages();
  myServer.stop();
  exit(); // Close window on shutdown
}

public class DisposeHandler { // Ensures messages logged in ANY type of closing event
  DisposeHandler(PApplet pa) {
    pa.registerMethod("dispose", this);
  }

  public void dispose() {      
    logMessages();
  }
}
