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
    }
})