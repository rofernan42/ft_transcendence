//= require_self
//= require_tree ./helpers
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./routers
//= require_tree ./views
//= require_tree .

var Transcendence = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function (data) {
    this.chatrooms = new Transcendence.Collections.Chatrooms(data.chatrooms);
    this.private_rooms = new Transcendence.Collections.PrivateRooms(data.private_rooms);
    this.users = new Transcendence.Collections.Users(data.users);
    this.friends = new Transcendence.Collections.Friends(data.friends);
    this.games = new Transcendence.Collections.Games(data.games);
    this.pongs = new Transcendence.Collections.Pongs(data.pongs);
    this.guilds = new Transcendence.Collections.Guilds(data.guilds);
    this.guild_wars = new Transcendence.Collections.GuildWars(data.guild_wars);
    this.guild_invitations = new Transcendence.Collections.GuildInvitations(data.guild_invitations);
    this.tournaments = new Transcendence.Collections.Tournaments(data.tournaments);
    this.current_user = new window.Transcendence.UserSession(data.current_user);
    this.otp_uri = data.otp_uri;
    new Transcendence.Routers.Home();
    new Transcendence.Routers.Chatrooms();
    new Transcendence.Routers.PrivateRooms();
    new Transcendence.Routers.Users();
    new Transcendence.Routers.Games();
    new Transcendence.Routers.Pongs();
    new Transcendence.Routers.Guilds();
    Backbone.history.start();
    setInterval(() => {
      $.ajax({
        url: '/api/tournaments',
        type: 'get',
        success: function (response) {
        }
      });
      $.ajax({
        url: '/api/guild_wars/',
        type: 'get',
        success: function (response) {
        }
      });
    }, 60000);
  }
};
