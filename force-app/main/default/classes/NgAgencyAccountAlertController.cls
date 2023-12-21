public class NgAgencyAccountAlertController {
    /*
     * 保全禁止代理店有り顧客取得
     */
    @AuraEnabled
    public static NgAgencyHelper.NgAgencyList getWarningAgency(String accountId){
        return NgAgencyHelper.getNgAgency(accountId); 
    }
}