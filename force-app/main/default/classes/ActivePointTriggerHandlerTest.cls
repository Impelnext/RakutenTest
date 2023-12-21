/*
* @Class Name      : ActivePointTriggerHandlerTest
* @Description     : 活動ポイントトリガのハンドラーのテストクラス
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class ActivePointTriggerHandlerTest {
    
    @isTest
    static void ActivePointTriggerHandlerTest_insert()
    {
        ActivePointTriggerHandlerTest triggerTest = new ActivePointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert  triggerTest.createActivePoint();
        ActivePoint__c polNum = [select id, LifeContract__c,LifeContract1__c,LifeContract2__c, POL_NUM__c 
                                from ActivePoint__c where POL_NUM__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
    }

    @isTest
    static void ActivePointTriggerHandlerTest_Update()
    {
        ActivePointTriggerHandlerTest triggerTest = new ActivePointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert  triggerTest.createActivePoint(contract.Id);        
        ActivePoint__c updPolNum = [select id, LifeContract__c,LifeContract1__c,LifeContract2__c, POL_NUM__c 
                                from ActivePoint__c where POL_NUM__c= '' limit 1];
        updPolNum.POL_NUM__c = '1234567';
        UPDATE updPolNum;
        system.assertEquals(contract.Id, updPolNum.LifeContract__c);
        Test.stopTest();
    }
    
    private ActivePoint__c createActivePoint(){
        return new ActivePoint__c(
                        POL_NUM__c = '1234567'
               );
    }

    private ActivePoint__c createActivePoint(Id lcId){
        return new ActivePoint__c(
                        POL_NUM__c = '',
                        LifeContract__c = lcId,
                        LifeContract1__c = lcId,
                        LifeContract2__c = lcId
               );
    }    
}