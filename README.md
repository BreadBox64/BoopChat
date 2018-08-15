## About BoopChat

BoopChat began as a solution to boredom. My friend was over, we had nothing to do, so we started experimenting with the network library in Processing java, and, well, here we are.

The guiding principles of BoopChat are very simple. We wanted to communicate in a nerdy way, and this approach fits the bill quite well. I personally wanted to use our creation as a way to teach young programmers the "imagine it, create it, share it" mindset that I've always had.


# Installation

### Client-only, non-mobile only:
1. Download the BoopChat repository (Extra all files when prompted)
2. Delete the ServerGUI and Mobile folders
3. As of right now, you must have [Processing](https://processing.org/download/) installed. This will change in the future.
4. Open and run ClientGUI.pde
  a. This will connect you to the main BoopChat server. Change the IP on line 81 if you wish to connect to a different server.

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

All commands are preceeded by a | symbol.

Text Background | Text Color | Styling | Message Management | Utility | Server Management
------------ | ------------- | ------------- | ------------- | ------------- | -------------
BGRED | RED | weight(int) | UC | MATH
BGPINK | PINK | RAINBOW | LC | timer(float)
BGMAROON | MAROON |  | countdown(int) | COMMANDS
BGPURPLE | PURPLE |  | msg(user) | VERSION
BGBLUE | BLUE | 
BGLIGHTBLUE | LIGHTBLUE
BGDARKBLUE | DARKBLUE
BGGREEN | GREEN
BGDARKGREEN | DARKGREEN
BGYELLOW | YELLOW
BGORANGE | ORANGE
bgrgb(r,g,b) | rgb(r,g,b)


## Images

<center>
The client and server viewed side by side. Note that messages can also be sent from the server, meaning that running both programs as seen above is entirely unnecesary.<br>
<img src="https://i.imgur.com/4NoZLca.png" width="60%" style="border: 10px solid #333333"><br><br>
The isolated client, shown in a light color mode.<br>
<img src="https://i.imgur.com/110jQ8H.png" width="60%" style="border: 10px solid #333333">
</center>


## Support or Contact

If you have any questions about BoopChat, or just want to chat, send an email to skaplanofficial@gmail.com!
