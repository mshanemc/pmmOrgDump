({
    onInit : function(component, event, helper) {
        helper.loadProjects(component, event, helper);
    },
    
    projectSelected : function(component, event, helper) {
        // Walk up the DOM tree until we get to the parent LI
        var element = event.currentTarget;
        while (element.nodeName != "LI") {
            element = element.parentElement;
        }
        component.set('v.recordId', element.id);
        component.set("v.projectId", element.id);
        component.set("v.taskId", null);
        helper.fireProjectSelectionEvent(component);
    }, 
    
    taskSelected: function(component, event, helper) {
        var closeTask = false;
        var element = event.target;
        if (element.nodeName == 'INPUT') {
            closeTask = true;
        }
        
        // Walk up the DOM tree until we get to the parent LI
        console.log('Clicked Task: ' + element.nodeName);
        while (element.nodeName != "LI") {
            element = element.parentElement;
        }
        component.set('v.recordId', element.id);
        component.set("v.taskId", element.id);
        helper.fireProjectSelectionEvent(component);
        if (closeTask) {
            helper.closeTask(element.id, component);
        }
    },
    
    addTask : function(component, event, helper) {
        console.log('Adding a task');
        var subject;
        var projectId = component.get("v.projectId");
        
        // Walk up the DOM tree and get the input value
        var element = event.currentTarget.parentElement.parentElement;
        var inputs = element.getElementsByTagName('input');
        for(var i = 0; i < inputs.length; i++) {
            if (inputs[i].type.toLowerCase() == 'text') {
                subject = inputs[i].value;
                inputs[i].value = null;
            }
        }
        
        console.log('Subject: ' + subject);
        console.log('Project: ' + projectId);
        
        // Make sure we have value values before submitting
        if (subject != null && subject != '') {
            console.log('Validation passed');
            var action = component.get("c.newTask");
            action.setParams({ 
                projectId : projectId,
                subject : subject
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var taskId = response.getReturnValue();
                    console.log('Success ' + taskId);
                    var items = component.get('v.items');
                    items.forEach(function(item) {
                        if (item.id == projectId) {
                            item.items.push({
                                "id" : taskId,
                                "label": subject,
                                "project" : projectId                            
                            })
                        }
                        component.set('v.items', items);
                    });
                } else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
    },
    
    showProjectModal: function(component, event, helper) {
		component.set('v.showProjectModal', true);  
    },

    hideProjectModal: function(component, event, helper) {
		component.set('v.showProjectModal', false);  
    },

    createProject: function(component, event, helper) {
        console.log('Adding a project');
        var projectName = component.get('v.newProjectName');
        var status = component.get('v.status');
        
        // Make sure we have value values before submitting
        if (projectName != null && status != null) {
            console.log('Validation passed');
            var action = component.get("c.newProject");
            action.setParams({ 
                projectName : projectName,
                status : status
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    helper.loadProjects(component, event, helper);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Project Created!",
                            "type": "success",
                            "duration": 1500,
                            "message": "This new project has been created."
                        });
                        toastEvent.fire();
                    
                } else if (state === "INCOMPLETE") {
                    // do something
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            $A.enqueueAction(action);
        }
        
        component.set('v.newProjectName', null);          
		component.set('v.showProjectModal', false);
    },
    
    handleProjectSelectionEvent: function(component, event, helper) {
        console.log('ProjectList Selection Event');
        component.set("v.recordId", event.getParam("recordId"));
        component.set("v.projectId", event.getParam("projectId"));
        component.set("v.taskId", event.getParam("taskId"));        
    },
    
    handleProjectChangedEvent: function(component, event, helper) {
        helper.loadProjects(component, event, helper);
    }
})