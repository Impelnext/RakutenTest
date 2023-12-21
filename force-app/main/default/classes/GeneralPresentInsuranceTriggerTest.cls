/*
* @Class Name      : GeneralPresentInsuranceTriggerTest 
* @Description     : 損保プレゼント保険トリガーハンドラTestClass
* @Created Date    : 2020.05.14
* @Created By      : Valsala Kumar
* @Modified Date   : 2023.09.13
* @Modified        : Takumi Nagaya
*/
@isTest
public class GeneralPresentInsuranceTriggerTest
{
    @isTest
    static void GeneralPresentInsuranceTriggerTest()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(account.Id);
        insert generalPresentIns;
        Test.stopTest();
        
        generalPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentIns.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_AccountId()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(null);
        insert generalPresentIns;
        Test.stopTest();
        
        generalPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentIns.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        // MyCarPresentIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDate__c, generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c, generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c, generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c, generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c, generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c, generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c, generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentMycarLinkageFlag__c, generalPresentIns.MycarLinkageFlag__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c, generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c, generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c, generalPresentIns.InsExpiryDate1__c);
        // WorkOutIns data
        System.assertEquals(oppt.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForWOI__c, false);
        // MamaFreeIns data
        System.assertEquals(oppt.GeneralPresentUpdateDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryStatusForMama__c, null);
        System.assertEquals(oppt.GeneralPresentInsStartDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentInsEndDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgreeForMama__c, false);
        System.assertEquals(oppt.GeneralPresentMydataShareAgreeForMama__c, false);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForMama__c, false);
        // Other
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
    }

    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_AccountId_for_WorkOutIns()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentIns.Name = 'ワークアウト保険';
        generalPresentIns.EntryDate__c = null;
        generalPresentIns.CrossPermission__c = true;
        generalPresentIns.MydataShareAgree__c = false;
        generalPresentIns.MycarLinkageFlag__c = false;
        generalPresentIns.InsExpiryDate1__c = null;
        generalPresentIns.InsExpiryYearMonth1__c = null;
        insert generalPresentIns;
        Test.stopTest();
        
        generalPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentIns.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('WorkOutInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        // WorkOutIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForWOI__c, generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatusForWOI__c, generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDateForWOI__c, generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDateForWOI__c, generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDateForWOI__c, generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForWOI__c, generalPresentIns.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(oppt.GeneralPresentUpdateDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c, null);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c, null);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c, null);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c, null);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(oppt.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c, null);
        // MamaFreeIns data
        System.assertEquals(oppt.GeneralPresentUpdateDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryStatusForMama__c, null);
        System.assertEquals(oppt.GeneralPresentInsStartDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentInsEndDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgreeForMama__c, false);
        System.assertEquals(oppt.GeneralPresentMydataShareAgreeForMama__c, false);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForMama__c, false);
        // Other
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
    }

    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_AccountId_for_MamaFreeIns()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentIns.Name = '子育てあんしんミニ保険';
        generalPresentIns.InsExpiredDate__c = null;
        generalPresentIns.MycarLinkageFlag__c = false;
        generalPresentIns.InsExpiryDate1__c = null;
        generalPresentIns.InsExpiryYearMonth1__c = null;
        generalPresentIns.CrossPermission__c = false;
        insert generalPresentIns;
        Test.stopTest();
        
        generalPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentIns.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MamaFreeInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        // MamaFreeIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDateForMama__c, generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentEntryNumberForMama__c, generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatusForMama__c, generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDateForMama__c, generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDateForMama__c, generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgreeForMama__c, generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgreeForMama__c, generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForMama__c, generalPresentIns.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(oppt.GeneralPresentUpdateDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c, null);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c, null);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c, null);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c, null);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(oppt.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(oppt.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
    }

    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_AccountId_for_MyCarPresentIns_And_WorkOutIns()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();

        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        GeneralPresentInsurance__c generalPresentInsForMyCarPresentIns = triggerTest.createGeneralPresentInsurance(null);
        insert generalPresentInsForMyCarPresentIns;
        GeneralPresentInsurance__c generalPresentInsForWorkOutIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentInsForWorkOutIns.Name = 'ワークアウト保険';
        generalPresentInsForWorkOutIns.EntryDate__c = null;
        generalPresentInsForWorkOutIns.CrossPermission__c = true;
        generalPresentInsForWorkOutIns.MydataShareAgree__c = false;
        generalPresentInsForWorkOutIns.MycarLinkageFlag__c = false;
        generalPresentInsForWorkOutIns.InsExpiryDate1__c = null;
        generalPresentInsForWorkOutIns.InsExpiryYearMonth1__c = null;
        insert generalPresentInsForWorkOutIns;
        Test.stopTest();

        generalPresentInsForMyCarPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentInsForMyCarPresentIns.Id);
        System.assertEquals(generalPresentInsForMyCarPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        generalPresentInsForWorkOutIns = triggerTest.getGeneralPresentInsuranceById(generalPresentInsForWorkOutIns.Id);
        System.assertEquals(generalPresentInsForWorkOutIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('WorkOutInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentInsForWorkOutIns.AccountId__c);
        System.assertEquals(generalPresentInsForWorkOutIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentInsForWorkOutIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentInsForWorkOutIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentInsForWorkOutIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentInsForWorkOutIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentInsForWorkOutIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentInsForWorkOutIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentInsForWorkOutIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentInsForWorkOutIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentInsForWorkOutIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentInsForWorkOutIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentInsForWorkOutIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');

        Opportunity oppt = triggerTest.getOpportunityById(generalPresentInsForWorkOutIns.OpportunityId__c);
        // MyCarPresentIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDate__c, generalPresentInsForMyCarPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c, generalPresentInsForMyCarPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c, generalPresentInsForMyCarPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c, generalPresentInsForMyCarPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c, generalPresentInsForMyCarPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c, generalPresentInsForMyCarPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c, generalPresentInsForMyCarPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentMycarLinkageFlag__c, generalPresentInsForMyCarPresentIns.MycarLinkageFlag__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c, generalPresentInsForMyCarPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c, generalPresentInsForMyCarPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c, generalPresentInsForMyCarPresentIns.InsExpiryDate1__c);
        // WorkOutIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForWOI__c, generalPresentInsForWorkOutIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatusForWOI__c, generalPresentInsForWorkOutIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDateForWOI__c, generalPresentInsForWorkOutIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDateForWOI__c, generalPresentInsForWorkOutIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDateForWOI__c, generalPresentInsForWorkOutIns.InsExpiredDate__c);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForWOI__c, generalPresentInsForWorkOutIns.CrossPermission__c);
        // Other
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
    }

    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_AccountId_for_MyCarPresentIns_And_WorkOutIns_And_MamaFreeIns()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();

        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        insert  triggerTest.createOpportunity(account.Id);

        Test.startTest();
        GeneralPresentInsurance__c generalPresentInsForMyCarPresentIns = triggerTest.createGeneralPresentInsurance(null);
        insert generalPresentInsForMyCarPresentIns;
        GeneralPresentInsurance__c generalPresentInsForWorkOutIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentInsForWorkOutIns.Name = 'ワークアウト保険';
        generalPresentInsForWorkOutIns.EntryDate__c = null;
        generalPresentInsForWorkOutIns.CrossPermission__c = true;
        generalPresentInsForWorkOutIns.MydataShareAgree__c = false;
        generalPresentInsForWorkOutIns.MycarLinkageFlag__c = false;
        generalPresentInsForWorkOutIns.InsExpiryDate1__c = null;
        generalPresentInsForWorkOutIns.InsExpiryYearMonth1__c = null;
        insert generalPresentInsForWorkOutIns;
        GeneralPresentInsurance__c generalPresentInsForMamaFreeIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentInsForMamaFreeIns.Name = '子育てあんしんミニ保険';
        generalPresentInsForMamaFreeIns.InsExpiredDate__c = null;
        generalPresentInsForMamaFreeIns.MycarLinkageFlag__c = false;
        generalPresentInsForMamaFreeIns.InsExpiryDate1__c = null;
        generalPresentInsForMamaFreeIns.InsExpiryYearMonth1__c = null;
        generalPresentInsForMamaFreeIns.CrossPermission__c = true;
        insert generalPresentInsForMamaFreeIns;
        Test.stopTest();

        generalPresentInsForMyCarPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentInsForMyCarPresentIns.Id);
        System.assertEquals(generalPresentInsForMyCarPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        generalPresentInsForWorkOutIns = triggerTest.getGeneralPresentInsuranceById(generalPresentInsForWorkOutIns.Id);
        System.assertEquals(generalPresentInsForWorkOutIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('WorkOutInsurance').getRecordTypeId());

            generalPresentInsForMamaFreeIns = triggerTest.getGeneralPresentInsuranceById(generalPresentInsForMamaFreeIns.Id);
        System.assertEquals(generalPresentInsForMamaFreeIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MamaFreeInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentInsForMamaFreeIns.AccountId__c);
        System.assertEquals(generalPresentInsForMamaFreeIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentInsForMamaFreeIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentInsForMamaFreeIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentInsForMamaFreeIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentInsForMamaFreeIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentInsForMamaFreeIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentInsForMamaFreeIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentInsForMamaFreeIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentInsForMamaFreeIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentInsForMamaFreeIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentInsForMamaFreeIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentInsForMamaFreeIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');

        Opportunity oppt = triggerTest.getOpportunityById(generalPresentInsForMamaFreeIns.OpportunityId__c);
        // MyCarPresentIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDate__c, generalPresentInsForMyCarPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c, generalPresentInsForMyCarPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c, generalPresentInsForMyCarPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c, generalPresentInsForMyCarPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c, generalPresentInsForMyCarPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c, generalPresentInsForMyCarPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c, generalPresentInsForMyCarPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentMycarLinkageFlag__c, generalPresentInsForMyCarPresentIns.MycarLinkageFlag__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c, generalPresentInsForMyCarPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c, generalPresentInsForMyCarPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c, generalPresentInsForMyCarPresentIns.InsExpiryDate1__c);
        // WorkOutIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(oppt.GeneralPresentEntryNumberForWOI__c, generalPresentInsForWorkOutIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatusForWOI__c, generalPresentInsForWorkOutIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDateForWOI__c, generalPresentInsForWorkOutIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDateForWOI__c, generalPresentInsForWorkOutIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDateForWOI__c, generalPresentInsForWorkOutIns.InsExpiredDate__c);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForWOI__c, generalPresentInsForWorkOutIns.CrossPermission__c);
        // MamaFreeIns data
        System.assertNotEquals(oppt.GeneralPresentUpdateDateForMama__c, null);
        System.assertEquals(oppt.GeneralPresentEntryDateForMama__c, generalPresentInsForMamaFreeIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentEntryNumberForMama__c, generalPresentInsForMamaFreeIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatusForMama__c, generalPresentInsForMamaFreeIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDateForMama__c, generalPresentInsForMamaFreeIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDateForMama__c, generalPresentInsForMamaFreeIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgreeForMama__c, generalPresentInsForMamaFreeIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgreeForMama__c, generalPresentInsForMamaFreeIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentCrossPermissionForMama__c, generalPresentInsForMamaFreeIns.CrossPermission__c);
        // Other
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
    }

    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_Account_easy_Id_unmatch() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  triggerTest.createAccount();
        account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentIns.easyId__c = null;
        insert generalPresentIns;
        Test.stopTest();
        
        generalPresentIns = triggerTest.getGeneralPresentInsuranceById(generalPresentIns.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account acc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, acc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        System.assertEquals(acc.OperationType__c, '割当可');
        System.assertEquals(acc.OpportunityStatus__c, '未対応');
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_non_Account_easy_Id_match() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        acc.easyId__pc = '1111111';
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.easyId__c = acc.easyId__pc;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.accountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertNotEquals(generalPresentIns.accountId__c, acc.Id);
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_name_phone() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.Phone__c  = account.PersonHomePhone;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_name_phone2() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.MobilePhone__c = account.PersonHomePhone;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(2, oppUpt.Size());
        System.assertNotEquals(oppUpt[0].id , generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_name_mobilephone() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.Phone__c  = account.PersonMobilePhone;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_name_mobilephone2() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.MobilePhone__c = account.PersonMobilePhone;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(2, oppUpt.Size());
        System.assertNotEquals(oppUpt[0].id , generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
        
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_name_gender_Birthdate() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.Gender__c = account.Gender__pc;
        sp.Birthday__c = account.PersonBirthdate;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
        
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_ExistHanyoOpp_OppUpdated() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        Opportunity opp =  triggerTest.createOpportunityHanyo(account.Id);
        opp.GeneralPresentUpdateDate__c = null;
        insert opp;
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.MobilePhone__c = account.PersonMobilePhone;
        //sp.MobilePhone__c = account.PersonMobilePhone;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(1, oppUpt.Size());
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertNotEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerTest_ExistHanyoOpp_OppReUpdated() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        Opportunity opp =  triggerTest.createOpportunityHanyo(account.Id);
        opp.GeneralPresentUpdateDate__c = System.Today();
        insert opp;
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(null);
        sp.LastName__c = account.LastName;
        sp.FirstName__c = account.FirstName;
        sp.LastNameFurigana__c = account.furiganaLast__pc;
        sp.FirstNameFurigana__c = account.furiganaForst__pc;
        sp.MobilePhone__c = account.PersonMobilePhone;
        //sp.MobilePhone__c = account.PersonMobilePhone;
        insert sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(generalPresentIns.AccountId__c);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(generalPresentIns.OpportunityId__c);
        System.assertEquals(1, oppUpt.Size());
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertNotEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void onBeforeUpdateProccessTest() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(account.Id);
        insert sp;
        update sp;
        Test.stopTest();
        
        GeneralPresentInsurance__c generalPresentIns = triggerTest.getGeneralPresentInsuranceById(sp.Id);
        System.assertEquals(generalPresentIns.RecordTypeId,
            Schema.SObjectType.GeneralPresentInsurance__c.getRecordTypeInfosByDeveloperName().get('MyCarPresentInsurance').getRecordTypeId());

        Account resultAcc = triggerTest.getAccountById(acc.Id);
        System.assertEquals(generalPresentIns.LastName__c, resultAcc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, resultAcc.FirstName);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, resultAcc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, resultAcc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.Birthday__c, resultAcc.PersonBirthdate);
        System.assertEquals(generalPresentIns.gender__c, resultAcc.Gender__pc);
        System.assertEquals(generalPresentIns.Phone__c, resultAcc.PersonHomePhone);
        System.assertEquals(generalPresentIns.MobilePhone__c, resultAcc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.PostCode__c, resultAcc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, resultAcc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, resultAcc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, resultAcc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, resultAcc.PersonEmail);
        System.assertEquals(generalPresentIns.accountId__c, resultAcc.Id);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerExOppNogeneralPresentInsUpdateTest()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);
        
        Opportunity opp = triggerTest.createOpportunityHanyo(account.Id);
        opp.GeneralPresentUpdateDate__c = null;
        insert opp;
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(account.Id);
        generalPresentIns.LastName__c = '個人';
        generalPresentIns.FirstName__c = '取引先';
        generalPresentIns.LastNameFurigana__c = 'コジン';
        generalPresentIns.FirstNameFurigana__c = 'トリヒキサキ';
        generalPresentIns.Phone__c = '11-1111-1111';
        insert generalPresentIns;
        Test.stopTest();
        
        Account acc = triggerTest.getAccountById(account.Id);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName__pc);
        System.assertEquals(generalPresentIns.FirstName__c, acc.firstname__pc);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName);
        System.assertEquals(generalPresentIns.FirstName__c, acc.firstname);      
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[0].id);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertNotEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerExOppgeneralPresentInsUpdateTest()
    {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();

        Account account = triggerTest.createAccount();
        insert  account;
        account = triggerTest.getAccountById(account.Id);

        Opportunity opp = triggerTest.createOpportunityHanyo(account.Id);
        insert opp;

        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(account.Id);
        generalPresentIns.LastName__c = null;
        generalPresentIns.FirstName__c = null;
        insert generalPresentIns;
        Test.stopTest();
        Account acc = triggerTest.getAccountById(account.Id);
        System.assertEquals('未登録', acc.LastName__pc);
        System.assertEquals(null, acc.firstname__pc);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerAccountName_Phone_MatchTest(){
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
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
        
        Opportunity opp = triggerTest.createOpportunityHanyo(null);
        insert opp;
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentIns.LastName__c = '個人';
        generalPresentIns.FirstName__c = '取引先';
        generalPresentIns.LastNameFurigana__c = 'コジン';
        generalPresentIns.FirstNameFurigana__c = 'トリヒキサキ';
        generalPresentIns.Phone__c = '11-1111-1111';
        insert generalPresentIns;
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM GeneralPresentInsurance__c WHERE Id =: generalPresentIns.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName__pc);
        System.assertEquals(generalPresentIns.FirstName__c, acc.firstname__pc);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt = triggerTest.getOpportunityById(oppUpt[1].id);
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }
    
    @isTest
    static void GeneralPresentInsuranceTriggerAccountName_Birthday_Gender_MatchTest(){
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        
        Account account = triggerTest.createAccount();
        insert  account;
        
        Opportunity opp = triggerTest.createOpportunityHanyo(account.id);
        opp.GeneralPresentUpdateDate__c = null;
        insert opp;
        triggerTest.waitSeconds(1);
        
        Account act = [Select LastName From Account limit 1];
        
        Account account2 = triggerTest.createAccount();
        account2.LastName = act.LastName;
        account2.PersonMailingPostalCode = '111-1234';
        // System.DmlException: Insert failed. 
        // First exception on row 0; 
        // first error: DUPLICATES_DETECTED, いずれか 1 つのレコードを使用しますか?: []
        //insert  account2;
        
        Opportunity opp2 = triggerTest.createOpportunityHanyo(account2.id);
        opp2.GeneralPresentUpdateDate__c = null;
        insert opp2;
        triggerTest.waitSeconds(1);
        
        //  同じ取引先に、同じメーカーのオープンな商談が存在します。: [] Because of this error Commented
        Opportunity opp3 = triggerTest.createOpportunityHanyo(account2.id);
        //insert opp3;
        
        Test.startTest();
        GeneralPresentInsurance__c generalPresentIns = triggerTest.createGeneralPresentInsurance(null);
        generalPresentIns.LastName__c = '個人';
        generalPresentIns.FirstName__c = '取引先';
        generalPresentIns.LastNameFurigana__c = 'コジン';
        generalPresentIns.FirstNameFurigana__c = 'トリヒキサキ';
        generalPresentIns.Birthday__c = date.newInstance(1998, 1, 10);
        generalPresentIns.Gender__c = '女性';
        insert generalPresentIns;
        
        Test.stopTest();
        
        Id accId = [SELECT Id, AccountId__c FROM GeneralPresentInsurance__c WHERE Id =: generalPresentIns.Id LIMIT 1].AccountId__c;
        Account acc = triggerTest.getAccountById(accId);
        List<Account> accList = [Select id from Account];
        System.assertEquals(1, accList.Size());
        System.assertEquals(generalPresentIns.LastName__c, acc.LastName__pc);
        System.assertEquals(generalPresentIns.FirstName__c, acc.firstname__pc);
        System.assertEquals(generalPresentIns.LastNameFurigana__c, acc.furiganaLast__pc);
        System.assertEquals(generalPresentIns.FirstNameFurigana__c, acc.furiganaForst__pc);
        System.assertEquals(generalPresentIns.MobilePhone__c, acc.PersonMobilePhone);
        System.assertEquals(generalPresentIns.Birthday__c, acc.PersonBirthdate);
        System.assertEquals(generalPresentIns.Gender__c, acc.Gender__pc);
        System.assertEquals(generalPresentIns.PostCode__c, acc.PersonMailingPostalCode);
        System.assertEquals(generalPresentIns.Prefecture__c, acc.PersonMailingState);
        System.assertEquals(generalPresentIns.City__c, acc.PersonMailingCity);
        System.assertEquals(generalPresentIns.TownName__c, acc.PersonMailingStreet);
        System.assertEquals(generalPresentIns.Email__c, acc.PersonEmail);
        
        
        List<Opportunity> oppUpt = [Select id From Opportunity ];
        Opportunity oppt1 = triggerTest.getOpportunityById(oppUpt[1].id);
        Opportunity oppt2 = triggerTest.getOpportunityById(oppUpt[0].id);
        Id oppId = [SELECT Id, OpportunityId__c FROM GeneralPresentInsurance__c WHERE Id =: generalPresentIns.Id LIMIT 1].OpportunityId__c;
        Opportunity oppt = triggerTest.getOpportunityById(oppId);
        System.assertEquals(oppt1.StageName , oppt2.StageName);
        System.assertEquals( '未対応', oppt2.StageName);
        System.assertEquals(2,oppUpt.Size());
        System.assertEquals(oppt.GeneralPresentMydataShareAgree__c , generalPresentIns.MydataShareAgree__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryYearMonth1__c , generalPresentIns.InsExpiryYearMonth1__c);
        System.assertEquals(oppt.GeneralPresentInsExpiryDate1__c , generalPresentIns.InsExpiryDate1__c);
        System.assertEquals(oppt.GeneralPresentEntryDate__c , generalPresentIns.EntryDate__c);
        System.assertEquals(oppt.GeneralPresentIpMailMagaAgree__c , generalPresentIns.IpMailMagaAgree__c);
        System.assertEquals(oppt.GeneralPresentEntryNumber__c , generalPresentIns.EntryNumber__c);
        System.assertEquals(oppt.GeneralPresentEntryStatus__c , generalPresentIns.EntryStatus__c);
        System.assertEquals(oppt.GeneralPresentInsStartDate__c , generalPresentIns.InsStartDate__c);
        System.assertEquals(oppt.GeneralPresentInsEndDate__c , generalPresentIns.InsEndDate__c);
        System.assertEquals(oppt.GeneralPresentInsExpiredDate__c , generalPresentIns.InsExpiredDate__c);
        System.assertNotEquals(oppt.InflowRoute__c, '損保プレゼント保険');
        System.assertNotEquals(oppt.GeneralPresentUpdateDate__c, null);
    }

    @isTest
    public static void target_value_changed(){
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(account.Id);
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
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(account.Id);
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
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Account acc = triggerTest.createAccount();
        insert  acc;
        
        Account account = triggerTest.getAccountById(acc.Id);
        insert  triggerTest.createOpportunity(account.Id);
        
        Test.startTest();
        GeneralPresentInsurance__c sp = triggerTest.createGeneralPresentInsurance(account.Id);
        insert sp;
        
        // other
        sp.EntryStatus__c = '加入ステータス2';
        Account before = triggerTest.getAccountById(account.Id);
        triggerTest.waitSeconds(1);
        update sp;
        Account after = triggerTest.getAccountById(account.Id);
        System.assert(before.LastModifiedDate == after.LastModifiedDate);
        
        Test.stopTest();
    }

    @isTest
    public static void target_value_changed_for_WorkOutIns() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Test.startTest();
        GeneralPresentInsurance__c gpi = triggerTest.createGeneralPresentInsurance(null);
        gpi.Name = 'ワークアウト保険';
        gpi.CrossPermission__c = true;
        // マイカー割プレゼント保険項目の初期化
        gpi.EntryDate__c = null;
        gpi.MydataShareAgree__c = false;
        gpi.MycarLinkageFlag__c = false;
        gpi.InsExpiryDate1__c = null;
        gpi.InsExpiryYearMonth1__c = null;
        insert gpi;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);

        Opportunity opp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assertNotEquals(opp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(opp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(opp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(opp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(opp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(opp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(opp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(opp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(opp.GeneralPresentEntryDate__c, null);
        System.assertEquals(opp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(opp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(opp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(opp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(opp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(opp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(opp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(opp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(opp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(opp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(opp.InflowRoute__c, '損保プレゼント保険');

        // update 加入者番号(ワークアウト保険)
        Datetime beforeGeneralPresentUpdateDateForWOI = opp.GeneralPresentUpdateDateForWOI__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.EntryNumber__c = gpi.EntryNumber__c + 'test';
        triggerTest.waitSeconds(1);
        update gpi;
        Opportunity afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForWOI__c > beforeGeneralPresentUpdateDateForWOI);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 加入ステータス(ワークアウト保険)
        beforeGeneralPresentUpdateDateForWOI = afterOpp.GeneralPresentUpdateDateForWOI__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.EntryStatus__c = gpi.EntryStatus__c + 'test';
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForWOI__c > beforeGeneralPresentUpdateDateForWOI);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 無料保険始期日(ワークアウト保険)
        beforeGeneralPresentUpdateDateForWOI = afterOpp.GeneralPresentUpdateDateForWOI__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.InsStartDate__c = gpi.InsStartDate__c.addDays(1);
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForWOI__c > beforeGeneralPresentUpdateDateForWOI);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 無料保険満期日(ワークアウト保険)
        beforeGeneralPresentUpdateDateForWOI = afterOpp.GeneralPresentUpdateDateForWOI__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.InsEndDate__c = gpi.InsEndDate__c.addDays(1);
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForWOI__c > beforeGeneralPresentUpdateDateForWOI);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 無料保険失効日(ワークアウト保険)
        beforeGeneralPresentUpdateDateForWOI = afterOpp.GeneralPresentUpdateDateForWOI__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.InsExpiredDate__c = gpi.InsExpiredDate__c.addDays(1);
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForWOI__c > beforeGeneralPresentUpdateDateForWOI);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update クロスパーミッション(ワークアウト保険)
        beforeGeneralPresentUpdateDateForWOI = afterOpp.GeneralPresentUpdateDateForWOI__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.CrossPermission__c = gpi.CrossPermission__c ? false : true;
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // WorkOutIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForWOI__c > beforeGeneralPresentUpdateDateForWOI);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, gpi.InsExpiredDate__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

    }

@isTest
    public static void target_value_changed_for_MamaFreeIns() {
        GeneralPresentInsuranceTriggerTest triggerTest = new GeneralPresentInsuranceTriggerTest();
        Test.startTest();
        GeneralPresentInsurance__c gpi = triggerTest.createGeneralPresentInsurance(null);
        gpi.Name = '子育てあんしんミニ保険';
        // マイカー割プレゼント保険項目の初期化
        gpi.InsExpiredDate__c = null;
        gpi.MycarLinkageFlag__c = false;
        gpi.InsExpiryDate1__c = null;
        gpi.InsExpiryYearMonth1__c = null;
        insert gpi;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);

        Opportunity opp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assertNotEquals(opp.GeneralPresentUpdateDateForMama__c, null);
        System.assertEquals(opp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(opp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(opp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(opp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(opp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(opp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(opp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(opp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(opp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(opp.GeneralPresentEntryDate__c, null);
        System.assertEquals(opp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(opp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(opp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(opp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(opp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(opp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(opp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(opp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(opp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(opp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(opp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(opp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(opp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(opp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(opp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(opp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(opp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(opp.InflowRoute__c, '損保プレゼント保険');

        // update 申込日時(ママ割フリー保険)
        Datetime beforeGeneralPresentUpdateDateForMama = opp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.EntryDate__c = gpi.EntryDate__c.addDays(1);
        triggerTest.waitSeconds(1);
        update gpi;
        Opportunity afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 加入者番号(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = opp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.EntryNumber__c = gpi.EntryNumber__c + 'test';
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 加入ステータス(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = afterOpp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.EntryStatus__c = gpi.EntryStatus__c + 'test';
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 無料保険始期日(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = afterOpp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.InsStartDate__c = gpi.InsStartDate__c.addDays(1);
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update 無料保険満期日(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = afterOpp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.InsEndDate__c = gpi.InsEndDate__c.addDays(1);
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update IPメルマガ購読同意(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = afterOpp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.IpMailMagaAgree__c = gpi.IpMailMagaAgree__c ? false : true;
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update MYDATA情報提供同意フラグ(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = afterOpp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.MydataShareAgree__c = gpi.MydataShareAgree__c ? false : true;
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

        // update クロスパーミッション(ママ割フリー保険)
        beforeGeneralPresentUpdateDateForMama = afterOpp.GeneralPresentUpdateDateForMama__c;
        gpi = triggerTest.getGeneralPresentInsuranceById(gpi.Id);
        gpi.CrossPermission__c = gpi.CrossPermission__c ? false : true;
        triggerTest.waitSeconds(1);
        update gpi;
        afterOpp = triggerTest.getOpportunityById(gpi.OpportunityId__c);
        // MamaFreeIns data
        System.assert(afterOpp.GeneralPresentUpdateDateForMama__c > beforeGeneralPresentUpdateDateForMama);
        System.assertEquals(afterOpp.GeneralPresentEntryDateForMama__c, gpi.EntryDate__c);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForMama__c, gpi.EntryNumber__c);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForMama__c, gpi.EntryStatus__c);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForMama__c, gpi.InsStartDate__c);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForMama__c, gpi.InsEndDate__c);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgreeForMama__c, gpi.IpMailMagaAgree__c);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgreeForMama__c, gpi.MydataShareAgree__c);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForMama__c, gpi.CrossPermission__c);
        // MyCarPresentIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumber__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatus__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDate__c, null);
        System.assertEquals(afterOpp.GeneralPresentIpMailMagaAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentMycarLinkageFlag__c, false);
        System.assertEquals(afterOpp.GeneralPresentMydataShareAgree__c, false);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryYearMonth1__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiryDate1__c, null);
        // WorkOutIns data
        System.assertEquals(afterOpp.GeneralPresentUpdateDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryNumberForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentEntryStatusForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsStartDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsEndDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentInsExpiredDateForWOI__c, null);
        System.assertEquals(afterOpp.GeneralPresentCrossPermissionForWOI__c, false);
        // Other
        System.assertEquals(afterOpp.InflowRoute__c, '損保プレゼント保険');

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
    
    private GeneralPresentInsurance__c createGeneralPresentInsurance(Id accountId){
        return new GeneralPresentInsurance__c(
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
            MydataShareAgree__c = TRUE,
            InsExpiryYearMonth1__c = Datetime.now().addYears(1).format('yyyyMM'), 
            InsExpiryDate1__c = System.Today().addYears(1), 
            EntryDate__c = System.Today(), 
            IpMailMagaAgree__c = TRUE, 
            EntryNumber__c = '12345T', 
            EntryStatus__c = '加入ステータス1', 
            InsStartDate__c = System.Today().addMonths(1), 
            InsEndDate__c = System.Today().addMonths(10), 
            InsExpiredDate__c = System.Today().addYears(1)
        );
    }
    
    private Opportunity createOpportunity(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '生保' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Opportunity(
            Name = '1111111',
            AccountId = accountId,
            StageName = '未対応',
            FirstCallDateTime__c = System.today(),
            FirstProbability__c = 'test',
            CloseDate = System.today(),
            RecordTypeId=recordTypes[0].Id
        );
    }
    
    private Opportunity createOpportunityHanyo(Id accountId) {
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Opportunity' 
                                        And    Name = '汎用' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Opportunity(
            Name = '1111111',
            AccountId = accountId,
            StageName = '未対応',
            FirstCallDateTime__c = System.today(),
            FirstProbability__c = 'test',
            CloseDate = System.today(),
            RecordTypeId=recordTypes[0].Id,
            GeneralPresentUpdateDate__c = System.now()
        );
    }
    
    private Account getAccountById( Id accountId ) {
        return [SELECT Id, Name, LastName, FirstName, furiganaLast__pc, furiganaForst__pc, 
                       PersonHomePhone, PersonMobilePhone, PersonBirthdate, Gender__pc, 
                       SYSAccountName__c, PersonMailingPostalCode, PersonMailingState, 
                       PersonMailingCity, PersonMailingStreet, PersonEmail,LastName__pc,firstname__pc,
                       OperationType__c,OpportunityStatus__c, LastModifiedDate, SystemModStamp 
                FROM   Account
                WHERE  Id =: accountId LIMIT 1];
    }
    
    private GeneralPresentInsurance__c getGeneralPresentInsuranceById( Id spId ) {
        return [SELECT Id, Name, easyId__c, OpportunityId__c, 
                       LastName__c, FirstName__c, LastNameFurigana__c, FirstNameFurigana__c, 
                       Phone__c, MobilePhone__c, Birthday__c, Gender__c, 
                       PostCode__c, Prefecture__c, City__c, TownName__c, Email__c, AccountId__c, 
                       MydataShareAgree__c, InsExpiryYearMonth1__c, InsExpiryDate1__c, EntryDate__c, 
                       IpMailMagaAgree__c, EntryNumber__c, EntryStatus__c, 
                       InsStartDate__c, InsEndDate__c, InsExpiredDate__c,
                       RecordTypeId, CrossPermission__c, MycarLinkageFlag__c
                FROM   GeneralPresentInsurance__c 
                WHERE  Id =: spId LIMIT 1];
    }
    
    private Opportunity getOpportunityById( Id oppId ) {
        return [SELECT GeneralPresentUpdateDate__c, GeneralPresentMydataShareAgree__c, GeneralPresentInsExpiryYearMonth1__c,
                       GeneralPresentInsExpiryDate1__c, GeneralPresentEntryDate__c, GeneralPresentIpMailMagaAgree__c,
                       GeneralPresentEntryNumber__c, GeneralPresentEntryStatus__c, GeneralPresentInsStartDate__c,
                       GeneralPresentInsEndDate__c, GeneralPresentInsExpiredDate__c, GeneralPresentMycarLinkageFlag__c,
                       GeneralPresentUpdateDateForWOI__c, GeneralPresentEntryNumberForWOI__c,
                       GeneralPresentEntryStatusForWOI__c, GeneralPresentInsStartDateForWOI__c, GeneralPresentInsEndDateForWOI__c,
                       GeneralPresentInsExpiredDateForWOI__c, GeneralPresentCrossPermissionForWOI__c,
                       GeneralPresentUpdateDateForMama__c, GeneralPresentEntryDateForMama__c, GeneralPresentEntryNumberForMama__c,
                       GeneralPresentEntryStatusForMama__c, GeneralPresentIpMailMagaAgreeForMama__c, GeneralPresentMydataShareAgreeForMama__c,
                       GeneralPresentInsStartDateForMama__c, GeneralPresentInsEndDateForMama__c, GeneralPresentCrossPermissionForMama__c,
                       InflowRoute__c, StageName 
                FROM Opportunity 
                WHERE  Id =: oppId LIMIT 1];
    }
}