/*
* @Class Name      : CommonUtilityTest
* @Description     : CommonUtilityハンドラTestClass
* @Created Date    : 2020.05.22
* @Created By      : Valsala Kumar J
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class CommonUtilityTest {
    
    @isTest
    static void CommonUtilityTest_getAccounts()
    {
        CommonUtilityTest triggerTest = new CommonUtilityTest();
        List<Account> accList = new List<Account>();
        List<AccountInfo> accInfoList = new List<AccountInfo>();
        
        // With AccountId matching
        Account account1 = triggerTest.createAccount();
        account1.furiganaLast__pc += '01';
        accList.add(account1);
        AccountInfo accInfo1 = triggerTest.createAccountInfo();
        triggerTest.setNameInfo(accInfo1);
        triggerTest.setOtherParams(accInfo1);
        accInfo1.toUpdate = true;
        accInfoList.add(accInfo1);
        
        // With Name and HomePhone matching
        Account account2 = triggerTest.createAccount();
        account2.furiganaLast__pc += '02';
        accList.add(account2);
        AccountInfo accInfo2 = triggerTest.createAccountInfo();
        accInfo2.lastnamekana = account2.furiganaLast__pc;
        accInfo2.mobilephone = NULL;
        accInfo2.birthdate = NULL;
        triggerTest.setNameInfo(accInfo2);
        triggerTest.setOtherParams(accInfo2);
        accInfo2.toUpdate = true;
        accInfoList.add(accInfo2);
        
        // With Name and MobilePhone matching
        Account account3 = triggerTest.createAccount();
        account3.furiganaLast__pc += '03';
        accList.add(account3);
        AccountInfo accInfo3 = triggerTest.createAccountInfo();
        accInfo3.lastnamekana = account3.furiganaLast__pc;
        accInfo3.homephone = NULL;
        accInfo3.birthdate = NULL;
        triggerTest.setNameInfo(accInfo3);
        triggerTest.setOtherParams(accInfo3);
        accInfo3.toUpdate = true;
        accInfoList.add(accInfo3);
        
        // With Name and BirthDate, Gender matching
        Account account4 = triggerTest.createAccount();
        account4.furiganaLast__pc += '04';
        accList.add(account4);
        AccountInfo accInfo4 = triggerTest.createAccountInfo();
        accInfo4.lastnamekana = account4.furiganaLast__pc;
        accInfo4.homephone = NULL;
        accInfo4.mobilephone = NULL;
        triggerTest.setNameInfo(accInfo4);
        triggerTest.setOtherParams(accInfo4);
        accInfo4.toUpdate = true;
        accInfoList.add(accInfo4);
        
        // With No matching
        AccountInfo accInfo5 = triggerTest.createAccountInfo();
        accInfo5.lastnamekana += '05';
        triggerTest.setNameInfo(accInfo5);
        triggerTest.setOtherParams(accInfo5);
        accInfo5.toUpdate = true;
        accInfoList.add(accInfo5);
        
        // With No matching and No Name
        AccountInfo accInfo6 = triggerTest.createAccountInfo();
        accInfo6.lastname = NULL;
        accInfo6.firstname = NULL;
        triggerTest.setNameInfo(accInfo6);
        triggerTest.setOtherParams(accInfo6);
        accInfo6.toUpdate = true;
        accInfoList.add(accInfo6);
        
        Test.startTest();
        
        // Create New Accounts
        insert accList;
        
        // Search with AccountId for First Entry
        accInfoList[0].accountId = accList[0].Id;
        
        // Get Existing and New Accounts for Searched AccountInfo
        CommonUtility util = new CommonUtility();
        List<Account> dbAccountList = util.getAccounts(accInfoList);
        
        Test.stopTest();
        
        System.assertEquals(dbAccountList.size(), accInfoList.size());
        System.assertEquals(dbAccountList[0].ID, accList[0].ID);
        System.assertEquals(dbAccountList[1].ID, accList[1].ID);
        System.assertEquals(dbAccountList[2].ID, accList[2].ID);
        System.assertEquals(dbAccountList[3].ID, accList[3].ID);
        System.assertNotEquals(dbAccountList[4].ID, NULL);
        System.assertNotEquals(dbAccountList[5].ID, NULL);
        
        Account dbAccount = [SELECT Id, LastName, FirstName, 
                                    furiganaLast__pc, furiganaForst__pc, 
                                    StopCallingFlg__c, LifeAgreeDay__pc, 
                                    CorrespondingDateAndTime__c, Age__pc 
                             FROM Account 
                             WHERE ID = :dbAccountList[0].ID];
        System.assertEquals(dbAccount.LastName, accInfoList[0].lastname);
        System.assertEquals(dbAccount.FirstName, accInfoList[0].firstname);
        System.assertEquals(dbAccount.furiganaLast__pc, accInfoList[0].lastnamekana);
        System.assertEquals(dbAccount.furiganaForst__pc, accInfoList[0].firstnamekana);
        System.assertEquals(dbAccount.StopCallingFlg__c, true);
        System.assertNotEquals(dbAccount.LifeAgreeDay__pc, NULL);
        System.assertNotEquals(dbAccount.CorrespondingDateAndTime__c, NULL);
        System.assertEquals(dbAccount.Age__pc, 40);
    }
    
    
    private AccountInfo createAccountInfo(){
        AccountInfo accInfo = new AccountInfo();
        accInfo.lastname = '個人';
        accInfo.firstname = '取引先';
        accInfo.lastnamekana = 'コジン';
        accInfo.firstnamekana = 'トリヒキサキ';
        accInfo.homephone = '11-1111-1111';
        accInfo.mobilephone = '22-2222-2222';
        accInfo.birthdate = date.newInstance(1998, 1, 10);
        accInfo.gender = '女性';
        accInfo.postalcode = '111-0000';
        accInfo.state = '東京都';
        accInfo.city = '世田谷区';
        accInfo.street = '玉川１－１４－１';
        accInfo.email = 'example01@example.com';
        return accInfo;
    }
    
    
    private void setOtherParams(AccountInfo src) {
        // Other Info
        Map<String, String> params = new Map<String, String>();
        params.put('StopCallingFlg__c', 'true');
        params.put('LifeAgreeDay__pc', System.Now().format('yyyy-MM-dd'));
        params.put('CorrespondingDateAndTime__c', System.Now().format('yyyy-MM-dd HH:mm:ss'));
        params.put('Age__pc', '40');
        src.params = params;
    }
    
    
    private void setNameInfo(AccountInfo src) {
        //氏名のキー情報作成
        src.nameinfo =  toSafeString(src.lastname) + 
                        toSafeString(src.firstname) + 
                        toSafeString(src.lastnamekana) +  
                        toSafeString(src.firstnamekana);
        src.nameinfo = src.nameinfo.deleteWhitespace();
    }
    
    private String toSafeString(String str) {
        return String.IsNotBlank(str) ? str : '';
    }
    
    
    private Account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先'];
        return new Account(
            LastName = '個人',
            FirstName = '取引先',
            furiganaLast__pc = 'コジン',
            furiganaForst__pc = 'トリヒキサキ',
            PersonHomePhone = '11-1111-1111',
            PersonMobilePhone = '22-2222-2222',
            PersonBirthdate = date.newInstance(1998, 1, 10),
            Gender__pc = '女性',
            SYSAccountName__c = '楽天太郎ﾗｸﾃﾝﾀﾛｳ',
            PersonMailingPostalCode = '111-0000',
            PersonMailingState = '東京都',
            PersonMailingCity = '世田谷区',
            PersonMailingStreet = '玉川１－１４－１',
            PersonEmail = 'example01@example.com',
            RecordTypeId=recordTypes[0].Id
        );
    }
}