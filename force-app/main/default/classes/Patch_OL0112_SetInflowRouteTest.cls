@isTest
private class Patch_OL0112_SetInflowRouteTest {
    public Patch_OL0112_SetInflowRouteTest() {

    }

    @isTest static void Patch_OL0112_UT1() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();

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
        opp7.InflowRoute__c = 'アップセル（ミニ開始30日以内）';
        oppList.add(opp7);

        //UT1_9
        Opportunity opp8 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp8.InflowRoute__c = 'アップセル（ミニ開始90日以内）';
        oppList.add(opp8);

        //UT1_10
        Opportunity opp71 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp71.InflowRoute__c = 'アップセル（ミニ開始8カ月前）';
        oppList.add(opp71);

        //UT1_11
        Opportunity opp81 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp81.InflowRoute__c = 'アップセル（ミニ終了3カ月前）';
        oppList.add(opp81);

        //UT1_12
        Opportunity opp9 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp9.InflowRoute__c = 'ミニ_サンキューコール';
        oppList.add(opp9);

        //UT1_13
        Opportunity opp10 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName1');
        opp10.InflowRoute__c = 'ssssssssssss';
        oppList.add(opp10);

        insert oppList; 

        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
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
        System.assertEquals('ミニ保険', OppResultList[7].InflowRoute__c);
        System.assertEquals('ミニ保険', OppResultList[8].InflowRoute__c);
        System.assertEquals('ミニ保険', OppResultList[9].InflowRoute__c);
        System.assertEquals('ミニ保険', OppResultList[10].InflowRoute__c);
        System.assertEquals('ミニ保険', OppResultList[11].InflowRoute__c);
        System.assertEquals('ssssssssssss', OppResultList[12].InflowRoute__c);
    }
 
    @isTest static void Patch_OL0112_UT2_1() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '全商談終了';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Opportunity opp21 = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'対応中',acc.Id,'OppName1');
        opp21.InflowRoute__c = '';
        opp21.CloseDate = Date.newInstance(2020, 3, 28);
        insert opp21;
      
        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c,StageName from Opportunity where id = :opp21.id];
        System.assertEquals(null, OppResultList[0].InflowRoute__c);
        System.assertEquals('対応終了', OppResultList[0].StageName);
    }

    @isTest static void Patch_OL0112_UT2_2() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        //Create SeihoLead__c
        SeihoLead__c sei = new SeihoLead__c();
        insert sei;
        sei.Opportunity__c = opp.id;
        update sei;

        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals('資料請求', OppResultList[0].InflowRoute__c);
    }

    @isTest static void Patch_OL0112_UT2_3() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        //Create SeihoOpportunity__c
        SeihoOpportunity__c seiOp = new SeihoOpportunity__c();
        insert seiOp;
        seiOp.Opportunity__c = opp.id;
        update seiOp;
        
        //Create SeihoLead__c
        SeihoLead__c sei = new SeihoLead__c();
        insert sei;
        sei.Opportunity__c = opp.id;
        update sei;
        
        //最も古いリード設定
        Test.setCreatedDate(seiOp.id,DateTime.newInstance(2019,12,12));

        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals('申込途中保存', OppResultList[0].InflowRoute__c);
    }

    @isTest static void Patch_OL0112_UT2_4() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'対応終了',acc.Id,'OppName1');
        opp.InflowRoute__c = '';
        insert opp;

        //Create SeihoLead__c
        SeihoLead__c sei = new SeihoLead__c();
        insert sei;
        sei.Opportunity__c = opp.id;
        update sei;
        
        //Create SeihoOpportunity__c
        SeihoOpportunity__c seiOp = new SeihoOpportunity__c();
        insert seiOp;
        seiOp.Opportunity__c = opp.id;
        update seiOp;
        
        //Create MiniInsurance__c
        MiniInsurance__c mini = new MiniInsurance__c();
        insert mini;
        mini.OpportunityId__c = opp.id;
        update mini;
        
        //最も古いリード設定
        Test.setCreatedDate(sei.id,DateTime.newInstance(2019,12,12));

        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c from Opportunity where id = :opp.id];
        System.assertEquals('資料請求', OppResultList[0].InflowRoute__c);
    }

    @isTest static void Patch_OL0112_UT2_5() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'対応終了',acc.Id,'20181104_生保_トモノ');
        opp.InflowRoute__c = '';
        insert opp;

        //Create MiniInsurance__c
        MiniInsurance__c mini = new MiniInsurance__c();
        insert mini;
        mini.OpportunityId__c = opp.id;
        update mini;
        
        //Create SeihoOpportunity__c
        SeihoOpportunity__c seiOp = new SeihoOpportunity__c();
        insert seiOp;
        seiOp.Opportunity__c = opp.id;
        update seiOp;
        
        //最も古いリード設定
        Test.setCreatedDate(mini.id,DateTime.newInstance(2019,12,12));

        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c,RecordType.Name,Name from Opportunity where id = :opp.id];
        System.assertEquals('ミニ保険', OppResultList[0].InflowRoute__c);
        System.assertEquals('生保', OppResultList[0].RecordType.Name);
        System.assertEquals('20181104_生保_トモノ', OppResultList[0].Name);
    }

    @isTest static void Patch_OL0112_UT2_6() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();

        //Create MiniInsurance__c
        MiniInsurance__c mini = new MiniInsurance__c();
        insert mini;
        mini = [Select OpportunityId__c From MiniInsurance__c Where Id=:mini.id];

        Opportunity opp = [select Id,AccountId,RecordTypeId,CampaignDateTime__c,Name,StageName,InflowRoute__c,CloseDate From Opportunity where Id=:mini.OpportunityId__c];
        opp.AccountId = acc.Id;
        opp.RecordTypeId = oppSeihoRecordTypeId;
        opp.CampaignDateTime__c = System.now(); 
        opp.Name = '20181104_生保_トモノ';
        opp.StageName = '対応中';
        opp.InflowRoute__c = '';
        opp.CloseDate = Date.newInstance(2020, 2, 28);
        update opp;
        
        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //Opportynityトリガーが起動しているとエラーになる（'汎用商談以外のレコードタイプを変更することはできません。'）
        // 　＞Opportynityトリガーを停止して確認済みのため、コメントアウトする
        // List<Opportunity> OppResultList = [Select InflowRoute__c,RecordType.Name,Name,closeDate,stageName from Opportunity where id = :opp.id];
        // // System.assertEquals('ミニ保険', OppResultList[0].InflowRoute__c);
        // // System.assertEquals('汎用', OppResultList[0].RecordType.Name);
        // // System.assertEquals('20181104_汎用_トモノ', OppResultList[0].Name);
        // System.assertEquals(Date.newInstance(2020, 3, 31), OppResultList[0].closeDate);
        // System.assertEquals('対応中', OppResultList[0].stageName);
    }

    @isTest static void Patch_OL0112_UT2_7() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();

        //Create MiniInsurance__c
        MiniInsurance__c mini = new MiniInsurance__c();
        insert mini;
        mini = [Select OpportunityId__c From MiniInsurance__c Where Id=:mini.id];

        Opportunity opp = [select Id,AccountId,RecordTypeId,CampaignDateTime__c,Name,StageName,InflowRoute__c,CloseDate From Opportunity where Id=:mini.OpportunityId__c];
        opp.AccountId = acc.Id;
        opp.RecordTypeId = oppSeihoRecordTypeId;
        opp.CampaignDateTime__c = System.now(); 
        opp.Name = '20181104_生保_トモノ';
        opp.StageName = '対応中';
        opp.InflowRoute__c = '';
        opp.CloseDate = Date.newInstance(2019, 12, 1);
        update opp;
        
        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //Opportynityトリガーが起動しているとエラーになる（'汎用商談以外のレコードタイプを変更することはできません。'）
        // 　＞Opportynityトリガーを停止して確認済みのため、コメントアウトする
        // List<Opportunity> OppResultList = [Select InflowRoute__c,RecordType.Name,Name,closeDate,stageName from Opportunity where id = :opp.id];
        // // System.assertEquals('ミニ保険', OppResultList[0].InflowRoute__c);
        // // System.assertEquals('汎用', OppResultList[0].RecordType.Name);
        // // System.assertEquals('20181104_汎用_トモノ', OppResultList[0].Name);
        // System.assertEquals(Date.newInstance(2020, 1, 31), OppResultList[0].closeDate);
        // System.assertEquals('対応終了', OppResultList[0].stageName);
    }

    @isTest static void Patch_OL0112_UT2_8() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        acc.OpportunityStatus__c = '対応継続可';
        acc.Migration_Id2__c='200000';
        insert acc;
        
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();

        //Create MiniInsurance__c
        MiniInsurance__c mini = new MiniInsurance__c();
        insert mini;
        mini = [Select OpportunityId__c From MiniInsurance__c Where Id=:mini.id];

        Opportunity opp = [select Id,AccountId,RecordTypeId,CampaignDateTime__c,Name,StageName,InflowRoute__c,CloseDate From Opportunity where Id=:mini.OpportunityId__c];
        opp.AccountId = acc.Id;
        opp.RecordTypeId = oppSeihoRecordTypeId;
        opp.CampaignDateTime__c = System.now(); 
        opp.Name = '20181104_生保_トモノ';
        opp.StageName = '対応中';
        opp.InflowRoute__c = '';
        opp.CloseDate = Date.newInstance(2020, 1, 31);
        update opp;
        
        //create Task
        Task ta = new Task(whatid = opp.id,Probability__c = 'C',Counter__c = '本人',Status = '未着手');
        insert ta; 

        Test.startTest();
        Patch_OL0112_SetInflowRouteAndRecordType batchable = new Patch_OL0112_SetInflowRouteAndRecordType();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> OppResultList = [Select InflowRoute__c,RecordType.Name,Name,closeDate,stageName from Opportunity where id = :opp.id];
        System.assertEquals('ミニ保険', OppResultList[0].InflowRoute__c);
        System.assertEquals('生保', OppResultList[0].RecordType.Name);
        System.assertEquals('20181104_生保_トモノ', OppResultList[0].Name);
        System.assertEquals(Date.newInstance(2020, 2, 29), OppResultList[0].closeDate);
        System.assertEquals('対応終了', OppResultList[0].stageName);
    }
}