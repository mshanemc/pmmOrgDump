({
    doInit : function(component, undefined, helper) {
        helper.recordInit(component);
    },

    handleSave : function(component, undefined, helper) {
        component.find("frd").saveRecord(
            $A.getCallback(function(saveResult){
                //console.log(saveResult);
                if (saveResult.state === "SUCCESS"){
                    //happy logic here
                    helper.recordInit(component);
                    $A.get("e.force:showToast").setParams({"type" : "success", "message" : "Request Saved"}).fire();
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log('User is offline, device doesn\'t support drafts.');
                } else if (saveResult.state === "ERROR"){
                    component.find("leh").passErrors(saveResult.error);
                }
            })
        );
    }
})