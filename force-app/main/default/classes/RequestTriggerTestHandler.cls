public class RequestTriggerTestHandler{

public static set<string> reqid = new set<String>();

    public static Request__c RequestTriggerTest(String className,String type,Id RecpId)
    {
    
        Request__c req1 = new Request__c();
        req1.Name = '12345';
        req1.Class__c = className;
        req1.Type__c = type;
        req1.Subject__c = '事由';
        req1.ChangeAgencyRegistration__c = '有';
        req1.AGRegistrationChange__c = '有';
        req1.JuniorSpecialContract__c = '有';
        req1.RecruiterRegistration__c ='有';
        req1.Reception__c = RecpId;
        req1.ReflectTheAddressOfTheInsuredPerson__c = true;
        req1.ReflectMailingAddress__c = true;
        req1.IsReflectDeliveryAddress__c = true;
        return req1;
         
        }
    
    public static Request__c RequestTriggerUpdate(String className,String type,Id recepId)
    {
         
         
         Request__c req7 = new Request__c();
         req7 = [Select id,Name,ReflectMailingAddress__c,ReflectTheAddressOfTheInsuredPerson__c,IsReflectDeliveryAddress__c ,Type__c,Class__c from Request__c where id!=: reqid limit 1];
         reqid.add(req7.id);
         req7.ReflectMailingAddress__c = true;
         req7.ReflectTheAddressOfTheInsuredPerson__c = true;
         req7.IsReflectDeliveryAddress__c = true;
         req7.Type__c = type;
          req7.Class__c  = className;
          req7.Reception__c = recepId;
          req7.Subject__c = '事由';
         return req7;
            
   }

}