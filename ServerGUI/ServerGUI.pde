/*
 
 BoopServer 1.1.1
 A server for booping.
 
 */

//*****************************//
//   IMPORTS, VARIABLES, ETC   //
//*****************************//

// IMPORTS
import processing.net.*;
import java.time.*;

// SERVER
Server myServer;
DisposeHandler dh;
int port = 10001;
char logMode = 'N'; /*
Method with which to save the debug log, these are the options:
'N' No logs are saved.
'G' Logs are grouped into folders by date and named by time.
'F' Logs are all in a single folder and are named with date & time,
'D' Logs are grouped into folder by month and named by day and time.
*/
String timeMode = "HWI!1-2-3-24!-:"; /*
What kind of timestamp to use.
The timestamp mode is made of three parts, the system, the format, and the delimiter.
It is written like this: "system!format!delimiter"

== Systems ==
First select a year system: 'S' or 'H', S is the Gregorian calender, H is the Holocene Epoch calender
Next select a divisional system: 'M' or 'W', M for month of the year & W for week of the year
Finally select a day system: 'D' or 'I', I for the day number, D for the name
In addition, you can append 'N' to change month numbers to names
Example: "SMI" = 2021/08/24

== Formats ==
"1-2-3-24" A Year-Month-Day format with 24 hour time
"3-2-3-24" A Day-Month-Year format with 24 hour time
"2-3-1-24" A Month-Day-Year format with 24 hour time
"1-2-3-12" A Year-Month-Day format with 12 hour time
"3-2-1-12" A Day-Month-Year format with 12 hour time
"2-3-1-12" A Month-Day-Year format with 12 hour time

== Delimiter Style ==
The delimiter is any two characters (Other than '!') next to eachother, the first will be used to delimit the date, the second; time.
Example: "SMI;1-2-3-24;/:" would produce "YEAR/MONTH/DAY | HOUR:MINUTE:SECOND"
*/

String msg;
String str = "start typing...";
boolean myServerRunning = true;

// VERSIONS
String version = "1.1.1";
String latestClient = "1.0.6";

// REGULATORS
int logLimit = 50; // Log every 50 messages
int messagesPos = 0;
int pingClock = 500; // Check if users are online every 5 seconds
boolean shutdown = false;
Boolean logging = true;

// LISTS
ArrayList<String> messages = new ArrayList<String>();
ArrayList<User> users = new ArrayList<User>();
ArrayList<Timer> timers = new ArrayList<Timer>();

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
  if (messages.size() - messagesPos > int((height - 66) / 12) && messages.size() > 0 && users.size() > 0) {
    messagesPos += 1;
  } else if (messages.size() - messagesPos > int((height - 32) / 12) && messages.size() > 0 && users.size() == 0) {
    messagesPos += 1;
  }

  // Update log every so often
  if (messages.size() - 50 >= logLimit) {
    logMessages();
  }

  //*****************************//
  // TIMER MANAGEMENT & RESPONSE //
  //*****************************//
  
  for(Timer temp : timers) {
    temp.onStep();
    if(temp.isComplete) {
      if(temp.owner.name == "SERVER") {
        if(shutdown == true) {
          shutdown = false;
          myServerRunning = false;
          timers.add(new Timer(300));
        }
        if(myServerRunning == false) {
          myServer.write("|KICKALL");
          stopServer();
        }
      } else {
        if(temp.broadcast) myServer.write("Timer has ended!|BGRED|weight(5)"); else temp.owner.myClient.write("Timer has ended!|BGRED|weight(5)");
        messages.add(getTimeStamp() + " | Timer has ended!|BGRED|weight(5)");
      }
      timers.remove(temp);
    }
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
    timers.add(new Timer(1));
    shutdown = true;
    messages.add(getTimeStamp() + " | SERVER-SIDE SHUTDOWN INITIATED");
    myServer.write("STOPPING SERVER (3 seconds) • COMMAND EXECUTED BY CONSOLE|BGRED|weight(5)|NOTIFY");
  } else if (key == ENTER) { // CONSOLE SENDING MESSAGE
    if (str.equals("start typing...")) {
    } else if (str.contains("|KICK")) {
      String person = str.substring(0, str.indexOf("|"));
      myServer.write("[SERVER] "+person+" has been kicked by Console!|BGRED|weight(5)|NOTIFY");
      messages.add(getTimeStamp() + " | [SERVER] "+person+" has been kicked by Console!|BGRED|weight(5)|NOTIFY");

      for (int i=0; i<users.size(); i++) {
        if (users.get(i).getName().equals(person)) {
          users.remove(i);
        }
      }
    } else { // GENERAL MESSAGES
      myServer.write("[SERVER] "+str+"|BGPINK|weight(5)");
      messages.add(getTimeStamp() + " | [SERVER] "+str+"|BGPINK|weight(5)");
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
    str = prune(keyCode) ? str+key : str;
  }
}

