/*
* @Class Name     : OpportunityTriggerHandler
* @Description    : 商談トリガーハンドラ
* @Created Date   : 2020.01.08
* @Created By     : Valsala Kumar
* @Modified Date  : 
* @Modified By    : 
*/
public class OpportunityTriggerHandler {
    
    public static String PROFILE_SYSTEMADMIN_NAME_EN = 'System Administrator';
    public static String PROFILE_SYSTEMADMIN_NAME_JP = 'システム管理者';
    
    // コンストラクタ
    public OpportunityTriggerHandler() {}
    
    /**
     * 商談作成前処理
     * @param List<Opportunity>
     * @return 
     */
    public void onBeforeInsertProcess(List<Opportunity> oppList) {
        
        // 商談のレコードタイプマップを取得
        Map<Id, Schema.RecordTypeInfo> oppRecordTypeMapById = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosById();
        
        // 取引先名対象を抽出
        Set<Id> accountIdSet = new Set<Id>();
        // 商談．所有者対象を抽出
        Set<Id> ownerIdSet = new Set<Id>();
        for(Opportunity o : oppList) {
            // （新規作成）商談．取引先名取得
            if(String.IsNotBlank(o.AccountId)){
                accountIdSet.add(o.AccountId);
            }
            // （新規作成）商談．所有者取得
            ownerIdSet.add(o.OwnerId);
        }
        
        // （新規作成）商談．所有者．プロファイル取得
        Map<Id, User> ownerMap = new Map<Id, User>  (
                                                        [
                                                            SELECT Id
                                                                 , Profile.Name
                                                              FROM User
                                                             WHERE Id IN :ownerIdSet
                                                        ]
                                                    );
        
        // 同じ取引先名が参照している商談を抽出
        List<Opportunity> duplicateOppList = [
                                        SELECT Id
                                             , RecordTypeId
                                             , RecordType.Name
                                             , AccountId
                                        FROM Opportunity
                                        WHERE AccountId IN : accountIdSet
                                          AND StageName != '対応終了'
                                    ];
        
        // 同じ取引先名に関連する商談
        Map<Id, List<Opportunity>> accOppMap = new Map<Id, List<Opportunity>>();
        for(Opportunity o : duplicateOppList) {
            if (accOppMap.get(o.AccountId) == NULL) {
                List<Opportunity> lst = new List<Opportunity>();
                lst.add(o);
                accOppMap.put(o.AccountId, lst);
            }
            else {
                accOppMap.get(o.AccountId).add(o);
            }
        }
        
        // 関連先取引先レコード取得
        // 条件：
        // 取引先．Id = 商談．取引先名
        Map<Id, Account> accMap = new Map<Id, Account>(
                                                        [
                                                            SELECT Id
                                                                 , OperationType__c
                                                              FROM Account
                                                             WHERE Id IN : accountIdSet
                                                        ]
                                                       );
        
        Boolean bHasError = false;
        // 作成前処理
        for(Opportunity o : oppList) {
            bHasError = false;
            
            if(String.IsNotBlank(o.AccountId)){
                
                // 重複商談取得
                // 重複商談が存在？
                // 条件：① AND ② AND ③
                // ①：商談．取引先名 =（新規作成）商談．取引先名
                // ②：商談．レコードタイプ =（新規作成）商談．レコードタイプ
                // ③：商談．商談ステータス <> 対応終了
                if(accOppMap.get(o.AccountId) != NULL) {
                    List<Opportunity> otherOppList = accOppMap.get(o.AccountId);
                    for (Opportunity otherOpp : otherOppList) {
                        if(o.RecordTypeId == otherOpp.RecordTypeId) {
                            // 重複商談が存在する
                            // エラーメッセージ表示
                            o.addError('同じ取引先に、同じメーカーのオープンな商談が存在します。');
                            
                            // 作成処理中止
                            bHasError = true;
                        }
                    }
                }
                
                // If Error, Process Next Opportunity
                if (bHasError)
                    continue;
                    // NOTREACHED
                
                // 商談所有者セット
                // 商談所有者初期設定
                // 商談所有者（一括変更用）= 商談．商談所有者
                o.OwnerForBulkChange__c = o.OwnerId;
                
                // レコードタイプセット
                // レコードタイプ初期設定
                // レコードタイプ(一括変更用)）= 商談．レコードタイプ
                o.RecordTypeForBulkChange__c = oppRecordTypeMapById.get(o.RecordTypeId).getName();
                
                // TSR割当商談のステータスは適正？
                // 商談ステータス整合性判定
                // 条件：① AND ②
                // ①：商談．所有者．プロファイル <> システム管理者
                // ②：商談．商談ステータス = 未割当
                if (String.IsNotBlank(o.OwnerId) && 
                    ownerMap.get(o.OwnerId) != NULL && 
                    (  ownerMap.get(o.OwnerId).Profile.Name != PROFILE_SYSTEMADMIN_NAME_EN
                    && ownerMap.get(o.OwnerId).Profile.Name != PROFILE_SYSTEMADMIN_NAME_JP)
                   && o.StageName == '未割当') {
                    // 適正でない
                    // 商談ステータス更新
                    // 商談ステータス = 未対応
                    o.StageName = '未対応';
                }
                
                // 架電禁止取引先判定
                // 条件：
                // 取引先．取引先ステータス = '架電禁止'
                if(accMap.get(o.AccountId) != NULL
                && accMap.get(o.AccountId).OperationType__c == '架電禁止') {
                    // 架電禁止である
                    // 商談ステータス更新
                    // 商談ステータス = 対応終了
                    o.StageName = '対応終了';
                    // クローズ種別 = 対応打ち切り
                    o.CloseType__c = '対応打ち切り';
                    // クローズ理由 = 取引先架電禁止
                    o.CloseReason__c = '取引先架電禁止';
                }
                
                // 申込なしクローズ商談判定
                // 申込なしクローズ商談？
                // 条件：① AND（ ② AND ③ ）
                // ①：商談．商談ステータス = 対応終了
                // ②：商談．最新見込確度 <> 申込済み
                // ③：商談．最新見込確度 <> 申込なし
                if(o.StageName == '対応終了'
                && (  o.RecentProbability__c != '申込済み'
                   && o.RecentProbability__c != '申込なし')) {
                   // 該当する
                   // 最新見込確度更新
                   // 最新見込確度 = 申込なし
                   o.RecentProbability__c = '申込なし';
                }
            }
        }
    }
    
    
    /**
     * 商談更新前処理
     * @param List<Opportunity>
     * @param Map<Id, Opportunity>
     * @return 
     */
    public void onBeforeUpdateProcess(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){
        
        // 商談のレコードタイプマップを取得(By RecordTypeId)
        Map<Id, Schema.RecordTypeInfo> oppRecordTypeMapById = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosById();
        // 商談のレコードタイプマップを取得(By RecordTypeName)
        Map<String, Schema.RecordTypeInfo> oppRecordTypeMapByName = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosByName();
        
        // 商談の汎用レコードタイプIDを取得
        Id oppHanyoRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hanyo').getRecordTypeId();
        
        // 取引先名対象を抽出
        Set<Id> accountIdSet = new Set<Id>();
        // 商談．所有者対象を抽出
        Set<Id> ownerIdSet = new Set<Id>();
        for(Opportunity o : oppList) {
            // （更新）商談．取引先名取得
            if(String.IsNotBlank(o.AccountId)){
                accountIdSet.add(o.AccountId);
            }
            // （更新）商談．所有者取得
            ownerIdSet.add(o.OwnerId);
            if (String.IsNotBlank(o.OwnerForBulkChange__c))
                ownerIdSet.add(o.OwnerForBulkChange__c);
        }
        
        // （更新）商談．所有者．プロファイル取得
        Map<Id, User> ownerMap = new Map<Id, User>  (
                                                        [
                                                            SELECT Id
                                                                 , Profile.Name
                                                              FROM User
                                                             WHERE Id IN :ownerIdSet
                                                        ]
                                                    );
        
        // 同じ取引先名が参照している商談を抽出
        List<Opportunity> duplicateOppList = [
                                                    SELECT Id
                                                         , RecordTypeId
                                                         , RecordType.Name
                                                         , AccountId
                                                    FROM Opportunity
                                                    WHERE AccountId IN : accountIdSet
                                                      AND StageName != '対応終了'
                                                 ORDER BY CampaignDateTime__c DESC
                                             ];
        
        // 同じ取引先名に関連する商談
        Map<Id, List<Opportunity>> accOppMap = new Map<Id, List<Opportunity>>();
        for(Opportunity o : duplicateOppList) {
            if (accOppMap.get(o.AccountId) == NULL) {
                List<Opportunity> lst = new List<Opportunity>();
                lst.add(o);
                accOppMap.put(o.AccountId, lst);
            }
            else {
                accOppMap.get(o.AccountId).add(o);
            }
        }
        
        // 関連先取引先レコード取得
        // 条件：
        // 取引先．Id = 商談．取引先名
        Map<Id, Account> accMap = new Map<Id, Account>(
                                                        [
                                                            SELECT Id
                                                                 , OperationType__c
                                                              FROM Account
                                                             WHERE Id IN : accountIdSet
                                                        ]
                                                       );
        
        Boolean bHasError = false;
        for (Opportunity o : oppList) {
            bHasError = false;
            
            // レコードタイプ一致判定
            Boolean bRecordTypeChanged = false;
            // レコードタイプが変更された？
            // 条件：
            //（更新前）商談．レコードタイプ<>（更新後）商談．レコードタイプ
            if(o.RecordTypeId != oldMap.get(o.Id).RecordTypeId) {
                // レコードタイプ（一括変更用）更新
                // 商談レコードタイプ（一括変更用） = 商談．レコードタイプ
                o.RecordTypeForBulkChange__c = oppRecordTypeMapById.get(o.RecordTypeId).getName();
                bRecordTypeChanged = true;
            }
            else {
                // レコードタイプ（一括変更用）変更判定
                // 条件：
                //（更新前）商談．レコードタイプ（一括変更用）<>（更新後）商談．レコードタイプ（一括変更用）
                if (String.IsNotBlank(o.RecordTypeForBulkChange__c) && 
                    o.RecordTypeForBulkChange__c != oldMap.get(o.Id).RecordTypeForBulkChange__c) {
                    // レコードタイプ更新
                    // 商談レコードタイプ = 商談．レコードタイプ（一括変更用）
                    o.RecordTypeId = oppRecordTypeMapByName.get(o.RecordTypeForBulkChange__c).getRecordTypeId();
                    bRecordTypeChanged = true;
                }
            }
            
            // レコードタイプ一致判定
            if (bRecordTypeChanged) {
                // 汎用商談の切り替え判定
                // 汎用商談からの変更？
                // 条件：① AND ( ② OR ③ ）
                // ①：（更新前）商談．レコードタイプ = 汎用
                // ②：（更新後）商談．レコードタイプ <> 汎用
                // ③：（更新後）商談．レコードタイプ（一括変更用）<> 汎用
                if(oldMap.get(o.Id).RecordTypeId == oppHanyoRecordTypeId
                && (  (String.IsNotBlank(o.RecordTypeId) && 
                       o.RecordTypeId != oppHanyoRecordTypeId)
                   || (String.IsNotBlank(o.RecordTypeForBulkChange__c) && 
                       oppRecordTypeMapByName.get(o.RecordTypeForBulkChange__c).getRecordTypeId() != oppHanyoRecordTypeId))) {
                   // Do Next Process for this Opportunity
                }
                else {
                    // 汎用商談以外のレコードタイプを変更する
                    // エラーメッセージ表示
                    o.addError('汎用商談以外のレコードタイプを変更することはできません。');
                    
                    // 更新処理中止
                    bHasError = true;
                }
                
                // If Error, Process Next Opportunity
                if (bHasError)
                    continue;
                    // NOTREACHED
                
                // 重複商談取得
                // 条件：
                // ①：商談．取引先名 = （更新後）商談．取引先名
                // ②：商談．レコードタイプ = （更新後）商談．レコードタイプ
                // ③：商談．商談ステータス <> 対応終了
                if(accOppMap.get(o.AccountId) != NULL) {
                    List<Opportunity> otherOppList = accOppMap.get(o.AccountId);
                    for (Opportunity otherOpp : otherOppList) {
                        if(o.RecordTypeId == otherOpp.RecordTypeId) {
                            // 重複商談が存在する
                            // 移行先商談取得
                            // 取得した商談レコードのうち、キャンペーン日時が最新のレコード
                            // 汎用商談更新
                            // 商談ステータス = 対応終了
                            o.StageName = '対応終了';
                            // クローズ種別 = 対応打ち切り
                            o.CloseType__c = '対応打ち切り';
                            // クローズ理由 = 他商談にて対応
                            o.CloseReason__c = '他商談にて対応';
                            // 商談レコードタイプ = 汎用
                            // 重複商談が存在するため商談レコードタイプ = 汎用に設定する
                            o.RecordTypeId = oppHanyoRecordTypeId;
                            // 最新見込確度 = 申込なし
                            o.RecentProbability__c = '申込なし';
                            // 移行先商談 = 取得した移行先商談レコードのSalesforceID
                            o.DestinationOpportunity__c = otherOpp.Id;
                            
                            // 取得した商談レコードのうち、キャンペーン日時が最新のレコード
                            break;
                            // NOTREACHED
                        }
                    }
                }
            }
            
            // 商談所有者変更判定
            // 商談所有者が変更された？
            // 条件：
            //（更新前）商談．商談所有者<>（更新後）商談．商談所有者
            if(o.OwnerId != oldMap.get(o.Id).OwnerId) {
                // 商談所有者（一括変更用）更新
                // 商談所有者（一括変更用） = 商談．商談所有者
                o.OwnerForBulkChange__c = o.OwnerId;
            }
            else {
                // 商談所有者（一括変更用）変更判定
                // 商談所有者（一括変更用）が変更された？
                // 条件：
                //（更新前）商談．商談所有者（一括変更用）<>（更新後）商談．商談所有者（一括変更用）
                if (String.IsNotBlank(o.OwnerForBulkChange__c) && 
                    o.OwnerForBulkChange__c != oldMap.get(o.Id).OwnerForBulkChange__c) {
                    // 商談所有者更新
                    // 商談．商談所有者 = 商談．商談所有者（一括変更用）
                    o.OwnerId = o.OwnerForBulkChange__c;
                }
            }
            
            // TSR割当商談のステータスは適正？
            // 商談ステータス整合性判定（未対応）
            // 条件：① AND ②
            // ①：商談．所有者．プロファイル <> システム管理者
            // ②：商談．商談ステータス = 未割当
            if (String.IsNotBlank(o.OwnerId) && 
                ownerMap.get(o.OwnerId) != NULL && 
                (  ownerMap.get(o.OwnerId).Profile.Name != PROFILE_SYSTEMADMIN_NAME_EN
                && ownerMap.get(o.OwnerId).Profile.Name != PROFILE_SYSTEMADMIN_NAME_JP)
               && o.StageName == '未割当') {
                // 適正でない
                // 商談ステータス更新（未対応）
                // 商談ステータス = 未対応
                o.StageName = '未対応';
            }
            
            // 対応開始商談のステータスは適正？
            // 商談ステータス整合性判定（対応中）
            // 条件：① AND ②
            // ①：（更新前）商談．初回対応日時 = NULL
            // ②：（更新後）商談．初回対応日時 <> NULL
            if(o.FirstCallDateTime__c != NULL
            && oldMap.get(o.Id).FirstCallDateTime__c == NULL) {
                // 適正でない
                // 商談ステータス更新（対応中）
                // 商談ステータス = 対応中
                o.StageName = '対応中';
            }
            
            // 申込なしクローズ商談判定
            // 申込なしクローズ商談？
            // 条件：① AND ② AND（ ③ OR ④ ）
            // ①：（更新前）商談．商談ステータス <> 対応終了
            // ②：（更新後）商談．商談ステータス = 対応終了
            // ③：（更新後）商談．最新見込確度 <> 申込済み
            // ④：（更新後）商談．最新見込確度 <> 申込なし
            if(o.StageName == '対応終了'
            && oldMap.get(o.Id).StageName != '対応終了'
            && (  o.RecentProbability__c != '申込済み'
               && o.RecentProbability__c != '申込なし')) {
               // 該当する
               // 最新見込確度更新
               // 最新見込確度 = 申込なし
               o.RecentProbability__c = '申込なし';
            }
        }
    }
    
    
    /**
     * 商談作成・更新後処理
     * @param List<Opportunity>
     * @param Map<Id, Opportunity>
     * @return 
     */
    public void onAfterProcess(List<Opportunity> oppList, Map<Id, Opportunity> oldMap){
        
        // 商談のレコードタイプマップを取得(By DeveloperName)
        Map<String, Schema.RecordTypeInfo> oppRecordTypeMapByDevName = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        
        // 商談の汎用レコードタイプIDを取得
        Id oppHanyoRecordTypeId = oppRecordTypeMapByDevName.get('Hanyo').getRecordTypeId();
        // 商談の生保レコードタイプIDを取得
        Id oppSeihoRecordTypeId = oppRecordTypeMapByDevName.get('Seiho').getRecordTypeId();
        // 商談の損保レコードタイプIDを取得
        Id oppSonpoRecordTypeId = oppRecordTypeMapByDevName.get('Sonpo').getRecordTypeId();
        // 商談の少短レコードタイプIDを取得
        Id oppSyotanRecordTypeId = oppRecordTypeMapByDevName.get('Syotan').getRecordTypeId();
        
        // 移行先商談対象を抽出
        Set<Id> destOppIdSet = new Set<Id>();
        // 取引先名対象を抽出
        Set<Id> accountIdSet = new Set<Id>();
        for(Opportunity o : oppList) {
            // 商談．取引先名取得
            if(String.IsNotBlank(o.AccountId)){
                accountIdSet.add(o.AccountId);
            }
            
            // 移行先商談取得
            if(String.IsNotBlank(o.DestinationOpportunity__c)
            && (  oldMap == NULL
               || o.DestinationOpportunity__c != oldMap.get(o.Id).DestinationOpportunity__c)) {
                destOppIdSet.add(o.DestinationOpportunity__c);
            }
        }
        
        // 移行先商談取得
        Map<Id, Opportunity> destOppMap = new Map<Id, Opportunity>(
                                                [
                                                    SELECT Id
                                                        , InflowRoute__c        // リードソース
                                                        , CampaignDateTime__c   // キャンペーン日時
                                                        , MiniUpdateDate__c     // ミニ保険更新日時
                                                        , Question1__c          // 質問1
                                                        , Question2__c          // 質問2
                                                        , Question3__c          // 質問3
                                                        , Question4__c          // 質問4
                                                        , Question5__c          // 質問5
                                                        , Question6__c          // 質問6
                                                        , Question7__c          // 質問7
                                                        , Question8__c          // 質問8
                                                        , Question9__c          // 質問9
                                                        , Question10__c         // 質問10
                                                        , Answer1__c            // 回答1
                                                        , Answer2__c            // 回答2
                                                        , Answer2_1__c          // 回答2-1
                                                        , Answer2_2__c          // 回答2-2
                                                        , Answer3__c            // 回答3
                                                        , Answer4__c            // 回答4
                                                        , Answer5__c            // 回答5
                                                        , Answer6__c            // 回答6
                                                        , Answer7__c            // 回答7
                                                        , Answer8__c            // 回答8
                                                        , Answer9__c            // 回答9
                                                        , Answer10__c           // 回答10
                                                        , DateSource__c         // データソース名
                                                        , ExLeadUpdateDate__c   // 外部データソース更新日時
                                                        , Item1__c              // 項目(1)
                                                        , Item2__c              // 項目(2)
                                                        , Item3__c              // 項目(3)
                                                        , Item4__c              // 項目(4)
                                                        , Item5__c              // 項目(5)
                                                        , Item6__c              // 項目(6)
                                                        , Item7__c              // 項目(7)
                                                        , Item8__c              // 項目(8)
                                                        , Item9__c              // 項目(9)
                                                        , Item10__c             // 項目(10)
                                                        , ItemLong1__c          // 項目ロング(1)
                                                        , ItemLong2__c          // 項目ロング(2)
                                                        , ItemLong3__c          // 項目ロング(3)
                                                        , ItemLong4__c          // 項目ロング(4)
                                                        , ItemLong5__c          // 項目ロング(5)
                                                        , ItemLong6__c          // 項目ロング(6)
                                                        , ItemLong7__c          // 項目ロング(7)
                                                        , ItemLong8__c          // 項目ロング(8)
                                                        , ItemLong9__c          // 項目ロング(9)
                                                        , ItemLong10__c         // 項目ロング(10)
                                                        , Date__c               // 日付
                                                    FROM Opportunity
                                                    WHERE Id IN : destOppIdSet
                                                ]);
        
        // 更新する商談のID
        Set<String> updOppIdSet = new Set<String>();
        //  更新するミニ保険に関連する商談のID
        Map<String, String> updMiniOppIdMap = new Map<String, String>();
        //  更新する外部データソースに関連する商談のID
        Map<String, String> updExtOppIdMap = new Map<String, String>();
        Boolean bHasError = false;
        Boolean bIsDestOppUpdated = false;
        for (Opportunity o : oppList) {
            bHasError = false;
            bIsDestOppUpdated = false;
            
            // 移行先商談判定
            // 移行先商談が設定されている？
            // 条件：①AND②
            // （作成または更新後）商談．移行先商談 <> null
            // （作成または更新前）商談．移行先商談 <> （作成または更新後）商談．移行先商談
            if(String.IsNotBlank(o.DestinationOpportunity__c)
            && (  oldMap == NULL
               || o.DestinationOpportunity__c != oldMap.get(o.Id).DestinationOpportunity__c)) {
                // 移行先商談更新
                // 設定されている
                // 移行先商談取得
                Opportunity destOpp = destOppMap.get(o.DestinationOpportunity__c);
                
                // キャンペーン日時比較
                // 条件：
                //（移行先商談で取得した）商談．キャンペーン日時 >（作成または更新）商談．キャンペーン日時
                if(o.CampaignDateTime__c != NULL
                && destOpp != NULL
                && destOpp.CampaignDateTime__c != NULL
                && destOpp.CampaignDateTime__c > o.CampaignDateTime__c) {
                    // 該当する
                    // キャンペーン情報セット
                    // 移行先商談．リードソース =（作成または更新）商談．リードソース
                    destOpp.InflowRoute__c = o.InflowRoute__c;
                    // 移行先商談．キャンペーン日時 =（作成または更新）商談．キャンペーン日時
                    destOpp.CampaignDateTime__c = o.CampaignDateTime__c;
                    // 移行先商談．完了予定日 =（作成または更新前）商談．完了予定日
                    if (oldMap != NULL)
                        destOpp.CloseDate = oldMap.get(o.Id).CloseDate;
                    else
                        destOpp.CloseDate = o.CloseDate;
                    
                    // 更新する商談のIDとして追加
                    updOppIdSet.add(destOpp.Id);
                }
                
                // ミニ保険情報は入力されている？
                // ミニ保険データ入力確認
                // 条件：① AND ②
                // ①：（移行先商談で取得した）商談．ミニ保険更新日時 = null
                // ②：（作成または更新）商談．ミニ保険更新日時 <> null
                if(o.MiniUpdateDate__c != NULL
                && destOpp != NULL
                && destOpp.MiniUpdateDate__c == NULL) {
                    // 入力されている
                    // ミニ保険情報セット
                    // 移行先商談．ミニ保険更新日時 = （作成または更新）商談．ミニ保険更新日時
                    destOpp.MiniUpdateDate__c = o.MiniUpdateDate__c;
                    // 移行先商談．質問 = （作成または更新）商談．質問
                    destOpp.Question1__c = o.Question1__c;
                    destOpp.Question2__c = o.Question2__c;
                    destOpp.Question3__c = o.Question3__c;
                    destOpp.Question4__c = o.Question4__c;
                    destOpp.Question5__c = o.Question5__c;
                    destOpp.Question6__c = o.Question6__c;
                    destOpp.Question7__c = o.Question7__c;
                    destOpp.Question8__c = o.Question8__c;
                    destOpp.Question9__c = o.Question9__c;
                    destOpp.Question10__c = o.Question10__c;
                    // 移行先商談．回答 = （作成または更新）商談．回答
                    destOpp.Answer1__c = o.Answer1__c;
                    destOpp.Answer2__c = o.Answer2__c;
                    destOpp.Answer2_1__c = o.Answer2_1__c;
                    destOpp.Answer2_2__c = o.Answer2_2__c;
                    destOpp.Answer3__c = o.Answer3__c;
                    destOpp.Answer4__c = o.Answer4__c;
                    destOpp.Answer5__c = o.Answer5__c;
                    destOpp.Answer6__c = o.Answer6__c;
                    destOpp.Answer7__c = o.Answer7__c;
                    destOpp.Answer8__c = o.Answer8__c;
                    destOpp.Answer9__c = o.Answer9__c;
                    destOpp.Answer10__c = o.Answer10__c;
                    
                    // 更新する商談のIDとして追加
                    updOppIdSet.add(destOpp.Id);
                    // 更新するミニ保険に関連する商談のIDとして追加
                    updMiniOppIdMap.put(o.Id, destOpp.Id);
                }
                
                // 外部データソース情報は入力されている？
                // 外部データソースデータ入力確認
                // 条件：
                // ①：（移行先商談で取得した）商談．外部データソース更新日時 = null
                // ②：（作成または更新）商談．外部データソース更新日時 <> null
                if(o.ExLeadUpdateDate__c != NULL
                && destOpp != NULL
                && destOpp.ExLeadUpdateDate__c == NULL) {
                    // されている
                    // 外部データソース情報セット
                    // 移行先商談．データソース名 = （作成または更新）商談．データソース名
                    destOpp.DateSource__c = o.DateSource__c;
                    // 移行先商談．外部データソース更新日時 = （作成または更新）商談．外部データソース更新日時
                    destOpp.ExLeadUpdateDate__c = o.ExLeadUpdateDate__c;
                    // 移行先商談．項目 = （作成または更新）商談．項目
                    destOpp.Item1__c = o.Item1__c;
                    destOpp.Item2__c = o.Item2__c;
                    destOpp.Item3__c = o.Item3__c;
                    destOpp.Item4__c = o.Item4__c;
                    destOpp.Item5__c = o.Item5__c;
                    destOpp.Item6__c = o.Item6__c;
                    destOpp.Item7__c = o.Item7__c;
                    destOpp.Item8__c = o.Item8__c;
                    destOpp.Item9__c = o.Item9__c;
                    destOpp.Item10__c = o.Item10__c;
                    // 移行先商談．項目ロング = （作成または更新）商談．項目ロング
                    destOpp.ItemLong1__c = o.ItemLong1__c;
                    destOpp.ItemLong2__c = o.ItemLong2__c;
                    destOpp.ItemLong3__c = o.ItemLong3__c;
                    destOpp.ItemLong4__c = o.ItemLong4__c;
                    destOpp.ItemLong5__c = o.ItemLong5__c;
                    destOpp.ItemLong6__c = o.ItemLong6__c;
                    destOpp.ItemLong7__c = o.ItemLong7__c;
                    destOpp.ItemLong8__c = o.ItemLong8__c;
                    destOpp.ItemLong9__c = o.ItemLong9__c;
                    destOpp.ItemLong10__c = o.ItemLong10__c;
                    // 移行先商談．日付 = （作成または更新）商談．日付
                    destOpp.Date__c = o.Date__c;
                    
                    // 更新する商談のIDとして追加
                    updOppIdSet.add(destOpp.Id);
                    // 更新する外部データソースに関連する商談のIDとして追加
                    updExtOppIdMap.put(o.Id, destOpp.Id);
                }
            }
        }
        
        if (updMiniOppIdMap.size() > 0) {
            // ミニ保険レコード取得
            List<MiniInsurance__c> miniList = [
                                                SELECT Id
                                                     , OpportunityId__c
                                                  FROM MiniInsurance__c
                                                 WHERE OpportunityId__c IN :updMiniOppIdMap.keySet()
                                              ];
            // 取得したミニ保険レコードを更新
            for (MiniInsurance__c mini : miniList) {
                // ミニ保険更新．商談 = （作成または更新）商談．移行先商談
                mini.OpportunityId__c = updMiniOppIdMap.get(mini.OpportunityId__c);
            }
            // ミニ保険更新
            update miniList;
        }
        
        if (updExtOppIdMap.size() > 0) {
            // 外部データソースレコード取得
            List<Externaldatasource__c> extList = [
                                                    SELECT Id
                                                         , OpportunityId__c
                                                      FROM Externaldatasource__c
                                                     WHERE OpportunityId__c IN :updExtOppIdMap.keySet()
                                                  ];
            // 取得した外部データソースレコードを更新
            for (Externaldatasource__c ext : extList) {
                // 外部データソース更新．商談 = （作成または更新）商談．移行先商談
                ext.OpportunityId__c = updExtOppIdMap.get(ext.OpportunityId__c);
            }
            // 外部データソース更新
            update extList;
        }
        
        // 上記処理にて設定された値で移行先商談を更新
        // 更新する商談のIDをもとに商談をリストアップ
        if (updOppIdSet.size() > 0) {
            Map<Id, Opportunity> updatedDestOppMap = new Map<Id, Opportunity>();
            for (Id oId : updOppIdSet) {
                if (updatedDestOppMap.get(oId) == NULL)
                    updatedDestOppMap.put(oId, destOppMap.get(oId));
            }
            // 移行先商談更新
            update updatedDestOppMap.values();
        }
        
        // 商談対応を終了した取引先IDリスト
        Set<Id> closedAccountIds = new Set<Id>();
        // 取引先更新リスト
        List<Id> updatedAccIds = new List<Id>();
        // 関連先取引先取得
        // 関連先取引先レコード取得
        // 条件：
        // 取引先．Id = 商談．取引先名
        Map<Id, Account> accMap = new Map<Id, Account>(
                                                        [
                                                            SELECT Id
                                                                 , OperationType__c
                                                                 , OpportunityStatus__c
                                                                 , MeetingSalesflg__c
                                                                 , StopCallingFlg__c
                                                              FROM Account
                                                             WHERE Id IN : accountIdSet
                                                        ]
                                                       );
        Boolean bIsAccUpdated = false;
        for (Opportunity o : oppList) {
            bIsAccUpdated = false;
            if(String.IsNotBlank(o.AccountId)
            && accMap.get(o.AccountId) != NULL) {
                Account a = accMap.get(o.AccountId);
                
                // 対面誘導に成功した顧客？
                // 対面販売フラグ設定判定
                // 条件：① AND ② AND ③
                // ①：取引先．対面販売フラグ = False
                // ②：商談．最新対応結果（中分類）= 対面誘導
                // ③：商談．最新対応結果（小分類）= 了承
                if(!a.MeetingSalesflg__c
                && o.RecentResultType_Middle__c == '対面誘導'
                && o.RecentResultType_Small__c == '了承') {
                    // 対面販売フラグセット
                    // 取引先更新
                    // 取引先．対面販売フラグ = TRUE
                    a.MeetingSalesflg__c = TRUE;
                    bIsAccUpdated = true;
                }
                
                // 未割当商談が作成された？
                // 商談ステータス更新判定
                // 条件：① AND ②
                // ①：（更新後）商談．商談ステータス = 未割当
                // ②：取引先．取引先ステータス = 有効商談なし
                if(a.OperationType__c == '有効商談なし'
                && o.StageName == '未割当') {
                    // 取引先ステータスセット（割当可）
                    // 取引先ステータス更新（割当可）
                    // 取引先．取引先ステータス = '割当可'
                    a.OperationType__c = '割当可';
                    // 取引先．対応状況 = '未対応'
                    a.OpportunityStatus__c = '未対応';
                    bIsAccUpdated = true;
                }
                else 
                    // 商談対応を開始した？
                    // 商談ステータス更新判定
                    // 条件：（① OR ② OR ③）AND（④ OR ⑤）AND（⑥ AND ⑦）
                    // ①：After Insertトリガ
                    // ②：（更新前）商談．商談ステータス = 未割当
                    // ③：（更新前）商談．商談ステータス = 対応終了
                    // ④：（更新後）商談．商談ステータス = 未対応
                    // ⑤：（更新後）商談．商談ステータス = 対応中
                    // ⑥：取引先．取引先ステータス <> 対応中
                    // ⑦：取引先．取引先ステータス <> 架電禁止
                if( (  oldMap == NULL
                    || oldMap.get(o.Id).StageName == '未割当'
                    || oldMap.get(o.Id).StageName == '対応終了')
                &&  (  o.StageName == '未対応'
                    || o.StageName == '対応中')
                &&  (  a.OperationType__c <> '対応中'
                    && a.OperationType__c <> '架電禁止')) {
                    // 取引先ステータスセット（対応中）
                    // 取引先ステータス更新（対応中）
                    // 取引先．取引先ステータス = '対応中'
                    a.OperationType__c = '対応中';
                    // 商談．レコードタイプが「生保」の場合
                    // 取引先．対応状況 = '生保フォロー中'
                    if (o.RecordTypeId == oppSeihoRecordTypeId) a.OpportunityStatus__c = '生保フォロー中';
                    // 商談．レコードタイプが「損保」の場合
                    // 取引先．対応状況 = '損保フォロー中'
                    if (o.RecordTypeId == oppSonpoRecordTypeId) a.OpportunityStatus__c = '損保フォロー中';
                    // 商談．レコードタイプが「少短」の場合
                    // 取引先．対応状況 = '少短フォロー中'
                    if (o.RecordTypeId == oppSyotanRecordTypeId) a.OpportunityStatus__c = '少短フォロー中';
                    bIsAccUpdated = true;
                }
                else 
                    // 商談対応を終了した？
                    // 商談ステータス更新判定
                    // 条件：（① OR ②）AND ③ AND ④
                    // ①：After Insertトリガ
                    // ②：（更新前）商談．商談ステータス<>対応終了
                    // ③：（更新後）商談．商談ステータス=対応終了
                    // ④：取引先．取引先ステータス<>架電禁止
                if( (  oldMap == NULL
                    || oldMap.get(o.Id).StageName != '対応終了')
                &&  o.StageName == '対応終了'
                &&  a.OperationType__c != '架電禁止') {
                    // 取引先に関連する商談を取得
                    closedAccountIds.add(a.Id);
                }
                
                // 架電禁止依頼が更新されている？
                // 架電禁止依頼更新判定条件：① OR ②
                // ①：After Insertトリガ
                // ②：（更新前）商談．架電禁止依頼<>（更新後）商談．架電禁止依頼
                if(oldMap == NULL
                || oldMap.get(o.Id).StopCallingList__c != o.StopCallingList__c) {
                    
                    // 永続的な架電禁止？
                    // 永続的な架電禁止判定
                    // 条件：
                    //（作成または更新後）商談．架電禁止依頼 = 永続的な架電禁止
                    if (o.StopCallingList__c == '永続的な架電禁止') {
                        // 永続的な架電禁止情報セット
                        // 取引先．取引先ステータス = '架電禁止'
                        a.OperationType__c = '架電禁止';
                        // 取引先．対応状況 = '全商談終了'
                        a.OpportunityStatus__c = '全商談終了';
                        // 取引先．架電停止フラグ = TRUE
                        a.StopCallingFlg__c = TRUE;
                        bIsAccUpdated = true;
                    }
                    else
                        // 進行中商談の全終了？
                        // 進行中商談の全終了判定
                        // 条件：
                        //（作成または更新後）商談．架電禁止依頼 = 進行中商談の全終了
                    if (o.StopCallingList__c == '進行中商談の全終了') {
                        // 進行中商談の全終了情報セット
                        // 取引先．取引先ステータス = '有効商談なし'
                        a.OperationType__c = '有効商談なし';
                        // 取引先．対応状況 = '全商談終了'
                        a.OpportunityStatus__c = '全商談終了';
                        bIsAccUpdated = true;
                    }
                }
                
                // 更新する取引先のIDとして追加
                if (bIsAccUpdated)
                    updatedAccIds.add(a.Id);
            }
        }
        
        if (closedAccountIds.size() > 0) {
            Map<Id, Id> updatedClosedAccIds = new Map<Id, Id>();
            // 取引先に関連する商談を取得
            List<Opportunity> otherOppList =    [
                                                    SELECT Id
                                                         , RecordTypeId
                                                         , StageName
                                                         , CampaignDateTime__c
                                                         , AccountId
                                                      FROM Opportunity
                                                     WHERE AccountId IN :closedAccountIds
                                                  ORDER BY CampaignDateTime__c DESC
                                                ];
            Map<Id, List<Opportunity>> accOtherOppMap = new Map<Id, List<Opportunity>>();
            for (Opportunity otherOpp : otherOppList) {
                if (accOtherOppMap.get(otherOpp.AccountId) == NULL) {
                    List<Opportunity> olist = new List<Opportunity>();
                    olist.add(otherOpp);
                    accOtherOppMap.put(otherOpp.AccountId, olist);
                }
                else {
                    accOtherOppMap.get(otherOpp.AccountId).add(otherOpp);
                }
            }
            
            
            // 取引先に関連する商談を取得
            for (Id closedAccountId : closedAccountIds) {
                List<Opportunity> accOppList = accOtherOppMap.get(closedAccountId);
                
                // 割当済商談取得
                // 最新商談を取得
                // 取得した商談レコードから、キャンペーン日時が最新のレコードを取得
                for (Opportunity o : accOppList) {
                    if(String.IsNotBlank(o.AccountId)
                    && accMap.get(o.AccountId) != NULL
                    && updatedClosedAccIds.get(o.AccountId) == NULL) {
                        Account a = accMap.get(o.AccountId);
                        // 取引先ステータス更新（終了後_対応中）
                        // 取引先ステータスセット（終了後_対応中）
                        if(o.StageName == '未対応' 
                        || o.StageName == '対応中') {
                            // 取引先．取引先ステータス = '対応中'
                            a.OperationType__c = '対応中';
                            // 商談．レコードタイプが「生保」の場合
                            // 取引先．対応状況 = '生保フォロー中'
                            if (o.RecordTypeId == oppSeihoRecordTypeId) a.OpportunityStatus__c = '生保フォロー中';
                            // 商談．レコードタイプが「損保」の場合
                            // 取引先．対応状況 = '損保フォロー中'
                            if (o.RecordTypeId == oppSonpoRecordTypeId) a.OpportunityStatus__c = '損保フォロー中';
                            // 商談．レコードタイプが「少短」の場合
                            // 取引先．対応状況 = '少短フォロー中'
                            if (o.RecordTypeId == oppSyotanRecordTypeId) a.OpportunityStatus__c = '少短フォロー中';
                            
                            // 更新する取引先のIDとして追加
                            updatedAccIds.add(a.Id);
                            // 最新商談を取得の為
                            updatedClosedAccIds.put(a.Id, a.Id);
                        }
                    }
                }
                
                // 未割当商談取得
                for (Opportunity o : accOppList) {
                    if(String.IsNotBlank(o.AccountId)
                    && accMap.get(o.AccountId) != NULL
                    && updatedClosedAccIds.get(o.AccountId) == NULL) {
                        Account a = accMap.get(o.AccountId);
                        // 取引先ステータス更新（終了後_割当可）
                        // 取引先ステータスセット（終了後_割当可）
                        if(o.StageName == '未割当') {
                            // 取引先．取引先ステータス = '割当可'
                            a.OperationType__c = '割当可';
                            // 取引先．対応状況 = '対応継続可'
                            a.OpportunityStatus__c = '対応継続可';
                            
                            // 更新する取引先のIDとして追加
                            updatedAccIds.add(a.Id);
                            // 最新商談を取得の為
                            updatedClosedAccIds.put(a.Id, a.Id);
                        }
                    }
                }
                
                // 割当済商談が存在しない
                // 未割当商談が存在しない
                // 商談．商談ステータス<>未対応
                // 商談．商談ステータス<>対応中
                // 商談．商談ステータス<>未割当
                for (Opportunity o : accOppList) {
                    if(String.IsNotBlank(o.AccountId)
                    && accMap.get(o.AccountId) != NULL
                    && updatedClosedAccIds.get(o.AccountId) == NULL) {
                        Account a = accMap.get(o.AccountId);
                        // 取引先ステータス更新（終了後_有効商談なし）
                        // 取引先ステータスセット（終了後_有効商談なし）
                        // 取引先．取引先ステータス = '有効商談なし'
                        a.OperationType__c = '有効商談なし';
                        // 取引先．対応状況 = '全商談終了'
                        a.OpportunityStatus__c = '全商談終了';
                        
                        // 更新する取引先のIDとして追加
                        updatedAccIds.add(a.Id);
                        // 最新商談を取得の為
                        updatedClosedAccIds.put(a.Id, a.Id);
                    }
                }
            }
        }
        
        // 上記処理にて設定された値で取引先を更新
        if (updatedAccIds.size() > 0) {
            Map<Id, Account> updatedAccMap = new Map<Id, Account>();
            for (Id aId : updatedAccIds) {
                if (updatedAccMap.get(aId) == NULL)
                    updatedAccMap.put(aId, accMap.get(aId));
            }
            // 取引先更新
            update updatedAccMap.values();
        }
    }
    
    
    /**
     * 商談削除後処理
     * @param List<Opportunity>
     * @return 
     */
    public void onAfterDeleteProcess(List<Opportunity> oppList){
        
        // 商談のレコードタイプマップを取得(By DeveloperName)
        Map<String, Schema.RecordTypeInfo> oppRecordTypeMapByDevName = 
                Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        
        // 商談の汎用レコードタイプIDを取得
        Id oppHanyoRecordTypeId = oppRecordTypeMapByDevName.get('Hanyo').getRecordTypeId();
        // 商談の生保レコードタイプIDを取得
        Id oppSeihoRecordTypeId = oppRecordTypeMapByDevName.get('Seiho').getRecordTypeId();
        // 商談の損保レコードタイプIDを取得
        Id oppSonpoRecordTypeId = oppRecordTypeMapByDevName.get('Sonpo').getRecordTypeId();
        // 商談の少短レコードタイプIDを取得
        Id oppSyotanRecordTypeId = oppRecordTypeMapByDevName.get('Syotan').getRecordTypeId();
        
        // 取引先名対象を抽出
        Set<Id> accountIdSet = new Set<Id>();
        for(Opportunity o : oppList) {
            // 商談．取引先名取得
            if(String.IsNotBlank(o.AccountId)){
                accountIdSet.add(o.AccountId);
            }
        }
        
        // 取引先更新リスト
        List<Id> updatedAccIds = new List<Id>();
        // 関連先取引先取得
        // 関連先取引先レコード取得
        // 条件：
        // 取引先．Id = 商談．取引先名
        // 対応可能な取引先？
        // 対応可能取引先判定
        // 条件：
        // 取引先．取引先ステータス <> 架電禁止
        Map<Id, Account> accMap = new Map<Id, Account>(
                                                        [
                                                            SELECT Id
                                                                 , OperationType__c
                                                                 , OpportunityStatus__c
                                                                 , MeetingSalesflg__c
                                                                 , StopCallingFlg__c
                                                              FROM Account
                                                             WHERE Id IN : accountIdSet
                                                               AND OperationType__c != '架電禁止'
                                                        ]
                                                       );
        
        // 対応可能
        if (accMap.size() > 0) {
            Map<Id, Id> updatedAccIdMap = new Map<Id, Id>();
            // 取引先に関連する商談を取得
            List<Opportunity> otherOppList =    [
                                                    SELECT Id
                                                         , RecordTypeId
                                                         , StageName
                                                         , CampaignDateTime__c
                                                         , AccountId
                                                      FROM Opportunity
                                                     WHERE AccountId IN :accMap.keySet()
                                                  ORDER BY CampaignDateTime__c DESC
                                                ];
            Map<Id, List<Opportunity>> accOtherOppMap = new Map<Id, List<Opportunity>>();
            for (Opportunity otherOpp : otherOppList) {
                if (accOtherOppMap.get(otherOpp.AccountId) == NULL) {
                    List<Opportunity> olist = new List<Opportunity>();
                    olist.add(otherOpp);
                    accOtherOppMap.put(otherOpp.AccountId, olist);
                }
                else {
                    accOtherOppMap.get(otherOpp.AccountId).add(otherOpp);
                }
            }
            
            // 取引先に関連する商談を取得
            // 取引先ステータス再設定
            for (Id accId : accMap.keySet()) {
                List<Opportunity> accOppList = accOtherOppMap.get(accId);
                
                // 割当済商談取得
                // 最新商談を取得
                // 取得した商談レコードから、キャンペーン日時が最新のレコードを取得
                if(accOppList != null && !accOppList.isEmpty()){
                   for (Opportunity o : accOppList) {
                        if(String.IsNotBlank(o.AccountId)
                        && accMap.get(o.AccountId) != NULL
                        && updatedAccIdMap.get(o.AccountId) == NULL) {
                            Account a = accMap.get(o.AccountId);
                            // 取引先ステータス更新（対応中）
                            // 取引先ステータスセット（対応中）
                            if(o.StageName == '未対応' 
                            || o.StageName == '対応中') {
                                // 取引先．取引先ステータス = '対応中'
                                a.OperationType__c = '対応中';
                                // 商談．レコードタイプが「生保」の場合
                                // 取引先．対応状況 = '生保フォロー中'
                                if (o.RecordTypeId == oppSeihoRecordTypeId) a.OpportunityStatus__c = '生保フォロー中';
                                // 商談．レコードタイプが「損保」の場合
                                // 取引先．対応状況 = '損保フォロー中'
                                if (o.RecordTypeId == oppSonpoRecordTypeId) a.OpportunityStatus__c = '損保フォロー中';
                                // 商談．レコードタイプが「少短」の場合
                                // 取引先．対応状況 = '少短フォロー中'
                                if (o.RecordTypeId == oppSyotanRecordTypeId) a.OpportunityStatus__c = '少短フォロー中';
                                
                                // 更新する取引先のIDとして追加
                                updatedAccIds.add(a.Id);
                                // 最新商談を取得の為
                                updatedAccIdMap.put(a.Id, a.Id);
                            }
                        }
                    }
                    
                    // 未割当商談取得
                    for (Opportunity o : accOppList) {
                        if(String.IsNotBlank(o.AccountId)
                        && accMap.get(o.AccountId) != NULL
                        && updatedAccIdMap.get(o.AccountId) == NULL) {
                            Account a = accMap.get(o.AccountId);
                            // 取引先ステータス更新（割当可）
                            // 取引先ステータスセット（割当可）
                            if(o.StageName == '未割当') {
                                // 取引先．取引先ステータス = '割当可'
                                a.OperationType__c = '割当可';
                                // 取引先．対応状況 = '対応継続可'
                                a.OpportunityStatus__c = '対応継続可';
                                
                                // 更新する取引先のIDとして追加
                                updatedAccIds.add(a.Id);
                                // 最新商談を取得の為
                                updatedAccIdMap.put(a.Id, a.Id);
                            }
                        }
                    }
                    
                    // 割当済商談が存在しない
                    // 未割当商談が存在しない
                    // 商談．商談ステータス<>未対応
                    // 商談．商談ステータス<>対応中
                    // 商談．商談ステータス<>未割当
                    for (Opportunity o : accOppList) {
                        if(String.IsNotBlank(o.AccountId)
                        && accMap.get(o.AccountId) != NULL
                        && updatedAccIdMap.get(o.AccountId) == NULL) {
                            Account a = accMap.get(o.AccountId);
                            // 取引先ステータス更新（全商談終了）
                            // 取引先ステータスセット（全商談終了）
                            // 取引先．取引先ステータス = '有効商談なし'
                            a.OperationType__c = '有効商談なし';
                            // 取引先．対応状況 = '全商談終了'
                            a.OpportunityStatus__c = '全商談終了';
                            
                            // 更新する取引先のIDとして追加
                            updatedAccIds.add(a.Id);
                            // 最新商談を取得の為
                            updatedAccIdMap.put(a.Id, a.Id);
                        }
                    }
                    
                    // 商談なしの場合
                    if (updatedAccIdMap.get(accId) == NULL) {
                        Account a = accMap.get(accId);
                        // 取引先ステータス更新（商談なし）
                        // 取引先ステータスセット（商談なし）
                        // 取引先．取引先ステータス = '有効商談なし'
                        a.OperationType__c = '有効商談なし';
                        // 取引先．対応状況 = NULL
                        a.OpportunityStatus__c = NULL;
                        
                        // 更新する取引先のIDとして追加
                        updatedAccIds.add(a.Id);
                        // 最新商談を取得の為
                        updatedAccIdMap.put(a.Id, a.Id);
                    }
                }
            }
        }
        
        // 上記処理にて設定された値で取引先を更新
        if (updatedAccIds.size() > 0) {
            Map<Id, Account> updatedAccMap = new Map<Id, Account>();
            for (Id aId : updatedAccIds) {
                if (updatedAccMap.get(aId) == NULL)
                    updatedAccMap.put(aId, accMap.get(aId));
            }
            // 取引先更新
            update updatedAccMap.values();
        }
    }
}