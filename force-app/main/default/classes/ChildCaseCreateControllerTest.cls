@isTest
public class ChildCaseCreateControllerTest
{
    //@testSetup
    //static void setup() {
    //
    //    List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' And Name = '個人取引先' ORDER BY Name ASC LIMIT 50];
    //    // 取引先
    //    Account account = new Account(
    //        LastName='個人',
    //        FirstName='取引先',
    //        RecordTypeId=recordTypes[0].Id
    //    );
    //    insert account;
    //    // 取引先登録で自動作成された取引先責任者取得
    //    Contact contact = [SELECT Id FROM Contact LIMIT 1] ;
    //    // 遷移元ケースオブジェクト作成
    //    // ケース
    //    Case caseObj = new Case(
    //        Origin='電話',
    //        Status='オープン',
    //        class__c='共通異動',
    //        type__c='住所変更',
    //        ContactId=contact.Id
    //    );
    //    insert caseObj;
    //}
    //

    @isTest
    static void ChildCaseCreateControllerTest_execute1()
    {
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        Case cs = controllerTest.createCase();
        cs.accountId = account.Id;
        insert cs;
        // 遷移元ケースオブジェクト取得
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        // 生保契約
        LifeContract__c lifeCon = new LifeContract__c(
            Name='生保契約',
            POL_NUM__c='111111',
            Status__c='オープン',
            KANJI_INSURED_NAME__c='被保険者1',
            AccountId__c=account.Id
        );
        insert lifeCon;
    
        List<ChildCaseCreateController.DTO> dtos = new List<ChildCaseCreateController.DTO>();
        ChildCaseCreateController.DTO d = new ChildCaseCreateController.DTO();
        d.checked = true;
        d.contractId = lifeCon.Id;
        d.name = lifeCon.Name;
        d.policyNumber = lifeCon.POL_NUM__c;
        d.insuranceCategory = '生保';
        d.status = lifeCon.Status__c;
        d.BillingAddress = lifeCon.StreetAddress__c;
        d.insured = lifeCon.KANJI_INSURED_NAME__c;
        dtos.add(d);
    
        Test.startTest();
    
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
    
        controller.dtos = dtos;
        controller.caseId = caseObj.Id;
        controller.execute();

        Case result = [SELECT Id, lifeContractReference__c FROM Case WHERE Id != :caseObj.Id LIMIT 1];
        System.assertEquals(lifeCon.Id, result.lifeContractReference__c);
    
        Test.stopTest();
    }

    @isTest
    static  void executeTest_life_insuranceClaims()
    {
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        Case cs = controllerTest.createCase();
        cs.accountId = account.Id;
        RecordType recType = null;
        for(RecordType rt : [SELECT Id, DeveloperName 
                         FROM   RecordType 
                         WHERE  SobjectType = 'Case' And DeveloperName = 'InsuranceClaims' ORDER BY Name ASC]) {
            recType = rt;
        }
        cs.RecordTypeId = recType.Id;
        insert cs;
        // 遷移元ケースオブジェクト取得
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        // 生保契約
        LifeContract__c lifeCon = new LifeContract__c(
            Name='生保契約',
            POL_NUM__c='111111',
            Status__c='オープン',
            KANJI_INSURED_NAME__c='被保険者1',
            AccountId__c=account.Id
        );
        insert lifeCon;
    
        List<ChildCaseCreateController.DTO> dtos = new List<ChildCaseCreateController.DTO>();
        ChildCaseCreateController.DTO d = new ChildCaseCreateController.DTO();
        d.checked = true;
        d.contractId = lifeCon.Id;
        d.name = lifeCon.Name;
        d.policyNumber = lifeCon.POL_NUM__c;
        d.insuranceCategory = '生保';
        d.status = lifeCon.Status__c;
        d.BillingAddress = lifeCon.StreetAddress__c;
        d.insured = lifeCon.KANJI_INSURED_NAME__c;
        dtos.add(d);
    
        Test.startTest();
    
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
    
        controller.dtos = dtos;
        controller.caseId = caseObj.Id;
        controller.execute();
        Case result = [SELECT Id, lifeContractReference__c FROM Case WHERE Id != :caseObj.Id LIMIT 1];
        System.assertEquals(lifeCon.Id, result.lifeContractReference__c);
    
        Test.stopTest();
    }

