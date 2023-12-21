/****************************************************************************************/
/* Class Name       : CollectiveAgencyContractAlertCtrlTest                             */
/* Description      : 損保契約情報画面での集団扱い代理店アラートクラスのテストクラス    */
/* @Created Date    : 2021.07.20                                                        */
/* @Created By      : SRM                                                               */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@IsTest
public class CollectiveAgencyContractAlertCtrlTest {

    @IsTest
    public static void m1() {
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'name';
        insert account;
        
        CollectiveAgency__c cag1 = new CollectiveAgency__c();
        cag1.AgencyNo__c = 'test1';
        insert cag1;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account.Id;
        dc1.AgencyCode__c = 'test1';
        insert dc1;
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.AccountId__c = account.Id;
        dc2.AgencyCode__c = 'test2';
        insert dc2;
        
        // 損保契約がNULL
        System.AssertEquals(CollectiveAgencyContractAlertController.isCollectiveAgencyContract(null), false);
        
        // 損保契約が集団扱い代理店
        System.AssertEquals(CollectiveAgencyContractAlertController.isCollectiveAgencyContract(dc1.Id), true);
        
        // 損保契約が集団扱い代理店ない
        System.AssertEquals(CollectiveAgencyContractAlertController.isCollectiveAgencyContract(dc2.Id), false);
    }
}