({
    doInit : function(component, event, helper) {
        console.log(`recordId is ${component.get("v.recordId")}`);
        var action = component.get("c.getWorkshopByEvent");
        action.setParams({
            eventId : component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a.getReturnValue());
                component.set("v.workshops", a.getReturnValue());
            } else if (state === "ERROR") {
                console.log(a.getError());
            }
        });
        $A.enqueueAction(action);
    },

    schedule : function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.getSource().get("v.value")
        });
        navEvt.fire();
    },
})