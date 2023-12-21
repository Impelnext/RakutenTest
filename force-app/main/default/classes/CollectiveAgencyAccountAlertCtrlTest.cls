/****************************************************************************************/
/* Class Name       : CollectiveAgencyAccountAlertCtrlTest                              */
/* Description      : 集団扱い代理店アラートクラスのテストクラス                        */
/* @Created Date    : 2021.07.27                                                        */
/* @Created By      : SRM                                                               */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@IsTest
public class CollectiveAgencyAccountAlertCtrlTest{

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
        
        CollectiveAgency__c cag1 = new CollectiveAgency__c();
        cag1.AgencyNo__c = 'test1';
        insert cag1;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account1.Id;
        dc1.AgencyCode__c = 'test1';
        insert dc1;
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.AccountId__c = account2.Id;
        dc2.AgencyCode__c = 'test2';
        insert dc2;
        
        // 取引先がNULL
        System.AssertEquals(CollectiveAgencyAccountAlertController.getWarningAgency(null).collectiveList.size(), 0);
        System.AssertEquals(CollectiveAgencyAccountAlertController.getWarningAgency(null).hasMore, NULL);
        
        // 取引先には連携NG代理店はある
        System.AssertEquals(CollectiveAgencyAccountAlertController.getWarningAgency(account1.Id).collectiveList.size(), 1);
        System.AssertEquals(CollectiveAgencyAccountAlertController.getWarningAgency(account1.Id).hasMore, NULL);
        
        // 取引先には連携NG代理店はありません
        System.AssertEquals(CollectiveAgencyAccountAlertController.getWarningAgency(account2.Id).collectiveList.size(), 0);
        System.AssertEquals(CollectiveAgencyAccountAlertController.getWarningAgency(account2.Id).hasMore, NULL);
    }
}