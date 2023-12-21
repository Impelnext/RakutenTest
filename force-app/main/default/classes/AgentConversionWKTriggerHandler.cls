public class AgentConversionWKTriggerHandler {
    
    // コンストラクタ
    public AgentConversionWKTriggerHandler() {
        
    }
    
    // 代理店コードの洗い替え
    public void onBeforeProcess(List<agentConversionWK__c> agentConversionWKList) {
        
        System.debug('agentConversionWKList：' + agentConversionWKList.size());
        
        // 代理店変換マスタ メタデータ取得
        List<AgencyConversionSetting__mdt> convSettings = [SELECT DeveloperName, MasterLabel, O_AgencyCodeField__c, N_AgencyCodeField__c 
                                                           FROM AgencyConversionSetting__mdt ORDER BY DeveloperName];
        //  代理店変換WK
        SObject obj = new AgentConversionWK__c(); 
        Set<String> agentCodeSet = new Set<String>();
        
        for (agentConversionWK__c wk : agentConversionWKList) {
            for (Integer cnt=0; cnt < convSettings.size(); cnt++) {
                AgencyConversionSetting__mdt setting = convSettings.get(cnt);
                agentCodeSet.add((String)wk.get(setting.O_AgencyCodeField__c));
            }
        }
        
        Map<String, String> codeMap = new Map<String, String>();
        for (agentConversionMaster__c master : [SELECT Id, Agency_code_Old__c, Agency_code_New__c 
                                                FROM agentConversionMaster__c 
                                                WHERE Agency_code_Old__c = :agentCodeSet]) {
            codeMap.put(master.Agency_code_Old__c, master.Agency_code_New__c);
        }
        // 	新しいコードをセット
        for (agentConversionWK__c wk : agentConversionWKList) {
        	for (Integer cnt=0; cnt < convSettings.size(); cnt++) {
            	AgencyConversionSetting__mdt setting = convSettings.get(cnt);
                String o_code = (String)wk.get(setting.O_AgencyCodeField__c);
                String n_code = (codeMap.containsKey(o_code)) ? codeMap.get(o_code) :(String) wk.get(setting.O_AgencyCodeField__c);
                wk.put(setting.N_AgencyCodeField__c, n_code);
            }
        }
    
    }
    
    public void joinSkAgencyCode( List<SObject> agentConversionWK ) {
        String prefix = 'SK_N_AgencyCode';
        Map<String, SObjectField> fieldMap = agentConversionWK.getSObjectType().getDescribe().fields.getMap();
        List<String> fieldNameList = new List<String>();
        // JOIN対象項目の抽出
        for(Integer count = 0; count < fieldMap.size(); count++) {
            String fieldName = prefix + (count+1) + '__c';
            if( !fieldMap.containsKey(fieldName) ) {
                break;
            }
            fieldNameList.add(fieldName);
        }
        
        // 代理店コードの結合
        for(SObject obj : agentConversionWK ) {
            List<String> agencyCodeList = new List<String>();
            for( String fieldName : fieldNameList ) {
                String agencyCode = (String)obj.get(fieldName);
                if( !String.isEmpty(agencyCode) ) {
                    agencyCodeList.add(agencyCode);
                }
            }
            obj.put('SK_N_AgencyCode__c', String.join(agencyCodeList, ','));
        }
    }

}