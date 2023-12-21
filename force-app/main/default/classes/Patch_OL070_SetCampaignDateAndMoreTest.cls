@isTest
private class Patch_OL070_SetCampaignDateAndMoreTest{
 
    @isTest static void Patch_OL070_UT1() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();
        Opportunity oppSyo1 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsAnshinPet__c=TRUE,IsOther_Little__c=FALSE,IsFree__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo1);
        Opportunity oppSyo2 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsAnshinPet__c=FALSE,IsOther_Little__c=TRUE,IsFree__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo2);
        Opportunity oppSyo3 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsAnshinPet__c=FALSE,IsOther_Little__c=FALSE,IsFree__c=TRUE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo3);
        Opportunity oppSyo4 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsAnshinPet__c=TRUE,IsOther_Little__c=TRUE,IsFree__c=TRUE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo4);
        Opportunity oppSyo5 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsAnshinPet__c=FALSE,IsOther_Little__c=FALSE,IsFree__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo5);
        insert oppList;
    
        Test.startTest();
        Patch_OL070_SetCampaignDateAndMore batchable = new Patch_OL070_SetCampaignDateAndMore();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> resultList = [Select ProdctName__c,prodtype_multilist__c from Opportunity Where ID in :oppList];
        //商品名
        System.assertEquals('あんしんペット保険', resultList[0].ProdctName__c);
        System.assertEquals('その他商品_少短', resultList[1].ProdctName__c);
        System.assertEquals('フリー保険', resultList[2].ProdctName__c);
        System.assertEquals('あんしんペット保険\nその他商品_少短\nフリー保険', resultList[3].ProdctName__c);
        System.assertEquals(null, resultList[4].ProdctName__c);
        //商品種類
        System.assertEquals('ペット', resultList[0].prodtype_multilist__c);
        System.assertEquals('その他', resultList[1].prodtype_multilist__c);
        System.assertEquals('その他', resultList[2].prodtype_multilist__c);
        System.assertEquals('その他;ペット', resultList[3].prodtype_multilist__c);
        System.assertEquals(null, resultList[4].prodtype_multilist__c);
                        
    }

    // @isTest static void Patch_OL070_UT2() {
    //     //create Account
    //     Account acc = TestHelperOpportunityTriggerHandler.createAccount();
    //     acc.OperationType__c ='割当可';
    //     insert acc;
        
    //     //create Opportunity
    //     List<Opportunity> oppList = new List<Opportunity> ();
    //     Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Seiho').getRecordTypeId();
    //     Opportunity oppSei1 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsSuper2000__c=TRUE,IsAnshinPlus_JoseiSupport__c=FALSE,IsSuperIryou__c=FALSE,IsAnshinPlus_GanSupport__c=FALSE,IsSuperTayoreruIryou__c=FALSE,IsAnshinPlus_NyuinSupport__c=FALSE,IsSuperGan__c=FALSE,IsMini__c=FALSE,IsSuperTeiki__c=FALSE,IsOther_Life__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSei1);
    //     Opportunity oppSei2 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsSuper2000__c=FALSE,IsAnshinPlus_JoseiSupport__c=TRUE,IsSuperIryou__c=FALSE,IsAnshinPlus_GanSupport__c=TRUE,IsSuperTayoreruIryou__c=FALSE,IsAnshinPlus_NyuinSupport__c=FALSE,IsSuperGan__c=FALSE,IsMini__c=FALSE,IsSuperTeiki__c=FALSE,IsOther_Life__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSei2);
    //     Opportunity oppSei3 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsSuper2000__c=FALSE,IsAnshinPlus_JoseiSupport__c=FALSE,IsSuperIryou__c=TRUE,IsAnshinPlus_GanSupport__c=FALSE,IsSuperTayoreruIryou__c=TRUE,IsAnshinPlus_NyuinSupport__c=FALSE,IsSuperGan__c=TRUE,IsMini__c=TRUE,IsSuperTeiki__c=FALSE,IsOther_Life__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSei3);
    //     Opportunity oppSei4 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsSuper2000__c=FALSE,IsAnshinPlus_JoseiSupport__c=FALSE,IsSuperIryou__c=FALSE,IsAnshinPlus_GanSupport__c=FALSE,IsSuperTayoreruIryou__c=FALSE,IsAnshinPlus_NyuinSupport__c=TRUE,IsSuperGan__c=FALSE,IsMini__c=FALSE,IsSuperTeiki__c=FALSE,IsOther_Life__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSei4);
    //     Opportunity oppSei5 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsSuper2000__c=TRUE,IsAnshinPlus_JoseiSupport__c=TRUE,IsSuperIryou__c=TRUE,IsAnshinPlus_GanSupport__c=FALSE,IsSuperTayoreruIryou__c=FALSE,IsAnshinPlus_NyuinSupport__c=FALSE,IsSuperGan__c=FALSE,IsMini__c=FALSE,IsSuperTeiki__c=TRUE,IsOther_Life__c=TRUE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSei5);
    //     insert oppList;
    
    //     Test.startTest();
    //     Patch_OL070_SetCampaignDateAndMore batchable = new Patch_OL070_SetCampaignDateAndMore();
    //     Database.executeBatch(batchable, 100);
    //     Test.stopTest();

    //     List<Opportunity> resultList = [Select ProdctName__c,prodtype_multilist__c from Opportunity Where ID in :oppList];
    //     //商品名
    //     System.assertEquals('楽天生命スーパー2000', resultList[0].ProdctName__c);
    //     System.assertEquals('楽天生命あんしんプラス（女性サポート）\n楽天生命あんしんプラス（がんサポート）', resultList[1].ProdctName__c);
    //     System.assertEquals('楽天生命スーパー医療保険\n楽天生命スーパーたよれる医療保険\n楽天生命スーパーがん保険\nミニ保険', resultList[2].ProdctName__c);
    //     System.assertEquals('楽天生命あんしんプラス（入院サポート）', resultList[3].ProdctName__c);
    //     System.assertEquals('楽天生命スーパー2000\n楽天生命あんしんプラス（女性サポート）\n楽天生命スーパー医療保険\n楽天生命スーパー定期保険\nその他商品_生命', resultList[4].ProdctName__c);
        
    //     //商品種類
    //     System.assertEquals('総合保障', resultList[0].prodtype_multilist__c);
    //     System.assertEquals('一時金保障（ガン有）', resultList[1].prodtype_multilist__c);
    //     System.assertEquals('医療（ガン有）', resultList[2].prodtype_multilist__c);
    //     System.assertEquals('一時金保障', resultList[3].prodtype_multilist__c);
    //     System.assertEquals('死亡;医療（ガン有）;一時金保障（ガン有）;総合保障;その他', resultList[4].prodtype_multilist__c);
                                
    // }

    @isTest static void Patch_OL070_UT3() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Opportunity oppSon1 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsCycleAssist__c=TRUE,IsDriveAssist__c=FALSE,IsGolfAssist__c=FALSE,Is1Day__c=FALSE,IsHomeAssist__c=FALSE,IsOther_Damage__c=FALSE,IsLivingAssist__c=FALSE,IsTravelAssist_Global__c=FALSE,IsTravelAssist_Domestic__c=FALSE,IsJitensha__c=TRUE,IsMochimonoSupport__c=FALSE,IsJitensha_Child__c=TRUE,IsRentalSupport__c=FALSE,IsGolfer__c=FALSE,IsNichijouBaisyou__c=FALSE,IsOutdoor__c=FALSE,IsChintaiAnshin__c=FALSE,IsSports__c=FALSE,IsKajiDaikou__c=FALSE,IsHareyakaSedai__c=FALSE,IsPapaMamma__c=FALSE,IsOkaimonoAnshin__c=FALSE,IsJosei__c=FALSE,IsOther_BerryEasy__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSon1);
        Opportunity oppSon2 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsCycleAssist__c=FALSE,IsDriveAssist__c=TRUE,IsGolfAssist__c=FALSE,Is1Day__c=FALSE,IsHomeAssist__c=FALSE,IsOther_Damage__c=FALSE,IsLivingAssist__c=FALSE,IsTravelAssist_Global__c=FALSE,IsTravelAssist_Domestic__c=FALSE,IsJitensha__c=FALSE,IsMochimonoSupport__c=FALSE,IsJitensha_Child__c=FALSE,IsRentalSupport__c=FALSE,IsGolfer__c=FALSE,IsNichijouBaisyou__c=FALSE,IsOutdoor__c=FALSE,IsChintaiAnshin__c=FALSE,IsSports__c=FALSE,IsKajiDaikou__c=FALSE,IsHareyakaSedai__c=FALSE,IsPapaMamma__c=FALSE,IsOkaimonoAnshin__c=FALSE,IsJosei__c=FALSE,IsOther_BerryEasy__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSon2);
        Opportunity oppSon3 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsCycleAssist__c=FALSE,IsDriveAssist__c=FALSE,IsGolfAssist__c=FALSE,Is1Day__c=FALSE,IsHomeAssist__c=TRUE,IsOther_Damage__c=FALSE,IsLivingAssist__c=TRUE,IsTravelAssist_Global__c=FALSE,IsTravelAssist_Domestic__c=FALSE,IsJitensha__c=FALSE,IsMochimonoSupport__c=FALSE,IsJitensha_Child__c=FALSE,IsRentalSupport__c=FALSE,IsGolfer__c=FALSE,IsNichijouBaisyou__c=FALSE,IsOutdoor__c=FALSE,IsChintaiAnshin__c=TRUE,IsSports__c=FALSE,IsKajiDaikou__c=FALSE,IsHareyakaSedai__c=FALSE,IsPapaMamma__c=FALSE,IsOkaimonoAnshin__c=FALSE,IsJosei__c=FALSE,IsOther_BerryEasy__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSon3);
        Opportunity oppSon4 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsCycleAssist__c=FALSE,IsDriveAssist__c=FALSE,IsGolfAssist__c=FALSE,Is1Day__c=FALSE,IsHomeAssist__c=FALSE,IsOther_Damage__c=TRUE,IsLivingAssist__c=FALSE,IsTravelAssist_Global__c=FALSE,IsTravelAssist_Domestic__c=FALSE,IsJitensha__c=FALSE,IsMochimonoSupport__c=TRUE,IsJitensha_Child__c=FALSE,IsRentalSupport__c=TRUE,IsGolfer__c=FALSE,IsNichijouBaisyou__c=TRUE,IsOutdoor__c=FALSE,IsChintaiAnshin__c=FALSE,IsSports__c=FALSE,IsKajiDaikou__c=TRUE,IsHareyakaSedai__c=TRUE,IsPapaMamma__c=TRUE,IsOkaimonoAnshin__c=TRUE,IsJosei__c=TRUE,IsOther_BerryEasy__c=TRUE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSon4);
        Opportunity oppSon5 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsCycleAssist__c=FALSE,IsDriveAssist__c=FALSE,IsGolfAssist__c=TRUE,Is1Day__c=TRUE,IsHomeAssist__c=FALSE,IsOther_Damage__c=FALSE,IsLivingAssist__c=FALSE,IsTravelAssist_Global__c=TRUE,IsTravelAssist_Domestic__c=TRUE,IsJitensha__c=FALSE,IsMochimonoSupport__c=FALSE,IsJitensha_Child__c=FALSE,IsRentalSupport__c=FALSE,IsGolfer__c=TRUE,IsNichijouBaisyou__c=FALSE,IsOutdoor__c=TRUE,IsChintaiAnshin__c=FALSE,IsSports__c=TRUE,IsKajiDaikou__c=FALSE,IsHareyakaSedai__c=FALSE,IsPapaMamma__c=FALSE,IsOkaimonoAnshin__c=FALSE,IsJosei__c=FALSE,IsOther_BerryEasy__c=FALSE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSon5);
        Opportunity oppSon6 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,IsCycleAssist__c=TRUE,IsDriveAssist__c=TRUE,IsGolfAssist__c=TRUE,Is1Day__c=TRUE,IsHomeAssist__c=TRUE,IsOther_Damage__c=TRUE,IsLivingAssist__c=TRUE,IsTravelAssist_Global__c=TRUE,IsTravelAssist_Domestic__c=TRUE,IsJitensha__c=TRUE,IsMochimonoSupport__c=TRUE,IsJitensha_Child__c=TRUE,IsRentalSupport__c=TRUE,IsGolfer__c=TRUE,IsNichijouBaisyou__c=TRUE,IsOutdoor__c=TRUE,IsChintaiAnshin__c=TRUE,IsSports__c=TRUE,IsKajiDaikou__c=TRUE,IsHareyakaSedai__c=TRUE,IsPapaMamma__c=TRUE,IsOkaimonoAnshin__c=TRUE,IsJosei__c=TRUE,IsOther_BerryEasy__c=TRUE,StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSon6);
        insert oppList;
    
        Test.startTest();
        Patch_OL070_SetCampaignDateAndMore batchable = new Patch_OL070_SetCampaignDateAndMore();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> resultList = [Select ProdctName__c,prodtype_multilist__c from Opportunity Where ID in :oppList];
        //商品名
        System.assertEquals('サイクルアシスト（傷害総合保険）\n自転車保険プラン\n自転車保険プラン(子供コース)', resultList[0].ProdctName__c);
        System.assertEquals('ドライブアシスト（自動車保険）', resultList[1].ProdctName__c);
        System.assertEquals('ホームアシスト（家庭総合保険）\nリビングアシスト（リビングアシスト総合保険）\n賃貸あんしんプラン', resultList[2].ProdctName__c);
        System.assertEquals('その他商品_損保\n持ち物サポートプラン\nレンタル品サポートプラン\n日常賠償プラン\n家事代行プラン\n晴れやか世代プラン\nパパママプラン\nお買い物あんしんプラン\n女性プラン\nその他商品_超かんたん保険', resultList[3].ProdctName__c);
        System.assertEquals('ゴルフアシスト（傷害総合保険）\n1日保険シリーズ\nトラベルアシスト（海外旅行保険）\nトラベルアシスト（国内旅行傷害保険）\nゴルファー保険プラン\nアウトドアプラン\nスポーツプラン', resultList[4].ProdctName__c);
        System.assertEquals('サイクルアシスト（傷害総合保険）\nドライブアシスト（自動車保険）\nゴルフアシスト（傷害総合保険）\n1日保険シリーズ\nホームアシスト（家庭総合保険）\nその他商品_損保\nリビングアシスト（リビングアシスト総合保険）\nトラベルアシスト（海外旅行保険）\nトラベルアシスト（国内旅行傷害保険）\n自転車保険プラン\n持ち物サポートプラン\n自転車保険プラン(子供コース)\nレンタル品サポートプラン\nゴルファー保険プラン\n日常賠償プラン\nアウトドアプラン\n賃貸あんしんプラン\nスポーツプラン\n家事代行プラン\n晴れやか世代プラン\nパパママプラン\nお買い物あんしんプラン\n女性プラン\nその他商品_超かんたん保険', resultList[5].ProdctName__c);
                                
        //商品種類
        System.assertEquals('自転車', resultList[0].prodtype_multilist__c);
        System.assertEquals('自動車', resultList[1].prodtype_multilist__c);
        System.assertEquals('住宅', resultList[2].prodtype_multilist__c);
        System.assertEquals('その他', resultList[3].prodtype_multilist__c);
        System.assertEquals('レジャー', resultList[4].prodtype_multilist__c);
        System.assertEquals('住宅;自動車;自転車;レジャー;その他', resultList[5].prodtype_multilist__c);
                                                
    }

    @isTest static void Patch_OL070_UT4_UT5() {
        //create Account
        Account acc = TestHelperOpportunityTriggerHandler.createAccount();
        acc.OperationType__c ='割当可';
        insert acc;
        
        //User
        User userSys = [Select id From User Where name='バッチユーザ'];
        User user0 = [Select id From User Where name!='バッチユーザ' limit 1];

        DateTime cmTime = System.now();
        //create Opportunity
        List<Opportunity> oppList = new List<Opportunity> ();
        Id oppSeihoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        Opportunity oppSyo1 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,ownerId = userSys.id,StageName = '未対応',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo1);
        Opportunity oppSyo2 = new Opportunity(RecordTypeId = oppSeihoRecordTypeId,ownerId = user0.id,CampaignDateTime__c= cmTime,StageName = '未対応',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(oppSyo2);
        insert oppList;
    
        Test.startTest();
        Patch_OL070_SetCampaignDateAndMore batchable = new Patch_OL070_SetCampaignDateAndMore();
        Database.executeBatch(batchable, 100);
        Test.stopTest();

        List<Opportunity> resultList = [Select CampaignDateTime__c,createddate,StageName from Opportunity Where ID in :oppList];
        System.assertEquals(resultList[0].CampaignDateTime__c, resultList[0].createddate);
        System.assertEquals(cmTime, resultList[1].CampaignDateTime__c);
        System.assertEquals('未割当', resultList[0].StageName);
        System.assertEquals('未対応', resultList[1].StageName);

    }

    // @isTest static void Patch_OL070_UT6() {
    //     //create Account
    //     Account acc = TestHelperOpportunityTriggerHandler.createAccount();
    //     acc.OperationType__c ='割当可';
    //     insert acc;
        
    //     //create Opportunity
    //     List<Opportunity> oppList = new List<Opportunity> ();
    //     Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
    //     Id oppSyotanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();
    //     Opportunity Opportunity1 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='Web誘導',RecentResultType_Small__c='申込完了',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity1);
    //     Opportunity Opportunity2 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='Web誘導',RecentResultType_Small__c='申込了承',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity2);
    //     Opportunity Opportunity3 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='Web誘導',RecentResultType_Small__c='検討中',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity3);
    //     Opportunity Opportunity4 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='Web誘導',RecentResultType_Small__c='NG（年齢）',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity4);
    //     Opportunity Opportunity5 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='資料送付',RecentResultType_Small__c='投函済み',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity5);
    //     Opportunity Opportunity6 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='資料送付',RecentResultType_Small__c='NG（既往症）',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity6);
    //     Opportunity Opportunity7 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='資料送付',RecentResultType_Small__c='NG（保険料）',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity7);
    //     Opportunity Opportunity8 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='資料送付',RecentResultType_Small__c='NG（その他）',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity8);
    //     Opportunity Opportunity9 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='即申込（初回コンタクト時）',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity9);
    //     Opportunity Opportunity10 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='対面誘導',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity10);
    //     Opportunity Opportunity11 = new Opportunity(RecordTypeId = oppSonpoRecordTypeId,RecentResultType_Middle__c='問合わせ',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity11);
    //     Opportunity Opportunity12 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='多忙',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity12);
    //     Opportunity Opportunity13 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='本人不在',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity13);
    //     Opportunity Opportunity14 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='留守',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity14);
    //     Opportunity Opportunity15 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='留守電',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity15);
    //     Opportunity Opportunity16 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='電話番号不備',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity16);
    //     Opportunity Opportunity17 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='架電拒否',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity17);
    //     Opportunity Opportunity18 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='アポ禁',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity18);
    //     Opportunity Opportunity19 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='その他',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity19);
    //     Opportunity Opportunity20 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='システム切電',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity20);
    //     Opportunity Opportunity21 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='発信放棄呼',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity21);
    //     Opportunity Opportunity22 = new Opportunity(RecordTypeId = oppSyotanRecordTypeId,RecentResultType_Middle__c='',RecentResultType_Small__c='',StageName = '未割当',AccountId = acc.Id,Name = 'OppName0',CloseDate = Date.today());oppList.add(Opportunity22);
    //     insert oppList;
    
    //     Test.startTest();
    //     Patch_OL070_SetCampaignDateAndMore batchable = new Patch_OL070_SetCampaignDateAndMore();
    //     Database.executeBatch(batchable, 100);
    //     Test.stopTest();

    //     List<Opportunity> resultList = [Select RecentResultType_Middle__c,RecentResultType_Small__c from Opportunity Where ID in :oppList];
    //     //中分類
    //     System.assertEquals('Web誘導', resultList[0].RecentResultType_Middle__c);
    //     System.assertEquals('Web誘導', resultList[1].RecentResultType_Middle__c);
    //     System.assertEquals('Web誘導', resultList[2].RecentResultType_Middle__c);
    //     System.assertEquals('Web誘導', resultList[3].RecentResultType_Middle__c);
    //     System.assertEquals('資料送付', resultList[4].RecentResultType_Middle__c);
    //     System.assertEquals('資料送付', resultList[5].RecentResultType_Middle__c);
    //     System.assertEquals('資料送付', resultList[6].RecentResultType_Middle__c);
    //     System.assertEquals('資料送付', resultList[7].RecentResultType_Middle__c);
    //     System.assertEquals('Web誘導', resultList[8].RecentResultType_Middle__c);
    //     System.assertEquals('対面誘導', resultList[9].RecentResultType_Middle__c);
    //     System.assertEquals('問合せ', resultList[10].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[11].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[12].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[13].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[14].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[15].RecentResultType_Middle__c);
    //     System.assertEquals('不要', resultList[16].RecentResultType_Middle__c);
    //     System.assertEquals('不要', resultList[17].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[18].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[19].RecentResultType_Middle__c);
    //     System.assertEquals('不通', resultList[20].RecentResultType_Middle__c);
    //     System.assertEquals(null, resultList[21].RecentResultType_Middle__c);
    //     //小分類
    //     System.assertEquals('申込完了', resultList[0].RecentResultType_Small__c);
    //     System.assertEquals('了承', resultList[1].RecentResultType_Small__c);
    //     System.assertEquals('継続検討', resultList[2].RecentResultType_Small__c);
    //     System.assertEquals('謝絶', resultList[3].RecentResultType_Small__c);
    //     System.assertEquals('了承', resultList[4].RecentResultType_Small__c);
    //     System.assertEquals('謝絶', resultList[5].RecentResultType_Small__c);
    //     System.assertEquals('謝絶', resultList[6].RecentResultType_Small__c);
    //     System.assertEquals('謝絶', resultList[7].RecentResultType_Small__c);
    //     System.assertEquals('申込完了', resultList[8].RecentResultType_Small__c);
    //     System.assertEquals(null, resultList[9].RecentResultType_Small__c);
    //     System.assertEquals(null, resultList[10].RecentResultType_Small__c);
    //     System.assertEquals('多忙', resultList[11].RecentResultType_Small__c);
    //     System.assertEquals('本人不在', resultList[12].RecentResultType_Small__c);
    //     System.assertEquals('留守', resultList[13].RecentResultType_Small__c);
    //     System.assertEquals('留守電', resultList[14].RecentResultType_Small__c);
    //     System.assertEquals('電話番号不備', resultList[15].RecentResultType_Small__c);
    //     System.assertEquals(null, resultList[16].RecentResultType_Small__c);
    //     System.assertEquals(null, resultList[17].RecentResultType_Small__c);
    //     System.assertEquals(null, resultList[18].RecentResultType_Small__c);
    //     System.assertEquals('システム切電', resultList[19].RecentResultType_Small__c);
    //     System.assertEquals('発信放棄呼', resultList[20].RecentResultType_Small__c);
    //     System.assertEquals(null, resultList[21].RecentResultType_Small__c);
                                                        
    // }

}