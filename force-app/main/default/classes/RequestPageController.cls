public class RequestPageController {
    @AuraEnabled
    public static String getRequestId(String recordId){
        //ケースの親リクエストを取得
        Case record = [Select Id, RequestReference__r.Id from Case Where Id = :recordId];
        String recId = record.RequestReference__r.Id;
        system.debug(recId);
        return recId;
    }
}