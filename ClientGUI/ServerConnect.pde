void serverConnect() {
  try {
    myClient = new Client(this, server, port);
    myClient.write(username + " has connected!|BGBLUE|weight(5)");
  } catch(NullPointerException e) {
    localServer = new Server(this, 10000);
    myClient = new Client(this, "localhost", 10000);
    messages.add(new message("Invalid Server-Port combination, opening temporary server.|BGRED|weight(5)"));
  }
}

void runServer() {
  if(serverOp) {
    Client thisClient = localServer.available();
    if (thisClient != null) {
      if (thisClient.available() > 0) {
        localServer.write(thisClient.readString());
      }
    }
  }
}
