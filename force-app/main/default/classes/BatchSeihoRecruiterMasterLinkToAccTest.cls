/****************************************************************************************/
/* Class Name       : BatchSeihoRecruiterMasterLinkToAccTest                               */
/* Description      : 代理店-取引先紐づけBatchTest                                         */
/* @Created Date    :                                                              */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                           */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@isTest
private class BatchSeihoRecruiterMasterLinkToAccTest {
    
    @isTest 
    static void updateAccountLinkPatttern1(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertEquals(lifeConList[0].accountid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        
    }
    @isTest 
    static void updateAccountLinkPatttern2(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.CSID__pc='';
        }
        update accList; 
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern3(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(0);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern4(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertEquals(Null, [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern5(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.CSID__pc='';
        }
        update accList;
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertNotEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern6(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,0);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        string csid= [select id,csid__pc from Account where id =:accIds[5]][0].csid__pc;
        system.debug(csid);
        system.debug(shList[0].CS_ID__c);
        system.debug(seihoOppList[0].Ref_Account__c);
        system.debug(accIds[0]);
        system.assertEquals(seihoOppList[0].ContracterCustoNo__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        //system.assertEquals(shList[0].Id, [select id,csid__pc from Account where id=:accIds[0]][0].seihoRecruiterMstId__c);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern7(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        //List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,0);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        string csid= [select id,csid__pc from Account where id =:accIds[5]][0].csid__pc;
        system.debug(csid);
        system.debug(shList[0].CS_ID__c);
        system.debug(seihoOppList[0].Ref_Account__c);
        system.debug(accIds[0]);
        system.assertEquals(seihoOppList[0].ContracterCustoNo__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPattter8(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,4);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        string csid= [select id,csid__pc from Account where id =:accIds[5]][0].csid__pc;
        system.debug(csid);
        system.debug(shList[0].CS_ID__c);
        system.debug(seihoOppList[0].Ref_Account__c);
        system.debug(accIds[0]);
        system.assertEquals(Null, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(shList[0].CS_ID__c,  [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertNotEquals(seihoOppList[0].ContracterCustoNo__c,  [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(lifeConList[0].csid__c,  [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern9(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        shList[0].CS_ID__c='NX0001';
        update  shList;
        test.startTest();
        
        BatchSeihoRecruiterMasterLinkToAccount batch = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batch);
        test.stopTest();
        system.assertNOtEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNOtEquals(lifeConList[0].csid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        //system.assertEquals('生保契約者;生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        //system.assertEquals(shList[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        //system.assertEquals(shList[0].AGENT_ID__c  , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        system.assertNOtEquals(lifeConList[0].accountid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        //SeihoAccoutType__c
        //SeihoRecruiterMstId__c
        //SeihoRecruiterNo__c
    }
    
    
    
    
    @isTest 
    static void updateAccountLinkPatttern11(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        //system.assertEquals('生保契約者;生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(shList[4].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        system.assertEquals(shList[4].RECRUITER_NUMBER__c  , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        system.assertEquals(lifeConList[0].accountid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        //SeihoAccoutType__c
        //SeihoRecruiterMstId__c
        //SeihoRecruiterNo__c
    }
    @isTest 
    static void updateAccountLinkPatttern12(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        shList[0].CS_ID__c='NX00001';
        update  shList;
        test.startTest();
        
        BatchSeihoRecruiterMasterLinkToAccount batch = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batch);
        test.stopTest();
        system.assertEquals(accIds[1], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[1].csid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        //system.assertEquals('生保契約者;生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[1]][0].SeihoAccoutType__c);
        //system.assertEquals(shList[0].Id, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[1]][0].SeihoRecruiterMstId__c);
        //system.assertEquals(shList[0].AGENT_ID__c  , [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[1]][0].SeihoRecruiterNo__c);
        //system.assertEquals(Null, [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        //system.assertEquals(Null, [select id,csid__pc,SeihoRecruiterMstId__c from Account where id=:accIds[0]][0].SeihoRecruiterMstId__c);
        //system.assertEquals(Null, [select id,csid__pc,SeihoRecruiterNo__c from Account where id=:accIds[0]][0].SeihoRecruiterNo__c);
        system.assertNOtEquals(lifeConList[0].accountid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        //SeihoAccoutType__c
        //SeihoRecruiterMstId__c
        //SeihoRecruiterNo__c
    }
    
    @isTest 
    static void updateAccountLinkPatttern13(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(0);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        accList[1].csId__pc='NX00000';
        update accList; 
        List<LifeContract__c> lifeConList= LifeContractData( accIds,5);
        test.startTest();
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchREC);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(accIds[1], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        //system.assertEquals(lifeConList[1].CS_ID__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[1].Id][0].CS_ID__c);
        system.assertEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        //system.assertEquals(lifeConList[0].accountid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[1].Id][0].account__c);
        
    }
    @isTest 
    static void updateAccountLinkPatttern14(){
        List<SeihoRecruiterMaster__c> shList  =SeihoRecruiterMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        for(SeihoRecruiterMaster__c sh:shList){
            sh.RECRUITER_STATUS_DID__c=Null;
            sh.AGENCY_NUMBER__c=Null;
            sh.CS_ID__c=Null;
            sh.REGISTRATION_DATE__c=Null;
            sh.Account__c=Null;
        }
        test.startTest();
        try{
        update shList; 
        BatchSeihoRecruiterMasterLinkToAccount batchAT = new  BatchSeihoRecruiterMasterLinkToAccount();
        database.executeBatch(batchAT);
              }
        catch(DMLException e){
            system.debug('Error '+e.getMessage());
        }
        test.stopTest();
        system.assertNotEquals(accIds[0], [select id,account__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(lifeConList[0].csid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].CS_ID__c);
        system.assertNotEquals(shList[0].CS_ID__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertNotEquals(lifeConList[0].accountid__c, [select id,account__c,CS_ID__c from SeihoRecruiterMaster__c where id=:shList[0].Id][0].account__c);
        
    }
    
    @isTest 
    static void schedulerTest(){
        test.startTest();
        string str='0 0 0 * * ?';
        BatchSeihoRecruiterMasterLinkToAccount batchREC = new  BatchSeihoRecruiterMasterLinkToAccount();
        system.schedule('batchREC',str,batchREC);
        test.stopTest();
        
        
        
    }
    private static List<SeihoRecruiterMaster__c> SeihoRecruiterMasterData(integer seihoCount){
        
        List<SeihoRecruiterMaster__c> shList = new List<SeihoRecruiterMaster__c>();
        // List<String> accIds = new List<String>();
        for (integer i=seihoCount;i<10;i++) {
            SeihoRecruiterMaster__c sh = new SeihoRecruiterMaster__c(RECRUITER_STATUS_DID__c='3',
                                                               RECRUITER_NUMBER__c ='00'+i,
                                                               CS_ID__c ='NX0000'+i ,                                                
                                                               REGISTRATION_DATE__c='2020-09-14',
                                                               Account__c = null);
            shList.add(sh);
        }
        insert shList;
        
        
        return shList;
    }
    private static List<String> AccountData(integer accCount){
        List<Account> accList = new List<Account>();
        List<String> accIds = new List<String>();
         List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        for (integer i=accCount;i<10;i++) {
           
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
}