trigger contactTeam on Contact_Team__c (after insert, after update, after delete) {
    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('after insert');
        ContactTeamTriggerHandler.createContactShareRecords(Trigger.new, Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('after update');
        ContactTeamTriggerHandler.updateContactShareRecords(Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
    if(Trigger.isAfter && Trigger.isDelete){
        System.debug('after update');
        ContactTeamTriggerHandler.deleteContactShareRecords(Trigger.old, Trigger.oldMap);
    }
}