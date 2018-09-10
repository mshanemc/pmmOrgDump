public with sharing class workshopSelectorCtrl {

    // @AuraEnabled
    // public static list<workshop__c> getWorkshopByEvent(id eventId){
    //     return [select name, abstract__c from workshop__c where Event__c =: eventId];
    // }

    // @AuraEnabled
    // public static list<session__c> getSessionsForWorkshop(id workshopId){
    //     return [select name, start__c from Session__c where workshop__c =: workshopId];
    // }

    // @AuraEnabled
    // public static registration__c register(id sessionId){
    //     registration__c r = new registration__c();

    //     user u = [select contactId from User where id =: UserInfo.getUserId()];

    //     r.Session__c = sessionId;
    //     if (u.contactId != null){
    //         r.Contact__c = u.contactId;
    //     }

    //     session__c session = [select workshop__c from session__c where id =: sessionId];
    //     list<registration__c> dupes = [select id, session__r.workshop__c from registration__c where session__r.workshop__c =: session.workshop__c and contact__c =: u.contactId];

    //     if (!dupes.isEmpty()){
    //         throw new AuraHandledException('You have already registered for a session for this workshop.  To change, cancel the other registration first');
    //     }

    //     insert r;
    //     return r;
    // }

    // // call on anything changing to cancelled
    // public static void registrationWaitlistHander(id sessionId){
    //     // just grab all the registrations for this workshop
    //     session__c session = [select name, Attendees_Allowed__c from session__c];
    //     list<registration__c> regs = [select status__c, Waitlist_Order__c from registration__c where session__c =: sessionId and status__c != 'Cancelled'];

    //     integer waitCount = 0;
    //     integer regCount = 0;

    //     for (registration__c reg:regs){
    //         if (reg.Status__c == 'Registered'){
    //             regCount++;
    //         } else  if (reg.Status__c == 'Waitlist'){
    //             waitCount++;
    //         }
    //     }

    //     id nextInLine;
    //     integer nextInLineNumber;

    //     list<registration__c> regsToUpdate = new list<registration__c>();

    //     // are there more slots open than registrations, and waitlist exists
    //     while (waitCount > 0 && regCount < session.Attendees_Allowed__c){
    //         for (registration__c reg:regs){
    //             if (reg.status__c == 'Waitlist'){
    //                 if (nextInLine == null){
    //                     nextInLine = reg.Id;
    //                     nextInLineNumber = integer.valueOf(reg.Waitlist_Order__c);
    //                 } else if (reg.Waitlist_Order__c < nextInLineNumber){
    //                     nextInLine = reg.Id;
    //                     nextInLineNumber = integer.valueOf(reg.Waitlist_Order__c);
    //                 }
    //             }
    //         }

    //         // move up the lowest number from the waitlist
    //         for (registration__c reg:regs){
    //             if (reg.Id == nextInLine){
    //                 reg.Status__c = 'Registered';
    //                 reg.Waitlist_Order__c = null;
    //                 regsToUpdate.add(reg);
    //             }
    //         }

    //         waitCount++;
    //         regCount--;
    //     }

    //     update regsToUpdate;

    //     //renumber the remaining waitlist if any
    //     waitlistRenumber(sessionId);
    // }

    // public static void waitlistRenumber(id sessionId){

    //     list<registration__c> regs = [select status__c, Waitlist_Order__c from registration__c where session__c =: sessionId and status__c != 'Waitlist' Order by Waitlist_Order__c ASC];

    //     for (integer k = 0; k<regs.size(); k++){
    //         regs[k].Waitlist_Order__c = k+1;
    //     }

    //     update regs;

    // }
}