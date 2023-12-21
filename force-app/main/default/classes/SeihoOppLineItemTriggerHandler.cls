public class SeihoOppLineItemTriggerHandler {
    private SeihoOpportunity__c dummyOpp;
    //コンストラクタ
    public SeihoOppLineItemTriggerHandler(){
        // 存在しない生保申込を参照する生保申込商品を紐付けるためのダミー生保申込
        String dummyAppliNo = System.Label.dummyAppliNo;
        for( SeihoOpportunity__c opp : [SELECT Id, AppliNo__c
                                        FROM   SeihoOpportunity__c
                                        WHERE  AppliNo__c = :dummyAppliNo] ) {
            dummyOpp = opp;
        }
        // ダミー生保申込が存在しない場合は新規Insert(初回処理)
        if( dummyOpp == null ) {
            dummyOpp = new SeihoOpportunity__c(
                Name = 'Dummy申込', AppliNo__c = dummyAppliNo, 
                AppliReceptionChannel__c = 'WEB', 
                ApplicantNameKana__c = 'ダミー モウシコミ', ApplicantName__c = 'Dummy申込',
                InsuredNameKana__c = 'ダミー モウシコミ', InsuredName__c = 'Dummy申込',
                Gender__c = '男性', ApplicantGender__c = '男性', InsuredGender__c = '男性',
                ContracterBD__c = Date.parse('3999/12/31'), Birthdate__c = Date.parse('3999/12/31'),
                InsuredBD__c = Date.parse('3999/12/31'), ParentalAuthorityBD__c = Date.parse('3999/12/31'),
                MobilePhone__c = '99988887777', Phone__c = '99988887777',
                InsuredCellPhoneNumber__c = '99988887777', InsuredPhoneNumber__c = '99988887777'
            );
            insert dummyOpp;
        }
    }
    
    //生保申込との紐付け
    public void setParentRecord(List<SeihoOpportunityLineItem__c> newList, Map<Id,SeihoOpportunityLineItem__c> oldMap){
        //取得対象となる生保申込IDのSetと処理対象のListを作成
        Set<String> parentIdSet = new Set<String>();
        Set<String> webMiniSubscSet = new Set<String>();

        List<SeihoOpportunityLineItem__c> targetList = new List<SeihoOpportunityLineItem__c>();
        Map<String, String> miniSyncSubscMap = new Map<String, String>();
        
        for(SeihoOpportunityLineItem__c line : newList){
            if(oldMap.size() == 0){
                if(line.OpportunityId__c <> Null){
                    parentIdSet.add(line.OpportunityId__c);
                }
                targetList.add(line);
            }/*else{
                //申込IDが変更になった場合のみSetとListに詰める
                if(   line.OpportunityId__c <> Null
                   && line.OpportunityId__c <> oldMap.get(line.Id).OpportunityId__c){
                    parentIdSet.add(line.OpportunityId__c);
                    targetList.add(line);
                }
            }*/
            if (line.MiniSyncSubsc__c == '有' || line.MiniSyncSubsc__c == '‐')  {
                if ( !miniSyncSubscMap.containsKey(line.OpportunityIdReference__c) 
                || miniSyncSubscMap.get(line.OpportunityIdReference__c) != '有' ) {
                    // 親レコードが存在しない場合(紙申込Insert) -> OpportunityId__cをキーとする
                    if (line.OpportunityIdReference__c == Null) {
                        parentIdSet.add(line.OpportunityId__c);
                        miniSyncSubscMap.put(line.OpportunityId__c, line.MiniSyncSubsc__c);
                    // 親レコードが存在する場合(Web申込 or 紙申込update) -> OpportunityIdReference__cをキーとする
                    } else {
                        webMiniSubscSet.add(line.OpportunityIdReference__c);
                        miniSyncSubscMap.put(line.OpportunityIdReference__c, line.MiniSyncSubsc__c);
                    }
                    targetList.add(line);
                }
            }
        }
        
        //処理対象レコードが存在する場合のみ処理実行
        if(targetList.size() > 0){
            //親レコードを取得
            List<SeihoOpportunity__c> parentRecordList = [Select AppliNo__c, Id, AppliReceptionChannel__c, MiniSyncSubsc__c From SeihoOpportunity__c Where AppliNo__c = :parentIdSet OR Id = :webMiniSubscSet];
            //親判定用Mapを作成
            Map<String, Id> parentRecMap = new Map<String, Id>();
            // ミニ同時申込フラグ用リスト
            List<SeihoOpportunity__c> miniSyncSubscList = new List<SeihoOpportunity__c>();

            for(SeihoOpportunity__c rec : parentRecordList){
                if(   rec.AppliReceptionChannel__c != 'WEB' && UserInfo.getUserId() == System.Label.BATCH_USER_ID
                   || rec.AppliReceptionChannel__c == 'WEB' && UserInfo.getUserId() != System.Label.BATCH_USER_ID) {
                    parentRecMap.put(rec.AppliNo__c, rec.Id);
                }
                if( rec.MiniSyncSubsc__c != '有' ) {
                    if (miniSyncSubscMap.containsKey(rec.AppliNo__c)) {
                        miniSyncSubscList.add(rec);
                        rec.MiniSyncSubsc__c = miniSyncSubscMap.get(rec.AppliNo__c);
                    } else if (miniSyncSubscMap.containsKey(rec.Id )) {
                        miniSyncSubscList.add(rec);
                        rec.MiniSyncSubsc__c = miniSyncSubscMap.get(rec.Id);
                    }
                }
            }
            update miniSyncSubscList;
            
            //処理対象レコードに対して申込IDとの参照関係を作成
            for(SeihoOpportunityLineItem__c target : targetList){
                if( target.OpportunityIdReference__c == null ) {
                    if( parentRecMap.containsKey(target.OpportunityId__c) ) {
                        target.OpportunityIdReference__c = parentRecMap.get(target.OpportunityId__c);
                    } else {
                        target.OpportunityIdReference__c = dummyOpp.Id;
                    }
                }
            }
        }
    }

    /**
     * 保険種類に基づいて、商品名/特約名をセットする。
     * @param List<SeihoOpportunityLineItem__c>
     * @param Map<Id,SeihoOpportunityLineItem__c>
     */
    public void setLineItemProductName(List<SeihoOpportunityLineItem__c> oppLineItemList, Map<Id,SeihoOpportunityLineItem__c> oppLineItemNewMap,Map<Id,SeihoOpportunityLineItem__c> oppLineItemOldMap){

        //親となる生保申込のIDをSetに格納する
        Set<String> seihoOppIdSet = new Set<String>();
        for(SeihoOpportunityLineItem__c lineItem : oppLineItemList){
            seihoOppIdSet.add(lineItem.OpportunityIdReference__c);
        }
        
        //親（生保申込）のレコードタイプを取得する
        Map<Id,SeihoOpportunity__c> seihoOppMap = new Map<Id,SeihoOpportunity__c>([SELECT ID, RecordType.Name FROM SeihoOpportunity__c 
                                                                                   WHERE ID IN: seihoOppIdSet and RecordType.Name = '紙申込']);
        
        //保険種類コードを使用してName項目に保険種類名を設定する。
        Map<String,String> insuranceTypeName = getInsuranceTypeName();
        for(SeihoOpportunityLineItem__c lineItem : oppLineItemList){
            if(seihoOppMap.get(lineItem.OpportunityIdReference__c) != null){
                lineItem.Name = insuranceTypeName.get(lineItem.InsuranceType__c) != null ? insuranceTypeName.get(lineItem.InsuranceType__c) : lineItem.InsuranceType__c;
            }
        }                                                                           
    }

    /**
     * 保険種類コードに対する保険種類名を取得する
     * @return Map<String,String>
     */
    public Map<String,String> getInsuranceTypeName(){

        Map<String,String> insuranceTypeName = new Map<String,String>{
            '01'=>'ガン保障付生命共済',
            '02'=>'終身・定期総合医療共済',
            '03'=>'10年定期生命共済',
            '04'=>'重度障害共済',
            '05'=>'災害保障共済',
            '06'=>'定期保険',
            '07'=>'重度障害保険',
            '08'=>'医療保険',
            '09'=>'ガン保険',
            '10'=>'生活習慣病保険',
            '11'=>'災害保障保険',
            '12'=>'女性疾病保険',
            '13'=>'入院支援保険',
            '14'=>'終身医療保険６０',
            '15'=>'６０日超保障型入院保険',
            '16'=>'長期逓減定期保険',
            '17'=>'インターネット申込専用定期保険',
            '18'=>'終身医療保険２０１４',
            '19'=>'限定告知型医療保険',
            '20'=>'総合保障保険',
            '21'=>'限定告知型定期保険',
            '22'=>'１年定期保険',
            '23'=>'終身医療保険２０１８',
            '24'=>'限定告知型医療保険２０１８',
            '25'=>'終身がん治療保険',
            '26'=>'医療保険１０９５',
            '27'=>'終身保険',
            '28'=>'認知症保険',
            '29'=>'健康還付型医療保険',
            'R1'=>'終身・定期総合医療共済ジュニア特約',
            'R2'=>'10年定期生命共済ジュニア特約',
            'R3'=>'介護保障付特定疾病医療特約'
        };

        return insuranceTypeName;
    }

    //生保申込に紐づいてない生保申込特約レコードを削除する
    public void deleteSeihoOppLineItem(List<SeihoOpportunityLineItem__c> seihoOppLineItemList){

/*        List<SeihoOpportunityLineItem__c> seihoOppLineItemDeleteList = new List<SeihoOpportunityLineItem__c>();
        for(SeihoOpportunityLineItem__c seiho : [Select Id, OpportunityIdReference__c from SeihoOpportunityLineItem__c where Id IN: seihoOppLineItemList]){
            if(seiho.OpportunityIdReference__c == dummyOpp.Id){
                seihoOppLineItemDeleteList.add(seiho);
            }
        }*/
        List<SeihoOpportunityLineItem__c> seihoOppLineItemDeleteList = [SELECT Id, OpportunityIdReference__c 
                                                                        FROM   SeihoOpportunityLineItem__c 
                                                                        WHERE  OpportunityIdReference__c = :dummyOpp.Id];
        if( seihoOppLineItemDeleteList != null && seihoOppLineItemDeleteList.size() > 0 ) {
            delete seihoOppLineItemDeleteList;
        }
    }
    
    
    // Web申込保険料設定判定
    // 作成後処理 OR 更新後処理 OR 削除後処理
    //・生保申込商品がInsertされたときは、
    // 紐づき先の生保申込みに紐づく申込商品を全て検索して、Web申込保険料を再計算する
    //・生保申込商品がUpdateされたときは、
    // 「生保申込商品．保険料/特約保険料が変わった場合のみ」紐づき先の生保申込みに紐づく申込商品を全て検索して、Web申込保険料を再計算する
    //・生保申込商品がDeleteされたときは、
    // 紐づき先の生保申込みに紐づく申込商品を全て検索して、Web申込保険料を再計算する。（削除された申込商品以外のレコードで再計算したいです）
    public void updateWebSeihoOpportunities(List<SeihoOpportunityLineItem__c> seihoOppLineItemList, Map<Id, SeihoOpportunityLineItem__c> oldMap){
        
        // 生保申込商品に関連する生保申込みIDセット
        Set<String> seihoOppIdSet = new Set<String>();
        for(SeihoOpportunityLineItem__c seihoOppItem : seihoOppLineItemList){
            // 作成後処理か
            // 更新後処理で保険料／特約保険料が更新か
            // 削除後処理か？
            if(oldMap == NULL
            || oldMap.get(seihoOppItem.Id).UnitPrice__c != seihoOppItem.UnitPrice__c) {
                if (String.IsNotBlank(seihoOppItem.OpportunityIdReference__c)) {
                    seihoOppIdSet.add(seihoOppItem.OpportunityIdReference__c);
                }
            }
        }
        
        // 関連先の生保申込みを取得
        Map<Id, SeihoOpportunity__c> seihoOppMap = new Map<Id, SeihoOpportunity__c>( 
                                                            [
                                                                SELECT Id
                                                                     , RecordTypeId
                                                                     , WebApplicationInsuFee__c
                                                                  FROM SeihoOpportunity__c
                                                                 WHERE Id IN :seihoOppIdSet
                                                                   AND RecordType.Name = 'Web申込'
                                                            ]);
        // 関連先の生保申込みに紐づく申込商品を全て取得
        Map<Id, List<SeihoOpportunityLineItem__c>> seihoOppItemMap = new Map<Id, List<SeihoOpportunityLineItem__c>>();
        List<SeihoOpportunityLineItem__c> allSeihoOppItemList = [
                                                                    SELECT Id
                                                                         , UnitPrice__c 
                                                                         , OpportunityIdReference__c 
                                                                      FROM SeihoOpportunityLineItem__c 
                                                                     WHERE OpportunityIdReference__c IN :seihoOppMap.keyset()
                                                                ];
        for(SeihoOpportunityLineItem__c seihoOppItem : allSeihoOppItemList){
            if (String.IsNotBlank(seihoOppItem.OpportunityIdReference__c)) {
                if (seihoOppItemMap.get(seihoOppItem.OpportunityIdReference__c) != NULL) {
                    seihoOppItemMap.get(seihoOppItem.OpportunityIdReference__c).add(seihoOppItem);
                }
                else {
                    List<SeihoOpportunityLineItem__c> lst = new List<SeihoOpportunityLineItem__c>();
                    lst.add(seihoOppItem);
                    seihoOppItemMap.put(seihoOppItem.OpportunityIdReference__c, lst);
                }
            }
        }
        
        // 関連先の生保申込みのWeb申込保険料を再計算して設定する
        for(Id seihoOppId : seihoOppMap.keyset()){
            SeihoOpportunity__c seihoOpp = seihoOppMap.get(seihoOppId);
            if (seihoOppItemMap.get(seihoOpp.Id) != NULL) {
                // Web申込保険料を再計算する
                List<SeihoOpportunityLineItem__c> seihoOppItemList = seihoOppItemMap.get(seihoOpp.Id);
                Decimal webApplicationInsuFee = 0;
                for (SeihoOpportunityLineItem__c seihoOppItem : seihoOppItemList) {
                    if(seihoOppItem.UnitPrice__c <> Null) webApplicationInsuFee += seihoOppItem.UnitPrice__c;
                }
                seihoOpp.WebApplicationInsuFee__c = String.valueOf(webApplicationInsuFee.round(System.RoundingMode.HALF_UP));
            }
        }
        
        // 取得した生保申込みレコードについて、更新後の値をセットする。
        if (seihoOppMap != NULL && seihoOppMap.size() > 0)
            update seihoOppMap.values();
    }
}