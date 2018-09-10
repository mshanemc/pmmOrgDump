({
    doInit : function(component, event, helper) {
        let path = window.location.pathname;
        console.log(path);
        component.set("v.buttonURL", component.get("v.regBaseURL") + "?startURL=" + window.location.pathname);
    },

    reg : function(component, event, helper) {
        $A.get("e.force:navigateToURL")
            .setParams({
                "url": component.get("v.regBaseURL") + "?startURL=" + window.location.pathname,
                "isredirect" : true
            }).fire();
    },


})