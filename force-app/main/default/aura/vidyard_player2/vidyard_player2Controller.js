({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCurrentUser");
        action.setCallback(this, function(a) {
            var user = a.getReturnValue();
            component.set("v.runningUser", user);
        });
        $A.enqueueAction(action);
    },

    handleShowPlayer : function(component, event, helper) {
    	var selected = event.getParam("player");
        component.set('v.player', selected);
    },

    doRender: function (component) {
        var frames = document.getElementsByClassName("vidyardFrame");

        for (var i = 0; i < frames.length; i++) {
            var frame = frames[i];
            frame.setAttribute("allowfullscreen", "allowfullscreen");
        }
    }
})