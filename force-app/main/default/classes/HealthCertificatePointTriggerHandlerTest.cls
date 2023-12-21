/*
* @Class Name      : HealthCertificatePointTriggerHandlerTest
* @Description     : 健康診断書ポイントトリガのハンドラーのテストクラス
* @Created Date    : 2023.02.06
* @Created By      : Takumi Nagaya
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class HealthCertificatePointTriggerHandlerTest {
    
    @isTest
    static void HealthCertificatePointTriggerTest_insert()
    {
        HealthCertificatePointTriggerHandlerTest triggerTest = new HealthCertificatePointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert  triggerTest.createHealthCertificatePoint();
        HealthCertificatePoint__c polNum = [select id, LifeContract__c, POL_NUM__c 
                                            from HealthCertificatePoint__c where POL_NUM__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
    }
    
    @isTest
    static void HealthCertificatePointTriggerTest_Update()
    {
        HealthCertificatePointTriggerHandlerTest triggerTest = new HealthCertificatePointTriggerHandlerTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        insert  triggerHandler.createAccount();
        
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        Test.startTest();
        insert  triggerTest.createHealthCertificatePoint(contract.Id);
        HealthCertificatePoint__c updPolNum = [select id, LifeContract__c, POL_NUM__c 
                                            from HealthCertificatePoint__c where POL_NUM__c= '' limit 1];
        updPolNum.POL_NUM__c = '1234567';
        UPDATE updPolNum;
        system.assertEquals(contract.Id, updPolNum.LifeContract__c);
        Test.stopTest();
    }

    private HealthCertificatePoint__c createHealthCertificatePoint(){
        return new HealthCertificatePoint__c(
            POL_NUM__c = '1234567'
        );
    }
    
    private HealthCertificatePoint__c createHealthCertificatePoint(Id lcId){
        return new HealthCertificatePoint__c(
            POL_NUM__c = '',
            LifeContract__c = lcId
        );
    }
}