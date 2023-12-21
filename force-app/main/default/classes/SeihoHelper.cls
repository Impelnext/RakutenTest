public class SeihoHelper {
    public Map<String, Id> getPolicyNumberMap( Map<String, Id> policyNumberMap, Set<String> policyNumberSet ) {
        if( policyNumberMap == null ) {
            policyNumberMap = new Map<String, Id>();
        }
        //証券番号から生保契約情報レコードを取得
        List<LifeContract__c> parentRecordList = [Select POL_NUM__c, Id From LifeContract__c Where POL_NUM__c = :policyNumberSet];
        //親判定用Mapを作成
        for(LifeContract__c rec : parentRecordList){
            if(rec.POL_NUM__c != Null){
                policyNumberMap.put(rec.POL_NUM__c, rec.Id);
            }
        }
        return policyNumberMap;
    }
}