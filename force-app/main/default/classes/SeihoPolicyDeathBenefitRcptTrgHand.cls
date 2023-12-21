/*
* @Class Name      : SeihoPolicyDeathBenefitRcptTrgHand
* @Description     : 生保契約死亡保険金受取人トリガ
* @Created Date    : 2020.01.20
* @Created By      : 
* @Modified Date   : 2020.09.18
* @Modified        : Valsala Kumar
*/
public class SeihoPolicyDeathBenefitRcptTrgHand {
    //コンストラクタ
    public SeihoPolicyDeathBenefitRcptTrgHand(){}


    //生保契約との紐付け
    public void setParentRecord(List<SeihoPolicyDeathBenefitRcpt__c> newList, Map<Id,SeihoPolicyDeathBenefitRcpt__c> oldMap){
        //取得対象となる保険証券番号のSetと処理対象のListを作成
        Set<String> parentNoSet = new Set<String>();
        SeihoHelper helper = new SeihoHelper();
        List<SeihoPolicyDeathBenefitRcpt__c> targetList = new List<SeihoPolicyDeathBenefitRcpt__c>();

        Map<String, Id> parentRecMap = new Map<String, Id>();
        for(SeihoPolicyDeathBenefitRcpt__c line : newList){
            Boolean isInsert = (oldMap == Null || oldMap.size() == 0);
            if( isInsert && line.INSURANCE_POLICY_NUMBER__c != Null   // 新規登録時
             || !isInsert && line.INSURANCE_POLICY_NUMBER__c != oldMap.get(line.Id).INSURANCE_POLICY_NUMBER__c ) { // 証券番号の更新時
                // 証券番号がNullに更新された場合
                if( !isInsert && line.INSURANCE_POLICY_NUMBER__c == Null ) {
                    parentRecMap.put(line.INSURANCE_POLICY_NUMBER__c, null);
                } else {
                    parentNoSet.add(line.INSURANCE_POLICY_NUMBER__c);
                }
                targetList.add(line);
            }
        }
        
        //処理対象レコードが存在する場合のみ処理実行
        if(targetList.size() > 0){
            //親レコードを取得
            parentRecMap = helper.getPolicyNumberMap( parentRecMap, parentNoSet );
            //処理対象レコードに対して申込IDとの参照関係を作成
            for(SeihoPolicyDeathBenefitRcpt__c target : targetList){
                target.LifeContract__c = parentRecMap.get(target.INSURANCE_POLICY_NUMBER__c);
            }
        }
    }
    
    
    //生保契約との情報を設定する
    public void setParentInfo(List<SeihoPolicyDeathBenefitRcpt__c> newList, Map<Id,SeihoPolicyDeathBenefitRcpt__c> oldMap){
        //取得対象となるレコードIdのSetと処理対象のListを作成
        Set<String> parentIdSet = new Set<String>();
        
        for(SeihoPolicyDeathBenefitRcpt__c line : newList){
            
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
                                                                , KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c
                                                                , DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c
                                                                , DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c
                                                             FROM LifeContract__c 
                                                            WHERE ID = :parentIdSet ]);
            // 元の値はクリアする
            for (LifeContract__c parentRec : parentRecMap.values()) {
                parentRec.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c = '';
                parentRec.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c = '';
                parentRec.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c = '';
            }
            
            // 1契約に対して複数の受取人レコードが取得できた場合は「BRANCH_NUMBER__c」でソートする
            List<SeihoPolicyDeathBenefitRcpt__c> lineList = [
                                                                SELECT Id
                                                                     , Name
                                                                     , LifeContract__c
                                                                     , KANJI_NAME__c
                                                                     , KANA_NAME__c
                                                                     , RELATIONSHIP_TO_INSURED__c
                                                                     , SPLIT_RATIO__c
                                                                     , BRANCH_NUMBER__c
                                                                  FROM SeihoPolicyDeathBenefitRcpt__c 
                                                                 WHERE LifeContract__c = :parentIdSet
                                                              ORDER BY LifeContract__c, BRANCH_NUMBER__c];
            
            //処理対象レコードに対して生保契約に関連情報を設定する
            for(SeihoPolicyDeathBenefitRcpt__c line : lineList){
                
                // 新規登録の場合、
                // 生保契約に連携する情報が変更になった場合、生保契約に設定する。
                if (String.IsNotBlank(line.LifeContract__c) && 
                    parentRecMap.get(line.LifeContract__c) != NULL) {
                    
                    LifeContract__c parentRec = parentRecMap.get(line.LifeContract__c);
                    
                    // Check if it's NOT FIRST child record
                    if (String.IsNotBlank(parentRec.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c)) {
                        parentRec.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c += '、';
                        parentRec.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c += '、';
                        parentRec.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c += '、';
                    }
                    
                    // 同じ生保契約に紐づく生保契約死亡保険金受取人レコードを全て取得し、
                    // 1レコードずつ「受取人名漢字」と「受取人名カナ」の項目を「／」で連結し、
                    // 1契約に対して複数の受取人レコードが取得できた場合は
                    //「BRANCH_NUMBER__c」でソートして「、」で連結して
                    // 紐づき先の生保契約情報の「死亡受取人　漢字／カナ」に設定する。
                    parentRec.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c += String.IsNotBlank(line.KANJI_NAME__c) ? line.KANJI_NAME__c : '';
                    parentRec.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c += '／';
                    parentRec.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c += String.IsNotBlank(line.KANA_NAME__c) ? line.KANA_NAME__c : '';
                    
                    // 同じ生保契約に紐づく生保契約死亡保険金受取人レコードを全て取得し、
                    // 1契約に対して複数の受取人レコードが取得できた場合は
                    //「BRANCH_NUMBER__c」でソートして「被保険者との続柄」を「、」で連結して
                    // 紐づき先の生保契約情報の「死亡受取人　続柄」に設定する。
                    parentRec.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c += String.IsNotBlank(line.RELATIONSHIP_TO_INSURED__c) ? line.RELATIONSHIP_TO_INSURED__c : '';
                    
                    // 同じ生保契約に紐づく生保契約死亡保険金受取人レコードを全て取得し、
                    // 1契約に対して複数の受取人レコードが取得できた場合は
                    // 「BRANCH_NUMBER__c」でソートして「分割割合」を「、」で連結して
                    // 紐づき先の生保契約情報の「死亡受取人　受取割合」に設定する。
                    parentRec.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c += String.IsNotBlank(line.SPLIT_RATIO__c) ? line.SPLIT_RATIO__c : '';
                    
                }
            }
            
            // 更新対象レコードは更新する。
            if (!parentRecMap.isEmpty())
                update parentRecMap.values();
        }
    }
}