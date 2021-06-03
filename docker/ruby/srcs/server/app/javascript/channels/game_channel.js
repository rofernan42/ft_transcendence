import { escapeSelector } from "jquery";
import consumer from "./consumer"

let game;
let room;
let side = "none"
let pong;
let room_id;
let inter;
let xneg;
let yneg;

let up = false
let down = false

let canvas = null
let contexte = null

let match = false
let interv = null
let interva = null


let currentTime = Date.now();

class Game {
  constructor(room_id) {
    this.room_name = "play_channel_" + room_id
    this.ballx = 300.0
    this.bally = 175.0
    this.balldirx = 0.5
    this.balldiry = 0.5
    this.left_action = 's'
    this.user_left_y = 125.0
    this.user_right_y = 125.0
    this.right_action = 's'
    this.user_left_score = 0
    this.user_right_score = 0
    this.room = room_id
    this.ballspeed = 400.0;
  }
}

document.addEventListener("keydown", event => {
  switch (event.key) {
    case "w" || "ArrowUp":
      up = true;
    case "s" || "ArrowDown":
      down = true;
  }
})

document.addEventListener("keyup", event => {
  switch (event.key) {
    case "w" || "ArrowUp":
      up = false;
    case "s" || "ArrowDown":
      down = false;
  }
})


function form_f()
{
    remove_sub()
    if (document.getElementById('ladder-id').checked == true) {
      document.getElementById('ladder-id-check').value = "true"
      document.getElementById('duel-id').value = "false"
    }
    else {
      document.getElementById('ladder-id-check').value = "false"
      document.getElementById('duel-id').value = "true"
    }
    if (game)
      return false;
    else
      return true;
}

consumer.subscriptions.create("GameChannel", {
  connected() {
    interv = null
    match = false
    interva = setInterval(() => {
    if (document.getElementById("search_game")) {
        document.getElementById("search_game").removeEventListener("submit", form_f);
        document.getElementById("search_game").addEventListener("submit", form_f);
        document.getElementById("search_game").hidden = false
      }
    }, 1000);
  },

  disconnected() {
    if (game)
      consumer.subscriptions.remove(game)
    if (room)
      consumer.subscriptions.remove(room)
    game = null
    room = null
    clearInterval(inter);
    clearInterval(interva)
  },

  received(data) {
    if (data.content == "create a match") {
      remove_sub()
      if (document.getElementById("matchmaking-index"))
        document.getElementById("matchmaking-index").hidden = true;
      if (document.getElementById("waiting"))
        document.getElementById("waiting").hidden = false;
      setTimeout(() => {
        if (location.hash != "#games")
          location.hash = "#games"
      }, 200);
      game = consumer.subscriptions.create({ channel: "GameChannel", is_matchmaking: data.is_matchmaking, ranked: data.ranked, is_duel: data.duel, user_one_email: data.user_one_email }, {
        connected() {
          if (document.getElementById("cancel-id"))
            document.getElementById("cancel-id").removeEventListener("click", cancel)
          setTimeout(() => {
            interv = setInterval(() => {
              if (!document.getElementById("matchmaking-index") && room == null && side == "none") {
                game_perform()
                remove_sub()
                if (document.getElementById("matchmaking-index")) {
                  document.getElementById("matchmaking-index").hidden = false;
                  document.getElementById("waiting").hidden = true;
                  document.getElementById("found").hidden = true;
                }
                if (interv) {
                  clearInterval(interv)
                  interv = null
                }
              }
            }, 200)
          }, 2000);
          setTimeout(() => {
            if (document.getElementById("cancel-id"))
              document.getElementById("cancel-id").addEventListener("click", cancel)
          }, 500);
        },
        disconnected() {
          game_perform();
        },
        received(data) {
          if (data.action === 'game_start') {
            if (document.getElementById("waiting"))
              document.getElementById("waiting").hidden = true;
            room_id = data.match_room_id
            side = data.msg
            if (document.getElementById("found"))
              document.getElementById("found").hidden = false;
            Transcendence.current_user.fetch().done(() => {
              Transcendence.pongs.set(data.pong)
              location.hash = "#pongs/" + data.user.pong.toString()
              room = consumer.subscriptions.create({ channel: "PlayChannel", game_room_id: data.user.pong, role: side }, {
                connected() {
                  pong = new Game(room_id)
                  contexte = null
                  inter = setInterval(() => {
                    if (document.getElementById("canvas-id")) {
                      canvas = document.getElementById("canvas-id")
                      contexte = canvas.getContext('2d');
                      contexte.clearRect(0, 0, 600, 350)
                      if (document.getElementById("forfeit-right"))
                        document.getElementById("forfeit-right").addEventListener("click", forfeit);
                      if (document.getElementById("forfeit-left"))
                        document.getElementById("forfeit-left").addEventListener("click", forfeit);
                    }
                    if (contexte != null) {
                      if (side == "left" && room)
                        room.perform("get_datas", { room_name: pong.room_name })
                      currentTime = Date.now();
                      clearInterval(inter);
                    }
                  }, 50);
                },

                disconnected() {
                },

                received(data) {
                  if (contexte != null && document.getElementById("canvas-id") == null) {
                    forfeit()
                    return;
                  }
                  if (data.content && data.content == "end") {
                    remove_sub()
                    setTimeout(function () {
                      location.hash = "#games"
                    }, 200);
                  }
                  else {
                    update_datas(data)
                    if (contexte != null && room != null && pong.user_left_score < 11 && pong.user_right_score < 11) {
                      play()
                      if (document.getElementById("user_left_score"))
                        document.getElementById("user_left_score").textContent = pong.user_left_score
                      if (document.getElementById("user_right_score"))
                        document.getElementById("user_right_score").textContent = pong.user_right_score
                    }
                  }
                }
              });
            });
          }
        }
      });
    }
    else if (data.content == "spectate") {
      // Transcendence.users.fetch().done(() => {
      Transcendence.current_user.fetch().done(() => {
        Transcendence.pongs.fetch().done(() => {
          location.hash = "#pongs/" + data.user.pong.toString()
          room = consumer.subscriptions.create({ channel: "PlayChannel", game_room_id: data.user.pong, role: "spec" }, {
            connected() {
              side = "spectate"
              pong = new Game(room_id)
              contexte = null
              inter = setInterval(() => {
                if (document.getElementById("canvas-id")) {
                  canvas = document.getElementById("canvas-id")
                  contexte = canvas.getContext('2d');
                  contexte.clearRect(0, 0, 600, 350)
                  if (document.getElementById("leave-spec"))
                    document.getElementById("leave-spec").addEventListener("click", leave);
                }
                if (contexte != null) {
                  room.perform("get_datas", { room_name: pong.room_name })
                  currentTime = Date.now();
                  clearInterval(inter);
                }
              }, 50);
            },

            disconnected() {
            },

            received(data) {
              if ((contexte != null && document.getElementById("canvas-id") == null) || (data.content && data.content == "end")) {
                remove_sub()
                setTimeout(function () {
                  location.hash = "#games"
                }, 200);
              }
              else {
                update_datas(data)
                if (contexte != null && room != null && pong.user_left_score < 11 && pong.user_right_score < 11) {
                  play()
                  if (document.getElementById("user_left_score"))
                    document.getElementById("user_left_score").textContent = pong.user_left_score
                  if (document.getElementById("user_right_score"))
                    document.getElementById("user_right_score").textContent = pong.user_right_score
                }
              }
            }
          });
        });
      });
      // });
    }
    else if (data.content == "disconnected") {
      remove_sub()
      if (location.hash != "#games") {
        setTimeout(function () {
          location.hash = "#games"
        }, 200);
      }
      // else if (document.getElementById("matchmaking-index")) {
      //   setTimeout(function () {
      //   document.getElementById("matchmaking-index").hidden = false;
      //   document.getElementById("waiting").hidden = true;
      //   document.getElementById("found").hidden = true;
      //   }, 500);
      // }
    }
  }
});

