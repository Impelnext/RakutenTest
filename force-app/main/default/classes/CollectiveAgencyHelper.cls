/****************************************************************************************/
/* Class Name       : CollectiveAgencyHelper                                            */
/* Description      : 集団扱い代理店の判定共通クラス                                    */
/* @Created Date    : 2021.07.20                                                        */
/* @Created By      : Sam jeshwin raj / Geelani                                         */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public class CollectiveAgencyHelper {
    
    /**
     * 集団扱い代理店有り顧客取得
     * @param  String
     * @return CollectiveAgencyList
     */
    public static CollectiveAgencyList getCollectiveAgency(String accountId){
        
        System.debug('accountId:' + accountId);
        CollectiveAgencyList collectiveAgencyList = new CollectiveAgencyList();
        
        // 取引先検索
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        
        if(accounts.size() == 0){
            return collectiveAgencyList;
        }
        
        // 損保契約検索
        AggregateResult[] groupedResults
                        = [SELECT AgencyCode__c 
                           FROM DamageContract__c 
                           WHERE AgencyCode__c != null
                             AND AccountId__c = :accountId
                           GROUP BY AgencyCode__c];
        
        Account account = accounts[0];
        
        // すべての集団扱い代理店名を取得(TRIM)
        List<String> allAgencyList = new List<String>();
        for(AggregateResult r : groupedResults){
            if(r.get('AgencyCode__c') != null){
                for(String agency : ((String)r.get('AgencyCode__c')).split(',')){
                    allAgencyList.add(StringUtil.trim(agency));
                }
            }
        }
        
        // 集団扱い代理店マップを取得(代理店名：代理店レコード)
        Map<String, CollectiveAgency__c> collectiveAgencyMap = getCollectiveAgencyMap(allAgencyList);
        System.debug(collectiveAgencyMap);
        
        for(AggregateResult r : groupedResults){
            if(collectiveAgencyList.collectiveList.size() >=10){
                collectiveAgencyList.hasMore = true;
                break;
            }
            List<String> agencyList = ((String)r.get('AgencyCode__c')).split(',');
            for(String agency : agencyList){
                if(collectiveAgencyList.collectiveList.size() >=10){
                    collectiveAgencyList.hasMore = true;
                    break;
                }
                if(collectiveAgencyMap .containsKey(StringUtil.trim(agency))){
                    // 該当代理店が集団扱い代理店の場合
                    collectiveAgencyList.addCollectiveAgency(collectiveAgencymap.get(StringUtil.trim(agency)));
                }
            }
        }
        return collectiveAgencyList;
    }
    
    /*
     * 損保契約が集団扱い代理店を判断する
     */
    public static boolean isCollectiveAgencyContract(String contractId){
        List<DamageContract__c> contractList = [SELECT Id,AgencyCode__c 
                                       FROM DamageContract__c
                                       WHERE Id = :contractId];
        if(contractList.size() == 0){
            return false;
        }
        
        if(contractList[0].AgencyCode__c != null){
            List<String> agencys = contractList[0].AgencyCode__c.split(',');
            List<String> trimedAgency = new List<String>();
            for(String agency : agencys){
                trimedAgency.add(StringUtil.trim(agency));
            }
            Map<String, CollectiveAgency__c> collectiveAgencyMap= getCollectiveAgencyMap(trimedAgency);
            if(collectiveAgencyMap.values().size() > 0){
                return true;
            }else{
                return false;
            }
        }
        
        return false;
    }
    
    /**
     * 集団扱い代理店マップを取得(代理店名：代理店レコード)
     * @param  List<String>
     * @return Map<String, CollectiveAgency__c>
     */
    public static Map<String, CollectiveAgency__c> getCollectiveAgencyMap(List<String> allAgencyList){
        Map<String, CollectiveAgency__c> result = new Map<String, CollectiveAgency__c>();
        List<CollectiveAgency__c> collectivetAgencyList = [SELECT Id, AgencyNo__c, Message__c
                                          FROM CollectiveAgency__c 
                                          WHERE AgencyNo__c IN : allAgencyList];
        for(CollectiveAgency__c collectiveAgency : collectivetAgencyList){
            result.put(collectiveAgency.AgencyNo__c, collectiveAgency);
        }
        
        return result;
    }
    
    /**
     * 画面用モデルオブジェクト
     * @Class Name      : CollectiveAgencyList
     * @Description     : Wrapper Class for List of CollectiveAgency__c
     */
    public class CollectiveAgencyList {
        @AuraEnabled public List<CollectiveAgency__c> collectiveList{get;set;}
        @AuraEnabled public boolean hasMore{get;set;}
        public CollectiveAgencyList (){
            collectiveList= new List<CollectiveAgency__c>();
        }
        public void addCollectiveAgency(CollectiveAgency__c collectivetAgency){
            collectiveList.add(collectivetAgency);
        }
    }
}