/*
* @Class Name      : LittleContractTriggerHandler 
* @Description     : 少短契約情報トリガーハンドラ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2019.12.26
* @Modified By     : Valsala Kumar
*/
public class LittleContractTriggerHandler {

    /**
     * コンストラクタ
     */
    public LittleContractTriggerHandler() {}
    
    
    /**
     * 少短契約情報作成前処理
     * @param List<LittleContract__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<LittleContract__c> littleContractList){
        
        //少短契約情報に関連する取引先IDセット
        Set<String> syotanAccountIdSet = new Set<String>();
        //少短契約情報に関連する契約管理番号親番セット
        Set<String> syotanSubscriberNoSet = new Set<String>();
        //少短契約親番存在Map
        Map<String, String> existParentNoMap = new Map<String, String>();
        for(LittleContract__c syotan : littleContractList){
            // 取引先IDセット
            if (String.IsNotBlank(syotan.AccountId__c)) {
                syotanAccountIdSet.add(syotan.AccountId__c);
            }
            // 契約管理番号親番セット
            if (String.IsNotBlank(syotan.SubscriberManageNoMaster__c)) {
                syotanSubscriberNoSet.add(syotan.SubscriberManageNoMaster__c);
            }
        }
        
        // 既存の取引先を取得(取引先IDベース)
        Map<String,Account> existRefAccountMap = new Map<String,Account>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account WHERE Id IN :syotanAccountIdSet]){
            existRefAccountMap.put(acc.Id, acc);
        }
        
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> accountOpportunityMap = new Map<Id,Opportunity>();
        
        // 親番が同じ少短契約情報を取得
        // 最古契約情報の関連先商談を取得
        Map<String,Id> oldSyotanOppMap = new Map<String,Id>();
        for(LittleContract__c oldSyotan :   [
                                                SELECT Id,Opportunity__c, SubscriberManageNoMaster__c 
                                                  FROM LittleContract__c 
                                                 WHERE SubscriberManageNoMaster__c IN :syotanSubscriberNoSet
                                              ORDER BY CreatedDate ASC
                                            ]){
            if (oldSyotanOppMap.get(oldSyotan.SubscriberManageNoMaster__c) == NULL) {
                oldSyotanOppMap.put(oldSyotan.SubscriberManageNoMaster__c, oldSyotan.Opportunity__c);
            }
            //既にANP加算済みの契約が存在する場合はMapにつめる
            existParentNoMap.put(oldSyotan.SubscriberManageNoMaster__c, oldSyotan.SubscriberManageNoMaster__c);
        }
        // 最古契約情報の関連先商談を取得
        Map<String,Account> oldOppMap = new Map<String,Account>();
        for(Opportunity opp : [
                                SELECT Id, Name, AccountId 
                                  FROM Opportunity 
                                 WHERE Id IN :oldSyotanOppMap.values()]){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 新規商談Insert用リスト
        List<Opportunity> insertOpportunityList = new List<Opportunity>();
        // 既存少短商談を取得
        List<Opportunity> existSyotanOpportunityList = [ 
                                                            SELECT Id, Name, AccountId 
                                                              FROM Opportunity
                                                             WHERE AccountId IN :syotanAccountIdSet
                                                               AND RecordType.DeveloperName = 'Syotan'
                                                          ORDER BY LastModifiedDate DESC
                                                      ];
        // 取引先、少短商談関連用マップに入れる
        // 最新少短商談を取得
        for(Opportunity opp : existSyotanOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // オープン中の汎用商談を取得
        // 既存汎用商談を取得
        List<Opportunity> existHanyoOpportunityList = [ 
                                                            SELECT Id, Name, AccountId 
                                                              FROM Opportunity
                                                             WHERE AccountId IN :syotanAccountIdSet
                                                               AND RecordType.DeveloperName = 'Hanyo'
                                                               AND StageName <> '対応終了'
                                                          ORDER BY LastModifiedDate DESC
                                                      ];
        // 取引先、汎用商談関連用マップに入れる
        // 最新汎用商談を取得
        for(Opportunity opp : existHanyoOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 商談
        // 商談の少短レコードタイプIDを取得
        Id oppsyotanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '少短' + '_';
        
        // 商談を新規作成
        for(LittleContract__c syotan : littleContractList){
            //取引先に紐づく少短契約、かつ、
            //処理対象の取引先に商談が存在しない、かつ、
            //同一親番の契約が存在しない場合に商談を作成する。
            if (   String.IsNotBlank(syotan.AccountId__c)
                && accountOpportunityMap.get(syotan.AccountId__c) == NULL
                && existParentNoMap.get(syotan.SubscriberManageNoMaster__c) == Null){
                
                //取引先を取得
                Account acc = existRefAccountMap.get(syotan.AccountId__c);
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppsyotanRecordTypeId;
                // 商談名
                String targetOppname = opportunityNameInsertStr;
                if(String.isNotBlank(acc.furiganaLast__pc)){
                    targetOppname  = targetOppname + acc.furiganaLast__pc;
                }
                if(String.isNotBlank(acc.furiganaForst__pc)){
                    targetOppname  = targetOppname + acc.furiganaForst__pc;
                }
                if(targetOppname.length()>80){
                    targetOpp.name = targetOppname.left(80);
                }else{
                    targetOpp.name = targetOppname;
                }
                // 商談ステータス
                targetOpp.StageName = '対応終了';
                // 入電理由
                targetOpp.telReason__c = 'その他';
                // 申込日
                targetOpp.CloseDate = insertCloseDate;
                // 取引先Id
                targetOpp.AccountId = syotan.AccountId__c;
                // リードソース
                targetOpp.InflowRoute__c = '';
                // クローズ種別
                targetOpp.CloseType__c = '申込';
                // 最新見込確度
                targetOpp.RecentProbability__c = '申込済み';
                // 最終見込確度
                targetOpp.LastProbability__c = '申込済み';
                // キャンペーン日時 = 少短契約情報．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
            //ANP加算対象フラグの設定
            if(existParentNoMap.get(syotan.SubscriberManageNoMaster__c) == Null){
                syotan.AnpAddFlag__c = TRUE;
            }else{
                syotan.AnpAddFlag__c = FALSE;
            }
            //商談作成対象から除外
            existParentNoMap.put(syotan.SubscriberManageNoMaster__c, syotan.SubscriberManageNoMaster__c);
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 少短契約情報．商談設定
        for(LittleContract__c syotan : littleContractList){
            if (String.IsNotBlank(syotan.AccountId__c)) {
                if(accountOpportunityMap.get(syotan.AccountId__c) <> Null){
                    syotan.Opportunity__c = accountOpportunityMap.get(syotan.AccountId__c).Id;
                }
            }
        }
    }
    
    
    /**
     * 少短契約情報更新前処理
     * @param List<LittleContract__c>
     * @param Map<Id, LittleContract__c>
     * @return 
     */
    public void onBeforeUpdateProcess(List<LittleContract__c> littleContractList, Map<Id, LittleContract__c> oldMap){
        for(LittleContract__c littleContract : littleContractList){
            // 取引先変更判定
            if (littleContract.AccountId__c <> oldMap.get(littleContract.Id).AccountId__c && 
                littleContract.Opportunity__c == oldMap.get(littleContract.Id).Opportunity__c){
                // 商談との関連解消
                // 商談参照項目クリア
                littleContract.Opportunity__c = NULL;
            }
        }
    }
    
    
    /**
     * 少短契約情報作成後／更新後処理
     * @param List<LittleContract__c>
     * @param Map<Id, LittleContract__c>
     * @return 
     */
    public void onAfterProcess(List<LittleContract__c> littleContractList, Map<Id, LittleContract__c> oldMap){
        //******20191226 修正　開始*******/
        // Phase3対応
        
        //少短契約情報に関連する商談IDセット
        Set<String> syotanOppIdSet = new Set<String>();
        //少短契約情報に関連する取引先IDセット
        Set<String> syotanAccountIdSet = new Set<String>();
        
        for(LittleContract__c syotan : littleContractList){
            if (String.IsNotBlank(syotan.Opportunity__c)) {
                syotanOppIdSet.add(syotan.Opportunity__c);
                if (String.IsNotBlank(syotan.AccountId__c)) {
                    syotanAccountIdSet.add(syotan.AccountId__c);
                }
            }
        }
        
        // 商談
        // 更新商談Update用Map
        Map<Id, Opportunity> updateOpportunityMap = new Map<Id, Opportunity>();
        
        // 少短契約情報、商談関連用マップ ID:商談ID
        // 関連先商談取得
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>(
                                                                [ 
                                                                    SELECT Id, RecordTypeId, StageName, 
                                                                           ANP__c, EstimatedANP__c, 
                                                                           CloseDate, CloseType__c, 
                                                                           RecentProbability__c, 
                                                                           LastProbability__c 
                                                                      FROM Opportunity
                                                                     WHERE Id IN :syotanOppIdSet
                                                                ]
                                                            );
        
        // 取引先に紐づく他商談を取得
        List<Opportunity> accOtherOppList = [ 
                                                SELECT Id, StageName, 
                                                       CloseDate, CloseType__c, 
                                                       CloseReason__c, RecentProbability__c, 
                                                       AccountId, LastProbability__c 
                                                  FROM Opportunity
                                                 WHERE AccountId = :syotanAccountIdSet 
                                                   AND Id <> :syotanOppIdSet
                                                   AND StageName <> '対応終了'
                                                   AND (RecordType.DeveloperName = 'Syotan' OR RecordType.DeveloperName = 'Hanyo')
                                            ];
        Map<Id, List<Opportunity>> accountOtherOppMap = new Map<Id, List<Opportunity>>();
        for(Opportunity targetOpp : accOtherOppList){
            if(accountOtherOppMap.get(targetOpp.AccountId) == NULL){
                List<Opportunity> accOppList = new List<Opportunity>();
                accOppList.add(targetOpp);
                accountOtherOppMap.put(targetOpp.AccountId,accOppList);
            }else{
                accountOtherOppMap.get(targetOpp.AccountId).add(targetOpp);
            }
        }
        
        for(LittleContract__c syotan : littleContractList){
            if(syotan.AnpAddFlag__c == TRUE){
                //契約のANP加算対象フラグがTRUEの場合のみANP更新や他商談の値設定を行う
                if (syotan.Opportunity__c != NULL && 
                    oppMap.get(syotan.Opportunity__c) != NULL && 
                    syotan.AnpAddFlag__c &&
                    (oldMap == NULL || 
                     oldMap.get(syotan.Id).Opportunity__c != syotan.Opportunity__c)) {
                    
                    Opportunity targetOpp = oppMap.get(syotan.Opportunity__c);
                    
                    // 関連先商談の項目設定（ANP更新）+ 
                    // 関連先商談の項目設定（ANP初回設定）
                    updateClosedOpportunity(targetOpp, syotan);
                    
                    // 取引先に紐づく他商談処理
                    if(accountOtherOppMap.get(syotan.AccountId__c) != NULL){
                        
                        List<Opportunity> accOppList = accountOtherOppMap.get(syotan.AccountId__c);
                        // 商談クローズ処理
                        // 取引先に紐づく他商談を値設定
                        updateOtherClosedOpportunity(accOppList, syotan);
                        
                        // Update用Mapに追加
                        for(Opportunity rec : accOppList){
                            if(updateOpportunityMap.get(rec.id) == Null){
                                updateOpportunityMap.put(rec.Id, rec);
                            }
                        }
                    }
                    
                    // Update用Mapに追加
                    if(updateOpportunityMap.get(targetOpp.id) == Null){
                        updateOpportunityMap.put(targetOpp.Id, targetOpp);
                    }
                }
            }
        }
        
        
        //商談を更新
        if(updateOpportunityMap != null && updateOpportunityMap.size() > 0)
            update updateOpportunityMap.values();
        
        
        // 少短申込フラグ更新処理
        // 取引先取得
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        for(LittleContract__c littleContract : littleContractList){
            if (littleContract.AccountId__c != NULL && 
                (oldMap == NULL ||
                 littleContract.AccountId__c <> oldMap.get(littleContract.Id).AccountId__c)){
                accIdSet.add(littleContract.AccountId__c);
            }
        }
        // 関連先取引先取得
        if(accIdSet.size() > 0){
            List<Account> updateAccountList = [ 
                                                SELECT Id, SsOppApplyflg__c, LittleUse__pc
                                                  FROM Account
                                                 WHERE Id = :accIdSet 
                                              ];
            // 取得した取引先レコードについて、少短申込フラグをTrueにする
            for(Account acc : updateAccountList){
                // 少短申込フラグ
                acc.SsOppApplyflg__c = TRUE;
                acc.LittleUse__pc = TRUE;
            }
            // 取引先の少短申込済みフラグ項目を更新
            if(updateAccountList != null && updateAccountList.size() > 0)
                update updateAccountList;
        }
        //******20191226 修正　エンド*******/
    }
    
    
    private void updateClosedOpportunity(Opportunity targetOpp, LittleContract__c syotan) {
        // 関連先商談の項目設定（ANP更新）+ 
        // 関連先商談の項目設定（ANP初回設定）
        
        // 商談の少短レコードタイプIDを取得
        Id oppSyotanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Syotan').getRecordTypeId();
        // 関連先商談更新_申込完了
        // 商談の設定
        targetOpp.RecordTypeId = oppSyotanRecordTypeId;
        // 商談ステータス
        targetOpp.StageName = '対応終了';
        // 完了予定日
        targetOpp.CloseDate = Date.newinstance(
                                        syotan.LastModifiedDate.year(), 
                                        syotan.LastModifiedDate.month(), 
                                        syotan.LastModifiedDate.day());
        // ANP + 見込ANP
        //RIPCRM-218 20200421 修正　開始
        /*if (String.isNotBlank(syotan.InsurancePremium__c) && 
            syotan.InsurancePremium__c.isNumeric()) {*/
        if (syotan.KEIYAKUJI_PRM_TOTAL__c != null) {
            if (targetOpp.ANP__c != NULL) {
                // 関連先商談の項目設定（ANP更新）
                // ANPの値 = 既存のANPの値 + 少短契約情報.契約時保険料
                targetOpp.ANP__c = targetOpp.ANP__c + Integer.valueOf(syotan.KEIYAKUJI_PRM_TOTAL__C);
            }
            else {
                // 関連先商談の項目設定（ANP初回設定）
                // ANPの値 = 少短契約情報.契約時保険料
                targetOpp.ANP__c = Integer.valueOf(syotan.KEIYAKUJI_PRM_TOTAL__C);
            }
            //RIPCRM-218 20200421 修正　終了
            // 見込ANP
            targetOpp.EstimatedANP__c = targetOpp.ANP__c;
        }
        // クローズ種別が申込以外の場合、クローズ理由をクリア
        if(targetOpp.CloseType__c <> '申込'){
            targetOpp.CloseReason__c = '';
        }
        // クローズ種別
        targetOpp.CloseType__c = '申込';
        // 最新見込確度
        targetOpp.RecentProbability__c = '申込済み';
        // 最終見込確度
        // （更新前）商談．最終見込確度=''の場合
        if (String.IsBlank(targetOpp.LastProbability__c)) {
            targetOpp.LastProbability__c = '申込済み';
        }
    }
    
    
    private void updateOtherClosedOpportunity(List<Opportunity> accOtherOppList, LittleContract__c syotan) {
        for(Opportunity targetOpp : accOtherOppList){
            // 商談ステータス
            targetOpp.StageName = '対応終了';
            // 完了予定日
            targetOpp.CloseDate = Date.newinstance(
                                        syotan.LastModifiedDate.year(), 
                                        syotan.LastModifiedDate.month(), 
                                        syotan.LastModifiedDate.day());
            // クローズ種別
            targetOpp.CloseType__c = '対応打ち切り';
            // クローズ理由
            targetOpp.CloseReason__c = '他商談にて対応';
            // 最新見込確度
            targetOpp.RecentProbability__c = '申込なし';
            // 最終見込確度
            // （更新前）商談．最終見込確度=''の場合
            if (String.IsBlank(targetOpp.LastProbability__c)) {
                targetOpp.LastProbability__c = '申込なし';
            }
        }
    }
    
    
    /**
     * 少短契約情報作成・更新前処理
     * @param List<LittleContract__c>
     * @return 
     */
    /*
    public void onBeforeProcess(List<LittleContract__c> littleContractList, Map<Id, LittleContract__c> oldMap){
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        for(LittleContract__c littleContract : littleContractList){
            if(   oldMap == Null || oldMap.size() == 0
               || littleContract.AccountId__c <> oldMap.get(littleContract.Id).AccountId__c){
                accIdSet.add(littleContract.AccountId__c);
            }
        }
        // 少短利用がFALSEの取引先が更新対象であるため、取得する
        if(accIdSet.size() > 0){
            List<Account> updateTargetAccountList = [SELECT Id,LittleUse__pc FROM Account WHERE Id IN :accIdSet AND LittleUse__pc = FALSE];
            for(Account acc : updateTargetAccountList){
                acc.LittleUse__pc = TRUE;
            }
            // 取引先の少短利用項目を更新
            update updateTargetAccountList;
        }
    }
    */

