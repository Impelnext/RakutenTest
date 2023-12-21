/*
* @Class Name      : SMSUpdateResultController 
* @Description     : SMS送信結果受信用API
* @Created Date    : 2020.05.19
* @Created By      : M.Tanaka
* @Modified Date   : 
* @Modified        : 
*/
//global with sharing class SMSUpdateResultController {
global class SMSUpdateResultController {

    Static final String RES_SEIKO = '送信済み（成功）';
    Static final String RES_RETRY = 'リトライ中';

    global String smsid {get; set;}
    global String status {get; set;}
    global String msg {get; set;}
        
    /*
     * 送信済 ==> 送信済み（成功）
     * 送信中/処理中 ==> nothing
     * 上記以外 ==> リトライ中
     */
    
    global SMSUpdateResultController () {
    
        System.debug('■■■ called SMSUpdateResultController');
        
        smsid = System.currentPageReference().getParameters().get('smsid');
        status = System.currentPageReference().getParameters().get('status');
        msg = '';
        
        System.debug('■■■ smsid=' + smsid + ' status=' + status);
        msg += ('| smsid=' + smsid + ' status=' + status);
        
    }
    
    public void init() {

        msg += ' |Call Init 0';
        if (smsid == null || status == null || smsid == '' || status == '' )  return;
        msg += ' |Call Init 1';

        try {
            msg += (' |' + status);
            switch on status {
                when '送信中' {
                    SMSInfo__c smsinfo = [SELECT Id, smsid__c, status__c, SendDateTime__c, sendresult__c,LastModifiedDate FROM SMSInfo__c WHERE smsid__c = :smsid LIMIT 1];
                    if (smsinfo.sendresult__c == null) {
                        smsinfo.sendresult__c = '[送信中]';
                    } else {
                        smsinfo.sendresult__c += '[送信中]';
                    }
                    System.debug('■■■ nothing smsid:' + smsid);
                    msg += ' |update status to nothing';
                    update smsinfo ;
                }
                when '処理中' {
                    SMSInfo__c smsinfo = [SELECT Id, smsid__c, status__c, SendDateTime__c, sendresult__c,LastModifiedDate FROM SMSInfo__c WHERE smsid__c = :smsid LIMIT 1];
                    if (smsinfo.sendresult__c == null) {
                        smsinfo.sendresult__c = '[処理中]';
                    } else {
                        smsinfo.sendresult__c += '[処理中]';
                    }
                    System.debug('■■■ nothing smsid:' + smsid);
                    msg += ' |update status to nothing';
                    update smsinfo ;
                }
                when '送信済' {
                    SMSInfo__c smsinfo = [SELECT Id, smsid__c, status__c, SendDateTime__c, sendresult__c,LastModifiedDate FROM SMSInfo__c WHERE smsid__c = :smsid LIMIT 1];
                    smsinfo.status__c = RES_SEIKO;
                    if (smsinfo.sendresult__c == null) {
                        smsinfo.sendresult__c = '[送信済]';
                    } else {
                        smsinfo.sendresult__c += '[送信済]';
                    }
                    System.debug('■■■ Update status ' + RES_SEIKO + ' smsid:' + smsid);
                    msg += (' |update status to ' + RES_SEIKO);
                    update smsinfo ;
                }
                when else {
                    SMSInfo__c smsinfo = [SELECT Id, smsid__c, status__c, SendDateTime__c, sendresult__c,LastModifiedDate FROM SMSInfo__c WHERE smsid__c = :smsid LIMIT 1];
                    smsinfo.status__c = RES_RETRY;
                    if (smsinfo.sendresult__c == null) {
                         smsinfo.sendresult__c = '[その他]';
                    } else {
                         smsinfo.sendresult__c += '[その他]';
                    }
                    System.debug('■■■ Update status ' + RES_RETRY + ' smsid:' + smsid);
                    msg += (' |update status to ' + RES_RETRY);
                    update smsinfo ;
                }          
            }
        } catch(Exception e) {
            msg += (' |exception : ' + e.getMessage());
            System.debug('■■■ Exception : ' + e.getMessage());
        } 
        
        // System.debug('■■■ end SMSUpdateResultController'); 
    }
}