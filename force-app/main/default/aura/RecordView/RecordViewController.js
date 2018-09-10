({
    save : function(component, event, helper) {
        component.find("edit").get("e.recordSave").fire();
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "duration": 1500,
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
        
        var compEvent = $A.get("e.c:ProjectChangedEvent");
        compEvent.fire();
        console.log('Event fired!');      
    },
    
    handleProjectSelectionEvent : function(component, event, helper) {
        console.log('Event Received');
        component.set("v.toggleChatter", false);
        component.set("v.recordId", event.getParam("recordId"));
        component.set("v.toggleChatter", true);
    }
})