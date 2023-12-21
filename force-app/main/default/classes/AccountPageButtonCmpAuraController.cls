public class AccountPageButtonCmpAuraController{
    @AuraEnabled
    public static Map<String,Boolean> getAccountContract(String accountId){
        Map<String,Boolean> acctInfoMap =ContractCount.getContractCount(accountId);
        String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;
        if ('システム管理者'.equals(profileName) || 
            'System Administrator'.equals(profileName) || 
            '新会社業務委託ロール'.equals(profileName) || 
            '損保担当ロール'.equals(profileName)) {
            acctInfoMap.put('FAQ', true);
        }
        else {
            acctInfoMap.put('FAQ', false);
        }
        return acctInfoMap;
    }
    
    private static final String MSG_HASNOEDIT = 'SMSを送信する権限がありません。';
    private static final String MSG_HASNOAPPROSAL = '承諾がないので送信できません。';
    // SMS情報編集権限チェック
    @AuraEnabled
    public static string checkError(String accountId){
        System.debug('■■■ checkError called : ' + accountId);
        String retStr = '';
        // SMS送信情報編集権限
        if (!Schema.sObjectType.SMSInfo__c.isUpdateable()) {
            retStr = MSG_HASNOEDIT;
        // SMS送信許可
        } else if (!isPermissionFlag(accountId)) {
            retStr = MSG_HASNOAPPROSAL;
        }
        System.debug('■■■ retStr' + retStr);
        return retStr;
    }
    
    @AuraEnabled
    public static Boolean isPermissionFlag(String accountId) {
        
        System.debug('■■■ isPermissionFlag called : ' + accountId);
        Boolean ret = false;
        
        try {
            Account act = [
                            SELECT Id,
                                   Name,
                                   SMSPermissionFlgLife__c,
                                   SMSPermissionFlgSonpo__c,
                                   SMSPermissionFlgLittle__c
                              FROM Account
                             WHERE Id =: accountId
                             LIMIT 1 
                          ];
            ret = act.SMSPermissionFlgLife__c || act.SMSPermissionFlgSonpo__c || act.SMSPermissionFlgLittle__c;
        } catch (Exception e) {
            System.debug('■■■ Exception : ' + e.getMessage());
        }
        
        return ret;
    }
    
    
    @AuraEnabled
    public static Account getAccInternalCall(string recordId)
    {
        List<Account> accounts = [select Id,LastName,FirstName,furiganaLast__pc,furiganaForst__pc,Gender__pc,
                                  PersonHomePhone,PersonMobilePhone,PersonBirthdate,PersonMailingState,
                                  PersonMailingCity,PersonMailingStreet,PersonMailingPostalCode from Account 
                                  where id=:recordId]; 
        if(!accounts.isEmpty() && accounts.size() == 1){
            Account acc = accounts[0];
            
            String postalCode = String.IsNotBlank(acc.PersonMailingPostalCode) ? acc.PersonMailingPostalCode : '';
            postalCode = postalCode.replace('-', '');
            
            if (!String.IsBlank(postalCode)) {
                // Add 2023/03/29 RIPCRM-741_代理店不在地域郵便番号マスターのメンテナンス By 範　Start
                postalCode = postalCode.substring(0,3);
                // Add 2023/03/29 RIPCRM-741_代理店不在地域郵便番号マスターのメンテナンス By 範　End
                List<PostalCode_HasNoAgency__c> lstNoAgency =   [
                                                                    SELECT Id 
                                                                         , Name 
                                                                      FROM PostalCode_HasNoAgency__c 
                                                                     WHERE Name = :postalCode
                                                                ];
                if (lstNoAgency.isEmpty()) {
                    // Set Prefecture from AccountInfo
                    setInternalCallPrefecture(acc);
                }
                else {
                    // 代理店不在地域郵便番号判定
                    // Not a Valid PostalCode with Agency
                    // Return Error to LightningComponent
                    acc = new Account();
                    acc.PersonMailingPostalCode = 'ERROR_PO_NOAGENCY';
                }
            }
            else {
                // 郵便番号未入力判定
                // PostalCode is Blank
                // Return Error to LightningComponent
                acc = new Account();
                acc.PersonMailingPostalCode = 'ERROR_PO_BLANK';
            }
            
            return acc;
            // NOTREACHED
        }
        
        //レコードIDが存在しない場合は空文字を返却
        return null;
    }
    
    
    @AuraEnabled
    public static Account getAccInternalCallWithNoCheck(string recordId)
    {
        List<Account> accounts = [select Id,LastName,FirstName,furiganaLast__pc,furiganaForst__pc,Gender__pc,
                                  PersonHomePhone,PersonMobilePhone,PersonBirthdate,PersonMailingState,
                                  PersonMailingCity,PersonMailingStreet,PersonMailingPostalCode from Account 
                                  where id=:recordId]; 
        if(!accounts.isEmpty() && accounts.size() == 1){
            Account acc = accounts[0];
            
            // Set Prefecture from AccountInfo
            setInternalCallPrefecture(acc);
            
            return acc;
            // NOTREACHED
        }
        
        //レコードIDが存在しない場合は空文字を返却
        return null;
    }
    
    private static void setInternalCallPrefecture(Account acc) {
        // Get Prefecture List from the Picklist Field
        String address = NULL;
        Map<String, String> states = ReceptionController.getSinglePicklist('InternalCallEscalation__c','State__c');
        if (String.IsBlank(acc.PersonMailingState)) {
            address = String.IsNotBlank(acc.PersonMailingCity) ? acc.PersonMailingCity : '';
            address += String.IsNotBlank(acc.PersonMailingStreet) ? acc.PersonMailingStreet : '';
        }
        else if (states.get(acc.PersonMailingState) == NULL) {
            address = String.IsNotBlank(acc.PersonMailingState) ? acc.PersonMailingState : '';
            address += String.IsNotBlank(acc.PersonMailingCity) ? acc.PersonMailingCity : '';
            address += String.IsNotBlank(acc.PersonMailingStreet) ? acc.PersonMailingStreet : '';
        }
        
        if (String.IsNotBlank(address)) {
            for (String state : states.keyset()) {
                if (address.indexOf(state) != -1) {
                    acc.PersonMailingState = state;
                    acc.PersonMailingCity = '';
                    // Remove ONLY the First occurance of Prefecture
                    acc.PersonMailingStreet = address.substring(0, address.indexOf(state)) + 
                                                address.substring(
                                                    address.indexOf(state) + state.length(), 
                                                    address.length());
                    break;
                    // NOTERACHED
                }
            }
        }
    }

    public static final String AGE_CLASS_CODE_ADULT = '0';
    public static final String AGE_CLASS_CODE_MINOR = '1';
    public static final String AGE_CLASS_CODE_NA = '9';

    public static final String APP_DEADLINE_CODE_OFF = '0';
    public static final String APP_DEADLINE_CODE_ON = '1';
    public static final String APP_DEADLINE_CODE_NA = '9';

    @AuraEnabled
    public static Map<String, String> getAccountAgeInfo(String accountId) {
        final Date today = Date.today();
        Map<String, String> actAgeInfoMap = new Map<String, String>();
        Account act = [
            SELECT PersonBirthdate,
                   NowAge__c
              FROM Account
             WHERE Id =: accountId
             LIMIT 1 
        ];

        // 未成年判定
        String ageClassCd;
        if (!isBirthDate(today, act.PersonBirthdate)) {
            ageClassCd = AGE_CLASS_CODE_NA;
        } else if (isMinorAge(act.NowAge__c)) {
            ageClassCd = AGE_CLASS_CODE_MINOR;
        } else {
            ageClassCd = AGE_CLASS_CODE_ADULT;
        }
        System.debug('ageClassCd : ' + ageClassCd);
        actAgeInfoMap.put('ageClassCd', ageClassCd);

        // 月末までの申込期限判定
        String appDlCd;
        if (isBirthDate(today, act.PersonBirthdate)) {
            if (isAppDl(today, act.PersonBirthdate)) {
                appDlCd = APP_DEADLINE_CODE_ON;
            } else {
                appDlCd = APP_DEADLINE_CODE_OFF;
            }
        } else {
            appDlCd = APP_DEADLINE_CODE_NA;
        }
        System.debug('appDlCd : ' + appDlCd);
        actAgeInfoMap.put('appDlCd', appDlCd);

        return actAgeInfoMap;
    }

    @TestVisible
    private static Boolean isBirthDate(Date today, Date birthdate) {
        Boolean result = false;
        if (birthdate != null && birthdate <= today) {
            result = true;
        }
        System.debug('birthdate <= today : ' + (birthdate <= today));
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

    @TestVisible
    private static Boolean isAppDl(Date today, Date targetDate) {
        Boolean isAppDl = false;
        System.debug('targetDate(1) : ' + targetDate);
        // 誕生日が1日
        if (targetDate.day() == 1) {
            // 前々月
            if (today.month() == (targetDate.addMonths(-2).month())) {
                isAppDl = true;
            }
        } else {
            // 前月
            if (today.month() == (targetDate.addMonths(-1).month())) {
                isAppDl = true;
            }
        }
        System.debug('targetDate(2) : ' + targetDate);
        return isAppDl;
    }
}