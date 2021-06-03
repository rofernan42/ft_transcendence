Transcendence.Views.GuildsPanel = Backbone.View.extend({
    initialize: function () {
        this.listenTo(Transcendence.users, 'change:username change:guild change:officer change:member change:pong add remove', this.render);
        this.listenTo(Transcendence.guilds, 'change add remove', this.render);
        this.listenTo(Transcendence.guild_wars, 'change add remove', this.render);
        this.listenTo(Transcendence.pongs, 'change add remove', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active");
        $(".option-guilds").addClass("active");
        if (!Transcendence.guilds.get(this.id)) {
            this.remove();
            location.hash = "#guilds";
        } else {
            let curr_war = null
            let guild_two = null
            let war_time = null
            if (this.model.toJSON().war) {
                curr_war = Transcendence.guild_wars.get(this.model.toJSON().war).toJSON()
                if (curr_war.started == true && curr_war.done == false) {
                    if (curr_war.guild_one_id == this.model.toJSON().id)
                        guild_two = Transcendence.guilds.get(curr_war.guild_two_id).toJSON()
                    else
                        guild_two = Transcendence.guilds.get(curr_war.guild_one_id).toJSON()
                    war_time = true
                    Transcendence.pongs.where({ done: false, mode: "war" }).forEach(element => {
                        guild_one_id = Transcendence.users.get(element.toJSON().user_left_id).toJSON().guild
                        guild_two_id = Transcendence.users.get(element.toJSON().user_right_id).toJSON().guild
                        if (guild_one_id && guild_two_id && guild_one_id != guild_two_id) {
                            if ((guild_one_id == this.model.toJSON().id || guild_one_id == guild_two.id) && (guild_two_id == guild_two.id || guild_two_id == this.model.toJSON().id)) {
                                war_time = false
                                return;
                            }
                        }
                    });
                    if (war_time == true)
                    {
                        if (curr_war.war_time == true)
                            war_time = true
                        else
                            war_time = false
                    }
                }
                else
                    curr_war = null
            }
            this.$el.html(JST['templates/guilds/panel']({
                curguild: this.model.toJSON(),
                guildwars: Transcendence.guild_wars.where({ done: true })
            }));
            this.$('.guilds-sidenav').append(JST['templates/guilds/guilds_sidenav']());
            var guildMembers = JST['templates/guilds/guild_members']({
                war_time: war_time,
                curr_war: curr_war,
                guild_two: guild_two,
                curguild: this.model.toJSON()
            });
            this.$('#guild-members').append(guildMembers);
        }
        return this;
    }
});