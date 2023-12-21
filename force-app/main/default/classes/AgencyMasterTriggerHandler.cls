/*
* @Class Name      : AgencyMasterTriggerHandler
* @Description     : 代理店マスタトリガのハンドラー
* @Created Date    : 2019.09.05
* @Created By      : R.Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/
public class AgencyMasterTriggerHandler {

    public AgencyMasterTriggerHandler(){

    }

    /**
     * 代理店マスタ作成後処理
     * @param List<AgencyMaster__c>
     * @return 
     */
    public void afterInsertUpdateProcess(List<AgencyMaster__c> agencyMasterList, Map<Id,AgencyMaster__c> agencyMasterOldMap, Map<Id,AgencyMaster__c> agencyMasterNewMap,String operation){

        //生保契約用の代理店コードマップ
        Map<String,Id> seihoAgencyMasterMap = new Map<String,Id>();
        //損保契約用の代理店コードリスト
        List<String> sonpoAgencyCodeList = new List<String>();
        //損保契約用の代理店コードマップ
        Map<String,Id> sonpoAgencyMasterMap = new Map<String,Id>();
        //損保契約の更新用マップ
        Map<Id,SObject> damageConUpdateMap = new Map<Id,SObject>();
        //少短契約用の代理店コードマップ
        Map<String,Id> shotanAgencyMasterMap = new Map<String,Id>();

        if(operation.equals('insert')){
            for(AgencyMaster__c agency : agencyMasterList){
                if(!String.isEmpty(agency.SeihoAgencyCode__c)){
                    seihoAgencyMasterMap.put(agency.SeihoAgencyCode__c,agency.Id);
                }
                if(!String.isBlank(agency.SonpoAgencyCode__c)){
                    sonpoAgencyMasterMap.put(agency.SonpoAgencyCode__c,agency.Id);
                }
                if(!String.isEmpty(agency.ShotanAgencyCode__c)){
                    shotanAgencyMasterMap.put(agency.ShotanAgencyCode__c,agency.Id);
                }
            }
        }

        if(operation.equals('update')){
            System.debug('update operation');
            for(String agencyId : agencyMasterOldMap.keySet()){
                if(agencyMasterOldMap.get(agencyId).SeihoAgencyCode__c != agencyMasterNewMap.get(agencyId).SeihoAgencyCode__c){
                    //生保代理店コードが消された場合
                    if(agencyMasterNewMap.get(agencyId).SeihoAgencyCode__c == null){
                        seihoAgencyMasterMap.put(agencyMasterOldMap.get(agencyId).SeihoAgencyCode__c, null);
                    }else if(agencyMasterOldMap.get(agencyId).SeihoAgencyCode__c != null){
                        seihoAgencyMasterMap.put(agencyMasterOldMap.get(agencyId).SeihoAgencyCode__c, null);
                        seihoAgencyMasterMap.put(agencyMasterNewMap.get(agencyId).SeihoAgencyCode__c, agencyId);
                    }else{
                        //生保代理店コードが最初にセットされた場合
                        seihoAgencyMasterMap.put(agencyMasterNewMap.get(agencyId).SeihoAgencyCode__c, agencyId);
                    }
                }
                if(agencyMasterOldMap.get(agencyId).SonpoAgencyCode__c != agencyMasterNewMap.get(agencyId).SonpoAgencyCode__c){
                    //生保代理店コードが消された場合
                    if(agencyMasterNewMap.get(agencyId).SonpoAgencyCode__c == null){
                        sonpoAgencyMasterMap.put(agencyMasterOldMap.get(agencyId).SonpoAgencyCode__c, null);
                    }else if(agencyMasterOldMap.get(agencyId).SonpoAgencyCode__c != null){
                        sonpoAgencyMasterMap.put(agencyMasterOldMap.get(agencyId).SonpoAgencyCode__c, null);
                        sonpoAgencyMasterMap.put(agencyMasterNewMap.get(agencyId).SonpoAgencyCode__c,agencyId);
                    }else{
                        //損保代理店コードが最初にセットされた場合
                        sonpoAgencyMasterMap.put(agencyMasterNewMap.get(agencyId).SonpoAgencyCode__c, agencyId);
                    }
                }
                if(agencyMasterOldMap.get(agencyId).ShotanAgencyCode__c != agencyMasterNewMap.get(agencyId).ShotanAgencyCode__c){
                    //少短代理店コードが消された場合
                    if(agencyMasterNewMap.get(agencyId).ShotanAgencyCode__c == null){
                        shotanAgencyMasterMap.put(agencyMasterOldMap.get(agencyId).ShotanAgencyCode__c, null);
                    }else if(agencyMasterOldMap.get(agencyId).ShotanAgencyCode__c != null){
                        shotanAgencyMasterMap.put(agencyMasterOldMap.get(agencyId).ShotanAgencyCode__c, null);
                        shotanAgencyMasterMap.put(agencyMasterNewMap.get(agencyId).ShotanAgencyCode__c, agencyId);
                    }else{
                        //少短代理店コードが最初にセットされた場合
                        shotanAgencyMasterMap.put(agencyMasterNewMap.get(agencyId).ShotanAgencyCode__c, agencyId);
                    }
                }
            }
        }

        System.debug('--- seihoAgencyMasterMap ' + seihoAgencyMasterMap);
        System.debug('--- sonpoAgencyCodeList ' + sonpoAgencyCodeList);
        System.debug('--- sonpoAgencyMasterMap ' + sonpoAgencyMasterMap);
        System.debug('--- shotanAgencyMasterMap ' + shotanAgencyMasterMap);
        
        //代理店コードに紐付く生保契約情報の取得、更新処理
        if(seihoAgencyMasterMap != null && seihoAgencyMasterMap.size() > 0){

            Set<String> seihoAgencyMasterSet = new Set<String>(seihoAgencyMasterMap.keySet());
            // Delete 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　Start
            // List<LifeContract__c> lifeContractList = getLifeContract('AGENCY_NUM__c', seihoAgencyMasterSet);
        
            // for(LifeContract__c life : lifeContractList){
            //     life.AgencyId__c = seihoAgencyMasterMap.get(life.AGENCY_NUM__c);
            // }

            // UPDATE lifeContractList;
            // Delete 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　End
            // Add 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　Start
            BactchAgencyMasterUpdateSH batch = new BactchAgencyMasterUpdateSH(seihoAgencyMasterSet, seihoAgencyMasterMap);
            Database.executeBatch(batch,200);
            // Add 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　End
        }
       
        //代理店コードに紐付く損保契約情報の取得処理
        if(sonpoAgencyMasterMap != null && sonpoAgencyMasterMap.size() > 0){
            
            Set<String> sonpoAgencyMasterSet = new Set<String>(sonpoAgencyMasterMap.keySet());
            // Delete 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　Start
            // List<DamageContract__c> sonpoContractList = [SELECT Id, AgencyCode1__c, AgencyCode2__c, AgencyCode3__c, AgencyCode4__c, AgencyCode5__c,
            //                                              AgencyId1__c, AgencyId2__c, AgencyId3__c, AgencyId4__c, AgencyId5__c, AgencyCode__c FROM DamageContract__c 
            //                                              WHERE AgencyCode1__c IN: sonpoAgencyMasterSet OR AgencyCode2__c IN: sonpoAgencyMasterSet OR
            //                                              AgencyCode3__c IN: sonpoAgencyMasterSet OR AgencyCode4__c IN: sonpoAgencyMasterSet OR
            //                                              AgencyCode5__c IN: sonpoAgencyMasterSet];

            // for(DamageContract__c damage : sonpoContractList){
            //     damage.AgencyId1__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode1__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode1__c) : damage.AgencyId1__c;
            //     damage.AgencyId2__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode2__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode2__c) : damage.AgencyId2__c;
            //     damage.AgencyId3__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode3__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode3__c) : damage.AgencyId3__c;
            //     damage.AgencyId4__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode4__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode4__c) : damage.AgencyId4__c;
            //     damage.AgencyId5__c = sonpoAgencyMasterMap.containsKey(damage.AgencyCode5__c) ? sonpoAgencyMasterMap.get(damage.AgencyCode5__c) : damage.AgencyId5__c;
            // }
            // UPDATE sonpoContractList;
            // Delete 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　End
            // Add 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　Start
            BactchAgencyMasterUpdateDC batch = new BactchAgencyMasterUpdateDC(sonpoAgencyMasterSet, sonpoAgencyMasterMap);
            Database.executeBatch(batch,200);
            // Add 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　End
        }

        //代理店コードに紐付く少短契約情報の取得、更新処理
        if(shotanAgencyMasterMap != null && shotanAgencyMasterMap.size() > 0){

            Set<String> shotanAgencyMasterSet = new Set<String>(shotanAgencyMasterMap.keySet());
            // Delete 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　Start
            // List<LittleContract__c> littleContractList = getLittleContract('AgencyCode__c', shotanAgencyMasterSet);

            // for(LittleContract__c little : littleContractList){
            //     little.AgencyId__c = shotanAgencyMasterMap.get(little.AgencyCode__c);
            // }

            // UPDATE littleContractList;
            // Delete 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　End
            // Add 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　Start
            BactchAgencyMasterUpdateST batch = new BactchAgencyMasterUpdateST(shotanAgencyMasterSet, shotanAgencyMasterMap);
            Database.executeBatch(batch,200);
            // Add 2023/04/10 [RIPCRM-RIPCRM-858]_【内部】代理店マスタトリガ改修 By 範　End
        }
    }

    /**
     * 代理店マスタ削除後処理
     * @param List<AgencyMaster__c>
     * @return 
     */
    public void afterDeleteProcess(Map<Id,AgencyMaster__c> agencyMasterOldMap){

        //生保契約用の代理店コードマップ
        Map<String,Id> seihoAgencyMasterOldMap = new Map<String,Id>();
        //損保契約用の代理店コードマップ
        Map<String,Id> sonpoAgencyMasterOldMap = new Map<String,Id>();
        //少短契約用の代理店コードマップ
        Map<String,Id> shotanAgencyMasterOldMap = new Map<String,Id>();
        
        for(String agencyId : agencyMasterOldMap.keySet()){
            if(agencyMasterOldMap.get(agencyId).SeihoAgencyCode__c != null){
                seihoAgencyMasterOldMap.put(agencyMasterOldMap.get(agencyId).SeihoAgencyCode__c, agencyId);
            }
            if(agencyMasterOldMap.get(agencyId).SonpoAgencyCode__c != null){
                sonpoAgencyMasterOldMap.put(agencyMasterOldMap.get(agencyId).SonpoAgencyCode__c, agencyId);
            }
            if(agencyMasterOldMap.get(agencyId).ShotanAgencyCode__c != null){
                shotanAgencyMasterOldMap.put(agencyMasterOldMap.get(agencyId).ShotanAgencyCode__c, agencyId);
            }
        }

        //代理店コードに紐付く生保契約情報の削除処理
        if(seihoAgencyMasterOldMap != null && seihoAgencyMasterOldMap.size() > 0){

            Set<String> seihoAgencyMasterOldSet = new Set<String>(seihoAgencyMasterOldMap.keySet());
            List<LifeContract__c> lifeContractList = getLifeContract('AgencyId__c', seihoAgencyMasterOldSet);

            for(LifeContract__c life : lifeContractList){
                life.AgencyId__c = null;
            }
            UPDATE lifeContractList;
        }

        //代理店コードに紐付く損保契約情報の削除処理
        if(sonpoAgencyMasterOldMap != null && sonpoAgencyMasterOldMap.size() > 0){

            Set<String> sonpoAgencyMasterOldSet = new Set<String>(sonpoAgencyMasterOldMap.keySet());
            List<DamageContract__c> sonpoContractList = getDamageContract(sonpoAgencyMasterOldSet);
            
            for(DamageContract__c damage : sonpoContractList){
                damage.AgencyId1__c = sonpoAgencyMasterOldMap.get(damage.AgencyId1__c) != null ? null : damage.AgencyId1__c;
                damage.AgencyId2__c = sonpoAgencyMasterOldMap.get(damage.AgencyId2__c) != null ? null : damage.AgencyId2__c;
                damage.AgencyId3__c = sonpoAgencyMasterOldMap.get(damage.AgencyId3__c) != null ? null : damage.AgencyId3__c;
                damage.AgencyId4__c = sonpoAgencyMasterOldMap.get(damage.AgencyId4__c) != null ? null : damage.AgencyId4__c;
                damage.AgencyId5__c = sonpoAgencyMasterOldMap.get(damage.AgencyId5__c) != null ? null : damage.AgencyId5__c;
            }
            UPDATE sonpoContractList;
        }

        //代理店コードに紐付く少短契約情報の削除処理
        if(shotanAgencyMasterOldMap != null && shotanAgencyMasterOldMap.size() > 0){

            Set<String> shotanAgencyMasterOldSet = new Set<String>(shotanAgencyMasterOldMap.keySet());
            List<LittleContract__c> littleContractList = getLittleContract('AgencyId__c', shotanAgencyMasterOldSet);
            
            for(LittleContract__c little : littleContractList){
                little.AgencyId__c = null;
            }
            UPDATE littleContractList;
        }
    }

    /**
     * 代理店に紐付く生保契約情報の取得
     * @param String
     * @param Set<String>
     * @return 
     */
    private static List<LifeContract__c> getLifeContract(String searchField, Set<String> seihoAgencyMasterSet){

        String queryString = 'SELECT Id, AgencyId__c, AGENCY_NUM__c FROM LifeContract__c WHERE ' + searchField + ' IN: seihoAgencyMasterSet';
        List<LifeContract__c> lifeContractList = Database.query(queryString);

        return lifeContractList;
    }

    /**
     * 代理店に紐付く少短契約情報の取得
     * @param String
     * @param Set<String>
     * @return 
     */
    private static List<LittleContract__c> getLittleContract(String searchField, Set<String> shotanAgencyMasterSet){

        List<LittleContract__c> littleContractList = new List<LittleContract__c>();
        String queryString = 'SELECT Id, AgencyId__c, AgencyCode__c FROM LittleContract__c WHERE ' + searchField + ' IN: shotanAgencyMasterSet';
        System.debug('queryString ' + queryString);
        littleContractList = Database.query(queryString);

        return littleContractList;
    }

    /**
     * 代理店に紐付く損保契約情報の取得
     * @param Set<String>
     * @return 
     */
    private static List<DamageContract__c> getDamageContract(Set<String> sonpoAgencyMasterOldSet){

        List<DamageContract__c> sonpoContractList = [SELECT Id, AgencyId1__c, AgencyId2__c, AgencyId3__c, AgencyId4__c, AgencyId5__c, AgencyCode__c FROM DamageContract__c 
                                                            WHERE AgencyId1__c IN: sonpoAgencyMasterOldSet OR AgencyId2__c IN: sonpoAgencyMasterOldSet OR 
                                                            AgencyId3__c IN: sonpoAgencyMasterOldSet OR AgencyId4__c IN: sonpoAgencyMasterOldSet OR
                                                            AgencyId5__c IN: sonpoAgencyMasterOldSet];

        return sonpoContractList;
    }

}