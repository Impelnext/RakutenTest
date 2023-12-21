/**
 * Class containing tests for SMSTemplateCmpController
 */
@IsTest public with sharing class SMSTemplateCmpControllerTEST {
    @isTest 
    static void testgetTempList() {
        SMSTemplateCmpControllerTEST controllertest = new SMSTemplateCmpControllerTEST();

        Test.startTest();
        controllertest.createTempList();
        List<Object> ls = SMSTemplateCmpController.getTempList();
        Test.stopTest();
    }
    
    
    @isTest
    static void testgetTemp() {
        SMSTemplateCmpControllerTEST controllertest = new SMSTemplateCmpControllerTEST();
        SMSMessageTemplate__c tmp = controllertest.createTemp();
        insert tmp;
        
        Test.startTest();
        SMSMessageTemplate__c gettmp = SMSTemplateCmpController.getTemp(tmp.id);
        Test.stopTest();
    }

    // @IsTest(SeeAllData=true) 
    @isTest 
    static void testdoSaveTemp() {
        SMSTemplateCmpControllerTEST controllertest = new SMSTemplateCmpControllerTEST();
        SMSMessageTemplate__c tmp = controllertest.createTemp();
        insert tmp;
        
        Test.startTest();
        SMSMessageTemplate__c nonTmp; 
        string rtn;
        rtn = SMSTemplateCmpController.doSaveTemp(tmp);
        rtn = SMSTemplateCmpController.doSaveTemp(nonTmp);
        Test.stopTest();
    }
    
    // @IsTest(SeeAllData=true) 
    @isTest 
    static void testdoDeleteTemp() {
        SMSTemplateCmpControllerTEST controllertest = new SMSTemplateCmpControllerTEST();
        SMSMessageTemplate__c tmp = controllertest.createTemp();
        insert tmp;
        
        Test.startTest();
        SMSMessageTemplate__c nonTmp; 
        string rtn;
        rtn = SMSTemplateCmpController.doDeleteTemp(tmp);
        rtn = SMSTemplateCmpController.doDeleteTemp(nonTmp);
        Test.stopTest();
    }
    
    @isTest 
    static void testInsertSMSInfoTemp() {
        SMSTemplateCmpControllerTEST controllertest = new SMSTemplateCmpControllerTEST();
        SMSMessageTemplate__c tmp = controllertest.createTemp();
        insert tmp;
        
        SMSInfo__c sms = controllertest.createSMSInfo();
        insert sms;

        String subject = '件名';
        String message = 'メッセージ';

        Test.startTest();
        String rtn = SMSTemplateCmpController.updateMessage(sms.Id,subject, message);
        sms.Status__c = '承認済み';
        sms.Branch_smsid__c = sms.Branch_smsid__c + 1;
        update sms;
        rtn = SMSTemplateCmpController.updateMessage(sms.Id,subject, message);
        Test.stopTest();
    }
    

    private SMSInfo__c createSMSInfo(){
        return new SMSInfo__c(
            Name='TEST',
            Branch_smsid__c=0,
            //SMSpermissionFlg__c=TRUE,
            DestinationPhoneNumber__c='00000000000'
        );
    }

    private SMSMessageTemplate__c createTemp(){
        return new SMSMessageTemplate__c (
            Name='tempTest',
            MessageDetail__c='テストテンプレート',
            Order__c=1
        );
    }

    // private List<SMSMessageTemplate__c> createTempList(){
    private void createTempList(){
        List<SMSMessageTemplate__c> recList = new List<SMSMessageTemplate__c>();
        for (Integer i=0; i < 10; i++) {
            SMSMessageTemplate__c rec = new SMSMessageTemplate__c (
                Name='tempTest',
                MessageDetail__c='テストテンプレート' + i,
                Order__c = i
            );
            recList.add(rec);
        }
        insert recList;

    }
}