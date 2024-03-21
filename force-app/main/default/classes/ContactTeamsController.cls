public with sharing class ContactTeamsController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact_Team__c> getContactShares(String contactId) {
        return [
            SELECT Id, Contact__c, User__c, Access__c, Role__c
            FROM Contact_Team__c
            WHERE Contact__c = :contactId
        ];
    }
    @AuraEnabled
    public static void deleteContactShares(String Id) {
        System.debug('Id '+Id);
        List<Contact_Team__c> contactTeam = [SELECT Id FROM Contact_Team__c WHERE Id = :Id LIMIT 1];
        try {
            delete contactTeam;
        } catch (DmlException e) {
            System.debug('An error occurred while deleting the account: ' + e.getMessage());
        }

    }

    public static List<Map<String, String>> getUserMap() {
        List<User> users = [SELECT Id, Name FROM USER WITH SECURITY_ENFORCED LIMIT 10];
        
        List<Map<String, String>> userOptions = new List<Map<String, String>>();
        for (User user: users) {
            userOptions.add(new Map<String, String>{'label' => user.Name, 'value' => user.Id});
        }

        return userOptions;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getSchemaData() {
        List<Map<String, String>> role = new List<Map<String, String>>();
        role.add(new Map<String, String>{'label' => 'Manager', 'value' => 'Manager'});
        role.add(new Map<String, String>{'label' => 'Agent', 'value' => 'Agent'});
        role.add(new Map<String, String>{'label' => 'Intern', 'value' => 'Intern'});
        
        List<Map<String, String>> access = new List<Map<String, String>>();
        access.add(new Map<String, String>{'label' => 'Read', 'value' => 'Read'});
        access.add(new Map<String, String>{'label' => 'Edit', 'value' => 'Edit'});

        List<Map<String, String>> user = getUserMap();

        Map<String, Object> schemaMap = new Map<String, Object>{
            'Role' => role,
            'Access'=> access,
            'User'=> user
        };

        return schemaMap;
    }
    
    @AuraEnabled
    public static void saveContactTeams(String contactTeams, Id contactId){
        try {
            if(!String.isBlank(contactTeams)){
                List<Contact_Team__c> newContactTeams = new List<Contact_Team__c>();
                List<ContactInfo> contactShares = (List<ContactInfo>)JSON.deserialize(contactTeams, List<ContactInfo>.class);
                
                for (ContactInfo contactTeam : contactShares) {
                    Contact_Team__c newContactTeam = new Contact_Team__c(
                        Id = !String.isBlank(contactTeam.Id) ? contactTeam.Id : null,
                        Contact__c = contactId, 
                        User__c = contactTeam.User, 
                        Access__c = contactTeam.Access,
                        Role__c = contactTeam.Role
                    );
                    newContactTeams.add(newContactTeam);
                }
                if(!newContactTeams.isEmpty()) {
                    upsert newContactTeams;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static void shareContactWithUser(String contactId, String userId, String accessLevel) {
        ContactShare contactShare = new ContactShare();
        contactShare.ContactId = contactId;
        contactShare.UserOrGroupId = userId;
        contactShare.ContactAccessLevel = accessLevel;
        insert contactShare;
    }

    public class ContactInfo {
        public String Id;
        public String User;
        public String Role;
        public String Access;
    }
    
}