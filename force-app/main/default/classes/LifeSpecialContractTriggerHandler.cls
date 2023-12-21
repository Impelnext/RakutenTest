/*
* @Class Name      : LifeSpecialContractTriggerHandler 
* @Description     : 生保特約トリガーハンドラ
* @Created Date    : 2019.05.31
* @Created By      : 
* @Modified Date   : 2020.09.18
* @Modified        : Valsala Kumar
*/
public class LifeSpecialContractTriggerHandler {
    //コンストラクタ
    public LifeSpecialContractTriggerHandler(){}
    
    //生保契約との紐付け
    public void setParentRecord(List<LifeSpecialContract__c> newList, Map<Id,LifeSpecialContract__c> oldMap){
        //取得対象となる保険証券番号のSetと処理対象のListを作成
        Set<String> parentNoSet = new Set<String>();
        List<LifeSpecialContract__c> targetList = new List<LifeSpecialContract__c>();
        
        for(LifeSpecialContract__c line : newList){
            if(oldMap == Null || oldMap.size() == 0){
                //新規登録の場合
                if(line.POL_NUM__c <> Null){
                    parentNoSet.add(line.POL_NUM__c);
                    targetList.add(line);
                }
            }else{
                //保険証券番号が変更になった場合のみSetとListに詰める
                if(line.POL_NUM__c <> oldMap.get(line.Id).POL_NUM__c){
                    parentNoSet.add(line.POL_NUM__c);
                    targetList.add(line);
                }
            }
        }
        
        //処理対象レコードが存在する場合のみ処理実行
        if(targetList.size() > 0){
            //親レコードを取得
            List<LifeContract__c> parentRecordList = [Select POL_NUM__c, Id From LifeContract__c Where POL_NUM__c = :parentNoSet];
            //親判定用Mapを作成
            Map<String, Id> parentRecMap = new Map<String, Id>();
            for(LifeContract__c rec : parentRecordList){
                if(rec.POL_NUM__c != Null){
                    parentRecMap.put(rec.POL_NUM__c, rec.Id);
                }
            }
            
            //処理対象レコードに対して申込IDとの参照関係を作成
            for(LifeSpecialContract__c target : targetList){
                target.LifeContract__c = parentRecMap.get(target.POL_NUM__c);
            }
        }
    }
    
    
    //生保契約との情報を設定する
    public void setParentInfo(List<LifeSpecialContract__c> newList, Map<Id,LifeSpecialContract__c> oldMap){
        //取得対象となるレコードIdのSetと処理対象のListを作成
        Set<String> parentIdSet = new Set<String>();
        for(LifeSpecialContract__c line : newList){
            
            // 新規登録の場合、
            // 生保契約に設定する情報が変更になった場合Setに詰める
            if (String.IsNotBlank(line.LifeContract__c)) {
                parentIdSet.add(line.LifeContract__c);
            }
            
            // 生保契約が変更になった場合、元の生保契約IdをSetに詰める
            if (oldMap != NULL && oldMap.size() > 0 && 
                line.LifeContract__c != oldMap.get(line.Id).LifeContract__c && 
                String.IsNotBlank(oldMap.get(line.Id).LifeContract__c)) {
                parentIdSet.add(oldMap.get(line.Id).LifeContract__c);
            }
        }
        
        //処理対象レコードが存在する場合のみ処理実行
        if(parentIdSet.size() > 0){
            //親レコードを取得
            //親判定用Mapを作成
            Map<Id, LifeContract__c> parentRecMap = new Map<Id, LifeContract__c>(
                                                         [ SELECT Id
                                                                , KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c
                                                                , AUTHORIZED_CLAIMANT_RELATIONSHIP__c
                                                                , Advanced_Contract_Flag__c
                                                                , Cancer_Contract_Amount__c
                                                                , Emergency_Contract_Amount__c
                                                                , Outpatient_Contract_Amount__c
                                                                , Sick7_Contract_Amount__c
                                                                , Discharge_Outpatient_Contract_Amount__c
                                                                , MajorSick3_Exemp_Contract__c
                                                                , AUTHORIZED_CLAIMANT_CONTRACT__c
                                                             FROM LifeContract__c 
                                                            WHERE ID = :parentIdSet ]);
            //生保契約情報と生保特約(リスト)のマップを作成
            Map<LifeContract__c, List<LifeSpecialContract__c>> contractMap = new Map<LifeContract__c, List<LifeSpecialContract__c>>(); 
            List<LifeSpecialContract__c> riderList = [SELECT Id, Name, KANJI_AUTHORIZED_CLMANT_NAME__c, 
                                                             KANA_AUTHORIZED_CLAIMANT_NAME__c, AUTHORIZED_CLMANT_RELATIONSHIP__c, 
                                                             BENEFIT_AMOUNT__c, LifeContract__c
                                                      FROM LifeSpecialContract__c 
                                                      WHERE LifeContract__c = :parentIdSet
                                                      ORDER BY LastModifiedDate DESC];
            for( LifeContract__c con : parentRecMap.values() ) {
                contractMap.put(con, new List<LifeSpecialContract__c>());
            }
            for( LifeSpecialContract__c lsc : riderList ) {
                LifeContract__c parent = null;
                if( !String.isEmpty(lsc.LifeContract__c) ) {
                    parent = parentRecMap.get(lsc.LifeContract__c);
                } else {
                    continue;
                }
                
                List<LifeSpecialContract__c> lscList = new List<LifeSpecialContract__c>();
                if( !contractMap.containsKey(parent) ) {
                    contractMap.put(parent, lscList);
                } else {
                    lscList = contractMap.get(parent);
                }
                lscList.add(lsc);
            }
            Map<Id, LifeContract__c> updateParentRecMap = new Map<Id, LifeContract__c>();
            // 生保契約情報毎に特約金額、指定代理人指名、指定代理人続き柄を入力
            for( LifeContract__c contract : contractMap.keySet() ) {
                List<LifeSpecialContract__c> childList = contractMap.get(contract);
                // 各特約金額を入力
                setRiderPrice(contract, childList);
                // 更新対象レコードはマップに追加する。
                updateParentRecMap.put(contract.Id, contract);
            }
            
            // 更新対象の生保契約情報レコードを更新
            if (!updateParentRecMap.isEmpty()) 
                update updateParentRecMap.values();
        }
    }

