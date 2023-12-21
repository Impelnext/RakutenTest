/*
* @Class Name      : DamageContractTriggerHandler 
* @Description     : 損保契約情報トリガーハンドラ
* @Created Date    : 2019.05.15
* @Created By      : 
* @Modified Date   : 2019.12.26
* @Modified By     : Valsala Kumar
* @Modified Date   : 2020.11.20
* @Modified By     : SRM
*/
public class DamageContractTriggerHandler {

    // Modify 2023/08/17 RIPCRM-940_損保代理店契約の電話番号対応に伴う統合CRM項目追加の進捗管理等 By 万　Start
    // 取引先設定用のビジネスクラス
    public DamageContractSetAccount setAccountBussiness;
    // Modify 2023/08/17 RIPCRM-940_損保代理店契約の電話番号対応に伴う統合CRM項目追加の進捗管理等 By 万　End

    /**
     * コンストラクタ
     */
    public DamageContractTriggerHandler() {
        // Modify 2023/08/17 RIPCRM-940_損保代理店契約の電話番号対応に伴う統合CRM項目追加の進捗管理等 By 万　Start
        this.setAccountBussiness = new DamageContractSetAccount();
        // Modify 2023/08/17 RIPCRM-940_損保代理店契約の電話番号対応に伴う統合CRM項目追加の進捗管理等 By 万　End
    }
    
