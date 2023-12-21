/**
 * Class containing tests for SMSSendCmpController
 */
@IsTest public with sharing class SMSSendCmpControllerTEST {
    /*
    @IsTest(SeeAllData=true) static void testRegistration() {
    }
    */  
    
    //@IsTest(SeeAllData=true) static void testsendSMS() {
    @IsTest() static void testsendSMS() {
        SMSSendCmpControllerTEST controllertest = new SMSSendCmpControllerTEST();
        
        SMSInfo__c info = controllertest.createSMSInfocall();
        //SMSInfo__c info = controllertest.createSMSInfo();
        //insert info;
        
        SMSInfo__c info2 = controllertest.createSMSInfocall2();
        //SMSInfo__c info2 = controllertest.createSMSInfo();
        //insert info2;
        //info2.status__c = '送信済み(成功)';
        //update info2;
        
        SMSInfo__c info3 = controllertest.createSMSInfocall3();
        //SMSInfo__c info3 = controllertest.createSMSInfo();
        //insert info3;
        //info3.status__c = 'リトライ中';
        //update info3;
        
        SMSInfo__c info4 = controllertest.createSMSInfocall4();
        //SMSInfo__c info4 = controllertest.createSMSInfo();
        //insert info4;
        //info4.status__c = '承認済み';
        //update info4;

        SMSInfo__c info5 = controllertest.createSMSInfocall5();
        //SMSInfo__c info5 = controllertest.createSMSInfo();
        //insert info5;
        //info5.SendContents__c = '';
        //update info5;
        
        
        Test.startTest();   
        string smsid = info.id;
        string str = null;
        string msg;
        
        msg = SMSSendCmpController.sendSMS(str);   //送信:null
        msg = SMSSendCmpController.sendSMS(smsid); //送信
        msg = SMSSendCmpController.sendSMS(info2.id); //送信
        msg = SMSSendCmpController.sendSMS(info3.id); //送信
        msg = SMSSendCmpController.sendSMS(info4.id); //送信
        msg = SMSSendCmpController.sendSMS(info5.id); //送信
        
        Test.stopTest();
    }
    
    //@IsTest(SeeAllData=true) static void testcheckSMS() {
    @IsTest() static void testcheckSMS() {
        SMSSendCmpControllerTEST controllertest = new SMSSendCmpControllerTEST();
        SMSInfo__c info = controllertest.createSMSInfo();
        insert info;
        
        Test.startTest();   
        string smsid = info.id;
        string str = null;
        string msg;
        
        msg = SMSSendCmpController.checkSMS(str);   //確認:null
        msg = SMSSendCmpController.checkSMS(smsid); //確認
        
        Test.stopTest();
    }
    
    //@IsTest(SeeAllData=true) static void testbasicAuthCallout(){
    @IsTest() static void testbasicAuthCallout(){
        SMSSendCmpControllerTEST controllertest = new SMSSendCmpControllerTEST();
        //SMSInfo__c info = controllertest.createSMSInfo();
        //insert info;
        SMSInfo__c info = controllertest.createSMSInfocall();
        
        Test.startTest(); 
        string smsid = info.smsid__c;
        string tel = '00000000000';
        string subject = 'テスト';
        string text = 'this is test.';
        string motono = '00000000000';
        
        Integer i = 0;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(i));

        string bd = SMSSendCmpController.basicAuthCallout(smsid, tel, subject, text, motono);
        Test.stopTest();
    }

    @isTest static void testMethod_T02(){
        SMSSendCmpControllerTEST controllertest = new SMSSendCmpControllerTEST();

        Account acc = createAccount();
        insert acc;
        SMSInfo__c info = controllertest.createSMSInfocall6(acc, 'リトライ中');
        SMSInfo__c info2 = controllertest.createSMSInfocall6(acc, '送信済み(成功)');
        SMSInfo__c info3 = controllertest.createSMSInfocall6(acc, '下書き');

        Test.startTest();   
        info.Account__c = null;
        string smsid = info.id;
        Integer ret0l = SMSSendCmpController.checkError(null);
        Integer ret = SMSSendCmpController.checkError(info.id);
//        info.Account__c = acc.Id;
//        info.Status__c = '下書き';
        Integer ret2 = SMSSendCmpController.checkError(info2.id);
        Integer ret3 = SMSSendCmpController.checkError(info3.id);
        Test.stopTest();
    }
    
    private SMSInfo__c createSMSInfo(){
        return new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000'//,
            //status__c = '承認済'
        );
    }
    
    private SMSInfo__c createSMSInfocall(){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            status__c = '承認済み',
            SendContents__c='test'
        );
        insert sinf;

        return sinf;
    }
    
    private SMSInfo__c createSMSInfocall2(){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            status__c = '送信済み(成功)'
        );
        insert sinf;

        return sinf;
    }
    private SMSInfo__c createSMSInfocall3(){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            status__c = 'リトライ中'
        );
        insert sinf;

        return sinf;
    }
    private SMSInfo__c createSMSInfocall4(){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            status__c = '下書き'
        );
        insert sinf;

        return sinf;
    }
    private SMSInfo__c createSMSInfocall5(){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            status__c = ''
        );
        insert sinf;

        return sinf;
    }
     private SMSInfo__c createSMSInfocall6(Account ac, String status){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            Status__c = status,
            Account__c = ac.Id
        );
        insert sinf;

        return sinf;
    }
    private SMSInfo__c createSMSInfocall7(Account ac, String status){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            Status__c = status,
            SendContents__c = null,
            Account__c = ac.Id
        );
        insert sinf;

        return sinf;
    }

    private SMSInfo__c createSMSInfocall8(Account ac, String status){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            Status__c = status,
            Account__c = ac.Id
        );
        insert sinf;

        return sinf;
    }

    private User createUser(){

        // get profile
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name IN ('Standard User', '標準ユーザ')];
        System.assert(profiles.size() > 0);

        return new User(
             LastName = 'LastName'
            ,Alias = 'Alias'
            ,Email = 'user@example.com'
            ,Username = 'user@example.com.dev'
            ,CommunityNickname = 'TestUser'
            ,EmailEncodingKey = 'ISO-2022-JP'
            ,TimeZoneSidKey = 'Asia/Tokyo'
            ,LocaleSidKey = 'ja_JP'
            ,LanguageLocaleKey = 'ja'
            ,ProfileId = profiles.get(0).Id
        );
    }

    private User createUser2(){

        // get profile
        List<Profile> profiles = [SELECT Id FROM Profile WHERE Name IN ('Standard User', '標準ユーザ')];
        System.assert(profiles.size() > 0);

        return new User(
             LastName = 'LastName2'
            ,Alias = 'Alias2'
            ,Email = 'user2@example.com'
            ,Username = 'user2@example.com.dev'
            ,CommunityNickname = 'TestUser2'
            ,EmailEncodingKey = 'ISO-2022-JP'
            ,TimeZoneSidKey = 'Asia/Tokyo'
            ,LocaleSidKey = 'ja_JP'
            ,LanguageLocaleKey = 'ja'
            ,ProfileId = profiles.get(0).Id
        );
    }

    static account createAccount(){
        return new Account(
            Name='TEST',
            SMSPermissionFlgLife__c=TRUE,
            SMSPermissionFlgSonpo__c=TRUE,
            SMSPermissionFlgLittle__c=TRUE
            //PersonMobilePhone='00000000000'
            //furigana__c=0
        );
    }
    
}