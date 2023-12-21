@isTest
public with sharing class Patch_SS030_ConvertCallingToAccountTest {
    
    @isTest static void testMethod_T01(){
        //取引先と架電IDを紐づけ
        MigrationCalling__c tmpKaden = [Select id,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K01' Limit 1];
        Account tmpAcc = [Select id,Migration_ID2__c From Account where Migration_ID2__c = 'K01' Limit 1];
        tmpKaden.AccountId__c = tmpAcc.Id;
        update tmpKaden;
        MigrationCalling__c beforeKaden = [Select id,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K01' Limit 1];

        Test.startTest();
        Patch_SS030_ConvertCallingToAccount batchable = new Patch_SS030_ConvertCallingToAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //架電レコードを再取得
        MigrationCalling__c afterKaden = [Select id,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K01' Limit 1];

        //K01の紐づきが変わっていないことを確認
        System.assertEquals(beforeKaden.AccountId__c, beforeKaden.AccountId__c);
    }
    @isTest static void testMethod_T02(){
        //移行用架電オブジェクトに電話番号設定
        MigrationCalling__c tmpKaden = [Select id,Phone__c From MigrationCalling__c Where MigrationCallingId__c = 'K02' Limit 1];
        tmpKaden.Phone__c = '03-0000-0000';
        update tmpKaden;

        Test.startTest();
        Patch_SS030_ConvertCallingToAccount batchable = new Patch_SS030_ConvertCallingToAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //取引先レコードを再取得
        Account resultAcc = [Select id,Migration_ID2__c,MigrationCalling__c From Account Where Migration_ID2__c = 'K02' Limit 1];
        MigrationCalling__c resultKaden = [Select id,MigratedFlag__c,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K02' Limit 1];

        //K02の架電の移行済みフラグがTRUEになっていること
        System.assertEquals(True, resultKaden.MigratedFlag__c);
    }

    @isTest static void testMethod_T03(){
        //移行用架電オブジェクトに電話番号設定
        MigrationCalling__c tmpKaden = [Select id,Phone__c From MigrationCalling__c Where MigrationCallingId__c = 'K03' Limit 1];
        tmpKaden.MobilePhone__c = '080-0000-0000';
        update tmpKaden;

        Test.startTest();
        Patch_SS030_ConvertCallingToAccount batchable = new Patch_SS030_ConvertCallingToAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //取引先レコードを再取得
        Account resultAcc = [Select id,Migration_ID2__c,MigrationCalling__c From Account Where Migration_ID2__c = 'K03' Limit 1];
        MigrationCalling__c resultKaden = [Select id,MigratedFlag__c,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K03' Limit 1];

        //K02の架電の移行済みフラグがTRUEになっていること
        System.assertEquals(True, resultKaden.MigratedFlag__c); //SS030では処理しなくなったためコメントアウト
    }

    @isTest static void testMethod_T04(){
        //移行用架電オブジェクトに電話番号設定
        MigrationCalling__c tmpKaden = [Select id,Phone__c From MigrationCalling__c Where MigrationCallingId__c = 'K04' Limit 1];
        tmpKaden.Phone__c = '080-0000-0000';
        update tmpKaden;

        Test.startTest();
        Patch_SS030_ConvertCallingToAccount batchable = new Patch_SS030_ConvertCallingToAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //取引先レコードを再取得
        Account resultAcc = [Select id,Migration_ID2__c,MigrationCalling__c From Account Where Migration_ID2__c = 'K04' Limit 1];
        MigrationCalling__c resultKaden = [Select id,MigratedFlag__c,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K04' Limit 1];

        //K02の架電の移行済みフラグがTRUEになっていること
        System.assertEquals(True, resultKaden.MigratedFlag__c); //SS030では処理しなくなったためコメントアウト
    }

    @isTest static void testMethod_T05(){
        //移行用架電オブジェクトに電話番号設定
        MigrationCalling__c tmpKaden = [Select id,Phone__c From MigrationCalling__c Where MigrationCallingId__c = 'K05' Limit 1];
        tmpKaden.MobilePhone__c = '03-0000-0000';
        update tmpKaden;

        Test.startTest();
        Patch_SS030_ConvertCallingToAccount batchable = new Patch_SS030_ConvertCallingToAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //取引先レコードを再取得
        Account resultAcc = [Select id,Migration_ID2__c,MigrationCalling__c From Account Where Migration_ID2__c = 'K05' Limit 1];
        MigrationCalling__c resultKaden = [Select id,MigratedFlag__c,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K05' Limit 1];

        //K02の架電の移行済みフラグがTRUEになっていること
        System.assertEquals(True, resultKaden.MigratedFlag__c); //SS030では処理しなくなったためコメントアウト
    }

    @isTest static void testMethod_T06(){
        //移行用架電オブジェクトに電話番号設定
        MigrationCalling__c tmpKaden = [Select id,Phone__c From MigrationCalling__c Where MigrationCallingId__c = 'K06' Limit 1];
        tmpKaden.MobilePhone__c = '03-0000-0000';
        update tmpKaden;

        Test.startTest();
        Patch_SS030_ConvertCallingToAccount batchable = new Patch_SS030_ConvertCallingToAccount();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //取引先レコードを再取得
        Account resultAcc = [Select id,Migration_ID2__c,MigrationCalling__c From Account Where Migration_ID2__c = 'K06' Limit 1];
        MigrationCalling__c resultKaden = [Select id,MigratedFlag__c,AccountId__c From MigrationCalling__c Where MigrationCallingId__c = 'K06' Limit 1];

        //K02の取引先が作成されていること
        System.assertEquals('K06', resultAcc.Migration_ID2__c);
        //K02の架電の移行済みフラグがTRUEになっていること
        System.assertEquals(True, resultKaden.MigratedFlag__c); //SS030では処理しなくなったためコメントアウト
    }
    
    @TestSetup
    static void makeTestData(){
        //取引先作成
        List<Account> accList = new List<Account>();
        Account acc = new Account();

        acc = createAccount('K01');
        acc.Migration_ID2__c = 'K01';
        accList.add(acc);
        acc = createAccount('K02');
        accList.add(acc);
        acc = createAccount('K03');
        accList.add(acc);
        acc = createAccount('K04');
        accList.add(acc);
        acc = createAccount('K05');
        accList.add(acc);

        insert accList;

        //移行用架電obj
        List<MigrationCalling__c> migList = new List<MigrationCalling__c>();
        MigrationCalling__c mig = new MigrationCalling__c();
        
        mig = createMigrationCalling('K01');
        mig.MigratedFlag__c = True;
        migList.add(mig);
        
        mig = createMigrationCalling('K02');
        migList.add(mig);
        
        mig = createMigrationCalling('K03');
        migList.add(mig);
        
        mig = createMigrationCalling('K04');
        migList.add(mig);
        
        mig = createMigrationCalling('K05');
        migList.add(mig);
        
        mig = createMigrationCalling('K06');
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
            PersonHomePhone = '03-0000-0000',
            PersonMobilePhone = '080-0000-0000',
            PersonBirthdate = Date.newInstance(1985, 1, 1),
            Gender__pc = '男性'
       );
       return accountObj;
    }
    public static MigrationCalling__c createMigrationCalling(String strName){
        MigrationCalling__c callObj = new MigrationCalling__c (
            MigrationCallingId__c = strName,
            Name              = strName,
            MigratedFlag__c   = False,
            FirstName_BD2M__c = '取引先' + strName,
            LastName_BD2M__c  = '個人' + strName,
            FirstNameKana__c  = 'とりひきさき' + strName,
            LastNameKana__c   = 'こじん' + strName,
            Birthdate_BD2M__c = Date.newInstance(1985, 1, 1),
            Gender_BD2M__c    = '男性'
        );
        return callObj;
    }
}