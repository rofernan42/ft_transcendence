import { Events } from "backbone";
import consumer from "./consumer"

consumer.subscriptions.create("FlashAdminChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if (data.type == "admin" || data.type == "ban" || data.type == "owner") {
      let currentChatroom = sessionStorage.getItem('chat_roomid')
      if (data.chatroom.id == currentChatroom) {
        var elem = `#flash-${data.type}-message`
        $(elem).show();
      }
    }
    else if (data.type == "flash" && data.flash) {
      flashMessage(data.flash[0][0], data.flash[0][1]);
    }
    else if (data.war == true)
    {
      var flash = `<div class="flash-message notice"> ` +
      data.user_one_name + ` sent you a duel request ! ` +
      `<form action="/api/pongs/accept_duel" method="post" data-remote="true" class="flash-form" style="display:inline-block">` +
      `<input type="submit" class="link-form" value="accept">` +
      `<input value="` + data.user_one_id + `" type="hidden" name="user_one_id">` +
      `<input value="` + data.user_two_id + `" type="hidden" name="user_two_id">` +
      `<input type="hidden" value="` + data.war + `" type="hidden" name="war">` +
      `</form> | <form id="decline-id" action="/api/pongs/decline_duel" method="post" data-remote="true" class="flash-form" style="display:inline-block">` +
      `<input type="submit" class="link-form" value="decline">` +
      `<input value="` + data.user_one_id + `" type="hidden" name="user_one_id">` +
      `<input value="` + data.user_two_id + `" type="hidden" name="user_two_id">` +
      `<input type="hidden" value="` + data.war + `" type="hidden" name="war">` +
      `</form></div>`
    $("#parent-flash").append(flash);
    setTimeout(function () {
        $("#parent-flash").find('div:first').slideUp(500, function () {this.remove()});
    }, 30000);
    $(".flash-form").submit(function (e) { $(e.target.parentElement).remove(); });
    $("#decline-id").submit(function (e) { $(e.target.parentElement).remove();});

    }
    else if (data.type == "duel")
    {
      var flash = `<div class="flash-message notice"> ` +
        data.user_one_name + ` sent you a duel request ! ` +
        `<form action="/api/pongs/accept_duel" method="post" data-remote="true" class="flash-form" style="display:inline-block">` +
        `<input type="submit" class="link-form" value="accept">` +
        `<input value="` + data.user_one_id + `" type="hidden" name="user_one_id">` +
        `<input value="` + data.user_two_id + `" type="hidden" name="user_two_id">` +
        `<input type="hidden" value="` + data.war + `" type="hidden" name="war">` +
        `</form> | <button class="link-form" onclick="$(this.parentElement).remove();">decline</button>` +
        `</div>`
      $("#parent-flash").append(flash);
      setTimeout(function () {
          $("#parent-flash").find('div:first').slideUp(500, function () {this.remove()});
      }, 30000);
      $(".flash-form").submit(function (e) { $(e.target.parentElement).remove(); });
    }
  }
});
