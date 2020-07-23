/**
 * Author: Prakash 
 * Description: It is test the Rest callout outbound
 * CreatedDate : July 20, 2020
 */
public with sharing class SFDCStopCallout {

    // Method to hit SFDC Stop Blogs and get the response
    public static HTTPResponse getBlogs() {
        // Creating the instance of HTTP class
        HTTP http = new HTTP();
        // Creating the instance of HTTP Request class
        HTTPRequest request = new HTTPRequest();
        // setting up the endpoint and method for the Http request
        request.setEndPoint('https://sfdcstop.herokuapp.com/blogs');
        request.setMethod('GET');

        // Hitting the API and getting the response
        HttpResponse response = http.send(request);

        // Checking the response state
        if(response.getStatusCode() == 200) {
            SFDCStopBlogsWrapper responseWrapper = SFDCStopBlogsWrapper.parse(response.getBody());

            // Displaying the author information
            System.debug('Author : ' + responseWrapper.author);

            if(responseWrapper.blogs != null && !responseWrapper.blogs.isEmpty()) {

                // Loop to iterate over the responsewrapper
                for(Integer i=0; i<responseWrapper.blogs.size(); i++) {
                    SFDCStopBlogsWrapper.Blogs blog = responseWrapper.blogs.get(i);
                    System.debug('Blog Id : ' + blog.Id);
                    System.debug('Blog Title : ' + blog.title);
                    System.debug('Blog URL : ' + blog.url);
                }
            }
        }
        
        return response;
    }
}