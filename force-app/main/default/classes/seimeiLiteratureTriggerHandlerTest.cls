@isTest
public class seimeiLiteratureTriggerHandlerTest {
    
    static testmethod void onBeforeProcess(){
        test.startTest();
        account acc=createAccountTestData('test','NX0001');
       seimeiDocumentMaster__c semeiDocument=seimeiDocumenTestData('DC0001');
        seimeiLiterature__c semei=createseimeiLiteratureTestData('NX0001','DC0001');
        test.stopTest();
        seimeiLiterature__c sem=[select Account__c,SeimeiDocMaster__c from seimeiLiterature__c where id=:semei.Id ];
        system.assertEquals(sem.Account__c, acc.id);
        system.assertEquals(sem.SeimeiDocMaster__c, semeiDocument.Id);
    }
     static testmethod void noRelatedDate(){
        test.startTest();
        account acc=createAccountTestData('test','NX0002');
       seimeiDocumentMaster__c semeiDocument=seimeiDocumenTestData('DC0001');
        seimeiLiterature__c semei=createseimeiLiteratureTestData('NX0001','DC0002');
        test.stopTest();
        
    }
    static testmethod void updateSemeiLateralCsid(){
        account acc=createAccountTestData('test','NX0001');
        seimeiLiterature__c semei=createseimeiLiteratureTestData('NX0001','DC0001');
        semei.CSID__c='';
        semei.DocumentCode__c='';
        test.startTest();
        update semei;
        test.stopTest();
        seimeiLiterature__c sem=[select Account__c,SeimeiDocMaster__c from seimeiLiterature__c where id=:semei.Id ];
        system.assertEquals(sem.Account__c, null);
         system.assertEquals(sem.SeimeiDocMaster__c, null);
    }
private static Account createAccountTestData(String identifier,String csId){

		Account acc = new Account(
			FirstName = 'user_' + identifier,
			LastName = 'Test',
			furiganaForst__pc = 'ユーザー_' + identifier,
			furiganaLast__pc = 'テスト',
			Gender__pc = '男性',
			CSID__pc = csId
			
		);
		insert acc;

		return acc;
	}
    private static seimeiLiterature__c createseimeiLiteratureTestData(string csid,string docCode){
        seimeiLiterature__c semei=new seimeiLiterature__c();
        semei.CSID__c=csid;
        semei.DocumentCode__c=docCode;
        insert semei;
        return semei;
    }
    private static seimeiDocumentMaster__c seimeiDocumenTestData(string docCode ){
        seimeiDocumentMaster__c semeiDocument=new seimeiDocumentMaster__c();
        semeiDocument.DocumentCode__c=docCode;
        semeiDocument.DocumentName__c='test';
        insert semeiDocument;
        return semeiDocument;
    }
    
}