@isTest
public class NgAgencyHelperTest {

    @isTest
    static void execut1()
    {
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'name';
        insert account;
        
        List<NGAgency__c> ngList = new List<NGAgency__c>();
        List<AgencyMaster__c> agencyList = new List<AgencyMaster__c>();
        Integer i=0;
        for(i=0 ; i<12; i++){
            NGAgency__c nga = new NGAgency__c();
            nga.AgencyNo__c = 'test' + i;
            ngList.add(nga);
            
            AgencyMaster__c agency = new AgencyMaster__c();
            agency.SonpoAgencyCode__c = 'test' + i;
            agencyList.add(agency);
        }
        insert ngList;
        insert agencyList;
        
        // DamageContract with NGAgencyCode and 主幹事代理店 as NGAgency
        List<DamageContract__c> dcs = new List<DamageContract__c>();
        for(i=0 ; i<12; i++){
            DamageContract__c dc = new DamageContract__c();
            dc.AccountId__c = account.Id;
            dc.AgencyCode__c = 'test' + i;
            dc.AgencyId1__c = agencyList[i].Id;
            dc.AgencyCode1__c = 'test' + i;
            dcs.add(dc);
        }
        insert dcs;
        
        // DamageContract with Blank AgencyCode
        DamageContract__c dc0 = new DamageContract__c();
        dc0.AccountId__c = account.Id;
        dc0.AgencyCode__c = null;
        dc0.AgencyId1__c = agencyList[0].Id;
        dc0.AgencyCode1__c = 'test0';
        insert dc0;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account.Id;
        dc1.AgencyCode__c = 'agency01';
        dc1.AgencyId1__c = agencyList[0].Id;
        dc1.AgencyCode1__c = 'test100';
        insert dc1;
        
        NgAgencyHelper.getNgAgency('test');
        NgAgencyHelper.getNgAgency(account.Id);
        
        NgAgencyHelper.isNGAgencyContract(null);
        NgAgencyHelper.isNGAgencyContract(dcs[0].Id);
        NgAgencyHelper.isNGAgencyContract(dc0.Id);
        NgAgencyHelper.isNGAgencyContract(dc1.Id);
    }
    
}