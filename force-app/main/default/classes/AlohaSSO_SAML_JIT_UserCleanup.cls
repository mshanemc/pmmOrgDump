public with sharing class AlohaSSO_SAML_JIT_UserCleanup implements Database.Batchable<sObject> {

   private static Set<Id> ignoreList = getIgnoredUsers();
   private static Integer counter = ignoreList.size();

   public Database.QueryLocator start(Database.BatchableContext context) {
       return Database.getQueryLocator([
               SELECT Id, isActive
               FROM User
               WHERE isActive = True
               AND Id NOT IN (SELECT UserId
                               FROM LoginHistory
                               WHERE LoginTime > LAST_MONTH)
               AND Id NOT IN :ignoreList]);
   }

   public void execute(Database.BatchableContext context, List<User> scope) {
       List<User> usersToDeactivate = new List<User>();
       for (User u:scope) {
           u.isActive = False;
           usersToDeactivate.add(u);
           ignoreList.add(u.Id);
       }
       try {
           update usersToDeactivate;
       } catch (DmlException ex) { /* ignore */ }
   }

   public void finish(Database.BatchableContext context) {
       Integer currentUsersCount = ignoreList.size();
       if (counter != currentUsersCount) {                     // halt the job is the number of deactivated users didn't change since the previous job
           counter = currentUsersCount;
           Database.executeBatch(this, 50);
       }
   }

   private static Set<Id> getIgnoredUsers() {
       Set<Id> usersToIgnore = new Set<Id>();
       List<User> users = [SELECT Id
                           FROM User
                           WHERE ProfileId IN (
                                   SELECT Id
                                   FROM Profile
                                   WHERE PermissionsManageUsers = True)];
       for (User u:users) {
           usersToIgnore.add(u.Id);
       }
       return usersToIgnore;
   }
}