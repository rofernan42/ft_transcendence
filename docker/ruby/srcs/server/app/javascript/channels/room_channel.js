import consumer from "./consumer"

const roomChannel = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.type == "chatrooms") {
      if (data.action == "chats") {
        Transcendence.chatrooms.get(data.content.chatroom_id).fetch().done(function () {
          if (Transcendence.current_user.id == data.content.user_id)
            $('#text-field').val('');
        });
      } else if (data.action == "update") {
        Transcendence.chatrooms.fetch();
      }
    } else if (data.type == "private_rooms") {
      if (data.action == "chats") {
        Transcendence.private_rooms.get(data.content.private_room_id).fetch().done(function () {
          if (Transcendence.current_user.id == data.content.user_id)
            $('#text-pm-field').val('');
        });
      } else if (data.action == "update") {
        if (data.updateType == "add") {
          Transcendence.private_rooms.fetch().done(function () {
            if (Transcendence.current_user.id == data.userid)
              location.hash = "#private_rooms/" + data.roomid;
          });
        } else {
          Transcendence.private_rooms.fetch()
        }
      }
    }
  }
});

export default roomChannel;