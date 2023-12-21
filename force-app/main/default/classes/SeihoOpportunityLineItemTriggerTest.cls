@isTest
public class SeihoOpportunityLineItemTriggerTest
{
    @isTest
    static void SeihoOpportunityLineItemTriggerTest_insert() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        Test.startTest();
        insert triggerTest.createSeihoOpportunity();
        insert triggerTest.createSeihoOpportunityLineItem();
        Test.stopTest();
    }
    
    @isTest
    static void insert_OpportunityId_no_match() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        insert triggerTest.createSeihoOpportunity();
        Test.startTest();
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.OpportunityId__c = '100001';
        insert item;
        Test.stopTest();
        List<SeihoOpportunityLineItem__c> result = new List<SeihoOpportunityLineItem__c>();
        for(SeihoOpportunityLineItem__c tmp : [SELECT Id, OpportunityIdReference__c 
                                              FROM   SeihoOpportunityLineItem__c
                                              WHERE  Id = :item.Id] ) {
            result.add(tmp);
        }
        System.assertEquals(0, result.size());
    }
    
    @isTest
    static void insert_OpportunityId_null() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        insert triggerTest.createSeihoOpportunity();
        Test.startTest();
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.OpportunityId__c = null;
        insert item;
        Test.stopTest();
        List<SeihoOpportunityLineItem__c> result = new List<SeihoOpportunityLineItem__c>();
        for(SeihoOpportunityLineItem__c tmp : [SELECT Id, OpportunityIdReference__c 
                                              FROM   SeihoOpportunityLineItem__c
                                              WHERE  Id = :item.Id] ) {
            result.add(tmp);
        }
        System.assertEquals(0, result.size());
    }

    @isTest
    static void SeihoOpportunityLineItemTriggerTest_update() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();

        SeihoOpportunity__c opp = triggerTest.createSeihoOpportunity();
        insert opp;
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        insert item;
        item.Name = '333333';

        Test.startTest();
        update item;
        Test.stopTest();

        SeihoOpportunityLineItem__c so = [SELECT Id, Name, OpportunityIdReference__c FROM SeihoOpportunityLineItem__c WHERE Id = :item.Id LIMIT 1];
        System.assertEquals(opp.Id, so.OpportunityIdReference__c);
    }

    @isTest
    static void insert_dummy_exist() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        insert triggerTest.createSeihoOpportunity();
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.OpportunityId__c = '100001';
        insert item;
        Test.startTest();
        SeihoOpportunityLineItem__c item2 = triggerTest.createSeihoOpportunityLineItem();
        item2.OpportunityId__c = '100002';
        insert item2;
        Test.stopTest();
        List<SeihoOpportunityLineItem__c> result = new List<SeihoOpportunityLineItem__c>();
        for(SeihoOpportunityLineItem__c tmp : [SELECT Id, OpportunityIdReference__c 
                                              FROM   SeihoOpportunityLineItem__c
                                              WHERE  Id IN (:item.Id, :item2.Id)] ) {
            result.add(tmp);
        }
        System.assertEquals(0, result.size());
    }

    @isTest
    static void insert_OpportunityIdReference_exist() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        SeihoOpportunity__c seihoOpp = triggerTest.createSeihoOpportunity();
        insert seihoOpp;
        Test.startTest();
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.OpportunityId__c = '100001';
        item.OpportunityIdReference__c = seihoOpp.Id;
        insert item;
        Test.stopTest();
        List<SeihoOpportunityLineItem__c> result = new List<SeihoOpportunityLineItem__c>();
        for(SeihoOpportunityLineItem__c tmp : [SELECT Id, OpportunityIdReference__c 
                                              FROM   SeihoOpportunityLineItem__c
                                              WHERE  OpportunityIdReference__c =: seihoOpp.Id] ) {
            result.add(tmp);
        }
        System.assertEquals(1, result.size());
        System.assertEquals(item.Id, result.get(0).Id);
    }

    @isTest
    static void miniSyncSubsc_true() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createSeihoOpportunity();
        insert opp;
        
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.MiniSyncSubsc__c = '有';

        Test.startTest();
        insert item;
        Test.stopTest();

        SeihoOpportunity__c seihoOppResult = [SELECT Id, AppliNo__c, MiniSyncSubsc__c, Opportunity__c FROM SeihoOpportunity__c WHERE AppliNo__c = :item.OpportunityId__c LIMIT 1];
        Opportunity oppResult = [SELECT Id,  MiniSyncSubsc__c FROM Opportunity WHERE Id = :seihoOppResult.Opportunity__c LIMIT 1];
        System.assertEquals('有', seihoOppResult.MiniSyncSubsc__c);
        System.assertEquals('有', oppResult.MiniSyncSubsc__c);

    }

    @isTest
    static void miniSyncSubsc_false() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createSeihoOpportunity();
        insert opp;
        
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.MiniSyncSubsc__c = '‐';

        Test.startTest();
        insert item;
        Test.stopTest();

        SeihoOpportunity__c seihoOppResult = [SELECT Id, AppliNo__c, MiniSyncSubsc__c, Opportunity__c FROM SeihoOpportunity__c WHERE AppliNo__c = :item.OpportunityId__c LIMIT 1];
        Opportunity oppResult = [SELECT Id,  MiniSyncSubsc__c FROM Opportunity WHERE Id = :seihoOppResult.Opportunity__c LIMIT 1];
        System.assertEquals('‐', seihoOppResult.MiniSyncSubsc__c);
        System.assertEquals('‐', oppResult.MiniSyncSubsc__c);
    }

    @isTest
    static void miniSyncSubsc_null() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createSeihoOpportunity();
        insert opp;
        
        SeihoOpportunityLineItem__c item = triggerTest.createSeihoOpportunityLineItem();
        item.MiniSyncSubsc__c = null;

        Test.startTest();
        insert item;
        Test.stopTest();

        SeihoOpportunity__c seihoOppResult = [SELECT Id, AppliNo__c, MiniSyncSubsc__c, Opportunity__c FROM SeihoOpportunity__c WHERE AppliNo__c = :item.OpportunityId__c LIMIT 1];
        Opportunity oppResult = [SELECT Id,  MiniSyncSubsc__c FROM Opportunity WHERE Id = :seihoOppResult.Opportunity__c LIMIT 1];
        System.assertEquals(null, seihoOppResult.MiniSyncSubsc__c);
        System.assertEquals(null, oppResult.MiniSyncSubsc__c);
    }

    @isTest
    static void miniSyncSubsc_multiple_exist() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createSeihoOpportunity();
        insert opp;
        SeihoOpportunityLineItem__c item1 = triggerTest.createSeihoOpportunityLineItem();
        item1.MiniSyncSubsc__c = '有';
        insert item1;
        SeihoOpportunityLineItem__c item2 = triggerTest.createSeihoOpportunityLineItem();
        item2.MiniSyncSubsc__c = '‐';
        item2.ForeignKey_SeihoOpportunityLineItem__c = '3333333';

        Test.startTest();
        insert item2;
        Test.stopTest();

        SeihoOpportunity__c seihoOppResult = [SELECT Id, AppliNo__c, MiniSyncSubsc__c, Opportunity__c FROM SeihoOpportunity__c WHERE AppliNo__c = '44444' LIMIT 1];
        Opportunity oppResult = [SELECT Id,  MiniSyncSubsc__c FROM Opportunity WHERE Id = :seihoOppResult.Opportunity__c LIMIT 1];
        System.assertEquals('有', seihoOppResult.MiniSyncSubsc__c);
        System.assertEquals('有', oppResult.MiniSyncSubsc__c);
    }

    @isTest
    static void miniSyncSubsc_multiple_same() {
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        SeihoOpportunity__c opp = triggerTest.createSeihoOpportunity();
        insert opp;

        SeihoOpportunityLineItem__c item1 = triggerTest.createSeihoOpportunityLineItem();
        item1.MiniSyncSubsc__c = '有';
        SeihoOpportunityLineItem__c item2 = triggerTest.createSeihoOpportunityLineItem();
        item2.MiniSyncSubsc__c = '‐';
        item2.ForeignKey_SeihoOpportunityLineItem__c = '3333333';
        SeihoOpportunityLineItem__c item3 = triggerTest.createSeihoOpportunityLineItem();
        item2.MiniSyncSubsc__c = null;
        item2.ForeignKey_SeihoOpportunityLineItem__c = '5555555';

        List<SeihoOpportunityLineItem__c> itemList = new List<SeihoOpportunityLineItem__c>{item1, item2}; 

        Test.startTest();
        insert itemList;
        Test.stopTest();

        SeihoOpportunity__c seihoOppResult = [SELECT Id, AppliNo__c, MiniSyncSubsc__c, Opportunity__c FROM SeihoOpportunity__c WHERE AppliNo__c = '44444' LIMIT 1];
        Opportunity oppResult = [SELECT Id,  MiniSyncSubsc__c FROM Opportunity WHERE Id = :seihoOppResult.Opportunity__c LIMIT 1];
        System.assertEquals('有', seihoOppResult.MiniSyncSubsc__c);
        System.assertEquals('有', oppResult.MiniSyncSubsc__c);
    }
    
    
    @isTest
    static void test_SiehoOppItem_Insert_WebApplicationInsuFee() {
        Id seihoOppWebRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityWeb').getRecordTypeId();
        Id seihoOppPaperRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityPaper').getRecordTypeId();
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createWebSeihoOpportunity('楽天WEB', '11111');
        opp.RecordTypeId = seihoOppWebRecordId;
        insert opp;
        
        SeihoOpportunity__c opp2 = triggerTest.createPaperSeihoOpportunity('楽天紙');
        opp2.RecordTypeId = seihoOppPaperRecordId;
        insert opp2;
        
        SeihoOpportunityLineItem__c item1 = triggerTest.createWebSeihoOpportunityLineItem('211111');
        item1.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item2 = triggerTest.createWebSeihoOpportunityLineItem('211112');
        item2.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item3 = triggerTest.createWebSeihoOpportunityLineItem('211113');
        item3.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item4 = triggerTest.createWebSeihoOpportunityLineItem('211114');
        item4.OpportunityIdReference__c = opp.Id;
        
        SeihoOpportunityLineItem__c item5 = triggerTest.createPaperSeihoOpportunityLineItem('211115');
        item5.OpportunityIdReference__c = opp2.Id;
        
        Test.startTest();
        
        // Insert First OppLineItem
        item1.UnitPrice__c = 152389;
        insert item1;
        
        SeihoOpportunity__c seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, RecordType.Name, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('152389', seihoOppResult.WebApplicationInsuFee__c);
        
        // Insert Second OppLineItem
        item2.UnitPrice__c = 0;
        insert item2;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('152389', seihoOppResult.WebApplicationInsuFee__c);
        
        // Insert Third OppLineItem
        item3.UnitPrice__c = 89724;
        insert item3;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('242113', seihoOppResult.WebApplicationInsuFee__c);
        
        // Insert Fourth OppLineItem
        item4.UnitPrice__c = 987654;
        insert item4;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('1229767', seihoOppResult.WebApplicationInsuFee__c);
        
        // Test Paper SeihoOpportunity
        // Insert Fifth OppLineItem
        item5.UnitPrice__c = 124578;
        insert item5;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp2.Id LIMIT 1];
        System.assertEquals(NULL, seihoOppResult.WebApplicationInsuFee__c);
        
        Test.stopTest();
        
    }
    
    
    @isTest
    static void test_SiehoOppItem_Update_WebApplicationInsuFee() {
        Id seihoOppWebRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityWeb').getRecordTypeId();
        Id seihoOppPaperRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityPaper').getRecordTypeId();
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createWebSeihoOpportunity('楽天WEB', '11111');
        opp.RecordTypeId = seihoOppWebRecordId;
        insert opp;
        
        SeihoOpportunity__c opp2 = triggerTest.createPaperSeihoOpportunity('楽天紙');
        opp2.RecordTypeId = seihoOppPaperRecordId;
        insert opp2;
        
        SeihoOpportunityLineItem__c item1 = triggerTest.createWebSeihoOpportunityLineItem('211111');
        item1.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item2 = triggerTest.createWebSeihoOpportunityLineItem('211112');
        item2.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item3 = triggerTest.createWebSeihoOpportunityLineItem('211113');
        item3.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item4 = triggerTest.createWebSeihoOpportunityLineItem('211114');
        item4.OpportunityIdReference__c = opp.Id;
        
        SeihoOpportunityLineItem__c item5 = triggerTest.createPaperSeihoOpportunityLineItem('211115');
        item5.OpportunityIdReference__c = opp2.Id;
        
        item1.UnitPrice__c = 152389;
        item2.UnitPrice__c = 0;
        item3.UnitPrice__c = 89724;
        item5.UnitPrice__c = 124578;
        
        List<SeihoOpportunityLineItem__c> itemList = new List<SeihoOpportunityLineItem__c>();
        itemList.add(item1);
        itemList.add(item2);
        itemList.add(item3);
        itemList.add(item5);
        
        // Insert OppLineItemList
        insert itemList;
        
        SeihoOpportunity__c seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, RecordType.Name, Opportunity__c 
                                                FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('242113', seihoOppResult.WebApplicationInsuFee__c);
        
        Test.startTest();
        
        // Update Second OppLineItem
        item2.UnitPrice__c = 56120;
        update item2;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('298233', seihoOppResult.WebApplicationInsuFee__c);
        
        // Update Second OppLineItem
        item3.UnitPrice__c = 36502;
        update item3;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('245011', seihoOppResult.WebApplicationInsuFee__c);
        
        // Update First OppLineItem
        item1.UnitPrice__c = 0;
        update item1;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('92622', seihoOppResult.WebApplicationInsuFee__c);
        
        // Insert Fourth OppLineItem
        item4.UnitPrice__c = 987654;
        insert item4;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('1080276', seihoOppResult.WebApplicationInsuFee__c);
        
        // Test Paper SeihoOpportunity
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp2.Id LIMIT 1];
        System.assertEquals(NULL, seihoOppResult.WebApplicationInsuFee__c);
        
        // Update Fifth OppLineItem
        item5.UnitPrice__c = 88750;
        update item5;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp2.Id LIMIT 1];
        System.assertEquals(NULL, seihoOppResult.WebApplicationInsuFee__c);
        
        Test.stopTest();
        
    }
    
    
    @isTest
    static void test_SiehoOppItem_Delete_WebApplicationInsuFee() {
        
        Id seihoOppWebRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityWeb').getRecordTypeId();
        Id seihoOppPaperRecordId = Schema.SObjectType.SeihoOpportunity__c.getRecordTypeInfosByDeveloperName().get('SeihoOpportunityPaper').getRecordTypeId();
        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        
        SeihoOpportunity__c opp = triggerTest.createWebSeihoOpportunity('楽天WEB', '11111');
        opp.RecordTypeId = seihoOppWebRecordId;
        insert opp;
        
        SeihoOpportunity__c opp2 = triggerTest.createPaperSeihoOpportunity('楽天紙');
        opp2.RecordTypeId = seihoOppPaperRecordId;
        insert opp2;
        
        SeihoOpportunityLineItem__c item1 = triggerTest.createWebSeihoOpportunityLineItem('211111');
        item1.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item2 = triggerTest.createWebSeihoOpportunityLineItem('211112');
        item2.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item3 = triggerTest.createWebSeihoOpportunityLineItem('211113');
        item3.OpportunityIdReference__c = opp.Id;
        SeihoOpportunityLineItem__c item4 = triggerTest.createWebSeihoOpportunityLineItem('211114');
        item4.OpportunityIdReference__c = opp.Id;
        
        SeihoOpportunityLineItem__c item5 = triggerTest.createPaperSeihoOpportunityLineItem('211115');
        item5.OpportunityIdReference__c = opp2.Id;
        
        Test.startTest();
        
        item1.UnitPrice__c = 152389;
        item2.UnitPrice__c = 0;
        item3.UnitPrice__c = 89724;
        item5.UnitPrice__c = 124578;
        
        List<SeihoOpportunityLineItem__c> itemList = new List<SeihoOpportunityLineItem__c>();
        itemList.add(item1);
        itemList.add(item2);
        itemList.add(item3);
        itemList.add(item5);
        
        // Insert OppLineItemList
        insert itemList;
        
        SeihoOpportunity__c seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, RecordType.Name, Opportunity__c 
                                                FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('242113', seihoOppResult.WebApplicationInsuFee__c);
        
        // Delete Third OppLineItem
        delete item3;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('152389', seihoOppResult.WebApplicationInsuFee__c);
        
        // Delete First OppLineItem
        delete item1;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('0', seihoOppResult.WebApplicationInsuFee__c);
        
        // Delete Second OppLineItem
        delete item2;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('0', seihoOppResult.WebApplicationInsuFee__c);
        
        // Insert Fourth OppLineItem
        item4.UnitPrice__c = 987654;
        insert item4;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp.Id LIMIT 1];
        System.assertEquals('987654', seihoOppResult.WebApplicationInsuFee__c);
        
        // Test Paper SeihoOpportunity
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp2.Id LIMIT 1];
        System.assertEquals(NULL, seihoOppResult.WebApplicationInsuFee__c);
        
        // Delete Fifth OppLineItem
        delete item5;
        
        seihoOppResult = [SELECT Id, WebApplicationInsuFee__c, Opportunity__c FROM SeihoOpportunity__c WHERE Id = :opp2.Id LIMIT 1];
        System.assertEquals(NULL, seihoOppResult.WebApplicationInsuFee__c);
        
        Test.stopTest();
        
    }

    @isTest
    static void setNameFromInsuranceType_insert(){

        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        //紙申込の生保申込
        Test.startTest();
        List<SeihoOpportunity__c> seihoOppList = triggerTest.createSeihoOpportunityData();
        insert seihoOppList;
        List<SeihoOpportunityLineItem__c> seihoLineItemList = triggerTest.createSeihoOpportunityLineItemData(seihoOppList);
        insert seihoLineItemList;
        Test.stopTest();
        SeihoOppLineItemTriggerHandler lineItemHandler = new SeihoOppLineItemTriggerHandler();
        Map<String,String> insuranceTypeNameMap = lineItemHandler.getInsuranceTypeName();

        List<SeihoOpportunityLineItem__c> dbLineItemList = [SELECT Id, Name, InsuranceType__c, OpportunityIdReference__c FROM SeihoOpportunityLineItem__c WHERE Id IN: seihoLineItemList];
        Set<String> seihoIdSet = new Set<String>();
        for(SeihoOpportunityLineItem__c line : dbLineItemList){
            seihoIdSet.add(line.OpportunityIdReference__c);
        }
        List<SeihoOpportunity__c> dbSeihoOppList = [SELECT Id, RecordType.Name FROM SeihoOpportunity__c WHERE Id IN: seihoIdSet];
        for(Integer i=0;i<5;i++){
            if(i!=4){
                //紙申込の生保申込の場合、商品名に設定される値の確認(商品名が保険種類に基づいて、変わります)
                System.assertEquals(insuranceTypeNameMap.get(dbLineItemList.get(i).InsuranceType__c), dbLineItemList.get(i).Name);
                System.assertEquals('紙申込', dbSeihoOppList.get(i).RecordType.Name);
            }else{
                //Web申込の生保申込の場合、商品名に設定される値の確認(商品名が保険種類に基づいて、変わりません)
                System.assertEquals('Web申込', dbSeihoOppList.get(i).RecordType.Name);
                System.assertEquals('生保申込商品_005', dbLineItemList.get(i).Name);
            }
        }
    }

    @isTest
    static void setNameFromInsuranceType_update(){

        SeihoOpportunityLineItemTriggerTest triggerTest = new SeihoOpportunityLineItemTriggerTest();
        //紙申込の生保申込
        Test.startTest();
        List<SeihoOpportunity__c> seihoOppList = triggerTest.createSeihoOpportunityData();
        insert seihoOppList;
        List<SeihoOpportunityLineItem__c> seihoLineItemList = triggerTest.createSeihoOpportunityLineItemData(seihoOppList);
        insert seihoLineItemList;
        Test.stopTest();
        SeihoOppLineItemTriggerHandler lineItemHandler = new SeihoOppLineItemTriggerHandler();
        Map<String,String> insuranceTypeNameMap = lineItemHandler.getInsuranceTypeName();

        List<SeihoOpportunityLineItem__c> dbLineItemList = [SELECT Id, Name, InsuranceType__c, OpportunityIdReference__c FROM SeihoOpportunityLineItem__c WHERE Id IN: seihoLineItemList];
        //保険種類が更新される前の商品名（Name）を格納
        Map<Id,String> oldProductNameMap = new Map<Id,String>();
        for(SeihoOpportunityLineItem__c line : dbLineItemList){
            oldProductNameMap.put(line.Id,line.Name);
        }

        dbLineItemList.get(0).InsuranceType__c = '05';
        dbLineItemList.get(1).InsuranceType__c = null;

        update dbLineItemList;
        
        List<SeihoOpportunityLineItem__c> updatedLineItemList = [SELECT Id, Name, InsuranceType__c, OpportunityIdReference__c FROM SeihoOpportunityLineItem__c WHERE Id IN: dbLineItemList];
        for(Integer i=0;i<5;i++){
            if(i==0){
                System.assertNotEquals(oldProductNameMap.get(updatedLineItemList.get(i).Id), updatedLineItemList.get(i).Name);
                System.assertEquals(insuranceTypeNameMap.get(updatedLineItemList.get(i).InsuranceType__c), updatedLineItemList.get(i).Name);
            }else if(i==1){
                System.assertNotEquals(oldProductNameMap.get(updatedLineItemList.get(i).Id), updatedLineItemList.get(i).Name);
                //商品名項目は必須項目なので、保険種類がNULLの場合、レコードIDが商品名（Name）としてセットされる
                System.assertEquals(updatedLineItemList.get(i).Id, updatedLineItemList.get(i).Name);
            }else{
                //紙申込の生保申込の場合、商品名に設定される値の確認(商品名が保険種類に基づいて、変わります)
                System.assertEquals(oldProductNameMap.get(updatedLineItemList.get(i).Id), updatedLineItemList.get(i).Name);
            }
        }
    }

    private List<SeihoOpportunity__c> createSeihoOpportunityData(){

        List<SeihoOpportunity__c> seihoOppList = new List<SeihoOpportunity__c>();
        for(Integer i=1;i<=4;i++){
            //紙申込
            SeihoOpportunity__c opp = new SeihoOpportunity__c(
                Name = '生保紙申込_00'+i,
                ApplicantName__c = 'TestUser_00'+i,
                ApplicantNameKana__c = 'テストユーザー_00'+i,
                ApplicantGender__c = '男性'
            );
            seihoOppList.add(opp);
        }
        //取引先
        Account acc = new Account(
            LastName = 'Account',
            FirstName = 'Test',
            furiganaLast__pc = 'アカウント',
            furiganaForst__pc = 'テスト'
        );
        insert acc;

        //Web申込
        SeihoOpportunity__c opp1 = new SeihoOpportunity__c(
            Name = '生保WEB申込_005',
            AppliNo__c = 'XXXXXXXX0000001',
            ApplyID__c = '00000'+1,
            AppliReceptionChannel__c = 'WEB',
            Ref_Account__c = acc.Id
        );
        seihoOppList.add(opp1);

        return seihoOppList;
    }

    private List<SeihoOpportunityLineItem__c> createSeihoOpportunityLineItemData(List<SeihoOpportunity__c> seihoOpp){

        List<SeihoOpportunityLineItem__c> lineItemList = new List<SeihoOpportunityLineItem__c>();
        for(Integer i=1;i<=4;i++){
            //紙申込に所属される生保申込商品ß
            SeihoOpportunityLineItem__c lineItem = new SeihoOpportunityLineItem__c(
                Name = '生保申込商品_00'+i,
                OpportunityIdReference__c = seihoOpp.get(i-1).Id,
                InsuranceType__c = String.valueOf(Integer.valueOf(15) + i),
                UnitPrice__c = 100
            );
            lineItemList.add(lineItem);
        }
        //Web申込に所属される生保申込商品
        SeihoOpportunityLineItem__c lineItem1 =  new SeihoOpportunityLineItem__c(
            Name = '生保申込商品_005',
            OpportunityId__c = 'XXXXXXXX0000001',
            InsuranceType__c = 'R2',
            OpportunityIdReference__c = null,
            UnitPrice__c = 1000
        );
        lineItemList.add(lineItem1);

        return lineItemList;
    }
    
    private SeihoOpportunityLineItem__c createSeihoOpportunityLineItem(){
        return new SeihoOpportunityLineItem__c(
            Name = '111111',
            OpportunityId__c = '44444',
            OpportunityIdReference__c = null,
            ForeignKey_SeihoOpportunityLineItem__c = '2222222',
            InsuranceType__c = '15'
        );
    }
    
    private SeihoOpportunity__c createSeihoOpportunity(){   
        return new SeihoOpportunity__c(
            Name = '楽天',
            AppliNo__c = '44444',
            AppliReceptionChannel__c = 'WEB'
        );
    }
    
    private SeihoOpportunityLineItem__c createPaperSeihoOpportunityLineItem(String key){
        return new SeihoOpportunityLineItem__c(
            Name = key,
            ForeignKey_SeihoOpportunityLineItem__c = key
        );
    }
    
    private SeihoOpportunity__c createPaperSeihoOpportunity(String name){   
        return new SeihoOpportunity__c(
            Name = name,
            AppliReceptionChannel__c = '紙'
        );
    }
    
    
    private SeihoOpportunityLineItem__c createWebSeihoOpportunityLineItem(String key){
        return new SeihoOpportunityLineItem__c(
            Name = key,
            ForeignKey_SeihoOpportunityLineItem__c = key
        );
    }
    
    private SeihoOpportunity__c createWebSeihoOpportunity(String name, String applyId){   
        return new SeihoOpportunity__c(
            Name = name,
            AppliReceptionChannel__c = 'WEB',
            ApplyID__c = applyId
        );
    }
}