boolean prune(int input) {
  boolean output = false;
  output = (input == 32) ? true : output;
  output = (input >= 44 && input <= 57) ? true : output;
  output = (input == 59) ? true : output;
  output = (input == 61) ? true : output;
  output = (input >= 65 && input <= 93) ? true : output;
  output = (input == 192) ? true : output;
  output = (input == 222) ? true : output;
  return output;
}

void mouseClicked() {
  if (mouseX >= 10 && mouseX <= 15 && mouseY >= 5 && mouseY <= 10) { // SHUTDOWN
    timers.add(new Timer(1));
    shutdown = true;
    messages.add(getTimeStamp() + " | SERVER-SIDE SHUTDOWN INITIATED");
    myServer.write("STOPPING SERVER (3 seconds) • COMMAND EXECUTED BY CONSOLE|BGRED|weight(5)|NOTIFY");
  } else if (mouseX >= 27 && mouseX <= 32 && mouseY >= 5 && mouseY <= 10) { // FLUSH
    messages.add(getTimeStamp() + " | SERVER-SIDE FLUSH INITIATED");
    myServer.write("|FLUSH");
  } else if (mouseX >= 44 && mouseX <= 49 && mouseY >= 5 && mouseY <= 10) { // PING
    messages.add(getTimeStamp() + " | SERVER-SIDE PING INITIATED");
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
  text("Shutting down in a few seconds...", 0, 40, width, 40);
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
    messages.add(getTimeStamp() + " | "+in);
    myServer.write(in);
  } else if (in.contains("|ONLINE")) { // LIST OF ONLINE USERS
    thisClient.write(online(thisClient));
  } else if (in.contains("|DISCONNECT")) { // DISCONNECT EVENT (REPLACE LATER)
    myServer.write(in.substring(0, in.indexOf("|"))+" has disconnected!|BGRED|weight(5)");
    messages.add(getTimeStamp() + " | "+in.substring(0, in.indexOf("|"))+" has disconnected!|BGRED|weight(5)");
    for (int i=0; i<users.size(); i++) {
      if (users.get(i).getClient().equals(thisClient)) { // Match who disconnected to remove them from online list
        pingClock = 500;
        users.remove(i);
      }
    }
  } else if (in.contains("|STOP")) { // INITIATE SHUTDOWN
    timers.add(new Timer(200));
    shutdown = true;
    messages.add(getTimeStamp() + " | STOPPING SERVER (2 seconds) • COMMAND EXECUTED BY IP: "+thisClient.ip()+"|BGRED|weight(5)");
    myServer.write("STOPPING SERVER (2 seconds) • COMMAND EXECUTED BY IP: "+thisClient.ip()+"|BGRED|weight(5)");
  } else if (in.contains("|VERSION")) {
    messages.add(getTimeStamp() + " | "+in);
    thisClient.write(in.substring(in.indexOf(":") + 2, in.indexOf("|")) + " • Server Version: " + version + " • Latest Client: " + latestClient + "|BGBLUE|weight(5)");
  } else if (in.contains("|COMMANDS")) {
    messages.add(getTimeStamp() + " | "+in);
    thisClient.write("Commands must be preceeded by pipe ( | ). Commands: bgrgb(r,g,b)  rgb(r,g,b)  VERSION  STOP  MATH  NC  timer(ms)  FLUSH  weight(pixels)  countdown(ms)  UC  LC|BGRGB(0,0,0)");
  } else if (in.contains("|msg(")){
    messages.add(year() + " - " + month() + " - "+ day()+" | "+hour()+":"+minute()+":" + second() + " | " + in);
    String target = in.substring(in.indexOf("(")+1,in.indexOf(")"));
    String from = in.substring(0,in.indexOf(":"));
    String msg = in.substring(in.indexOf(":")+1, in.indexOf("|"));
    for (User targetClient : users){
      if (target.equals(targetClient.getName())){
        targetClient.getClient().write("[" + from + " -> You]" + msg + "|bgrgb(50,50,50)|weight(5)");
        thisClient.write("[You -> " + target + "]" + msg + "|bgrgb(50,50,50)|weight(5)");
      }
    }
  } else if (in.contains("|timer(")) {
    messages.add(getTimeStamp() + " | "+in);
    User owner = null;
    for(User temp : users) {
      if(temp.name == in.substring(0, in.indexOf(":"))) owner = temp;
    }
    if(owner == null) messages.add(getTimeStamp() + " | <ERROR> Timer had invalid owner, canceling timer creation!"); else {
      timers.add(new Timer(owner, float(in.substring(in.indexOf("(")+1, in.indexOf(","))) * 100, boolean(in.substring(in.indexOf(",") + 1, in.indexOf(")")))));
      if(boolean(in.substring(in.indexOf(",") + 1, in.indexOf(")")))) myServer.write(in.substring(0, in.indexOf(":")) + " has started a timer for " + float(in.substring(in.indexOf("(")+1, in.indexOf(","))) + " seconds!|BGORANGE|weight(5)");
    }
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
    messages.add(getTimeStamp() + " | "+in);
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
//      CLASS DEFINITIONS      //
//*****************************//

public class User {
  Client myClient;
  String name;

  User(Client c, String id) {
    myClient = c;
    name = id;
  }
  
  User(String id) {
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
      messages.add(getTimeStamp() + " | Detected disconnect: "+name+" has lost connection");
      myServer.write(name+" has lost connection|BGRED|weight(5)");
      users.remove(this); // Remove user is not found to be active
    }
  }
}

class Timer {
  boolean isComplete;
  boolean broadcast;
  float timeLeft;
  User owner;
  
  Timer(User newOwner, float time, boolean _broadcast) {
    isComplete = false;
    timeLeft = time;
    owner = newOwner;
    broadcast = _broadcast;
  }
  
  Timer(float time) {
    isComplete = false;
    timeLeft = time;
    owner = new User("SERVER");
    broadcast = false;
  }
  
  void onStep() {
    if(timeLeft < 1) {
      timeLeft = 0;
      isComplete = true;
    } else {
      timeLeft--;
    }
  }
}

//*****************************//
//      UTILITY FUNCTIONS      //
//*****************************//

String getTimeStamp(String timeMode) {
  LocalDateTime now = LocalDateTime.now();
  String output = "";
  String[] parts = split(timeMode, '!');
  String[] align = split(parts[1], '-');
  char delimDate = parts[2].charAt(0);
  char delimTime = parts[2].charAt(1);
  String[] timeParts = new String[3];
  if(parts[0].contains("H")) timeParts[0] = str(now.getYear() + 10000);
  if(parts[0].contains("S")) timeParts[0] = str(now.getYear());
  if(parts[0].contains("W")) timeParts[1] = nf(getWeekOfYear(now), 2);
  if(parts[0].contains("M")) timeParts[1] = nf(now.getMonthValue(), 2);
  if(parts[0].contains("M") && parts[0].contains("N")) timeParts[1] = now.getMonth().name();
  if(parts[0].contains("W") && parts[0].contains("I")) timeParts[2] = nf(now.getDayOfWeek().getValue(), 2);
  if(parts[0].contains("M") && parts[0].contains("I")) timeParts[2] = nf(now.getDayOfMonth(), 2);
  if(parts[0].contains("D")) timeParts[2] = now.getDayOfWeek().name();
  
  // Sort the timeParts into order
  String[] timePartsHold = timeParts;
  timeParts[0] = timePartsHold[int(align[0]) - 1];
  timeParts[1] = timePartsHold[int(align[1]) - 1];
  timeParts[2] = timePartsHold[int(align[2]) - 1];
  String anteOrPost = (now.getHour() > 12) ? "PM" : "AM" ;
  
  println(align[3].length());
  // Assemble the timestamp
  output += timeParts[0];
  output += delimDate;
  output += timeParts[1];
  output += delimDate;
  output += timeParts[2];
  output += " | ";
  if(align[3].equals("12")) output += nf((now.getHour() % 12), 2); else output += nf(now.getHour(), 2);
  output += delimTime;
  output += nf(now.getMinute(), 2);
  output += delimTime;
  output += nf(now.getSecond(), 2);
  if(align[3].equals("12")) output += ' ' + anteOrPost;
  return output;
}

int getWeekOfYear(LocalDateTime time) {
  LocalDate begin = Year.of(time.getYear()).atMonth(1).atDay(1);
  int offset = begin.getDayOfWeek().getValue() - 1;
  return ceil((time.getDayOfYear() + offset)/7);
}

//*****************************//
//       MESSAGE LOGGING       //
//*****************************//

void logMessages() {
  String[] list = new String[messages.size()];
  for (int i = messagesPos*19; i < messages.size(); i++) {
    list[i] = messages.get(i);
  }
  switch(logMode) {
    case 'N' :
      // No logs, LEAVE EMPTY
    break;
    case 'F' :
      saveStrings("logs/" + year() + "." + month() + "." + day() + "." + hour() + "." + minute() + "." + second() + ".txt", list);
    break;
    case 'D' :
      saveStrings("logs/"+year()+"/"+month()+"/"+day()+"."+hour()+"."+minute()+"."+second()+".txt", list);
    break;
    default :
      saveStrings("logs/"+year()+"/"+month()+"/"+day()+"/"+hour()+"."+minute()+"."+second()+".txt", list);
    break;
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
