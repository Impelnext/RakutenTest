public with sharing class SMSInfoTriggerHandler {
    static final String URL = 'https://' +  System.Label.SMSAPI_BasicUsername + ':' + System.Label.SMSAPI_BasicPassword + '@www.sms-console.jp/api/?status=1&';
    
    static final String ID = System.Label.SMSAPI_BasicUsername;
    static final String PW = System.Label.SMSAPI_BasicPassword;
    
    static final String SOFTBANKNO = '243000';

    //このメソッドを非同期実行するために、@futureを記述
    @future(callout=true)
    public static void sendMail(Set<Id> idSet){
        
        List<SMSInfo__c> sList = new List<SMSInfo__c>();
        sList = [SELECT id,smsid__c, status__c,DestinationPhoneNumber__c, sendSubject__c, sendContents__c, SenderPhoneNumber__c,SendDateTime__c FROM SMSInfo__c WHERE id in :idSet];
        
        Integer state;
        for(SMSInfo__c sms : sList){
            String esmstext = EncodingUtil.urlEncode(sms.sendContents__c, 'UTF-8');
            String urlstr = URL + 'smsid=' + sms.smsid__c + '&mobilenumber=' + sms.DestinationPhoneNumber__c + '&smstext=' + esmstext;
            
            urlstr += '&docomotitle=' + sms.SenderPhoneNumber__c;
            urlstr += '&autitle=' + sms.SenderPhoneNumber__c;       
            urlstr += '&softbanktitle=' + SOFTBANKNO;
            urlstr += '&rakutentitle=' + sms.SenderPhoneNumber__c;  
                    
            System.debug('■■■■ endpoint:' + urlstr);
    
            HttpRequest req = new HttpRequest();
            req.setEndpoint(urlstr);
            req.setMethod('GET');
        
            String username = ID;
            String password = PW;
    
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' +
            EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
    
            String body;
            Http http = new Http();
            HTTPResponse res = http.send(req);
            state = res.getStatusCode();
            body = res.getBody();
            System.debug('■■■■ body:' + body);
        }

        // 1min待ち
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) <= 10000*6) { // 1min =10秒*6
            finishTime = DateTime.now().getTime();
        }

        // ステータスと送信日時の更新
        List<SMSInfo__c> sList2 = new List<SMSInfo__c>();
            sList2 = [SELECT id,smsid__c, status__c,SendDateTime__c FROM SMSInfo__c WHERE id in :idSet];

        List<SMSInfo__c> updList = new List<SMSInfo__c>();
        for(SMSInfo__c sms : sList2){
            if(sms.status__c == '承認済み' )  sms.status__c  = 'リトライ中';
            if (sms.SendDateTime__c == null ) sms.SendDateTime__c = DateTime.now();
            updList.add(sms);
        }
        if (updList.size()>0){
            try {
                update updList;
            } catch (Exception e) {
                System.debug('■■■ Exception : ' + e.getMessage());
            }
        }
    
    }
}