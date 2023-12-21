@isTest
private class Patch_OL020_MigTaskChgListFieldValueTest{
 
    @isTest static void Patch_OL020_UT1_UT3_UT4() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //create Opportunity
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Opportunity opp = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'対応中',acc.Id,'OppName1');
        insert opp;

        //create Task
        Task ta = new Task(whatid = opp.id,Probability__c = 'C',Counter__c = '本人',Status = '未着手');
        insert ta; 
        Task ta1 = new Task(whatid = opp.id,Probability__c = 'D',Counter__c = '本人',Status = '未完了');
        insert ta1; 
        Task ta2 = new Task(whatid = opp.id,Probability__c = 'D',Counter__c = '本人',Status = 'Completed');
        insert ta2; 
    
        Test.startTest();
        Patch_OL020_MigTaskChgListFieldValue batchable = new Patch_OL020_MigTaskChgListFieldValue();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Task> resultList = [Select Probability__c, Counter__c, Status from Task];
        //UT1
        System.assertEquals('C', resultList[0].Probability__c);
        System.assertEquals('申込なし', resultList[1].Probability__c);
        //UT3
        // System.assertEquals('本人', resultList[0].Counter__c);
        // System.assertEquals('その他', resultList[1].Counter__c);
        //UT4
        System.assertEquals('未着手', resultList[0].Status);
        System.assertEquals('着手中', resultList[1].Status);
        System.assertEquals('完了', resultList[2].Status);
    }

    @isTest static void Patch_OL020_UT2() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
        Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();   
        Opportunity oppSei = TestHelperOpportunityTriggerHandler.createOpportunity(oppSeihoRecordTypeId,'未割当',acc.Id,'OppName0');
        Opportunity oppHan = TestHelperOpportunityTriggerHandler.createOpportunity(oppHanyoRecordTypeId,'未割当',acc.Id,'OppName1');
        oppList.add(oppSei);
        oppList.add(oppHan);
        insert oppList;

        List<Task> taskList = new List<Task> ();
        //Task
        Task task1 = new Task(whatid=oppSei.id,ResultType_Large__c='サンキュー',ResultType_Middle__c='発信(サンキュー)',ResultType_Small__c='ミニ保険保障案内済');taskList.add(task1);
        Task task2 = new Task(whatid=oppSei.id,ResultType_Large__c='サンキュー',ResultType_Middle__c='発信(サンキュー)',ResultType_Small__c='資料請求案内済');taskList.add(task2);
        Task task3 = new Task(whatid=oppSei.id,ResultType_Large__c='サンキュー',ResultType_Middle__c='入電(サンキュー)',ResultType_Small__c='資料到着案内済');taskList.add(task3);
        Task task4 = new Task(whatid=oppSei.id,ResultType_Large__c='サンキュー',ResultType_Middle__c='入電(サンキュー)',ResultType_Small__c='見込作成');taskList.add(task4);
        Task task5 = new Task(whatid=oppSei.id,ResultType_Large__c='サンキュー',ResultType_Middle__c='入電(サンキュー)',ResultType_Small__c='見込作成（時設）');taskList.add(task5);
        Task task6 = new Task(whatid=oppSei.id,ResultType_Large__c='サンキュー',ResultType_Middle__c='入電(サンキュー)',ResultType_Small__c='検討中（時設）');taskList.add(task6);
        Task task7 = new Task(whatid=oppSei.id,ResultType_Large__c='不備督促',ResultType_Middle__c='発信',ResultType_Small__c='通話（案内のみ）');taskList.add(task7);
        Task task8 = new Task(whatid=oppSei.id,ResultType_Large__c='不備督促',ResultType_Middle__c='入電',ResultType_Small__c='維持');taskList.add(task8);
        Task task9 = new Task(whatid=oppSei.id,ResultType_Large__c='不備督促',ResultType_Middle__c='折TEL',ResultType_Small__c='折TELその他');taskList.add(task9);
        Task task10 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='申込了承',ResultType_Small__c='');taskList.add(task10);
        Task task11 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='申込了承（時設）',ResultType_Small__c='');taskList.add(task11);
        Task task12 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='申込拒否',ResultType_Small__c='');taskList.add(task12);
        Task task13 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='見込作成',ResultType_Small__c='');taskList.add(task13);
        Task task14 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='見込作成（時設）',ResultType_Small__c='');taskList.add(task14);
        Task task15 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='検討中',ResultType_Small__c='');taskList.add(task15);
        Task task16 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='検討中（時設）',ResultType_Small__c='');taskList.add(task16);
        Task task17 = new Task(whatid=oppSei.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='多忙',ResultType_Small__c='');taskList.add(task17);
        Task task18 = new Task(whatid=oppSei.id,ResultType_Large__c='折TEL',ResultType_Middle__c='本人不在',ResultType_Small__c='');taskList.add(task18);
        Task task19 = new Task(whatid=oppSei.id,ResultType_Large__c='折TEL',ResultType_Middle__c='留守',ResultType_Small__c='');taskList.add(task19);
        Task task20 = new Task(whatid=oppSei.id,ResultType_Large__c='発信',ResultType_Middle__c='留守電',ResultType_Small__c='');taskList.add(task20);
        Task task21 = new Task(whatid=oppSei.id,ResultType_Large__c='発信',ResultType_Middle__c='話中',ResultType_Small__c='');taskList.add(task21);
        Task task22 = new Task(whatid=oppSei.id,ResultType_Large__c='発信',ResultType_Middle__c='コール保留',ResultType_Small__c='');taskList.add(task22);
        Task task23 = new Task(whatid=oppHan.id,ResultType_Large__c='発信',ResultType_Middle__c='電話番号不備',ResultType_Small__c='');taskList.add(task23);
        Task task24 = new Task(whatid=oppHan.id,ResultType_Large__c='発信',ResultType_Middle__c='アポ禁',ResultType_Small__c='');taskList.add(task24);
        Task task25 = new Task(whatid=oppHan.id,ResultType_Large__c='発信',ResultType_Middle__c='その他',ResultType_Small__c='');taskList.add(task25);
        Task task26 = new Task(whatid=oppHan.id,ResultType_Large__c='発信',ResultType_Middle__c='次回架電予約',ResultType_Small__c='');taskList.add(task26);
        Task task27 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='新契約',ResultType_Small__c='申込完了');taskList.add(task27);
        Task task28 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='新契約',ResultType_Small__c='申込了承');taskList.add(task28);
        Task task29 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='新契約',ResultType_Small__c='検討中');taskList.add(task29);
        Task task30 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='新契約',ResultType_Small__c='申込拒否');taskList.add(task30);
        Task task31 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='新契約',ResultType_Small__c='新契約その他');taskList.add(task31);
        Task task32 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='維持',ResultType_Small__c='契約照会');taskList.add(task32);
        Task task33 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='風評',ResultType_Small__c='風評');taskList.add(task33);
        Task task34 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='楽天グループ',ResultType_Small__c='楽天グループ事業関連');taskList.add(task34);
        Task task35 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='呼損',ResultType_Small__c='呼損');taskList.add(task35);
        Task task36 = new Task(whatid=oppHan.id,ResultType_Large__c='入電',ResultType_Middle__c='入電その他',ResultType_Small__c='ワン切り');taskList.add(task36);
        Task task37 = new Task(whatid=oppHan.id,ResultType_Large__c='折TEL',ResultType_Middle__c='通話',ResultType_Small__c='検討中');taskList.add(task37);
        Task task38 = new Task(whatid=oppHan.id,ResultType_Large__c='折TEL',ResultType_Middle__c='通話（未案内）',ResultType_Small__c='');taskList.add(task38);
        Task task39 = new Task(whatid=oppHan.id,ResultType_Large__c='折TEL',ResultType_Middle__c='折TELその他',ResultType_Small__c='');taskList.add(task39);
        Task task40 = new Task(whatid=oppHan.id,ResultType_Large__c='謝絶フォロー',ResultType_Middle__c='申込済',ResultType_Small__c='');taskList.add(task40);
        Task task41 = new Task(whatid=oppHan.id,ResultType_Large__c='発信',ResultType_Middle__c='システム切電',ResultType_Small__c='');taskList.add(task41);
        Task task42 = new Task(whatid=oppHan.id,ResultType_Large__c='発信',ResultType_Middle__c='発信放棄呼',ResultType_Small__c='');taskList.add(task42);
        Task task43 = new Task(whatid=oppHan.id,ResultType_Large__c='不備督促',ResultType_Middle__c='発信',ResultType_Small__c='アポ禁');taskList.add(task43);
        Task task44 = new Task(whatid=oppHan.id,ResultType_Large__c='',ResultType_Middle__c='',ResultType_Small__c='');taskList.add(task44);
                
        insert taskList; 
    
        Test.startTest();
        Patch_OL020_MigTaskChgListFieldValue batchable = new Patch_OL020_MigTaskChgListFieldValue();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //Assert
        List<Task> resultList = [Select ResultType_Large__c,ResultType_Middle__c,ResultType_Small__c from Task Where ID in :taskList];
        // 大分類
        System.assertEquals('発信', resultList[0].ResultType_Large__c);
        System.assertEquals('発信', resultList[1].ResultType_Large__c);
        System.assertEquals('入電', resultList[2].ResultType_Large__c);
        System.assertEquals('入電', resultList[3].ResultType_Large__c);
        System.assertEquals('入電', resultList[4].ResultType_Large__c);
        System.assertEquals('入電', resultList[5].ResultType_Large__c);
        System.assertEquals('発信', resultList[6].ResultType_Large__c);
        System.assertEquals('入電', resultList[7].ResultType_Large__c);
        System.assertEquals('折TEL', resultList[8].ResultType_Large__c);
        System.assertEquals('発信', resultList[9].ResultType_Large__c);
        System.assertEquals('発信', resultList[10].ResultType_Large__c);
        System.assertEquals('発信', resultList[11].ResultType_Large__c);
        System.assertEquals('発信', resultList[12].ResultType_Large__c);
        System.assertEquals('発信', resultList[13].ResultType_Large__c);
        System.assertEquals('発信', resultList[14].ResultType_Large__c);
        System.assertEquals('発信', resultList[15].ResultType_Large__c);
        System.assertEquals('発信', resultList[16].ResultType_Large__c);
        System.assertEquals('折TEL', resultList[17].ResultType_Large__c);
        System.assertEquals('折TEL', resultList[18].ResultType_Large__c);
        System.assertEquals('発信', resultList[19].ResultType_Large__c);
        System.assertEquals('発信', resultList[20].ResultType_Large__c);
        System.assertEquals('発信', resultList[21].ResultType_Large__c);
        System.assertEquals('発信', resultList[22].ResultType_Large__c);
        System.assertEquals('発信', resultList[23].ResultType_Large__c);
        System.assertEquals('発信', resultList[24].ResultType_Large__c);
        System.assertEquals('発信', resultList[25].ResultType_Large__c);
        System.assertEquals('入電', resultList[26].ResultType_Large__c);
        System.assertEquals('入電', resultList[27].ResultType_Large__c);
        System.assertEquals('入電', resultList[28].ResultType_Large__c);
        System.assertEquals('入電', resultList[29].ResultType_Large__c);
        System.assertEquals('入電', resultList[30].ResultType_Large__c);
        System.assertEquals('入電', resultList[31].ResultType_Large__c);
        System.assertEquals('入電', resultList[32].ResultType_Large__c);
        System.assertEquals('入電', resultList[33].ResultType_Large__c);
        System.assertEquals('入電', resultList[34].ResultType_Large__c);
        System.assertEquals('入電', resultList[35].ResultType_Large__c);
        System.assertEquals('折TEL', resultList[36].ResultType_Large__c);
        System.assertEquals('折TEL', resultList[37].ResultType_Large__c);
        System.assertEquals('折TEL', resultList[38].ResultType_Large__c);
        System.assertEquals('発信', resultList[39].ResultType_Large__c);
        System.assertEquals('発信', resultList[40].ResultType_Large__c);
        System.assertEquals('発信', resultList[41].ResultType_Large__c);
        System.assertEquals('発信', resultList[42].ResultType_Large__c);
        System.assertEquals(null, resultList[43].ResultType_Large__c);
                
        // 中分類
        System.assertEquals('Web誘導', resultList[0].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[1].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[2].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[3].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[4].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[5].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[6].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[7].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[8].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[9].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[10].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[11].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[12].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[13].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[14].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[15].ResultType_Middle__c);
        System.assertEquals('不通', resultList[16].ResultType_Middle__c);
        System.assertEquals('不通', resultList[17].ResultType_Middle__c);
        System.assertEquals('不通', resultList[18].ResultType_Middle__c);
        System.assertEquals('不通', resultList[19].ResultType_Middle__c);
        System.assertEquals('不通', resultList[20].ResultType_Middle__c);
        System.assertEquals('不通', resultList[21].ResultType_Middle__c);
        System.assertEquals('不通', resultList[22].ResultType_Middle__c);
        System.assertEquals('不通', resultList[23].ResultType_Middle__c);
        System.assertEquals('不通', resultList[24].ResultType_Middle__c);
        System.assertEquals('不通', resultList[25].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[26].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[27].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[28].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[29].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[30].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[31].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[32].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[33].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[34].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[35].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[36].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[37].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[38].ResultType_Middle__c);
        System.assertEquals('申込後架電', resultList[39].ResultType_Middle__c);
        System.assertEquals('不通', resultList[40].ResultType_Middle__c);
        System.assertEquals('不通', resultList[41].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[42].ResultType_Middle__c);
        System.assertEquals(null, resultList[43].ResultType_Middle__c);
                
        // 小分類
        System.assertEquals('継続検討', resultList[0].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[1].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[2].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[3].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[4].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[5].ResultType_Small__c);
        System.assertEquals('通話（案内のみ）', resultList[6].ResultType_Small__c);
        System.assertEquals('維持', resultList[7].ResultType_Small__c);
        System.assertEquals('折TELその他', resultList[8].ResultType_Small__c);
        System.assertEquals('了承', resultList[9].ResultType_Small__c);
        System.assertEquals('了承', resultList[10].ResultType_Small__c);
        System.assertEquals('拒否', resultList[11].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[12].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[13].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[14].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[15].ResultType_Small__c);
        System.assertEquals('多忙', resultList[16].ResultType_Small__c);
        System.assertEquals('本人不在', resultList[17].ResultType_Small__c);
        System.assertEquals('留守', resultList[18].ResultType_Small__c);
        System.assertEquals('留守電', resultList[19].ResultType_Small__c);
        System.assertEquals(null, resultList[20].ResultType_Small__c);
        System.assertEquals(null, resultList[21].ResultType_Small__c);
        System.assertEquals('電話番号不備', resultList[22].ResultType_Small__c);
        System.assertEquals(null, resultList[23].ResultType_Small__c);
        System.assertEquals(null, resultList[24].ResultType_Small__c);
        System.assertEquals(null, resultList[25].ResultType_Small__c);
        System.assertEquals('申込完了', resultList[26].ResultType_Small__c);
        System.assertEquals('了承', resultList[27].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[28].ResultType_Small__c);
        System.assertEquals('拒否', resultList[29].ResultType_Small__c);
        System.assertEquals(null, resultList[30].ResultType_Small__c);
        System.assertEquals('契約照会', resultList[31].ResultType_Small__c);
        System.assertEquals('風評', resultList[32].ResultType_Small__c);
        System.assertEquals('楽天グループ事業関連', resultList[33].ResultType_Small__c);
        System.assertEquals('呼損', resultList[34].ResultType_Small__c);
        System.assertEquals('ワン切り', resultList[35].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[36].ResultType_Small__c);
        System.assertEquals(null, resultList[37].ResultType_Small__c);
        System.assertEquals(null, resultList[38].ResultType_Small__c);
        System.assertEquals('申込完了', resultList[39].ResultType_Small__c);
        System.assertEquals('システム切電', resultList[40].ResultType_Small__c);
        System.assertEquals('発信放棄呼', resultList[41].ResultType_Small__c);
        System.assertEquals('不要', resultList[42].ResultType_Small__c);
        System.assertEquals(null, resultList[43].ResultType_Small__c);
                
    }

    @isTest static void Patch_OL020_UT5() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Id oppSyotanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();   
        Opportunity oppSon = TestHelperOpportunityTriggerHandler.createOpportunity(oppSonpoRecordTypeId,'未割当',acc.Id,'OppName0');
        Opportunity oppSyo = TestHelperOpportunityTriggerHandler.createOpportunity(oppSyotanRecordTypeId,'未割当',acc.Id,'OppName1');
        oppList.add(oppSon);
        oppList.add(oppSyo);
        insert oppList;

        List<Task> taskList = new List<Task> ();
        //Task
        Task task1 = new Task(whatid=oppSon.id,ResultType_Middle__c='Web誘導',ResultType_Small__c='申込完了');taskList.add(task1);
        Task task2 = new Task(whatid=oppSon.id,ResultType_Middle__c='Web誘導',ResultType_Small__c='申込了承');taskList.add(task2);
        Task task3 = new Task(whatid=oppSon.id,ResultType_Middle__c='Web誘導',ResultType_Small__c='検討中');taskList.add(task3);
        Task task4 = new Task(whatid=oppSon.id,ResultType_Middle__c='Web誘導',ResultType_Small__c='NG（年齢）');taskList.add(task4);
        Task task5 = new Task(whatid=oppSon.id,ResultType_Middle__c='資料送付',ResultType_Small__c='投函済み');taskList.add(task5);
        Task task6 = new Task(whatid=oppSon.id,ResultType_Middle__c='資料送付',ResultType_Small__c='NG（既往症）');taskList.add(task6);
        Task task7 = new Task(whatid=oppSon.id,ResultType_Middle__c='資料送付',ResultType_Small__c='NG（保険料）');taskList.add(task7);
        Task task8 = new Task(whatid=oppSon.id,ResultType_Middle__c='資料送付',ResultType_Small__c='NG（その他）');taskList.add(task8);
        Task task9 = new Task(whatid=oppSon.id,ResultType_Middle__c='即申込（初回コンタクト時）',ResultType_Small__c='');taskList.add(task9);
        Task task10 = new Task(whatid=oppSon.id,ResultType_Middle__c='対面誘導',ResultType_Small__c='');taskList.add(task10);
        Task task11 = new Task(whatid=oppSon.id,ResultType_Middle__c='問合わせ',ResultType_Small__c='');taskList.add(task11);
        Task task12 = new Task(whatid=oppSyo.id,ResultType_Middle__c='多忙',ResultType_Small__c='');taskList.add(task12);
        Task task13 = new Task(whatid=oppSyo.id,ResultType_Middle__c='本人不在',ResultType_Small__c='');taskList.add(task13);
        Task task14 = new Task(whatid=oppSyo.id,ResultType_Middle__c='留守',ResultType_Small__c='');taskList.add(task14);
        Task task15 = new Task(whatid=oppSyo.id,ResultType_Middle__c='留守電',ResultType_Small__c='');taskList.add(task15);
        Task task16 = new Task(whatid=oppSyo.id,ResultType_Middle__c='電話番号不備',ResultType_Small__c='');taskList.add(task16);
        Task task17 = new Task(whatid=oppSyo.id,ResultType_Middle__c='架電拒否',ResultType_Small__c='');taskList.add(task17);
        Task task18 = new Task(whatid=oppSyo.id,ResultType_Middle__c='アポ禁',ResultType_Small__c='');taskList.add(task18);
        Task task19 = new Task(whatid=oppSyo.id,ResultType_Middle__c='その他',ResultType_Small__c='');taskList.add(task19);
        Task task20 = new Task(whatid=oppSyo.id,ResultType_Middle__c='システム切電',ResultType_Small__c='');taskList.add(task20);
        Task task21 = new Task(whatid=oppSyo.id,ResultType_Middle__c='発信放棄呼',ResultType_Small__c='');taskList.add(task21);
        Task task22 = new Task(whatid=oppSyo.id,ResultType_Middle__c='',ResultType_Small__c='');taskList.add(task22);
        insert taskList; 
    
        Test.startTest();
        Patch_OL020_MigTaskChgListFieldValue batchable = new Patch_OL020_MigTaskChgListFieldValue();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        //Assert
        List<Task> resultList = [Select ResultType_Large__c,ResultType_Middle__c,ResultType_Small__c from Task Where ID in :taskList];
        // 中分類
        System.assertEquals('Web誘導', resultList[0].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[1].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[2].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[3].ResultType_Middle__c);
        System.assertEquals('資料送付', resultList[4].ResultType_Middle__c);
        System.assertEquals('資料送付', resultList[5].ResultType_Middle__c);
        System.assertEquals('資料送付', resultList[6].ResultType_Middle__c);
        System.assertEquals('資料送付', resultList[7].ResultType_Middle__c);
        System.assertEquals('Web誘導', resultList[8].ResultType_Middle__c);
        System.assertEquals('対面誘導', resultList[9].ResultType_Middle__c);
        System.assertEquals('問合せ', resultList[10].ResultType_Middle__c);
        System.assertEquals('不通', resultList[11].ResultType_Middle__c);
        System.assertEquals('不通', resultList[12].ResultType_Middle__c);
        System.assertEquals('不通', resultList[13].ResultType_Middle__c);
        System.assertEquals('不通', resultList[14].ResultType_Middle__c);
        System.assertEquals('不通', resultList[15].ResultType_Middle__c);
        System.assertEquals('不要', resultList[16].ResultType_Middle__c);
        System.assertEquals('不要', resultList[17].ResultType_Middle__c);
        System.assertEquals('不通', resultList[18].ResultType_Middle__c);
        System.assertEquals('不通', resultList[19].ResultType_Middle__c);
        System.assertEquals('不通', resultList[20].ResultType_Middle__c);
        System.assertEquals(null, resultList[21].ResultType_Middle__c);
                
        // 小分類
        System.assertEquals('申込完了', resultList[0].ResultType_Small__c);
        System.assertEquals('了承', resultList[1].ResultType_Small__c);
        System.assertEquals('継続検討', resultList[2].ResultType_Small__c);
        System.assertEquals('謝絶', resultList[3].ResultType_Small__c);
        System.assertEquals('了承', resultList[4].ResultType_Small__c);
        System.assertEquals('謝絶', resultList[5].ResultType_Small__c);
        System.assertEquals('謝絶', resultList[6].ResultType_Small__c);
        System.assertEquals('謝絶', resultList[7].ResultType_Small__c);
        System.assertEquals('申込完了', resultList[8].ResultType_Small__c);
        System.assertEquals(null, resultList[9].ResultType_Small__c);
        System.assertEquals(null, resultList[10].ResultType_Small__c);
        System.assertEquals('多忙', resultList[11].ResultType_Small__c);
        System.assertEquals('本人不在', resultList[12].ResultType_Small__c);
        System.assertEquals('留守', resultList[13].ResultType_Small__c);
        System.assertEquals('留守電', resultList[14].ResultType_Small__c);
        System.assertEquals('電話番号不備', resultList[15].ResultType_Small__c);
        System.assertEquals(null, resultList[16].ResultType_Small__c);
        System.assertEquals(null, resultList[17].ResultType_Small__c);
        System.assertEquals(null, resultList[18].ResultType_Small__c);
        System.assertEquals('システム切電', resultList[19].ResultType_Small__c);
        System.assertEquals('発信放棄呼', resultList[20].ResultType_Small__c);
        System.assertEquals(null, resultList[21].ResultType_Small__c);

    }

}