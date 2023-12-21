public class NgAgencyAlertController {
    /*
     * 保全禁止代理店有り顧客取得
     */
    @AuraEnabled
    public static NgAgencyHelper.NgAgencyList getWarningAgency(String recordId){
        return NgAgencyHelper.getNgAgency(recordId); 
    }
}