@isTest
global class MockHttpResponse implements HttpCalloutMock {
    // コンストラクタ
    // global HttpResponse respond(HttpRequest req, Integer i) {
    public Integer i {get;set;}
    public String body {get;set;}

    public MockHttpResponse(Integer i) {
        this.i = i;
        this.body = '';
        if (i == 1) {
            this.body = '200中間失敗';
        } else if (i == 2) {
            this.body = '200最終送信済';
        } 
    }

    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody(this.body);
        return res;
    }
}