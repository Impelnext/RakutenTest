@isTest
public class JointRecruitmentAgencyAlertTest{
    static Map<String,Integer> testReturnMap;
    
    @testSetup static void setup() {
        //Create common Account
        RecordType recordType = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' And Name = '個人取引先' Limit 1];
        
        Account testAcc = new Account();
        testAcc.lastname = 'TestAccount';
        testAcc.recordtypeid = recordType.id;
        insert testAcc;
        
        //Create common Agency Master
        AgencyMaster__c testAgency = new AgencyMaster__c();
        testAgency.SeihoAgencyCode__c = 'TEST';
        testAgency.SonpoAgencyCode__c = 'TEST';
        testAgency.ShotanAgencyCode__c = 'TEST';
        insert testAgency;
        
        //Create LifeContract__c
        LifeContract__c testlife = new LifeContract__c();
        testlife.AccountId__c = testAcc.id;
        testlife.AgencyId__c = testAgency.id;
        insert testlife;
        
        //Create DamageContract__c
        DamageContract__c testdamage = new DamageContract__c();
        testdamage.AccountId__c = testAcc.id;
        testdamage.AgencyId1__c = testAgency.id;
        insert testdamage;
        
        //Create LittleContract__c
        LittleContract__c testlittle = new LittleContract__c();
        testlittle.AccountId__c = testAcc.id;
        testlittle.AgencyId__c = testAgency.id;
        insert testlittle;
    }
    
    @isTest
    static void testMethod1() {
        Account acc = [Select id From Account Where Name = 'TestAccount'];
        testReturnMap = JointRecruitmentAgencyAlertController.getContractInfo(acc.id);
    }
}