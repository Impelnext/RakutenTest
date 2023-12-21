@isTest
public class SeihoPolicyContDiscMgmtHandTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        SeihoPolicyContDiscMgmtHandTest triggerTest = new SeihoPolicyContDiscMgmtHandTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        //取引先作成
        insert  triggerHandler.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        //生保特約登録
        Test.startTest();
        insert  triggerTest.createLifeSpecialContract();
        insert  triggerTest.createLifeSpecialContractWithNoPolicyNumber();
        SeihoPolicyContDiscountMgmt__c polNum = [select id, LifeContract__c, INSURANCE_POLICY_NUMBER__c from SeihoPolicyContDiscountMgmt__c where INSURANCE_POLICY_NUMBER__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
        
        
    }
    
   
    private SeihoPolicyContDiscountMgmt__c createLifeSpecialContract(){
        return new SeihoPolicyContDiscountMgmt__c(
            INSURANCE_POLICY_NUMBER__c = '1234567'
        );
    }
    
    // Test scenario Without Existing Policy Number
    
    private SeihoPolicyContDiscountMgmt__c createLifeSpecialContractWithOutExistingPolNumber(){
        return new SeihoPolicyContDiscountMgmt__c(
            INSURANCE_POLICY_NUMBER__c = '89065'
        );
    }
    
    // Test Scenario With No Policy Number
    
    private SeihoPolicyContDiscountMgmt__c createLifeSpecialContractWithNoPolicyNumber(){
        return new SeihoPolicyContDiscountMgmt__c( 
        );
    }
}