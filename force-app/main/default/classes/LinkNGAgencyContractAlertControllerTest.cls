/****************************************************************************************/
/* Class Name       : LinkNGAgencyContractAlertControllerTest                           */
/* Description      : 損保契約情報画面での保全禁止連携代理店アラートクラスのテストクラス*/
/* @Created Date    : 2021.03.11                                                        */
/* @Created By      : Valsala Kumar J                                                   */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@IsTest
public class LinkNGAgencyContractAlertControllerTest {

    @IsTest
    public static void m1() {
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'name';
        insert account;
        
        LinkNGAgencyCode__c nga1 = new LinkNGAgencyCode__c();
        nga1.AgencyCode__c = 'test1';
        insert nga1;
        
        DamageContract__c dc1 = new DamageContract__c();
        dc1.AccountId__c = account.Id;
        dc1.AgencyCode__c = 'test1';
        insert dc1;
        
        DamageContract__c dc2 = new DamageContract__c();
        dc2.AccountId__c = account.Id;
        dc2.AgencyCode__c = 'test2';
        insert dc2;
        
        // 損保契約がNULL
        System.AssertEquals(LinkNGAgencyContractAlertController.isNGAgencyContract(null), false);
        
        // 損保契約が連携NG代理店
        System.AssertEquals(LinkNGAgencyContractAlertController.isNGAgencyContract(dc1.Id), true);
        
        // 損保契約が連携NG代理店ない
        System.AssertEquals(LinkNGAgencyContractAlertController.isNGAgencyContract(dc2.Id), false);
    }
}