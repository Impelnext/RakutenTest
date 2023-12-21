@isTest
public with sharing class Patch_SS042_AccMigrationMiniReLinkTest {
    
    @isTest static void testMethod_T01(){
        //テスト実施準備
        List<MiniInsurance__c> setupMiniList = [Select id,AccountId__c
                                                From MiniInsurance__c
                                                Where mini_apply_id__c = 'K01'];
        List<Account> tempAccountList = [Select id,Migration_ID2__c
                                         From Account
                                         Where Migration_ID2__c = 'K01'];
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
        Patch_SS042_AccMigrationMiniReLink batchable = new Patch_SS042_AccMigrationMiniReLink();
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
        System.assertEquals(tempAccountMap.get('K01'), resultMiniMap.get('K01').AccountId__c);
    }

    @isTest static void testMethod_T02(){
        //テスト実施準備
        MiniInsurance__c tmpMini = [Select id,AccountId__c,Migration_ID2__c
                                    From MiniInsurance__c
                                    Where mini_apply_id__c = 'K02'
                                    Limit 1];
        tmpMini.AccountId__c = Null;
        tmpMini.Migration_ID2__c = 'K02';
        
        update tmpMini;

        Test.startTest();
        Patch_SS042_AccMigrationMiniReLink batchable = new Patch_SS042_AccMigrationMiniReLink();
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

        //K02の取引先に紐づいていることを確認
        System.assertEquals('K02', resultMiniMap.get('K02').AccountId__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T03(){
        //テスト実施準備
        MiniInsurance__c tmpMini = [Select id,AccountId__c,Migration_ID2__c
                                    From MiniInsurance__c
                                    Where mini_apply_id__c = 'K03'
                                    Limit 1];
        tmpMini.AccountId__c = Null;
        tmpMini.Migration_ID2__c = 'K03';
        update tmpMini;

        Test.startTest();
        Patch_SS042_AccMigrationMiniReLink batchable = new Patch_SS042_AccMigrationMiniReLink();
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

        //取引先への紐づきが無いままになっていることを確認
        System.assertEquals(Null, resultMiniMap.get('K03').AccountId__r.Migration_ID2__c);
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
            mini_apply_id__c = strName
        );
        return miniObj;
    }
}