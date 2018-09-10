({
    loadProjects : function(component, event, helper) {
        var action = component.get("c.getMyProjects");
        action.setParams({ status : component.get("v.status") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var items = new Array();
                var returnValues = response.getReturnValue();
                console.log(returnValues);
                returnValues.forEach(function(project) {
                    var values = {};
                    var recordId = component.get("v.recordId");
                    var status = component.get("v.status");
                    // Bad hack to default to first selection in list
                    if (recordId == null && status == 'Doing' && recordId == null) {
                        component.set("v.recordId", project.Id);
                        component.set("v.projectId", project.Id);
                        helper.fireProjectSelectionEvent(component);
                    }
                    values.id = project.Id;
                    values.label = project.Name;
                    values.duein = project.Days_Until_Due__c;
                    values.items = [];
                    if (project.Tasks != null) {
                        values.hasTasks = true;
                        project.Tasks.forEach(function(task) {
                            values.items.push({
                                "id" : task.Id,
                                "label": task.Subject,
                                "project" : project.Id,
                                "duein" : helper.daysUntil(task.ActivityDate)
                            }); 
                        });
                    }
                    items.push(values);
                });
                console.log(items);
                component.set('v.items', items);
            }
            else if (state === "INCOMPLETE") {
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
    },
    
    collapseAll : function(component) {
        var ul = component.find("projects").getElement();
        var uls = ul.getElementsByTagName("ul");
        for (var i = 0; i < uls.length; ++i) {
            uls[i].classList.remove("show");
        }
        var items = ul.getElementsByClassName("expanded");
        for (var i = 0; i < items.length; ++i) {
            items[i].classList.remove("expanded");
        }        
    },
    
    deselectAll : function(component) {
        var ul = component.find("projects").getElement();
        var items = ul.getElementsByClassName("selected");
        for (var i = 0; i < items.length; ++i) {
            items[i].classList.remove("selected");
        }        
    },
    
    fireProjectSelectionEvent: function(component) {
        var selectedRecordId = component.get('v.recordId');
        console.log('Selected Record: ' + selectedRecordId);
        var compEvent = $A.get("e.c:ProjectSelectionEvent");
        compEvent.setParams({"recordId" : component.get('v.recordId') });
        compEvent.setParams({"projectId" : component.get('v.projectId') });
        compEvent.setParams({"taskId" : component.get('v.taskId') });
        compEvent.fire();
        console.log('Event fired!');      
    },
    
    closeTask : function(taskId, component) {
        var taskId = component.get('v.taskId');
        if (!taskId) {
            return;
        }
        
        console.log('Closing task - ' + taskId);
        var action = component.get("c.closeTask");
        action.setParams({ 
            taskId : taskId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Success');
                var projectId = component.get('v.projectId');
                var items = component.get('v.items');
                console.log("Iterating...");
                for(var a = 0; a < items.length; a++) {
                    console.log("Project: " + items[a].label);
                    if (items[a].id == projectId) {
                        console.log('Found project');
                        var tasks = [];
                        items[a].items.forEach(function(task) {
                            // Remove the task from the list.
                            if (task.id != taskId) {
                                console.log('Found task');
                                tasks.push(task);
                            }
                        });
                        items[a].items = tasks;
                        component.set('v.items', items);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Task Completed!",
                            "type": "success",
                            "duration": 1500,
                            "message": "This task has now been marked as completed."
                        });
                        toastEvent.fire();
                        return;
                    } 
                }
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
    },
    
    daysUntil: function(dueDate) {
        if (dueDate == null) {
            return null;
        }
        var today = new Date();
        today.setHours(0);
        today.setMinutes(0);
        today.setSeconds(0);
        var dueDate = new Date(dueDate + ' 00:00:00');
        var diff = new Date(dueDate - today);
        var days = Math.round(diff/1000/60/60/24);
        return days;
    }
})