    private void setRiderPrice( LifeContract__c parentRec, List<LifeSpecialContract__c> childList ) {
        Map<String, LifeSpecialContract__c> childMap = new Map<String, LifeSpecialContract__c>();
        for( LifeSpecialContract__c lsc : childList ) {
            childMap.put(lsc.Name, lsc);
        }
        // 先進特約フラグ設定
        // 生保特約の特約名（Name項目）=「先進医療特約」: 有
        // 生保特約の特約名（Name項目）=「先進医療特約2018」:有（2018）
        if ( childMap.containsKey('先進医療特約') ) {
            parentRec.Advanced_Contract_Flag__c = '有';
        } else if( childMap.containsKey('先進医療特約２０１８') ) {
            parentRec.Advanced_Contract_Flag__c = '有（2018）';
        } else {
            parentRec.Advanced_Contract_Flag__c = '';             
        }

        // がん特約/特約金額設定
        // 生保特約の特約名（Name項目）= 「がん特約」「がん特則」→「有」＋「／」＋「給付金額」
        // 生保特約の特約名（Name項目）= 「がん特約Ⅱ」→「有（Ⅱ）」+「／」＋「給付金額」
        if ( childMap.containsKey('がん特約') ) {
            LifeSpecialContract__c child = childMap.get('がん特約');
            parentRec.Cancer_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else if( childMap.containsKey('がん特則') ) {
            LifeSpecialContract__c child = childMap.get('がん特則');
            parentRec.Cancer_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else if ( childMap.containsKey('がん特約Ⅱ') ) {
            LifeSpecialContract__c child = childMap.get('がん特約Ⅱ');
            parentRec.Cancer_Contract_Amount__c = '有（Ⅱ）' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else {
            parentRec.Cancer_Contract_Amount__c = '';
        } 

        // 急性心筋梗塞・脳卒中特約/特約金額設定
        // 生保特約の特約名（Name項目）= 「急性心筋梗塞・脳卒中特約」「限定告知型急性心筋梗塞・脳卒中特約」→「有」＋「／」＋「給付金額」を設定する
        if (childMap.containsKey('急性心筋梗塞・脳卒中特約') ) {
            LifeSpecialContract__c child = childMap.get('急性心筋梗塞・脳卒中特約');
            parentRec.Emergency_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else if( childMap.containsKey('限定告知型急性心筋梗塞・脳卒中特約') ) {
            LifeSpecialContract__c child = childMap.get('限定告知型急性心筋梗塞・脳卒中特約');
            parentRec.Emergency_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else {
            parentRec.Emergency_Contract_Amount__c = '';
        } 

        // 通院特約/特約金額設定
        // 生保特約の特約名（Name項目）=「通院特約」「限定告知型通院特約」 →「有」＋「／」＋「給付金額」
        if ( childMap.containsKey('通院特約') ) {
            LifeSpecialContract__c child = childMap.get('通院特約');
            parentRec.Outpatient_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else if( childMap.containsKey('限定告知型通院特約') ) {
            LifeSpecialContract__c child = childMap.get('限定告知型通院特約');
            parentRec.Outpatient_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else {
            parentRec.Outpatient_Contract_Amount__c = '';
        } 

        // 7疾病特/特約金額設定
        // 生保特約の特約名（Name項目）が「７疾病特約」 →「有」＋「／」＋「給付金額」
        if ( childMap.containsKey('７疾病特約') ) {
            LifeSpecialContract__c child = childMap.get('７疾病特約');
            parentRec.Sick7_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else {
            parentRec.Sick7_Contract_Amount__c = '';
        } 

        // 退院・通院特/特約金額設定
        // 生保特約の特約名（Name項目）=「退院・通院特約」→ 「有」＋「／」＋「給付金額」
        if ( childMap.containsKey('退院・通院特約') ) {
            LifeSpecialContract__c child = childMap.get('退院・通院特約');
            parentRec.Discharge_Outpatient_Contract_Amount__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else {
            parentRec.Discharge_Outpatient_Contract_Amount__c = '';
        } 

        // ３大疾病払込免除特約設定
        // 生保特約の特約名（Name項目）が「３大疾病保険料払込免除特約」 ←「有」＋「／」＋「給付金額」
        if ( childMap.containsKey('３大疾病保険料払込免除特約') ) {
            LifeSpecialContract__c child = childMap.get('３大疾病保険料払込免除特約');
            parentRec.MajorSick3_Exemp_Contract__c = '有' + '／' + (String.IsNotBlank(child.BENEFIT_AMOUNT__c) ? child.BENEFIT_AMOUNT__c : '');
        } else {
            parentRec.MajorSick3_Exemp_Contract__c = '';
        } 
        
        // 指定代理請求人特約設定
        // 生保特約の特約名（Name項目）が「指定代理請求特約」→「有」
        if ( childMap.containsKey('指定代理請求特約') ) {
            LifeSpecialContract__c child = childMap.get('指定代理請求特約');
            parentRec.AUTHORIZED_CLAIMANT_CONTRACT__c = '有';
            // 指定代理人漢字／カナ ← 指定代理請求人氏名 + ／ + 指定代理請求人氏名カナ
            parentRec.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c = String.IsNotBlank(child.KANJI_AUTHORIZED_CLMANT_NAME__c) ? child.KANJI_AUTHORIZED_CLMANT_NAME__c : '';
            parentRec.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c += '／';
            parentRec.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c += String.IsNotBlank(child.KANA_AUTHORIZED_CLAIMANT_NAME__c) ? child.KANA_AUTHORIZED_CLAIMANT_NAME__c : '';
            // 指定代理人　続柄 ← 指定代理請求人続柄
            parentRec.AUTHORIZED_CLAIMANT_RELATIONSHIP__c = String.IsNotBlank(child.AUTHORIZED_CLMANT_RELATIONSHIP__c) ? child.AUTHORIZED_CLMANT_RELATIONSHIP__c : '';
        } else {
            parentRec.AUTHORIZED_CLAIMANT_CONTRACT__c = '';
            parentRec.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c = '';
            parentRec.AUTHORIZED_CLAIMANT_RELATIONSHIP__c = '';
        } 
 
    }
}