function remove_sub() {
  if (game)
    consumer.subscriptions.remove(game)
  game = null
  if (room)
    consumer.subscriptions.remove(room)
  room = null
}

function cancel() {
  document.getElementById("cancel-id").removeEventListener("click", cancel)
  game_perform()
  remove_sub()

  if (location.hash != "#games") {
    location.hash = "#games"
  }
  else if (document.getElementById("matchmaking-index")) {
    setTimeout(function () {
      document.getElementById("matchmaking-index").hidden = false;
      document.getElementById("waiting").hidden = true;
      document.getElementById("found").hidden = true;
    }, 1000)
  }
  if (interv) {
    clearInterval(interv)
    interv = null
  }

}

function forfeit() {
  setTimeout(function () {
    game_perform()
  }, 200);
  remove_sub()
  setTimeout(function () {
    location.hash = "#games"
  }, 200);
}

function leave() {
  game = null
  if (room)
    room.perform("leave", { player_email: Transcendence.current_user.toJSON().email })
  setTimeout(function () {
    if (room)
      consumer.subscriptions.remove(room)
    room = null
  }, 200);
  Transcendence.current_user.fetch().done(() => {
    setTimeout(function () {
      location.hash = "#games"
    }, 200);
  });
}

function game_perform() {
  if (game) {
    game.perform("disconnected", { player_email: Transcendence.current_user.toJSON().email })
  }
}

function update_pos_paddle(pong, delta) {
  if (side == "left") {
    if (up)
      pong.left_action = 'u'
    else if (down)
      pong.left_action = 'd'
    else
      pong.left_action = 's'
  }
  else if (side == "right") {
    if (up)
      pong.right_action = 'u'
    else if (down)
      pong.right_action = 'd'
    else
      pong.right_action = 's'
  }
  if (pong.left_action == 'u') {
    pong.user_left_y = Math.max(pong.user_left_y - 200 * delta, -0.9)
    if (pong.user_left_y <= 0)
      pong.user_left_y = 0;
  }
  else if (pong.left_action == 'd') {
    pong.user_left_y = Math.max(pong.user_left_y + 200 * delta, -0.9)
    if (pong.user_left_y > canvas.height - 100)
      pong.user_left_y = canvas.height - 100;
  }
  if (pong.right_action == 'u') {
    pong.user_right_y = Math.max(pong.user_right_y - 200 * delta, -0.9)
    if (pong.user_right_y <= 0)
      pong.user_right_y = 0;
  }
  else if (pong.right_action == 'd') {
    pong.user_right_y = Math.max(pong.user_right_y + 200 * delta, -0.9)
    if (pong.user_right_y > canvas.height - 100)
      pong.user_right_y = canvas.height - 100;
  }
}

