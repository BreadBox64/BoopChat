color[] rainbow = {#FF0000, #FF8000, #FEFF00, #00FF00, #00FF81, #00FDFF, #007DFF, #0300FF, #8300FF, #FF00FB, #FF007C};
boolean[] rainbowText = {true, true, false, false, false, false, false, true, true, true, false, true};

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
    } else {
      if ((red(modeColor) + green(modeColor) + blue(modeColor))/3 < 100) {
        tc = color(255);
      } else {
        tc = color(0);
      }
      bg = modeColor;
    }

    // Connection Commands
    
    if (in.contains("|CONFIRMONLINE")) {
      myClient.write(username + " is in the chat!|BGBLUE|weight(5)|official");
    }

    if (in.length() >= 15 && in.substring(0, 14).equals("Users Online: ")) {
      usersOnline.clear();
      String list = in.substring(14);
      list = list.substring(0, list.indexOf("|")).replaceAll(" ","");

      while (list.length() > 0) {
        String user;
        println(list);
        if (list.contains(",")) {
          user = list.substring(0, list.indexOf(","));
          list = list.substring(list.indexOf(",") + 1);
        } else {
          user = list;
          list = "";
        }
        println("[" + user + "]");
        usersOnline.add(user);
      }
    }
    
    if (in.contains("joined") && in.contains("|official")){
      String tempUser = in.substring(0,in.indexOf(" "));
      if (!tempUser.equals(username)){
        usersOnline.add(tempUser);
      }
    }
    
    if (in.contains("disconnect") && in.contains("|official")){
      String tempUser = in.substring(0,in.indexOf(" "));
      for (int i=0; i<usersOnline.size(); i++){
        if (tempUser.equals(usersOnline.get(i))){
          usersOnline.remove(i);
        }
      }
    }
    
    if(in.equals("|KICKALL")) exit();
    if(in.equals("[SERVER] " + username + " has been kicked by Console!|BGRED|weight(5)")) exit();
    
    
    if (in.contains("|FLUSH")) {
      messages.clear();
      messages.add(new message("Messages flushed!|BGDARKBLUE|weight(5)|countdown(500)"));
    } else if (in.contains("|TYPING")) {
      typing=in.substring(0, in.indexOf("|")) + " is typing...";
    } else if (in.contains("|NOTTYPING")) {
      typing="Hello, " + username + "!";
    } else { 
      if (in.contains(username + ":")) {
        x = 0;
      } else {
        x = 20;
      }
      
      // Color Management
      
      for (String textColor : colorsDict.keyArray()) {
        bg = (in.contains("|BG" + textColor)) ? colorsDict.get(textColor) : bg;
        tc = (in.contains("|BG" + textColor) && textColor == "YELLOW") ? color(#000000) : color(#FFFFFF);
      }

      if (in.contains("|bgrgb(")) {
        String storage = in;
        int r = int(in.substring(in.indexOf("(") + 1, in.indexOf(",")));
        storage = in.substring(in.indexOf(",") + 1);
        int g = int(storage.substring(0, storage.indexOf(",")));
        int b = int(storage.substring(storage.indexOf(",") + 1, storage.indexOf(")")));
        bg = color(r, g, b);
        tc = color(255-red(bg), 255-green(bg), 255-blue(bg));
      }
      
      for (String textColor : colorsDict.keyArray()){ // This for loop replaces all the if-else statements
        tc = (in.contains('|' + textColor)) ? colorsDict.get(textColor) : tc;
      } 
        
      if (in.contains("|rgb(")) {
        String storage = in;
        int r = int(trim(in.substring(in.indexOf("(") + 1, in.indexOf(","))));
        storage = in.substring(in.indexOf(",") + 1);
        int g = int(trim(storage.substring(0, storage.indexOf(","))));
        int b = int(trim(storage.substring(storage.indexOf(",") + 1, storage.indexOf(")"))));
        tc = color(r, g, b);
      }
      
      // Misc. Text Management
      
      if (in.contains("|weight(")) {
        String storage = in.substring(in.indexOf("|weight"));
        weight = int(storage.substring(storage.indexOf("(") + 1, storage.indexOf(")")));
      }

      if (in.contains("|countdown(")) {
        String storage = in.substring(in.indexOf("|countdown"));
        countdown = int(storage.substring(storage.indexOf("(") + 1, storage.indexOf(")")));
      }

      if (in.contains("|UC")) {
        text = in.substring(0, in.indexOf("|")).toUpperCase();
      } else if (in.contains("|LC")) {
        text = in.substring(0, in.indexOf("|")).toLowerCase();
      } else if (in.contains("|")) {
        text = in.substring(0, in.indexOf("|"));
      } else {
        text = in;
      }

      if (rainbowMode == true) {
        bg = rainbow[rainbowStep];
        tc = rainbowText[rainbowStep] ? #FFFFFF : #000000;
        rainbowStep = (rainbowStep + 1) % rainbow.length;
      }
    }

    if (mode.equals("light")) {
      bg = color(red(bg) + 50, green(bg) + 50, blue(bg) + 50);
    }
  }

  void display(int pos) {
    if (text == null) {
    } else {
      if (text.contains(username + ":")) {
        x = 20 + largeWindowAdjust;
      } else {
        x = 0 + largeWindowAdjust;
      }

      w = width-20 - largeWindowAdjust; 
      lines = int(textWidth(text) / (w-15));
      h = 30 + lines*20;
      y = pos;
      pushStyle();
      rectMode(CORNER);
      fill(bg);
      if (mode.equals("dark")) {
        stroke(red(bg)/2, green(bg)/2, blue(bg)/2);
      } else if (mode.equals("light")) {
        stroke(red(bg)/1.25, green(bg)/1.25, blue(bg)/1.25);
      } else {
        stroke((red(bg) + red(modeColor))/4, (green(bg) + green(modeColor))/4, (blue(bg) + blue(modeColor))/4);
      }

      strokeWeight(weight);
      rect(x, y, w, h);

      fill(tc);
      text(text, x + 8, y + 10, w-15, h-10);
      popStyle();
    }
  }

  void update() {
    if (countdown >= 0) {
      countdown--;
    }

    if (countdown == 0 && messages.size() > 1) {
      messages.remove(this);
    }
  }
}
