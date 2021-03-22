## About BoopChat

BoopChat began as a solution to boredom. My friend was over, we had nothing to do, so we started experimenting with the network library in Processing java, and, well, here we are.

The guiding principles of BoopChat are very simple. We wanted to communicate in a nerdy way, and this approach fits the bill quite well. I personally wanted to use our creation as a way to teach young programmers the "imagine it, create it, share it" mindset that I've always had.


# Installation

### Client-only, non-mobile only:
1. Download the BoopChat repository (Extra all files when prompted)
2. Delete the ServerGUI and Mobile folders
3. As of right now, you must have [Processing](https://processing.org/download/) installed. This will change in the future.
4. Open and run ClientGUI.pde

### Client-only, mobile only:
1. Download the BoopChat repository (Extra all files when prompted)
2. Delete the ServerGUI and ClientGUI folders
3. As of right now, you must have [Processing](https://processing.org/download/) installed. Android mode is required (no iOS version exists currently).
4. Make sure your device(s) have developer mode and USB debugging enabled. From the Processing Android window, press the "run on device" button to begin installing BoopChat with the device plugged in. Once this is done, the app will open.
5. The device can now be disconnected. BoopChat will still work, but (currently) will only connect to the default IP. Change as desired.

### Server (No mobile version currently exists):
1. Download the BoopChat repository (Extra all files when prompted)
2. Delete the Mobile folder, keep the ClientGUI folder if desired (but it is not required)
3. As of right now, you must have [Processing](https://processing.org/download/) installed. This will change in the future.
4. Open and run ServerGUI.pde
  a. This will run the server on port 10001 by default.
  b. To test your server, use the client and connect via "localhost."
  c. After you go through the steps of port forwarding, other users can join your server

# Usage

The most basic usage of BoopChat is typing a word or phrase and pressing enter (For mobile users, a tap on the upper half of the screen is equivalent). While this simple usage allows a very straightforward messaging service, BoopChat *does* offer some great commands.
All commands are preceeded by a ```|``` symbol.
Text Background | Text Color | Styling | Message Management | Utility | Server Management

### Background Colors
May be combined with other commands
For all named bgcolors:
  Usage:
  ```msg|BGCOLOR```
  Example:
  ```Kerbal|BGGREEN```
* BGRED
* BGYELLOW
* BGORANGE
* BGGREEN
* BGDARKGREEN
* BGBLUE
* BGLIGHTBLUE
* BGDARKBLUE
* BGPURPLE
* BGPINK
* BGMAROON
* BGBLACK
* BGGREY
* BGWHITE
* bgrgb(int,int,int)

### Text Colors
May be combined with other commands
For all named colors:
  Usage:
  ```msg|COLOR```
  Example:
  ```Depressed Crab|BGBLUE|WHITE```
* RED
* YELLOW
* ORANGE
* GREEN
* DARKGREEN
* BLUE
* LIGHTBLUE
* DARKBLUE
* PURPLE
* PINK
* MAROON
* BLACK
* GREY
* WHITE
* rgb()
  Usage:
  ```msg|rgb(int,int,int)```
  Example:
  ```I am issuing you another stern warning!|BGBLUE|rgb(240, 240, 245)```

### Styling
May be combined with other commands
* weight()
  Usage:
  ```msg|weight(int)```
  Example:
  ```Hello John!|RED|weight(4)```
* RAINBOW
  Toggles the background of messages cycling in a rainbow pattern
  Usage:
  ```msg|RAINBOW```

### Message Management
May be combined with other commands

* 
May not be combined with other commands
* msg()
  Sends a private message to another client
  Usage:
  ```msg|msg(recipent)```
  Example:
  ```Hello|msg(John)```

### Utility
May not be combined with other commands
* EXIT
  Closes the BoopChat client
  Usage:
  ```|EXIT```
  
* COMMANDS
  Lists all commands
  Usage:
  ```|COMMANDS```
  
* VERSION
  Lists client version, server version and latest client version
  Usage:
  ```|VERSION```
  
* ONLINE
  Lists all online users
  Usage:
  ```|ONLINE```
* DISCONNECT
  Force disconnect from server
  Usage:
  ```|DISCONNECT```

* CLEAR
  Clears screen of messages
  Usage:
  ```|CLEAR```
* CHANGENAME
  Usage:
  ```newName|CHANGENAME```
  Example:
  ```Louis MXIV|CHANGENAME```
* CHANGESERVER
  Usage:
  ```newServerIP|CHANGESERVER```
  Example:
  ```localhost|CHANGESERVER```
* CHANGEPORT
  Usage:
  ```newPort|CHANGEPORT```
  Note that ```newPort``` must be an integer.
  Example:
  ```10024|CHANGEPORT```

### Server Management
May be combined with other commands
* STOP
  Shuts down the server within 3 seconds
  Usage:
  ```|STOP```
May be combined with other commands

## Images

<center>
The client and server viewed side by side. Note that messages can also be sent from the server, meaning that running both programs as seen above is entirely unnecesary.<br>
<img src="https://i.imgur.com/4NoZLca.png" width="60%" style="border: 10px solid rgb(40,100,190)"><br><br>
The isolated client, shown in a dark color mode.<br>
<img src="https://i.imgur.com/110jQ8H.png" width="60%" style="border: 10px solid rgb(40,100,190)">
</center>


## Support or Contact

If you have any questions about BoopChat, or just want to chat, send an email to skaplanofficial@gmail.com!
