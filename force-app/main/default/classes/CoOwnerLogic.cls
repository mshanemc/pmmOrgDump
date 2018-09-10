public class CoOwnerLogic {
    
	@InvocableMethod (label='Update CoOwners' description='loops through the coowners object and updates the list on the project' )
    public static void createCoOwnerList(list<string> projectIds){
        //get the project
        list<project__c> projectsToUpdate = [select id, users__c from project__c where id in: projectIds];
        
        //get the co-owners
        list<Co_Owner__c> coowners = [select id, Project__c, user__r.firstname, user__r.lastname from Co_Owner__c where project__c in: projectIds];
        map<id, list<string>> userListByProject = new map<id, list<string>>();
        
        for (project__c p:projectsToUpdate){
            list<string> temp = new list<string>();
      		userListByProject.put(p.Id, temp);
        }
        
        for (Co_Owner__c coo:coowners){            
            list<string>temp = userListByProject.get(coo.Project__c);                            
            temp.add(coo.user__r.firstname + ' ' + coo.user__r.lastname);
           	userListByProject.put(coo.Project__c, temp);
        }
        
        //build the names list        
        for (project__c p:projectsToUpdate){
        	list<string> userNames = userListByProject.get(p.Id);
            string convertedNames = String.join(userNames, ',');
            p.Users__c = convertedNames;
        }
        //update the project
        update projectsToUpdate;
    }
}