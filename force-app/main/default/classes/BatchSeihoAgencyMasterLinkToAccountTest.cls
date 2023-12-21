/****************************************************************************************/
/* Class Name       : BatchSeihoAgencyMasterLinkToAccountTest                           */
/* Description      : 代理店-取引先紐づけBatchTest                                        */
/* @Created Date    :                                                                   */
/* @Created By      : SRM - ONYX（マスタ-取引先関連付け対応）                              */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
@isTest
private class BatchSeihoAgencyMasterLinkToAccountTest {
    
    @isTest 
    static void updateAccountLinkPatttern1(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertEquals(lifeConList[0].accountid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        
    }
    @isTest 
    static void updateAccountLinkPatttern2(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.CSID__pc='';
        }
        update accList; 
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern3(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(0);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern4(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        system.assertNotEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern5(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        for (Account acc:accList) {
            acc.CSID__pc='';
        }
        update accList;
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        system.assertNotEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern6(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,0);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        
        for (SeihoAgencyMaster__c sh : [Select id,Account__c,csid__c from SeihoAgencyMaster__c]) 
            System.debug(sh);
        
        for (Account acc : [select id, csid__pc from Account]) 
            System.debug(acc);
        
        for (LifeContract__c lf :  [Select id,AccountId__c,csid__c from LifeContract__c]) 
            System.debug(lf);
        
        for (seihoOpportunity__c so : [Select id,Ref_Account__c,ContracterCustoNo__c from seihoOpportunity__c]) 
            System.debug(so);
        
        system.assertEquals(seihoOppList[0].ContracterCustoNo__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertEquals(accIds[0],[select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        
    }
    @isTest 
    static void updateAccountLinkPatttern7(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        //List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,0);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        string csid= [select id,csid__pc from Account where id =:accIds[5]][0].csid__pc;
        system.debug(csid);
        system.debug(shList[0].csid__c);
        system.debug(seihoOppList[0].Ref_Account__c);
        system.debug(accIds[0]);
        system.assertEquals(seihoOppList[0].ContracterCustoNo__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertEquals(accIds[0],[select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        
    }
    @isTest 
    static void updateAccountLinkPattter8(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList=LifeContractData( accIds,4);
        List<seihoOpportunity__c> seihoOppList=seihoOppdata(accIds,4);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        string csid= [select id,csid__pc from Account where id =:accIds[5]][0].csid__pc;
        system.debug(csid);
        system.debug(shList[0].csid__c);
        system.debug(seihoOppList[0].Ref_Account__c);
        system.debug(accIds[0]);
        system.assertEquals(Null, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(shList[0].csid__c,  [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertNotEquals(seihoOppList[0].ContracterCustoNo__c,  [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(lifeConList[0].csid__c,  [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        
        
    }
    @isTest 
    static void updateAccountLinkPatttern9(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        //BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        //database.executeBatch(batchsh);
        shList[0].Account__c=accIds[0];
        update  shList;
        test.startTest();
        shList[0].csid__c='NX0001';
        update  shList;
        BatchSeihoAgencyMasterLinkToAccount batch = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batch);
        test.stopTest();
        system.assertNOtEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNOtEquals(lifeConList[0].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertNOtEquals(lifeConList[0].accountid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        //SeihoAccoutType__c
        //seihoAgencyMstId__c
        //seihoAgencyNo__c
    }
    
    
    
    
    @isTest 
    static void updateAccountLinkPatttern11(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        for (Account acc : [select id, csid__pc from Account]) 
            System.debug(acc);
       for (SeihoAgencyMaster__c sh : [Select id,Account__c,csid__c from SeihoAgencyMaster__c]) 
            System.debug(sh);
        system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertEquals('生保契約者;生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(shList[4].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(shList[4].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertEquals(lifeConList[0].accountid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        //SeihoAccoutType__c
        //seihoAgencyMstId__c
        //seihoAgencyNo__c
    }
    @isTest 
    static void updateAccountLinkPatttern12(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
       SeihoAgencyMaster__c seiho=shList[0];
       seiho.csid__c='NX00001';
        update  seiho;
       
        test.startTest();
        
        BatchSeihoAgencyMasterLinkToAccount batch = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batch);
        test.stopTest();
         for (Account acc : [select id, csid__pc from Account]) 
            System.debug(acc);
       for (SeihoAgencyMaster__c sh : [Select id,Account__c,csid__c from SeihoAgencyMaster__c]) 
            System.debug(sh);
        system.assertEquals(accIds[1], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[1].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertEquals('生保契約者;生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[1]][0].SeihoAccoutType__c);
        system.assertEquals(shList[5].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[1]][0].seihoAgencyMstId__c);
        system.assertEquals(shList[5].agncyno__c , [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[1]][0].seihoAgencyNo__c);
        system.assertEquals('生保契約者;生保代理店', [select id,csid__pc,SeihoAccoutType__c from Account where id=:accIds[0]][0].SeihoAccoutType__c);
        system.assertEquals(shList[4].Id, [select id,csid__pc,seihoAgencyMstId__c from Account where id=:accIds[0]][0].seihoAgencyMstId__c);
        system.assertEquals(shList[4].agncyno__c, [select id,csid__pc,seihoAgencyNo__c from Account where id=:accIds[0]][0].seihoAgencyNo__c);
        system.assertNOtEquals(lifeConList[0].accountid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        //SeihoAccoutType__c
        //seihoAgencyMstId__c
        //seihoAgencyNo__c
    }
    
    @isTest 
    static void updateAccountLinkPatttern13(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(0);
        List<Account> accList  =[select id,csid__pc from Account where id in:accIds];
        accList[1].csId__pc='NX00000';
        update accList; 
        List<LifeContract__c> lifeConList= LifeContractData( accIds,5);
        test.startTest();
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        database.executeBatch(batchsh);
        test.stopTest();
        system.assertEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertNotEquals(accIds[1], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        //system.assertEquals(lifeConList[1].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[1].Id][0].csid__c);
        system.assertEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertNotEquals(lifeConList[1].accountid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[1].Id][0].account__c);
        
    }
    @isTest 
    static void updateAccountLinkPatttern14(){
        List<SeihoAgencyMaster__c> shList  =SeihoAgencyMasterData(0);
        List<String> accIds  =AccountData(4);
        List<LifeContract__c> lifeConList= LifeContractData( accIds,0);
        
        for(SeihoAgencyMaster__c sh:shList){
            sh.agncyno__c='Agncy01';
        }
        test.startTest();
        try{
            update shList; 
            
            BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
            database.executeBatch(batchsh);
        }
        catch(DMLException e){
            system.debug('Error '+e.getMessage());
        }
        test.stopTest();
        
        system.assertNotEquals(accIds[0], [select id,account__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        system.assertEquals(lifeConList[0].csid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].csid__c);
        system.assertNotEquals(shList[0].csid__c, [select id,csid__pc from Account where id=:accIds[0]][0].csid__pc);
        system.assertNotEquals(lifeConList[0].accountid__c, [select id,account__c,csid__c from SeihoAgencyMaster__c where id=:shList[0].Id][0].account__c);
        
    }
    
    @isTest 
    static void schedulerTest(){
        test.startTest();
        string str='0 0 0 * * ?';
        BatchSeihoAgencyMasterLinkToAccount batchsh = new  BatchSeihoAgencyMasterLinkToAccount();
        system.schedule('batchsh',str,batchsh);
        test.stopTest();
        
        
        
    }
    private static List<SeihoAgencyMaster__c> SeihoAgencyMasterData(integer seihoCount){
        
        List<SeihoAgencyMaster__c> shList = new List<SeihoAgencyMaster__c>();
        // List<String> accIds = new List<String>();
        for (integer i=seihoCount;i<10;i++) {
            SeihoAgencyMaster__c sh = new SeihoAgencyMaster__c(agncysts__c='3',
                                                               agncyno__c='00'+i,
                                                               csid__c ='NX0000'+i ,                                                
                                                               agncyrgstymd__c=date.newInstance(2020,09,28),
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