@isTest
public class SeihoPolicyRevivalAssessmentHandlerTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        SeihoPolicyRevivalAssessmentHandlerTest triggerTest = new SeihoPolicyRevivalAssessmentHandlerTest();
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
        SeihoPolicyRevivalAssessment__c polNum = [select id, LifeContract__c, INSURANCE_POLICY_NUMBER__c from SeihoPolicyRevivalAssessment__c where INSURANCE_POLICY_NUMBER__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
        
        
    }
    
   
    private SeihoPolicyRevivalAssessment__c createLifeSpecialContract(){
        return new SeihoPolicyRevivalAssessment__c(
            INSURANCE_POLICY_NUMBER__c = '1234567'
        );
    }
    
    // Test scenario Without Existing Policy Number
    
    private SeihoPolicyRevivalAssessment__c createLifeSpecialContractWithOutExistingPolNumber(){
        return new SeihoPolicyRevivalAssessment__c(
            INSURANCE_POLICY_NUMBER__c = '89065'
        );
    }
    
    // Test Scenario With No Policy Number
    
    private SeihoPolicyRevivalAssessment__c createLifeSpecialContractWithNoPolicyNumber(){
        return new SeihoPolicyRevivalAssessment__c( 
        );
    }
}