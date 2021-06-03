function getAnagram(userId) {
    guildId = Transcendence.users.get(userId).toJSON().guild
    if (guildId) {
        return Transcendence.guilds.get(guildId).toJSON().anagram;
    }
    return null;
}

function flashMessage(type, str) {
    var flash = `<div class="flash-message ${type}">` +
        `${str} <span class="closebtn" onclick="$(this.parentElement).remove();">&times;</span>` +
        `</div>`
    $("#parent-flash").append(flash);
    setTimeout(function () {
        $("#parent-flash").find('div:first').slideUp(500, function () {this.remove()});
    }, 3000);
} // type: notice, error or deleted; str: message to print