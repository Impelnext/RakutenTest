@isTest
public class SMSInfoTriggerTEST {

    @isTest
    static void SMSInfoTriggerTest_delete()
    {
        SMSInfoTriggerTEST triggerTest = new SMSInfoTriggerTEST();

        Test.startTest();

        SMSInfo__c smsinfo = triggerTest.createSMSInfo();
        delete smsinfo;

        SMSInfo__c smsinfo2 = triggerTest.createSMSInfo2();
        try {
            delete smsinfo2;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('下書き以外のステータスでは削除できません。') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();
    }

    private SMSInfo__c createSMSInfo() {
        SMSInfo__c smsinfo = new SMSInfo__c(
            Name = 'TEST',
            DestinationPhoneNumber__c='00000000000',
            Status__c = '下書き'
        );
        insert smsinfo;
        return  smsinfo;
    }

    private SMSInfo__c createSMSInfo2() {
        SMSInfo__c smsinfo = new SMSInfo__c(
            Name = 'TEST',
            DestinationPhoneNumber__c='00000000000',
            Status__c = '承認済み'
        );
        insert smsinfo;
        return  smsinfo;
    }
    // Add 2023/03/10 RIPCRM-838_SMS承認・送信プロセスの変更 By 範　Start
    @IsTest() static void testsendMail(){
        SMSInfoTriggerTEST triggerTest = new SMSInfoTriggerTEST();
        SMSInfo__c sinf = new SMSInfo__c(
            Name='TEST',
            DestinationPhoneNumber__c='00000000000',
            status__c = '下書き',
            SendContents__c='test'
        );
        insert sinf;

        Test.startTest();

        Integer i = 0;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(i));

        SMSInfo__c smsinfo =  new SMSInfo__c();
        smsinfo.id=sinf.id;
        smsinfo.Name='TEST';
        smsinfo.DestinationPhoneNumber__c='00000000000';
        smsinfo.status__c = '承認済み';
        smsinfo.SendContents__c='test';
        
        update smsinfo;

        Test.stopTest();
    }
    // Add 2023/03/10 RIPCRM-838_SMS承認・送信プロセスの変更 By 範　End
}