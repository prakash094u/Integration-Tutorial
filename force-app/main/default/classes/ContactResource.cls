/*
* Author: Prakash
* Created Date: July 16, 2020
* Description: This used to test the Rest API Methods
*/

// Setting up the Request URL
@RestResource(urlMapping='/contactAPI/*')
global with sharing class ContactResource {

    // Get Method
    @HttpGet
    global static List<Contact> getContactIdAndNames() {
        // Initialize the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        //Get the request URI
        String contactRequestURI = contactRequest.requestURI;
        // Getting the limit from the request URI
        Integer contactLimit = Integer.valueOf(contactRequestURI.substring(contactRequestURI.lastIndexOf('/') + 1));

        // Querying the Contacts
        List<Contact> contacts = [SELECT ID, Name FROM Contact LIMIT : contactLimit];

        return contacts;
    }
    
    // Post Method
    @HttpPost
    global static Contact createContact(String firstName, String lastName, String birthDate, String leadSource) {
       // Create contact 
        Contact contact     = new Contact(
            FirstName       = firstName,
            LastName        = lastName,
            BirthDate       = Date.parse(birthDate),
            LeadSource      = leadSource 
        );

        insert contact;

        return contact;
    }

    // Delete Method
    @HttpDelete
    global static Map<String, String> deleteContact() {
        // Initializing the response map
        Map<String, String> responseMap = new Map<String, String>();
        // Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the request URI
        string contactRequestURI = contactRequest.requestURI;
        System.debug('Contact Request URI : ' + contactRequestURI);

        // Getting teh contact Id from the request URI
        Id contactId = Id.valueOf(contactRequestURI.substring(contactRequestURI.lastIndexOf('/')+1));

        //Initializng contact to delete
        Contact contact = new Contact(Id=contactId);
        // Deleting the Contact
        try {
            delete contact;
            responseMap.put('success', '1');
            responseMap.put('message', 'Record Deleted successfully');
        } catch(DmlException e) {
            responseMap.put('Failed', '0');
            responseMap.put('message', e.getMessage());
        }

        return responseMap;
    }

       //PUT Method
       @HTTPPut
       global static Contact upsertContact(String firstName, String lastName, String birthDate, String leadSource) {
           // Initializing the request parameter with the incoming request
           RestRequest contactRequest = RestContext.request;
           //Getting the request URI
           String contactRequestURI = contactRequest.requestURI;
           // Getting the contact Id from the Request URI
           String contactId = contactRequestURI.substring(contactRequestURI.lastIndexOf('/')+1);
           // Initializing the contact to upsert
           Contact contact = new Contact();
           // Condition to check the contact Id 
           if(String.isNotEmpty(contactId)) {
               contact.Id = contactId;
           }
           contact.FirstName = firstName;
           contact.LastName = lastName;
           contact.BirthDate = Date.parse(birthDate);
           contact.LeadSource = leadSource;
   
           upsert contact;
           
           return contact;
   
       }

    // Patch Method
    @HttpPatch
    global static Contact updateContact() {
        // Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the request URI
        String contactRequestURI = contactRequest.requestURI;
        // Getting the contact Id from the Request URI
        String contactId = contactRequestURI.substring(contactRequestURI.lastIndexOf('/') + 1);
        // Getting the request body from the request
        String requestBody = contactRequest.requestBody.toString();

    
        // Creating the contact object
        Contact contact;
        // Checking if the contact Id obtained from the URL is not empty
        if(String.isNotEmpty(contactId)) {
            contact = (contact) JSON.deserialize(requestBody, Contact.class);

            //Assigning the contact Id
            contact.Id = contactId;
            update contact;
        }

        return contact;
    }
}