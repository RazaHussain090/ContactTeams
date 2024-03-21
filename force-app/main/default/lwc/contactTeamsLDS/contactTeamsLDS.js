import { LightningElement, wire } from 'lwc';
import { getRecordList } from 'lightning/uiListApi';
import CONTACT_TEAM_OBJECT from '@salesforce/schema/Contact_Team__c';
import USER_FIELD from '@salesforce/schema/Contact_Team__c.User__c';
import ROLE_FIELD from '@salesforce/schema/Contact_Team__c.Role__c';
import ACCESS_FIELD from '@salesforce/schema/Contact_Team__c.Access__c';

export default class ContactTeamsLDS extends LightningElement {

    columns = [
        { label: 'User', fieldName: USER_FIELD.fieldApiName },
        { label: 'Role', fieldName: ROLE_FIELD.fieldApiName },
        { label: 'Access', fieldName: ACCESS_FIELD.fieldApiName }
    ];
    

    @wire(getRecordList, {
        objectApiName: CONTACT_TEAM_OBJECT,
        fields: [USER_FIELD.fieldApiName, ROLE_FIELD.fieldApiName, ACCESS_FIELD.fieldApiName],
        optionalFields: [],
        pageSize: 5
    })
    contacts;


}