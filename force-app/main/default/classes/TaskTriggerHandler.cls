/*
* @Class Name     : TaskTriggerHandler 
* @Description    : ToDoトリガーハンドラ
* @Created Date   : 2019.04.29
* @Created By     : 
* @Modified Date  : 2020.01.07
* @Modified By    : Valsala Kumar
* @Modified Date  : 2022.05.20
* @Modified By    : Valsala Kumar
* @Description    : 取引先活動の判断追加
*/
public class TaskTriggerHandler {

    // コンストラクタ
    public TaskTriggerHandler() {}
    
    /**
     * ToDo作成前・更新前
     * @param List<Task>
     * @return 
     */
    public void onBeforeProcess(List<Task> taskList, String operation){
        
        // 対象を抽出
        Set<Id> oppIdSet = new Set<Id>();
        List<Task> targetTaskList = new List<Task>();
        for (Task t : taskList) {
            // 商談に関連するToDoのみが対象
            if (t.WhatId != null 
            &&  t.WhatId.getSobjectType().getDescribe().getName() == 'Opportunity'){
                oppIdSet.add(t.WhatId);
                targetTaskList.add(t);
            }
        }
        
        // ToDoが参照している商談を抽出
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id
                ,FirstResultType_Middle__c  // 初回コンタクト結果（中分類）
                ,RecentCallDateTime__c      // 最新対応日時
                ,RecentProbability__c       // 最新見込確度
            FROM Opportunity
            WHERE Id IN : oppIdSet
        ]);
        
        // 更新する商談のID
        Set<String> updIdSet = new Set<String>();
        // ToDo→商談 情報セット
        for (Task t : targetTaskList) {
            
            // If WhatId is Invalid, throw Error
            if (oppMap.get(t.WhatId) == NULL) {
                t.addError('商談:[' + t.WhatId + ']がありません');
                continue;
                // NOTREACHED
            }
            
            // 初回コール判定
            if (t.ResultType_Large__c == '発信'
            &&  String.IsNotBlank(t.ResultType_Middle__c)
            &&  t.ResultType_Middle__c <> '不通'
            &&  t.ResultType_Middle__c <> '問合せ'
            &&  t.ResultType_Middle__c <> '不要'
            &&  t.ResultType_Middle__c <> '申込後架電'
            &&  (  String.IsBlank(oppMap.get(t.WhatId).FirstResultType_Middle__c)
                || oppMap.get(t.WhatId).FirstResultType_Middle__c == '不通'
                || oppMap.get(t.WhatId).FirstResultType_Middle__c == '問合せ'
                || oppMap.get(t.WhatId).FirstResultType_Middle__c == '不要'
                || oppMap.get(t.WhatId).FirstResultType_Middle__c == '申込後架電')) {
                
                // 初回コールフラグセット
                t.FirstCall__c = TRUE;
            }
            
            // 見込確度上昇判定
            if(t.CallDateTime__c >= oppMap.get(t.WhatId).RecentCallDateTime__c
            && String.IsNotBlank(oppMap.get(t.WhatId).RecentProbability__c)) {
                // 活動．見込確度の変換後の値 > 商談．最新見込確度の変換後の値
                // の場合、見込確度上昇フラグセット
                setImprovingProbability(oppMap.get(t.WhatId), t);
            }
        }
    }
    
    
    /**
     * ToDo登録後処理
     * 処理仕様(作成後・更新後処理)
     * @param List<Task>
     * @return 
     */
    public void onAfterProcess(List<Task> taskList, Map<Id, Task> oldMap, String operation){
        
        // 対象を抽出
        Set<Id> oppIdSet = new Set<Id>();
        List<Task> targetTaskList = new List<Task>();
        
        // 対象取引先を抽出
        Set<Id> accIdSet = new Set<Id>();
        List<Task> targetAccountTaskList = new List<Task>();
        
        for (Task t : taskList) {
            // 商談に関連するToDoのみが対象
            /*****20190518 コード修正　開始*********/
            /*if(!String.isBlank(t.WhatId) && String.valueOf(t.WhatId).startsWith('006')) {
                // 商談IDを取得
                oppIdSet.add(t.WhatId);
                targetTaskList.add(t);
            }*/
            if (t.WhatId != null 
            &&  t.WhatId.getSobjectType().getDescribe().getName() == 'Opportunity'){
                oppIdSet.add(t.WhatId);
                targetTaskList.add(t);
            }
            /*****20190518 コード修正　エンド*********/
            
            // 取引先活動の判断
            if (t.WhatId != null 
            &&  t.WhatId.getSobjectType().getDescribe().getName() == 'Account'){
                // 活動は「永続的な架電禁止」に設定されてある場合
                if((oldMap == NULL || 
                    oldMap.get(t.Id).StopCallingList__c != t.StopCallingList__c) && 
                   t.StopCallingList__c == '永続的な架電禁止') {
                    accIdSet.add(t.WhatId);
                    targetAccountTaskList.add(t);
                }
            }
        }
        
        // 取引先活動の判断
        if (accIdSet.size() > 0) {
            // 関連先取引先取得
            // 条件：
            // 取引先．Id = 活動．関連ID
            Map<Id, Account> accMap = new Map<Id, Account>(
                                                            [
                                                                SELECT Id
                                                                     , OperationType__c
                                                                     , OpportunityStatus__c
                                                                     , StopCallingFlg__c
                                                                  FROM Account
                                                                 WHERE Id IN : accIdSet
                                                            ]
                                                           );
            // ToDo→取引先に情報をセット
            // 取引先更新リスト
            List<Id> updatedAccIds = new List<Id>();
            Boolean bIsAccUpdated = false;
            for (Task t : targetAccountTaskList) {
                
                // 「永続的な架電禁止」以外の場合
                if (accMap.get(t.WhatId) == NULL) {
                    continue;
                    // NOTREACHED
                }
                
                Account a = accMap.get(t.WhatId);
                bIsAccUpdated = false;
                
                // 架電禁止依頼更新判定
                // 条件：① OR ②
                // ①：After Insertトリガ
                // ②：（更新前）活動．架電禁止依頼<>（更新後）活動．架電禁止依頼
                if(oldMap == NULL
                || oldMap.get(t.Id).StopCallingList__c != t.StopCallingList__c) {
                    
                    // 永続的な架電禁止判定
                    // 条件：
                    //（作成または更新後）活動．架電禁止依頼 = 永続的な架電禁止
                    if (t.StopCallingList__c == '永続的な架電禁止') {
                        // 永続的な架電禁止情報セット
                        // 取引先．取引先ステータス = '架電禁止'
                        a.OperationType__c = '架電禁止';
                        // 取引先．対応状況 = '全商談終了'
                        a.OpportunityStatus__c = '全商談終了';
                        // 取引先．架電停止フラグ = TRUE
                        a.StopCallingFlg__c = TRUE;
                        bIsAccUpdated = true;
                    }
                }
                
                // 更新する取引先のIDとして追加
                if (bIsAccUpdated)
                    updatedAccIds.add(a.Id);
            }
            
            // 更新する取引先のIDをもとに取引先をリストアップ
            Map<Id, Account> updAccountMap = new Map<Id, Account>();
            for(String key : updatedAccIds) {
                if (updAccountMap.get(key) == NULL) updAccountMap.put(key, accMap.get(key));
            }
            
            if (updAccountMap.size() > 0) update updAccountMap.values();
        }
        
        
        /*****20200107 PHASE3 コード修正　開始*********/
        
        // ToDoが参照している商談を抽出
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id
                ,FirstResultType_Middle__c  // 初回コンタクト結果（中分類）
                ,FirstResultType_Small__c   // 初回コンタクト結果（小分類）
                ,FirstCallDateTime__c       // 初回コンタクト日時
                ,FirstProbability__c        // 初回見込確度
                ,StageName
                ,RecentResultType_Middle__c // 最新対応結果（中分類）
                ,RecentResultType_Small__c  // 最新対応結果（小分類）
                ,RecentCallDateTime__c      // 最新対応日時
                ,RecentProbability__c       // 最新見込確度
                ,RecentNextCallDateTime__c  // 次回架電日時
                ,ClaimDate__c               // 苦情対応日時
                ,RequestDate__c             // 要望対応日時
                ,ThankDate__c               // 感謝対応日時
                ,RecentPromise__c           // 顧客約束有無
                ,Field1__c                  // 枝番
                ,Check_AcceptReparation__c  // 保障/補償内容了解済みフラグ
                ,Check_AcceptPremire__c     // 保険料了解済みフラグ
                ,Check_ApproveDate__c       // 申込時期確認済みフラグ
                ,StopCallingList__c         // 架電禁止依頼
                ,VOC__c                     // VOC
                ,prodtype_multilist__c      // 商品種別
                ,ProdctName__c              // 商品名
                ,CloseType__c
                ,CloseReason__c
                ,CloseDate
                ,LastProbability__c
            FROM Opportunity
            WHERE Id IN : oppIdSet
        ]);
        
        // 更新する商談のID
        Set<String> updIdSet = new Set<String>();
        // ToDo→商談 情報セット
        for (Task t : targetTaskList) {
            
            // If WhatId is Invalid, throw Error
            if (oppMap.get(t.WhatId) == NULL) {
                t.addError('商談:[' + t.WhatId + ']がありません');
                continue;
                // NOTREACHED
            }
            
            // 初回の場合（初回コンタクト日時が空白 or 初回コンタクト日時よりも古いToDo）
            
            // * 初回コンタクト日時判定 * //
            // 条件： 商談．初回コンタクト日時 = null
            if (oppMap.get(t.WhatId).FirstCallDateTime__c == null || 
            // * 初回通話履歴判定 * //
            // 条件： （ ① AND ② AND ③ AND ④ AND ⑤ ） AND （ ⑥ OR ⑦ OR ⑧ OR ⑨ OR ⑩ OR ⑪ ）
            // ①： 活動．対応結果（中分類） <> 不通
            // ②： 活動．対応結果（中分類） <> null
            // ③： 活動．対応結果（中分類） <> 問合せ      //2020/05 ADD RIPCRM-190
            // ④： 活動．対応結果（中分類） <> 不要       //2020/05 ADD RIPCRM-190
            // ⑤： 活動．対応結果（中分類） <> 申込後架電  //2020/05 ADD RIPCRM-190
            // ⑥： 商談．初回コンタクト結果（中分類） = 不通
            // ⑦： 商談．初回コンタクト結果（中分類） = null
            // ⑧： 商談．初回コンタクト結果（中分類） = 問合せ      //2020/05 ADD RIPCRM-190
            // ⑨： 商談．初回コンタクト結果（中分類） = 不要       //2020/05 ADD RIPCRM-190
            // ⑩： 商談．初回コンタクト結果（中分類） = 申込後架電  //2020/05 ADD RIPCRM-190
            // ⑪： 商談．初回コンタクト日時 >= 活動． 対応日時
                ((t.ResultType_Middle__c != '不通' && 
                  String.IsNotBlank(t.ResultType_Middle__c) && 
                  t.ResultType_Middle__c != '問合せ' &&          //2020/05 ADD RIPCRM-190
                  t.ResultType_Middle__c != '不要' &&          //2020/05 ADD RIPCRM-190
                  t.ResultType_Middle__c != '申込後架電') &&     //2020/05 ADD RIPCRM-190
                 (oppMap.get(t.WhatId).FirstResultType_Middle__c == '不通' || 
                  String.IsBlank(oppMap.get(t.WhatId).FirstResultType_Middle__c) || 
                  oppMap.get(t.WhatId).FirstResultType_Middle__c == '問合せ' || 
                  oppMap.get(t.WhatId).FirstResultType_Middle__c == '不要' || 
                  oppMap.get(t.WhatId).FirstResultType_Middle__c == '申込後架電' || 
                  oppMap.get(t.WhatId).FirstCallDateTime__c >= t.CallDateTime__c)) ||
            // * 初回不通履歴判定 * //
            // 条件： ① AND （ ② OR ③ OR ④ OR ⑤ OR ⑥） 
            // ①： 商談．初回コンタクト日時 >= 活動． 対応日時
            // ②： 商談．初回コンタクト結果（中分類） = 不通
            // ③： 商談．初回コンタクト結果（中分類） = null
            // ④： 商談．初回コンタクト結果（中分類） = 問合せ      //2020/05 ADD RIPCRM-190
            // ⑤： 商談．初回コンタクト結果（中分類） = 不要       //2020/05 ADD RIPCRM-190
            // ⑥： 商談．初回コンタクト結果（中分類） = 申込後架電  //2020/05 ADD RIPCRM-190
                (oppMap.get(t.WhatId).FirstCallDateTime__c >= t.CallDateTime__c && 
                 (oppMap.get(t.WhatId).FirstResultType_Middle__c == '不通' || 
                  String.IsBlank(oppMap.get(t.WhatId).FirstResultType_Middle__c) ||
                  oppMap.get(t.WhatId).FirstResultType_Middle__c == '問合せ' ||        //2020/05 ADD RIPCRM-190
                  oppMap.get(t.WhatId).FirstResultType_Middle__c == '不要' ||         //2020/05 ADD RIPCRM-190
                  oppMap.get(t.WhatId).FirstResultType_Middle__c == '申込後架電'))) {  //2020/05 ADD RIPCRM-190
                
                // 初回情報セット
                setFirstTaskInfoToOpportunity(oppMap.get(t.WhatId), t);
                
                if (String.IsNotBlank(t.Probability__c)) {
                    // 初回見込み確度セット
                    // 初回見込確度 = 活動．見込確度
                    oppMap.get(t.WhatId).FirstProbability__c        = t.Probability__c;
                    // 「商談の最終見込確度がnull」の場合に、最終見込確度をセットする処理
                    if (oppMap.get(t.WhatId).LastProbability__c == null) {
                        // 最終見込確度 = 活動．見込確度
                        oppMap.get(t.WhatId).LastProbability__c     = t.Probability__c;
                    }
                }
                
                // 更新する商談のIDとして追加
                updIdSet.add(t.WhatId);
            }
            
            // 初回見込確度は設定されている？
            // 商談の初回見込確度、最新見込確度、最終見込確度の設定
            if (oppMap.get(t.WhatId).FirstProbability__c == null) {
                // 初回見込み確度セット
                // 初回見込確度 = 活動．見込確度
                oppMap.get(t.WhatId).FirstProbability__c        = t.Probability__c;
                // 最新見込確度 = 活動．見込確度
                oppMap.get(t.WhatId).RecentProbability__c       = t.Probability__c;
                // 最終見込確度 = 活動．見込確度
                oppMap.get(t.WhatId).LastProbability__c         = t.Probability__c;
                
                // 更新する商談のIDとして追加
                updIdSet.add(t.WhatId);
            }
            
            // 初回か最新ToDoの場合（初回コンタクト日時が空白 or 最新コンタクト日時よりも新しいToDo）
            // 紐づき先商談の最新活動？
            if (oppMap.get(t.WhatId).RecentCallDateTime__c == NULL
            ||  oppMap.get(t.WhatId).RecentCallDateTime__c <= t.CallDateTime__c) {
                // 該当する
                
                // 最新活動判定
                // 商談最新・次回項目セット
                setRecentTaskInfoToOpportunity(oppMap.get(t.WhatId), t);
                
                // 活動に見込確度は設定されている？
                // 最新見込確度更新判定
                if (String.IsNotBlank(t.Probability__c)){
                    // 商談最新見込確度セット
                    // 最新見込確度 = 活動．見込確度
                    oppMap.get(t.WhatId).RecentProbability__c       = t.Probability__c;
                    // 最終見込確度 = 活動．見込確度
                    // ※活動.見込確度 <> '申込済み''申込なし'のとき
                    if (!'申込済み'.equals(t.Probability__c)
                    &&  !'申込なし'.equals(t.Probability__c)) {
                        oppMap.get(t.WhatId).LastProbability__c         = t.Probability__c;
                    }
                }
                
                // 商談クローズ連携判定
                // 失注活動判定
                // 対面誘導活動判定
                // 申込確約活動判定
                setClosedTaskInfoToOpportunity(oppMap.get(t.WhatId), t);
                
                // VOCが設定されている？
                if (String.IsNotBlank(t.VOC__c)){
                    // VOC入力判定
                    // VOCが設定されている？
                    setVOCToOpportunity(oppMap.get(t.WhatId), t);
                    // VOC対応日時判定
                    // VOC対応日時の設定対象？
                    setVOCDateToOpportunity(oppMap.get(t.WhatId), t);
                }
                
                // 更新する商談のIDとして追加
                updIdSet.add(t.WhatId);
            }
            
            // 活動の商品種別入力判定
            // Insertトリガ判定条件 + 
            // Updateトリガ時商品種別変更判定
            if (Operation == 'insert'
            ||  (  Operation == 'update'
                && oldMap != NULL
                && t.prodtype_multilist__c <> oldMap.get(t.Id).prodtype_multilist__c)){
                // 商談の商品種別が入力されている？
                if (String.IsNotBlank(t.prodtype_multilist__c)) {
                    // 商品種別変更判定
                    setProductTypeToOpportunity(oppMap.get(t.WhatId), t);
                    
                    // 更新する商談のIDとして追加
                    updIdSet.add(t.WhatId);
                }
            }
            
            
            // 活動の商品名入力判定
            // Insertトリガ判定条件 + 
            // Updateトリガ時商品名変更判定
            if (Operation == 'insert'
            ||  (  Operation == 'update'
                && oldMap != NULL
                && t.ProdctName__c <> oldMap.get(t.Id).ProdctName__c)){
                // 活動の商品名が入力されている？
                if (String.IsNotBlank(t.ProdctName__c)) {
                    // 商品名変更判定
                    setProductNameToOpportunity(oppMap.get(t.WhatId), t);
                    
                    // 更新する商談のIDとして追加
                    updIdSet.add(t.WhatId);
                }
            }
            /*****20200107 PHASE3 コード修正　エンド*********/
            
            
            /*****20190518 コード修正　開始*********/
            if (Operation == 'insert' 
            &&  t.ResultType_Large__c == '発信' && t.CallDateTime__c != null){
                Decimal branchNumber = oppMap.get(t.WhatId).Field1__c;
                oppMap.get(t.WhatId).Field1__c = branchNumber != null ? branchNumber + 1 : 1;
                updIdSet.add(t.WhatId);
            }
            /*
            if(operation == 'delete' && t.ResultType_Large__c == '発信' && t.CallDateTime__c != null){
                Decimal branchNumber = oppMap.get(t.WhatId).Field1__c;
                oppMap.get(t.WhatId).Field1__c = branchNumber != 1 ? branchNumber - 1 : null;
                updIdSet.add(t.WhatId);
            }
            */
            /*****20190518 コード修正　エンド*********/
        }
        
        // 更新する商談のIDをもとに商談をリストアップ
        Map<Id, Opportunity> updOppMap = new Map<Id, Opportunity>();
        for(String key : updIdSet) {
            if (updOppMap.get(key) == NULL) updOppMap.put(key, oppMap.get(key));
        }
        
        if (updOppMap.size() > 0) update updOppMap.values();
    }
    
    
    /**
     * ToDo登録後処理
     * 処理仕様(削除後処理)
     * @param List<Task>
     * @return 
     */
    public void onAfterDeleteProcess(List<Task> taskList, Map<Id, Task> oldMap, String operation){
        
        // 対象を抽出
        Set<Id> oppIdSet = new Set<Id>();
        List<Task> targetTaskList = new List<Task>();
        for(Task t : taskList) {
            // 商談に関連するToDoのみが対象
            if (t.WhatId != null 
            &&  t.WhatId.getSobjectType().getDescribe().getName() == 'Opportunity'){
                oppIdSet.add(t.WhatId);
                targetTaskList.add(t);
            }
        }
        
        // ToDoが参照している商談を抽出
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id
                ,FirstResultType_Middle__c  // 初回コンタクト結果（中分類）
                ,FirstResultType_Small__c   // 初回コンタクト結果（小分類）
                ,FirstCallDateTime__c       // 初回コンタクト日時
                ,FirstProbability__c        // 初回見込確度
                ,RecentResultType_Middle__c // 最新対応結果（中分類）
                ,RecentResultType_Small__c  // 最新対応結果（小分類）
                ,RecentCallDateTime__c      // 最新対応日時
                ,RecentProbability__c       // 最新見込確度
                ,RecentNextCallDateTime__c  // 次回架電日時
                ,ClaimDate__c               // 苦情対応日時
                ,RequestDate__c             // 要望対応日時
                ,ThankDate__c               // 感謝対応日時
                ,RecentPromise__c           // 顧客約束有無
                ,Field1__c                  // 枝番
                ,Check_AcceptReparation__c  // 保障/補償内容了解済みフラグ
                ,Check_AcceptPremire__c     // 保険料了解済みフラグ
                ,Check_ApproveDate__c       // 申込時期確認済みフラグ
                ,StopCallingList__c         // 架電禁止依頼
                ,VOC__c                     // VOC
                ,prodtype_multilist__c      // 商品種別
                ,ProdctName__c              // 商品名
                ,CloseType__c
                ,CloseReason__c
                ,CloseDate
                ,LastProbability__c
            FROM Opportunity
            WHERE Id IN : oppIdSet
        ]);
        
        // 同じ商談に関連する活動が存在？
        List<Task> relatedTaskList = [
            SELECT Id
                ,WhatId
                ,ResultType_Middle__c       // 対応結果（中分類）
                ,ResultType_Small__c        // 対応結果（小分類）
                ,CallDateTime__c            // 対応日時
                ,NextCallDateTime__c        // 次回架電日時
                ,Promise__c                 // 顧客約束有無
                ,Check_AcceptReparation__c  // 保障/補償内容了解済みフラグ
                ,Check_AcceptPremire__c     // 保険料了解済みフラグ
                ,Check_ApproveDate__c       // 申込時期確認済みフラグ
                ,StopCallingList__c         // 架電禁止依頼
                ,VOC__c                     // VOC
                ,prodtype_multilist__c      // 商品種別
                ,ProdctName__c              // 商品名
                ,Probability__c
                ,ResultType_Large__c
             FROM Task
            WHERE WhatId IN : oppIdSet
              AND CallDateTime__c != NULL
            ORDER BY CallDateTime__c ASC    // 対応日時が古い順
        ];
        
        // 同じ商談に関連する活動
        Map<Id, List<Task>> oppTaskMap = new Map<Id, List<Task>>();
        for(Task relatedTask : relatedTaskList) {
            if (oppTaskMap.get(relatedTask.WhatId) == NULL) {
                List<Task> lst = new List<Task>();
                lst.add(relatedTask);
                oppTaskMap.put(relatedTask.WhatId, lst);
            }
            else {
                oppTaskMap.get(relatedTask.WhatId).add(relatedTask);
            }
        }
        
        // Flags to Set the Oldest and Latest Values
        Boolean bIsSetFirstTaskInfo = FALSE;
        Boolean bIsSetRecentTaskInfo = FALSE;
        Boolean bIsSetFirstProbability = FALSE;
        Boolean bIsSetRecentProbability = FALSE;
        Boolean bIsSetVOC = FALSE;
        Boolean bIsSetVOCDate = FALSE;
        
        // ToDo→商談 情報セット
        for (Opportunity opp : oppMap.values()) {
            
            // 処理で設定されない場合
            clearOpportunityFields(opp);
            
            bIsSetFirstTaskInfo = FALSE;
            bIsSetRecentTaskInfo = FALSE;
            bIsSetFirstProbability = FALSE;
            bIsSetRecentProbability = FALSE;
            bIsSetVOC = FALSE;
            bIsSetVOCDate = FALSE;
            
            // 活動取得
            // 対応日時が古い順
            List<Task> oppRelatedTaskList = oppTaskMap.get(opp.Id);
            // 活動が存在しない
            if (oppRelatedTaskList == NULL)
                continue;
                // NOTREACHED
            
            // 最古活動判定
            // 最古活動取得（活動．対応日時が最古）
            for(Task t : oppRelatedTaskList) {
                // // 通話履歴が存在する
                // 通話履歴取得
                if (!bIsSetFirstTaskInfo
                &&  String.IsNotBlank(t.ResultType_Middle__c)
                &&  t.ResultType_Middle__c != '不通'
                &&  t.ResultType_Middle__c != '問合せ'
                &&  t.ResultType_Middle__c != '不要'
                &&  t.ResultType_Middle__c != '申込後架電') {
                    // 初回通話履歴取得（活動．対応日時が最古）
                    // 初回情報セット
                    setFirstTaskInfoToOpportunity(opp, t);
                    bIsSetFirstTaskInfo = TRUE;
                }
                
                // 見込確度が設定された活動は存在？
                // 初回活動取得（活動．対応日時が最古）
                if (!bIsSetFirstProbability
                &&  String.IsNotBlank(t.Probability__c)) {
                    // 商談初回見込確度セット
                    // 初回見込確度 = 活動．見込確度
                    opp.FirstProbability__c        = t.Probability__c;
                    // 最終見込確度 = 活動．見込確度
                    opp.LastProbability__c         = t.Probability__c;
                    bIsSetFirstProbability = TRUE;
                }
                
                // 商品種別が設定された活動は存在？
                // 商談の商品種別が入力されている？
                // 活動の商品種別、選択リスト値全取得
                setProductTypeToOpportunity(opp, t);
                // 活動の商品名が入力されている？
                // 対応日時順に並べ替え
                // 条件：取得した商品名と対応日時を以下の条件で並び替える
                // ①：対応日時が古い順
                setProductNameToOpportunity(opp, t);
                
                // VOC対応日時の設定対象？
                // VOC対応日時判定
                if (!bIsSetVOCDate
                &&  String.IsNotBlank(t.VOC__c)){
                    // VOC対応日時判定
                    // 活動．対応日時が最古
                    // 活動．VOC = 苦情
                    // 活動．VOC = 要望
                    // 活動．VOC = 感謝
                    if (setVOCDateToOpportunity(opp, t)) {
                        bIsSetVOCDate = TRUE;
                    }
                }
                
                // 発信履歴は存在？
                // 発信履歴取得
                // 条件： 取得した活動レコードから、以下条件に合致するレコード数を取得
                // ① AND ②
                // ①：活動.対応結果（大分類）= 発信
                // ②：活動.対応日時 <> null
                // 取得項目：レコード数
                if (t.ResultType_Large__c == '発信' 
                &&  t.CallDateTime__c != null){
                    // 枝番セット
                    Decimal branchNumber = opp.Field1__c;
                    opp.Field1__c = branchNumber != null ? branchNumber + 1 : 1;
                }
            }
            
            // 通話履歴が存在しない
            // 最古活動判定
            // 最古活動取得（活動．対応日時が最古）
            if (!bIsSetFirstTaskInfo) {
                // 初回活動取得
                for (Task t : oppRelatedTaskList) {
                    // 初回活動取得（活動．対応日時が最古）
                    // 初回情報セット
                    setFirstTaskInfoToOpportunity(opp, t);
                    bIsSetFirstTaskInfo = TRUE;
                    break;
                    // NOTREACHED
                }
            }
            
            // 最新活動判定
            // 最新活動取得（活動．対応日時が最新）
            for(Integer nIdx = oppRelatedTaskList.size()-1; nIdx >= 0; nIdx--) {
                Task recentTask = oppRelatedTaskList[nIdx];
                // 最新活動判定
                if (!bIsSetRecentTaskInfo) {
                    // 商談最新・次回項目セット
                    setRecentTaskInfoToOpportunity(opp, recentTask);
                    bIsSetRecentTaskInfo = TRUE;
                }
                
                // 見込確度が設定された活動は存在？
                // 最新活動取得（活動．対応日時が最新）
                if (!bIsSetRecentProbability
                &&  String.IsNotBlank(recentTask.Probability__c)) {
                    // 商談最新見込確度セット
                    // 最新見込確度 = 活動．見込確度
                    opp.RecentProbability__c           = recentTask.Probability__c;
                    // 最終見込確度 = 活動．見込確度
                    // ※活動.見込確度 <> '申込済み''申込なし'のとき
                    if (!'申込済み'.equals(recentTask.Probability__c)
                    &&  !'申込なし'.equals(recentTask.Probability__c)) {
                        opp.LastProbability__c         = recentTask.Probability__c;
                    }
                    bIsSetRecentProbability = TRUE;
                }
                
                // VOCが設定されている？
                // VOC入力判定
                if (!bIsSetVOC
                &&  String.IsNotBlank(recentTask.VOC__c)){
                    // VOCセット
                    // VOC入力判定
                    setVOCToOpportunity(opp, recentTask);
                    bIsSetVOC = TRUE;
                }
                
                if (bIsSetRecentTaskInfo 
                &&  bIsSetRecentProbability
                &&  bIsSetVOC)
                    break;
                    // NOTREACHED
            }
        }
        
        // 商談更新
        if(oppMap.size() > 0) update oppMap.values();
    }
    
    
    // 見込確度上昇判定
    private void setImprovingProbability(Opportunity o, Task t) {
        // 事前準備：
        // 活動．見込確度および商談．最新見込確度を以下の通り変換
        // null⇒0
        // 申込なし⇒0
        // C⇒1
        // B⇒2
        // A⇒3
        // S⇒4
        // 申込済み⇒5
        // その他の値⇒99
        Map<String, Integer> mapProbabilityLevel = new Map<String, Integer>();
        mapProbabilityLevel.put('null', 0);
        mapProbabilityLevel.put('申込なし', 0);
        mapProbabilityLevel.put('C', 1);
        mapProbabilityLevel.put('B', 2);
        mapProbabilityLevel.put('A', 3);
        mapProbabilityLevel.put('S', 4);
        mapProbabilityLevel.put('申込済み', 5);
        mapProbabilityLevel.put('その他の値', 99);
        
        // 活動．見込確度の変換後の値
        Integer nTaskProbabilityLevel;
        if (String.IsBlank(t.Probability__c))
            nTaskProbabilityLevel = mapProbabilityLevel.get('null');
        else if (mapProbabilityLevel.get(t.Probability__c) == NULL)
            nTaskProbabilityLevel = mapProbabilityLevel.get('その他の値');
        else
            nTaskProbabilityLevel = mapProbabilityLevel.get(t.Probability__c);
        
        // 商談．最新見込確度の変換後の値
        Integer nOpporProbabilityLevel;
        if (String.IsBlank(o.RecentProbability__c))
            nOpporProbabilityLevel = mapProbabilityLevel.get('null');
        else if (mapProbabilityLevel.get(o.RecentProbability__c) == NULL)
            nOpporProbabilityLevel = mapProbabilityLevel.get('その他の値');
        else
            nOpporProbabilityLevel = mapProbabilityLevel.get(o.RecentProbability__c);
        
        if(nTaskProbabilityLevel > nOpporProbabilityLevel){
            // 見込確度上昇フラグセット
            t.ImprovingProbability__c = TRUE;
        }
    }
    
    
    // 初回活動判定
    private void setFirstTaskInfoToOpportunity(Opportunity o, Task t) {
        // 初回情報セット
        // 初回コンタクト結果（中分類）
        o.FirstResultType_Middle__c  = t.ResultType_Middle__c;
        // 初回コンタクト結果（小分類）
        o.FirstResultType_Small__c   = t.ResultType_Small__c;
        // 初回コンタクト日時
        o.FirstCallDateTime__c       = t.CallDateTime__c;
    }
    
    
    // 最新活動判定
    private void setRecentTaskInfoToOpportunity(Opportunity o, Task t) {
        // 最新情報セット
        o.RecentResultType_Middle__c = t.ResultType_Middle__c;
        o.RecentResultType_Small__c  = t.ResultType_Small__c;
        o.RecentCallDateTime__c      = t.CallDateTime__c;
        
        // 次回情報セット
        if (t.NextCallDateTime__c != NULL) o.RecentNextCallDateTime__c  = t.NextCallDateTime__c;
        o.RecentPromise__c           = t.Promise__c;
        
        // 商談最新・次回項目セット
        if (t.Check_AcceptReparation__c)  o.Check_AcceptReparation__c     = t.Check_AcceptReparation__c;
        if (t.Check_AcceptPremire__c)      o.Check_AcceptPremire__c       = t.Check_AcceptPremire__c;
        if (t.Check_ApproveDate__c)        o.Check_ApproveDate__c         = t.Check_ApproveDate__c;
        if (String.IsNotBlank(t.StopCallingList__c)) o.StopCallingList__c = t.StopCallingList__c;
    }
    
    
    // VOCが設定されている？
    private void setVOCToOpportunity(Opportunity o, Task t) {
        // VOC入力判定
        if(String.IsNotBlank(t.VOC__c)){
            // VOCセット
            // VOC
            o.VOC__c = t.VOC__c;
        }
    }
    
    
    // VOC対応日時の設定対象？
    private Boolean setVOCDateToOpportunity(Opportunity o, Task t) {
        // VOC対応日時判定
        // VOC対応日時の設定対象？
        // VOC対応日時判定
        if('苦情'.equals(t.VOC__c)
        && o.ClaimDate__c == NULL){
            // VOC対応日時セット
            // 苦情対応日時
            o.ClaimDate__c = t.CallDateTime__c;
        }
        
        if('要望'.equals(t.VOC__c)
        && o.RequestDate__c == NULL){
            // VOC対応日時セット
            // 要望対応日時
            o.RequestDate__c = t.CallDateTime__c;
        }
        
        if('感謝'.equals(t.VOC__c)
        && o.ThankDate__c == NULL){
            // VOC対応日時セット
            // 感謝対応日時
            o.ThankDate__c = t.CallDateTime__c;
        }
        
        return o.ClaimDate__c != NULL 
            && o.RequestDate__c != NULL 
            && o.ThankDate__c != NULL;
    }
    
    
    // 商談クローズ連携（失注・謝絶）
    // 商談クローズ連携（対面誘導）
    // クローズ理由セット
    private void setClosedTaskInfoToOpportunity(Opportunity o, Task t) {
        // 失注を表す活動？
        // 失注活動判定
        if(o.StageName <> '対応終了'
        && (t.ResultType_Small__c == '拒否'
           || t.ResultType_Small__c == '謝絶'
           || t.ResultType_Middle__c == '不要')) {
            
            // 商談クローズ連携（失注・謝絶）
            
            // 最新見込確度
            o.RecentProbability__c = '申込なし';
            // クローズ種別
            // 活動．対応結果（小分類）が「拒否」の場合 (OR)
            // 活動．対応結果（中分類）が『不要』の場合
            if (t.ResultType_Small__c == '拒否' || 
                t.ResultType_Middle__c == '不要') {
                o.CloseType__c = '失注';
            }
            // クローズ種別
            // 活動．対応結果（小分類）が「謝絶」の場合
            if (t.ResultType_Small__c == '謝絶') o.CloseType__c = '謝絶';
            // クローズ理由
            o.CloseReason__c = t.CloseReason__c;
            // 完了予定日
            o.CloseDate = Date.newinstance(t.CallDateTime__c.year(), 
                                                    t.CallDateTime__c.month(), 
                                                    t.CallDateTime__c.day());
        }
        // 対面誘導を表す活動？
        // 対面誘導活動判定
        else 
        if(o.StageName <> '対応終了'
        && t.ResultType_Middle__c == '対面誘導'
        && t.ResultType_Small__c == '了承') {
            
            // 商談クローズ連携（対面誘導）
            
            // 最新見込確度
            o.RecentProbability__c = '申込なし';
            // クローズ種別
            o.CloseType__c = '対応打ち切り';
            // クローズ理由
            o.CloseReason__c = '対面誘導';
            // 完了予定日
            o.CloseDate = Date.newinstance(t.CallDateTime__c.year(), 
                                                    t.CallDateTime__c.month(), 
                                                    t.CallDateTime__c.day());
        }
        // 申込確約を表す活動？
        // 申込確約活動判定
        else 
        if(o.StageName <> '対応終了'
        && (t.ResultType_Small__c == '申込完了'
            || ((  t.ResultType_Middle__c == 'Web誘導'
                || t.ResultType_Middle__c == '紙申込誘導')
               && t.ResultType_Small__c == '了承'))) {
            // クローズ理由セット
            // クローズ種別
            o.CloseType__c = '申込';
            // クローズ理由
            o.CloseReason__c = t.CloseReason__c;
        }
    }
    
    
    // 商談の商品種別が入力されている？
    private void setProductTypeToOpportunity(Opportunity o, Task t) {
        if (String.IsNotBlank(t.prodtype_multilist__c)) {
            // 商談の商品種別が入力されている？
            if (String.IsNotBlank(o.prodtype_multilist__c)) {
                // 商談．商品種別の選択リスト値を取得
                // o.prodtype_multilist__c
                
                // 活動の商品種別、選択リスト値取得
                // 活動．商品種別の選択リスト値を、リスト値毎に取得
                List<String> lstTaskProdType = t.prodtype_multilist__c.split(';');
                
                // 既存商品種別判定
                for (String taskProdType : lstTaskProdType) {
                    // 商談に存在しない
                    if (!o.prodtype_multilist__c.contains(taskProdType)) {
                        // 商品種別に追記してセット
                        o.prodtype_multilist__c += ';' + taskProdType;
                    }
                }
            }
            else {
                // 商品種別セット
                o.prodtype_multilist__c = t.prodtype_multilist__c;
            }
        }
    }
    
    
    // 活動の商品名が入力されている？
    private void setProductNameToOpportunity(Opportunity o, Task t) {
        // 活動の商品名が入力されている？
        if (String.IsNotBlank(t.ProdctName__c)) {
            // 対応日時フォーマット: yyyy/mm/dd HH:mm
            String taskCallDateTime = t.CallDateTime__c.format('yyyy/MM/dd HH:mm');
            // 商談の商品名が入力されている？
            if (String.IsNotBlank(o.ProdctName__c)) {
                // 商品名に追記してセット
                // 対応日時と結合してセット
                // 商談．商品名　&　改行　&　活動．商品名　&"(" &　活動．対応日時 & ")"
                o.ProdctName__c += '\n' + t.ProdctName__c + '(' + taskCallDateTime + ')';
            }
            else {
                // 商品名セット
                // 対応日時と結合してセット
                // 活動．商品名　&"(" &　活動．対応日時 & ")"
                o.ProdctName__c = t.ProdctName__c + '(' + taskCallDateTime + ')';
            }
        }
    }
    
    private void clearOpportunityFields(Opportunity o) {
        // 初回情報セット
        // 初回コンタクト結果（中分類）
        o.FirstResultType_Middle__c  = '';
        // 初回コンタクト結果（小分類）
        o.FirstResultType_Small__c   = '';
        // 初回コンタクト日時
        o.FirstCallDateTime__c       = NULL;
        
        // 最新情報セット
        o.RecentResultType_Middle__c = '';
        o.RecentResultType_Small__c  = '';
        o.RecentCallDateTime__c      = NULL;
        
        // 次回情報セット
        o.RecentNextCallDateTime__c  = NULL;
        o.RecentPromise__c           = '無';
        
        // 商談最新・次回項目セット
        o.Check_AcceptReparation__c  = FALSE;
        o.Check_AcceptPremire__c     = FALSE;
        o.Check_ApproveDate__c       = FALSE;
        o.StopCallingList__c         = '';
        
        // 初回見込確度
        o.FirstProbability__c   = '';
        // 最新見込確度
        o.RecentProbability__c  = '';
        // 最終見込確度
        o.LastProbability__c    = '';
        // 商品種別
        o.prodtype_multilist__c = '';
        // 商品名
        o.ProdctName__c         = '';
        // VOC
        o.VOC__c                = '';
        // 苦情対応日時
        o.ClaimDate__c          = NULL;
        // 要望対応日時
        o.RequestDate__c        = NULL;
        // 感謝対応日時
        o.ThankDate__c          = NULL;
        // 枝番
        o.Field1__c             = NULL;
    }
}