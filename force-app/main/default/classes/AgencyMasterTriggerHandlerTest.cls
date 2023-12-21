/*
* @Class Name      : AgencyMasterTriggerHandlerTest 
* @Description     : Test Class Trigger AgencyMasterTrigger
* @Created Date    : 2019.09.13
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class AgencyMasterTriggerHandlerTest {
    
  
    
    static testMethod void AfterUpdateProcessLifeContact()
    {
        test.startTest();
        /* LifeContract  */
        AgencyMaster__c agency1 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion(null,'DC001','LTC001');
        LifeContract__c lifeContract = AgencyMasterTriggerHandlerTestHelper.lifeContractInsertion('Life_001','LC001',null); 
        
        /* Update  */
        agency1.seihoAgencyCode__c='LC001';
        update agency1;
        System.Debug('Agency1::'+Agency1);
              
        test.stopTest();
           
        //Assert
        AgencyMasterTriggerHandlerTestHelper.assertValidationlifeContract(lifeContract.Id,agency1.Id);
    }    
    static testMethod void AfterUpdateProcessDamageContactSingle(){
        test.startTest();
        
        /* DamageContract  */
        AgencyMaster__c agency2 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC001',null,'LTC001');
        DamageContract__c damageContract1 = AgencyMasterTriggerHandlerTestHelper.damageContractInsertion('Damage_001','DC001');
        
        agency2.SonpoAgencyCode__c='DC001';
        update agency2;
        test.stopTest();
        
        //Assert
        //AgencyMasterTriggerHandlerTestHelper.assertValidationDamageContract(damageContract1.Id,agency2.Id,null,null);
        
    }
     static testMethod void AfterUpdateProcessDamageContactMultiple(){
        test.startTest();
        
        /* DamageContract  */
        AgencyMaster__c agency1 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC001',null,'LTC001');
        AgencyMaster__c agency2 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC002',null,'LTC002');
        AgencyMaster__c agency3 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC003',null,'LTC003');
        DamageContract__c damageContract1 = AgencyMasterTriggerHandlerTestHelper.damageContractInsertion('Damage_001','DC001,DC002,DC003');
        
        agency1.SonpoAgencyCode__c='DC001';
        update agency1;
        
        agency2.SonpoAgencyCode__c='DC002';
        update agency2;
        
        agency3.SonpoAgencyCode__c='DC003';
        update agency3;
        
        test.stopTest();
        
        //Assert
        //AgencyMasterTriggerHandlerTestHelper.assertValidationDamageContract(damageContract1.Id,agency1.Id,agency2.id,agency3.id);
        
    }
    static testMethod void AfterUpdateProcessLittleContract(){
        test.startTest();
        
        /* LittleContract  */
        AgencyMaster__c agency3 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC001','DC001',null);
        LittleContract__c littleContract = AgencyMasterTriggerHandlerTestHelper.LittleContractInsertion('Little_001','LTC001',null);
        
        agency3.ShotanAgencyCode__c='LTC001';
        update agency3;
        test.stopTest();
           
        //Assert
        AgencyMasterTriggerHandlerTestHelper.assertValidationlittleContract(littleContract.Id,agency3.Id);
        
    }
    static testMethod void AfterDeleteProcess()
    {
        test.startTest();
        
        // /* LifeContract Insertion */
        // LifeContract__c lifeContract = AgencyMasterTriggerHandlerTestHelper.lifeContractInsertion('Life_001','LC001',null);
        
        // /* DamageContract Insertion 1 */
        // DamageContract__c damageContract1 = AgencyMasterTriggerHandlerTestHelper.damageContractInsertion('Damage_001','DC001');
        
        // /* LittleContract Insertion */
        // LittleContract__c littleContract = AgencyMasterTriggerHandlerTestHelper.LittleContractInsertion('Little_001','LTC001',null);
        
        /** Single Master **/
        AgencyMaster__c lifeAgency = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC001','DC001','LTC001');
        
        Delete lifeAgency;
                  
        test.stopTest();
        
        // //Assert
        // AgencyMasterTriggerHandlerTestHelper.assertValidationlifeContract(lifeContract.Id,null);
        // AgencyMasterTriggerHandlerTestHelper.assertValidationDamageContract(damageContract1.Id,null,null,null);
        // AgencyMasterTriggerHandlerTestHelper.assertValidationlittleContract(littleContract.Id,null);
                
    } 
    static testMethod void AfterDeleteProcessMultiple()
    {
        test.startTest();
        
        // /* LifeContract Insertion */
        // LifeContract__c lifeContract1 = AgencyMasterTriggerHandlerTestHelper.lifeContractInsertion('Life_001','LC0001',null);
        // //LifeContract__c lifeContract2 = AgencyMasterTriggerHandlerTestHelper.lifeContractInsertion('Life_002','LC0002',null);
        // //LifeContract__c lifeContract3 = AgencyMasterTriggerHandlerTestHelper.lifeContractInsertion('Life_003','LC0003',null);
        
        // /* DamageContract Insertion 1 */
        // DamageContract__c damageContract1 = AgencyMasterTriggerHandlerTestHelper.damageContractInsertion('Damage_001','DC0001');
        
        // /* LittleContract Insertion */
        // LittleContract__c littleContract1 = AgencyMasterTriggerHandlerTestHelper.LittleContractInsertion('Little_001','LTC0001',null);
        // //LittleContract__c littleContract2 = AgencyMasterTriggerHandlerTestHelper.LittleContractInsertion('Little_002','LTC0002',null);
        // //LittleContract__c littleContract3 = AgencyMasterTriggerHandlerTestHelper.LittleContractInsertion('Little_003','LTC0003',null);
                     
        /** Multiple DamageCntract **/
        //DamageContract__c damageContract2 = AgencyMasterTriggerHandlerTestHelper.damageContractInsertion('Damage_002','DC0001,DC0002,DC0003');
        //AgencyMaster__c lifeAgency1 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC0001','DC0001','LTC0001');
        //AgencyMaster__c lifeAgency2 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC0002','DC0002','LTC0002');
        //AgencyMaster__c lifeAgency3 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC0003','DC0003','LTC0003');
        AgencyMaster__c agency1 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('LC0001','','');
        AgencyMaster__c agency2 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('','DC0001','');
        AgencyMaster__c agency3 = AgencyMasterTriggerHandlerTestHelper.agencyInsertion('','','LTC0001');
        
        //Delete lifeAgency1;
        //Delete lifeAgency2;
        //Delete lifeAgency3;Not deleted
        Delete agency1;
        Delete agency2;
        //Delete agency3;Not deleted
        
        test.stopTest();
        
        // //Assert
        // AgencyMasterTriggerHandlerTestHelper.assertValidationlifeContract(lifeContract1.Id,null);
        // AgencyMasterTriggerHandlerTestHelper.assertValidationDamageContract(damageContract1.Id,null,null,null);
        // //AgencyMasterTriggerHandlerTestHelper.assertValidationlittleContract(littleContract1.Id,null);
        // AgencyMasterTriggerHandlerTestHelper.assertValidationlittleContract(littleContract1.Id,agency3.Id);
        
        
        //AgencyMasterTriggerHandlerTestHelper.assertValidationlifeContract(lifeContract3.Id,lifeAgency3.id);
        //AgencyMasterTriggerHandlerTestHelper.assertValidationDamageContract(damageContract2.Id,lifeAgency3.id,null,null);
        //AgencyMasterTriggerHandlerTestHelper.assertValidationlittleContract(littleContract3.Id,lifeAgency3.id);
        
        /*LifeContract__c LifeContractUpdt = [SELECT AgencyId__c from LifeContract__c where id =: lifeContract1.Id];
        System.assertEquals(null,LifeContractUpdt.AgencyId__c);
        
        LifeContract__c LifeContractUpdt1 = [SELECT AgencyId__c from LifeContract__c where id =: lifeContract2.Id];
        System.assertEquals(null,LifeContractUpdt1.AgencyId__c);
        
        LifeContract__c LifeContractUpdt2 = [SELECT AgencyId__c from LifeContract__c where id =: lifeContract3.Id];
        System.assertEquals(null,LifeContractUpdt2.AgencyId__c);
        
        DamageContract__c damageContract1Updt = [SELECT AgencyId1__c,AgencyId2__c,AgencyId3__c from DamageContract__c where id =: damageContract1.Id];
        System.assertEquals(null,damageContract1Updt.AgencyId1__c);
        System.assertEquals(null,damageContract1Updt.AgencyId2__c);
        System.assertEquals(null,damageContract1Updt.AgencyId3__c);
        
        LittleContract__c LittleContractUpdt = [SELECT AgencyId__c from LittleContract__c where id =: littleContract1.Id];
        System.assertEquals(null,LittleContractUpdt.AgencyId__c);
        
        LittleContract__c LittleContractUpdt2 = [SELECT AgencyId__c from LittleContract__c where id =: littleContract2.Id];
        System.assertEquals(null,LittleContractUpdt2.AgencyId__c);
        
        LittleContract__c LittleContractUpdt3 = [SELECT AgencyId__c from LittleContract__c where id =: littleContract3.Id];
        System.assertEquals(null,LittleContractUpdt3.AgencyId__c);*/
    }
    
}