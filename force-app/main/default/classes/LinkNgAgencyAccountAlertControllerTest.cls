/****************************************************************************************/
/* Class Name       : LinkNgAgencyAccountAlertControllerTest                            */
/* Description      : 保全禁止連携代理店アラートクラスのテストクラス                    */
/* @Created Date    : 2021.03.11                                                        */
/* @Created By      : Valsala Kumar J                                                   */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@IsTest
public class LinkNgAgencyAccountAlertControllerTest {

    @IsTest
    public static void m1() {
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account1 = new Account();
        account1.RecordTypeId = recordType.Id;
        account1.LastName = 'name';
        insert account1;
        
        Account account2 = new Account();
        account2.RecordTypeId = recordType.Id;
        account2.LastName = 'name';
        insert account2;
        
        LinkNGAgencyCode__c nga1 = new LinkNGAgencyCode__c();
        nga1.AgencyCode__c = 'test1';
        insert nga1;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account1.Id;
        dc1.AgencyCode__c = 'test1';
        insert dc1;
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.AccountId__c = account2.Id;
        dc2.AgencyCode__c = 'test2';
        insert dc2;
        
        // 取引先がNULL
        System.AssertEquals(LinkNgAgencyAccountAlertController.getWarningAgency(null).ngList.size(), 0);
        System.AssertEquals(LinkNgAgencyAccountAlertController.getWarningAgency(null).hasMore, NULL);
        
        // 取引先には連携NG代理店はある
        System.AssertEquals(LinkNgAgencyAccountAlertController.getWarningAgency(account1.Id).ngList.size(), 1);
        System.AssertEquals(LinkNgAgencyAccountAlertController.getWarningAgency(account1.Id).hasMore, NULL);
        
        // 取引先には連携NG代理店はありません
        System.AssertEquals(LinkNgAgencyAccountAlertController.getWarningAgency(account2.Id).ngList.size(), 0);
        System.AssertEquals(LinkNgAgencyAccountAlertController.getWarningAgency(account2.Id).hasMore, NULL);
    }
}