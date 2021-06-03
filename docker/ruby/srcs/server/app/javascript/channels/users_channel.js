import consumer from "./consumer"

consumer.subscriptions.create("UsersChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.content == "profile") {
      Transcendence.users.fetch()
    }
    Transcendence.current_user.fetch();
    if (data.content == "banned") {
      window.location.href = "/"
    }
  }
});
