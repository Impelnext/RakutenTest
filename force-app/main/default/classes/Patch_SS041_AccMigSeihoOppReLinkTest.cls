@isTest
public with sharing class Patch_SS041_AccMigSeihoOppReLinkTest {
    
    @isTest static void testMethod_T01(){
        //テスト実施準備
        List<SeihoOpportunity__c> setSeihoOppList = [Select id,Ref_Account__c
                                                     From SeihoOpportunity__c
                                                     Where ApplyID__c = 'K01'];
        List<Account> tempAccountList = [Select id,Migration_ID2__c From Account Where Migration_ID2__c = 'K01'];
        Map<String, Id> tempAccountMap = new Map<String, Id>();
        for(Account rec : tempAccountList){
            tempAccountMap.put(rec.Migration_ID2__c, rec.Id);
        }
        //値設定（テスト用に値の変換を行う）
        for(SeihoOpportunity__c rec : setSeihoOppList){
            rec.Ref_Account__c = tempAccountMap.get('K01');
        }
        update setSeihoOppList;

        Test.startTest();
        Patch_SS041_AccMigrationSeihoOppReLink batchable = new Patch_SS041_AccMigrationSeihoOppReLink();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoOpportunity__c> resultSeihoOppList = [Select id
                                                              ,Ref_Account__c
                                                              ,Ref_Account__r.Migration_ID2__c
                                                              ,Migration_ID2__c
                                                              ,ApplyID__c
                                                        From SeihoOpportunity__c
                                                        Where ApplyID__c = 'K01'];
        Map<String, SeihoOpportunity__c> resultSeihoOppMap = new Map<String, SeihoOpportunity__c>();
        for(SeihoOpportunity__c result : resultSeihoOppList){
            resultSeihoOppMap.put(result.ApplyID__c, result);
        }

        //K01の紐づきが変わっていないことを確認
        System.assertEquals(tempAccountMap.get('K01'), resultSeihoOppMap.get('K01').Ref_Account__c);
    }

    @isTest static void testMethod_T02(){
        //テスト実施準備
        SeihoOpportunity__c tmpSeihoOpp = [Select id,Ref_Account__c,Migration_ID2__c
                                           From SeihoOpportunity__c
                                           Where ApplyID__c = 'K02'
                                           Limit 1];
        tmpSeihoOpp.Ref_Account__c = Null;
        tmpSeihoOpp.Migration_ID2__c = 'K02';
        update tmpSeihoOpp;

        Test.startTest();
        Patch_SS041_AccMigrationSeihoOppReLink batchable = new Patch_SS041_AccMigrationSeihoOppReLink();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoOpportunity__c> resultSeihoOppList = [Select id
                                                              ,Ref_Account__c
                                                              ,Ref_Account__r.Migration_ID2__c
                                                              ,Migration_ID2__c
                                                              ,ApplyID__c
                                                        From SeihoOpportunity__c
                                                        Where ApplyID__c = 'K02'];
        Map<String, SeihoOpportunity__c> resultSeihoOppMap = new Map<String, SeihoOpportunity__c>();
        for(SeihoOpportunity__c result : resultSeihoOppList){
            resultSeihoOppMap.put(result.ApplyID__c, result);
        }

        //K02の取引先に紐づいていることを確認
        System.assertEquals('K02', resultSeihoOppMap.get('K02').Ref_Account__r.Migration_ID2__c);
    }

    @isTest static void testMethod_T03(){
        //テスト実施準備
        SeihoOpportunity__c tmpSeihoOpp = [Select id,Ref_Account__c,Migration_ID2__c
                                           From SeihoOpportunity__c
                                           Where ApplyID__c = 'K03'
                                           Limit 1];
        tmpSeihoOpp.Ref_Account__c = Null;
        tmpSeihoOpp.Migration_ID2__c = 'K03';
        update tmpSeihoOpp;

        Test.startTest();
        Patch_SS041_AccMigrationSeihoOppReLink batchable = new Patch_SS041_AccMigrationSeihoOppReLink();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<SeihoOpportunity__c> resultSeihoOppList = [Select id
                                                              ,Ref_Account__c
                                                              ,Ref_Account__r.Migration_ID2__c
                                                              ,Migration_ID2__c
                                                              ,ApplyID__c
                                                        From SeihoOpportunity__c
                                                        Where ApplyID__c = 'K03'];
        Map<String, SeihoOpportunity__c> resultSeihoOppMap = new Map<String, SeihoOpportunity__c>();
        for(SeihoOpportunity__c result : resultSeihoOppList){
            resultSeihoOppMap.put(result.ApplyID__c, result);
        }

        //取引先への紐づきが無いままになっていることを確認
        System.assertEquals(Null, resultSeihoOppMap.get('K03').Ref_Account__r.Migration_ID2__c);
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
        List<SeihoOpportunity__c> seihoOppList = new List<SeihoOpportunity__c>();
        Map<String, Id> accMap = new Map<String, Id>();
        SeihoOpportunity__c seihoOpp = new SeihoOpportunity__c();
        List<Account> tmpAccList = [Select id, Migration_ID2__c From Account];
        for(Account rec : tmpAccList){
            accMap.put(rec.Migration_ID2__c, rec.Id);
        }
        
        seihoOpp = createSeihoOpportunity('K01');
        seihoOppList.add(seihoOpp);

        seihoOpp = createSeihoOpportunity('K02');
        seihoOppList.add(seihoOpp);

        seihoOpp = createSeihoOpportunity('K03');
        seihoOppList.add(seihoOpp);

        insert seihoOppList;
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
   public static SeihoOpportunity__c createSeihoOpportunity(String strName){
        SeihoOpportunity__c seihoOppObj = new SeihoOpportunity__c (
            Migration_ID2__c = strName,
            ApplyID__c = strName
        );
        return seihoOppObj;
    }
}