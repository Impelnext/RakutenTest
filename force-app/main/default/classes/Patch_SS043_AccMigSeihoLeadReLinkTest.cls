@isTest
public with sharing class Patch_SS043_AccMigSeihoLeadReLinkTest {
    
    @isTest static void testMethod_T01(){
        //テスト実施準備
        List<SeihoLead__c> setupLeadList = [Select id,Ref_Account__c
                                                From SeihoLead__c
                                                Where CatalogOrderId__c = 111];
        List<Account> tempAccountList = [Select id,Migration_ID2__c
                                         From Account
                                         Where Migration_ID2__c = '111'];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(SeihoLead__c rec : setupLeadList){
            rec.Ref_Account__c = tempAccountMap.get('111');
        }
        update setupLeadList;

        Test.startTest();
        Patch_SS043_AccMigrationSeihoLeadReLink batchable = new Patch_SS043_AccMigrationSeihoLeadReLink();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultLeadList = [Select id
                                                   ,Ref_Account__c
                                                   ,Ref_Account__r.Migration_ID2__c
                                                   ,Migration_ID2__c
                                                   ,CatalogOrderId__c
                                             From SeihoLead__c
                                             Where CatalogOrderId__c = 111];
        Map<Integer, SeihoLead__c> resultLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultLeadList){
            resultLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //K01の紐づきが変わっていないことを確認
        System.assertEquals(tempAccountMap.get('111'), resultLeadMap.get(111).Ref_Account__c);
    }

    @isTest static void testMethod_T02(){
        //テスト実施準備
        SeihoLead__c tmpLead = [Select id,Ref_Account__c,Migration_ID2__c
                                From SeihoLead__c
                                Where CatalogOrderId__c = 222
                                Limit 1];
        tmpLead.Ref_Account__c = Null;
        tmpLead.Migration_ID2__c = '222';
        
        update tmpLead;

        Test.startTest();
        Patch_SS043_AccMigrationSeihoLeadReLink batchable = new Patch_SS043_AccMigrationSeihoLeadReLink();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultLeadList = [Select id
                                                   ,Ref_Account__c
                                                   ,Ref_Account__r.Migration_ID2__c
                                                   ,Migration_ID2__c
                                                   ,CatalogOrderId__c
                                             From SeihoLead__c
                                             Where CatalogOrderId__c = 222];
        Map<Integer, SeihoLead__c> resultLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultLeadList){
            resultLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //K02の取引先に紐づいていることを確認
        System.assertEquals('222', resultLeadMap.get(222).Ref_Account__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T03(){
        //テスト実施準備
        SeihoLead__c tmpLead = [Select id,Ref_Account__c,Migration_ID2__c
                                From SeihoLead__c
                                Where CatalogOrderId__c = 333
                                Limit 1];
        tmpLead.Ref_Account__c = Null;
        tmpLead.Migration_ID2__c = '333';
        
        update tmpLead;

        Test.startTest();
        Patch_SS043_AccMigrationSeihoLeadReLink batchable = new Patch_SS043_AccMigrationSeihoLeadReLink();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoLead__c> resultLeadList = [Select id
                                                   ,Ref_Account__c
                                                   ,Ref_Account__r.Migration_ID2__c
                                                   ,Migration_ID2__c
                                                   ,CatalogOrderId__c
                                             From SeihoLead__c
                                             Where CatalogOrderId__c = 333];
        Map<Integer, SeihoLead__c> resultLeadMap = new Map<Integer, SeihoLead__c>();
        for(SeihoLead__c result : resultLeadList){
            resultLeadMap.put(Integer.valueOf(result.CatalogOrderId__c), result);
        }

        //取引先への紐づきが無いままになっていることを確認
        System.assertEquals(Null, resultLeadMap.get(333).Ref_Account__r.Migration_ID2__c);
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

        insert accList;

        //生保申込作成
        List<SeihoLead__c> leadList = new List<SeihoLead__c>();
        Map<String, Id> accMap = new Map<String, Id>();
        SeihoLead__c lead = new SeihoLead__c();
        List<Account> tmpAccList = [Select id, Migration_ID2__c From Account];
        for(Account rec : tmpAccList){
            accMap.put(rec.Migration_ID2__c, rec.Id);
        }
        
        lead = createSeihoLead('111');
        leadList.add(lead);

        lead = createSeihoLead('222');
        leadList.add(lead);

        lead = createSeihoLead('333');
        leadList.add(lead);

        insert leadList;
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
    SeihoLead__c leadObj = new SeihoLead__c (
            Migration_ID2__c = strName,
            CatalogOrderId__c = Integer.valueOf(strName)
        );
        return leadObj;
    }
}