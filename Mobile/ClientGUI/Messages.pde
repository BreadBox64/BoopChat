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
    } else {
      if ((red(modeColor)+green(modeColor)+blue(modeColor))/3 < 100) {
        tc = color(255);
      } else {
        tc = color(0);
      }
      bg = modeColor;
    }


    if (in.contains("|CONFIRMONLINE")) {
      myClient.write(username + " joined the chat!|BGBLUE|weight(5)|official");
    }

    if (in.length() >= 15 && in.substring(0, 14).equals("Users Online: ")) {
      usersOnline.clear();
      String list = in.substring(14);
      list = list.substring(0, list.indexOf("|")).replaceAll(" ", "");

      while (list.length() > 0) {
        String user;
        println(list);
        if (list.contains(",")) {
          user = list.substring(0, list.indexOf(","));
          list = list.substring(list.indexOf(",")+1);
        } else {
          user = list;
          list = "";
        }
        println("["+user+"]");
        usersOnline.add(user);
      }
    }

    if (in.contains("joined") && in.contains("|official")) {
      String tempUser = in.substring(0, in.indexOf(" "));
      if (!tempUser.equals(username)) {
        usersOnline.add(tempUser);
      }
    }

    if (in.contains("disconnected") && in.contains("|official")) {
      String tempUser = in.substring(0, in.indexOf(" "));
      for (int i=0; i<usersOnline.size(); i++) {
        if (tempUser.equals(usersOnline.get(i))) {
          usersOnline.remove(i);
        }
      }
    }

    if (in.contains("|FLUSH")) {
      messages.clear();
      messages.add(new message("Messages flushed!|BGDARKBLUE|weight(5)|countdown(500)"));
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
        tc = color(255-red(bg), 255-green(bg), 255-blue(bg));
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

      if (in.contains("|UC")) {
        text = in.substring(0, in.indexOf("|")).toUpperCase();
      } else if (in.contains("|LC")) {
        text = in.substring(0, in.indexOf("|")).toLowerCase();
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
      bg = color(red(bg)+50, green(bg)+50, blue(bg)+50);
    }
  }

  void display(int pos) {
    if (text == null) {
    } else {
      if (text.contains(username+":")) {
        x = 0+largeWindowAdjust;
      } else {
        x = 20+largeWindowAdjust;
      }

      w = width-20-largeWindowAdjust; 
      lines = int(textWidth(text)/(w-15));
      h = height/16+lines*height/15;
      y = pos;
      pushStyle();
      rectMode(CORNER);
      fill(bg);
      if (mode.equals("dark")) {
        stroke(red(bg)/2, green(bg)/2, blue(bg)/2);
      } else if (mode.equals("light")) {
        stroke(red(bg)/1.25, green(bg)/1.25, blue(bg)/1.25);
      } else {
        stroke((red(bg)+red(modeColor))/4, (green(bg)+green(modeColor))/4, (blue(bg)+blue(modeColor))/4);
      }

      strokeWeight(weight);
      rect(x, y, w, h);

      fill(tc);
      textSize(height/50);
      textAlign(LEFT, CENTER);
      text(text, x+8, y+height/200, w-15, h-height/100);
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
