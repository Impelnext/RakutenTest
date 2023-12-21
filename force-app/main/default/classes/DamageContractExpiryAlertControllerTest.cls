/****************************************************************************************/
/* Class Name       : DamageContractExpiryAlertController                               */
/* Description      : 損保契約情報画面で損保有効契約の満期日アラートクラスのテストクラス*/
/* @Created Date    : 2022.04.07                                                        */
/* @Created By      : SRM Offshore                                                      */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@IsTest
public class DamageContractExpiryAlertControllerTest {
    
    @IsTest
    public static void checkAlertFlagON(){
        
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'TestContractExpiryAlert';
        insert account;
        
        DamageContract__c dc = new DamageContract__c();
        dc.AccountId__c = account.Id;
        dc.AgencyCode__c = 'TEST12';
        DateTime thisday = System.Now();
        DateTime startDate = thisday.addMonths(-1);
        DateTime endDate = thisday.addMonths(2);
        dc.ContractStartDate__c = startDate.format('yyyyMMdd');
        dc.ContractEndDate__c = endDate.format('yyyyMMdd');
        insert dc;
        
        System.assertEquals(DamageContractExpiryAlertController.isMaturitySoon(dc.Id), TRUE);
    }
    
    @IsTest
    public static void checkAlertFlagOFF(){
        
        RecordType recordType =  [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType
                                    WHERE Name = '個人取引先'
                                     AND SobjectType = 'Account'];
        Account account = new Account();
        account.RecordTypeId = recordType.Id;
        account.LastName = 'TestContractExpiryAlert';
        insert account;
        
        DamageContract__c dc = new DamageContract__c();
        dc.AccountId__c = account.Id;
        dc.AgencyCode__c = 'TEST12';
        DateTime thisday = System.Now();
        DateTime startDate = thisday.addMonths(-1);
        DateTime endDate = thisday.addMonths(3);
        dc.ContractStartDate__c = startDate.format('yyyyMMdd');
        dc.ContractEndDate__c = endDate.format('yyyyMMdd');
        insert dc;
        
        System.assertEquals(DamageContractExpiryAlertController.isMaturitySoon(dc.Id), FALSE);
    }
}