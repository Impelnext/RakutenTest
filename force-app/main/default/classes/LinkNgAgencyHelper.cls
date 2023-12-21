/****************************************************************************************/
/* Class Name       : LinkNgAgencyHelper                                                */
/* Description      : 保全禁止連携代理店の判定共通クラス                                */
/* @Created Date    : 2021.03.09                                                        */
/* @Created By      : Valsala Kumar J                                                   */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public class LinkNgAgencyHelper {
    
    /**
     * 保全禁止連携代理店有り顧客取得
     * @param  String
     * @return LinkNgAgencyList
     */
    public static LinkNgAgencyList getNgAgency(String accountId){
        
        System.debug('accountId:' + accountId);
        LinkNgAgencyList ngAgencyList = new LinkNgAgencyList();
        
        // 取引先検索
        List<Account> accounts = [SELECT Id FROM Account WHERE Id = :accountId];
        
        if(accounts.size() == 0){
            return ngAgencyList;
        }
        
        // 損保契約検索
        AggregateResult[] groupedResults
                        = [SELECT AgencyCode__c 
                           FROM DamageContract__c 
                           WHERE AgencyCode__c != null
                             AND AccountId__c = :accountId
                           GROUP BY AgencyCode__c];
        
        Account account = accounts[0];
        
        // すべての連携NG代理店名を取得(TRIM)
        List<String> allAgencyList = new List<String>();
        for(AggregateResult r : groupedResults){
            if(r.get('AgencyCode__c') != null){
                for(String agency : ((String)r.get('AgencyCode__c')).split(',')){
                    allAgencyList.add(StringUtil.trim(agency));
                }
            }
        }
        
        // 連携NG代理店マップを取得(代理店名：代理店レコード)
        Map<String, LinkNGAgencyCode__c> ngAgencyMap = getNgAgencyMap(allAgencyList);
        System.debug(ngAgencyMap);
        
        for(AggregateResult r : groupedResults){
            if(ngAgencyList.ngList.size() >=10){
                ngAgencyList.hasMore = true;
                break;
            }
            List<String> agencyList = ((String)r.get('AgencyCode__c')).split(',');
            for(String agency : agencyList){
                if(ngAgencyList.ngList.size() >=10){
                    ngAgencyList.hasMore = true;
                    break;
                }
                if(ngAgencyMap.containsKey(StringUtil.trim(agency))){
                    // 該当連携代理店がＮＧ連携代理店の場合
                    ngAgencyList.addNgAgency(ngAgencymap.get(StringUtil.trim(agency)));
                }
            }
        }
        return ngAgencyList;
    }
    
    /*
     * 損保契約が連携NG代理店かを判断する
     */
    public static boolean isNGAgencyContract(String contractId){
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
            Map<String, LinkNGAgencyCode__c> ngAgencyMap = getNgAgencyMap(trimedAgency);
            if(ngAgencyMap.values().size() > 0){
                return true;
            }else{
                return false;
            }
        }
        
        return false;
    }
    
    /**
     * 連携NG代理店マップを取得(代理店名：代理店レコード)
     * @param  List<String>
     * @return Map<String, LinkNGAgencyCode__c>
     */
    public static Map<String, LinkNGAgencyCode__c> getNgAgencyMap(List<String> allAgencyList){
        Map<String, LinkNGAgencyCode__c> result = new Map<String, LinkNGAgencyCode__c>();
        List<LinkNGAgencyCode__c> ngAgencyList = [SELECT Id, AgencyCode__c, Message__c
                                          FROM LinkNGAgencyCode__c 
                                          WHERE AgencyCode__c IN : allAgencyList];
        for(LinkNGAgencyCode__c ngAgency : ngAgencyList){
            result.put(ngAgency.AgencyCode__c, ngAgency);
        }
        
        return result;
    }
    
    /**
     * 画面用モデルオブジェクト
     * @Class Name      : LinkNgAgencyList
     * @Description     : Wrapper Class for List of LinkNGAgencyCode__c
     */
    public class LinkNgAgencyList {
        @AuraEnabled public List<LinkNGAgencyCode__c> ngList{get;set;}
        @AuraEnabled public boolean hasMore{get;set;}
        public LinkNgAgencyList(){
            ngList = new List<LinkNGAgencyCode__c>();
        }
        public void addNgAgency(LinkNGAgencyCode__c ngAgency){
            ngList.add(ngAgency);
        }
    }
}