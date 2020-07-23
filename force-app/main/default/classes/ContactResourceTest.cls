/**
 * Author: Prakash
 * Description: Creating a test class for the Apex rest callout methods
 * Created Date: July 20, 2020
 */
@isTest
public with sharing class ContactResourceTest {
    @TestSetup
    static void makeData(){
        // Inserting the contact record
        Contact contact =   new Contact(
            FirstName   =  'Test_FirstName',
            LastName    =   'Test_LastName'
        );

        insert contact;
    }

    // Testing the Get Method
    @isTest static void testGetContactIdAndNames() {
        Test.startTest();
       
        // Forming the Request
        RestRequest contactRequest  = new RestRequest();
        contactRequest.requestURI   = 'https://na123.salesforce.com/services/apexrest/contactAPI/1';
        contactRequest.httpMethod   = 'GET';
        RestContext.request         = contactRequest;

        //Testing the API
        List<Contact> contacts = ContactResource.getContactIdAndNames();

        // Confirming the response
        System.assert(contacts != null, 'Contact should not be null');
        System.assertEquals(contacts.size(), 1, 'Result from the Rest Get Request');

        Test.stopTest();
    }

    // Testing the Post method
    @isTest static void testcreateContact() {
        Test.startTest();

        Contact returnedContact = ContactResource.createContact('Test_FirstName', 'Test_LastName', '03/17/2020', 'Web');

        System.assert(returnedContact != null, 'Contact should not be null');
        
        Contact contact = [SELECT ID, LeadSource FROM Contact WHERE Id =: returnedContact.Id];

        System.assert(contact != null, 'Contact should not be null');
        Test.stopTest();
    }

    // Testing the Delete Method
    @isTest static void testDeleteContact() {
        Test.startTest();

        Contact contactToDelete = [SELECT ID FROM Contact LIMIT 1];

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://na123.salesforce.com/services/apexrest/contactAPI/' + contactToDelete.Id;
        contactRequest.httpMethod = 'DELETE';

        RestContext.request = contactRequest;

        //Testing the API
        Map<String, String> responseMap = ContactResource.deleteContact();

        Contact queriedContact = [SELECT ID, IsDeleted FROM Contact WHERE ID =:contactToDelete.Id ALL ROWS];

        System.assertEquals('1', responseMap.get('success'), 'This is for the successful response');
        System.assert(queriedContact.IsDeleted, 'The proves that the record is soft deleted');

        Test.stopTest();
    }

    // Testing the Delete request with exception
    @isTest static void testDeleteContactWithException() {
        Test.startTest();

        Contact contactToDelete = [SELECT ID FROM Contact LIMIT 1];
        Delete contactToDelete;

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://na123.salesforce.com/services/apexrest/contactAPI/' + contactToDelete.Id;
        contactRequest.httpMethod = 'DELETE';

        RestContext.request = contactRequest;
        
        //Test the API
        Map<String, String> responseMap = ContactResource.deleteContact();
        
        System.assertNotEquals('1', responseMap.get('success'), 'This is for the failure response');
 
        Test.stopTest();
    }

    //Testing the upsert
    @isTest static void testUpsertContact() {
        Test.startTest();
        Contact contactToUpsert = [SELECT Id FROM Contact LIMIT 1];

        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://na123.salesforce.com/services/apexrest/contactAPI/' + contactToUpsert.Id;
        contactRequest.httpMethod = 'PUT';
        RestContext.request = contactRequest;

        Contact returnContact = ContactResource.upsertContact('Test_FistName_1', 'Test_LastName_1', '03/18/1992', 'Web');

        Contact queriedContact = [SELECT Name, LeadSource FROM Contact WHERE Id = : contactToUpsert.Id ALL ROWS];
        
        System.assertEquals(contactToUpsert.Id, queriedContact.Id, 'The record is updated and the new record is created');

        Test.stopTest();
    }

    //Testing the update
    @isTest static void testUpdateContact() {
        Test.startTest();

        Contact contactToUpdate  = [SELECT ID FROM Contact LIMIT 1];
        // Updating the contact
        Contact contact = new Contact();
        contact.FirstName= 'Rest_Contact_Update';

        // Forming the request
        RestRequest contactRequest = new RestRequest();
        contactRequest.requestURI = 'https://na123.salesforce.com/services/apexrest/contactAPI/' + contactToUpdate.Id;
        contactRequest.httpMethod = 'PATCH';

        contactRequest.requestBody = Blob.valueOf(JSON.serialize(contact));
        RestContext.request = contactRequest;

        Contact returnedContact = ContactResource.updateContact();

        Contact queriedContact = [SELECT ID, FirstName, LastName FROM Contact WHERE ID = :contactToUpdate.ID];

        System.assertEquals(queriedContact.Id, contactToUpdate.Id, 'This proves that the Integration call is success');
        System.assertEquals('Rest_Contact_Update', queriedContact.FirstName, 'This proves that the contact first Name is updated');

        Test.stopTest();
    }
}