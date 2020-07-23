@isTest
public with sharing class ContactSoapResourceTest {
    @TestSetup
    static void  prepareTestData(){
        Contact contact = new Contact();
        contact.FirstName = 'Test_FirstName';
        contact.LastName = 'Test_LastName';

        insert contact;
    }

    @isTest static void getContactIdAndNameTest() {
        Test.startTest();
        List<Contact> contacts = ContactSoapResource.getContactIdAndName(1);
        Contact contact = [SELECT ID, Name FROM Contact LIMIT 1];

        System.assert(contacts.size() > 0);
        System.assert(contact != null);
        System.assertEquals(contacts[0].Name, contact.Name, 'The  Name should be same');
        Test.stopTest();

    }
}
