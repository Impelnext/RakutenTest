/****************************************************************************************/
/* Class Name       : LinkNgAgencyHelperTest                                            */
/* Description      : 保全禁止連携代理店判定共通クラスのテストクラス                    */
/* @Created Date    : 2021.03.10                                                        */
/* @Created By      : Valsala Kumar J                                                   */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@isTest
public class LinkNgAgencyHelperTest {

    @isTest
    static void test1()
    {
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'name';
        insert account;
        
        List<DamageContract__c> dcs = new List<DamageContract__c>();
        
        for(Integer i=0 ; i<1; i++){
            LinkNGAgencyCode__c nga = new LinkNGAgencyCode__c();
            nga.AgencyCode__c = 'test' + i;
            insert nga;
            
            DamageContract__c dc = new DamageContract__c();
            dc.AccountId__c = account.Id;
            dc.AgencyCode__c = 'test' + i;
            insert dc;
            dcs.add(dc);
        }
        
        DamageContract__c dc0 = new DamageContract__c();
        dc0.AccountId__c = account.Id;
        dc0.AgencyCode__c = null;
        insert dc0;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account.Id;
        dc1.AgencyCode__c = 'agency01';
        insert dc1;
        
        // Invalid AccountID
        System.AssertEquals(LinkNgAgencyHelper.getNgAgency('test').ngList.size(), 0);
        System.AssertNotEquals(LinkNgAgencyHelper.getNgAgency(account.Id).hasMore, true);
        
        // HasLess than 10 保全禁止連携代理店 Records
        // Valid AccountID with 保全禁止連携代理店
        System.AssertEquals(LinkNgAgencyHelper.getNgAgency(account.Id).ngList.size(), 1);
        System.AssertNotEquals(LinkNgAgencyHelper.getNgAgency(account.Id).hasMore, true);
    }
}