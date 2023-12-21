/*
* @Class Name      : MasterPageButtonApexControllerTest 
* @Description     : MasterPageButtonApexControllerTestのテストクラス
* @Created Date    : 2020.06.10
* @Created By      : SRM
* @Modified Date   : 
* @Modified        : 
*/

@isTest
public class MasterPageButtonApexControllerTest {
    static testmethod void executesoqlTest(){

        Test.startTest(); 
        
        SeihoRecruiterMaster__c sr =  new SeihoRecruiterMaster__c();
        sr.Name ='Recruiter';
        sr.AGENCY_NUMBER__c ='Test';
        sr.KANA_NAME__c ='kana';
        insert sr;

        MasterPageButtonApexController.MasterWrapper Recruiter = MasterPageButtonApexController.fetchMasterRecords((Id.ValueOf(sr.Id)));
        SeihoAgentMaster__c agnt = new SeihoAgentMaster__c();
        agnt.Name = 'Agent';
        agnt.KANA_AGENT_NAME__c = 'Kana';
        insert agnt;
        
        MasterPageButtonApexController.MasterWrapper Agent = MasterPageButtonApexController.fetchMasterRecords((Id.ValueOf(agnt.Id)));
        Test.stopTest();

        //Checking recruiter record
        System.assertEquals('Recruiter',Recruiter.Name);
        System.assertEquals('kana',Recruiter.kanaName );
        System.assertEquals('SeihoRecruiterMaster__c',Recruiter.objectName);

        //Checking Agent record
        System.assertEquals('Agent',Agent.Name);
        System.assertEquals('Kana',Agent.kanaName );
        System.assertEquals('SeihoAgentMaster__c',Agent.objectName);
     }
}