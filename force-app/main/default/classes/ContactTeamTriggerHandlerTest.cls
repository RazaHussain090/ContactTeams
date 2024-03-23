@isTest
private class ContactTeamTriggerHandlerTest {
    @isTest
    static void testCreateContactShareRecords() {
        Contact contactRecord = new Contact(LastName = 'Test Contacts');
        insert contactRecord;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; // Or any other profile
        User testUser = new User(
            ProfileId = p.Id,
            LastName = 'Test',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'testU',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        List<Contact_Team__c> contactTeams = new List<Contact_Team__c>();
        contactTeams.add(new Contact_Team__c(
            Contact__c = contactRecord.Id,
            User__c = testUser.Id,
            Access__c = 'Read'
        ));

        Test.startTest();
        ContactTeamTriggerHandler.createContactShareRecords(contactTeams, new Map<Id, Contact_Team__c>());
        Test.stopTest();
    }

    @isTest
    static void testUpdateContactShareRecords() {
        Contact contactRecord = new Contact(LastName = 'Test Contact');
        insert contactRecord;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; // Or any other profile
        User testUser = new User(
            ProfileId = p.Id,
            LastName = 'Test',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'testU',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        Contact_Team__c contactTeam = new Contact_Team__c(
            Contact__c = contactRecord.Id,
            User__c = testUser.Id,
            Access__c = 'Read'
        );
        insert contactTeam;

        contactTeam.Access__c = 'Edit';

        Test.startTest();
        ContactTeamTriggerHandler.updateContactShareRecords(new List<Contact_Team__c>{contactTeam}, new Map<Id, Contact_Team__c>{contactTeam.Id => contactTeam}, new Map<Id, Contact_Team__c>{contactTeam.Id => contactTeam});
        Test.stopTest();
    }

    @isTest
    static void testDeleteContactShareRecords() {
        Contact contactRecord = new Contact(LastName = 'Test Contact');
        insert contactRecord;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; // Or any other profile
        User testUser = new User(
            ProfileId = p.Id,
            LastName = 'Test',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            Alias = 'testU',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;
        Contact_Team__c contactTeam = new Contact_Team__c(
            Contact__c = contactRecord.Id,
            User__c = testUser.Id,
            Access__c = 'Read'
        );
        insert contactTeam;

        Test.startTest();
        ContactTeamTriggerHandler.deleteContactShareRecords(new List<Contact_Team__c>{contactTeam}, new Map<Id, Contact_Team__c>{contactTeam.Id => contactTeam});
        Test.stopTest();
    }
}
