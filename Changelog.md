# Changelogs

## Server

### Version 1.1:
- Made EVERYTHING more modular
- Reorganized & commented code to add structure
- Replaced "cooldown" with "timer"
- Added timer for server-initiated shutdown (there was already one for client-side shutdowns)
- Added red shutdown screen
- Added blue startup screen
- Clients now stored in an ArrayList using User object
- Name, client stored in User
- Opens possibility for private messaging & identifying exact users
- Made |ONLINE use "you (username)" when listing your own name
- Added loading screen to be changed later (Maybe image?)
- Added a list of online users to the terminal
- Added server-side messaging ([SERVER] Hi) with pink bg and border
- Added |timer() command IN SECONDS
- Added |KICK command (only accessible by Console atm) -- ex: Steven|KICK
- Ping clients every 5 seconds to detect when people exit or lose connection
- Added small bottons for shutdown, flush, and ping
- Altered |VERSION formatting yet again
- Reworked logging system to only require two ArrayLists
- Added message saying that list of online users was updated ("Detected disconnect: x has lost connection)

### 1.0.2.5.2.1:
- Doesn’t log things that have : and ;
- Added a boolean for logging cuz why not

### 1.0.2.5.2:
- Redid |VERSION command to fit with text wrapping
- Made simple match expressions like 1+1 work where before they would no return results
- Updated |COMMANDS command
- Added check for if a message contains a “:” before relaying it to other clients… avoids 

### 1.0.2.5:
- Server now handles math operations (+, -, *, /)
- Try/catch used to avoid math errors
- Fancy formatting for errors
- Dark green bg and stroke for math/eventually other "utility" kind of things

### 1.0.2.4.1:
- Made server announcement for changing name
- Username also change in users list to keep online list always current

### 1.0.2.4:
- Made logs actually save from compiled app
- Autosaves log after certain amount of messages (right now it's 50)
- Added the DisposeHandler from client to save logs in the case of incorrect server shutdown
- Added date/time stamps for client disconnection, cuz we had them already for client connection

### 1.0.2.3:
- made server messages prettier with more colors and borders
- fixed |VERSION formatting
- Added latestClient to |VERSION command (If server file has updated value for variable, will be able to tell if client is out of date — might even be able to make auto-update later? idk)

### 1.0.2.2:
- Made logs actually save from compiled app
- Autosaves log after certain amount of messages (right now it's 50)
- Added the DisposeHandler from client to save logs in the case of incorrect server shutdown
- Added date/time stamps for client disconnection, cuz we had them already for client connection

### 1.0.1:
- Added |VERSION command

### 1.0:
- Initial Release


## Client

### 1.0.6:
- Added color modes for all supported colors except yellow (use gold instead)
- New default theme (Dark blue)
- Added mechanism to adjust GUI based on width of window
- List of onlne users now shown for larger window sizes
- User names stored in ArrayList, step towards private messaging
- Added rgb(r,g,b)|MODE feature
- Formatted code to adopt benefits of using GitHub
- Included windows application in download

### 1.0.5.8:
- Fixed Issue #3 - Fix colors of the "Messages Flushed!" message
- Adjusted text wrapping to use textWdith() instead of eyeballed values
- Made typing box always show last letter typed; scrolls when message is longer than width

### 1.0.5.7:
- Made colored text work in light mode
- Made countdown() work properly at times below 5 milliseconds
- Added |LC command to turn entire message lowercase
- Renamed |CAPS command to |UC, as in uppercase, to match |LC format
- Made changing name no longer impact mode

### 1.0.5.6:
- Added light and dark modes
- Added |MODE command (ex: light|MODE)
- Decreased brightness of bottom typing bar for dark mode to match theme
- Client now detects if there isn't an info.txt file and automatically generates one instead of crashing
- Added |countdown() command (ex: countdown(100) -- message disappears in 100 ticks)
- Made |VERSION command more reliant on server response
- Made |CLEAR and |FLUSH position next message correctly
- Added disappearing message indicating that messages have been cleared
- Added DARKBLUE color for bg and tc
- Added update() method for messages class -> allows removal of individual messages without disrupting display method

### 1.0.5.5.1:
- Client now detects if there isn't an info.txt file and automatically generates one instead of crashing

### 1.0.5.5:
- |MATH command (ex: 1+1|MATH, What is 1+1|MATH)

### 1.0.5.4:
- Decreased typingFrameLimit to 150
- Username now based on file
- Added |CHANGENAME command (ex: Steven|CHANGENAME)
- Made server announcement for changing name
- Username also change in users list to keep online list always current

### 1.0.5.3:
- Made bgrgb() play nice with weight()
- Altered the way the client and server handle user logins -> server now sends confirmation message when it sends online users list, client then responds to provide “x joined the chat!” message… This lets us format the users list and login message separately

### 1.0.5.2:
- Fixed Typing Notifications, less responsive than before, but also less buggy
- Got client-side non-message-generating commands working (like |FLUSH, |TYPING, and |NOTTYPING)
- Fixed Auto-Message Scrolling to work with multi-line messages
- Made bgrgb() play nice with weight()
- Altered the way the client and server handle user logins -> server now sends confirmation message when it sends online users list, client then responds to provide “x joined the chat!” message… This lets us format the users list and login message separately

### 1.0.5.1:
- Added text wrapping!!!

### 1.0.5:
- Created |MAROON, |LIGHTBLUE, |DARKGREEN, and corresponding |BG commands
- Added |weight() command
- Added |CAPS command
- Multicommand text alterations now possible (i.e. HI|BGRED|LIGHTBLUE|weight(10) => Red background, light blue text, stroke weight of 10)
- Added |RAINBOW command
- Moved messages to an ArrayList system

### 1.0.2:
-Changed IP to new address
-Made "Connectioin Diagnostics" that print to the console during the connection phase.
- Added changelog

### 1.0.1:
- Added version variable and |VERSION command
- Added colored text and backgrounds

### 1.0:
- Initial Release
