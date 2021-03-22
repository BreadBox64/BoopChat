void setModeColor() {
  for (String textColor : colorsDict.keyArray()){ // This for loop replaces all the if-else statements
    modeColor = (mode.equals(textColor)) ? colorsDict.get(textColor) : modeColor;
  }
  
  if (mode.contains("rgb(") && mode.contains(")")) {
    String storage = mode;
    int rr = int(trim(mode.substring(mode.indexOf("(") + 1, mode.indexOf(","))));
    storage = mode.substring(mode.indexOf(",") + 1);
    int rg = int(trim(storage.substring(0, storage.indexOf(","))));
    int rb = int(trim(storage.substring(storage.indexOf(",") + 1, storage.indexOf(")"))));
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
      if ((red(modeColor) + green(modeColor) + blue(modeColor))/3 < 100) { // Overall dark
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
  if (width/5 < 200) {
    largeWindowAdjust = width/5 + 2;
    rect(0, 0, width/5, height-30);

    fill(255);
    textAlign(CENTER, CENTER);
    text("Users Online", 0, 0, width/5, 60);

    stroke(100);
    strokeWeight(1);
    line(10, 40, width/5-10, 40); // Underline Users Online text

    textAlign(LEFT);

    int pos = 0;
    for (String u : usersOnline) {
      text(u, 10, 60 + pos); // Display usernames
      pos += 15;
    }
  } else {
    largeWindowAdjust = 202;
    rect(0, 0, 200, height-30);

    fill(255);
    textAlign(CENTER, CENTER);
    text("Users Online", 0, 0, 202, 60);

    stroke(100);
    strokeWeight(1);
    line(10, 40, 202-10, 40); // Underline Users Online text

    textAlign(LEFT);

    int pos = 0;
    for (String u : usersOnline) {
      text(u, 10, 60 + pos); // Display usernames
      pos += 15;
    }
  }
}
