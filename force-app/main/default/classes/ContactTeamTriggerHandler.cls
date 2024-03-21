public with sharing class ContactTeamTriggerHandler {
    
    public static void createContactShareRecords(List<Contact_Team__c> triggerNew, Map<Id, Contact_Team__c> triggerMap){
        if(triggerNew.isEmpty() && triggerMap.isEmpty()) {
            return;
        }
        List<ContactShare> contactShares = new List<ContactShares>();
        for(Contact_Team__c contactTeam : TriggerNew){
            ContactShare contactShare = new ContactShare(
                ContactId = contactId,
                UserOrGroupId = userId,
                ContactAccessLevel = accessLevel
            );
            contactShares.add(contactShare);
            
        }
        if(!contactShares.isEmpty()){
            insert contactShares;
        }
    }

    public static void updateContactShareRecords(List<Contact_Team__c> triggerNew, Map<Id, Contact_Team__c> triggerMap) {
        if(triggerNew.isEmpty() && triggerMap.isEmpty()) {
            return;
        }
        List<ContactShare> contactShares = new List<ContactShares>();
        for(Contact_Team__c contactTeam : TriggerNew){
            ContactShare contactShare = new ContactShare(
                ContactId = contactId,
                UserOrGroupId = userId,
                ContactAccessLevel = accessLevel
            );
            contactShares.add(contactShare);
            
        }
        if(!contactShares.isEmpty()){
            update contactShares;
        }
    }
}