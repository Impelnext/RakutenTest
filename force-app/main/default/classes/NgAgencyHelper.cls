public class NgAgencyHelper {
    
    /*
     * 保全禁止代理店有り顧客取得
     */
    public static NgAgencyList getNgAgency(String accountId){
        
        System.debug('accountId:' + accountId);
        NgAgencyList ngAgencyList = new NgAgencyList();
        
        // 取引先検索
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        
        if(accounts.size() == 0){
            return ngAgencyList;
        }
        
        // 損保契約検索
        // 代理店コードがNG代理店にいる＋損保契約情報の幹事代理店がある場合、
        // エラーメッセージを表示させます。
        List<DamageContract__c> results
                        = [SELECT AgencyCode__c, AgencyCode1__c 
                           FROM DamageContract__c 
                           WHERE AgencyCode__c != NULL 
                             AND AgencyCode1__c != NULL 
                             AND AccountId__c = :accountId];
        
        Account account = accounts[0];
        
        // すべての代理店名を取得(TRIM)
        Set<String> allAgencyList = new Set<String>();
        
        for(DamageContract__c r : results){
            // 契約の代理店コードの判定
            for(String agency : r.AgencyCode__c.split(',')){
                allAgencyList.add(StringUtil.trim(agency));
            }
            
            // 契約主幹事代理店コードの判定
            allAgencyList.add(r.AgencyCode1__c);
        }
        
        // NG代理店マップを取得(代理店名：代理店レコード)
        Map<String, NgAgency__c> ngAgencyMap = getNgAgencyMap(new List<String>(allAgencyList));
        System.debug(ngAgencyMap);
        
        for(DamageContract__c r : results){
            if(ngAgencyList.ngList.size() >=10){
                ngAgencyList.hasMore = true;
                break;
            }
            
            // 主幹事代理店はNG代理店以外の場合、なにもしない
            if (!ngAgencyMap.containsKey(r.AgencyCode1__c)){
                continue;
                // NOTREACHED
            }
            
            List<String> agencyList = r.AgencyCode__c.split(',');
            for(String agency : agencyList){
                if(ngAgencyList.ngList.size() >=10){
                    ngAgencyList.hasMore = true;
                    break;
                }
                if(ngAgencyMap.containsKey(StringUtil.trim(agency))){
                    // 該当代理店がＮＧ代理店の場合
                    ngAgencyList.addNgAgency(ngAgencymap.get(StringUtil.trim(agency)));
                }
            }
        }
        
        return ngAgencyList;
    }
    
    /*
     * 損保契約がNG代理店かを判断する
     */
    public static boolean isNGAgencyContract(String contractId){
        // 代理店コードがNG代理店にいる＋損保契約情報の幹事代理店がある場合、
        // エラーメッセージを表示させます。
        List<DamageContract__c> contractList = [SELECT Id,AgencyCode__c, AgencyCode1__c  
                                       FROM DamageContract__c
                                       WHERE Id = :contractId 
                                         AND AgencyCode__c != NULL 
                                         AND AgencyCode1__c != NULL];
        if(contractList.size() == 0){
            return false;
        }
        
        if(contractList[0].AgencyCode__c != null){
            DamageContract__c contract = contractList[0];
            List<String> agencys = contract.AgencyCode__c.split(',');
            Set<String> trimedAgency = new Set<String>();
            for(String agency : agencys){
                trimedAgency.add(StringUtil.trim(agency));
            }
            // 主幹事代理店コードを取得
            trimedAgency.add(contract.AgencyCode1__c);
            
            Map<String, NgAgency__c> ngAgencyMap = getNgAgencyMap(new List<String>(trimedAgency));
            // 主幹事代理店はNG代理店の場合、NG代理店の判定
            if (ngAgencyMap.containsKey(contract.AgencyCode1__c)){
                for(String agency : agencys){
                    if (ngAgencyMap.containsKey(StringUtil.trim(agency))){
                        return true;
                        // NOTREACHED
                    }
                }
            }
        }
        
        return false;
    }
    
    /*
     * NG代理店マップを取得(代理店名：代理店レコード)
     */
    public static Map<String, NgAgency__c> getNgAgencyMap(List<String> allAgencyList){
        Map<String, NgAgency__c> result = new Map<String, NgAgency__c>();
        List<NgAgency__c> ngAgencyList = [SELECT Id, AgencyNo__c, Message__c
                                          FROM NGAgency__c 
                                          WHERE AgencyNo__c IN : allAgencyList];
        for(NgAgency__c ngAgency : ngAgencyList){
            result.put(ngAgency.AgencyNo__c, ngAgency);
        }
        
        return result;
    }
    
    /*
     * 画面用モデルオブジェクト
     */
    public class NgAgencyList{
        @AuraEnabled public List<NGAgency__c> ngList{get;set;}
        @AuraEnabled public boolean hasMore{get;set;}
        public NGAgencyList(){
            ngList = new List<NGAgency__c>();
        }
        public void addNgAgency(NGAgency__c ngAgency){
            ngList.add(ngAgency);
        }
    }
}