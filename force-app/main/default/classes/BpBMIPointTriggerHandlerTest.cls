/*
* @Class Name      : BpBMIPointTriggerHandlerTest
* @Description     : 血圧BMIポイントトリガのハンドラーのテストクラス
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class BpBMIPointTriggerHandlerTest {
    
    @isTest
    static void BpBMIPointTriggerTest_insert()
    {
        BpBMIPointTriggerHandlerTest triggerTest = new BpBMIPointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert  triggerTest.createBpBMIPoint();
        BpBMIPoint__c polNum = [select id, LifeContract__c, POL_NUM__c 
                                from BpBMIPoint__c where POL_NUM__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
    }
    
    @isTest
    static void BpBMIPointTriggerTest_Update()
    {
        BpBMIPointTriggerHandlerTest triggerTest = new BpBMIPointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert  triggerTest.createBpBMIPoint(contract.Id);
        BpBMIPoint__c updPolNum = [select id, LifeContract__c, POL_NUM__c 
                                from BpBMIPoint__c where POL_NUM__c= '' limit 1];
        updPolNum.POL_NUM__c = '1234567';
        UPDATE updPolNum;
        
        system.assertEquals(contract.Id, updPolNum.LifeContract__c);
        Test.stopTest();
    }

    private BpBMIPoint__c createBpBMIPoint(){
        return new BpBMIPoint__c(
            POL_NUM__c = '1234567'
        );
    }
    
    private BpBMIPoint__c createBpBMIPoint(Id lcId){
        return new BpBMIPoint__c(
            POL_NUM__c = '',
            LifeContract__c = lcId
        );
    }    
}