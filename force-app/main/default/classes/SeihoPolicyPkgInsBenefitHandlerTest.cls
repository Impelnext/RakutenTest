@isTest
public class SeihoPolicyPkgInsBenefitHandlerTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        SeihoPolicyPkgInsBenefitHandlerTest triggerTest = new SeihoPolicyPkgInsBenefitHandlerTest();
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
        SeihoPolicyPkgInsBenefit__c polNum = [select id, INSURANCE_POLICY_NUMBER__c, LifeContract__c from SeihoPolicyPkgInsBenefit__c where INSURANCE_POLICY_NUMBER__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
        
        
    }
    
   
    private SeihoPolicyPkgInsBenefit__c createLifeSpecialContract(){
        return new SeihoPolicyPkgInsBenefit__c(
            INSURANCE_POLICY_NUMBER__c = '1234567'
        );
    }
    
    // Test scenario Without Existing Policy Number
    
    private SeihoPolicyPkgInsBenefit__c createLifeSpecialContractWithOutExistingPolNumber(){
        return new SeihoPolicyPkgInsBenefit__c(
            INSURANCE_POLICY_NUMBER__c = '89065'
        );
    }
    
    // Test Scenario With No Policy Number
    
    private SeihoPolicyPkgInsBenefit__c createLifeSpecialContractWithNoPolicyNumber(){
        return new SeihoPolicyPkgInsBenefit__c( 
        );
    }
}