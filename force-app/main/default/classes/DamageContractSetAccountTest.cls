@isTest
public with sharing class DamageContractSetAccountTest {

    private static Account infoOfAccount;
    private static DamageContract__c infoOfDamageContract;

    static void dataCreateAccount(){
        Id accountRecordtypeId = Schema.SobjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
        infoOfAccount = new Account(
            LastName='個人',
            FirstName='取引先',
            furiganaLast__pc = 'Firigana',
            furiganaForst__pc = 'Forst',
            OperationType__c = '割当可',
            RecordTypeId = accountRecordtypeId,
            ContractorPhoneFax__pc = ''
        );
    }

    static void dataCreateDamageContract(Account infoOfAccount){

        infoOfDamageContract = new DamageContract__c(
            InsuraPolicyNo__c = '2222222',
            Name = 'test damage insurance',
            ContractTerm__c = 'test damage contract term',
            ContractStartDate__c = '20190101',
            InsuredPerson__c = '楽天　損保一郎',
            CarNo__c = '111-2222',
            SubjectArea__c = '東京都',
            InsuredPhoneNum__c = '222-3333-4444',
            InsuranceFee__c = '2500',
            ContractStatus__c = '新規',
            TorihikisakiKana__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ',
            PaymentType__c = '年払い',
            PledgeOrNot__c = '有',
            AccountId__c = infoOfAccount.Id);
    }

    /*
     * 取引先の電話番号をセットする処理の通常ケース
    */
    @isTest
    static void testNormal() {
        Test.startTest();
        dataCreateAccount();
        insert infoOfAccount;
        dataCreateDamageContract(infoOfAccount);
        System.debug('is insert');
        insert infoOfDamageContract;
        infoOfDamageContract.ContractorPhoneFax__c = '111-2222-3333';
        System.debug('is update');
        update infoOfDamageContract;
        Test.stopTest();

        Contact infoOfContact = [SELECT Id,ContractorPhoneFax__c FROM Contact WHERE AccountId =: infoOfAccount.Id];
        Assert.areEqual('111-2222-3333', infoOfContact.ContractorPhoneFax__c);
        Account infoOfAcc = [SELECT Id,ContractorPhoneFax__pc FROM Account WHERE Id =: infoOfAccount.Id];
        Assert.areEqual('111-2222-3333', infoOfAcc.ContractorPhoneFax__pc);
    }

    /*
     * 取引先の電話番号をセットする処理の臨界値テスト
    */
    @isTest
    static void testMaxLength() {
        String phoneNumber = 'iphone:111-2222-3333';//max:20桁
        Test.startTest();
        dataCreateAccount();
        insert infoOfAccount;
        dataCreateDamageContract(infoOfAccount);
        System.debug('is insert');
        insert infoOfDamageContract;
        infoOfDamageContract.ContractorPhoneFax__c = phoneNumber;
        System.debug('is update');
        update infoOfDamageContract;
        

        Contact infoOfContact = [SELECT Id,ContractorPhoneFax__c FROM Contact WHERE AccountId =: infoOfAccount.Id];
        Assert.areEqual(phoneNumber, infoOfContact.ContractorPhoneFax__c);
        Account infoOfAcc = [SELECT Id,ContractorPhoneFax__pc FROM Account WHERE Id =: infoOfAccount.Id];
        Assert.areEqual(phoneNumber, infoOfAcc.ContractorPhoneFax__pc);

        phoneNumber += phoneNumber + 'x';
        try {
            infoOfDamageContract.ContractorPhoneFax__c = phoneNumber;
            update infoOfDamageContract;
            System.debug(phoneNumber);

        } catch (Exception e) {
            System.debug('over max length');
            System.debug(e);
        }

        Test.stopTest();
    }

    /*
     * 更新時損保契約情報の関連取引先が別にある
    */
    @isTest
    static void testAccountChanged() {
        String phoneNumber = '111-2222-3333';
        Test.startTest();
        dataCreateAccount();
        insert infoOfAccount;
        dataCreateDamageContract(infoOfAccount);
        System.debug('is insert');
        insert infoOfDamageContract;
        Account clonedAcc = infoOfAccount.clone();
        insert clonedAcc;
        infoOfDamageContract.ContractorPhoneFax__c = phoneNumber;
        infoOfDamageContract.AccountId__c = clonedAcc.Id;
        System.debug('is update');
        update infoOfDamageContract;
        
        Test.stopTest();

        Contact infoOfContact = [SELECT Id,ContractorPhoneFax__c FROM Contact WHERE AccountId =: infoOfAccount.Id];
        Assert.isTrue(String.isBlank(infoOfContact.ContractorPhoneFax__c));
        
    }

    /*
     * 更新時損保契約情報の携帯電話情報が空
    */
    @isTest
    static void testDCNullPhoneInfo() {
        String phoneNumber = '111-2222-3333';
        Test.startTest();
        dataCreateAccount();
        insert infoOfAccount;
        dataCreateDamageContract(infoOfAccount);
        System.debug('is insert');
        insert infoOfDamageContract;
        infoOfDamageContract.ContractorPhoneFax__c = phoneNumber;
        System.debug('is update1');
        update infoOfDamageContract;
        infoOfDamageContract.ContractorPhoneFax__c = '';
        System.debug('is update2');
        update infoOfDamageContract;
        
        Test.stopTest();

        Contact infoOfContact = [SELECT Id,ContractorPhoneFax__c FROM Contact WHERE AccountId =: infoOfAccount.Id];
        Assert.areEqual(phoneNumber, infoOfContact.ContractorPhoneFax__c);
        
    }

    /*
     * 取引先に既に存在している値が損保契約情報の値と同じになっている
    */
    @isTest
    static void testSamePhoneInfo() {
        String phoneNumber = '111-2222-3333';
        Test.startTest();
        dataCreateAccount();
        infoOfAccount.ContractorPhoneFax__pc = phoneNumber;
        insert infoOfAccount;
        dataCreateDamageContract(infoOfAccount);
        System.debug('is insert');
        insert infoOfDamageContract;
        infoOfDamageContract.ContractorPhoneFax__c = phoneNumber;
        System.debug('is update1');
        update infoOfDamageContract;
        
        Test.stopTest();

        Contact infoOfContact = [SELECT Id,ContractorPhoneFax__c FROM Contact WHERE AccountId =: infoOfAccount.Id];
        Assert.areEqual(phoneNumber, infoOfContact.ContractorPhoneFax__c);
        
    }

    /*
     * 取引先の電話番号をセットする処理の複数件テスト
    */
    @isTest
    static void testLargeData() {
        String phoneNumber = '111-2222-3333';
        Integer maxnum = 200;
        List<Account> accList = new List<Account>();
        List<DamageContract__c> DCList = new List<DamageContract__c>();

        Test.startTest();
        for (Integer num = 0; num < maxnum; num++) {
            dataCreateAccount();
            infoOfAccount.FirstName += num;
            accList.add(infoOfAccount);
        }
        insert accList;
        
        for (Account tmpAcc : accList) {
            dataCreateDamageContract(tmpAcc);
            DCList.add(infoOfDamageContract);
            System.debug('is insert');
        }
        insert DCList;

        Integer strNum = 0;
        // Acc.Id => DamageContract__c
        Map<Id, DamageContract__c> accIdToDCMap = new Map<Id, DamageContract__c>();
        for (DamageContract__c tmpDC : DCList) {
            tmpDC.ContractorPhoneFax__c = phoneNumber + strNum;
            strNum++;
            accIdToDCMap.put(tmpDC.AccountId__c,tmpDC);
        }
        
        System.debug('is update');
        update DCList;
        Test.stopTest();

        Map<Id, Account> accMap = new Map<Id, Account>(accList);

        List<Contact> contactList = [SELECT Id,ContractorPhoneFax__c, AccountId FROM Contact WHERE AccountId IN: accMap.keySet()];
        for (Contact tmpCon : contactList) {
            Assert.areEqual(tmpCon.ContractorPhoneFax__c, accIdToDCMap.get(tmpCon.AccountId).ContractorPhoneFax__c);
        }
        
    }
}