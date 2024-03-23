@isTest
private class ContactTeamsControllerTest {
    @isTest
    static void testGetContactShares() {
        Contact contactRecord = new Contact(LastName = 'Test Contact');
        insert contactRecord;

        // Create a test user
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

        Contact_Team__c contactTeamRecord = new Contact_Team__c(
            Contact__c = contactRecord.Id,
            User__c = testUser.Id,
            Access__c = 'Read',
            Role__c = 'Manager'
        );
        insert contactTeamRecord;

        Test.startTest();
        List<Contact_Team__c> result = ContactTeamsController.getContactShares(contactRecord.Id);
        Test.stopTest();

        System.assertEquals(1, result.size());
    }

    @isTest
    static void testDeleteContactShares() {
        Contact contactRecord = new Contact(LastName = 'Test Contact');
        insert contactRecord;

        // Create a test user
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

        Contact_Team__c contactTeamRecord = new Contact_Team__c(
            Contact__c = contactRecord.Id,
            User__c = testUser.Id,
            Access__c = 'Read',
            Role__c = 'Manager'
        );
        insert contactTeamRecord;

        Test.startTest();
        ContactTeamsController.deleteContactShares(contactTeamRecord.Id);
        Test.stopTest();

        List<Contact_Team__c> deletedContactTeams = [SELECT Id FROM Contact_Team__c WHERE Id = :contactTeamRecord.Id];
        System.assertEquals(0, deletedContactTeams.size());
    }

    @isTest
    static void testGetSchemaData() {
        Test.startTest();
        Map<String, Object> schemaData = ContactTeamsController.getSchemaData();
        Test.stopTest();

        List<Map<String, String>> roles = (List<Map<String, String>>) schemaData.get('Role');
        List<Map<String, String>> accesses = (List<Map<String, String>>) schemaData.get('Access');
        List<Map<String, String>> users = (List<Map<String, String>>) schemaData.get('User');
    }

    @isTest
    static void testSaveContactTeams() {
        Contact contactRecord = new Contact(LastName = 'Test Contact');
        insert contactRecord;
        // Create a test user
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
        List<ContactTeamsController.ContactInfo> contactTeams = new List<ContactTeamsController.ContactInfo>();
        ContactTeamsController.ContactInfo contactTeam = new ContactTeamsController.ContactInfo();
        contactTeam.User = testUser.Id;
        contactTeam.Access = 'Read';
        contactTeam.Role = 'Manager';
        contactTeams.add(contactTeam);

        Test.startTest();
        ContactTeamsController.saveContactTeams(JSON.serialize(contactTeams), contactRecord.Id);
        Test.stopTest();

        List<Contact_Team__c> savedContactTeams = [SELECT Id FROM Contact_Team__c WHERE Contact__c = :contactRecord.Id];
        System.assertEquals(1, savedContactTeams.size());
    }
}
