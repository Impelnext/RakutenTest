public class OppCreateDefaultValueAuraController {
    
    /*
     * 取引先カナ名取得
     */
    @AuraEnabled
    public static String getAccFurigana(String recordId){
        return AccountHelper.getAccFurigana(recordId); 
    }
    /*
     * 商談レコードID取得
     */
    @AuraEnabled
    public static Map<String,String> getRType(){
        Map<String,String> mapResult = new Map<String,String>();
        Map<String,Profile> mapProf = new Map<String,Profile>();
        Map<String,RecordType> mapRType = new Map<String,RecordType>();
        
        // プロファイルの一覧を取得
        List<Profile> listProf =  [SELECT Id,Name FROM Profile];
        for(Profile p : listProf){
            mapProf.put(p.Name,p);
        }
        
        // 商談のレコードIDの一覧を取得
        List<RecordType> listRType =  [SELECT Id,Name FROM RecordType WHERE SobjectType = 'Opportunity'];
         for(RecordType r : listRType){
            mapRType.put(r.Name,r);
        }
        
        // ユーザープロファイルが使用可能な商談のレコードIDの一覧を返却
        String strProf = UserInfo.getProfileId();
        if(strProf.equals(mapProf.get('生保担当ロール').Id)){
            mapResult.put('生保',mapRType.get('生保').Id);
        }else if(strProf.equals(mapProf.get('損保担当ロール').Id)){
            mapResult.put('損保',mapRType.get('損保').Id);
        }else if(strProf.equals(mapProf.get('少短担当ロール').Id)){
            mapResult.put('少短',mapRType.get('少短').Id);
        }else if(strProf.equals(mapProf.get('新会社参照用ロール').Id)){
            // NO CREATE ACCESS
        }else{
            mapResult.put('生保',mapRType.get('生保').Id);
            mapResult.put('損保',mapRType.get('損保').Id);
            mapResult.put('少短',mapRType.get('少短').Id);
        }
        return mapResult;
    }
}