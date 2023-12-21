public class RequestControllerHandlerTest{
    //public static Account ac;
    public static id createAccount(String accountName){
                
        Account ac =  RequestControllerHandlerTest.createAccount();
        insert ac;
        
        LifeContract__c lc = new LifeContract__c();       
        lc.AccountId__c = ac.Id;
        //insert lc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.AccountId__c = ac.id;
        //insert dc;
        
        LittleContract__c litCon = new LittleContract__c();
        litCon.AccountId__c = ac.id;
        //insert litCon;
        
        return ac.id;
    }
    
    public static List<Id> createContracts(Id accountId){
              
        List<Id> contractIds = new List<Id> ();
        
        LifeContract__c lc = new LifeContract__c();       
        lc.AccountId__c = accountId;
        insert lc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.AccountId__c = accountId;
        insert dc;
        
        LittleContract__c litCon = new LittleContract__c();
        litCon.AccountId__c = accountId;
        insert litCon;
        
        contractIds.add(lc.id);
        contractIds.add(dc.id);
        contractIds.add(litCon.id);
        
        return contractIds;
    }
    
    public static id createReception(String receptionName,Id accountId){
              
        
        Reception__c rec = new Reception__c();
        rec.Account__c = accountId;
        // Add 2023/01/05 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
        rec.PrimaryCompletion_MajorItem__c = '①【センター解決対象外】';
        rec.PrimaryCompletion_MediumItem__c = '他チームのOPへ転送した（紛れ入電、お客さまの間違い）';
        // Add 2023/01/05 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End
        insert rec;
        return rec.id;
    }
    public static Request__c saveRequest(String className, String type,String subject,Id accountId,Id receptionId,List<String> selectPolicyNumbers,Map<String,String> getPolicyMap) {
        Request__c req = new Request__c();
        req.Class__c = className;
        req.Type__c = type;
        req.Subject__c = subject;
        req.PolicyNumber1__c = getPolicyMap.get('PolicyNumber1');
        req.PolicyNumber2__c = getPolicyMap.get('PolicyNumber2');
        req.PolicyNumber3__c = getPolicyMap.get('PolicyNumber3');
        req.PolicyNumber4__c = getPolicyMap.get('PolicyNumber4');
        req.PolicyNumber5__c = getPolicyMap.get('PolicyNumber5');
        req.PolicyNumber6__c = getPolicyMap.get('PolicyNumber6');
        req.PolicyNumber7__c = getPolicyMap.get('PolicyNumber7');
        req.PolicyNumber8__c = getPolicyMap.get('PolicyNumber8');
        req.PolicyNumber9__c = getPolicyMap.get('PolicyNumber9');
        req.PolicyNumber10__c = getPolicyMap.get('PolicyNumber10');
        req.ChangeAgencyRegistration__c = '有';
        insert req;
        
        return req;
    }
    
    private static account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(LastName='個人',FirstName='取引先',RecordTypeId=recordTypes[0].Id);
    }
    
    
}