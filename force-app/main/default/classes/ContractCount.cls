public class ContractCount {
    
    /*
     * 契約件数取得
     */
    @AuraEnabled
    public static Map<String,Boolean> getContractCount(String accountId){
        Map<String,Boolean> mapResult = new Map<String,Boolean>();

        if(!String.isEmpty(accountId)){
            // 契約レコード取得
            List<LifeContract__c> lfCntList = [SELECT Id FROM LifeContract__c Where AccountId__c =: accountId Limit 1];
            List<LifeSpecialContract__c> lfsCntList = [SELECT Id FROM LifeSpecialContract__c Where LifeContract__r.AccountId__c =: accountId Limit 1];
            List<DamageContract__c> dmgCntList = [SELECT Id FROM DamageContract__c Where AccountId__c =: accountId Limit 1];
            List<LittleContract__c> ltlCntList = [SELECT Id FROM LittleContract__c Where AccountId__c =: accountId Limit 1];

            // ユーザープロファイルが使用可能な商談のレコードIDの一覧を返却
            if(lfCntList.size() > 0){
                mapResult.put('SEIHO', True);
            }else{
                mapResult.put('SEIHO', False);
            }

            if(lfsCntList.size() > 0){
                mapResult.put('SEIHO_TOKUYAKU', True);
            }else{
                mapResult.put('SEIHO_TOKUYAKU', False);
            }
            
            if(dmgCntList.size() > 0){
                mapResult.put('SONPO', True);
            }else{
                mapResult.put('SONPO', False);
            }
            
            if(ltlCntList.size() > 0){
                mapResult.put('SYOTAN', True);
            }else{
                mapResult.put('SYOTAN', False);
            }

            //受付情報、リクエスト情報に使うため、取引IDをマッピに格納
            mapResult.put(accountId,true);
        }
        
        return mapResult;
    }
}