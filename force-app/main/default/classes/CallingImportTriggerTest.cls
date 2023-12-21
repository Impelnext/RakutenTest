@isTest
public class CallingImportTriggerTest {

    @isTest
    static void setCaseReference(){
        test.startTest();
        createCallingImport();
        test.stoptest();
    }

    @isTest
    static void createCallingImport(){
    
        Account acc = createAccountTestData();
        List<Request__c>  req = createRequestTestData();
        List<SeihoAgencyMaster__c> agnc = createAgencyMasterTestData();
        List<SeihoRecruiterMaster__c> rec = createRecruiterMasterTestData();
        List<callingImport__c> callingImports = new List<callingImport__c>();
        callingImport__c  calling1 = new callingImport__c();
        calling1.CustomerNo__c = acc.csid__pc;
        calling1.ReceptionDatetime__c = datetime.newInstance(2019,5, 28, 1, 6, 8);
        calling1.CallListType__c = '契約確認コール';
        calling1.Description__c = 'callingtest1';
        callingImport__c  calling2 = new callingImport__c();
        calling2.ReceptionDatetime__c = datetime.newInstance(2019,5, 28, 1, 6, 8);
        calling2.CallListType__c = '継続フォロー';
        calling2.Description__c = 'callingtest1';
        calling2.SeihoAgencyNo__c = agnc[0].agncyno__c;
        calling2.requestNo1__c = req[1].requestnumber__c;
        calling2.SeihoRecruiterNo__c = rec[0].recruiter_number__c;
        callingImport__c  calling3 = new callingImport__c();
        calling3.ReceptionDatetime__c = datetime.newInstance(2019,5, 28, 1, 6, 8);
        calling3.CallListType__c = '口座不備';
        calling3.Description__c = 'callingtest1';
        calling3.SeihoAgencyNo__c = agnc[1].agncyno__c;
        calling3.SeihoRecruiterNo__c = rec[1].recruiter_number__c;
        calling3.requestNo1__c = req[2].requestnumber__c;
        callingImports.add(calling1);
        callingImports.add(calling2);
        callingImports.add(calling3);
        insert callingImports;
    }

     @isTest
     private static Account createAccountTestData(){

		Account acc = new Account(
			FirstName = 'user_' ,
			LastName = 'Test',
			furiganaForst__pc = 'ユーザー_',
			furiganaLast__pc = 'テスト',
			Gender__pc = '男性',
			CSID__pc ='590',
			SeihoAgentMstId__c = null,
            SeihoAccoutType__c = '生保エージェント',
            SeihoAgentID__c = null
		); 
		insert acc;
 
		return acc;
	}
    
    @isTest
    static List<Request__c> createRequestTestData(){

        List<String> requestSubject = new List<String>{'契約確認コール','継続フォロー','口座不備'};
        List<String> requestType = new List<String>{'契約確認コール','フォロー対応','フォロー対応'};
        List<Request__c> requestList = new List<Request__c>();
        for(Integer i=0;i<3;i++){
            Request__c request = new Request__c();
            request.Registration__c = true;
            request.Class__c = '生命代サ専用ケース'; 
            request.Type__c = requestType[i];
            request.Subject__c = requestSubject[i];
            request.Status__c = 'CC完了';
            request.RequestStatusComment__c = 'Testing';
            request.Priority__c = '中';
            request.Name = 'TestK'+i;
            request.JuniorSpecialContract__c ='有';
            request.AGRegistrationChange__c ='有';
            request.ChangeAgencyRegistration__c ='有'; 
            request.RecruiterRegistration__c ='有';
            
            requestList.add(request);
        }
        insert requestList;

        return  RequestList;
    }

    @isTest
    private static List<SeihoAgencyMaster__c> createAgencyMasterTestData(){
        
        List<SeihoAgencyMaster__c> SeihoAgencyMasterList = new List<SeihoAgencyMaster__c>();
        for(Integer i=1;i<3;i++){

            SeihoAgencyMaster__c agency = new SeihoAgencyMaster__c(
            agncyno__c = 'test'+i,
            agncynmkn__c = 'SeihoAgency_001', //カナ 
            agncynmkj__c = 'SeihoAgency_001', //漢字
            tantoupbragncyno__c='AG00008',
            csid__c = 'test'+i,
            Account__c = null,
            cmmsspymnbankcd__c = 'test'+i,
            cmmsspymnbrnchcd__c = 'test'+i,
            HurikomiBank__c = null,
            HurikomiBranch__c = null
            );
            SeihoAgencyMasterList.add(agency);
        }
        insert SeihoAgencyMasterList;

        return SeihoAgencyMasterList;
    }
   
    private static List<SeihoRecruiterMaster__c> createRecruiterMasterTestData(){

        List<SeihoRecruiterMaster__c> SeihoRecruiterMasterList = new List<SeihoRecruiterMaster__c>();
        for(Integer i=1;i<3;i++){
            SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
                Name = 'RECRUITER_001',
                CS_ID__c = 'test'+i,
                RECRUITER_NUMBER__c = 'RN00001',
                AGENCY_NUMBER__c = 'AG00001',
                SeihoAgencyMasterName__c = null,
                Account__c = null
            );
            SeihoRecruiterMasterList.add(recruiter);
        }
        insert SeihoRecruiterMasterList;

        return SeihoRecruiterMasterList;
    }
}