    @isTest
    static  void executeTest_life_reduc()
    {
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        Case cs = controllerTest.createCase();
        cs.accountId = account.Id;
        RecordType recType = null;
        for(RecordType rt : [SELECT Id, DeveloperName 
                         FROM   RecordType 
                         WHERE  SobjectType = 'Case' And DeveloperName = 'Reduc' ORDER BY Name ASC]) {
            recType = rt;
        }
        cs.RecordTypeId = recType.Id;
        insert cs;
        // 遷移元ケースオブジェクト取得
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        // 生保契約
        LifeContract__c lifeCon = new LifeContract__c(
            Name='生保契約',
            POL_NUM__c='111111',
            Status__c='オープン',
            KANJI_INSURED_NAME__c='被保険者1',
            AccountId__c=account.Id
        );
        insert lifeCon;
    
        List<ChildCaseCreateController.DTO> dtos = new List<ChildCaseCreateController.DTO>();
        ChildCaseCreateController.DTO d = new ChildCaseCreateController.DTO();
        d.checked = true;
        d.contractId = lifeCon.Id;
        d.name = lifeCon.Name;
        d.policyNumber = lifeCon.POL_NUM__c;
        d.insuranceCategory = '生保';
        d.status = lifeCon.Status__c;
        d.BillingAddress = lifeCon.StreetAddress__c;
        d.insured = lifeCon.KANJI_INSURED_NAME__c;
        dtos.add(d);
    
        Test.startTest();
    
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
    
        controller.dtos = dtos;
        controller.caseId = caseObj.Id;
        controller.execute();
        Case result = [SELECT Id, lifeContractReference__c FROM Case WHERE Id != :caseObj.Id LIMIT 1];
        System.assertEquals(lifeCon.Id, result.lifeContractReference__c);
    
        Test.stopTest();
    }

    @isTest
    static  void executeTest_life_surname()
    {
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        Case cs = controllerTest.createCase();
        cs.accountId = account.Id;
        RecordType recType = null;
        for(RecordType rt : [SELECT Id, DeveloperName 
                         FROM   RecordType 
                         WHERE  SobjectType = 'Case' 
                         And    DeveloperName = 'Surname' ORDER BY Name ASC]) {
            recType = rt;
        }
        cs.RecordTypeId = recType.Id;
        insert cs;
        // 遷移元ケースオブジェクト取得
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
        // 生保契約
        LifeContract__c lifeCon = new LifeContract__c(
            Name='生保契約',
            POL_NUM__c='111111',
            Status__c='オープン',
            KANJI_INSURED_NAME__c='被保険者1',
            AccountId__c=account.Id
        );
        insert lifeCon;
    
        List<ChildCaseCreateController.DTO> dtos = new List<ChildCaseCreateController.DTO>();
        ChildCaseCreateController.DTO d = new ChildCaseCreateController.DTO();
        d.checked = true;
        d.contractId = lifeCon.Id;
        d.name = lifeCon.Name;
        d.policyNumber = lifeCon.POL_NUM__c;
        d.insuranceCategory = '生保';
        d.status = lifeCon.Status__c;
        d.BillingAddress = lifeCon.StreetAddress__c;
        d.insured = lifeCon.KANJI_INSURED_NAME__c;
        dtos.add(d);
    
        Test.startTest();
    
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
    
        controller.dtos = dtos;
        controller.caseId = caseObj.Id;
        controller.execute();
        Case result = [SELECT Id, lifeContractReference__c FROM Case WHERE Id != :caseObj.Id LIMIT 1];
        System.assertEquals(lifeCon.Id, result.lifeContractReference__c);
    
        Test.stopTest();
    }

    @isTest
    static void ChildCaseCreateControllerTest_execute2()
    {
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];

        // 遷移元ケースオブジェクト取得
        Case cs = controllerTest.createCase();
        cs.accountId = account.Id;
        insert cs;
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
    
        // 損保契約
        DamageContract__c damageCon = new DamageContract__c(
            Name='損保契約',
            InsuraPolicyNo__c='222222',
            ContractStatus__c='オープン',
            InsuredPerson__c='被保険者2',
            AgencyCode__c='test01,test02',
            AccountId__c=account.Id
        );
        insert damageCon;
    
        List<ChildCaseCreateController.DTO> dtos = new List<ChildCaseCreateController.DTO>();
        ChildCaseCreateController.DTO d = new ChildCaseCreateController.DTO();
        d.checked = true;
        d.contractId = damageCon.Id;
        d.name = damageCon.Name;
        d.policyNumber = damageCon.InsuraPolicyNo__c;
        d.insuranceCategory = '損保';
        d.status = damageCon.ContractStatus__c;
        d.BillingAddress = damageCon.StreetAddress__c;
        d.insured = damageCon.InsuredPerson__c;
        dtos.add(d);
    
        Test.startTest();
    
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
    
        controller.dtos = dtos;
        controller.caseId = caseObj.Id;
        controller.execute();
        Case result = [SELECT Id, damageContractReference__c FROM Case WHERE Id != :caseObj.Id LIMIT 1];
        System.assertEquals(damageCon.Id, result.damageContractReference__c);
    
