public class ExC_FileDownloadController {

    public static final String WRONG_PASSWORD_MESSAGE = 'That wasn\'t the right password.';
    public static final String CANNOT_ACCESS_MESSAGE = 'Can\'t access content delivery';
    
    @AuraEnabled
    public static Boolean checkPassword(String id, String pass){
        String url = System.Label.ExC_ContentDistributionDomain + '/sfc/p/' + id;
        Http h = new Http();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        
        //make body
        Map<String, String> params =  new Map<String, String>();
        Map<String, String> encodedParams = new Map<String, String>();
        String body = '';
        params.put('compositePageName', id);
        params.put('dpt', pass);
        for (String name : params.keySet()) {
            if (params.get(name) != null) {
                String value = params.get(name);
                body += '&' + name + '=' + EncodingUtil.urlDecode(value, 'utf-8');
            }
        }
        req.setBody(body.substring(1));
        HttpResponse res = h.send(req);

        Boolean isWrongPass = res.getBody().contains(WRONG_PASSWORD_MESSAGE);
        Boolean isCannotAccess = res.getBody().contains(CANNOT_ACCESS_MESSAGE);
        return !(isWrongPass || isCannotAccess);

    }

}