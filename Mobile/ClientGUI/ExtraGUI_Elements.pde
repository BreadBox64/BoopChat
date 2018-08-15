void setModeColor() {
  if (mode.equals("blue")) {
    modeColor=color(0, 0, 255);
  } else if (mode.equals("red")) {
    modeColor=color(150, 0, 0);
  } else if (mode.equals("lightblue")) {
    modeColor=color(1, 150, 205);
  } else if (mode.equals("darkblue")) {
    modeColor=color(4, 20, 76);
  } else if (mode.equals("orange")) {
    modeColor=color(255, 100, 1);
  } else if (mode.equals("pink")) {
    modeColor=color(255, 20, 147);
  } else if (mode.equals("maroon")) {
    modeColor=color(75, 0, 10);
  } else if (mode.equals("green")) {
    modeColor=color(0, 150, 0);
  } else if (mode.equals("darkgreen")) {
    modeColor=color(1, 50, 25);
  } else if (mode.equals("gold")) {
    modeColor=color(255, 195, 1);
  } else if (mode.equals("purple")) {
    modeColor=color(64, 0, 100);
  } else if (mode.contains("rgb(") && mode.contains(")")) {
    String storage = mode;
    int rr = int(mode.substring(mode.indexOf("(")+1, mode.indexOf(",")));
    storage = mode.substring(mode.indexOf(",")+1);
    int rg = int(storage.substring(0, storage.indexOf(",")));
    int rb = int(storage.substring(storage.indexOf(",")+1, storage.indexOf(")")));
    modeColor=color(rr, rg, rb);
  }
}



void modeBG() {
  if (mode.equals("dark")) {
    background(21);
  } else if (mode.equals("light")) {
    background(220);
  } else { // User-defined colors w/ rgb(r,g,b)|MODE command
    if (red(modeColor) > 0 && green(modeColor) > 0 && blue(modeColor) > 0) { // Non-black color
      if ((red(modeColor)+green(modeColor)+blue(modeColor))/3 < 100) { // Overall dark
        background(red(modeColor)/3, green(modeColor)/3, blue(modeColor)/3);
      } else { // Overall light
        background(red(modeColor)*.9, green(modeColor)*.9, blue(modeColor)*.9);
      }
    } else if (red(modeColor) == 0 && green(modeColor) == 0 && blue(modeColor) == 0) { // Black
      background(red(modeColor), green(modeColor), blue(modeColor));
    } else if (red(modeColor) > 0) { // Has at least some red, may have either green or blue but not both
      background(red(modeColor)/3, green(modeColor), blue(modeColor));
    } else if (green(modeColor) > 0) {
      background(red(modeColor), green(modeColor)/3, blue(modeColor));
    } else if (blue(modeColor) > 0) {
      background(red(modeColor), green(modeColor), blue(modeColor)/3);
    }
  }
}


void largeModeDisplay() {
  if (mode.equals("dark")) {
    fill(81);
  } else if (mode.equals("light")) {
    fill(190);
  } else {
    fill(red(modeColor)/1.1, green(modeColor)/1.1, blue(modeColor)/1.1);
  }
  if (width/5 < 300) {
    largeWindowAdjust = width/5+2;
    rect(0, height/20-10, width/5, height-height/10);

    fill(255);
    textSize(width/60);
    textAlign(CENTER, CENTER);
    text("Users Online", 0, height/18, width/5, height/18);

    stroke(100);
    strokeWeight(1);
    line(10, height/18+height/25, width/5-10, height/18+height/25); // Underline Users Online text

    textAlign(LEFT);

    int pos = 0;
    for (String u : usersOnline) {
      text(u, 10, height/8+pos); // Display usernames
      pos += height/50;
    }
  } else {
    largeWindowAdjust = 302;
    rect(0, height/20-10, 300, height-height/10);

    fill(255);
    textSize(25);
    textAlign(CENTER, CENTER);
    text("Users Online", 0, height/18, 302, height/18);

    stroke(100);
    strokeWeight(1);
    line(10, height/18+height/25, 302-10, height/18+height/25); // Underline Users Online text

    textAlign(LEFT);

    int pos = 0;
    for (String u : usersOnline) {
      text(u, 10, height/8+pos); // Display usernames
      pos += height/50;
    }
  }
}
