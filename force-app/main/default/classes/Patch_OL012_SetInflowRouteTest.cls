@isTest
private class Patch_OL012_SetInflowRouteTest {
    public Patch_OL012_SetInflowRouteTest() {

    }

    @isTest static void Patch_OL012_UT1() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();

        //UT1_1
        Opportunity opp0 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp0.InflowRoute__c = '0120-069-105';
        oppList.add(opp0);

        //UT1_2
        Opportunity opp1 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp1.InflowRoute__c = '0120-921-210';
        oppList.add(opp1);

        //UT1_3
        Opportunity opp2 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp2.InflowRoute__c = '0120-921-343';
        oppList.add(opp2);

        //UT1_4
        Opportunity opp3 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp3.InflowRoute__c = '0120-977-021';
        oppList.add(opp3);

        //UT1_5
        Opportunity opp4 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp4.InflowRoute__c = '一次保存';
        oppList.add(opp4);

        //UT1_6
        Opportunity opp5 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp5.InflowRoute__c = 'BDDM';
        oppList.add(opp5);

        //UT1_7
        Opportunity opp6 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp6.InflowRoute__c = '既契約セル';
        oppList.add(opp6);

        //UT1_8
        Opportunity opp7 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp7.InflowRoute__c = 'アップセル';
        oppList.add(opp7);

        //UT1_9
        Opportunity opp8 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp8.InflowRoute__c = 'クロスセル';
        oppList.add(opp8);

        // //UT1_10
        // Opportunity opp9 = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.Id,'OppName1');
        // opp9.InflowRoute__c = 'ミニ_サンキューコール';
        // oppList.add(opp9);

        //UT1_11
        Opportunity opp10 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp10.InflowRoute__c = 'ssssssssssss';
        oppList.add(opp10);

        insert oppList; 

        Test.startTest();
        Patch_OL012_SetInflowRouteAndRecordType batchable = new Patch_OL012_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id in :oppList];
        // System.assertEquals('TVCM', OppResultList[0].InflowRoute__c);
        System.assertEquals('TVCM', OppResultList[0].InflowRoute__c);
        System.assertEquals('Web入電', OppResultList[1].InflowRoute__c);
        System.assertEquals('その他IB', OppResultList[2].InflowRoute__c);
        System.assertEquals('その他IB', OppResultList[3].InflowRoute__c);
        System.assertEquals('申込途中保存', OppResultList[4].InflowRoute__c);
        System.assertEquals('外部データソース', OppResultList[5].InflowRoute__c);
        System.assertEquals('既契約クロスセル', OppResultList[6].InflowRoute__c);
        System.assertEquals('既契約アップセル', OppResultList[7].InflowRoute__c);
        System.assertEquals('既契約クロスセル', OppResultList[8].InflowRoute__c);
        // System.assertEquals('ミニ保険', OppResultList[9].InflowRoute__c);
        System.assertEquals('ssssssssssss', OppResultList[9].InflowRoute__c);
    }
 
    @isTest static void Patch_OL010_UT4_1() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        insert acc;
        
        //create Opportunity
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        Test.startTest();
        Patch_OL012_SetInflowRouteAndRecordType batchable = new Patch_OL012_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals(null, OppResultList[0].InflowRoute__c);
    }
    @isTest static void Patch_OL010_UT4_2() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        insert acc;
        
        //create Opportunity
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        //Create GeneralWebApplication__c
        GeneralWebApplication__c sonW = new GeneralWebApplication__c();
        sonW.ForeignKey_GeneralWebApplication__c = 'aaaaaaaaaaa';
        insert sonW;
        sonW.Opportunity__c = opp.id;
        update sonW;
        
        Test.startTest();
        Patch_OL012_SetInflowRouteAndRecordType batchable = new Patch_OL012_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals('申込途中保存', OppResultList[0].InflowRoute__c);
    }

    @isTest static void Patch_OL010_UT4_3() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        insert acc;
        
        //create Opportunity
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        //Create GeneralRequest__c
        GeneralRequest__c gen = new GeneralRequest__c();
        gen.ForeignKey_Renban__c = 'aaaa';
        insert gen;
        gen.Opportunity__c = opp.id;
        update gen;
        
        Test.startTest();
        Patch_OL012_SetInflowRouteAndRecordType batchable = new Patch_OL012_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals('資料請求', OppResultList[0].InflowRoute__c);
    }

    @isTest static void Patch_OL010_UT4_4() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        insert acc;
        
        //create Opportunity
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        //Create GeneralWebApplication__c
        GeneralWebApplication__c sonW = new GeneralWebApplication__c();
        sonW.ForeignKey_GeneralWebApplication__c = 'aaaaaaaaaaa';
        insert sonW;
        sonW.Opportunity__c = opp.id;
        update sonW;
        
        //Create GeneralRequest__c
        GeneralRequest__c gen = new GeneralRequest__c();
        gen.ForeignKey_Renban__c = 'aaaa';
        insert gen;
        gen.Opportunity__c = opp.id;
        update gen;
        
        Test.startTest();
        Patch_OL012_SetInflowRouteAndRecordType batchable = new Patch_OL012_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals('申込途中保存', OppResultList[0].InflowRoute__c);
    }

}