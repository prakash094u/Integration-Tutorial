@isTest
public with sharing class SFDCStopCalloutTest {
    public static Integer RESPONSE_CODE = 200;
    public static String RESPONSE_HEADER_KEY = 'Content-Type';
    public static String RESPONSE_HEADER_VALUE = 'application/JSON';
    public static string RESPONSE_BODY = '{"author":"Rahul Malhotra","blogs":[{"id":"1","title":"Salesforce Integration Tutorial Part1 - Introduction and Setting up Workbench","url":"https://www.sfdcstop.com/2019/11/salesforce-integration-tutorial-part-1.html"},{"id":"2","title":"Salesforce Integration Tutorial Part 2 - Exploring GET Method","url":"https://www.sfdcstop.com/2019/11/salesforce-integration-tutorial-part-2.html"}]}';


    @isTest static void testGetBlogs() {
        Test.startTest();
        // setting the mock response
        Test.setMock(HttpCalloutMock.class, new SFDCStopMock());
        // performing the API callout
        HttpResponse response = SFDCStopCallout.getBlogs();

        System.assertEquals(response.getStatusCode(), RESPONSE_CODE, 'The status code should be 200');
        System.assertEquals(response.getHeader(RESPONSE_HEADER_KEY), RESPONSE_HEADER_VALUE, 'The is the header key');
        System.assertEquals(response.getBody(), RESPONSE_BODY, 'This is the actual response body');

        Test.stopTest();

    }
}