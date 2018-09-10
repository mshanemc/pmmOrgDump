public with sharing class ProjectsController {
    @AuraEnabled
    public static List<Project__c> getMyProjects(String status) {
        Id myID = UserInfo.getUserId();
        string fullname = '%' + userinfo.getFirstName() + ' ' + userInfo.getLastName() + '%'; 
        List<Project__c> projects = [SELECT Id, Name, Days_Until_Due__c, (SELECT Id, Subject, ActivityDate  FROM Tasks WHERE Status <> 'Completed' AND OwnerId = :myID ORDER BY ActivityDate ASC NULLS LAST, CreatedDate) FROM Project__c 
                                     WHERE ( OwnerId = :myID OR Users__c like: fullName )
                                       AND Status__c = :status
                                     ORDER BY Priority__c ASC];
        return projects;
    }
    
    @AuraEnabled
    public static ID newTask(String projectId, string subject) {
        Task task = new Task();
        task.Subject = subject;
        task.WhatId = projectId;
		insert task;
        return task.Id;
    }
    
    @AuraEnabled 
    public static ID newProject(String projectName, String status) {
        Project__c project = new Project__c();
        project.Name = projectName;
        project.Status__c = status;
        insert project;
        return project.Id;
    }
    
    @AuraEnabled
    public static void closeTask(String taskId) {
        Task task = [SELECT Status FROM Task WHERE Id = :taskId];
        task.Status = 'Completed';
        update task;
    }
    
    
    private static list<id> getExpandedProjects(String status){
        set<id> projectIds = new set<id>();
        // projects I am the ownerOf
        // project I have tasks associated with
        
        // projects I follow via Chatter
        map<id, Project__c> projects = new map<id, Project__c>(
            [SELECT Id, Name FROM Project__c 
             WHERE Status__c = :status]
        );
        map<id, EntitySubscription> followedProjects = new map<id, EntitySubscription>(
            [select ParentId from entitySubscription 
             where SubscriberId  =: Userinfo.getUserId() and ParentId in: projects.keySet()]
        );
        projectIds.addAll(new List<id>(followedProjects.keySet()));
        
        // projects I requested
        // projects I am requested PMM for
        
        return new list<id>(projectIds);
    }	
}