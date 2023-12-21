public with sharing class LifeContractAlertCmpController {

    public static final String AGE_CLASS_CODE_ADULT = '0';
    public static final String AGE_CLASS_CODE_MINOR = '1';
    public static final String AGE_CLASS_CODE_NA = '9';

    @AuraEnabled
    public static Map<String, String> getContractAgeInfo(Id recordId) {
        final Date today = Date.today();
        Map<String, String> contractAgeInfoMap = new Map<String, String>();
        LifeContract__c contract = [
            SELECT CONTROR_BIRTH_DATE__c,
                   INSURED_BIRTH_DATE__c
              FROM LifeContract__c
             WHERE Id =: recordId
             LIMIT 1 
        ];

        // 未成年判定 契約者
        String ageClassCd;
        if (!isBirthDate(today, contract.CONTROR_BIRTH_DATE__c)) {
            ageClassCd = AGE_CLASS_CODE_NA;
        } else if (isMinorAge(today, contract.CONTROR_BIRTH_DATE__c)) {
            ageClassCd = AGE_CLASS_CODE_MINOR;
        } else {
            ageClassCd = AGE_CLASS_CODE_ADULT;
        }
        System.debug('ageClassCd : ' + ageClassCd);
        contractAgeInfoMap.put('ageClassCd', ageClassCd);

        // 未成年判定 被保険者
        String ageClassCdForInsured;
        if (!isBirthDate(today, contract.INSURED_BIRTH_DATE__c)) {
            ageClassCdForInsured = AGE_CLASS_CODE_NA;
        } else if (isMinorAge(today, contract.INSURED_BIRTH_DATE__c)) {
            ageClassCdForInsured = AGE_CLASS_CODE_MINOR;
        } else {
            ageClassCdForInsured = AGE_CLASS_CODE_ADULT;
        }
        System.debug('ageClassCdForInsured : ' + ageClassCdForInsured);
        contractAgeInfoMap.put('ageClassCdForInsured', ageClassCdForInsured);

        return contractAgeInfoMap;
    }

    @TestVisible
    private static Boolean isBirthDate(Date today, String strBirthdate) {
        Boolean result = false;
        Date birthdate = null;
        try {
            birthdate = Date.parse(strBirthDate);
            System.debug('■ birthdate: ' + birthdate);
        } catch(Exception e) {
            System.debug('■■■ Exception : ' + e.getMessage());
        }
        if (birthdate != null && birthdate <= today) {
            result = true;
        }
        return result;
    }

    @TestVisible
    private static Boolean isMinorAge(Date today, String strBirthDate) {
        Boolean isMinorAge = false;
        if (getAge(today, strBirthDate) < 18) {
            isMinorAge = true;
        }
        return isMinorAge;
    }

    @TestVisible
    private static Integer getAge(Date today, String strBirthDate) {
        Integer age = null;
        Date birthdate = null;
        try {
            birthdate = Date.parse(strBirthDate);
            System.debug('■ birthdate: ' + birthdate);
        } catch(Exception e) {
            System.debug('■■■ Exception : ' + e.getMessage());
        }
        if (birthdate != null) {
            System.debug('■ Date.today(): ' + today);
            if ((today.month() - birthdate.month()) > 0
                || ((today.month() - birthdate.month()) >= 0
                && (today.day() - birthdate.day()) >= 0)) {
                age = today.year() - birthdate.year();
            } else {
                age = today.year() - birthdate.year() - 1;
            }
        }
        System.debug('■ age: ' + age);
        return age;
    }
}