function draw_game(pong) {
  contexte.clearRect(0, 0, 600, 350)

  contexte.strokeStyle = 'black';
  contexte.beginPath();
  contexte.moveTo(canvas.width / 2, 0)
  contexte.lineTo(canvas.width / 2, canvas.height)

  contexte.stroke();
  contexte.fillSyle = "black";
  contexte.fillRect(0, pong.user_left_y, 10, 100);
  contexte.fillRect(600 - 10, pong.user_right_y, 10, 100);
  contexte.fill();

  contexte.beginPath();
  contexte.fillStyle = "black";
  contexte.arc(pong.ballx, pong.bally, 5, 0, Math.PI * 2, false);
  contexte.fill();

  //requestAnimationFrame(draw_game)
}

function update(pong) {

  if (side == "left") {
    if (room != null)
      room.perform("update_left", pong)
  }
  else if (side == "right") {
    if (room != null)
      room.perform("update_right", { paddle_right_y: pong.right_action, room_name: pong.room_name })
  }
}

function update_datas(data) {
  pong.ballx = data['ball_pos_x']
  pong.bally = data['ball_pos_y']
  pong.left_action = data['left_action']
  pong.right_action = data['right_action']
  pong.user_left_score = data['left_score']
  pong.user_right_score = data['right_score']
  pong.balldirx = data['ball_dir_x']
  pong.balldiry = data['ball_dir_y']
  pong.ballspeed = data['ball_speed']
}

function play() {
  var now = Date.now();
  var delta = (now - currentTime) / 1000;
  currentTime = now;
  ballmove(pong, delta);
  update_pos_paddle(pong, delta);
  if (side != "spec")
    update(pong)
  draw_game(pong)
  setTimeout(function () {
    if (side == "left" && room != null)
      room.perform("get_datas", { room_name: pong.room_name })
  }, 1000 / 45);
}

function ballmove(pong, delta) {
  var magn = Math.sqrt(pong.balldirx * pong.balldirx + pong.balldiry * pong.balldiry)
  var newposx = pong.ballx + (pong.ballspeed * delta) * (pong.balldirx / magn)
  var newposy = pong.bally + (pong.ballspeed * delta) * (pong.balldiry / magn)

  if (newposy > canvas.height) {
    pong.bally = canvas.height - (newposy - canvas.height)
    pong.balldiry *= -1
  }
  else if (newposy <= 0) {
    pong.bally = newposy * -1
    pong.balldiry *= -1
  }
  else {
    pong.bally += ((pong.ballspeed * delta) * pong.balldiry)
  }

  if (newposx > canvas.width - 10) {
    if (side == "left") {


      if (pong.bally > pong.user_right_y + 100 || pong.bally < pong.user_right_y) {
        pong.user_left_score++;
        pong.ballx = canvas.width / 2
        pong.bally = canvas.height / 2

        xneg = Math.random() < 0.5 ? -1 : 1;
        yneg = Math.random() < 0.5 ? -1 : 1;

        pong.balldirx = (Math.random() * (0.9 - 0.4) + 0.4) * xneg
        pong.balldiry = (Math.random() * (0.6 - 0.2) + 0.2) * yneg
        pong.ballspeed = 400.0
        return;
      }
    }
    if (pong.bally < pong.user_right_y + 100 && pong.bally > pong.user_right_y) {
      pong.ballx = canvas.width - (newposx - canvas.width)
      pong.balldirx *= -1
      pong.ballspeed *= 1.1
      return
    }
  }
  else if (newposx <= 0) {
    if (side == "left") {
      if (pong.bally > pong.user_left_y + 100 || pong.bally < pong.user_left_y) {
        pong.user_right_score++;
        pong.ballx = canvas.width / 2
        pong.bally = canvas.height / 2

        xneg = Math.random() < 0.5 ? -1 : 1;
        yneg = Math.random() < 0.5 ? -1 : 1;

        pong.balldirx = (Math.random() * (0.9 - 0.4) + 0.4) * xneg
        pong.balldiry = (Math.random() * (0.6 - 0.2) + 0.2) * yneg
        pong.ballspeed = 400.0
        return;
      }
    }
    if (pong.bally < pong.user_left_y + 100 && pong.bally > pong.user_left_y) {
      pong.ballx = newposx * -1
      pong.balldirx *= -1
      pong.ballspeed *= 1.1
      return
    }
  }
  else {
    pong.ballx += ((pong.ballspeed * delta) * pong.balldirx)
  }
}
