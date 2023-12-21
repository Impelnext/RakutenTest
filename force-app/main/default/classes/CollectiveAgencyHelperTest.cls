/****************************************************************************************/
/* Class Name       : CollectiveAgencyHelperTest                                        */
/* Description      : 集団扱い代理店アラート共通クラスのテストクラス                    */
/* @Created Date    : 2021.07.27                                                        */
/* @Created By      : SRM                                                               */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@isTest
public class CollectiveAgencyHelperTest {
    
    static void execute1()
    {
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'name';
        insert account;
        
        List<DamageContract__c> dcs = new List<DamageContract__c>();
        Integer i=0;
        //for(Integer i=0 ; i<12; i++){
            CollectiveAgency__c cag = new CollectiveAgency__c();
            cag.AgencyNo__c = 'test' + i;
            insert cag;
            
            DamageContract__c dc = new DamageContract__c();
            dc.AccountId__c = account.Id;
            dc.AgencyCode__c = 'test' + i;
            insert dc;
            dcs.add(dc);
        //}
        
        DamageContract__c dc0 = new DamageContract__c();
        dc0.AccountId__c = account.Id;
        dc0.AgencyCode__c = null;
        insert dc0;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account.Id;
        dc1.AgencyCode__c = 'agency01';
        insert dc1;
        
        CollectiveAgencyHelper.getCollectiveAgency('test');
        
        CollectiveAgencyHelper.getCollectiveAgency(account.Id);
        
        CollectiveAgencyHelper.isCollectiveAgencyContract(null);
        CollectiveAgencyHelper.isCollectiveAgencyContract(dcs[0].Id);
        CollectiveAgencyHelper.isCollectiveAgencyContract(dc0.Id);
        CollectiveAgencyHelper.isCollectiveAgencyContract(dc1.Id);
    }
    
}