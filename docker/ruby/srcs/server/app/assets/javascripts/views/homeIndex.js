Transcendence.Views.HomeIndex = Backbone.View.extend ({
    events : {
        "click .confirm-choice": "unset"
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-home").addClass("active")
        this.$el.html(JST['templates/home/index']());
        return this;
    },
    unset: function (e) {
        $.ajax({
            type: "PUT",
            url: "/api/users/unset_ft",
            dataType: "json",
            encode: true,
            processData: false,
            contentType: false,
        }).done(data => {
            Transcendence.current_user.set({first_time: false});
            $("#firsttime-modal").hide();
        });
    },
});
