@isTest
public class ContractSearchCustomControllerTest
{
    @isTest
    static void ContractSearchCustomControllerTest_getLifeContractSeiho()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert controllerTest.createLifeContract(account.Id,'1');

        Test.startTest();
        ContractSearchCustomController.getLifeContract('1234567', null, null, 'test name', null, 'term', null, 'ﾗｸﾃﾝ', '楽天', null, null, null, null, '楽天', null, null, null, null, null);

        Test.stopTest();
    }
    
    @isTest
    static void ContractSearchCustomControllerTest_getLifeContractKyosai()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert controllerTest.createLifeContract(account.Id,'2');

        Test.startTest();
        ContractSearchCustomController.getLifeContract('876901', null, null, 'test name', null, 'term', null, 'ﾗｸﾃﾝ', '楽天', null, null, null, null, '楽天', null, null, null, null, null);

        Test.stopTest();
    }

    @isTest
    static void ContractSearchCustomControllerTest_getDamageContract()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert controllerTest.createDamageContract(account.Id);
        insert controllerTest.createLittleContract(account.Id);

        Test.startTest();
        ContractSearchCustomController.getDamageContract('2222222', null, null, 'test damage insurance', null, 'test damage contract term', null, 'ﾗｸﾃﾝ', '楽天', null, null, null, null, '楽天', null, null, '111-2222', null, null);

        Test.stopTest();
    }

    @isTest
    static void ContractSearchCustomControllerTest_getLittleContract()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert controllerTest.createLittleContract(account.Id);

        Test.startTest();
        ContractSearchCustomController.getLittleContract('3333333', null, null, 'test little insurance name', null, 'little period', null, null, '楽天', null, null, null, null, '楽天', null, null, null, null, null);

        Test.stopTest();
    }

    @isTest
    static void ContractSearchCustomControllerTest_getSearchWhereLifeContract()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        ContractSearchCustomController.searchValue sv = new ContractSearchCustomController.searchValue();
        sv.insuraPolicyNo = 'test';
        sv.applicationNumber = 'test';
        sv.insuraType = 'test';
        sv.name = 'test';
        sv.status = 'test';
        sv.contractTerm = 'test';
        sv.CSID = 'test';
        sv.contractorNameKana = 'test';
        sv.contractorNameKanji = 'test';
        sv.subscriberDateOfBirth = 'test';
        sv.phone = 'test';
        sv.postalCode = 'test';
        sv.insuredNameKana = 'test';
        sv.insuredNameKanji = 'test';
        sv.insuredBirthdate = 'test';
        sv.insuredBody = 'test';
        sv.carNo = 'test';
        sv.agencyCode = 'test';
        sv.agency = 'test';

        Test.startTest();
        ContractSearchCustomController.getSearchWhere('L', sv);
        Test.stopTest();
    }
    
    @isTest
    static void ContractSearchCustomControllerTest_getSearchWhereDamageContract()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        ContractSearchCustomController.searchValue sv = new ContractSearchCustomController.searchValue();
        sv.insuraPolicyNo = 'test';
        sv.applicationNumber = 'test';
        sv.insuraType = 'test';
        sv.name = 'test';
        sv.status = 'test';
        sv.contractTerm = 'test';
        sv.CSID = 'test';
        sv.contractorNameKana = 'test';
        sv.contractorNameKanji = 'test';
        sv.subscriberDateOfBirth = 'test';
        sv.phone = 'test';
        sv.postalCode = 'test';
        sv.insuredNameKana = 'test';
        sv.insuredNameKanji = 'test';
        sv.insuredBirthdate = 'test';
        sv.insuredBody = 'test';
        sv.carNo = 'test';
        sv.agencyCode = 'test';
        sv.agency = 'test';

        Test.startTest();
        ContractSearchCustomController.getSearchWhere('G', sv);
        Test.stopTest();
    }
    
    @isTest
    static void ContractSearchCustomControllerTest_getSearchWhereLittleContract()
    {
        ContractSearchCustomControllerTest controllerTest = new ContractSearchCustomControllerTest();
        ContractSearchCustomController.searchValue sv = new ContractSearchCustomController.searchValue();
        sv.insuraPolicyNo = 'test';
        sv.applicationNumber = 'test';
        sv.insuraType = 'test';
        sv.name = 'test';
        sv.status = 'test';
        sv.contractTerm = 'test';
        sv.CSID = 'test';
        sv.contractorNameKana = 'test';
        sv.contractorNameKanji = 'test';
        sv.subscriberDateOfBirth = 'test';
        sv.phone = 'test';
        sv.postalCode = 'test';
        sv.insuredNameKana = 'test';
        sv.insuredNameKanji = 'test';
        sv.insuredBirthdate = 'test';
        sv.insuredBody = 'test';
        sv.carNo = 'test';
        sv.agencyCode = 'test';
        sv.agency = 'test';

        Test.startTest();
        ContractSearchCustomController.getSearchWhere('S', sv);
        Test.stopTest();
    }

    private account createAccount(){
        List<RecordType> recordTypes = [SELECT Id, Name 
                                        FROM   RecordType 
                                        WHERE  SobjectType = 'Account' 
                                        And    Name = '個人取引先' 
                                        ORDER BY Name ASC LIMIT 50];
        return new Account(
            LastName='個人',
            FirstName='取引先',
            RecordTypeId=recordTypes[0].Id
        );
    }

    private LifeContract__c createLifeContract(Id accountId,String type){
        return new LifeContract__c(
            Name = 'test name',
            POL_NUM__c = '1234567',
            MUTUAL_AID_NUM__c = '876901',
            PRODUCT_NAME__c = 'test product name',
            KANJI_CONTROR_NAME__c = '楽天　一郎',
            INSR_PERIOD__c = 'term',
            CONTRACT_DATE__c = '20190101',
            KANJI_INSURED_NAME__c = '楽天　一郎',
            Phone__c = '111-2222-3333',
            BENE_AMOUNT__c = '3000000',
            MONTHLY_PRM__c = '2000',
            Status__c = '01',
            LIFE_MUTUAL_TYPE__c = type,
            KANA_CONTROR_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ',
            BENEFIT_RECIPIENT__c = '楽天　二郎',
            AccountId__c = accountId
        );
    }

    private DamageContract__c createDamageContract(Id accountId){
        return new DamageContract__c(
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
            AccountId__c = accountId);
    }

    private LittleContract__c createLittleContract(Id accountId){
        return new LittleContract__c(
            InsuranceType__c = 'test little insurance',
            /*** 本番00090 FIX START ***/
            //SubscriberStatus__c='オープン',
            SubscriberStatus__c='10',
            /*** 本番00090 END START ***/
            SubscriberManageNo__c = '3333333',
            Name = 'test little insurance name',
            SubscriberNameKanji__c = '楽天　少短一郎',
            InsurancePeriod__c = 'little period',
            InsuranceCommencement__c = '2019/01/01',
            InsuredKanji__c = '楽天　少短一郎',
            InsuranceTarget_1__c = 'pet name',
            SubscriberTel__c = '333-4444-5555',
            InsurancePremium__c = '3000',
            SubscriberAddressKanji__c = '東京都世田谷区玉川',
            CustomerNumber__c = '1',
            petAge__c = '5',
            AccountId__c = accountId
        );
    }
}