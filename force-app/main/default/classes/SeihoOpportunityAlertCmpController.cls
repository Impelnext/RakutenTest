public with sharing class SeihoOpportunityAlertCmpController {

    public static final String AGE_CLASS_CODE_ADULT = '0';
    public static final String AGE_CLASS_CODE_MINOR = '1';
    public static final String AGE_CLASS_CODE_NA = '9';

    @AuraEnabled
    public static Map<String, String> getAgeInfo(Id recordId) {
        final Date today = Date.today();
        Map<String, String> ageInfoMap = new Map<String, String>();
        SeihoOpportunity__c sOpportunity = [
            SELECT Ref_Account__r.PersonBirthdate,
                   Ref_Account__r.NowAge__c
              FROM SeihoOpportunity__c
             WHERE Id =: recordId
             LIMIT 1 
        ];
        System.debug('sOpportunity.Ref_Account__r.PersonBirthdate : ' + sOpportunity.Ref_Account__r.PersonBirthdate);
        System.debug('sOpportunity.Ref_Account__r.NowAge__c : ' + sOpportunity.Ref_Account__r.NowAge__c);

        // 未成年判定
        String ageClassCd;
        if (!isBirthDate(today, sOpportunity.Ref_Account__r.PersonBirthdate)) {
            ageClassCd = AGE_CLASS_CODE_NA;
        } else if (isMinorAge(sOpportunity.Ref_Account__r.NowAge__c)) {
            ageClassCd = AGE_CLASS_CODE_MINOR;
        } else {
            ageClassCd = AGE_CLASS_CODE_ADULT;
        }
        System.debug('ageClassCd : ' + ageClassCd);
        ageInfoMap.put('ageClassCd', ageClassCd);

        return ageInfoMap;
    }

    @TestVisible
    private static Boolean isBirthDate(Date today, Date birthdate) {
        Boolean result = false;
        if (birthdate != null && birthdate <= today) {
            result = true;
        }
        return result;
    }

    @TestVisible
    private static Boolean isMinorAge(Decimal age) {
        Boolean isMinorAge = false;
        if (age < 18) {
            isMinorAge = true;
        }
        return isMinorAge;
    }
}