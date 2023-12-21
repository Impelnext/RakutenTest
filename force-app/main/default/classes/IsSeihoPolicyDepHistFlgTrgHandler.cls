public class IsSeihoPolicyDepHistFlgTrgHandler {
    //コンストラクタ
    public IsSeihoPolicyDepHistFlgTrgHandler(){}
    
    //生保契約との紐付け
    public void setParentRecord(List<SeihoPolicyDepHist__c> newList, Map<Id,SeihoPolicyDepHist__c> oldMap){
        //取得対象となる保険証券番号のSetと処理対象のListを作成
        Set<String> parentNoSet = new Set<String>();
        SeihoHelper helper = new SeihoHelper();
        List<SeihoPolicyDepHist__c> targetList = new List<SeihoPolicyDepHist__c>();

        Map<String, Id> parentRecMap = new Map<String, Id>();
        for(SeihoPolicyDepHist__c line : newList){
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
            for(SeihoPolicyDepHist__c target : targetList){
                target.LifeContract__c = parentRecMap.get(target.INSURANCE_POLICY_NUMBER__c);
            }
        }
    }
}