    /**
     * 損保契約情報作成前処理
     * @param List<DamageContract__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<DamageContract__c> damageContractList){

        //損保契約情報に関連する取引先IDセット
        Set<String> sonpoAccountIdSet = new Set<String>();
        for(DamageContract__c sonpo : damageContractList){
            if (String.IsNotBlank(sonpo.AccountId__c)) {
                sonpoAccountIdSet.add(sonpo.AccountId__c);
            }
            /* RIPCRM-191 修正　開始
            else{
                //取引先に紐づかない契約の場合エラーとする
                sonpo.addError('取引先に紐づかない契約のためエラー　契約識別番号：' + sonpo.ContractUniqueKey__c);
            }
            */
            /* RIPCRM-191 修正　終了 ***/
        }
        
        // 既存の取引先を取得(取引先IDベース)
        Map<String,Account> existRefAccountMap = new Map<String,Account>();
        for(Account acc : [SELECT Id,furiganaLast__pc,furiganaForst__pc FROM Account WHERE Id IN :sonpoAccountIdSet]){
            existRefAccountMap.put(acc.Id, acc);
        }
        
        // 取引先、商談関連用マップ ID:取引先ID
        Map<Id,Opportunity> accountOpportunityMap = new Map<Id,Opportunity>();
        // 新規商談Insert用リスト
        List<Opportunity> insertOpportunityList = new List<Opportunity>();
        // 既存損保商談を取得
        List<Opportunity> existSonpoOpportunityList = [ 
                                                            SELECT Id, Name, AccountId 
                                                              FROM Opportunity
                                                             WHERE AccountId IN :sonpoAccountIdSet
                                                               AND RecordType.DeveloperName = 'Sonpo'
                                                          ORDER BY LastModifiedDate DESC
                                                      ];
        // 取引先、損保商談関連用マップに入れる
        // 最新損保商談を取得
        for(Opportunity opp : existSonpoOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 損保商談が存在しない場合
        // オープン中の汎用商談を取得
        // 既存汎用商談を取得
        List<Opportunity> existHanyoOpportunityList = [ 
                                                            SELECT Id, Name, AccountId 
                                                              FROM Opportunity
                                                             WHERE AccountId IN :sonpoAccountIdSet
                                                               AND RecordType.DeveloperName = 'Hanyo'
                                                               AND StageName <> '対応終了'
                                                          ORDER BY LastModifiedDate DESC
                                                      ];
        // 取引先、汎用商談関連用マップに入れる
        // 損保商談が存在しない場合
        // 最新汎用商談を取得
        for(Opportunity opp : existHanyoOpportunityList){
            if (accountOpportunityMap.get(opp.AccountId) == NULL) {
                accountOpportunityMap.put(opp.AccountId, opp);
            }
        }
        
        // 商談が存在しない場合
        // 商談を新規作成
        // 商談の損保レコードタイプIDを取得
        Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        DateTime insertDate = datetime.now();
        //商談のクローズ日は翌月末日
        Date today = System.today();
        Date insertCloseDate = Date.newInstance(today.year(), today.month() + 2,0);
        String opportunityNameInsertStr = insertDate.format('yyyyMMdd') + '_' + '損保' + '_';
        
        // 商談を新規作成
        for (DamageContract__c sonpo : damageContractList){
            if (String.IsNotBlank(sonpo.AccountId__c) && 
                accountOpportunityMap.get(sonpo.AccountId__c) == NULL){
                //取引先を取得
                Account acc = existRefAccountMap.get(sonpo.AccountId__c);
                // 商談がない場合、新規作成
                Opportunity targetOpp = new Opportunity();
                // 商談の設定
                targetOpp.RecordTypeId = oppSonpoRecordTypeId;
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
                targetOpp.AccountId = sonpo.AccountId__c;
                // リードソース
                targetOpp.InflowRoute__c = '';
                // クローズ種別
                targetOpp.CloseType__c = '申込';
                // 最新見込確度
                targetOpp.RecentProbability__c = '申込済み';
                // 最終見込確度
                targetOpp.LastProbability__c = '申込済み';
                // キャンペーン日時 = 損保契約情報．システム日付
                targetOpp.CampaignDateTime__c = System.Now();
                
                insertOpportunityList.add(targetOpp);
                accountOpportunityMap.put(acc.Id, targetOpp);
            }
        }
        // 新規商談Insert
        insert insertOpportunityList;
        
        // 損保契約情報．商談設定
        // 商談を取得した場合、取得した商談．Id
        // 取得できない場合、新規作成した商談．Id
        for(DamageContract__c sonpo : damageContractList){
            if (String.IsNotBlank(sonpo.AccountId__c)) {
                sonpo.Opportunity__c = accountOpportunityMap.get(sonpo.AccountId__c).Id;
            }
        }
    }
    
    
    /**
     * 損保契約情報更新前処理
     * @param List<DamageContract__c>
     * @param Map<Id, DamageContract__c>
     * @return 
     */
    public void onBeforeUpdateProcess(List<DamageContract__c> damageContractList, Map<Id, DamageContract__c> oldMap){
        for (DamageContract__c damageContract : damageContractList){
            // 取引先変更判定
            if (damageContract.AccountId__c <> oldMap.get(damageContract.Id).AccountId__c && 
                damageContract.Opportunity__c == oldMap.get(damageContract.Id).Opportunity__c){
                // 商談との関連解消
                // 商談参照項目クリア
                damageContract.Opportunity__c = NULL;
            }
        }
    }
    
    /**
    * 損保契約情報作成後／更新後処理
    * @param List<DamageContract__c>
    * @param Map<Id, DamageContract__c>
    * @return 
    */
    public void setDamageContractMail(List<DamageContract__c> damageContractList, Map<Id, DamageContract__c> oldMap){
        
        // メール更新処理
        // 取引先取得
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        for (DamageContract__c damageContract : damageContractList) {
            // 損保契約者情報のメールアドレスが、変更された際に
            // 取引先情報のメールアドレスも更新する。（新規作成の場合も含む）
            // 損保契約者情報のメールアドレスがnullの場合は、取引先情報のメールアドレスを更新しない
            // 損保契約者情報と、取引先情報のメールアドレスが一致している場合は、取引先情報のメールアドレスを更新しない
            if (String.isNotBlank(damageContract.Mail__c) &&
                String.IsNotBlank(damageContract.AccountId__c) && 
                (   oldMap == Null 
                 || oldMap.size() == 0
                 || damageContract.Mail__c <> oldMap.get(damageContract.Id).Mail__c)) {
                accIdSet.add(damageContract.AccountId__c);
            }
        }
        
        // 関連先取引先取得
        if (accIdSet.size() > 0) {
            Map<Id, Account> updateAccountMap = new Map<Id,Account> ();
            Map<Id, List<DamageContract__c>> accountDamageMap = new Map<Id, List<DamageContract__c>>();
            Map<Id, Account> accountMap = new Map<id,Account>(
                                                                [ 
                                                                    SELECT Id, PersonEmail
                                                                      FROM Account
                                                                     WHERE Id = :accIdSet 
                                                                ]
                                                             );
            for(DamageContract__c damageContract : damageContractList) {
                // 損保契約者情報のメールアドレスが、変更された際に
                // 取引先情報のメールアドレスも更新する。（新規作成の場合も含む）
                // 損保契約者情報のメールアドレスがnullの場合は、取引先情報のメールアドレスを更新しない
                // 損保契約者情報と、取引先情報のメールアドレスが一致している場合は、取引先情報のメールアドレスを更新しない
                if (String.IsNotBlank(damageContract.Mail__c) &&
                    String.IsNotBlank(damageContract.AccountId__c) && 
                    accountMap.get(damageContract.AccountId__c) != NULL && 
                    (   oldMap == Null 
                     || oldMap.size() == 0
                     || damageContract.Mail__c <> oldMap.get(damageContract.Id).Mail__c)){
                    
                    Account acc = accountMap.get(damageContract.AccountId__c);
                    
                    // 【通常稼働用】
                    // 損保契約者情報のメールアドレスと、取引先情報のメールアドレスが一致している場合は更新しない。（空更新は行わない）
                    if (damageContract.Mail__c <> acc.PersonEmail) {
                    // 【移行用】
                    // 取引先情報にすでにメールアドレスが登録されている場合は、更新しない
                    // 移行時は取引先が空の場合の時のみ、メールアドレスを登録する
                    //if (String.IsBlank(acc.PersonEmail)) {
                        acc.PersonEmail = damageContract.Mail__c;
                        updateAccountMap.put(acc.Id, acc);
                    }
                    
                    // 損保契約者情報をリストに設定する
                    if (accountDamageMap.get(acc.Id) != NULL) {
                        accountDamageMap.get(acc.Id).add(damageContract);
                    }
                    else {
                        accountDamageMap.put(acc.Id, new List<DamageContract__c>{damageContract});
                    }
                }
            }
            
            // 取引先のメールを更新する
            // Partial Success is OK
            if (updateAccountMap.size() > 0) {
                List<Database.SaveResult> res_lists = new List<Database.SaveResult>();
                List<Account> updateAccList = updateAccountMap.values();
                
                // 取引先のメールを更新する
                res_lists = Database.update(updateAccountMap.values(), false);
                
                for (Integer idx = 0; idx < res_lists.size(); idx++) {
                    Database.SaveResult res = res_lists[idx];
                    if(res.isSuccess()){
                        // 成功時（何も無し）
                    }
                    else{
                        // 失敗時
                        // メールエラーの判定
                        // 損保契約情報から、取引先情報へのメールアドレス設定には失敗した場合に、
                        // エラーログオブジェクトにエラー情報を登録する
                        Id accId = updateAccList[idx].Id;
                        List<ErrorLog__c> errList = new List<ErrorLog__c>();
                        for(Database.Error err : res.getErrors()) {
                            if (String.IsNotBlank(err.getMessage()) && 
                                err.getStatusCode() == StatusCode.INVALID_EMAIL_ADDRESS) {
                                
                                if (String.IsNotBlank(accId) &&
                                    accountDamageMap.get(accId) != NULL) {
                                    List<DamageContract__c> damageErrList = accountDamageMap.get(accId);
                                    for (DamageContract__c damageErr : damageErrList) {
                                        // 取引先のエラーメールの場合のみエラー判定する
                                        if (damageErr.Mail__c == accountMap.get(accId).PersonEmail) {
                                            // Error Log insert
                                            ErrorLog__c errLog = new ErrorLog__c (
                                                                                    ProgramName__c = 'DamageContractTrigger.INVALID_EMAIL_ADDRESS',
                                                                                    ErrorMessage__c = 'INVALID_EMAIL_ADDRESS:メールアドレスが無効です。'
                                                                                                    + '契約識別番号：'
                                                                                                    + damageErr.ContractUniqueKey__c
                                                                                                    + '、 無効なメールアドレス：'
                                                                                                    + damageErr.Mail__c
                                                                                 );
                                            errList.add(errLog);
                                            
                                            // エラーを統合CRMバッチに返さない
                                        }
                                    }
                                }
                            }
                            else {
                                // メールエラー以外の場合、エラーをバッチに返す
                                throw new DMLException('Id：' + accId 
                                                        + '、ERROR_CODE：' + err.getStatusCode()
                                                        + '、ERROR_MESSAGE：' + err.getMessage());
                                // NOTREACHED
                            }
                        }
                        
                        // エラーログを登録する
                        if(errList != null && errList.size() > 0)
                            insert errList;
                    }
                }
            }
        }
    }
    
    
    /**
     * 損保契約情報作成後／更新後処理
     * @param List<DamageContract__c>
     * @param Map<Id, DamageContract__c>
     * @return 
     */
    public void onAfterProcess(List<DamageContract__c> damageContractList, Map<Id, DamageContract__c> oldMap){
        // Modify 2023/08/17 RIPCRM-940_損保代理店契約の電話番号対応に伴う統合CRM項目追加の進捗管理等 By 万　Start
        if(oldMap != null){// after updateの場合のみ実行させる
            this.setAccountBussiness.setAccountAfterUpdate(damageContractList, oldMap);
        }
        // Modify 2023/08/17 RIPCRM-940_損保代理店契約の電話番号対応に伴う統合CRM項目追加の進捗管理等 By 万　End
        
        //******20191226 修正　開始*******/
        // Phase3対応
        
        //損保契約情報に関連する商談IDセット
        Set<String> sonpoOppIdSet = new Set<String>();
        //損保契約情報に関連する取引先IDセット
        Set<String> sonpoAccountIdSet = new Set<String>();
        
        for (DamageContract__c sonpo : damageContractList){
            if (String.IsNotBlank(sonpo.Opportunity__c)) {
                sonpoOppIdSet.add(sonpo.Opportunity__c);
                if (String.IsNotBlank(sonpo.AccountId__c)) {
                    sonpoAccountIdSet.add(sonpo.AccountId__c);
                }
            }
        }
        
        // 商談
        // 更新商談Update用リスト
        Map<Id, Opportunity> updateOpportunityMap = new Map<Id, Opportunity>();
        
        // 損保契約情報、商談関連用マップ ID:商談ID
        // 関連先商談取得
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>(
                                                                [ 
                                                                    SELECT Id, RecordTypeId, StageName, 
                                                                           ANP__c, EstimatedANP__c, 
                                                                           CloseDate, CloseType__c, 
                                                                           RecentProbability__c, 
                                                                           LastProbability__c 
                                                                      FROM Opportunity
                                                                     WHERE Id IN :sonpoOppIdSet
                                                                ]
                                                            );
        
        // 取引先に紐づく他商談を取得
        List<Opportunity> accOtherOppList = [ 
                                                SELECT Id, StageName, 
                                                       CloseDate, CloseType__c, 
                                                       CloseReason__c, RecentProbability__c, 
                                                       AccountId, LastProbability__c 
                                                  FROM Opportunity
                                                 WHERE AccountId = :sonpoAccountIdSet 
                                                   AND Id <> :sonpoOppIdSet
                                                   AND StageName <> '対応終了'
                                                   AND (RecordType.DeveloperName = 'Sonpo' OR RecordType.DeveloperName = 'Hanyo')
                                            ];
        Map<Id, List<Opportunity>> accountOtherOppMap = new Map<Id, List<Opportunity>>();
        for (Opportunity targetOpp : accOtherOppList){
            if (accountOtherOppMap.get(targetOpp.AccountId) == NULL){
                List<Opportunity> accOppList = new List<Opportunity>();
                accOppList.add(targetOpp);
                accountOtherOppMap.put(targetOpp.AccountId,accOppList);
            }
            else{
                accountOtherOppMap.get(targetOpp.AccountId).add(targetOpp);
            }
        }
        
        for(DamageContract__c sonpo : damageContractList){
            if (sonpo.Opportunity__c != NULL && 
                oppMap.get(sonpo.Opportunity__c) != NULL && 
                (oldMap == NULL || 
                 oldMap.get(sonpo.Id).Opportunity__c != sonpo.Opportunity__c)) {
                
                Opportunity targetOpp = oppMap.get(sonpo.Opportunity__c);
                
                // 関連先商談の項目設定（ANP更新）+ 
                // 関連先商談の項目設定（ANP初回設定）
                updateClosedOpportunity(targetOpp, sonpo);
                
                // 取引先に紐づく他商談処理
                if (accountOtherOppMap.get(sonpo.AccountId__c) != NULL){
                    
                    List<Opportunity> accOppList = accountOtherOppMap.get(sonpo.AccountId__c);
                    // 商談クローズ処理
                    // 取引先に紐づく他商談を値設定
                    updateOtherClosedOpportunity(accOppList, sonpo);
                    
                    // Update用Mapに追加
                    for(Opportunity rec : accOppList){
                        if(updateOpportunityMap.get(rec.id) == Null){
                            updateOpportunityMap.put(rec.id, rec);
                        }
                    }
                }
                
                // Update用Mapに追加
                if(updateOpportunityMap.get(targetOpp.id) == Null){
                    updateOpportunityMap.put(targetOpp.id, targetOpp);
                }
            }
        }
        
        
        //商談を更新
        if (updateOpportunityMap != null && updateOpportunityMap.size() > 0)
            update updateOpportunityMap.values();
        
        
        // 損保申込フラグ更新処理
        // 取引先取得
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        for (DamageContract__c damageContract : damageContractList){
            if (damageContract.AccountId__c != NULL && 
                (  oldMap == Null 
                || oldMap.size() == 0
                || damageContract.AccountId__c <> oldMap.get(damageContract.Id).AccountId__c)){
                accIdSet.add(damageContract.AccountId__c);
            }
        }
        // 関連先取引先取得
        if (accIdSet.size() > 0){
            List<Account> updateAccountList =   [ 
                                                    SELECT Id, SonpoOppApplyflg__c, DamageUse__pc 
                                                      FROM Account
                                                     WHERE Id = :accIdSet 
                                                ];
            // 取得した取引先レコードについて、損保申込フラグをTrueにする
            for (Account targetAcc : updateAccountList){
                // 損保申込フラグ
                targetAcc.SonpoOppApplyflg__c = TRUE;
                targetAcc.DamageUse__pc = TRUE;
            }
            
            // 取引先の損保申込フラグ項目を更新
            if (updateAccountList != null && updateAccountList.size() > 0)
                update updateAccountList;
        }
        //******20191226 修正　エンド*******/
    }

    /**
     * 取引先に紐づかない損保契約をエラーログに追加する
     * @param List<DamageContract__c>
     * RIPCRM-191 修正　開始
     */
    public void NoAccountIdContractProcess(List<DamageContract__c> damageContractList){

        List<Id> damageContractIdList = new List<Id>();
        //取引先に紐づかない契約のリスト
        List<ErrorLog__c> sonpoErrorList = new List<ErrorLog__c>();
        Map<Id,DamageContract__c> damageContractMap = new Map<Id,DamageContract__c>(
                                                                [SELECT Id, AccountId__c, ContractUniqueKey__c, OpenId__c FROM DamageContract__c 
                                                                WHERE Id IN: damageContractList]
                                                                );
        for(DamageContract__c damage : damageContractMap.values()){
            if(String.isBlank(damage.AccountId__c)){
                damageContractIdList.add(damage.Id);
                String openIdValue = String.isNotBlank(damage.OpenId__c) ? 'あり' : 'なし';
                if(damage.ContractUniqueKey__c.startsWith('ERR-')){
                    ErrorLog__c errLog = new ErrorLog__c(
                        ProgramName__c = 'DamageContractTrigger.NoAccountIdContractProcess',
                        ErrorMessage__c = '保険種類に値が入っていません。\n 保険証券番号：' + damage.ContractUniqueKey__c.replace('ERR-','') + '\n OpenID :' + openIdValue
                    );
                    sonpoErrorList.add(errLog);
                }else{
                    ErrorLog__c errLog = new ErrorLog__c(
                        ProgramName__c = 'DamageContractTrigger.NoAccountIdContractProcess',
                        ErrorMessage__c = '対象の契約が存在しません。\n 契約識別番号：' + damage.ContractUniqueKey__c +'\n OpenID :' + openIdValue
                    );
                    sonpoErrorList.add(errLog);
                }
            }
        }

        if(sonpoErrorList != null && sonpoErrorList.size() > 0){
            //エラー契約をエラーログにINSERTする
            insert sonpoErrorList;
            //取引先に紐づかない契約を削除する。
            Database.delete(damageContractIdList);
        }
    }
    /*** RIPCRM-191 修正　終了 **/
    
    
    private void updateClosedOpportunity(Opportunity targetOpp, DamageContract__c sonpo) {
        // 関連先商談の項目設定（ANP更新）+ 
        // 関連先商談の項目設定（ANP初回設定）
        
        // 商談の損保レコードタイプIDを取得
        Id oppSonpoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sonpo').getRecordTypeId();
        // 関連先商談更新_申込完了
        // 商談の設定
        targetOpp.RecordTypeId = oppSonpoRecordTypeId;
        // 商談ステータス
        targetOpp.StageName = '対応終了';
        // 完了予定日
        targetOpp.CloseDate = Date.newinstance(
                                        sonpo.LastModifiedDate.year(), 
                                        sonpo.LastModifiedDate.month(), 
                                        sonpo.LastModifiedDate.day());
        // ANP + 見込ANP
        if (String.isNotBlank(sonpo.InsuranceFee__c)) {
            String fee = sonpo.InsuranceFee__c.replaceAll('[円,$]', '');
            if (fee.isNumeric()) {
                if (targetOpp.ANP__c != NULL) {
                    // 関連先商談の項目設定（ANP更新）
                    // ANPの値 = 既存のANPの値 + 損保契約情報.保険料
                    targetOpp.ANP__c = targetOpp.ANP__c + Integer.valueOf(fee);
                }
                else {
                    // 関連先商談の項目設定（ANP初回設定）
                    // ANPの値 = 損保契約情報.保険料
                    targetOpp.ANP__c = Integer.valueOf(fee);
                }
                // 見込ANP
                targetOpp.EstimatedANP__c = targetOpp.ANP__c;
            }
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
    
    
    private void updateOtherClosedOpportunity(List<Opportunity> accOtherOppList, DamageContract__c sonpo) {
        for(Opportunity targetOpp : accOtherOppList){
            // 商談ステータス
            targetOpp.StageName = '対応終了';
            // 完了予定日
            targetOpp.CloseDate = Date.newinstance(
                                        sonpo.LastModifiedDate.year(), 
                                        sonpo.LastModifiedDate.month(), 
                                        sonpo.LastModifiedDate.day());
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
     * 損保契約情報作成・更新前処理
     * @param List<DamageContract__c>
     * @return 
     */
    /*
    public void onBeforeProcess(List<DamageContract__c> damageContractList, Map<Id, DamageContract__c> oldMap){
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        for(DamageContract__c damageContract : damageContractList){
            if(   oldMap == Null || oldMap.size() == 0
               || damageContract.AccountId__c <> oldMap.get(damageContract.Id).AccountId__c){
                accIdSet.add(damageContract.AccountId__c);
            }
        }
        // 損保利用がFALSEの取引先が更新対象であるため、取得する
        if(accIdSet.size() > 0){
            List<Account> updateTargetAccountList = [SELECT Id,DamageUse__pc FROM Account WHERE Id IN :accIdSet AND DamageUse__pc = FALSE];
            for(Account acc : updateTargetAccountList){
                acc.DamageUse__pc = TRUE;
            }
            // 取引先の損保利用項目を更新
            update updateTargetAccountList;
        }
    }
    */
    
    
    /**
     * 損保契約情報作成・更新前処理
     * @param List<DamageContract__c>
     * @return 
     */
    /*
    public void onAfterProcess(List<DamageContract__c> damageContractList){
        // 取引先Idを格納するセット
        Set<Id> accIdSet = new Set<Id>();
        //商談の更新リスト
        List<Opportunity> updateOpportunityList = new List<Opportunity>();
        
        for(DamageContract__c damageContract : damageContractList){
            accIdSet.add(damageContract.AccountId__c);
        }
        List<Account> accountList = [Select Id, (Select Id, StageName from Opportunities where RecordType.Name = '損保') from Account where Id IN: accIdSet];
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
     * 損保契約情報作成・更新後処理
     * @param List<DamageContract__c>
     * @param Map<Id,DamageContract__c>
     * @return 
     */
/** 契約者変更時の契約分割機能に伴い変更フラグON処理を撤廃 **/
/*    public void onAfterUpdateProcess(List<DamageContract__c> damageContractList, Map<Id,DamageContract__c> oldMap){

        //取引先更新の判断フラグ
        boolean updateFlag = false;
        //取引先を格納するセット
        Set<Id> accountIdSet = new Set<Id>();
        for(DamageContract__c damageContract : damageContractList){
            accountIdSet.add(damageContract.AccountId__c);
        }
        //更新用List
        Map<Id, Account> updateAccountMap = new Map<Id, Account>();

        //損保契約に紐づいている取引先の情報マップ
        Map<Id,Account> accountMap = new Map<Id,Account>();
        for(Account acc : [Select Id, furigana__c, Gender__pc, PersonBirthdate, nameChangedFlag__c, genderChangedFlag__c, birthdateChangedFlag__c from Account where Id IN: accountIdSet]){
            accountMap.put(acc.Id, acc);
        }

        for(DamageContract__c damageContract : damageContractList){
            if(damageContract.TorihikisakiKana__c != oldMap.get(damageContract.Id).TorihikisakiKana__c){
                if(accountMap.get(damageContract.AccountId__c).furigana__c != damageContract.TorihikisakiKana__c){
                    updateFlag = true;
                    accountMap.get(damageContract.AccountId__c).nameChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(damageContract.AccountId__c).Id, accountMap.get(damageContract.AccountId__c));
                }
            }
            if(damageContract.TorihikisakiGender__c != oldMap.get(damageContract.Id).TorihikisakiGender__c){
                if(accountMap.get(damageContract.AccountId__c).Gender__pc != damageContract.TorihikisakiGender__c){
                    updateFlag = true;
                    accountMap.get(damageContract.AccountId__c).genderChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(damageContract.AccountId__c).Id, accountMap.get(damageContract.AccountId__c));
                }
            }
            if(damageContract.TorihikisakiBD__c != oldMap.get(damageContract.Id).TorihikisakiBD__c){
                System.debug('damageContract.TorihikisakiBD__c ' + damageContract.TorihikisakiBD__c);
                // 数字8桁の場合
                if(!(damageContract.TorihikisakiBD__c != null
                   && Pattern.matches('\\d{8}', damageContract.TorihikisakiBD__c))){
                    String tempDate = damageContract.TorihikisakiBD__c;
                    Date torihikisakiBD = Date.valueOf(tempDate.left(4)+'-'+tempDate.mid(4,2)+'-'+tempDate.right(2));
                    if(accountMap.get(damageContract.AccountId__c).PersonBirthdate != torihikisakiBD){
                        updateFlag = true;
                        accountMap.get(damageContract.AccountId__c).birthdateChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(damageContract.AccountId__c).Id, accountMap.get(damageContract.AccountId__c));
                    }
                }else{
                    // 8桁数字以外の場合、予想外のデータのため、レポート出力対象とする
                    updateFlag = true;
                    accountMap.get(damageContract.AccountId__c).birthdateChangedFlag__c = true;
                    updateAccountMap.put(accountMap.get(damageContract.AccountId__c).Id, accountMap.get(damageContract.AccountId__c));
                }
            }
        }

        if(updateAccountMap.size() > 0){
            update updateAccountMap.values();
        }
    }*/

    /**
    * 生保契約情報作成前、更新前処理
    * @param List<DamageContract__c>
    * @param Map<Id,DamageContract__c>
    * @param Set<String
    * @return 
    */
    public void setAgencyMasterReference(List<DamageContract__c> newDamageContractList,Map<Id,DamageContract__c> damageContractOldMap, String operation){

        Map<String,Id> agencyMasterMap = new Map<String,Id>();
        List<DamageContract__c> changedDamageContractList = new List<DamageContract__c>();

        if(operation.equals('insert')){
            /**** 20200219 CPUタイムリミット修正　開始　********/
            for(DamageContract__c damage : newDamageContractList){
                damage.isAgencyCodeChanged__c = damage.AgencyCode__c != null ? true : false;
            }
            //agencyMasterMap = searchAgencyMaster(newDamageContractList);
            //setDamageContractAgency(newDamageContractList, agencyMasterMap);
            /**** 20200218 CPUタイムリミット修正　エンド　********/
        }else if(operation.equals('update')){
            for(DamageContract__c damageContract : newDamageContractList){
                DamageContract__c oldDamageContract = damageContractOldMap.get(damageContract.Id);
                if((String.isNotBlank(damageContract.AgencyCode__c) || String.isBlank(damageContract.AgencyCode__c)) && oldDamageContract.AgencyCode__c != damageContract.AgencyCode__c){
                    /**** 20200218 CPUタイムリミット修正　開始　********/
                    damageContract.isAgencyCodeChanged__c = true;
                    //changedDamageContractList.add(damageContract);
                }
            }
            //agencyMasterMap = searchAgencyMaster(clearDamageContractAgencyCode(changedDamageContractList));
            //setDamageContractAgency(changedDamageContractList, agencyMasterMap);
            /**** 20200218 CPUタイムリミット修正　エンド　********/
        }
    }

    /**
    * 代理店マスタの検索
    * @param List<DamageContract__c>
    * @return Map<String,Id>
    */
    public Map<String,Id> searchAgencyMaster(List<DamageContract__c> newDamageContractList){
        
        System.debug('inside search ' + newDamageContractList);

        //検索用の代理店コードリスト
        List<String> inputAgencyCodeList = new List<String>();
        Map<String,Id> agencyMasterMap = new Map<String,Id>();

        for(Sobject damage : newDamageContractList){
            System.debug('--agency code ' + damage.get('AgencyCode__c'));
            List<String> agencyCodeList = damage.get('AgencyCode__c') != null ? ((String)damage.get('AgencyCode__c')).split(',') : new List<String>();
            if(agencyCodeList.size() >= 2){
                for(Integer index = 0;index<agencyCodeList.size();index++){
                    damage.put('AgencyCode' + String.valueOf(index+1) + '__c',agencyCodeList.get(index));
                }
            }else if(agencyCodeList.size() == 1){
                damage.put('AgencyCode1__c',agencyCodeList.get(0));
            }
            
            System.debug('-- inside Damage contract list ' + newDamageContractList);

            if(String.isNotBlank((String)damage.get('AgencyCode__c'))){
                for(String  key : ((String)damage.get('AgencyCode__c')).split(',')){
                    inputAgencyCodelist.add(key);
                }
                System.debug('inputAgencyCodeList ' + inputAgencyCodeList);
            }
            
            System.debug('out inputAgencyCodeList ' + inputAgencyCodeList);
        }

        List<AgencyMaster__c> agencyList = [SELECT id,SonpoAgencyCode__c FROM AgencyMaster__c WHERE SonpoAgencyCode__c IN: inputAgencyCodeList];
        System.Debug('agencyList::'+agencyList );
        for(AgencyMaster__c agency : agencyList){
            agencyMasterMap.put(agency.SonpoAgencyCode__c, agency.Id);
        }
        return agencyMasterMap;
    }

    /**
    * 生保契約情報の項目クリア
    * @param List<DamageContract__c>
    * @return List<DamageContract__c>
    */
    public List<DamageContract__c> clearDamageContractAgencyCode(List<DamageContract__c> damageContractList){

        for(DamageContract__c damageContract : damageContractList){

            damageContract.AgencyCode1__c = '';
            damageContract.AgencyCode2__c = '';
            damageContract.AgencyCode3__c = '';
            damageContract.AgencyCode4__c = '';
            damageContract.AgencyCode5__c = '';

            damageContract.AgencyId1__c = null;
            damageContract.AgencyId2__c = null;
            damageContract.AgencyId3__c = null;
            damageContract.AgencyId4__c = null;
            damageContract.AgencyId5__c = null;
        }
        return damageContractList;
    }

    /**
    * 生保契約情報に代理店を更新
    * @param List<DamageContract__c>
    * @return Map<String,Id>
    */
    public void setDamageContractAgency(List<DamageContract__c> damageContractList, Map<String,Id> agencyMasterMap){

        for(DamageContract__c damage : damageContractList){

            damage.AgencyId1__c = agencyMasterMap.get(damage.AgencyCode1__c) != null ? agencyMasterMap.get(damage.AgencyCode1__c) : null;
            damage.AgencyId2__c = agencyMasterMap.get(damage.AgencyCode2__c) != null ? agencyMasterMap.get(damage.AgencyCode2__c) : null;
            damage.AgencyId3__c = agencyMasterMap.get(damage.AgencyCode3__c) != null ? agencyMasterMap.get(damage.AgencyCode3__c) : null;
            damage.AgencyId4__c = agencyMasterMap.get(damage.AgencyCode4__c) != null ? agencyMasterMap.get(damage.AgencyCode4__c) : null;
            damage.AgencyId5__c = agencyMasterMap.get(damage.AgencyCode5__c) != null ? agencyMasterMap.get(damage.AgencyCode5__c) : null;
        }
    }
}