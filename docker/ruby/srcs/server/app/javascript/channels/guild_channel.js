import consumer from "./consumer"

consumer.subscriptions.create("GuildChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    Transcendence.guilds.fetch();
    if (data.content == "guild_invitation") {
      Transcendence.guild_invitations.fetch();
    } else if (data.content == "guild_war") {
      Transcendence.guild_wars.fetch();
    }
  }
});
