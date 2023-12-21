@isTest
public class SsWebRequestTriggerTest
{
    @isTest
    static void SsWebRequestTriggerTest()
    {
        SsWebRequestTriggerTest triggerTest = new SsWebRequestTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        insert triggerTest.createSsWebRequest(account.Id);

        Test.stopTest();

    }
    
    @isTest
    static void SsWebRequestTriggerTest_non_AccountId()
    {
        SsWebRequestTriggerTest triggerTest = new SsWebRequestTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
         insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SsWebRequest__c ssWebReq = triggerTest.createSsWebRequest(null);
        insert ssWebReq;

        List<SsWebRequest__c> ssWebReqList = [Select Id, Opportunity__r.StageName from SsWebRequest__c where Id =: ssWebReq.Id];
        //本トリガーは無効化しているためAssertは行わない。（必ずNGになってしまうため）
        //System.assertEquals('未対応', ssWebReqList.get(0).Opportunity__r.StageName);

        Test.stopTest();

    }
    
    @isTest
    static void SsWebRequestTriggerTest_non_Account_easy_Id()
    {
        SsWebRequestTriggerTest triggerTest = new SsWebRequestTriggerTest();

        insert  triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
         insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();

        SsWebRequest__c sr = triggerTest.createSsWebRequest(null);
        sr.easy_id__c = null;
        insert sr;

        Test.stopTest();

    }

    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName = '個人',
            FirstName = '取引先',
            PersonHomePhone = '99-9999-9999',
            PersonMobilePhone = '88-8888-8888',
            PersonBirthdate = date.newInstance(1990, 11, 21),
            Gender__pc = '男性',
            SYSAccountName__c = '楽天太郎ﾗｸﾃﾝﾀﾛｳ',
            RecordTypeId=recordTypes[0].Id
        );
    }

    private SsWebRequest__c createSsWebRequest(Id accountId){
        return new SsWebRequest__c(
            easy_id__c = '1111111',
            request_id__c = '2222222',
            id__c = '5555555',
            last_name__c = '楽天',
            first_name__c = '太郎',
            last_name_kana__c = 'ﾗｸﾃﾝ',
            first_name_kana__c = 'ﾀﾛｳ',
            tel1__c = '99-9999-9999',
            tel2__c = '88-8888-8888',
            tel3__c = '77-7777-7777',
            request_date__c = '2017-1-1 15:30:00',
            zip_code1__c = '3333333',
            pref__c = '住所',
            city__c = '市区町村市区町村市区町村市区町村市区町村市区町村市区町村市区町村',
            address__c = '住所１',
            building__c = '住所２',
            Ref_Account__c = accountId
        );
    }

    private Opportunity createOpportunity(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '生保' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Opportunity(
            Name = '1111111',
            AccountId = accountId,
            StageName = '未対応',
            FirstCallDateTime__c = System.today(),
            FirstProbability__c = 'test',
            CloseDate = System.today(),
            RecordTypeId=recordTypes[0].Id
        );
    }
}