    /**
     * 少短契約情報作成・更新前処理
     * @param List<LittleContract__c>
     * @return 
     */
    /*
    public void onAfterProcess(List<LittleContract__c> littleContractList){
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        //商談の更新リスト
        List<Opportunity> updateOpportunityList = new List<Opportunity>();

        for(LittleContract__c littleContract : littleContractList){
            accIdSet.add(littleContract.AccountId__c);
        }
        List<Account> accountList = [Select Id, (Select Id, StageName from Opportunities where RecordType.Name = '少短') from Account where Id IN: accIdSet];
        for(Account acc : accountList){
            for(Opportunity opp : acc.Opportunities){
                opp.StageName = '対応終了';
                updateOpportunityList.add(opp);
            }
        }

        //商談の商談ステータスを更新する
        if(updateOpportunityList != null && updateOpportunityList.size() > 0)
            update updateOpportunityList;
    }
    */

    /**
     * 少短契約情報作成・更新後処理
     * @param List<LittleContract__c>
     * @param Map<Id,LittleContract__c>
     * @return 
     */
    /** 契約者変更時の契約分割機能に伴い変更フラグON処理を撤廃 **/
/*    public void onAfterUpdateProcess(List<LittleContract__c> littleContractList, Map<Id,LittleContract__c> oldMap){
        //取引先更新の判断フラグ
        boolean updateFlag = false;
        //取引先を格納するセット
        Set<Id> accountIdSet = new Set<Id>();
        for(LittleContract__c littleContract : littleContractList){
            accountIdSet.add(littleContract.AccountId__c);
        }
        //更新用List
        Map<Id, Account> updateAccountMap = new Map<Id, Account>();

        //少短契約に紐づいている取引先の情報マップ
        Map<Id,Account> accountMap = new Map<Id,Account>();
        for(Account acc : [Select Id, furigana__c, Gender__pc, PersonBirthdate, nameChangedFlag__c, genderChangedFlag__c, birthdateChangedFlag__c from Account where Id IN: accountIdSet]){
            accountMap.put(acc.Id, acc);
        }

        for(LittleContract__c littleContract : littleContractList){
            if(littleContract.SubscriberNameKana__c != oldMap.get(littleContract.Id).SubscriberNameKana__c){
                if(accountMap.get(littleContract.AccountId__c).furigana__c != littleContract.SubscriberNameKana__c){
                    updateFlag = true;
                    accountMap.get(littleContract.AccountId__c).nameChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(littleContract.AccountId__c).Id, accountMap.get(littleContract.AccountId__c));
                }
            }
            if(littleContract.SubscriberSex__c != oldMap.get(littleContract.Id).SubscriberSex__c){
                if(accountMap.get(littleContract.AccountId__c).Gender__pc != littleContract.SubscriberSex__c){
                    updateFlag = true;
                    accountMap.get(littleContract.AccountId__c).genderChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(littleContract.AccountId__c).Id, accountMap.get(littleContract.AccountId__c));
                }
            }
            if(littleContract.SubscriberBirthdate__c != oldMap.get(littleContract.Id).SubscriberBirthdate__c){
                Date subscriberBDate = Date.parse(littleContract.SubscriberBirthdate__c);
                if(accountMap.get(littleContract.AccountId__c).PersonBirthdate != subscriberBDate){
                    updateFlag = true;
                    accountMap.get(littleContract.AccountId__c).birthdateChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(littleContract.AccountId__c).Id, accountMap.get(littleContract.AccountId__c));
                }
            }
        }

        if(updateAccountMap.size() > 0){
            update updateAccountMap.values();
        }
        
    }*/

