/*
 * @Class Name      : DisclosureDesignationTriggerHandlerTest
 * @Description     : 開示指定者トリガーハンドラーテスト
 * @Created Date    : 2021.06.30
 * @Created By      : Takasumi Ito
 * @Modified Date   : 2021.01.04
 * @Modified By     : Sam jeshwin raj
 */
@IsTest
public class DisclosureDesignationTriggerHandlerTest {

    @isTest
    static void checkExistDiscDesPer_succes_not_exist_one_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account = triggerHandlerTest.createAccount(0);
        insert account;
        DisclosureDesignation__c disclosureDesignation = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.checkExistDiscDesPer(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }

    }

    @isTest
    static void checkExistDiscDesPer_succes_not_exist_multi_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);  // 取引先0 - 開示指定者0
        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);  // 取引先1 - 開示指定者1
        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);  // 取引先2 - 開示指定者2
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.checkExistDiscDesPer(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);
        DisclosureDesignation__c expect2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }

    }

    @isTest
    static void checkExistDiscDesPer_succes_not_exist_zero_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.checkExistDiscDesPer(disclosureDesignationList);
        Test.stopTest();

        // expected value
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');

    }

    @isTest
    static void checkExistDiscDesPer_succes_exist_one_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account = triggerHandlerTest.createAccount(0);
        insert account;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account.Id, 1);
        insert disclosureDesignation1;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.checkExistDiscDesPer(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        expect.addError('取引先に紐づく開示指定者情報が既に存在しています。');
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
            for (Integer j = 0; j < nestDisclosureDesignationErrors.size(); j++) {
                DataBase.Error nestDisclosureDesignationError = nestDisclosureDesignationErrors.get(j);
                DataBase.Error nestExpectError = nestExpectErrors.get(j);
                System.assertEquals(nestExpectError.message, nestDisclosureDesignationError.message, 'message');
            }
        }

    }

    @isTest
    static void checkExistDiscDesPer_succes_exist_multi_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);  // 取引先0 - 開示指定者0
        insert disclosureDesignation0;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 1);  // 取引先0 - 開示指定者1

        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 2);  // 取引先1 - 開示指定者2
        insert disclosureDesignation2;
        DisclosureDesignation__c disclosureDesignation3 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 3);  // 取引先1 - 開示指定者3

        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation4 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 4);  // 取引先2 - 開示指定者4

        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation3);
        disclosureDesignationList.add(disclosureDesignation4);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.checkExistDiscDesPer(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 1);
        expect1.addError('取引先に紐づく開示指定者情報が既に存在しています。');
        DisclosureDesignation__c expect3 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 3);
        expect3.addError('取引先に紐づく開示指定者情報が既に存在しています。');
        DisclosureDesignation__c expect4 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 4);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect1);
        expects.add(expect3);
        expects.add(expect4);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
            for (Integer j = 0; j < nestDisclosureDesignationErrors.size(); j++) {
                DataBase.Error nestDisclosureDesignationError = nestDisclosureDesignationErrors.get(j);
                DataBase.Error nestExpectError = nestExpectErrors.get(j);
                System.assertEquals(nestExpectError.message, nestDisclosureDesignationError.message, 'message');
            }
        }

    }

    @isTest
    static void editByStatus_succes_status_not_stop_one_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account = triggerHandlerTest.createAccount(0);
        insert account;
        DisclosureDesignation__c disclosureDesignation = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.editByStatus(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }

    }

    @isTest
    static void editByStatus_succes_status_not_stop_multi_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);  // 取引先0 - 開示指定者0

        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);  // 取引先1 - 開示指定者1

        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);  // 取引先2 - 開示指定者2

        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.editByStatus(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);
        DisclosureDesignation__c expect2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }

    }

    @isTest
    static void editByStatus_succes_status_not_stop_zero_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.editByStatus(disclosureDesignationList);
        Test.stopTest();

        // expected value
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');

    }

    @isTest
    static void editByStatus_succes_status_stop_one_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account = triggerHandlerTest.createAccount(0);
        insert account;
        DisclosureDesignation__c disclosureDesignation = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        disclosureDesignation.Status__c = '停止';
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.editByStatus(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect = triggerHandlerTest.createDisclosureDesignationByStopStatus(account.Id, 0);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
           // System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }

    }
    @isTest //レコード 削除 追加 【統合CRM】RIPDEV-170_損保家族登録開始
    static void DeleteStsSec2() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignationSec2(account0.Id, 0);  // 取引先0 - 開示指定者0
        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignationSec2(account1.Id, 1);  // 取引先1 - 開示指定者1
        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignationSec2(account2.Id, 2);  // 取引先2 - 開示指定者2
        disclosureDesignation2.Status2__c='レコード削除';
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);
        Insert disclosureDesignationList;
        //更新
        disclosureDesignationList[1].Status2__c='レコード削除';
        update disclosureDesignationList;
        
        List<DisclosureDesignation__c> disclosureDesignations= [Select Account__c,Counter2__c,Status2__c,section2__c,NameKana2__c,NameKanji2__c,Relationship2__c ,
                                                                Birthday2__c ,PhoneNumber2__c from DisclosureDesignation__c  where Id =:disclosureDesignationList order by Account__c];
                                   
        // expected value
        DisclosureDesignation__c expect0 = triggerHandlerTest.createDisclosureDesignationSec2(account0.Id, 0);
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignationByDeleteStatusSec2(account1.Id, 1);
        DisclosureDesignation__c expect2 = triggerHandlerTest.createDisclosureDesignationByDeleteStatusSec2(account2.Id, 2);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);
        System.debug(disclosureDesignations+',@@@'+expects);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
        
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignations.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            //System.debug(nestExpect.Counter2__c+'@@@'+nestDisclosureDesignation.Counter2__c);
            System.assertEquals(nestExpect.Counter2__c, nestDisclosureDesignation.Counter2__c, 'Counter2__c');
            System.assertEquals(nestExpect.Status2__c, nestDisclosureDesignation.Status2__c, 'Status2__c');
            System.assertEquals(nestExpect.NameKana2__c, nestDisclosureDesignation.NameKana2__c, 'NameKana2__c');
            System.assertEquals(nestExpect.NameKanji2__c, nestDisclosureDesignation.NameKanji2__c, 'NameKanji2__c');
            System.assertEquals(nestExpect.Relationship2__c, nestDisclosureDesignation.Relationship2__c, 'Relationship2__c');
            System.assertEquals(nestExpect.Birthday2__c, nestDisclosureDesignation.Birthday2__c, 'Birthday2__c');
            System.assertEquals(nestExpect.PhoneNumber2__c, nestDisclosureDesignation.PhoneNumber2__c, 'PhoneNumber2__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }
     } 
 @isTest //'レコード削除' 値追加 【統合CRM】RIPDEV-170_損保家族登録
    static void DeleteSts() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);  // 取引先0 - 開示指定者0
        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);  // 取引先1 - 開示指定者1
        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);  // 取引先2 - 開示指定者2
        disclosureDesignation2.Status__c='レコード削除';
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);
        Insert disclosureDesignationList;
        //更新
        disclosureDesignationList[1].Status__c='レコード削除';
        update disclosureDesignationList;
        
        List<DisclosureDesignation__c> disclosureDesignations= [Select Account__c,Counter__c,Status__c,section__c,NameKana__c,NameKanji__c,Relationship__c ,
                                                                Birthday__c ,PhoneNumber__c from DisclosureDesignation__c  where Id =:disclosureDesignationList order by Account__c];
                                   
        // expected value
        DisclosureDesignation__c expect0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignationByDeleteStatus(account1.Id, 1);
        DisclosureDesignation__c expect2 = triggerHandlerTest.createDisclosureDesignationByDeleteStatus(account2.Id, 2);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);
        System.debug(disclosureDesignations+',@@@'+expects);
    
        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
        
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignations.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }
     } 
    @isTest
    static void editByStatus_succes_status_stop_multi_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);  // 取引先0 - 開示指定者0
        disclosureDesignation0.Status__c = '停止';

        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);  // 取引先1 - 開示指定者1
        disclosureDesignation1.Status__c = '停止';

        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);  // 取引先2 - 開示指定者2

        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.editByStatus(disclosureDesignationList);
        Test.stopTest();

        // expected value
        DisclosureDesignation__c expect0 = triggerHandlerTest.createDisclosureDesignationByStopStatus(account0.Id, 0);
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignationByStopStatus(account1.Id, 1);
        DisclosureDesignation__c expect2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignationList.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            //System.assertEquals(nestExpect.Counter__c, nestDisclosureDesignation.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestDisclosureDesignation.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestDisclosureDesignation.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestDisclosureDesignation.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestDisclosureDesignation.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestDisclosureDesignation.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestDisclosureDesignation.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }

    }

    @isTest
    static void createDisclosureDesignationHistory_succes_one_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account = triggerHandlerTest.createAccount(0);
        insert account;
        DisclosureDesignation__c disclosureDesignation = triggerHandlerTest.createDisclosureDesignation(account.Id, 0);
        insert disclosureDesignation;
        delete [SELECT Id FROM DisclosureDesignationHistory__c WHERE DisclosureDesignation__c =: disclosureDesignation.id];
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.createDisclosureDesignationHistory(disclosureDesignationList);
        Test.stopTest();
        Set<Id> disclosureDesignationIdSet = new Set<Id>();
        disclosureDesignationIdSet.add(disclosureDesignation.id);
        List<DisclosureDesignationHistory__c> results =
        [
            SELECT Id, DisclosureDesignation__c, Counter__c, Status__c, NameKana__c, NameKanji__c, Relationship__c, Birthday__c, PhoneNumber__c
            FROM DisclosureDesignationHistory__c
            WHERE DisclosureDesignation__c IN: disclosureDesignationIdSet
        ];

        // expected value
        DisclosureDesignationHistory__c expect = triggerHandlerTest.createDisclosureDesignationHistory(disclosureDesignation.Id, 0);
        List<DisclosureDesignationHistory__c> expects = new List<DisclosureDesignationHistory__c>();
        expects.add(expect);

        // verify
        System.assertEquals(expects.size(), results.size(), 'size');
        Map<Id, DisclosureDesignationHistory__c> expectMap = new Map<Id, DisclosureDesignationHistory__c>();
        for (DisclosureDesignationHistory__c nestExpect : expects) {
            expectMap.put(nestExpect.DisclosureDesignation__c, nestExpect);
        }
        for (Integer i = 0; i < results.size(); i++) {
            DisclosureDesignationHistory__c nestResult = results.get(i);
            DisclosureDesignationHistory__c nestExpect = expectMap.get(nestResult.DisclosureDesignation__c);
            System.assertEquals(nestExpect.DisclosureDesignation__c, nestResult.DisclosureDesignation__c, 'DisclosureDesignation__c');
            System.assertEquals(nestExpect.Counter__c, nestResult.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestResult.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestResult.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestResult.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestResult.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestResult.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestResult.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestResultErrors = nestResult.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestExpectErrors.size(), 'Errors size');
        }

    }

    @isTest
    static void createDisclosureDesignationHistory_succes_multi_case() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignation(account0.Id, 0);  // 開示指定者0
        insert disclosureDesignation0;

        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignation(account1.Id, 1);  // 開示指定者1       
        disclosureDesignation1.Counter__c = 'コール';
        disclosureDesignation1.Status__c = '有効';
        disclosureDesignation1.NameKana__c = '生命';
        disclosureDesignation1.NameKanji__c = null;
        disclosureDesignation1.Relationship__c = null;
        disclosureDesignation1.Birthday__c = null;
        disclosureDesignation1.PhoneNumber__c = null;
        insert disclosureDesignation1;

        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignation(account2.Id, 2);  // 開示指定者2
        disclosureDesignation2.Status__c = '停止';
        insert disclosureDesignation2;

        Set<Id> disclosureDesignationIdSet = new Set<Id>();
        disclosureDesignationIdSet.add(disclosureDesignation0.id);
        disclosureDesignationIdSet.add(disclosureDesignation1.id);
        disclosureDesignationIdSet.add(disclosureDesignation2.id);
        delete [SELECT Id FROM DisclosureDesignationHistory__c WHERE DisclosureDesignation__c IN: disclosureDesignationIdSet];  // 開示指定者履歴は削除

        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.createDisclosureDesignationHistory(disclosureDesignationList);
        Test.stopTest();
        List<DisclosureDesignationHistory__c> results =
        [
            SELECT Id, DisclosureDesignation__c, Counter__c, Status__c, NameKana__c, NameKanji__c, Relationship__c, Birthday__c, PhoneNumber__c
            FROM DisclosureDesignationHistory__c
            WHERE DisclosureDesignation__c IN: disclosureDesignationIdSet
        ];

        // expected value
        DisclosureDesignationHistory__c expect0 = triggerHandlerTest.createDisclosureDesignationHistory(disclosureDesignation0.Id, 0);
        DisclosureDesignationHistory__c expect1 = triggerHandlerTest.createDisclosureDesignationHistory(disclosureDesignation1.Id, 1);
        expect1.Counter__c = 'コール';
        expect1.Status__c = '有効';
        expect1.NameKana__c = '生命';
        expect1.NameKanji__c = null;
        expect1.Relationship__c = null;
        expect1.Birthday__c = null;
        expect1.PhoneNumber__c = null;
        DisclosureDesignationHistory__c expect2 = triggerHandlerTest.createDisclosureDesignationHistory(disclosureDesignation2.Id, 2);
        expect2.Status__c = '停止';
        List<DisclosureDesignationHistory__c> expects = new List<DisclosureDesignationHistory__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);

        // verify
        System.assertEquals(expects.size(), results.size(), 'size');
        Map<Id, DisclosureDesignationHistory__c> expectMap = new Map<Id, DisclosureDesignationHistory__c>();
        for (DisclosureDesignationHistory__c nestExpect : expects) {
            expectMap.put(nestExpect.DisclosureDesignation__c, nestExpect);
        }
        for (Integer i = 0; i < results.size(); i++) {
            DisclosureDesignationHistory__c nestResult = results.get(i);
            DisclosureDesignationHistory__c nestExpect = expectMap.get(nestResult.DisclosureDesignation__c);
            System.assertEquals(nestExpect.DisclosureDesignation__c, nestResult.DisclosureDesignation__c, 'DisclosureDesignation__c');
            System.assertEquals(nestExpect.Counter__c, nestResult.Counter__c, 'Counter__c');
            System.assertEquals(nestExpect.Status__c, nestResult.Status__c, 'Status__c');
            System.assertEquals(nestExpect.NameKana__c, nestResult.NameKana__c, 'NameKana__c');
            System.assertEquals(nestExpect.NameKanji__c, nestResult.NameKanji__c, 'NameKanji__c');
            System.assertEquals(nestExpect.Relationship__c, nestResult.Relationship__c, 'Relationship__c');
            System.assertEquals(nestExpect.Birthday__c, nestResult.Birthday__c, 'Birthday__c');
            System.assertEquals(nestExpect.PhoneNumber__c, nestResult.PhoneNumber__c, 'PhoneNumber__c');
            List<DataBase.Error> nestResultErrors = nestResult.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestExpectErrors.size(), 'Errors size');
        }

    }
     //RIPDEV-170_損保家族登録開始
       @isTest
    static void MultiTestForSection2() {

        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account0 = triggerHandlerTest.createAccount(0);  // 取引先0
        insert account0;
        DisclosureDesignation__c disclosureDesignation0 = triggerHandlerTest.createDisclosureDesignationSec2(account0.Id, 0);  // 取引先0 - 開示指定者0
        Account account1 = triggerHandlerTest.createAccount(1);  // 取引先1
        insert account1;
        DisclosureDesignation__c disclosureDesignation1 = triggerHandlerTest.createDisclosureDesignationSec2(account1.Id, 1);  // 取引先1 - 開示指定者1
        Account account2 = triggerHandlerTest.createAccount(2);  // 取引先2
        insert account2;
        DisclosureDesignation__c disclosureDesignation2 = triggerHandlerTest.createDisclosureDesignationSec2(account2.Id, 2);  // 取引先2 - 開示指定者2
        disclosureDesignation2.Status2__c='停止';
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation0);
        disclosureDesignationList.add(disclosureDesignation1);
        disclosureDesignationList.add(disclosureDesignation2);
        Insert disclosureDesignationList;
        //更新
        disclosureDesignationList[1].Status2__c='停止';
        update disclosureDesignationList;
        
        List<DisclosureDesignation__c> disclosureDesignations= [Select Account__c,Counter2__c,Status2__c,section2__c,NameKana2__c,NameKanji2__c,Relationship2__c ,
                                                                Birthday2__c ,PhoneNumber2__c from DisclosureDesignation__c  where Id =:disclosureDesignationList order by Account__c];
                                   
        // expected value
        DisclosureDesignation__c expect0 = triggerHandlerTest.createDisclosureDesignationSec2(account0.Id, 0);
        DisclosureDesignation__c expect1 = triggerHandlerTest.createDisclosureDesignationByStopStatusSec2(account1.Id, 1);
        DisclosureDesignation__c expect2 = triggerHandlerTest.createDisclosureDesignationByStopStatusSec2(account2.Id, 2);
        List<DisclosureDesignation__c> expects = new List<DisclosureDesignation__c>();
        expects.add(expect0);
        expects.add(expect1);
        expects.add(expect2);
        System.debug(disclosureDesignationList+',@@@'+expects);

        // verify
        System.assertEquals(expects.size(), disclosureDesignationList.size(), 'size');
        
        for (Integer i = 0; i < disclosureDesignationList.size(); i++) {
        
            DisclosureDesignation__c nestDisclosureDesignation = disclosureDesignations.get(i);
            DisclosureDesignation__c nestExpect = expects.get(i);
            
            System.assertEquals(nestExpect.Account__c, nestDisclosureDesignation.Account__c, 'Account__c');
            System.assertEquals(nestExpect.Counter2__c, nestDisclosureDesignation.Counter2__c, 'Counter2__c');
            System.assertEquals(nestExpect.Status2__c, nestDisclosureDesignation.Status2__c, 'Status2__c');
            System.assertEquals(nestExpect.NameKana2__c, nestDisclosureDesignation.NameKana2__c, 'NameKana2__c');
            System.assertEquals(nestExpect.NameKanji2__c, nestDisclosureDesignation.NameKanji2__c, 'NameKanji2__c');
            System.assertEquals(nestExpect.Relationship2__c, nestDisclosureDesignation.Relationship2__c, 'Relationship2__c');
            System.assertEquals(nestExpect.Birthday2__c, nestDisclosureDesignation.Birthday2__c, 'Birthday2__c');
            System.assertEquals(nestExpect.PhoneNumber2__c, nestDisclosureDesignation.PhoneNumber2__c, 'PhoneNumber2__c');
            List<DataBase.Error> nestDisclosureDesignationErrors = nestDisclosureDesignation.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestDisclosureDesignationErrors.size(), 'Errors size');
        }
     }   
     @isTest
    static void createDisclosureDesignationHistory_Section2() {
        //開示指定者履歴の確認
        DisclosureDesignationTriggerHandlerTest triggerHandlerTest = new DisclosureDesignationTriggerHandlerTest();

        // test data
        Account account = triggerHandlerTest.createAccount(0);
        insert account;
        DisclosureDesignation__c disclosureDesignation = triggerHandlerTest.createDisclosureDesignationSec2(account.Id, 0);
        insert disclosureDesignation;
        delete [SELECT Id FROM DisclosureDesignationHistory__c WHERE DisclosureDesignation__c =: disclosureDesignation.id];
        List<DisclosureDesignation__c> disclosureDesignationList = new List<DisclosureDesignation__c>();
        disclosureDesignationList.add(disclosureDesignation);

        // process execute
        Test.startTest();
        DisclosureDesignationTriggerHandler target = new DisclosureDesignationTriggerHandler();
        target.createDisclosureDesignationHistory(disclosureDesignationList);
        Test.stopTest();
        
        Set<Id> disclosureDesignationIdSet = new Set<Id>();
        disclosureDesignationIdSet.add(disclosureDesignation.id);
        List<DisclosureDesignationHistory__c> results =
        [
            SELECT Id, DisclosureDesignation__c, Counter2__c, Status2__c, NameKana2__c, NameKanji2__c, Relationship2__c, Birthday2__c, PhoneNumber2__c
            FROM DisclosureDesignationHistory__c
            WHERE DisclosureDesignation__c IN: disclosureDesignationIdSet
        ];

        // expected value
        DisclosureDesignationHistory__c expect = triggerHandlerTest.createDisclosureDesignationHistorySec2(disclosureDesignation.Id, 0);
        List<DisclosureDesignationHistory__c> expects = new List<DisclosureDesignationHistory__c>();
        expects.add(expect);

        // verify
        System.assertEquals(expects.size(), results.size(), 'size');
        Map<Id, DisclosureDesignationHistory__c> expectMap = new Map<Id, DisclosureDesignationHistory__c>();
        for (DisclosureDesignationHistory__c nestExpect : expects) {
            expectMap.put(nestExpect.DisclosureDesignation__c, nestExpect);
        }
        for (Integer i = 0; i < results.size(); i++) {
            DisclosureDesignationHistory__c nestResult = results.get(i);
            DisclosureDesignationHistory__c nestExpect = expectMap.get(nestResult.DisclosureDesignation__c);
            System.assertEquals(nestExpect.DisclosureDesignation__c, nestResult.DisclosureDesignation__c, 'DisclosureDesignation__c');
            System.assertEquals(nestExpect.Counter2__c, nestResult.Counter2__c, 'Counter2__c');
            System.assertEquals(nestExpect.Status2__c, nestResult.Status2__c, 'Status2__c');
            System.assertEquals(nestExpect.NameKana2__c, nestResult.NameKana2__c, 'NameKana2__c');
            System.assertEquals(nestExpect.NameKanji2__c, nestResult.NameKanji2__c, 'NameKanji2__c');
            System.assertEquals(nestExpect.Relationship2__c, nestResult.Relationship2__c, 'Relationship2__c');
            System.assertEquals(nestExpect.Birthday2__c, nestResult.Birthday2__c, 'Birthday2__c');
            System.assertEquals(nestExpect.PhoneNumber2__c, nestResult.PhoneNumber2__c, 'PhoneNumber2__c');
            List<DataBase.Error> nestResultErrors = nestResult.getErrors();
            List<DataBase.Error> nestExpectErrors = nestExpect.getErrors();
            System.assertEquals(nestExpectErrors.size(), nestExpectErrors.size(), 'Errors size');
        }

    }

      //RIPDEV-170_損保家族登録終了

    private DisclosureDesignation__c createDisclosureDesignation(Id accountId, Integer index) {

        DisclosureDesignation__c disclosureDesignation = new DisclosureDesignation__c(
            Account__c = accountId,
            Counter__c = 'コール',
            Status__c = '有効',
            section__c='生命',
            NameKana__c = 'ラクテン　ハナコ' + index,
            NameKanji__c = '楽天　花子' + index,
            Relationship__c = '配偶者',
            Birthday__c = Date.newInstance(1993, 12, 31),
            PhoneNumber__c = '11122223333'
        );

        return disclosureDesignation;
    }
        private DisclosureDesignation__c createDisclosureDesignationSec2(Id accountId, Integer index) {

        DisclosureDesignation__c disclosureDesignation = new DisclosureDesignation__c(
            Account__c = accountId,
            Counter2__c = 'コール',
            Status2__c = '有効',
            section2__c='生命',
            NameKana2__c = 'ラクテン　ハナコ' + index,
            NameKanji2__c = '楽天　花子' + index,
            Relationship2__c = '配偶者',
            Birthday2__c = Date.newInstance(1993, 12, 31),
            PhoneNumber2__c = '11122223333'
        );

        return disclosureDesignation;
    }

    private DisclosureDesignation__c createDisclosureDesignationByStopStatus(Id accountId, Integer index) {

        DisclosureDesignation__c disclosureDesignation = createDisclosureDesignation(accountId, index);
        disclosureDesignation.Status__c = '停止';
        disclosureDesignation.NameKana__c = null;
        disclosureDesignation.NameKanji__c = null;
        disclosureDesignation.Relationship__c = null;
        disclosureDesignation.Birthday__c = null;
        disclosureDesignation.PhoneNumber__c = null;

        return disclosureDesignation;
    }
        private DisclosureDesignation__c createDisclosureDesignationByStopStatusSec2(Id accountId, Integer index) {

        DisclosureDesignation__c disclosureDesignation = createDisclosureDesignation(accountId, index);
        disclosureDesignation.Status2__c = '停止';
        disclosureDesignation.NameKana2__c = null;
        disclosureDesignation.NameKanji2__c = null;
        disclosureDesignation.Relationship2__c = null;
        disclosureDesignation.Birthday2__c = null;
        disclosureDesignation.PhoneNumber2__c = null;

        return disclosureDesignation;
    }
     private DisclosureDesignation__c createDisclosureDesignationByDeleteStatus(Id accountId, Integer index) {

        DisclosureDesignation__c disclosureDesignation = createDisclosureDesignation(accountId, index);
        disclosureDesignation.section__c=null;
        disclosureDesignation.counter__c=null;
        disclosureDesignation.Status__c = 'レコード削除';
        disclosureDesignation.NameKana__c = null;
        disclosureDesignation.NameKanji__c = null;
        disclosureDesignation.Relationship__c = null;
        disclosureDesignation.Birthday__c = null;
        disclosureDesignation.PhoneNumber__c = null;

        return disclosureDesignation;
    }
        private DisclosureDesignation__c createDisclosureDesignationByDeleteStatusSec2(Id accountId, Integer index) {

        DisclosureDesignation__c disclosureDesignation = createDisclosureDesignationSec2(accountId, index);
        disclosureDesignation.section2__c=null;
        disclosureDesignation.counter2__c=null;   
        disclosureDesignation.Status2__c = 'レコード削除';
        disclosureDesignation.NameKana2__c = null;
        disclosureDesignation.NameKanji2__c = null;
        disclosureDesignation.Relationship2__c = null;
        disclosureDesignation.Birthday2__c = null;
        disclosureDesignation.PhoneNumber2__c = null;

        return disclosureDesignation;
    }

    private DisclosureDesignationHistory__c createDisclosureDesignationHistory(Id disclosureDesignationId, Integer index) {

        DisclosureDesignationHistory__c disclosureDesignationHistory = new DisclosureDesignationHistory__c(
            DisclosureDesignation__c = disclosureDesignationId,
            Counter__c = 'コール',
            Status__c = '有効',
            NameKana__c = 'ラクテン　ハナコ' + index,
            NameKanji__c = '楽天　花子' + index,
            Relationship__c = '配偶者',
            Birthday__c = '1993/12/31',
            PhoneNumber__c = '11122223333'
        );

        return disclosureDesignationHistory;
    }
   private DisclosureDesignationHistory__c createDisclosureDesignationHistorySec2(Id disclosureDesignationId, Integer index) {

        DisclosureDesignationHistory__c disclosureDesignationHistory = new DisclosureDesignationHistory__c(
            DisclosureDesignation__c = disclosureDesignationId,
            Counter2__c = 'コール',
            Status2__c = '有効',
            NameKana2__c = 'ラクテン　ハナコ' + index,
            NameKanji2__c = '楽天　花子' + index,
            Relationship2__c = '配偶者',
            Birthday2__c = '1993/12/31',
            PhoneNumber2__c = '11122223333'
        );

        return disclosureDesignationHistory;
    }
    private Account createAccount(Integer index) {

        List<RecordType> recordTypes =
        [
            SELECT Id, Name
            FROM   RecordType
            WHERE  SobjectType = 'Account' And Name = '個人取引先'
            ORDER BY Name ASC
            LIMIT 1
        ];

        Account account = new Account(
            LastName = '楽天',
            FirstName = '太郎' + index,
            furiganaLast__pc = 'ラクテン',
            furiganaForst__pc = 'タロウ' + index,
            OperationType__c = '割当可',
            RecordTypeId = recordTypes[0].Id,
            PersonHomePhone = '333-4444-5555'
        );

        return account;
    }

}