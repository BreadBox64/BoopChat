void serverConnect() {
  try {
    myClient = new Client(this, server, port);
    myClient.write(username + " has connected!|BGBLUE|weight(5)");
  } catch(NullPointerException e) {
    //localServer = new Server(this, 10000);
    //myClient = new Client(this, "localhost", 10000);
    //messages.add(new message("Invalid Server-Port combination, opening temporary server.|BGRED|weight(5)"));
  }
}

void openServer() {
  
}
