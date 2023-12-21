public class NGAgencyContractAlertController {
    /*
     * NG代理店判断
     */
    @AuraEnabled
    public static boolean isNGAgencyContract(String contractId){
        return NgAgencyHelper.isNGAgencyContract(contractId); 
    }
}