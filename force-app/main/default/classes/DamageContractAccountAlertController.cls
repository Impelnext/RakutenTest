public class DamageContractAccountAlertController {
	/*
     * 取引先情報取得
     */
    @AuraEnabled
    public static Account getAccountInfo(String recordId){
        List<Account> accountList = [SELECT Id,Name,DamageUse__pc 
                                     FROM Account
                                     WHERE Id = :recordId];
        if(accountList.size() > 0){
            return accountList[0];
        }else{
            return null;
        }
    }
}