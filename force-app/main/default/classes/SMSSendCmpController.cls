public with sharing class SMSSendCmpController {

    //static final String URL = 'https://RIPtestIM:testIM%@www.sms-console.jp/api/?status=1&';
    static final String URL = 'https://' +  System.Label.SMSAPI_BasicUsername + ':' + System.Label.SMSAPI_BasicPassword + '@www.sms-console.jp/api/?status=1&';
    
    // static final String ID = 'RIPtestIM'; // for TEST
    // static final String PW = 'testIM%'; // for TEST
    //static final String ID = 'rakuten-life_api';
    //static final String PW = 'CA9XzTVS';
    static final String ID = System.Label.SMSAPI_BasicUsername;
    static final String PW = System.Label.SMSAPI_BasicPassword;

    static final String C_STATUS_SHITAGAKI = '下書き';
    static final String C_STATUS_OK = '送信済み(成功)';
    static final String C_STATUS_RETRY = 'リトライ中';
    
    static final String SOFTBANKNO = '243000';

    /**
     * sendSMS SMS送信
     */
    @AuraEnabled
    public static String sendSMS(String smsinfoId) {

        System.debug('■■■ called sendSMS');

        String msg;
        String body;
        Integer err;

        System.debug('■■■ sendSMS smsinfoId:' + smsinfoId);
        if (!String.isEmpty(smsinfoId)) {

//            err = checkError(smsinfoId);

//            if (err != 0) {
//                return String.valueOf(err);
//            }

            try {
                SMSInfo__c sms = [ SELECT id, IsDeleted, Name, status__c, DestinationPhoneNumber__c, ContractorFurigana__c,
                    Sender__c, SenderPhoneNumber__c, SendSubject__c, SendContents__c, SendDateTime__c,
                    SendResult__c, Branch_smsid__c, smsid__c, SMSPermissionFlg__c, Account__c, DifferentPhoneNumber__c
                    FROM SMSInfo__c WHERE Id =: smsinfoId Limit 1 ];

                msg = '0';
                System.debug('■■■ smsid__c : ' + sms.smsid__c);
                System.debug('■■■ DestinationPhoneNumber__c : ' + sms.DestinationPhoneNumber__c);
                System.debug('■■■ sendSubject__c : ' + sms.sendSubject__c);
                System.debug('■■■ sendContents__c : ' + sms.sendContents__c);
                System.debug('■■■ SenderPhoneNumber__c : ' + sms.SenderPhoneNumber__c);

// 2020/10/05 MODIFIED BY)IM.TANAKA
                // body = basicAuthCallout(sms.smsid__c, sms.DestinationPhoneNumber__c, sms.sendSubject__c, sms.sendContents__c);
                body = basicAuthCallout(sms.smsid__c, sms.DestinationPhoneNumber__c, sms.sendSubject__c, sms.sendContents__c, sms.SenderPhoneNumber__c);

            } catch (Exception e) {
                System.debug('■■■ Exception : ' + e.getMessage());
            }
        }
        System.debug('■■■ ' + msg);
        System.debug('■■■ ' + body);
        return msg;
    }

    /**
     * checkSMS 送信日時更新
     */
    @AuraEnabled
    public static String checkSMS(String smsinfoId) {
        System.debug('■■■ called checkSMS');

        String msg;
        String body;

        System.debug('■■■ checkSMS smsinfoId:' + smsinfoId);
        if (!String.isEmpty(smsinfoId)) {

            try {
                SMSInfo__c sms = [ SELECT id, IsDeleted, Name, status__c, DestinationPhoneNumber__c, ContractorFurigana__c,
                    Sender__c, SenderPhoneNumber__c, SendSubject__c, SendContents__c, SendDateTime__c,
                    SendResult__c, Branch_smsid__c, smsid__c, SMSPermissionFlg__c, Account__c, DifferentPhoneNumber__c
                    FROM SMSInfo__c WHERE Id =: smsinfoId Limit 1 ];

                msg = sms.status__c;
                if (sms.status__c == '下書き' || sms.status__c == '承認済み') {
                    sms.status__c  = 'リトライ中';
                }
                if (sms.SendDateTime__c == null)
                    sms.SendDateTime__c = DateTime.now();
                update sms;
                System.debug('■■■ ' + msg);
            } catch (Exception e) {
                System.debug('■■■ Exception : ' + e.getMessage());
            }
        }
        return msg;
    }

    /**
     * checkERROR エラーチェック
     */
    @AuraEnabled
    public static Integer checkError(String smsinfoId) {
        System.debug('■■■ called checkERROR');

        Integer error;
        String body;

        error = 0;
        if (!String.isEmpty(smsinfoId)) {
            System.debug('■■■ smsinfoId' + smsinfoId);

            try {
                SMSInfo__c sms = [ SELECT id, IsDeleted, Name, status__c, SMSPermissionFlg__c, SendContents__c
                    FROM SMSInfo__c WHERE Id =: smsinfoId Limit 1 ];
                System.debug('■■■ soql OK');

                /*
                * 承認済み、送信済（失敗）は、処理中断せず送信処理する
                */
                if (sms == null) {
                    error = 1;
                } else if (sms.status__c == C_STATUS_SHITAGAKI) {
                    error = 2; //下書き
                } else if (sms.status__c == C_STATUS_OK) {
                    error = 3; // 送信済(成功)
                } else if (sms.status__c == C_STATUS_RETRY) {
                    error = 4; // リトライ中
                } else if (sms.SMSPermissionFlg__c == false) {
                    error = 5; // フラグ許可なし
                } else if (sms.SendContents__c == null) {
                    error = 6; // メッセージなし
                }
                System.debug('■■■ ' + String.valueOf(error));
            } catch (Exception e) {
                error = 1; // オブジェクトエラー
                System.debug('■■■ Exception : ' + e.getMessage());
            }
        } else {
            System.debug('■■■ smsinfoId is empty');
        }
        return error;
    }

    /**
     * SMS送信APIを呼び出す
     * @param String, String, String, String
     * @return String
     */
    @AuraEnabled
    // 2020/10/05 MODIFIED BY)IM.TANAKA
    // public static String basicAuthCallout(String smsid, String tel, String subject, String smstext) {
    public static String basicAuthCallout(String smsid, String tel, String subject, String smstext, String senderphonenumber) {
        String esubject = EncodingUtil.urlEncode(subject, 'UTF-8');
        String esmstext = EncodingUtil.urlEncode(smstext, 'UTF-8');
        String urlstr = URL + 'smsid=' + smsid + '&mobilenumber=' + tel + '&smstext=' + esmstext;
        // 2020/10/05 APPEND START BY)IM.TANAKA
        urlstr += '&docomotitle=' + senderphonenumber;
        urlstr += '&autitle=' + senderphonenumber;       
        urlstr += '&softbanktitle=' + SOFTBANKNO;
        urlstr += '&rakutentitle=' + senderphonenumber;   
        // 2020/10/05 END START BY)IM.TANAKA
                
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
//   
        Http http = new Http();
        HTTPResponse res = http.send(req);
        body = res.getBody();
//
        System.debug('■■■■ body:' + body);

        return body;
    }
}