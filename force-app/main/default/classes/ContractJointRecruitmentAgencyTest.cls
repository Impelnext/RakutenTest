@isTest
public class ContractJointRecruitmentAgencyTest{
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
        LifeContract__c life = [Select id From LifeContract__c Limit 1];
        ContractJointRecruitmentAgencyController.ContractWrapper wrapper;
        wrapper = ContractJointRecruitmentAgencyController.getContractInfo(life.id);
    }
    @isTest
    static void testMethod2() {
        DamageContract__c little = [Select id From DamageContract__c Limit 1];
        ContractJointRecruitmentAgencyController.ContractWrapper wrapper;
        wrapper = ContractJointRecruitmentAgencyController.getContractInfo(little.id);
    }
    @isTest
    static void testMethod3() {
        LittleContract__c damage = [Select id From LittleContract__c Limit 1];
        ContractJointRecruitmentAgencyController.ContractWrapper wrapper;
        wrapper = ContractJointRecruitmentAgencyController.getContractInfo(damage.id);
    }
    @isTest
    static void testMethod4() {
        List<String> strList = new List<String>();
        strList.add('12345');
        ContractJointRecruitmentAgencyController.ContractWrapper wrapper;
        wrapper = ContractJointRecruitmentAgencyController.getAgencyInfo('SeihoAgencyCode__c',null,strList);
    }
}