@isTest
public with sharing class SeihoOpportunityAlertCmpControllerTest {

    @isTest static void getAgeInfo_ageClassCode_adult() {
        // data
        Date birthdate = Date.today().addYears(-18);
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = birthdate
        );
        insert act;
        SeihoOpportunity__c sOpportunity = new SeihoOpportunity__c(
            Ref_Account__c = act.Id
        );
        insert sOpportunity;

        // execute
        Test.startTest();
        Map<String, String> result = SeihoOpportunityAlertCmpController.getAgeInfo(sOpportunity.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
    }

    @isTest static void getAgeInfo_ageClassCode_minor() {
        // data
        Date birthdate = Date.today().addYears(-18).addDays(1);
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = birthdate
        );
        insert act;
        SeihoOpportunity__c sOpportunity = new SeihoOpportunity__c(
            Ref_Account__c = act.Id
        );
        insert sOpportunity;

        // execute
        Test.startTest();
        Map<String, String> result = SeihoOpportunityAlertCmpController.getAgeInfo(sOpportunity.Id);
        Test.stopTest();

        // verify
        System.assertEquals('1', result.get('ageClassCd'));
    }

    @isTest static void getAgeInfo_ageClassCode_na() {
        // data
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = null
        );
        insert act;
        SeihoOpportunity__c sOpportunity = new SeihoOpportunity__c(
            Ref_Account__c = act.Id
        );
        insert sOpportunity;

        // execute
        Test.startTest();
        Map<String, String> result = SeihoOpportunityAlertCmpController.getAgeInfo(sOpportunity.Id);
        Test.stopTest();

        // verify
        System.assertEquals('9', result.get('ageClassCd'));
    }

    @isTest static void getAgeInfo_ageClassCode_na_non_account() {
        // data
        SeihoOpportunity__c sOpportunity = new SeihoOpportunity__c(
            Ref_Account__c = null
        );
        insert sOpportunity;

        // execute
        Test.startTest();
        Map<String, String> result = SeihoOpportunityAlertCmpController.getAgeInfo(sOpportunity.Id);
        Test.stopTest();

        // verify
        System.assertEquals('9', result.get('ageClassCd'));
    }

    @isTest static void isBirthDate_success() {
        // data
        Date today = Date.newInstance(2022, 1, 1);

        // verify
        System.assertEquals(true, SeihoOpportunityAlertCmpController.isBirthDate(today, Date.newInstance(2021, 12, 31)));
        System.assertEquals(true, SeihoOpportunityAlertCmpController.isBirthDate(today, Date.newInstance(2022, 1, 1)));
        System.assertEquals(false, SeihoOpportunityAlertCmpController.isBirthDate(today, Date.newInstance(2022, 1, 2)));
        System.assertEquals(false, SeihoOpportunityAlertCmpController.isBirthDate(today, null));
    }

    @isTest static void isMinorAge_success() {
        // data
        Decimal baseValue = 18;

        // verify
        System.assertEquals(true, SeihoOpportunityAlertCmpController.isMinorAge(baseValue - 1));
        System.assertEquals(false, SeihoOpportunityAlertCmpController.isMinorAge(baseValue));
        System.assertEquals(false, SeihoOpportunityAlertCmpController.isMinorAge(baseValue + 1));
        System.assertEquals(false, SeihoOpportunityAlertCmpController.isMinorAge(null));
    }
}