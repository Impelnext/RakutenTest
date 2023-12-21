@isTest
public class CallCountComponentControllerTest
{
    @isTest
    static void CallCountComponentControllerTest()
    {
        CallCountComponentControllerTest controllerTest = new CallCountComponentControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert controllerTest.createOpportunity(account.Id);
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        CallCountComponentController.getCallCount(opp.Id);
        Test.StopTest();
    }

    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName='個人',
            FirstName='取引先',
            RecordTypeId=recordTypes[0].Id
        );
    }

    private Opportunity createOpportunity(Id accountId){
        return new Opportunity(
            Name = 'テスト商談',                        // 商談名
            CloseDate = Date.valueOf('2019-04-01'),  // 完了予定日
            StageName = '未着手',                       // 商談ステータス
            telReason__c = 'Web広告',                  // 入電理由
            Probability = 10,                        // 確度(%)
            AccountId = accountId
        );
    }
}