@isTest
public with sharing class Patch_SS012_AccMigrationMiniTest {

    @isTest static void testMethod_T01(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<MiniInsurance__c> setupMiniList = [Select id,AccountId__c From MiniInsurance__c Where mini_apply_id__c = 'K01'];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(MiniInsurance__c rec : setupMiniList){
            rec.AccountId__c = tempAccountMap.get('K01');
        }
        update setupMiniList;

        Test.startTest();
        Patch_SS012_AccMigrationMini batchable = new Patch_SS012_AccMigrationMini(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MiniInsurance__c> resultMiniList = [Select id
                                                       ,AccountId__c
                                                       ,AccountId__r.Migration_ID2__c
                                                       ,Migration_ID2__c
                                                       ,mini_apply_id__c
                                                 From MiniInsurance__c
                                                 Where mini_apply_id__c = 'K01'];
        Map<String, MiniInsurance__c> resultMiniMap = new Map<String, MiniInsurance__c>();
        for(MiniInsurance__c result : resultMiniList){
            resultMiniMap.put(result.mini_apply_id__c, result);
        }

        //K01の紐づきが変わっていないことを確認
        System.assertEquals('K01', resultMiniMap.get('K01').AccountId__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T02(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<MiniInsurance__c> setupMiniList = [Select id,AccountId__c From MiniInsurance__c Where mini_apply_id__c = 'K02'];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(MiniInsurance__c rec : setupMiniList){
            //取引先の架電IDと生保申込みの架電IDが別となるよう設定
            rec.AccountId__c = tempAccountMap.get('K10');
        }
        update setupMiniList;

        Test.startTest();
        Patch_SS012_AccMigrationMini batchable = new Patch_SS012_AccMigrationMini(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MiniInsurance__c> resultMiniList = [Select id
                                                       ,AccountId__c
                                                       ,AccountId__r.Migration_ID2__c
                                                       ,Migration_ID2__c
                                                       ,mini_apply_id__c
                                                 From MiniInsurance__c
                                                 Where mini_apply_id__c = 'K02'];
        Map<String, MiniInsurance__c> resultMiniMap = new Map<String, MiniInsurance__c>();
        for(MiniInsurance__c result : resultMiniList){
            resultMiniMap.put(result.mini_apply_id__c, result);
        }

        //取引先との紐づきが変更されることを確認
        System.assertEquals('K02', resultMiniMap.get('K02').AccountId__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T03(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<MiniInsurance__c> setupMiniList = [Select id,AccountId__c From MiniInsurance__c Where mini_apply_id__c = 'K03'];
        List<Account> tempAccountList1 = [Select id,Migration_ID2__c From Account];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList1){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(MiniInsurance__c rec : setupMiniList){
            rec.AccountId__c = tempAccountMap.get('K03');
        }
        update setupMiniList;

        List<Account> tempAccountList2 = [Select id,Migration_ID2__c From Account Where Migration_ID2__c = 'K03'];
        for(Account rec : tempAccountList2){
            rec.Migration_ID2__c = 'KXX';
        }
        update tempAccountList2;

        Test.startTest();
        Patch_SS012_AccMigrationMini batchable = new Patch_SS012_AccMigrationMini(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MiniInsurance__c> resultMiniList = [Select id
                                                       ,AccountId__c
                                                       ,AccountId__r.Migration_ID2__c
                                                       ,Migration_ID2__c
                                                       ,mini_apply_id__c
                                                 From MiniInsurance__c
                                                 Where mini_apply_id__c = 'K03'];
        Map<String, MiniInsurance__c> resultMiniMap = new Map<String, MiniInsurance__c>();
        for(MiniInsurance__c result : resultMiniList){
            resultMiniMap.put(result.mini_apply_id__c, result);
        }

        //取引先との紐づきが切れていることを確認
        System.assertEquals(Null, resultMiniMap.get('K03').AccountId__r.Migration_ID2__c);
        System.assertEquals(Null, resultMiniMap.get('K03').AccountId__c);
    }

    @isTest static void testMethod_T04(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<MiniInsurance__c> setupMiniList = [Select id,AccountId__c From MiniInsurance__c Where mini_apply_id__c = 'K04'];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account Where Migration_ID2__c = 'K04'];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(MiniInsurance__c rec : setupMiniList){
            rec.AccountId__c = tempAccountMap.get('K04');
        }
        update setupMiniList;
        
        for(Account rec : tempAccountList){
            //取引先の移行用外部ID2（架電ID）
            rec.Migration_ID2__c = Null;
        }
        update tempAccountList;

        Test.startTest();
        Patch_SS012_AccMigrationMini batchable = new Patch_SS012_AccMigrationMini(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MiniInsurance__c> resultMiniList = [Select id
                                                       ,AccountId__c
                                                       ,AccountId__r.Migration_ID2__c
                                                       ,Migration_ID2__c
                                                       ,mini_apply_id__c
                                                 From MiniInsurance__c
                                                 Where mini_apply_id__c = 'K04'];
        Map<String, MiniInsurance__c> resultMiniMap = new Map<String, MiniInsurance__c>();
        for(MiniInsurance__c result : resultMiniList){
            resultMiniMap.put(result.mini_apply_id__c, result);
        }

        //取引先の移行用外部ID2に値が設定されることを確認
        System.assertEquals('K04', resultMiniMap.get('K04').AccountId__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T05(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<MiniInsurance__c> setupMiniList = [Select id,Migration_ID2__c From MiniInsurance__c Where mini_apply_id__c = 'K05'];
        //値設定（テスト用に値の変換を行う）
        for(MiniInsurance__c rec : setupMiniList){
            //生保申込みの移行用架電IDをクリア
            rec.Migration_ID2__c = Null;
        }
        update setupMiniList;

        Test.startTest();
        Patch_SS012_AccMigrationMini batchable = new Patch_SS012_AccMigrationMini(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<MiniInsurance__c> resultMiniList = [Select id
                                                       ,AccountId__c
                                                       ,AccountId__r.Migration_ID2__c
                                                       ,Migration_ID2__c
                                                       ,mini_apply_id__c
                                                 From MiniInsurance__c
                                                 Where mini_apply_id__c = 'K05'];
        Map<String, MiniInsurance__c> resultMiniMap = new Map<String, MiniInsurance__c>();
        for(MiniInsurance__c result : resultMiniList){
            resultMiniMap.put(result.mini_apply_id__c, result);
        }

        //取引先との紐づきが変わっていないことを確認
        System.assertEquals(Null, resultMiniMap.get('K05').AccountId__r.Migration_ID2__c);
    }
    
    @TestSetup
    static void makeTestData(){
        //取引先作成
        List<Account> accList = new List<Account>();
        Account acc = new Account();

        acc = createAccount('K01');
        accList.add(acc);

        acc = createAccount('K02');
        accList.add(acc);
        
        acc = createAccount('K03');
        accList.add(acc);

        acc = createAccount('K04');
        accList.add(acc);

        acc = createAccount('K05');
        accList.add(acc);

        acc = createAccount('K06');
        accList.add(acc);

        acc = createAccount('K07');
        accList.add(acc);

        acc = createAccount('K08');
        accList.add(acc);

        acc = createAccount('K09');
        accList.add(acc);

        acc = createAccount('K10');
        accList.add(acc);

        insert accList;

        //生保申込作成
        List<MiniInsurance__c> miniList = new List<MiniInsurance__c>();
        Map<String, Id> accMap = new Map<String, Id>();
        MiniInsurance__c mini = new MiniInsurance__c();
        List<Account> tmpAccList = [Select id, Migration_ID2__c From Account];
        for(Account rec : tmpAccList){
            accMap.put(rec.Migration_ID2__c, rec.Id);
        }
        
        mini = createMiniInsurance('K01');
        miniList.add(mini);

        mini = createMiniInsurance('K02');
        miniList.add(mini);

        mini = createMiniInsurance('K03');
        miniList.add(mini);

        mini = createMiniInsurance('K04');
        miniList.add(mini);

        mini = createMiniInsurance('K05');
        miniList.add(mini);

        mini = createMiniInsurance('K06');
        miniList.add(mini);

        mini = createMiniInsurance('K07');
        miniList.add(mini);

        mini = createMiniInsurance('K08');
        miniList.add(mini);

        mini = createMiniInsurance('K09');
        miniList.add(mini);

        mini = createMiniInsurance('K10');
        miniList.add(mini);

        insert miniList;
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
    public static MiniInsurance__c createMiniInsurance(String strName){
        MiniInsurance__c miniObj = new MiniInsurance__c (
            Migration_ID2__c = strName,
            isTargetAccMigration__c = True,
            mini_apply_id__c = strName
        );
        return miniObj;
    }
}