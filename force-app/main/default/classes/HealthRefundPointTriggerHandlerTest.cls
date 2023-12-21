/*
* @Class Name      : HealthRefundPointTriggerHandlerTest
* @Description     : 健康還付ポイントトリガのハンドラーのテストクラス
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class HealthRefundPointTriggerHandlerTest {
    
    @isTest
    static void HealthRefundPointTriggerHandlerTest_insert()
    {
        HealthRefundPointTriggerHandlerTest triggerTest = new HealthRefundPointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert triggerTest.createHealthRefundPoint();
        HealthRefundPoint__c PolNum = [select id, LifeContract__c, LifeContract1__c, POL_NUM__c 
                                       from HealthRefundPoint__c where POL_NUM__c= '1234567' limit 1];
        
        system.assertEquals(contract.Id, PolNum.LifeContract__c);
        Test.stopTest();
    }
    
    @isTest
    static void HealthRefundPointTriggerHandlerTest_Update()
    {
        HealthRefundPointTriggerHandlerTest triggerTest = new HealthRefundPointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert triggerTest.createHealthRefundPoint1(contract.Id);
        HealthRefundPoint__c updPolNum = [select id, LifeContract__c, LifeContract1__c, POL_NUM__c 
                                       from HealthRefundPoint__c where POL_NUM__c= '' limit 1];
         updPolNum.POL_NUM__c = '1234567';
        UPDATE updPolNum;
        system.assertEquals(contract.Id, updPolNum.LifeContract__c);
        Test.stopTest();
    }
    private HealthRefundPoint__c createHealthRefundPoint(){
        return new HealthRefundPoint__c(
            POL_NUM__c = '1234567'
        );
    }
    
    private HealthRefundPoint__c createHealthRefundPoint1(Id lcId){
        return new HealthRefundPoint__c(
            POL_NUM__c = '',
            LifeContract__c = lcId,
            LifeContract1__c = lcId
        );
    }
}