        Test.stopTest();
    }
    
    @isTest
    static void ChildCaseCreateControllerTest_execute3()
    {
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        insert controllerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];

        // 遷移元ケースオブジェクト取得
        Case cs = controllerTest.createCase();
        cs.accountId = account.Id;
        insert cs;
        Case caseObj = [SELECT Id FROM Case LIMIT 1];
    
        // 少短契約
        LittleContract__c littleCon = new LittleContract__c(
            Name='少短契約',
            SubscriberManageNo__c='333333',
            SubscriberStatus__c='オープン',
            InsuredKanji__c='被保険者3',
            AccountId__c=account.Id
        );
        insert littleCon;
    
        List<ChildCaseCreateController.DTO> dtos = new List<ChildCaseCreateController.DTO>();
        ChildCaseCreateController.DTO d = new ChildCaseCreateController.DTO();
        d.checked = true;
        d.contractId = littleCon.Id;
        d.name = littleCon.Name;
        d.policyNumber = littleCon.SubscriberManageNo__c;
        d.insuranceCategory = '少短';
        d.status = littleCon.SubscriberStatus__c;
        d.insured = littleCon.InsuredKanji__c;
        dtos.add(d);
    
        Test.startTest();
    
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
    
        controller.dtos = dtos;
        controller.caseId = caseObj.Id;
        controller.execute();
    
        Case result = [SELECT Id, littleContractReference__c FROM Case WHERE Id != :caseObj.Id LIMIT 1];
        System.assertEquals(littleCon.Id, result.littleContractReference__c);

        Test.stopTest();
    }

    public ChildCaseCreateControllerTest(){}
    @isTest
    public static void viewTest_no_case_found(){
        Case caseObj = new Case();
        Test.startTest();
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
        controller.view();
        System.assertEquals(0, controller.dtos.size());
        Test.StopTest();
    }

    @isTest
    public static void viewTest_no_contactId(){
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        // 取引先
        Account acc = controllerTest.createAccount();
        insert acc;
        // 取引先登録で自動作成された取引先責任者取得
        Contact contact = [SELECT Id FROM Contact LIMIT 1] ;
        // 遷移元ケースオブジェクト作成
        // ケース
        Case caseObj = controllerTest.createCase();
        insert caseObj;
        controllerTest.setIdParam(caseObj.Id);
        Test.startTest();
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
        controller.view();
        System.assertEquals(0, controller.dtos.size());
        Test.StopTest();
    }

    @isTest
    public static void viewTest_no_contract(){
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        // 取引先
        Account acc = controllerTest.createAccount();
        insert acc;
        // 取引先登録で自動作成された取引先責任者取得
        Contact contact = [SELECT Id FROM Contact LIMIT 1] ;
        // 遷移元ケースオブジェクト作成
        // ケース
        Case caseObj = controllerTest.createCase();
        caseObj.contactId = contact.Id;
        insert caseObj;
        controllerTest.setIdParam(caseObj.Id);
        Test.startTest();
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
        controller.view();
        System.assertEquals(0, controller.dtos.size());
        Test.StopTest();
    }

    @isTest
    public static void viewTest_single_contract(){
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        // 取引先
        Account acc = controllerTest.createAccount();
        insert acc;
        // 取引先登録で自動作成された取引先責任者取得
        Contact contact = [SELECT Id FROM Contact LIMIT 1] ;
        // ケース
        Case caseObj = controllerTest.createCase();
        caseObj.contactId = contact.Id;
        insert caseObj;

        LifeContract__c life = controllerTest.createLifeContract(acc.Id);
        insert life;
        DamageContract__c damage = controllerTest.createDamageContract(acc.Id);
        insert damage;
        LittleContract__c little = controllerTest.createLittleContract(acc.Id);
        insert little;

        controllerTest.setIdParam(caseObj.Id);

        Test.startTest();
        // オブジェクトを渡してインスタンス化する
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
        controller.view();
        System.assertEquals(3, controller.dtos.size());
        Test.StopTest();
    }

    @isTest
    public static void property_test(){
        ChildCaseCreateControllerTest controllerTest = new ChildCaseCreateControllerTest();
        Case caseObj = controllerTest.createCase();
        insert caseObj;
        ApexPages.StandardController stdController = new ApexPages.StandardController (caseObj);
        ChildCaseCreateController controller = new ChildCaseCreateController(stdController);
        List<SelectOption> option = controller.CtrlPickListOptions;
        option = controller.DependentPickListOptions;
        option = controller.QueueListOptions;
    }
    
    private void setIdParam(Id id){
        PageReference pageRef = Page.ChildCaseCreateList;
        pageRef.getParameters().put('id', id); 
        Test.setCurrentPage(pageRef);
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
    private Case createCase(){
        return new Case(
            Origin='電話',
            Status='オープン',
            class__c='対応履歴',
            type__c='対応履歴'
        );
    }

    private LifeContract__c createLifeContract(Id accountId){
        return new LifeContract__c(
            Name = 'test name',
            POL_NUM__c = '1234567',
            PRODUCT_NAME__c = 'test product name',
            KANJI_CONTROR_NAME__c = '楽天　一郎',
            INSR_PERIOD__c = 'term',
            CONTRACT_DATE__c = '20190523',
            KANJI_INSURED_NAME__c = '楽天　一郎',
            Phone__c = '111-2222-3333',
            BENE_AMOUNT__c = '3000000',
            MONTHLY_PRM__c = '2000',
            Status__c = '01',
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
            AgencyCode__c = 'test01,test02',
            AccountId__c = accountId);
    }

    private LittleContract__c createLittleContract(Id accountId){
        return new LittleContract__c(
            InsuranceType__c = 'test little insurance',
            SubscriberStatus__c = '新規',
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