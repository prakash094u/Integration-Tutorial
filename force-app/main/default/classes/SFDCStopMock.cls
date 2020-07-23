@isTest
global  class SFDCStopMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

        // Setting the response body
        response.setBody('{"author":"Rahul Malhotra","blogs":[{"id":"1","title":"Salesforce Integration Tutorial Part1 - Introduction and Setting up Workbench","url":"https://www.sfdcstop.com/2019/11/salesforce-integration-tutorial-part-1.html"},{"id":"2","title":"Salesforce Integration Tutorial Part 2 - Exploring GET Method","url":"https://www.sfdcstop.com/2019/11/salesforce-integration-tutorial-part-2.html"}]}');
        // setting the response header
        response.setHeader('Content-Type', 'application/JSON');
       // Setting the response code
        response.setStatusCode(200);
        // returning the response
        return response;
    }
}