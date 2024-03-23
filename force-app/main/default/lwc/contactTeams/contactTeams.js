import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import saveContactTeams from '@salesforce/apex/ContactTeamsController.saveContactTeams';
import getContactShares from '@salesforce/apex/ContactTeamsController.getContactShares';
import getSchemaData from '@salesforce/apex/ContactTeamsController.getSchemaData';
import deleteContactShares from '@salesforce/apex/ContactTeamsController.deleteContactShares';
export default class ContactTeams extends LightningElement {
    contactId;
    @track contacts;

    roleOptions;
    accessOptions;
    userOptions;
    schema;

    @wire(CurrentPageReference)
    pageRef;

    @wire(getSchemaData)
    wiredSchema({ error, data }) {
        if (data) {
            this.schema = data;
            console.log(JSON.stringify(this.schema));
            this.roleOptions = this.schema['Role'];
            this.accessOptions = this.schema['Access'];
            this.userOptions = this.schema['User'];
        } else if (error) {
            // Handle errors here
            console.error(error);
        }
    }
    

    connectedCallback(){
        this.contactId = this.pageRef?.state?.c__recordId;
        try{
            /*getSchemaData()
                .then((result) => {
                    console.log('schema initiated');
                    this.schema = result;
                    console.log(JSON.stringify(this.schema));
                    this.roleOptions = this.schema['Role'];
                    this.accessOptions = this.schema['Access'];
                    this.userOptions = this.schema['User'];
                    //this.contacts = [...this.contacts];
                })
                .catch((error) => {
                    error = error;
                    console.log('error '+error);
                });*/
                this.updateContactTeams();
        }catch(e){
            console.log('error '+e);
        }       
    }

    updateContactTeams(){
        getContactShares({contactId: this.contactId})
        .then((result) => {
            console.log('data initiated');
            this.schema = result;
            console.log(JSON.stringify(result));
            let length = 1;
            if(result){
                const newContactTeams = result.map(contactTeams => ({
                    Id: contactTeams.Id,
                    RId: String(length++),
                    User: contactTeams.User__c,
                    Role: contactTeams.Role__c,
                    Access: contactTeams.Access__c
                }));
                this.contacts = newContactTeams;
                console.log('contacts '+JSON.stringify(this.contacts));
            }
            
        })
        .catch((error) => {
            error = error;
            console.log('error '+error);
        });
    }

    addContact() {
        const newContact = {
            RId: String(this.contacts.length + 1),
            User: '',
            Role: '',
            Access: ''
        };
        this.contacts = [...this.contacts, newContact];
    }
    deleteContact(event) {
        const contactId = event.currentTarget.dataset.id;
        this.contacts = this.contacts.filter(contact => contact.Id !== contactId);
        console.log('dataset.id '+JSON.stringify(event.currentTarget.dataset));
        deleteContactShares({Id: event.currentTarget.dataset.id})
        .then((result) => {
            console.log('Successfully Deleted');
            this.updateContactTeams();
        }) .catch((error) => {
            error = error;
            console.log('error '+JSON.stringify(error));
        }); 
    }
    
    handleUserChange(event) {
        const contactId = event.target.dataset.id;
        const newUser = event.detail.recordId;
        
        console.log('Selected record:' +event.detail.recordId);

        const contact = this.contacts.find(contact => contact.Id === contactId);
        if (contact) {
            contact.User = newUser;
        }
        console.log(JSON.stringify(this.contacts));
        
        this.contacts = [...this.contacts];
    }

    handleRoleChange(event) {
        const contactId = event.target.dataset.id;
        const newRole = event.detail.value;
        
        const contact = this.contacts.find(contact => contact.Id === contactId);
        if (contact) {
            contact.Role = newRole;
        }
        console.log(JSON.stringify(this.contacts));
        
        this.contacts = [...this.contacts];
    }
    handleAccessChange(event) {
        const contactId = event.target.dataset.id;
        const newAccess = event.detail.value;
        
        const contact = this.contacts.find(contact => contact.Id === contactId);
        if (contact) {
            contact.Access = newAccess;
        }
        console.log(JSON.stringify(this.contacts));
        
        this.contacts = [...this.contacts];
    }

    handleSave(event) {
        saveContactTeams({ contactTeams: JSON.stringify(this.contacts), contactId: this.contactId })
        .then((result) => {
            console.log('Successfully Saved');
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact Team Members saved successfully',
                    variant: 'success'
                })
            );
            this.updateContactTeams();
        })
        .catch((error) => {
            error = error;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Failure',
                    message: 'Contact Team Members does not saved succesffuly',
                    variant: 'error'
                })
            );
            console.log('error '+JSON.stringify(error));
        });
    }
    handleCancel(event) {
    }

    
}