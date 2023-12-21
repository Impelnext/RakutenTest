@isTest
public with sharing class Patch_SS013_AccMigrationSeihoLeadTest {
    
    @isTest static void testMethod_T01(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<SeihoLead__c> setSeihoLeadList = [Select id,Ref_Account__c From SeihoLead__c Where CatalogOrderId__c = 111];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(SeihoLead__c rec : setSeihoLeadList){
            rec.Ref_Account__c = tempAccountMap.get('111');
        }
        update setSeihoLeadList;

        Test.startTest();
        Patch_SS013_AccMigrationSeihoLead batchable = new Patch_SS013_AccMigrationSeihoLead(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultSeihoLeadList = [Select id
                                                        ,Ref_Account__c
                                                        ,Ref_Account__r.Migration_ID2__c
                                                        ,Migration_ID2__c
                                                        ,CatalogOrderId__c
                                                  From SeihoLead__c
                                                  Where CatalogOrderId__c = 111];
        Map<Integer, SeihoLead__c> resultSeihoLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultSeihoLeadList){
            resultSeihoLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //111の紐づきが変わっていないことを確認
        System.assertEquals(String.valueOf(111), resultSeihoLeadMap.get(111).Ref_Account__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T02(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<SeihoLead__c> setSeihoLeadList = [Select id,Ref_Account__c From SeihoLead__c Where CatalogOrderId__c = 222];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(SeihoLead__c rec : setSeihoLeadList){
            //取引先の架電IDと生保申込みの架電IDが別となるよう設定
            rec.Ref_Account__c = tempAccountMap.get('000');
        }
        update setSeihoLeadList;

        Test.startTest();
        Patch_SS013_AccMigrationSeihoLead batchable = new Patch_SS013_AccMigrationSeihoLead(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultSeihoLeadList = [Select id
                                                              ,Ref_Account__c
                                                              ,Ref_Account__r.Migration_ID2__c
                                                              ,Migration_ID2__c
                                                              ,CatalogOrderId__c
                                                        From SeihoLead__c
                                                        Where CatalogOrderId__c = 222];
        Map<Integer, SeihoLead__c> resultSeihoLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultSeihoLeadList){
            resultSeihoLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //取引先との紐づきが変更されることを確認
        System.assertEquals(String.valueOF(222), resultSeihoLeadMap.get(222).Ref_Account__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T03(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<SeihoLead__c> setSeihoLeadList = [Select id,Ref_Account__c From SeihoLead__c Where CatalogOrderId__c = 333];
        List<Account> tempAccountList1 = [Select id,Migration_ID2__c From Account];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList1){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(SeihoLead__c rec : setSeihoLeadList){
            rec.Ref_Account__c = tempAccountMap.get('333');
        }
        update setSeihoLeadList;

        List<Account> tempAccountList2 = [Select id,Migration_ID2__c From Account Where Migration_ID2__c = '333'];
        for(Account rec : tempAccountList2){
            rec.Migration_ID2__c = '123';
        }
        update tempAccountList2;

        Test.startTest();
        Patch_SS013_AccMigrationSeihoLead batchable = new Patch_SS013_AccMigrationSeihoLead(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultSeihoLeadList = [Select id
                                                              ,Ref_Account__c
                                                              ,Ref_Account__r.Migration_ID2__c
                                                              ,Migration_ID2__c
                                                              ,CatalogOrderId__c
                                                        From SeihoLead__c
                                                        Where CatalogOrderId__c = 333];
        Map<Integer, SeihoLead__c> resultSeihoLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultSeihoLeadList){
            resultSeihoLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //取引先との紐づきが切れていることを確認
        System.assertEquals(Null, resultSeihoLeadMap.get(333).Ref_Account__r.Migration_ID2__c);
        System.assertEquals(Null, resultSeihoLeadMap.get(333).Ref_Account__c);
    }

    @isTest static void testMethod_T04(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<SeihoLead__c> setSeihoLeadList = [Select id,Ref_Account__c From SeihoLead__c Where CatalogOrderId__c = 444];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account Where Migration_ID2__c = '444'];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(SeihoLead__c rec : setSeihoLeadList){
            rec.Ref_Account__c = tempAccountMap.get('444');
        }
        update setSeihoLeadList;
        
        for(Account rec : tempAccountList){
            //取引先の移行用外部ID2（架電ID）
            rec.Migration_ID2__c = Null;
        }
        update tempAccountList;

        Test.startTest();
        Patch_SS013_AccMigrationSeihoLead batchable = new Patch_SS013_AccMigrationSeihoLead(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultSeihoLeadList = [Select id
                                                        ,Ref_Account__c
                                                        ,Ref_Account__r.Migration_ID2__c
                                                        ,Migration_ID2__c
                                                        ,CatalogOrderId__c
                                                  From SeihoLead__c
                                                  Where CatalogOrderId__c = 444];
        Map<Integer, SeihoLead__c> resultSeihoLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultSeihoLeadList){
            resultSeihoLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //取引先の移行用外部ID2に値が設定されることを確認
        System.assertEquals(String.valueOf(444), resultSeihoLeadMap.get(444).Ref_Account__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T05(){
        //テスト実施準備
        Datetime testDate = System.Now().addDays(-10);
        List<SeihoLead__c> setSeihoLeadList = [Select id,Migration_ID2__c From SeihoLead__c Where CatalogOrderId__c = 555];
        //値設定（テスト用に値の変換を行う）
        for(SeihoLead__c rec : setSeihoLeadList){
            //生保申込みの移行用架電IDをクリア
            rec.Migration_ID2__c = Null;
        }
        update setSeihoLeadList;

        Test.startTest();
        Patch_SS013_AccMigrationSeihoLead batchable = new Patch_SS013_AccMigrationSeihoLead(testDate);
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultSeihoLeadList = [Select id
                                                        ,Ref_Account__c
                                                        ,Ref_Account__r.Migration_ID2__c
                                                        ,Migration_ID2__c
                                                        ,CatalogOrderId__c
                                                  From SeihoLead__c
                                                  Where CatalogOrderId__c = 555];
        Map<Integer, SeihoLead__c> resultSeihoLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultSeihoLeadList){
            resultSeihoLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //取引先との紐づきが変わっていないことを確認
        System.assertEquals(Null, resultSeihoLeadMap.get(555).Ref_Account__r.Migration_ID2__c);
    }
    
    @TestSetup
    static void makeTestData(){
        //取引先作成
        List<Account> accList = new List<Account>();
        Account acc = new Account();

        acc = createAccount('111');
        accList.add(acc);

        acc = createAccount('222');
        accList.add(acc);
        
        acc = createAccount('333');
        accList.add(acc);

        acc = createAccount('444');
        accList.add(acc);

        acc = createAccount('555');
        accList.add(acc);

        acc = createAccount('666');
        accList.add(acc);

        acc = createAccount('777');
        accList.add(acc);

        acc = createAccount('888');
        accList.add(acc);

        acc = createAccount('999');
        accList.add(acc);

        acc = createAccount('000');
        accList.add(acc);

        insert accList;

        //生保申込作成
        List<SeihoLead__c> seihoLeadList = new List<SeihoLead__c>();
        Map<String, Id> accMap = new Map<String, Id>();
        SeihoLead__c seihoOpp = new SeihoLead__c();
        List<Account> tmpAccList = [Select id, Migration_ID2__c From Account];
        for(Account rec : tmpAccList){
            accMap.put(rec.Migration_ID2__c, rec.Id);
        }
        
        seihoOpp = createSeihoLead('111');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('222');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('333');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('444');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('555');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('666');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('777');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('888');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('999');
        seihoLeadList.add(seihoOpp);

        seihoOpp = createSeihoLead('000');
        seihoLeadList.add(seihoOpp);

        insert seihoLeadList;
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
   public static SeihoLead__c createSeihoLead(String strName){
        SeihoLead__c seihoOppObj = new SeihoLead__c (
            Migration_ID2__c = strName,
            isTargetAccMigration__c = True,
            CatalogOrderId__c = Integer.valueOf(strName)
        );
        return seihoOppObj;
    }
}