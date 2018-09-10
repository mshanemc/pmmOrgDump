({
    doInit : function(component, event, helper) {
        let tableColumns = [
            { label: 'Start Time (Pacific)', fieldName: 'Start__c', type: 'date', typeAttributes: {hour: "numeric", minute: "2-digit", month: "short", day: "numeric", timeZone: "America/Los_Angeles" } },
            { label: 'Open Seats', fieldName: 'Open_Seats__c', type: 'number' }
        ];

        if (component.get("v.isRegistered")){
            tableColumns.push(
                {
                    type: 'action', typeAttributes: {
                        rowActions: [{
                            label: 'Sign Up', name: 'signup'
                        }]
                    }
                })
        }

        component.set("v.tableColumns", tableColumns);

        var action = component.get("c.getSessionsForWorkshop");
        action.setParams({
            workshopId: component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a.getReturnValue());
                component.set("v.sessionData", a.getReturnValue());
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find('leh').passErrors(a.getError());
            }
        });
        $A.enqueueAction(action);
    },

    handleRowAction : function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log(JSON.stringify(row));

        //    public static registration__c register(id sessionId){

        var action = component.get("c.register");
        action.setParams({
            sessionId: row.Id
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a);
                $A.get("e.force:showToast").setParams({"type" : "success", "message" : "You're registered!"}).fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": a.getReturnValue().Id,
                });
                navEvt.fire();
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find('leh').passErrors(a.getError());
            }
        });
        $A.enqueueAction(action);

    },
})