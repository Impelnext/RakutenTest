public class RequestSpecialContractReductionCmpCont {

    @AuraEnabled //get Picklist Values
    public static Map<String, String> getSinglePicklist(String objectName,String fieldName){
        Map<String, String> options = ReceptionController.getSinglePicklist(objectName,fieldName);    
        return options;
    }
}