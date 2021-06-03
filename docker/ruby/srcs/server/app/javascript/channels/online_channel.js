import consumer from "./consumer"

consumer.subscriptions.create("OnlineChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if (data.online == "on" && Transcendence.users && Transcendence.users.get(data.user)) {
      Transcendence.users.get(data.user).set({online: true})
    } else if (data.online == "off" && Transcendence.users && Transcendence.users.get(data.user)) {
      Transcendence.users.get(data.user).set({online: false})
    }
  }
});
