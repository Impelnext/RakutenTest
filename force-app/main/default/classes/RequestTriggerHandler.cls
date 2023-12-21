public with sharing class RequestTriggerHandler {
    Map<String, Id> rpMap = new Map<String, Id>();
    //RequestTriggerForAfterInsert ReqTriggerAfterInsert = new RequestTriggerForAfterInsert();
    public RequestTriggerHandler() {
        //レコードタイプオブジェクトを取得
        List<RecordType> rtList = [SELECT Id, Name FROM RecordType WHERE SobjectType='Request__c'];
        
        //RecordTypeのMapを作成
        for(RecordType rec : rtList){
            rpMap.put(rec.Name, rec.Id);
        }
        System.debug('the Recordid is :'+rpMap);
    }
    
    
    /**
     * リクエスト情報作成・更新前処理
     * @param List<Request__c>
     * @return 
     */
    public void onBeforeProcess(List<Request__c> reqList, Map<Id,Request__c> oldMap){
        //レコードタイプを設定
        for(Request__c rec : reqList){
            //対応区分、対応種別が変わる場合のみレコードタイプ設定
            if(   oldMap.get(rec.Id) == Null
               || rec.class__c <> oldMap.get(rec.Id).class__c
               || rec.type__c <> oldMap.get(rec.Id).type__c){
                setRecordType(rec);
            }
        }
        //生保代理店、生保募集人、生保エージェントマスタの紐付け
        setMasterRecord(reqList,oldMap);
        setRequestInfo(reqList,oldMap);
    }
    
    
    /**
    * 生保代理店マスタ,生保募集人マスタ,生保エージェントマスタの紐付け処理
    * @param List<Request__c>
    * @param Map<Id,Request__c>
    */
    Public void setMasterRecord(List<Request__c> reqList, Map<Id,Request__c> oldMap){
        
        Set<Id> receptionIdSet = new Set<Id>();
        for(Request__c rec : reqList){
            receptionIdSet.add(rec.Reception__c);
        }
        
        Map<Id,Reception__c> receptionMap = MasterHelper.getReceptionMap(receptionIdSet);
        for (Request__c req : reqList) {
            if (oldMap == NULL || oldMap.isEmpty()) {
                if (req.Reception__c != NULL) {
                    req.SeihoRecruiter__c = receptionMap.get(req.Reception__c).SeihoRecruiter__c != NULL ? receptionMap.get(req.Reception__c).SeihoRecruiter__c : null;
                    req.SeihoAgency__c = receptionMap.get(req.Reception__c).SeihoAgency__c!= NULL ? receptionMap.get(req.Reception__c).SeihoAgency__c: null;
                    req.SeihoAgent__c = receptionMap.get(req.Reception__c).SeihoAgent__c != NULL ? receptionMap.get(req.Reception__c).SeihoAgent__c: null;
                }
            }
            else if (oldMap!= NULL || !oldMap.isEmpty()) {
                if (req.Reception__c != NULL && req.Reception__c != oldmap.get(req.Id).Reception__c) {
                    req.SeihoRecruiter__c = receptionMap.get(req.Reception__c).SeihoRecruiter__c != NULL ? receptionMap.get(req.Reception__c).SeihoRecruiter__c : null;
                    req.SeihoAgency__c = receptionMap.get(req.Reception__c).SeihoAgency__c!= NULL ? receptionMap.get(req.Reception__c).SeihoAgency__c: null;
                    req.SeihoAgent__c = receptionMap.get(req.Reception__c).SeihoAgent__c != NULL ? receptionMap.get(req.Reception__c).SeihoAgent__c: null;
                }
            }
        }
    }
    
    
    public void setRequestInfo(List<Request__c> reqList, Map<Id,Request__c> oldMap){
    
        for(Request__c req : reqList){
            
            // Name項目設定
            if(String.isBlank(req.Name)){
                req.Name = req.Subject__c;
            }
            
            // 問合わせ概要設定（生命）
            if(oldMap.get(req.Id) == null || oldMap.get(req.Id).OverviewOfInquirySeimei__c <> req.OverviewOfInquirySeimei__c ){
                if(String.isNotBlank(req.OverviewOfInquirySeimei__c)){
                    req.OverviewOfInquiry__c = req.OverviewOfInquirySeimei__c;
                }
            }
            
            // 問合わせ概要設定（損保）
            if(oldMap.get(req.Id) == null || oldMap.get(req.Id).OverviewOfInquirySompo__c <> req.OverviewOfInquirySompo__c ){
                if(String.isNotBlank(req.OverviewOfInquirySompo__c)){
                    req.OverviewOfInquiry__c = req.OverviewOfInquirySompo__c;
                }
            }
            
            // 問合わせ概要設定（少短）
            if(oldMap.get(req.Id) == null || oldMap.get(req.Id).InquirySummaryShortTermInsurance__c <> req.InquirySummaryShortTermInsurance__c ){
                if(String.isNotBlank(req.InquirySummaryShortTermInsurance__c)){
                    req.OverviewOfInquiry__c = req.InquirySummaryShortTermInsurance__c;
                }
            }
            
            // 電話受付完了日時設定
            if(req.TelAcceptCompnDate__c == Null){
                req.TelAcceptCompnDate__c = DateTime.now();
            }
        }
    }
    
    
    /**
     * レコードタイプ設定
     * @param Request__c
     * @return 
     */
    public void setRecordType(Request__c req){
    
        //@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@　共通ケース　@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@
        if(req.Class__c == '共通ケース'){
            if(req.Type__c  == '住所変更') req.RecordTypeId = rpMap.get('住所変更');
            else if(req.Type__c  == '改姓（名義変更）') req.RecordTypeId = rpMap.get('改姓（名義変更）');
            else if(req.Type__c  == '電話番号変更') req.RecordTypeId = rpMap.get('電話番号変更');
            else if(req.Type__c  == 'メールアドレス変更') req.RecordTypeId = rpMap.get('メールアドレス変更');
            else if(req.Type__c  == '対応依頼') req.RecordTypeId = rpMap.get('対応依頼');
            else if(req.Type__c  == '情報連携') req.RecordTypeId = rpMap.get('情報連携');
            else if(req.Type__c  == '苦情・要望') req.RecordTypeId = rpMap.get('苦情・要望');
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@　生命専用ケース　@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //
        else if(req.Class__c == '生命専用ケース'){
            if(req.Type__c  == '保険金・給付金・共済金請求') req.RecordTypeId = rpMap.get('保険金・給付金・共済金請求');
            else if(req.Type__c  == '解約') req.RecordTypeId = rpMap.get('解約');
            else if(req.Type__c  == '受取人（生保）') req.RecordTypeId = rpMap.get('受取人（生保）');
            else if(req.Type__c  == '指定代理人変更') req.RecordTypeId = rpMap.get('指定代理人変更');
            //else if(req.Type__c  == '証券再発行') req.RecordTypeId = rpMap.get('証券再発行');
            else if(req.Type__c  == '保険証券・証書再発行') req.RecordTypeId = rpMap.get('保険証券・証書再発行');
            else if(req.Type__c  == '収納（集金）') req.RecordTypeId = rpMap.get('収納（集金）');
            else if(req.Type__c  == '減額') req.RecordTypeId = rpMap.get('減額');
            else if(req.Type__c  == '減口（生保）') req.RecordTypeId = rpMap.get('減口（生保）');
            else if(req.Type__c  == '特約解約')  req.RecordTypeId = rpMap.get('特約解約');
            else if(req.Type__c  == '更新時減額')  req.RecordTypeId = rpMap.get('更新時減額');
            else if(req.Type__c  == '更新時減口（共済）') req.RecordTypeId = rpMap.get('更新時減口（共済）');
            else if(req.Type__c  == '更新拒否') req.RecordTypeId = rpMap.get('更新拒否');
            else if(req.Type__c  == '控除再発行') req.RecordTypeId = rpMap.get('控除再発行');
            else if(req.Type__c  == '海外渡航') req.RecordTypeId = rpMap.get('海外渡航');
            else if(req.Type__c  == 'アルファ付替') req.RecordTypeId = rpMap.get('アルファ付替');
            else if(req.Type__c  == '減口（共済）') req.RecordTypeId = rpMap.get('減口（共済）');
            else if(req.Type__c  == '受取人（共済）')  req.RecordTypeId = rpMap.get('受取人（共済）');
            else if(req.Type__c  == '返金先口座')  req.RecordTypeId = rpMap.get('返金先口座');
            else if(req.Type__c  == 'Retention') req.RecordTypeId = rpMap.get('Retention（生命）');
            else if(req.Type__c  == '特約減額') req.RecordTypeId = rpMap.get('特約減額');
            else if(req.Type__c  == '汎用（生命）')  req.RecordTypeId = rpMap.get('汎用（生命）');
            else if(req.Type__c  == '書類発送ケース')  req.RecordTypeId = rpMap.get('書類発送ケース');
            else if(req.Type__c  == '問合せケース（生命）')  req.RecordTypeId = rpMap.get('問合せケース（生命）');
            else if(req.Type__c  == '契約確認コール')  req.RecordTypeId = rpMap.get('契約確認コール');
            else if(req.Type__c  == '口座変更（無事故給付金）')  req.RecordTypeId = rpMap.get('口座変更（無事故給付金）');
            
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@　損保専用ケース　@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //
        else if(req.Class__c == '損保専用ケース'){
            if(req.Type__c  == '住所・対象所在地同時変更') req.RecordTypeId = rpMap.get('住所・対象所在地同時変更');
            else if(req.Type__c  == '車両入替') req.RecordTypeId = rpMap.get('車両入替');
            else if(req.Type__c  == '保険証券再発行') req.RecordTypeId = rpMap.get('保険証券再発行');
            else if(req.Type__c  == '承認書再発行') req.RecordTypeId = rpMap.get('承認書再発行');
            else if(req.Type__c  == '控除証明書再発行') req.RecordTypeId = rpMap.get('控除証明書再発行');
            else if(req.Type__c  == 'サイクルアシスト証券発行') req.RecordTypeId = rpMap.get('契約証再発行（SA・LA）');
            else if(req.Type__c  == 'リビングアシスト契約証再発行') req.RecordTypeId = rpMap.get('契約証再発行（SA・LA）');
            else if(req.Type__c  == '中断証明発行') req.RecordTypeId = rpMap.get('中断証明発行');
            else if(req.Type__c  == '中断証明再発行') req.RecordTypeId = rpMap.get('中断証明再発行');
            else if(req.Type__c  == '解約（自動車）') req.RecordTypeId = rpMap.get('解約（自動車）');
            else if(req.Type__c  == '解約（火災）') req.RecordTypeId = rpMap.get('解約（火災）');
            else if(req.Type__c  == '解約（傷害）') req.RecordTypeId = rpMap.get('解約（傷害）');
            else if(req.Type__c  == '解約（ジャンプ・積立・その他）') req.RecordTypeId = rpMap.get('解約（ジャンプ・積立・その他）');
            else if(req.Type__c  == '対象所在地変更（火災・満期戻）') req.RecordTypeId = rpMap.get('対象所在地変更（火災・満期戻）');
            else if(req.Type__c  == '用途車種変更（自動車）') req.RecordTypeId = rpMap.get('用途車種変更（自動車）');
            else if(req.Type__c  == '登録番号変更（自動車）') req.RecordTypeId = rpMap.get('登録番号変更（自動車）');
            else if(req.Type__c  == '保険金額変更') req.RecordTypeId = rpMap.get('保険金額変更');
            else if(req.Type__c  == '条件変更（自動車）') req.RecordTypeId = rpMap.get('条件変更（自動車）');
            else if(req.Type__c  == '全損失効') req.RecordTypeId = rpMap.get('全損失効');
            else if(req.Type__c  == '構造用法面積変更') req.RecordTypeId = rpMap.get('構造用法面積変更');
            else if(req.Type__c  == '職業職種（級別）の変更') req.RecordTypeId = rpMap.get('職業職種（級別）の変更');
            else if(req.Type__c  == '権利譲渡（名義変更）') req.RecordTypeId = rpMap.get('権利譲渡（名義変更）');
            else if(req.Type__c  == '名義変更（保険の対象の所有者氏名変更）') req.RecordTypeId = rpMap.get('名義変更（保険の対象の所有者氏名変更）');
            else if(req.Type__c  == '増車') req.RecordTypeId = rpMap.get('増車');
            else if(req.Type__c  == '質権設定・削除') req.RecordTypeId = rpMap.get('質権設定・削除');
            else if(req.Type__c  == '等級訂正') req.RecordTypeId = rpMap.get('等級訂正');
            else if(req.Type__c  == '被保険者変更') req.RecordTypeId = rpMap.get('被保険者変更');
            else if(req.Type__c  == '付保証明書発行') req.RecordTypeId = rpMap.get('付保証明書発行');
            else if(req.Type__c  == '口座変更、クレカ変更') req.RecordTypeId = rpMap.get('口座変更、クレカ変更');
            else if(req.Type__c  == '入金確認') req.RecordTypeId = rpMap.get('入金確認');
            else if(req.Type__c  == '新規契約・継続契約・中途更改') req.RecordTypeId = rpMap.get('新規契約・継続契約・中途更改');
            else if(req.Type__c  == '問合せケース（損保）') req.RecordTypeId = rpMap.get('問合せケース（損保）');
            else if(req.Type__c  == '汎用（損保）') req.RecordTypeId = rpMap.get('汎用（損保）');
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@　少短専用ケース　@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //
        else if(req.Class__c == '少短専用ケース'){
            if(req.Type__c  == '少短事故受付') req.RecordTypeId = rpMap.get('少短事故受付');
            else if(req.Type__c  == '保険金関連（事故受付以外）') req.RecordTypeId = rpMap.get('保険金関連（事故受付以外）');
            else if(req.Type__c  == '少短事故受付（賠責）') req.RecordTypeId = rpMap.get('少短事故受付（賠責）');
            else if(req.Type__c  == '更新変更_少短') req.RecordTypeId = rpMap.get('更新変更');
            else if(req.Type__c  == '更新拒否_少短') req.RecordTypeId = rpMap.get('更新拒否_少短');
            else if(req.Type__c  == '解約_少短') req.RecordTypeId = rpMap.get('解約_少短');
            else if(req.Type__c  == 'Retention（少短）') req.RecordTypeId = rpMap.get('Retention（少短）');
            else if(req.Type__c  == '申込内容変更・新規多頭対応') req.RecordTypeId = rpMap.get('申込内容変更・新規多頭対応');
            else if(req.Type__c  == '契約内容変更') req.RecordTypeId = rpMap.get('契約内容変更');
            else if(req.Type__c  == '証券類・更新案内再送') req.RecordTypeId = rpMap.get('証券類・更新案内再送');
            else if(req.Type__c  == '振込用紙再送') req.RecordTypeId = rpMap.get('振込用紙再送');
            else if(req.Type__c  == '問合せケース（少短）') req.RecordTypeId = rpMap.get('問合せケース（少短）');
            else if(req.Type__c  == '汎用（少短）'){req.RecordTypeId=rpMap.get('汎用（少短）');}
        }
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@　セールス専用ケース　@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        //
        else if(req.Class__c == 'セールス専用ケース'){
            if(req.Type__c  == '生命_コール資料請求') req.RecordTypeId = rpMap.get('生命_コール資料請求');
            //else if(req.Type__c  == '損保_ミドル連携') req.RecordTypeId = rpMap.get('損保_ミドル連携');
            else if(req.Type__c  == '少短_コール資料請求') req.RecordTypeId = rpMap.get('少短_コール資料請求');
            else if(req.Type__c  == '生命・少短_比較チーム連携') req.RecordTypeId = rpMap.get('生命・少短_比較チーム連携');
            else if(req.Type__c  == '生命_対面誘導（生命営推本部）') req.RecordTypeId = rpMap.get('生命_対面誘導（生命営推本部）');
            //else if(req.Type__c  == '信書回収') req.RecordTypeId = rpMap.get('信書回収');
        
        }
        //ONYX対応
        //@@@@@@@@@@@@@@@@@@@@@@@
        //@@@@@　生命代サ専用ケース　@@@@@
        //@@@@@@@@@@@@@@@@@@@@@@@
        else if(req.Class__c == '生命代サ専用ケース'){
            if(req.Type__c  == 'タブレット・Team Viewer') req.RecordTypeId = rpMap.get('タブレット・Team Viewer');
            else if(req.Type__c == '収納（集金）_代サ') req.RecordTypeId = rpMap.get('収納（集金）');
            else if(req.Type__c == '新契約') req.RecordTypeId = rpMap.get('新契約');
            else if(req.Type__c == '声紋認証') req.RecordTypeId = rpMap.get('声紋認証');
            else if(req.Type__c == '問い合わせケース') req.RecordTypeId = rpMap.get('問い合わせケース');
            else if(req.Type__c == '更新') req.RecordTypeId = rpMap.get('更新');
            else if(req.Type__C == 'Agency Support') req.RecordTypeId = rpMap.get('AgencySupport');
            else if(req.Type__C == 'ポイントプログラム・楽天ID連携') req.RecordTypeId = rpMap.get('ポイントプログラム・楽天ID連携');
            else if(req.Type__C == '保全（異動）・照会') req.RecordTypeId = rpMap.get('保全（異動）・照会');
            else if(req.Type__C == '書類発送ケース_代サ') req.RecordTypeId = rpMap.get('書類発送ケース_代サ');
            else if(req.Type__c == 'フォロー対応') 
            {
                if(req.Subject__c == '口座不備')
                    req.RecordTypeId = rpMap.get('フォロー対応（口座不備）');
                else if (req.Subject__c =='継続フォロー' || req.Subject__c =='解約メール')
                    req.RecordTypeId = rpMap.get('フォロー対応（継続フォロー・解約メール）');
                else if (req.Subject__c =='お客様対応依頼')
                    req.RecordTypeId = rpMap.get('フォロー対応（お客様対応依頼）');
            }
        }
    }
    
    public void onAfterProcess(List<Request__c> reqList, Map<Id,Request__c> oldMap){
       system.debug('---------------'+oldMap);
        updateReceptionAddress(reqList, oldMap);
        updateCaseStatus(reqList);
    }
    
    public void updateCaseStatus(List<Request__c> reqList){
        Set<Id> completedReqIds = new Set<Id>();
        for(Request__c req : reqList){
            if (req.Status__c == 'CC完了' || req.Status__c == '誤作成削除') {
                completedReqIds.add(req.Id);
            }
        }
        
        List<String> caseStatusList = new List<String> {'オープン', 'CC対応中'};
        
        if (!completedReqIds.IsEmpty()) {
            List<Case> caseToUpdateList =   [SELECT Id, Status,RequestReference__r.Status__c FROM Case 
                                                 WHERE RequestReference__c IN :completedReqIds 
                                                       AND Status IN :caseStatusList];
            for (Case caseToUpdate : caseToUpdateList) {              
                caseToUpdate.Status = caseToUpdate.RequestReference__r.Status__c;                
            }
            
            UPDATE caseToUpdateList;
        }
    }
   
    public void updateReceptionAddress(List<Request__c> reqList, Map<Id,Request__c> oldMap){
    
    set<String> RecpListIdsInSet = new set<String>();
    list<Reception__c> recpListToUpdate = new list<Reception__c>();
    for(Request__c req : reqList){
        Reception__c reception = new Reception__c();
        
        if(req.Class__c == '共通ケース' && req.Type__c == '住所変更'){
        if(oldMap.get(req.Id) == null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c = req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = (req.ChangedAddress2__c != NULL ? req.ChangedAddress2__c : '') + 
                                    (req.ChangedBuildingName__c != NULL ? req.ChangedBuildingName__c : '');
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        
        if(req.Class__c == '生命専用ケース' && req.Type__c == '保険金・給付金・共済金請求'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.MailingPostalCode__c;
            reception.MailingState__c = req.MailingPrefectures__c;
            reception.MailingCity__c = req.MailingCity__c;
            reception.Address1__c = req.MailingAddress1__c;
            reception.Address2__c = req.MailingAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '控除証明書再発行'){
        if(oldMap.get(req.Id) == Null
        || req.IsReflectDeliveryAddress__c <> oldMap.get(req.Id).IsReflectDeliveryAddress__c){
        if(req.IsReflectDeliveryAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.DeliveryAddress_zipCode__c;
            reception.MailingState__c = req.DeliveryAddress_prefecture__c;
            reception.MailingCity__c = req.DeliveryAddress_city__c;
            reception.Address1__c = req.DeliveryAddress_Address1__c;
            reception.Address2__c = req.DeliveryAddress_buildingName__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '解約（火災）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectCancellationReceptionInfo__c <> oldMap.get(req.Id).ReflectCancellationReceptionInfo__c){
        if(req.ReflectCancellationReceptionInfo__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.MailingPostalCode__c;
            reception.MailingState__c = req.MailingPrefectures__c;
            reception.MailingCity__c = req.MailingCity__c;
            reception.Address1__c = req.MailingAddress1__c;
            reception.Address2__c = req.DestinationBuildingName__c;
            reception.id = req.Reception__c;
           if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '解約（火災）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.Postalcode__c;
            reception.MailingState__c = req.Prefectures__c;
            reception.MailingCity__c = req.City__c;
            reception.Address1__c = req.Address1__c;
            reception.Address2__c = req.BuildingName__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '解約（ジャンプ・積立・その他）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.Postalcode__c;
            reception.MailingState__c = req.Prefectures__c;
            reception.MailingCity__c = req.City__c;
            reception.Address1__c = req.Address1__c;
            reception.Address2__c = req.BuildingName__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '対象所在地変更（火災・満期戻）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c = req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedBuildingName__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '全損失効'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.PostalAddressWhereDocumentsAreSent__c;
            reception.MailingState__c = req.SendingDocumentsToPrefectures__c;
            reception.MailingCity__c = req.CityWhereTheDocumentIsSent__c;
            reception.Address1__c = req.DocumentAddress1__c;
            reception.Address2__c = req.NameOfBuildingToWhichDocumentsAreSent__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '質権設定・削除'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.MailingPostalCode__c;
            reception.MailingState__c = req.MailingPrefectures__c;
            reception.MailingCity__c = req.MailingCity__c;
            reception.Address1__c = req.MailingAddress1__c;
            reception.Address2__c = req.DestinationBuildingName__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '被保険者変更'){ 
        if(oldMap.get(req.Id) == Null
        || req.ReflectTheAddressOfTheInsuredPerson__c <> oldMap.get(req.Id).ReflectTheAddressOfTheInsuredPerson__c){
        if(req.ReflectTheAddressOfTheInsuredPerson__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.AutoInsuredPostalCodeAfterChange__c;
            reception.MailingState__c = req.CarPrefectureOfTheInsuredAfterChange__c;
            reception.MailingCity__c = req.AutoInsuredCityAfterChange__c;
            reception.Address1__c = req.AutoInsuredPersonsAddressAfterChange1__c;
            reception.Address2__c = req.AutoInsuredBuildingNameAfterChange__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '損保専用ケース' && req.Type__c == '被保険者変更'){
        if(oldMap.get(req.Id) == Null
        || req.OtherReflectAdresPersonAfterChange__c <> oldMap.get(req.Id).OtherReflectAdresPersonAfterChange__c){
        if(req.OtherReflectAdresPersonAfterChange__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.OtherPostCodeInsuredPersonAfterChange__c;
            reception.MailingState__c = req.OtherPrefectureOfInsuredAfterChange__c;
            reception.MailingCity__c = req.OtherInsuredCityAfterChange__c;
            reception.Address1__c = req.OtherInsuredPersonAddressAfterChange1__c;
            reception.Address2__c = req.OtherInsuredPersonAddressAfterChange2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '少短事故受付'){ 
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '少短事故受付（賠責）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '保険金関連（事故受付以外）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '更新変更_少短'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
            }
        }
        }
        }
        
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '更新拒否_少短'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '解約_少短'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '振込用紙再送'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
       
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '証券類・更新案内再送'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '申込内容変更・新規多頭対応'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '契約内容変更'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
           if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        
        
        if(req.Class__c == '少短専用ケース' && req.Type__c == '汎用（少短）'){
        if(oldMap.get(req.Id) == Null
        || req.ReflectMailingAddress__c <> oldMap.get(req.Id).ReflectMailingAddress__c){
        if(req.ReflectMailingAddress__c == true){
        if(req.Reception__c != null){
            reception.AdderssInputMethod__c = '手動入力';
            reception.MailingPostalCode__c =req.ChangedPostNumber__c;
            reception.MailingState__c = req.ChangedPrefecture__c;
            reception.MailingCity__c = req.ChangedMunicipality__c;
            reception.Address1__c = req.ChangedAddress1__c;
            reception.Address2__c = req.ChangedAddress2__c;
            reception.id = req.Reception__c;
            if(!RecpListIdsInSet.contains(reception.id)){
            recpListToUpdate.add(reception);
            RecpListIdsInSet.add(reception.id);
            }
        }
        }
        }
        }
        }
        
        if(recpListToUpdate.size()>0){
            update recpListToUpdate;
        }
    
    }
    
    //ロングテキストエリア項目の値をテキスト項目にコピー
    public void setLongTextToText(List<Request__c> reqList){
        //全レコード処理
        for(Request__c req : reqList){
            //対応依頼内容が256文字以上の場合
            if(String.isNotBlank(req.RequestDetails__c) && req.RequestDetails__c.length() > 255){
                //対応依頼内容が256文字以上の場合は256文字以降の文字を切り捨てて255文字までの同項目にセット
                req.RequestDetails255__c = req.RequestDetails__c.substring(0, 255);
            }else{
                //対応依頼内容がNull若しくは255文字以下の場合はそのままセット
                req.RequestDetails255__c = req.RequestDetails__c;
            }
            
            //その他依頼内容詳細が256文字以上の場合
            if(String.isNotBlank(req.DetailsOfOtherRequests__c) && req.DetailsOfOtherRequests__c.length() > 255){
                //その他依頼内容詳細が256文字以上の場合は256文字以降の文字を切り捨てて255文字までの同項目にセット
                req.DetailsOfOtherRequests255__c = req.DetailsOfOtherRequests__c.substring(0, 255);
            }else{
                //その他依頼内容詳細がNull若しくは255文字以下の場合はそのままセット
                req.DetailsOfOtherRequests255__c = req.DetailsOfOtherRequests__c;
            }
            
            //事故内容が256文字以上の場合
            if(String.isNotBlank(req.AccidentContents__c) && req.AccidentContents__c.length() > 255){
                //事故内容が256文字以上の場合は256文字以降の文字を切り捨てて255文字までの同項目にセット
                req.AccidentContents255__c = req.AccidentContents__c.substring(0, 255);
            }else{
                //事故内容がNull若しくは255文字以下の場合はそのままセット
                req.AccidentContents255__c = req.AccidentContents__c;
            }
            
            //特記事項が256文字以上の場合
            if(String.isNotBlank(req.Notices__c) && req.Notices__c.length() > 255){
                //特記事項が256文字以上の場合は256文字以降の文字を切り捨てて255文字までの同項目にセット
                req.Notices255__c = req.Notices__c.substring(0, 255);
            }else{
                //特記事項がNull若しくは255文字以下の場合はそのままセット
                req.Notices255__c = req.Notices__c;
            }
        }
    }
}