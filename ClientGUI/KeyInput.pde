void keyPressed() {
  if (key == ENTER) {
    if (str.equals("start typing...")) {
    } else if (str.equals("|CLEAR")) {
      messages.clear();
      messages.add(new message("Messages cleared!|bgrgb(0,0,75)|weight(5)|countdown(500)"));
    } else if (str.equals("|RAINBOW")) {
      rainbowMode ^= true;
    } else if (str.contains("|CHANGENAME")) {
      String[] temp = {str.substring(0, str.indexOf("|")), mode};
      saveStrings("info.txt", temp);
      myClient.write(username+" has changed their name to "+temp[0]+"!|BGORANGE|weight(5)|NC");
      username = temp[0];
    } else if (str.contains("|MODE")) {
      String[] temp = {username, str.substring(0, str.indexOf("|"))};
      saveStrings("info.txt", temp);
      mode = temp[1];
      setModeColor();
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
