@isTest
public with sharing class Patch_SS020_CheckExistAccountTest {
    
    @isTest static void testMethod_T01(){

        Test.startTest();
        Patch_SS020_CheckExistAccount batchable = new Patch_SS020_CheckExistAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MigrationCalling__c> resultMigList = [Select id
                                                         ,MigrationCallingId__c
                                                         ,MigratedFlag__c
                                                         ,AccountId__c
                                                         ,AccountId__r.Migration_ID2__c
                                                   From MigrationCalling__c
                                                   Where MigrationCallingId__c = 'K01'];
        Map<String, MigrationCalling__c> resultMigMap = new Map<String, MigrationCalling__c>();
        for(MigrationCalling__c result : resultMigList){
            resultMigMap.put(result.MigrationCallingId__c, result);
        }

        //K01は取引先に存在していることを確認
        System.assertEquals(True, resultMigMap.get('K01').MigratedFlag__c);
        //架電オブジェクトに取引先とのリレーションが作成されていることを確認
        System.assertEquals('K01', resultMigMap.get('K01').AccountId__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T02(){

        Test.startTest();
        Patch_SS020_CheckExistAccount batchable = new Patch_SS020_CheckExistAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MigrationCalling__c> resultMigList = [Select id
                                                         ,MigrationCallingId__c
                                                         ,MigratedFlag__c
                                                         ,AccountId__c
                                                         ,AccountId__r.Migration_ID2__c
                                                   From MigrationCalling__c
                                                   Where MigrationCallingId__c = 'K02'];
        Map<String, MigrationCalling__c> resultMigMap = new Map<String, MigrationCalling__c>();
        for(MigrationCalling__c result : resultMigList){
            resultMigMap.put(result.MigrationCallingId__c, result);
        }

        //K01は取引先に存在していることを確認
        System.assertEquals(False, resultMigMap.get('K02').MigratedFlag__c);
        //架電オブジェクトに取引先とのリレーションが作成されていないことを確認（取引先が存在しないため）
        System.assertEquals(Null, resultMigMap.get('K02').AccountId__r.Migration_ID2__c);
    }
    
    @TestSetup
    static void makeTestData(){
        //取引先作成
        List<Account> accList = new List<Account>();
        Account acc = new Account();

        acc = createAccount('K01');
        accList.add(acc);

        insert accList;

        //移行用架電obj
        List<MigrationCalling__c> migList = new List<MigrationCalling__c>();
        MigrationCalling__c mig = new MigrationCalling__c();
        
        mig = createMigrationCalling('K01');
        migList.add(mig);
        
        mig = createMigrationCalling('K02');
        migList.add(mig);

        insert migList;
    }

    public static account createAccount(String strName){
        Account accountObj = new Account (
            LastName = '個人' + strName,
            FirstName = '取引先' + strName,
            LastName__pc = '個人' + strName,
            firstname__pc = '取引先' + strName,
            furiganaLast__pc = 'こじん' + strName,
            furiganaForst__pc = 'とりひきさき' + strName,
            PersonMobilePhone = '080-0000-0000',
            Migration_ID2__c = strName
       );
       return accountObj;
    }
    public static MigrationCalling__c createMigrationCalling(String strName){
        MigrationCalling__c callObj = new MigrationCalling__c (
            MigrationCallingId__c = strName
        );
        return callObj;
    }
}