    /**
    * 少短契約情報作成前、更新前処理
    * @param List<LittleContract__c>
    * @return 
    */
    public void setAgencyMasterReference(List<LittleContract__c> newLittleContractList, Map<Id,LittleContract__c> oldLittleConMap, String operation){
        
        Set<String> agencyNumSet = new Set<String>();
        List<LittleContract__c> changedLittleContractList = new List<LittleContract__c>();

        if(operation.equals('insert')){
            for(LittleContract__c littleContract : newLittleContractList){        
                if(String.isNotBlank(littleContract.AgencyCode__c)){
                    agencyNumSet.add(littleContract.AgencyCode__c);
                }
            }
            setLittleContractAgency(newLittleContractList, agencyNumSet);

        }else if(operation.equals('update')){

            for(LittleContract__c littleContract : newLittleContractList){
                LittleContract__c oldLittleCon = oldLittleConMap.get(littleContract.Id);
                if(String.isNotBlank(littleContract.AgencyCode__c) && oldLittleCon.AgencyCode__c != littleContract.AgencyCode__c){
                    agencyNumSet.add(littleContract.AgencyCode__c);
                    changedLittleContractList.add(littleContract);
                }else if(String.isBlank(littleContract.AgencyCode__c) && oldLittleCon.AgencyCode__c != littleContract.AgencyCode__c){
                    changedLittleContractList.add(littleContract);
                }
            }
            setLittleContractAgency(changedLittleContractList, agencyNumSet);
        }             
    }

    /**
    * 少短契約情報に代理店を更新
    * @param List<LittleContract__c>
    * @param Set<String>
    * @return 
    */
    public void setLittleContractAgency(List<LittleContract__c> littleContractList,Set<String> agencyNumSet){

        Map<String,Id> shotanAgencyMasterMap = new Map<String,Id>();
        List<AgencyMaster__c> agencyList = [SELECT id,ShotanAgencyCode__c FROM AgencyMaster__c WHERE ShotanAgencyCode__c IN : agencyNumSet ];
        for(AgencyMaster__c agency : agencyList){
            shotanAgencyMasterMap.put(agency.ShotanAgencyCode__c,agency.Id);
        }

        for(LittleContract__c littleContract : littleContractList){
            littleContract.AgencyId__c = shotanAgencyMasterMap.get(littleContract.AgencyCode__c);
        } 
    }
}