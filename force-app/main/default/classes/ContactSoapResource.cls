global with sharing class ContactSoapResource {
    webservice static List<Contact> getContactIdAndName(Integer contactLimit) {
        List<Contact> contacts = [SELECT ID, Name, BirthDate, Phone FROM Contact LIMIT : contactLimit];

        return contacts;
    }
}
