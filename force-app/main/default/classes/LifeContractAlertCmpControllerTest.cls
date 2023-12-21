@isTest
public with sharing class LifeContractAlertCmpControllerTest {

    private static String convertDateToString(Date dt) {
        String result = null;
        if (dt != null) {
            result = 
                String.valueOf(dt.year()) + '/'
                + String.valueOf(dt.month()).leftPad(2, '0') + '/'
                + String.valueOf(dt.day()).leftPad(2, '0');
        }
        return result;
    }

    @isTest static void getContractAgeInfo_cont_adult_insrd_adult() {
        // data
        Date birthdate = Date.today().addYears(-18);
        Date birthdateForInsrd = Date.today().addYears(-18);
        LifeContract__c contract = new LifeContract__c(
            CONTROR_BIRTH_DATE__c = convertDateToString(birthdate),
            INSURED_BIRTH_DATE__c = convertDateToString(birthdateForInsrd)
        );
        insert contract;

        // execute
        Test.startTest();
        Map<String, String> result = LifeContractAlertCmpController.getContractAgeInfo(contract.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
        System.assertEquals('0', result.get('ageClassCdForInsured'));
    }

    @isTest static void getContractAgeInfo_cont_minor_insrd_adult() {
        // data
        Date birthdate = Date.today().addYears(-18).addDays(1);
        Date birthdateForInsrd = Date.today().addYears(-18);
        LifeContract__c contract = new LifeContract__c(
            CONTROR_BIRTH_DATE__c = convertDateToString(birthdate),
            INSURED_BIRTH_DATE__c = convertDateToString(birthdateForInsrd)
        );
        insert contract;

        // execute
        Test.startTest();
        Map<String, String> result = LifeContractAlertCmpController.getContractAgeInfo(contract.Id);
        Test.stopTest();

        // verify
        System.assertEquals('1', result.get('ageClassCd'));
        System.assertEquals('0', result.get('ageClassCdForInsured'));
    }

    @isTest static void getContractAgeInfo_cont_na_insrd_adult() {
        // data
        Date birthdate = null;
        Date birthdateForInsrd = Date.today().addYears(-18);
        LifeContract__c contract = new LifeContract__c(
            CONTROR_BIRTH_DATE__c = convertDateToString(birthdate),
            INSURED_BIRTH_DATE__c = convertDateToString(birthdateForInsrd)
        );
        insert contract;

        // execute
        Test.startTest();
        Map<String, String> result = LifeContractAlertCmpController.getContractAgeInfo(contract.Id);
        Test.stopTest();

        // verify
        System.assertEquals('9', result.get('ageClassCd'));
        System.assertEquals('0', result.get('ageClassCdForInsured'));
    }

    @isTest static void getContractAgeInfo_cont_adult_insrd_minor() {
        // data
        Date birthdate = Date.today().addYears(-18);
        Date birthdateForInsrd = Date.today().addYears(-18).addDays(1);
        LifeContract__c contract = new LifeContract__c(
            CONTROR_BIRTH_DATE__c = convertDateToString(birthdate),
            INSURED_BIRTH_DATE__c = convertDateToString(birthdateForInsrd)
        );
        insert contract;

        // execute
        Test.startTest();
        Map<String, String> result = LifeContractAlertCmpController.getContractAgeInfo(contract.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
        System.assertEquals('1', result.get('ageClassCdForInsured'));
    }

    @isTest static void getContractAgeInfo_cont_adult_insrd_na() {
        // data
        Date birthdate = Date.today().addYears(-18);
        Date birthdateForInsrd = null;
        LifeContract__c contract = new LifeContract__c(
            CONTROR_BIRTH_DATE__c = convertDateToString(birthdate),
            INSURED_BIRTH_DATE__c = convertDateToString(birthdateForInsrd)
        );
        insert contract;

        // execute
        Test.startTest();
        Map<String, String> result = LifeContractAlertCmpController.getContractAgeInfo(contract.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
        System.assertEquals('9', result.get('ageClassCdForInsured'));
    }

    @isTest static void isBirthDate_success() {
        // data
        Date today = Date.newInstance(2022, 1, 1);

        // verify
        System.assertEquals(true, LifeContractAlertCmpController.isBirthDate(today, '2021/12/31'));
        System.assertEquals(true, LifeContractAlertCmpController.isBirthDate(today, '2022/01/01'));
        System.assertEquals(false, LifeContractAlertCmpController.isBirthDate(today, '2022/01/02'));
        System.assertEquals(false, LifeContractAlertCmpController.isBirthDate(today, 'abc'));
        System.assertEquals(false, LifeContractAlertCmpController.isBirthDate(today, null));
    }

    @isTest static void isMinorAge_success() {
        // data
        Date today = Date.newInstance(2022, 1, 1);
        Integer adultAge = 18;

        // verify
        System.assertEquals(true, LifeContractAlertCmpController.isMinorAge(today, convertDateToString(today.addYears((0 - adultAge)).addDays(1))));
        System.assertEquals(false, LifeContractAlertCmpController.isMinorAge(today, convertDateToString(today.addYears((0 - adultAge)))));
        System.assertEquals(false, LifeContractAlertCmpController.isMinorAge(today, convertDateToString(today.addYears((0 - adultAge)).addDays(-1))));
        System.assertEquals(false, LifeContractAlertCmpController.isMinorAge(today, convertDateToString(today.addYears((0 - (adultAge + 1))))));
        System.assertEquals(false, LifeContractAlertCmpController.isMinorAge(today, 'abc'));
        System.assertEquals(false, LifeContractAlertCmpController.isMinorAge(today, null));
    }

    @isTest static void getAge_success() {
        // data
        Date today = Date.newInstance(2022, 1, 1);
        Integer adultAge = 18;

        // verify
        System.assertEquals(0, LifeContractAlertCmpController.getAge(today, convertDateToString(today)));
        System.assertEquals(1, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears(-1))));
        System.assertEquals(100, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears(-100))));
        System.assertEquals(-1, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addDays(1))));
        System.assertEquals(-1, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears(1))));
        System.assertEquals(null, LifeContractAlertCmpController.getAge(today, 'abc'));
        System.assertEquals(null, LifeContractAlertCmpController.getAge(today, null));
        System.assertEquals(17, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears((0 - adultAge)).addDays(1))));
        System.assertEquals(18, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears((0 - adultAge)))));
        System.assertEquals(18, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears((0 - adultAge)).addDays(-1))));
        System.assertEquals(19, LifeContractAlertCmpController.getAge(today, convertDateToString(today.addYears((0 - (adultAge + 1))))));
    }
}