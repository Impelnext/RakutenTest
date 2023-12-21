/*
* @Class Name      : ReceptionPageButtonCmpController 
* @Description     : リクエスト登録情報のコントロール
* @Created Date    : 2019.10.08
* @Created By      : R.Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/
public class RequestPageButtonCmpController {

    @AuraEnabled
    public static Map<String,Boolean> getAccountContract(String requestId){

        System.debug('request ID ' + requestId);

        List<Request__c> requestList = [SELECT Reception__r.Account__c FROM Request__c WHERE Id =: requestId LIMIT 1];
        String accountId = requestList.size() > 0 ? requestList.get(0).Reception__r.Account__c : ''; 
        System.debug('accountId ' + accountId);
        return ContractCount.getContractCount(accountId);
    }
}