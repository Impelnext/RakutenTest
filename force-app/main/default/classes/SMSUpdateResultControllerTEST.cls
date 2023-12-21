/**
 * Class containing tests for SMSUpdateResultController
 */
@IsTest public with sharing class SMSUpdateResultControllerTEST {
    //@IsTest(SeeAllData=true) static void testinitNosts() {
    @IsTest() static void testinitNosts() {
        SMSUpdateResultControllerTEST controllertest = new SMSUpdateResultControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        
        Test.startTest();
        SMSUpdateResultController rst = new SMSUpdateResultController();
        rst.init();
        Test.stopTest();
    }
    
    //@IsTest(SeeAllData=true) static void testinitstsS() {
    @IsTest() static void testinitstsS() {
        SMSUpdateResultControllerTEST controllertest = new SMSUpdateResultControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        info = [Select id, smsid__c, Branch_smsid__c from SMSInfo__c LIMIT 1];
        System.debug('■■■ smsid__c:' + info.smsid__c);
        System.debug('■■■ Branch_smsid__c:' + String.valueOf(info.Branch_smsid__c));
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('smsid', info.smsid__c);
        System.currentPageReference().getParameters().put('status', '送信中');
        
        Test.startTest();
        info = [Select id, smsid__c, Branch_smsid__c from SMSInfo__c LIMIT 1];
        SMSUpdateResultController rst = new SMSUpdateResultController();
        rst.init();
        Test.stopTest();
    }

    //@IsTest(SeeAllData=true) static void testinitstsN() {
    @IsTest() static void testinitstsN() {
        SMSUpdateResultControllerTEST controllertest = new SMSUpdateResultControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        info = [Select id, smsid__c, Branch_smsid__c from SMSInfo__c LIMIT 1];
        System.debug('■■■ smsid__c:' + info.smsid__c);
        System.debug('■■■ Branch_smsid__c:' + String.valueOf(info.Branch_smsid__c));
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('smsid', info.smsid__c);
        System.currentPageReference().getParameters().put('status', '処理中');
        
        Test.startTest();
        SMSUpdateResultController rst = new SMSUpdateResultController();
        rst.init();
        Test.stopTest();
    }

    //@IsTest(SeeAllData=true) static void testinitstsE() {
    @IsTest() static void testinitstsE() {
        SMSUpdateResultControllerTEST controllertest = new SMSUpdateResultControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        info = [Select id, smsid__c, Branch_smsid__c from SMSInfo__c LIMIT 1];
        System.debug('■■■ smsid__c:' + info.smsid__c);
        System.debug('■■■ Branch_smsid__c:' + String.valueOf(info.Branch_smsid__c));
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('smsid', info.smsid__c);
        System.currentPageReference().getParameters().put('status', '送信済');
        
        Test.startTest();
        SMSUpdateResultController rst = new SMSUpdateResultController();
        rst.init();
        Test.stopTest();
    }

    //@IsTest(SeeAllData=true) static void testinitstsR() {
    @IsTest() static void testinitstsR() {
        SMSUpdateResultControllerTEST controllertest = new SMSUpdateResultControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        info = [Select id, smsid__c, Branch_smsid__c from SMSInfo__c LIMIT 1];
        System.debug('■■■ smsid__c:' + info.smsid__c);
        System.debug('■■■ Branch_smsid__c:' + String.valueOf(info.Branch_smsid__c));
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('smsid', info.smsid__c);
        System.currentPageReference().getParameters().put('status', 'ERROR');
        
        Test.startTest();
        SMSUpdateResultController rst = new SMSUpdateResultController();
        rst.init();
        Test.stopTest();
    }

    //@IsTest(SeeAllData=true) static void testinitstsExc() {
    @IsTest() static void testinitstsExc() {
        SMSUpdateResultControllerTEST controllertest = new SMSUpdateResultControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        info = [Select id, smsid__c, Branch_smsid__c from SMSInfo__c LIMIT 1];
        System.debug('■■■ smsid__c:' + info.smsid__c);
        System.debug('■■■ Branch_smsid__c:' + String.valueOf(info.Branch_smsid__c));
        
        Test.setCurrentPageReference(new PageReference('Page.myPage'));
        System.currentPageReference().getParameters().put('smsid', info.smsid__c);
        System.currentPageReference().getParameters().put('status', 'ERROR');
        
        Test.startTest();
        SMSUpdateResultController rst = new SMSUpdateResultController();
        rst.init();
        Test.stopTest();
    }  
    
    private SMSInfo__c createSMSInfo(){
        return new SMSInfo__c(
            Name='TEST',
            status__c='承認済み',
            Branch_smsid__c = 20,
            sendresult__c=' ',
            DestinationPhoneNumber__c='00000000000'
        );
    }

    private SMSInfo__c createSMSInfo2(){
        return new SMSInfo__c(
            Name='TEST',
            status__c='承認済み',
            Branch_smsid__c = 20,
            sendresult__c='',
            DestinationPhoneNumber__c='00000000000'
        );
    }
}