@isTest
public class IsSeihoPolicyDepHistFlgTrgHandlerTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        IsSeihoPolicyDepHistFlgTrgHandlerTest triggerTest = new IsSeihoPolicyDepHistFlgTrgHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        //取引先作成
        insert  triggerHandler.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerHandler.createLifeContract(account.Id);
        
        //生保特約登録
        Test.startTest();
        insert  triggerTest.createLifeSpecialContract();
        insert  triggerTest.createLifeSpecialContractWithNoPolicyNumber();
        SeihoPolicyDepHist__c polNum = [select id,INSURANCE_POLICY_NUMBER__c from SeihoPolicyDepHist__c where INSURANCE_POLICY_NUMBER__c= '1234567' limit 1];
        system.assert('1234567'== polNum.INSURANCE_POLICY_NUMBER__c);
        Test.stopTest();
        
        
    }
    
   
    private SeihoPolicyDepHist__c createLifeSpecialContract(){
        return new SeihoPolicyDepHist__c(
            INSURANCE_POLICY_NUMBER__c = '1234567'
        );
    }
    
    // Test scenario Without Existing Policy Number
    
    private SeihoPolicyDepHist__c createLifeSpecialContractWithOutExistingPolNumber(){
        return new SeihoPolicyDepHist__c(
            INSURANCE_POLICY_NUMBER__c = '89065'
        );
    }
    
    // Test Scenario With No Policy Number
    
    private SeihoPolicyDepHist__c createLifeSpecialContractWithNoPolicyNumber(){
        return new SeihoPolicyDepHist__c( 
        );
    }
}