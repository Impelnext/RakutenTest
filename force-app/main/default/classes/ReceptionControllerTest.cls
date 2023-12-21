@isTest
private class ReceptionControllerTest{

  @isTest
  static void TestSaveReception(){
   integer clone=1;
      Account ac =  ReceptionControllerTest.createAccount();
      insert ac;
      
      Reception__c rec = new Reception__c();
      rec.Account__c = ac.id;
      rec.PrimaryCompletion_MajorItem__c ='①【センター解決対象外】'; 
      rec.PrimaryCompletion_MediumItem__c ='その他';
      insert rec;
      
      Map<String, String> areaInfoMap = new Map<String, String> ();
      areaInfoMap.put('prefecture','prefecture');
      areaInfoMap.put('municipality','municipality');
      areaInfoMap.put('chome','chome');
      
      Test.startTest(); 
      ReceptionController.saveReception(rec, ac.id,areaInfoMap,clone);   
      ReceptionController.saveReception(rec, ac.id,areaInfoMap,null); 
      ReceptionController.saveReception(rec,null,areaInfoMap,null); 
      ReceptionController.getAccReceptionDetails(rec.id);
      ReceptionController.getAccDetails(ac.id);
      ReceptionController.getContractInfo(ac.id);
      ReceptionController.getSinglePicklist('Reception__c','RelationshipWithContractor__c');
      ReceptionController.getMultiPiklistValues('Reception__c', 'LT_InquiryName__c');
      ReceptionController.getAccountContract(ac.id);
      ReceptionController.getDependentMap('Reception__c','PrimaryCompletion_MajorItem__c', 'PrimaryCompletion_MediumItem__c');
      
      Test.stopTest();
   
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