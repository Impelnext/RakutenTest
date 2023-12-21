@isTest
public with sharing class Patch_CommonDmlOperaionTest {
    
    @isTest static void testMethod_T01(){
        List<Account> accList = new List<Account>();
        accList.add(new Account());
        Test.startTest();
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(accList, 'insert', 'Patch_SS020_CheckExistAccount - MigrationCalling__c');
        Test.stopTest();
    }
    @isTest static void testMethod_T02(){
        MigrationCalling__c callObj = new MigrationCalling__c (
            MigrationCallingId__c = 'yamada',
            Name              = 'yamada',
            MigratedFlag__c   = False,
            FirstName_BD2M__c = '取引先',
            LastName_BD2M__c  = '個人',
            FirstNameKana__c  = 'とりひきさき',
            LastNameKana__c   = 'こじん',
            Birthdate_BD2M__c = Date.newInstance(1985, 1, 1),
            Gender_BD2M__c    = '男性'
        );
        List<MigrationCalling__c> mcList = new List<MigrationCalling__c> ();
        mcList.add(callObj);

        Test.startTest();
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(mcList, 'insert', 'Patch_SS020_CheckExistAccount - MigrationCalling__c');
        Test.stopTest();
    }
    @isTest static void testMethod_T03(){
        MigrationCalling__c callObj = new MigrationCalling__c (
            MigrationCallingId__c = 'yamada',
            Name              = 'yamada',
            MigratedFlag__c   = False,
            FirstName_BD2M__c = '取引先',
            LastName_BD2M__c  = '個人',
            FirstNameKana__c  = 'とりひきさき',
            LastNameKana__c   = 'こじん',
            Birthdate_BD2M__c = Date.newInstance(1985, 1, 1),
            Gender_BD2M__c    = '男性'
        );
        List<MigrationCalling__c> mcList = new List<MigrationCalling__c>();
        mcList.add(callObj);

        insert mcList;

        List<MigrationCalling__c> mcListAfter = [Select id From MigrationCalling__c];

        Test.startTest();
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(mcListAfter, 'update', 'Patch_SS020_CheckExistAccount - MigrationCalling__c');
        Test.stopTest();
    }
}