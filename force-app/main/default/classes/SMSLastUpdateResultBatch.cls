/*
* @Class Name      : SMSLastUpdateResultBatch
* @Description     : SMS送信最終結果バッチ
* @Created Date    : 2020.05.19
* @Created By      : M.Tanaka
* @Modified Date   : 
* @Modified        : 
*/
global class SMSLastUpdateResultBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    static final Integer OVERMIN = 30; // 30 min
    static final String URL = 'https://www.sms-console.jp/api5/?';

    // static final String ID = 'RIPtestIM'; // for TEST
    // static final String PW = 'testIM%'; // for TEST
    //static final String ID = 'rakuten-life_api';
    //static final String PW = 'CA9XzTVS';
    static final String ID = System.Label.SMSAPI_BasicUsername;
    static final String PW = System.Label.SMSAPI_BasicPassword;

    Static final String RES_RETRY = 'リトライ中';
    Static final String RES_CYUKAN = '中間';
    Static final String RES_SAISYU = '最終';
    Static final String RES_SOSHINSUMI = '送信済';
    Static final String RES_SEIKO = '送信済み（成功）';
    Static final String RES_SHIPPAI = '送信済み（失敗）';

    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}
    //バッチ対象の損保契約レコードの総件数を格納
    public Integer smsinfoRecordCount{get;set;}
     //更新対象レコードの総件数
    public Integer updatedRecordCount{get;set;}
     
    /**
     * コンストラクタ
     */
    public SMSLastUpdateResultBatch () {
    
        System.debug('■■■ Called SMSLastUpdateResultBatch ');
            
        smsinfoRecordCount = 0;
        updatedRecordCount = 0;
        batchProcessedFlag = false;
        batchExceptionFlag = false;
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){

        System.debug('■■■ Called start ');
        
        String query = 'SELECT id,IsDeleted,Name,status__c,DestinationPhoneNumber__c,ContractorFurigana__c,Sender__c,';
               query += ' SenderPhoneNumber__c,SendSubject__c,SendContents__c,SendDateTime__c,SendResult__c,Branch_smsid__c,smsid__c,SMSPermissionFlg__c,';
               query += ' Account__c,DifferentPhoneNumber__c ';
               query += ' FROM SMSInfo__c WHERE isDeleted = false and status__c = \'リトライ中\'';

        Integer smsinfoRecordCount = [SELECT count() FROM SMSInfo__c WHERE isDeleted = false and status__c = 'リトライ中'];

        System.debug('■■■ ' + query);

        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param List<SMSInfo__c>
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<SMSInfo__c> smsinfo ){
   
        String body;

        System.debug('■■■ Called execute');
            
        batchProcessedFlag = true;

        //レスポンスボディ3行目が「中間」：「リトライ中」
        //レスポンスボディ3行目が「最終」かつ2行目が「送信済」：送信済み（成功）
        //レスポンスボディ3行目が「最終」かつ2行目が「送信済」以外：送信済み（失敗）

        DateTime nowtime = DateTime.now();
        DateTime sendp30;
        System.debug('■■■ now : ' + nowtime);
        
        // Update SMS List
        List<SMSInfo__c> updateSMSList = new List<SMSInfo__c>();
        
        try {
            for (SMSInfo__c sms : smsinfo) {
                System.debug('■■■ id : ' + sms.Id + ' status : ' + sms.status__c);

                // SendDateTime__c システム日時との差が30分以上
                if (sms.SendDateTime__c == null)  continue;
                sendp30 = sms.SendDateTime__c.addMinutes(OVERMIN);
                System.debug('■■■ sendp30 : ' + sendp30);
                if (sendp30 > nowtime) {
                    System.debug('■■■ senddatetime : false');
                    continue;
                }
                System.debug('■■■ senddatetime : true');
                body = basicAuthCallout(sms.smsid__c);
                
                if (body.contains(RES_CYUKAN)) {
                    sms.status__c = RES_RETRY;
                    System.debug('■■■ update : ' + sms.status__c);
                    //update sms;
                    updateSMSList.add(sms);
                } else if (body.contains(RES_SAISYU) && body.contains(RES_SOSHINSUMI)) {
                    sms.status__c = RES_SEIKO;
                    System.debug('■■■ update : ' + sms.status__c);
                    //update sms;
                    updateSMSList.add(sms);
                } else if (body.contains(RES_SAISYU) && !body.contains(RES_SOSHINSUMI)) {
                    sms.status__c = RES_SHIPPAI;
                    System.debug('■■■ update : ' + sms.status__c);
                    //update sms;
                    updateSMSList.add(sms);
                }else if (body.contains('514')) {
                    sms.status__c = RES_SHIPPAI;
                    System.debug('■■■ update : ' + sms.status__c);
                    //update sms;
                    updateSMSList.add(sms);
                } else {
                    System.debug('■■■ update : none');
                }
            }
            
            // Update All SMS Records
            if (updateSMSList.size() > 0) {
                update updateSMSList;
            }
            
        } catch (Exception e) {
            batchExceptionFlag = true;
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc) {

        System.debug('■■■ Called finish');

    }   

    /**
     * ENDPOINTを呼び出す
     * @param String
     * @return String
     */
    public String basicAuthCallout(String smsid) {
        String urlstr = URL + 'smsid=' + smsid;
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
   
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String body = res.getBody();
        System.debug('■■■■ body:' + body);

        return body;
    }
}