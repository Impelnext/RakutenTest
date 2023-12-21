/*
* @Class Name      : AgencyMasterTriggerHandlerTestHelper 
* @Description     : Created for AgencyMasterTriggerHandlerTest
* @Created Date    : 2019.09.16
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
public class AgencyMasterTriggerHandlerTestHelper {
    
    /**********************************************************************************/
    /* Method Name  :  lifeContractInsertion
    /* Description  :  create record in Life Contract
    /**********************************************************************************/
    public static LifeContract__c lifeContractInsertion(String lifeContractName,string agencyNumber,Id agencyId){
        LifeContract__c life = new LifeContract__c();
        life.Name = lifeContractName; //'TestLC001';
        life.AGENCY_NUM__c = agencyNumber; //'LC001';
        if(agencyId != null){
            life.AgencyId__c = agencyId;
        }
        insert life;
        return life;
    }
    /**********************************************************************************/
    /* Method Name  :  damageContractInsertion
    /* Description  :  create record in Damage Contract
    /**********************************************************************************/
    public static DamageContract__c damageContractInsertion(String damageContractName,String damageAgencyCode){
        DamageContract__c damage = new DamageContract__c();
        damage.Name = damageContractName; //'DC00';
        damage.AgencyCode__c = damageAgencyCode; //'DC001,DC002';
        damage.AccountId__c = createAccount(damageContractName);
        
        List<String> damageAgencyCodeList = damageAgencyCode.split(',');
        if(damageAgencyCodeList.size() == 1){
            damage.AgencyCode1__c = damageAgencyCodeList.get(0);
        }else{
            damage.AgencyCode1__c = damageAgencyCodeList.get(0);
            damage.AgencyCode2__c = damageAgencyCodeList.get(1);
            damage.AgencyCode3__c = damageAgencyCodeList.get(2);
        }
        insert damage;
        return damage;
    }
    /**********************************************************************************/
    /* Method Name  :  LittleContractInsertion
    /* Description  :  create record in Little Contract
    /**********************************************************************************/
    public static LittleContract__c LittleContractInsertion(String littleContractName,String littleAgencyCode,Id agencyId){
        LittleContract__c little = new LittleContract__c();
        little.Name = littleContractName; //'TestLTC001';
        little.AgencyCode__c = littleAgencyCode; //'LTC001';
        if(agencyId != null){
            little.AgencyId__c = agencyId;
        }
        insert little;
        return little;
    }
    /**********************************************************************************/
    /* Method Name  :  agencyInsertion
    /* Description  :  create record in Agency Master
    /**********************************************************************************/
    public static AgencyMaster__c agencyInsertion(String seihoAgencyCode,String SonpoAgencyCode,String ShotanAgencyCode){
        AgencyMaster__c agency = new AgencyMaster__c();
        if(seihoAgencyCode != null)
            agency.SeihoAgencyCode__c = seihoAgencyCode; //'LC001'; 
        if(SonpoAgencyCode != null)
            agency.SonpoAgencyCode__c = SonpoAgencyCode;
        if(ShotanAgencyCode != null)
            agency.ShotanAgencyCode__c = ShotanAgencyCode;
        
        insert agency;
        return agency;
    }
    /**********************************************************************************/
    /* Method Name  :  assertValidationlifeContract
    /* Description  :  Validating result
    /**********************************************************************************/
    public static void assertValidationlifeContract(Id lifeContractId, Id lifeAgencyId){
        LifeContract__c lifeContract = [SELECT AgencyId__c from LifeContract__c where id =: lifeContractId];
        System.assertEquals(lifeAgencyId,lifeContract.AgencyId__c);
    }
    /**********************************************************************************/
    /* Method Name  :  assertValidationDamageContract
    /* Description  :  Validating result
    /**********************************************************************************/
    public static void assertValidationDamageContract(Id damageContract1,Id damageAgencyId,Id damageAgencyId2,Id damageAgencyId3){
        DamageContract__c damageContract1Updt = [SELECT AgencyId1__c,AgencyId2__c,AgencyId3__c from DamageContract__c where id =: damageContract1];            
        System.assertEquals(damageAgencyId,damageContract1Updt.AgencyId1__c);
        System.assertEquals(damageAgencyId2,damageContract1Updt.AgencyId2__c);
        System.assertEquals(damageAgencyId3,damageContract1Updt.AgencyId3__c);
    }
    /**********************************************************************************/
    /* Method Name  :  assertValidationlittleContract
    /* Description  :  Validating result
    /**********************************************************************************/
    public static void assertValidationlittleContract(Id littleContractId, Id littleAgencyId){
        LittleContract__c littleContract = [SELECT AgencyId__c from LittleContract__c where id =: littleContractId];
        System.assertEquals(littleAgencyId,littleContract.AgencyId__c);
    }
    
    /**********************************************************************************/
    /* Method Name  :  createAccount
    /* Description  :  create record in Account
    /**********************************************************************************/
    public static Id createAccount(String accountName){
        List<RecordType> recordTypes = [
                                            SELECT Id, Name 
                                              FROM RecordType 
                                             WHERE SobjectType = 'Account' 
                                               AND Name = '個人取引先'
                                       ];
        Account acc = new Account(
                            LastName = String.IsNotBlank(accountName) ? accountName : '個人',
                            FirstName = '取引先',
                            furiganaLast__pc = String.IsNotBlank(accountName) ? accountName : 'コジン',
                            furiganaForst__pc = 'トリヒキサキ',
                            PersonHomePhone = '11-1111-1111',
                            PersonMobilePhone = '22-2222-2222',
                            PersonBirthdate = date.newInstance(1998, 1, 10),
                            Gender__pc = '女性',
                            PersonMailingPostalCode = '111-0000',
                            PersonMailingState = '東京都',
                            PersonMailingCity = '世田谷区',
                            PersonMailingStreet = '玉川１－１４－１',
                            PersonEmail = 'example01@example.com',
                            RecordTypeId=recordTypes[0].Id
                        );
        insert acc;
        return acc.Id;
    }
}