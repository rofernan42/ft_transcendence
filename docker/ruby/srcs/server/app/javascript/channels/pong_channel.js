import consumer from "./consumer"

consumer.subscriptions.create("PongChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.content == "ok") {
      Transcendence.pongs.fetch().done(() => {
        
      });
    } else if (data.content == "set") {
      Transcendence.pongs.add(data.pong)
    }
  }
});
