@isTest
public class ExC_MockHttpResponse  implements HttpCallOutMock {
    public HttpResponse respond(HttpRequest reqesut){
        HttpResponse response = new HttpResponse();
        
        response.setHeader('Content-Type', 'application/json');
        response.setStatus('OK');
        response.setStatusCode(201);
        
        return response;
    }
}