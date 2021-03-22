void keyPressed() {
  if (key == ENTER) {
    if (str.equals("start typing...")) {
    } else if (str.equals("|CLEAR")) {
      messages.clear();
      messages.add(new message("Messages cleared!|bgrgb(0,0,75)|weight(5)|countdown(5)"));
    } else if (str.contains("|RAINBOW")) {
      rainbowMode ^= true;
      messages.add(new message("Rainbow mode " + (rainbowMode ? "" : "de") + "activated!|bgrgb(0,0,75)|weight(5)|countdown(500)"));
      if(!str.equals(""))  myClient.write(username + ": " + str);
    } else if (str.contains("|CHANGENAME")) {
      String[] temp = {str.substring(0, str.indexOf("|")), mode, server, str(port)};
      saveStrings("info.txt", temp);
      myClient.write(username + " has changed their name to " + temp[0] + "!|BGORANGE|weight(5)|NC");
      username = temp[0];
    } else if (str.contains("|CHANGESERVER")) {
      String[] temp = {username, mode, str.substring(0, str.indexOf("|")), str(port)};
      saveStrings("info.txt", temp);
      server = temp[2];
      myClient.write(username + "|DISCONNECT");
      myClient = new Client(this, server, port);
      myClient.write(username + " has connected!|BGBLUE|weight(5)");
      
    } else if (str.contains("|CHANGEPORT")) {
      String[] temp = {username, mode, server, str(int(str.substring(0, str.indexOf("|"))))};
      saveStrings("info.txt", temp);
      port = int(temp[3]);
      myClient.write(username + "|DISCONNECT");
      myClient = new Client(this, server, port);
      myClient.write(username + " has connected!|BGBLUE|weight(5)");
      
    } else if (str.contains("|EXIT")) {
      exit();
      
    } else if (str.contains("|MODE")) {
      String[] temp = {username, str.substring(0, str.indexOf("|")), server, str(port)};
      saveStrings("info.txt", temp);
      mode = temp[1];
      setModeColor();
    } else {
      if (str.equals("|VERSION")) {
        str = "Client Version: " + version + str;
      }
      myClient.write(username + ": " + str);
    }

    str = "start typing...";
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
    str = prune(keyCode) ? str + key : str;
    if (frameCount - lastTypeFrame > typingFrameLimit) {
      myClient.write(username + "|TYPING");
      lastTypeFrame = frameCount;
      isTyping = prune(keyCode);
    }
  }
}

boolean prune(int input) { // Add any other keys to allow through here
// Currently supported charecters:
// a-z, A-Z, 0-9, `, ~, !, @, #, $, %, ^, &, *, (, ), -, +, [, {, ], }, \, |, ;, :, ', ", ,, <, ., >, /, ?,
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
