/**
 * Author: Prakash
 * Created Date: July 16, 2020
 * Description: To handle the multiple parameters from the Rest API integration inbound
 */
// Setting up the URL
@RestResource(urlMapping='/contactAPI1/*')
global with sharing class ContactResource1 {
    
    // GET Method
    @HttpGet
    global static List<Contact> getContactIdNameAndLeadSource() {
        //Initializing the rest parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the URL parameters from the request
        Map<String, String> contactRequestParams = contactRequest.params;
        //Getting the limit and leadsource from the request url params
        Integer contactLimit = Integer.valueOf(contactRequestParams.get('limit'));
        String leadSource = contactRequestParams.get('leadsource');
        //Query on contacts
        List<Contact> contacts = [SELECT Id, Name, leadSource FROM Contact 
                                    WHERE leadSource= :leadsource LIMIT: contactLimit];
        
        return contacts;
    }
    
    // POST Method
    @HttpPost
    global static contact createNewContact() {
        // Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the request body from the request
        String requestBody = contactRequest.requestBody.toString();
        // Deserializing the JSON response body and assigning it to an instnace of contact object
        Contact contact = (Contact) JSON.deserialize(requestBody, Contact.class);

        insert contact;
        return contact;
    }

    // Wrapper class
    global class ResponseWrapper {
        String success;
        String message;
    }

    // DELETE Method
    @HttpDelete
    global static List<ResponseWrapper> deleteContacts() {
        // Initializing the response wrapper List
        List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
        // Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the request URI
        String contactRequestURI = contactRequest.requestURI;
        // Getting the contact Id's from the request URI
        String[] contactIds = (contactRequestURI.substring(contactRequestURI.lastIndexOf('/')+1)).split(',');

        // Initializing the contacts List to perform the delete operation
        List<Contact> contactsToDelete = new list<Contact>();

        // Loop to iterate over the list of strings from request URI
        for(String contactId : contactIds) {
            Contact contact = new Contact(Id= contactId);
            contactsToDelete.add(contact);
        }

        // Performing the DML Operation
        Database.DeleteResult[] results = Database.delete(contactsToDelete, false);

        // Loop to iterate over the list of results
        for(Database.DeleteResult result : results) {
            // Initializing the wrapper 
            ResponseWrapper wrapper = new ResponseWrapper();

            // Condition ot check the success result
            if(result.isSuccess()) {
                wrapper.success = '1';
                wrapper.message = 'successfully deleted contact with Id: ' +result.getId();
            } else {
                
                // Delete failed, getting errors and setting up the error message in response wrapper
                wrapper.success = '0';

                for(Database.Error error : result.getErrors()) {
                    wrapper.message = 'The following error has occured for contact with Id : ' +result.getId() + '. ';
                    wrapper.message +=  error.getStatusCode() + ' : ' + error.getMessage();
                    wrapper.message += ' Contact fields that affected this error : ' + error.getFields(); 
                }
            }

            responseWrapperList.add(wrapper); 
        }

        return responseWrapperList;
    }

    // PATCH Method
    @HttpPatch
    global static List<ResponseWrapper> updateContacts() {
        // Initializing the response wrapper list
        List<ResponseWrapper> responseWrapperList = new List<ResponseWrapper>();
        // Initializing the request parameter with the incoming request
        RestRequest contactRequest = RestContext.request;
        // Getting the request body from the request
        String requestBody = contactRequest.requestBody.toString();
        // Deserializing the JSON request body and initializing the list of contact to update
        List<Contact> contacts = (List<Contact>) JSON.deserialize(requestBody, List<Contact>.class);

        // Updating the contacts with partial success enabled
        Database.SaveResult[] results = Database.update(contacts, false);

        // Loop to iterate over the list of results
        for(Database.SaveResult result : results) {
            // Initializing the response wrapper
            ResponseWrapper wrapper = new ResponseWrapper();

            // condition to check for the success result
            if(result.isSuccess()) {

                // Update successful, Setting up the appropriate message in response wrapper
                wrapper.success = '1';
                wrapper.message = 'Successfully updated contact with Id : ' +result.getId();
            } else {
                wrapper.success = '0';
                for(Database.Error error : result.getErrors()) {
                    wrapper.message = 'The following error has occured for contact with Id : ' + result.getId() + '. ';
                    wrapper.message += error.getStatusCode() + ': ' +  error.getMessage();
                    wrapper.message += ' Contact fields that affected this error : ' + error.getFields();
                }
            }

            responseWrapperList.add(wrapper);
        }

        return responseWrapperList;
    }
}