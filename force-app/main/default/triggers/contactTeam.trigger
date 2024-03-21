trigger contactTeam on Contact_Team__c (before insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        ContactTeamTriggerHandler.createContactShareRecords(Trigger.new, Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        ContactTeamTriggerHandler.updateContactShareRecords(Trigger.new, Trigger.newMap);
    }
}