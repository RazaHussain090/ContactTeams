public without sharing class ContactTeamTriggerHandler {
    
    public static void createContactShareRecords(List<Contact_Team__c> triggerNew, Map<Id, Contact_Team__c> triggerMap){
        if(triggerNew.isEmpty() && triggerMap.isEmpty()) {
            return;
        }
        List<ContactShare> contactShares = new List<ContactShare>();
        for(Contact_Team__c contactTeam : TriggerNew){
            ContactShare contactShare = new ContactShare(
                ContactId = contactTeam.Contact__c,
                UserOrGroupId = contactTeam.User__c,
                ContactAccessLevel = contactTeam.Access__c,
                RowCause = 'Manual'
            );
            contactShares.add(contactShare);
        }
        if(!contactShares.isEmpty()){
            insert contactShares;
        }
    }

    public static void updateContactShareRecords(List<Contact_Team__c> triggerNew, Map<Id, Contact_Team__c> triggerNewMap, Map<Id, Contact_Team__c> triggerOldMap) {
        if(triggerNew.isEmpty() && triggerNewMap.isEmpty()) {
            return;
        }
        Set<Id> contactIds = new Set<Id>();
        for (Contact_Team__c contactTeam : triggerNew) {
            contactIds.add(contactTeam.Contact__c); 
        }
        if(contactIds.isEmpty()) {
            return;
        }

        List<ContactShare> contactShares = [SELECT Id, ContactId, UserOrGroupId, ContactAccessLevel, RowCause FROM ContactShare WHERE ContactId IN :contactIds];

        Map<Id, ContactShare> contactShareMap = new Map<Id, ContactShare>(); 
        for(ContactShare contactShare : contactShares) {
            contactShareMap.put(contactShare.ContactId, contactShare);
        }

        System.debug('executed updateContactShareRecords');
        List<ContactShare> updatedContactShares = new List<ContactShare>();
        for(Contact_Team__c contactTeam : TriggerNew){
            ContactShare contactShare = contactShareMap.get(contactTeam.Contact__c);
            //System.debug('1 '+triggerNewMap.get(contactTeam.Id).User__c != triggerOldMap.get(contactTeam.Id).User__c);
            if(triggerNewMap.get(contactTeam.Id).User__c != triggerOldMap.get(contactTeam.Id).User__c ) {
                contactTeam.Contact__c.addError('Please Create a new record for the Contact.');
            }
            if(triggerNewMap.get(contactTeam.Id).Access__c != triggerOldMap.get(contactTeam.Id).Access__c) {
                contactShare.ContactAccessLevel = contactTeam.Access__c;
            }

            if(!updatedContactShares.contains(contactShare))
                updatedContactShares.add(contactShare);
            
        }
        if(!updatedContactShares.isEmpty()){
            update updatedContactShares;
        }
    }

    public static void deleteContactShareRecords(List<Contact_Team__c> triggerOld, Map<Id, Contact_Team__c> triggerOldMap) {
        if(triggerOld.isEmpty() && triggerOldMap.isEmpty()) {
            return;
        }
        Set<Id> contactIds = new Set<Id>();
        for (Contact_Team__c contactTeam : triggerOld){
            contactIds.add(contactTeam.Contact__c); 
        }
        if(contactIds.isEmpty())
        {
            return;
        }
        List<ContactShare> contactShares = [SELECT Id, ContactId, UserOrGroupId, ContactAccessLevel, RowCause FROM ContactShare WHERE ContactId IN :contactIds];

        List<ContactShare> deleteContactShare = new List<ContactShare>();

        Map<Id, ContactShare> contactShareMap = new Map<Id, ContactShare>(); 
        for(ContactShare contactShare : contactShares) {
            contactShareMap.put(contactShare.ContactId, contactShare);
        }


        if(!contactShares.isEmpty()) {
            for(Contact_Team__c contactTeam : triggerOld) {
                if(contactShareMap.get(contactTeam.Contact__c).UserOrGroupId == contactTeam.User__c) {
                    deleteContactShare.add(contactShareMap.get(contactTeam.Contact__c));
                }
            }
        }
        if(!deleteContactShare.isEmpty()) {
            delete deleteContactShare;
        }
    }
}