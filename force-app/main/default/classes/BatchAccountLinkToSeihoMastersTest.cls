/****************************************************************************************/
/* Class Name       : BatchAccountLinkToSeihoMastersTest                                */
/* Description      : 取引先-代理店、エージェント、募集人紐づけBatchTest                    */
/* @Created Date    :                                                                   */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                              */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@isTest
private class BatchAccountLinkToSeihoMastersTest {
    @isTest 
    static void updateMasterPattern1(){
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        //system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:sh[0].Id][0].account__c);
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[4].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[4].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[4].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[4].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[4].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[4].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern2(){
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.CSID__pc='';
        }
        update accList; 
        List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern3(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        system.assertEquals('生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern4(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        system.assertEquals(Null, [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    
    @isTest 
    static void updateMasterPattern5(){
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.CSID__pc='';
        }
        update accList;
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        system.assertEquals(Null, [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern6(){
        List<String> accIds  =AccountData(0);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,4);
        List<LifeContract__c> lifeConList=LifeContractData( accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        for (SeihoAgencyMaster__c sh1 : [Select id,Account__c,csid__c from SeihoAgencyMaster__c]) 
            System.debug(sh1);
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern7(){
        List<String> accIds  =AccountData(0);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,4);
        //List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        system.assertEquals('生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern8(){
        List<String> accIds  =AccountData(0);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,0);
        List<LifeContract__c> lifeConList=LifeContractData( accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        system.assertEquals('生保契約者', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern9(){
        List<String> accIds  =AccountData(0);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,5);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',5,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',5,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',5,'3','2020-09-15', '1000');
        sg[1].cs_Id__c='NX00005';
        sh[1].csId__c='NX00005';
        sr[1].cs_Id__c='NX00005';
        sg[2].cs_Id__c='NX00005';
        sh[2].csId__c='NX00005';
        sr[2].cs_Id__c='NX00005';
        sg[1].AGENT_STATUS_DID__c='4';
        sr[1].RECRUITER_STATUS_DID__c='1';
        sh[1].agncysts__c='1';
        sg[2].AGENT_STATUS_DID__c='4';
        sr[2].RECRUITER_STATUS_DID__c='4';
        sh[2].agncysts__c='4';
        update sg;
        update sh;
        update sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batch = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batch);
        test.stopTest();
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern10(){
        List<String> accIds  =AccountData(0);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,5);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',5,'4','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',5,'1','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',5,'1','2020-09-15', '1000');
        sg[1].cs_Id__c='NX00005';
        sh[1].csId__c='NX00005';
        sr[1].cs_Id__c='NX00005';
        sg[1].AGENT_STATUS_DID__c='4';
        sr[1].RECRUITER_STATUS_DID__c='4';
        sh[1].agncysts__c='4';
        
        update sg;
        update sh;
        update sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batch = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batch);
        test.stopTest();
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[1].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[1].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern11(){
        List<String> accIds  =AccountData(0);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,5);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',5,'4','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',5,'4','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',5,'4','2020-09-15', '1000');
        sg[1].cs_Id__c='NX00005';
        sh[1].csId__c='NX00005';
        sr[1].cs_Id__c='NX00005';
        sg[2].cs_Id__c='NX00005';
        sh[2].csId__c='NX00005';
        sr[2].cs_Id__c='NX00005';
        sg[1].AGENT_STATUS_DID__c='';
        sr[1].RECRUITER_STATUS_DID__c='';
        sh[1].agncysts__c='';
        sg[2].AGENT_STATUS_DID__c='';
        sr[2].RECRUITER_STATUS_DID__c='';
        sh[2].agncysts__c='';
        update sg;
        update sh;
        update sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batch = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batch);
        test.stopTest();
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern12(){
        List<String> accIds  =AccountData(0);
        //List<LifeContract__c> lifeConList= LifeContractData(accIds,6);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',3,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',3,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        //system.assertEquals(accIds[0], [select id,account__c from SeihoAgentMaster__c where id=:sg[0].Id][0].account__c);
        system.assertEquals('生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern13(){
        List<String> accIds  =AccountData(0);
        //List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        //system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:sh[0].Id][0].account__c);
        system.assertEquals('生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern14(){
        List<String> accIds  =AccountData(0);
        //List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        //system.assertEquals(accIds[0], [select id,account__c from SeihoAgentMaster__c where id=:sr[0].Id][0].account__c);
        system.assertEquals('生保募集人', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    
    @isTest 
    static void updateMasterPattern15(){
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        //system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:sh[0].Id][0].account__c);
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[4].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[4].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[4].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[4].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[4].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[4].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    
    @isTest 
    static void updateMasterPattern16(){
        List<String> accIds  =AccountData(0);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,5);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',5,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',5,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',5,'3','2020-09-15', '1000');
        //Account acc  =[select id,csid__pc from Account where id =:accIds[0]];
        BatchAccountLinkToSeihoMasters batchc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchc);
        lifeConList[0].csid__c='NX00006';
        update lifeConList;
        test.startTest();
        BatchAccountLinkToSeihoMasters batch = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batch);
        test.stopTest();
        for (SeihoAgencyMaster__c sh1 : [Select id,Account__c,csid__c from SeihoAgencyMaster__c]) 
            System.debug(sh1);
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[1]][0].SeihoAccoutType__c);
        system.assertEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[1].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(Null , [select id,Account__c from seihoAgencyMaster__c where id=:sh[0].id][0].Account__c);
         system.assertEquals(accIds[0] , [select id,Account__c from seihoAgencyMaster__c where id=:sh[1].id][0].Account__c);
        //system.assertEquals(sh[1].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[1].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[1].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[1].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[1].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[1].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    
    @isTest 
    static void updateMasterPattern17(){
        List<String> accIds  =AccountData(4);
        //List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,4);
        //List<LifeContract__c> lifeConList=LifeContractData( accIds,5);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',4,'3','2020-09-15', '1000');
        Account acc  =[select id,csid__pc from Account where id =:accIds[0]];
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        acc.csid__pc='NX00001';
        update acc;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAc);
        test.stopTest();
        system.assertEquals(Null, [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern18(){
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.lastname='';
        }
        
        test.startTest();
        try{
            update accList; 
            BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
            database.executeBatch(batchAcc);
        }
        catch(DMLException e){
            system.debug('Error '+e.getMessage());
        }
        test.stopTest();
        //system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:sh[0].Id][0].account__c);
        system.assertNotEquals('生保契約者;生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertNotEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertNotEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNotEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertNotEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertNotEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertNotEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        // system.AssertEquals();
    }
    @isTest 
    static void updateMasterPattern19(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'1','2020-09-15', '1000');
         for (SeihoAgencyMaster__c she:sh) {
            she.csid__c='NX00000';
        }
        sh[0].agncyrgstymd__c=date.newInstance(2020,10,15);
      
        update sh;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保代理店',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
   
    }
    
    @isTest 
    static void updateMasterPattern20(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'1','2020-09-15', '1000');
       
        for (SeihoAgencyMaster__c she:sh) {
            she.csid__c='NX00000';
        }
      update  sh;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
       
        system.assertEquals('生保代理店',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[9].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[9].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        
    }
    @isTest 
    static void updateMasterPattern21(){
        List<String> accIds  =AccountData(0);
      
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'1','2020-09-15', '1000');
        for (SeihoAgencyMaster__c she:sh) {
            she.agncysts__c='4';
            she.csid__c='NX00000';
        }
        sh[0].agncysts__c='1';
      update  sh;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保代理店',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
    
    }
     @isTest 
    static void updateMasterPattern22(){
        List<String> accIds  =AccountData(0);
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',3,'1','2020-09-15', '1000');
        for (SeihoRecruiterMaster__c she:sr) {
            she.cs_id__c='NX00000';
        }
        sr[0].REGISTRATION_DATE__c='2020-10-15';
      update  sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
       
        system.assertEquals('生保募集人',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,seihoRecruiterMstId__c from Account where id=:accIds[0]][0].seihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,seihoRecruiterno__c from Account where id=:accIds[0]][0].seihoRecruiterno__c);
      
    }
     @isTest 
    static void updateMasterPattern23(){
        List<String> accIds  =AccountData(0);
      
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'4','2020-09-15', '1000');
        for (SeihoAgentMaster__c she:sg) {
            she.cs_id__c='NX00000';
        }
        sg[0].ANNIHILATION_DATE__c='2020-10-15';
      update  sg;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保エージェント',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].Agent_id__c , [select id,csid__pc,seihoAgentId__c from Account where id=:accIds[0]][0].seihoAgentId__c);

    }
    
     @isTest 
    static void updateMasterPattern24(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'4','2020-09-15', '1000');
   
         for (SeihoAgencyMaster__c she:sh) {
            she.csid__c='NX00000';
        }
        sh[0].clsymd__c=date.newInstance(2020,10,15);
      
        update sh;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
   
        system.assertEquals('生保代理店',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
      
    }
     @isTest 
    static void updateMasterPattern25(){
         List<String> accIds  =AccountData(0);
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',3,'4','2020-09-15', '1000');
        for (SeihoRecruiterMaster__c she:sr) {
            she.cs_id__c='NX00000';
        }
        sr[0].OUT_OF_BUSINESS_DATE__c='2020-10-15';
      update  sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保募集人',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,seihoRecruiterMstId__c from Account where id=:accIds[0]][0].seihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,seihoRecruiterno__c from Account where id=:accIds[0]][0].seihoRecruiterno__c);
        
    }
     @isTest 
    static void updateMasterPattern26(){
       List<String> accIds  =AccountData(0);

        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',3,'4','2020-09-15', '1000');
        for (SeihoRecruiterMaster__c she:sr) {
            she.RECRUITER_STATUS_DID__c='4';
            she.cs_id__c='NX00000';
        }
        sr[0].RECRUITER_STATUS_DID__c='1';
      update  sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保募集人',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,seihoRecruiterMstId__c from Account where id=:accIds[0]][0].seihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,seihoRecruiterno__c from Account where id=:accIds[0]][0].seihoRecruiterno__c);
    
    }
     @isTest 
    static void updateMasterPattern27(){
        List<String> accIds  =AccountData(0);
      
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        
        for (SeihoAgentMaster__c she:sg) {
            she.cs_id__c='NX00000';
        }
       
      update  sg;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保エージェント',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sg[9].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[9].Agent_id__c , [select id,csid__pc,seihoAgentId__c from Account where id=:accIds[0]][0].seihoAgentId__c);
        
    }
     @isTest 
    static void updateMasterPattern28(){
       List<String> accIds  =AccountData(0); 

        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'1','2020-09-15', '1000');
        for (SeihoRecruiterMaster__c she:sr) {
            
            she.cs_id__c='NX00000';
        }
        
      update  sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        system.assertEquals('生保募集人',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sr[9].Id, [select id,csid__pc,seihoRecruiterMstId__c from Account where id=:accIds[0]][0].seihoRecruiterMstId__c);
        system.assertEquals(sr[9].RECRUITER_NUMBER__c , [select id,csid__pc,seihoRecruiterno__c from Account where id=:accIds[0]][0].seihoRecruiterno__c);
     
    }
    @isTest 
    static void updateMasterPattern29(){
         List<String> accIds  =AccountData(0);
        
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
      
        for (SeihoAgentMaster__c she:sg) {
            she.cs_id__c='NX00000';
            she.AGENT_STATUS_DID__c='4';
        }
       sg[0].AGENT_STATUS_DID__c='3';
      update  sg;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        system.assertEquals('生保エージェント',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].Agent_id__c , [select id,csid__pc,seihoAgentId__c from Account where id=:accIds[0]][0].seihoAgentId__c);
        
    }
    @isTest 
    static void updateMasterPattern30(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');

        for (SeihoAgentMaster__c she:sg) {
            she.CS_ID__c='NX00000';
        }
        sg[0].REGISTRATION_DATE__c='2020-10-15';

        for (SeihoAgencyMaster__c she:sh) {
            she.csid__c='NX00000';
        }
        sh[0].agncyrgstymd__c=date.newInstance(2020,10,15);

        for (SeihoRecruiterMaster__c she:sr) {
            she.CS_ID__c='NX00000';
        }
        sr[0].REGISTRATION_DATE__c='2020-10-15';
      
        update sg;
        update sh;
        update sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[0].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[0].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[0].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[0].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[0].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);      
    }
    @isTest 
    static void updateMasterPattern31(){
        List<String> accIds  =AccountData(0);
        List<SeihoAgentMaster__c> sg=createAgntMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoAgencyMaster__c> sh=createAgncyMstTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'3','2020-09-15', '1000');

        for (SeihoAgentMaster__c she:sg) {
            she.CS_ID__c='NX00000';
        }
        for (SeihoAgencyMaster__c she:sh) {
            she.csid__c='NX00000';
        }
        for (SeihoRecruiterMaster__c she:sr) {
            she.CS_ID__c='NX00000';
        }
      
        update sg;
        update sh;
        update sr;
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
        for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        
        system.assertEquals('生保代理店;生保募集人;生保エージェント', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sh[9].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(sh[9].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(sg[9].Id, [select id,csid__pc,seihoAgentMstId__c from Account where id=:accIds[0]][0].seihoAgentMstId__c);
        system.assertEquals(sg[9].AGENT_ID__c , [select id,csid__pc,SeihoAgentID__c from Account where id=:accIds[0]][0].SeihoAgentID__c);
        system.assertEquals(sr[9].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(sr[9].RECRUITER_NUMBER__c , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);      
    }

    @isTest 
    static void updateMasterPattern32(){
       List<String> accIds  =AccountData(3); 
       List<LifeContract__c> lifeConList= LifeContractData(accIds,0);
        List<SeihoRecruiterMaster__c> sr=createRecMstrTestDataStsBased('NX0000',0,'1','2020-09-15', '1000');
       
        test.startTest();
        BatchAccountLinkToSeihoMasters batchAcc = new  BatchAccountLinkToSeihoMasters();
        database.executeBatch(batchAcc);
        test.stopTest();
         for (Account acc : [select id, csid__pc,SeihoAccoutType__c from Account]) 
            System.debug(acc);
        system.assertEquals('生保契約者;生保募集人',[select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(sr[3].Id, [select id,csid__pc,seihoRecruiterMstId__c from Account where id=:accIds[0]][0].seihoRecruiterMstId__c);
        system.assertEquals(sr[3].RECRUITER_NUMBER__c , [select id,csid__pc,seihoRecruiterno__c from Account where id=:accIds[0]][0].seihoRecruiterno__c);
        
    }

    @isTest 
    static void schedulerTest(){
        test.startTest();
        string str='0 0 0 * * ?';
        BatchAccountLinkToSeihoMasters batchsh = new  BatchAccountLinkToSeihoMasters();
        system.schedule('batchsh',str,batchsh);
        test.stopTest();
        
        
        
    }
    private static List<String> AccountData(integer accCount){
        List<Account> accList = new List<Account>();
        List<String> accIds = new List<String>();
          List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        for (integer i=accCount;i<5;i++) {
           
        Account acc= new Account(
            LastName='個人'+i,
            FirstName='取引先'+i,
            LastName__pc='個人'+i, 
            csid__pc='NX0000'+i,
            firstname__pc='取引先'+i,
            furiganaLast__pc='こじん'+i,
            furiganaForst__pc='とりひきさき'+i,
            PersonMailingState ='東京都',
            PersonBirthdate=date.parse('1982/01/01'),
            Gender__pc = '男性',
            RecordTypeId=recordTypes[0].Id
        );
            accList.add(acc);
        }
        insert accList;
        for (Account acc:accList) {
            accIds.add(acc.Id);
        }
        system.debug(accids[0]);
        return accIds;
    }
    private static List<LifeContract__c>  LifeContractData(List<String> accIds,integer accCount){
        List<LifeContract__c> lifeConList = new List<LifeContract__c>();
        integer count=accCount;
        for (String Id:accIds) {
            LifeContract__c lifeCon = new LifeContract__c(csid__c='NX0000'+count++,AccountId__c=Id);
            lifeConList.add(lifeCon);
        }
        insert lifeConList;
        return lifeConList;
    }
    private static List<seihoOpportunity__c> seihoOppdata(List<String> accIds,Integer accCount){
        List<seihoOpportunity__c> seihoOppList = new List<seihoOpportunity__c>();
        integer count=accCount;
        for (String Id:accIds) {
            seihoOpportunity__c seihoOpp = new seihoOpportunity__c(Name='NX0000'+count,ContracterCustoNo__c='NX0000'+count++,Ref_Account__c=Id);
            seihoOppList.add(seihoOpp);
        }
        insert seihoOppList;
        return seihoOppList;
    }
    private static List<SeihoAgencyMaster__c> createAgncyMstTestDataStsBased(String csId,integer accCount, String statusCode, String regDate,String RecID){
        List<SeihoAgencyMaster__c> shList = new List<SeihoAgencyMaster__c>();
        for (integer i=accCount;i<10;i++) {
            
            SeihoAgencyMaster__c Agency = new SeihoAgencyMaster__c(
               // Name = 'AGENCY_001'+i,
                csid__c = csId+i,
                tantoupbragncyno__c = null,
                agncyno__c = RecID+i,
                agncyrgstymd__c=(statusCode=='3'||statusCode=='1' )?Date.ValueOf(regDate):null,
                clsymd__c=(statusCode=='4')?Date.ValueOf(regDate):null,
                agncysts__c= statusCode
            );
            shList.add(Agency);
        }
        insert shList;        
        return shList;
    }
    private static List<SeihoRecruiterMaster__c> createRecMstrTestDataStsBased(String csId, integer acccount,String statusCode, String regDate,String RecID){
        List<SeihoRecruiterMaster__c> srList = new List<SeihoRecruiterMaster__c>();
        for (integer i=accCount;i<10;i++) {
            SeihoRecruiterMaster__c recruiter = new SeihoRecruiterMaster__c(
                Name = 'RECRUITER_001',
                CS_ID__c = csId+i,
                RECRUITER_NUMBER__c = RecID+i,
                AGENCY_NUMBER__c = 'AG00001',
                REGISTRATION_DATE__c=(statusCode=='3'||statusCode=='1' )?regDate:null,
                OUT_OF_BUSINESS_DATE__c=(statusCode=='4')?regDate:null,
                SeihoAgencyMasterName__c = null,
                RECRUITER_STATUS_DID__c=statusCode,
                Account__c = null
            );
            srList.add(recruiter);   
        }
        insert srList;
        return srList;
    }
    private static List<SeihoAgentMaster__c> createAgntMstrTestDataStsBased(String csId,integer acccount, String statusCode, String regDate,String AgntID){
        List<SeihoAgentMaster__c> sgList = new List<SeihoAgentMaster__c>();
        for (integer i=accCount;i<10;i++) {
            SeihoAgentMaster__c agent = new SeihoAgentMaster__c(
                Name = 'Test User_'+i,
                CS_ID__c = csId+i,
                BELONG_AGENT__c = 'AG00001',
                SeihoAgentParentFlag__c = false,
                MEMBER_ID_SEQ__c = 'AG00007',
                Account__c = null,
                OLD_AGENT_ID__c ='AG00001',
                AGENT_STATUS_DID__c=statusCode, 
                REGISTRATION_DATE__c=(statusCode=='3')?regDate:null,
                ANNIHILATION_DATE__c=(statusCode=='4')?regDate:null,
                AGENT_ID__c=AgntID+i
            );
            sgList.add(agent);
        }
        insert sgList;
        
        return sgList;
    }
}