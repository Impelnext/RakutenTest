/**
 * Class containing tests for SMSLastUpdateResultBatch
 */
@IsTest public with sharing class SMSLastUpdateResultBatchTEST {
    //@IsTest(SeeAllData=true) static void testConst() {
    @IsTest() static void testConst() {
        SMSLastUpdateResultBatchTEST controllertest = new SMSLastUpdateResultBatchTEST();
        //List<SMSInfo__c> infoList = Test.loadData(SMSInfo__c.sObjectType, 'Test_info_Data');
        
        
        Integer i = 0;//1、2
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(i));

        SMSInfo__c info = controllertest.createSMSInfo();


        SMSLastUpdateResultBatch resultBatch= new SMSLastUpdateResultBatch();  
        Database.executeBatch(resultBatch);
        Test.startTest();   
        string bc = resultBatch.basicAuthCallout(info.id);
        Test.stopTest();
    }
    
    @IsTest() static void testConsttype1() {
        SMSLastUpdateResultBatchTEST controllertest = new SMSLastUpdateResultBatchTEST();
        //List<SMSInfo__c> infoList = Test.loadData(SMSInfo__c.sObjectType, 'Test_info_Data');
        
        
        Integer i = 1;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(i));

        SMSInfo__c info = controllertest.createSMSInfo();



        SMSLastUpdateResultBatch resultBatch= new SMSLastUpdateResultBatch();  
        Database.executeBatch(resultBatch);
        Test.startTest();   
        string bc = resultBatch.basicAuthCallout(info.id);
        Test.stopTest();
    }
    
    @IsTest() static void testConsttype2() {
        SMSLastUpdateResultBatchTEST controllertest = new SMSLastUpdateResultBatchTEST();
        //List<SMSInfo__c> infoList = Test.loadData(SMSInfo__c.sObjectType, 'Test_info_Data');
        
        
        Integer i = 2;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(i));

        SMSInfo__c info = controllertest.createSMSInfo();


        SMSLastUpdateResultBatch resultBatch= new SMSLastUpdateResultBatch();  
        Database.executeBatch(resultBatch);
        Test.startTest();   
        string bc = resultBatch.basicAuthCallout(info.id);
        Test.stopTest();
    }
    
    private SMSInfo__c createSMSInfo(){
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            SendDateTime__c=DateTime.now().addHours(-1),//
            //isDeleted=FALSE,
            status__c='リトライ中'
        );
        insert sinf;

        return sinf;
    }
    
}