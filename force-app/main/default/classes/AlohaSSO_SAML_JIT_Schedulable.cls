global with sharing class AlohaSSO_SAML_JIT_Schedulable implements Schedulable {

    global void execute(SchedulableContext SC){
        AlohaSSO_SAML_JIT_UserCleanup UC = new AlohaSSO_SAML_JIT_UserCleanup();
        database.executeBatch(UC);
    }
}