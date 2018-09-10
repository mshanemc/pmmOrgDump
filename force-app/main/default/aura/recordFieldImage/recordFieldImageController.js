({
    onRecordLoad : function(component, event, helper) {
        component.set("v.imgSrc", component.get("v.targetFields." + component.get("v.field")));
    }
})