/*
* @Class Name      : ReceptionPageButtonCmpController 
* @Description     : 受付登録情報のコントロール
* @Created Date    : 2019.10.08
* @Created By      : R.Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/
public class ReceptionPageButtonCmpController {
    
    @AuraEnabled
    public static Map<String,Boolean> getAccountContract(String receptionId){

        List<Reception__c> receptionList = [SELECT Account__c FROM Reception__c WHERE Id =: receptionId];
        String accountId = receptionList.size() > 0 ? receptionList.get(0).Account__c : ''; 
        return ContractCount.getContractCount(accountId);
    }
}