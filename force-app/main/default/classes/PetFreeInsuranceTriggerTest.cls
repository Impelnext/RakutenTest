/*
* @Class Name      : PetFreeInsuranceTriggerTest 
* @Description     : ペットフリー保険トリガーハンドラテストクラス
* @Created Date    : 2020.08.07
* @Created By      : Valsala Kumar
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class PetFreeInsuranceTriggerTest
{
    @isTest
    static void PetFreeInsuranceTriggerTest_AccountId()
    {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        
        Test.startTest();
        PetFreeInsurance__c petFreeIns = triggerTest.createPetFreeInsurance(account.Id);
        insert petFreeIns;
        Test.stopTest();
        
        petFreeIns = triggerTest.getPetFreeInsuranceById(petFreeIns.Id);
        Account acc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, acc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, acc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(petFreeIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(petFreeIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, acc.Gender__pc);
        System.assertEquals(petFreeIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, acc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, acc.PersonEmail);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_non_AccountId()
    {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        
        Test.startTest();
        PetFreeInsurance__c petFreeIns = triggerTest.createPetFreeInsurance(null);
        insert petFreeIns;
        Test.stopTest();
        
        petFreeIns = triggerTest.getPetFreeInsuranceById(petFreeIns.Id);
        Account acc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, acc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, acc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(petFreeIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(petFreeIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, acc.Gender__pc);
        System.assertEquals(petFreeIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, acc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_non_Account_easy_Id_unmatch() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  triggerTest.createAccount();
        account = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        PetFreeInsurance__c petFreeIns = triggerTest.createPetFreeInsurance(null);
        petFreeIns.easyId__c = null;
        insert petFreeIns;
        Test.stopTest();
        
        petFreeIns = triggerTest.getPetFreeInsuranceById(petFreeIns.Id);
        Account acc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, acc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, acc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(petFreeIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(petFreeIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, acc.Gender__pc);
        System.assertEquals(petFreeIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, acc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_non_Account_easy_Id_match() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(null);
        sp.easyId__c = acc.easyId__pc;
        insert sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(petFreeIns.accountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertNotEquals(petFreeIns.accountId__c, acc.Id);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_name_phone() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.Phone__c  = account.PersonHomePhone;
        insert sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(petFreeIns.accountId__c, resultAcc.Id);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_name_phone2() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.MobilePhone__c = account.PersonHomePhone;
        insert sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(petFreeIns.accountId__c, resultAcc.Id);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_name_mobilephone() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.Phone__c  = account.PersonMobilePhone;
        insert sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(petFreeIns.accountId__c, resultAcc.Id);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_name_mobilephone2() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.MobilePhone__c = account.PersonMobilePhone;
        insert sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(petFreeIns.accountId__c, resultAcc.Id);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerTest_name_gender_Birthdate() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.Gender__c = account.Gender__pc;
        sp.Birthday__c = account.PersonBirthdate;
        insert sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(petFreeIns.AccountId__c);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(petFreeIns.accountId__c, resultAcc.Id);
    }
    
    
    @isTest
    static void onBeforeUpdateProccessTest() {
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(account.Id);
        insert sp;
        update sp;
        Test.stopTest();
        
        PetFreeInsurance__c petFreeIns = triggerTest.getPetFreeInsuranceById(sp.Id);
        Account resultAcc = triggerTest.getAccountById(acc.Id);
        
        System.assertEquals(petFreeIns.LastName__c, resultAcc.LastName);
        System.assertEquals(petFreeIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(petFreeIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(petFreeIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(petFreeIns.gender__c, resultAcc.Gender__pc);
        System.assertEquals(petFreeIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(petFreeIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(petFreeIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(petFreeIns.accountId__c, resultAcc.Id);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerAccountName_Phone_MatchTest(){
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        triggerTest.waitSeconds(1);
        
        Account act = [Select LastName From Account limit 1];
        Account account2 = triggerTest.createAccount();
        account2.LastName = act.LastName;
        // System.DmlException: Insert failed. 
        // First exception on row 0; 
        // first error: DUPLICATES_DETECTED, いずれか 1 つのレコードを使用しますか?: []
        //insert  account2;
        
        Test.startTest();
        PetFreeInsurance__c petFreeIns = triggerTest.createPetFreeInsurance(null);
        petFreeIns.LastName__c = '個人';
        petFreeIns.FirstName__c = '取引先';
        petFreeIns.LastNameFurigana__c = 'コジン';
        petFreeIns.FirstNameFurigana__c = 'トリヒキサキ';
        petFreeIns.Phone__c = '11-1111-1111';
        insert petFreeIns;
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM PetFreeInsurance__c WHERE Id =: petFreeIns.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(petFreeIns.LastName__c, acc.LastName__pc);
        System.assertEquals(petFreeIns.FirstName__c, acc.firstname__pc);
        System.assertEquals(petFreeIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(petFreeIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(petFreeIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, acc.Gender__pc);
        System.assertEquals(petFreeIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, acc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, acc.PersonEmail);
    }
    
    
    @isTest
    static void PetFreeInsuranceTriggerAccountName_Birthday_Gender_MatchTest(){
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        
        Account act = [Select LastName From Account limit 1];
        
        Account account2 = triggerTest.createAccount();
        account2.LastName = act.LastName;
        account2.PersonMailingPostalCode = '111-1234';
        // System.DmlException: Insert failed. 
        // First exception on row 0; 
        // first error: DUPLICATES_DETECTED, いずれか 1 つのレコードを使用しますか?: []
        //insert  account2;
        
        Test.startTest();
        PetFreeInsurance__c petFreeIns = triggerTest.createPetFreeInsurance(null);
        petFreeIns.LastName__c = '個人';
        petFreeIns.FirstName__c = '取引先';
        petFreeIns.LastNameFurigana__c = 'コジン';
        petFreeIns.FirstNameFurigana__c = 'トリヒキサキ';
        petFreeIns.Birthday__c = date.newInstance(1998, 1, 10);
        petFreeIns.Gender__c = '女性';
        insert petFreeIns;
        
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM PetFreeInsurance__c WHERE Id =: petFreeIns.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        List<Account> accList = [Select id from Account];
        System.assertEquals(1, accList.Size());
        System.assertEquals(petFreeIns.LastName__c, acc.LastName__pc);
        System.assertEquals(petFreeIns.FirstName__c, acc.firstname__pc);
        System.assertEquals(petFreeIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(petFreeIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(petFreeIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(petFreeIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(petFreeIns.Gender__c, acc.Gender__pc);
        System.assertEquals(petFreeIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(petFreeIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(petFreeIns.City__c, acc.PersonMailingCity);
        System.assertEquals(petFreeIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(petFreeIns.Email__c, acc.PersonEmail);
    }
    
    
    @isTest
    public static void target_value_changed(){
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(account.Id);
        insert sp;
        // birthdate
        Account before = triggerTest.getAccountById(account.Id);
        sp.Birthday__c = date.newInstance(1991, 11, 21);
        triggerTest.waitSeconds(1);
        update sp;
        Account after = triggerTest.getAccountById(account.Id);
        System.assert(before.lastModifiedDate < after.lastModifiedDate);
        
        // Gender__c
        sp.Gender__c = '女性';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // easyId__c
        sp.easyId__c = '444444';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // Email__c
        sp.Email__c = 'rakuten999999@rexample.com';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // Phone__c
        sp.Phone__c = '9988882222';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // MobilePhone__c
        sp.MobilePhone__c = '9988882222';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // LastName__c
        sp.LastName__c = 'テスト０００１';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // FirstName__c
        sp.FirstName__c = 'テスト０００１';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // LastNameFurigana__c
        sp.LastNameFurigana__c = 'テストレイレイレイイチ';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // FirstNameFurigana__c
        sp.FirstNameFurigana__c = 'テストレイレイレイイチ';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void target_value_changed2(){
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(account.Id);
        insert sp;
        
        // PostCode__c
        sp.PostCode__c = '9870123';
        Account before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        Account after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // Prefecture__c
        sp.Prefecture__c = '東京';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // City__c
        sp.City__c = '品川区';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        // TownName__c
        sp.TownName__c = '高輪１－１－１';
        before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate < after.LastModifiedDate);
        
        Test.stopTest();
        
    }
    
    
    @isTest
    public static void target_value_notchanged(){
        PetFreeInsuranceTriggerTest triggerTest = new PetFreeInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        
        Test.startTest();
        PetFreeInsurance__c sp = triggerTest.createPetFreeInsurance(account.Id);
        insert sp;
        
        // other
        sp.InsuredStatus__c = '有効中';
        Account before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        Account after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate == after.LastModifiedDate);
        
        Test.stopTest();
    }
    
    
    private void waitSeconds(Integer seconds) {
        Long startTime = DateTime.now().getTime();
        Long finishTime = DateTime.now().getTime();
        while ((finishTime - startTime) < seconds * 1000) {
            finishTime = DateTime.now().getTime();
        }
    }
    
    
    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
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
    
    
    private PetFreeInsurance__c createPetFreeInsurance(Id accountId){
        return new PetFreeInsurance__c(
            easyId__c = '1111111', 
            LastName__c = '楽天', 
            FirstName__c = '太郎', 
            LastNameFurigana__c = 'ﾗｸﾃﾝ', 
            FirstNameFurigana__c = 'ﾀﾛｳ', 
            Phone__c = '99-9999-9999', 
            MobilePhone__c = '88-8888-8888',
            Birthday__c = date.newInstance(1990, 11, 21), 
            Gender__c = '男性', 
            PostCode__c = '222-2222', 
            Prefecture__c = '東京都', 
            City__c = '千代田区', 
            TownName__c = '麹町 6-6東急四谷ビル', 
            Email__c = 'example02@example.com', 
            AccountId__c = accountId, 
            OpenId__c = '1111111', 
            MailMagaAgree__c = TRUE, 
            InsuredSeq__c = 123451, 
            EntryDate__c = System.Today(), 
            InsuredStatus__c = '有効中', 
            InsuredNo__c = '12345', 
            ClaimInsuranceFee__c = 1000, 
            InsuranceStartDate__c = System.Today(), 
            InsuranceEndDate__c = System.Today().addYears(10), 
            SyogaiNyuinPayment__c = 1000, 
            MaigoHogoPayment__c = 1000, 
            PetBaisyoPayment__c = 1000, 
            PetLinkageDate__c = System.Today(), 
            Memo__c = 'MEMO', 
            ReturnReason__c = 'TEST', 
            ReturnInsuranceFee__c = 1000, 
            ReturnAgentFee__c = 500, 
            ReturnDate__c = System.Today().addMonths(1)
        );
    }
    
    
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaLast__pc, furiganaForst__pc, 
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, 
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail, LastName__pc, firstname__pc,
                       OperationType__c, OpportunityStatus__c, LastModifiedDate, SystemModStamp 
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    
    
    private PetFreeInsurance__c getPetFreeInsuranceById( Id spId ) {
        return [SELECT Id, Name, 
                       LastName__c, FirstName__c, LastNameFurigana__c, FirstNameFurigana__c, 
                       Phone__c, MobilePhone__c, Birthday__c, Gender__c, 
                       PostCode__c, Prefecture__c, City__c, TownName__c, Email__c, AccountId__c, 
                       PolicyNumber__c, GroupNo__c, GroupName__c, GroupContractorName__c, 
                       PlanCd__c, PlanName__c, InsuredSeq__c, easyId__c, OpenId__c, 
                       ChangeNameFlg__c, LastNameOrg__c, LastNameFuriganaOrg__c, 
                       EntryDate__c, InsuredStatus__c, InsuredNo__c, MailMagaAgree__c, 
                       ClaimInsuranceFee__c, InsuranceStartDate__c, InsuranceEndDate__c, 
                       SyogaiNyuinPayment__c, MaigoHogoPayment__c, PetBaisyoPayment__c, 
                       ChangeDate1__c, ChangeReason1__c, ChangeDate2__c, ChangeReason2__c, ChangeDate3__c, ChangeReason3__c, 
                       AgentCd__c, AgentName__c, AgentFeeRate__c, 
                       TaxRate__c, ReleaseDate__c, ReleaseType__c, 
                       ReturnReason__c, ReturnDate__c, ReturnInsuranceFee__c, ReturnAgentFee__c, Memo__c, 
                       PetLinkageDate__c, ExpirationBeforeNoticeFlg__c, ExpirationNoticeFlg__c 
                FROM   PetFreeInsurance__c 
                WHERE  Id =: spId LIMIT 1];
    }
}