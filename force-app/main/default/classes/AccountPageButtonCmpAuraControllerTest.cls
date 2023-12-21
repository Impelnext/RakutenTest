@isTest 
public with sharing class AccountPageButtonCmpAuraControllerTest {
    @isTest static void testMethod_T01(){
        Account acc = [Select id From Account Limit 1];
        Map<String,Boolean> test = AccountPageButtonCmpAuraController.getAccountContract(acc.id);
        Account ac = AccountPageButtonCmpAuraController.getAccInternalCall(acc.id);
        System.AssertEquals(ac.Id, acc.Id);
    }
    
    @isTest static void testMethod_T02(){
        Account acc = [Select id From Account Limit 1];
        String  msg = AccountPageButtonCmpAuraController.checkError(acc.id);
    }
    @isTest static void testMethod_T03(){
        Account acc = [Select id From Account Limit 1];
        Map<String,Boolean> test = AccountPageButtonCmpAuraController.getAccountContract(acc.id);
        Account ac = AccountPageButtonCmpAuraController.getAccInternalCall(acc.id);
        System.AssertEquals(ac.Id, acc.Id);
}
    @TestSetup
    static void makeTestData(){
        //取引先作成
        List<Account> accList = new List<Account>();
        Account acc = new Account();
        acc = createAccount();
        accList.add(acc);
        insert accList;
    }
    
    public static account createAccount(){
        Account accountObj = new Account (
            LastName = '個人',
            FirstName = '取引先',
            LastName__pc = '個人',
            firstname__pc = '取引先',
            furiganaLast__pc = 'こじん',
            furiganaForst__pc = 'とりひきさき',
            PersonHomePhone = '03-0000-0000',
            PersonMobilePhone = '080-0000-0000',
            PersonBirthdate = Date.newInstance(1985, 1, 1),
            Gender__pc = '男性',
            PersonMailingPostalCode = '100-0000',
            PersonMailingCity = '北海道'
       );
       return accountObj;
    }

    @isTest static void getAccountAgeInfo_ageClassCode_adult() {
        // data
        Date birthdate = Date.today().addYears(-18);
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = birthdate
        );
        insert act;

        // execute
        Test.startTest();
        Map<String, String> result = AccountPageButtonCmpAuraController.getAccountAgeInfo(act.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
        System.assertEquals('0', result.get('appDlCd'));
    }

    @isTest static void getAccountAgeInfo_ageClassCode_minor() {
        // data
        Date birthdate = Date.today().addYears(-18).addDays(1);
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = birthdate
        );
        insert act;

        // execute
        Test.startTest();
        Map<String, String> result = AccountPageButtonCmpAuraController.getAccountAgeInfo(act.Id);
        Test.stopTest();

        // verify
        System.assertEquals('1', result.get('ageClassCd'));
        System.assertEquals('0', result.get('appDlCd'));
    }

    @isTest static void getAccountAgeInfo_ageClassCode_na() {
        // data
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = null
        );
        insert act;

        // execute
        Test.startTest();
        Map<String, String> result = AccountPageButtonCmpAuraController.getAccountAgeInfo(act.Id);
        Test.stopTest();

        // verify
        System.assertEquals('9', result.get('ageClassCd'));
        System.assertEquals('9', result.get('appDlCd'));
    }

    @isTest static void getAccountAgeInfo_appDeadlineCode_on() {
        // data
        Date birthdate = Date.today().addYears(-20).addMonths(2);
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = Date.newInstance(birthdate.year(), birthdate.month(), 1)
        );
        insert act;

        // execute
        Test.startTest();
        Map<String, String> result = AccountPageButtonCmpAuraController.getAccountAgeInfo(act.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
        System.assertEquals('1', result.get('appDlCd'));
    }

    @isTest static void getAccountAgeInfo_appDeadlineCode_off() {
        // data
        Date birthdate = Date.today().addYears(-20).addMonths(1);
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = Date.newInstance(birthdate.year(), birthdate.month(), 1)
        );
        insert act;

        // execute
        Test.startTest();
        Map<String, String> result = AccountPageButtonCmpAuraController.getAccountAgeInfo(act.Id);
        Test.stopTest();

        // verify
        System.assertEquals('0', result.get('ageClassCd'));
        System.assertEquals('0', result.get('appDlCd'));
    }

    @isTest static void getAccountAgeInfo_appDeadlineCode_na() {
        // data
        Account act = new Account(
            LastName = '太郎',
            FirstName = '楽天',
            PersonBirthdate = null
        );
        insert act;

        // execute
        Test.startTest();
        Map<String, String> result = AccountPageButtonCmpAuraController.getAccountAgeInfo(act.Id);
        Test.stopTest();

        // verify
        System.assertEquals('9', result.get('ageClassCd'));
        System.assertEquals('9', result.get('appDlCd'));
    }

    @isTest static void isBirthDate_success() {
        // data
        Date today = Date.newInstance(2022, 1, 1);

        // verify
        System.assertEquals(true, AccountPageButtonCmpAuraController.isBirthDate(today, Date.newInstance(2021, 12, 31)));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isBirthDate(today, Date.newInstance(2022, 1, 1)));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isBirthDate(today, Date.newInstance(2022, 1, 2)));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isBirthDate(today, null));
    }

    @isTest static void isMinorAge_success() {
        // data
        Decimal baseValue = 18;

        // verify
        System.assertEquals(true, AccountPageButtonCmpAuraController.isMinorAge(baseValue - 1));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isMinorAge(baseValue));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isMinorAge(baseValue + 1));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isMinorAge(null));
    }

    @isTest static void isAppDl_success() {

        // 誕生日の日が1日　・・・　前々月の期間中ture
        // data
        Date birthdate = Date.newInstance(2022, 1, 1);

        // verify
        System.assertEquals(false, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 10, 31), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 11, 1), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 11, 15), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 11, 30), birthdate));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 12, 1), birthdate));

        // 誕生日の日が1日以外　・・・　前月の期間中ture
        // data
        birthdate = Date.newInstance(2022, 1, 2);

        // verify
        System.assertEquals(false, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 11, 30), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 12, 1), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 12, 15), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2021, 12, 31), birthdate));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2022, 1, 1), birthdate));

        // 誕生日の日が1日以外（うるう年）　・・・　前月の期間中ture
        // data
        birthdate = Date.newInstance(2020, 3, 2);

        // verify
        System.assertEquals(false, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2020, 1, 31), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2020, 2, 1), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2020, 2, 15), birthdate));
        System.assertEquals(true, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2020, 2, 29), birthdate));
        System.assertEquals(false, AccountPageButtonCmpAuraController.isAppDl(Date.newInstance(2020, 3, 1), birthdate));
    }
    @isTest static void getAccInternalCallWithNoCheck() {
       Account acc = [Select id From Account Limit 1];
        Map<String,Boolean> test = AccountPageButtonCmpAuraController.getAccountContract(acc.id);
        Account ac = AccountPageButtonCmpAuraController.getAccInternalCallWithNoCheck(acc.id);
        System.AssertEquals(ac.Id, acc.Id);
    }
}