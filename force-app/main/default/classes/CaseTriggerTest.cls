@isTest
public class CaseTriggerTest
{
    @isTest
    static void CaseTriggerTest_insert()
    {
        CaseTriggerTest triggerTest = new CaseTriggerTest();

        insert triggerTest.createAccount();

        Test.startTest();

        insert  triggerTest.createCase();

        Test.stopTest();
    }
    
    @isTest
    static void CaseTriggerTest_insert_cc()
    {
        CaseTriggerTest triggerTest = new CaseTriggerTest();

        insert triggerTest.createAccount();
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert triggerTest.createLifeContract(account.Id);
        LifeContract__c lc = [SELECT Id FROM LifeContract__c LIMIT 1];

        Test.startTest();

        insert  triggerTest.createCase_cc(lc.Id);

        Test.stopTest();
    }

    @isTest
    static void CaseTriggerTest_update()
    {
        CaseTriggerTest triggerTest = new CaseTriggerTest();

        insert  triggerTest.createAccount();
        insert  triggerTest.createCase();
        Case cs = [SELECT Id, Status FROM Case LIMIT 1];
        cs.Status = 'クローズ';

        Test.startTest();

        update cs;

        Test.stopTest();
    }

    @isTest
    static void testCaseTriggerHandle(){
        List<Case> oldList = createCaseList();
        for(Case c : oldList){
            c.Status = 'オーペン';
        }
        insert oldList;
        
        List<Case> newList = createCaseList();
        Integer i= 0 ;
        for(Case c : newList){
            c.Id = oldList[i].Id;
            c.Status = 'CC完了';
            c.HasNGAgency__c = true;
            i++;
        }
        Map<Id, Case> oldMap = new Map<Id, Case>();
        for(Case c : oldList){
            oldMap.put(c.Id, c);
        }
        
        CaseTriggerHandler triggerHandle = new CaseTriggerHandler();
        triggerHandle.setCaseRecordType(oldList);
        triggerHandle.setCaseOwner(newList, oldMap);
        triggerHandle.setNGAgencyGroup(newList);
        
    }

    @isTest
    static void testCaseSetOwnerSalesCase(){
        Case oldCase = new Case(Status = 'オープン');
        insert oldCase;
        Map<Id, Case> oldMap = new Map<Id, Case>{oldCase.Id => oldCase};
        
        //Group 取得
        Set<Id> groupIdSet = new Set<Id>();
        for(QueueSobject que : [SELECT Id, QueueId FROM QueueSobject WHERE SobjectType = 'Case']) {
            groupIdSet.add(que.QueueId);
        }
        Map<String, Group> caseGroupMap = new Map<String, Group>();
        for(Group gr : [SELECT ID, name, DeveloperName FRom Group WHERE ID IN :groupIdSet]){
            caseGroupMap.put(gr.DeveloperName,gr);
        }
        
        CaseTriggerHandler triggerHandle = new CaseTriggerHandler();


        Map<String, Case> newCaseMap = new Map<String, Case>{
            'DNP' => createCase('セールス専用ケース', '生命_コール資料請求', 'CC完了', oldCase.Id),
            'MiddleOfficeSonpo' => createCase('セールス専用ケース', '損保_ミドル連携', 'CC完了', oldCase.Id),
            'MatsuyamaLittle'  => createCase('セールス専用ケース', '少短_コール資料請求', 'CC完了', oldCase.Id),
            'SalesLife'    => createCase('セールス専用ケース', '生命_対面誘導（生命営推本部）', 'CC完了', oldCase.Id),
            'DNP'  => createCase('セールス専用ケース', '生命_WEB資料請求', 'CC完了', oldCase.Id),
            'MatsuyamaLittle'   => createCase('セールス専用ケース', '少短_WEB資料請求', 'CC完了', oldCase.Id),
            'CallCenter'  => createCase('セールス専用ケース', '信書回収', 'CC完了', oldCase.Id),
            'compareTeam' => createCase('セールス専用ケース', '生命・少短_比較チーム連携', 'CC完了', oldCase.Id)
        };

        triggerHandle.setCaseOwner(newCaseMap.values(), oldMap);
        System.assertEquals(newCaseMap.get('DNP').ownerId, caseGroupMap.get('DNP').Id);
        System.assertEquals(newCaseMap.get('MiddleOfficeSonpo').ownerId, caseGroupMap.get('MiddleOfficeSonpo').Id);
        System.assertEquals(newCaseMap.get('MatsuyamaLittle').ownerId,  caseGroupMap.get('MatsuyamaLittle').Id);
        System.assertEquals(newCaseMap.get('SalesLife').ownerId,    caseGroupMap.get('SalesLife').Id);
        System.assertEquals(newCaseMap.get('DNP').ownerId,  caseGroupMap.get('DNP').Id);
        System.assertEquals(newCaseMap.get('MatsuyamaLittle').ownerId,   caseGroupMap.get('MatsuyamaLittle').Id);
        System.assertEquals(newCaseMap.get('CallCenter').ownerId,  caseGroupMap.get('CallCenter').Id);
        System.assertEquals(newCaseMap.get('compareTeam').ownerId, UserInfo.getUserId());

        for( String key : newCaseMap.keySet() ) {
            newCaseMap.get(key).ownerId = userInfo.getUserId();
        }
        oldCase.status = 'CC完了';
        triggerHandle.setCaseOwner(newCaseMap.values(), oldMap);
        System.assertEquals(newCaseMap.get('DNP').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('MiddleOfficeSonpo').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('MatsuyamaLittle').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('SalesLife').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('DNP').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('MatsuyamaLittle').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('CallCenter').ownerId, UserInfo.getUserId());
        System.assertEquals(newCaseMap.get('compareTeam').ownerId, UserInfo.getUserId());

    }

    private static Case createCase(String className, String type, String status, Id id){
        return new Case(
            Id = id,
            class__c = className,
            type__c = type,
            Status = status,
            OwnerId = UserInfo.getUserId()
        );
    }

    private static List<Case> createCaseList(){
        Account acc = new Account();
        acc.LastName = 'test';
        acc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount'][0].Id;
        insert acc;
        
        DamageContract__c dc = new DamageContract__c();
        dc.AgencyCode__c = 'test';
        dc.AccountId__c = acc.Id;
        insert dc;
        
        LifeContract__c lc = new LifeContract__c();
        lc.AccountId__c = acc.Id;
        insert lc;
        
        LittleContract__c lic = new LittleContract__c();
        lic.AccountId__c = acc.Id;
        insert lic;

        List<Case> l = new List<Case>();
        l.add(new Case(class__c='対応履歴',type__c='対応履歴', damageContractReference__c = dc.id));
        l.add(new Case(class__c='共通異動',type__c='住所変更', damageContractReference__c = dc.id));
        l.add(new Case(class__c='共通異動',type__c='電話番号変更', damageContractReference__c = dc.id));
        l.add(new Case(class__c='共通異動',type__c='改姓（名義変更）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='共通異動',type__c='メールアドレス変更', damageContractReference__c = dc.id));
        l.add(new Case(class__c='共通異動',type__c='住所変更', lifeContractReference__c = lc.id));
        l.add(new Case(class__c='共通異動',type__c='改姓（名義変更）', lifeContractReference__c = lc.id));
        l.add(new Case(class__c='共通異動',type__c='電話番号変更', lifeContractReference__c = lc.id));
        l.add(new Case(class__c='共通異動',type__c='メールアドレス変更', lifeContractReference__c = lc.id));
        l.add(new Case(class__c='共通異動',type__c='住所変更', littleContractReference__c = lic.id));
        l.add(new Case(class__c='共通異動',type__c='改姓（名義変更）', littleContractReference__c = lic.id));
        l.add(new Case(class__c='共通異動',type__c='電話番号変更', littleContractReference__c = lic.id));
        l.add(new Case(class__c='共通異動',type__c='メールアドレス変更', littleContractReference__c = lic.id));
        l.add(new Case(class__c='生命専用ケース',type__c='保険金・給付金・共済金請求', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='受取人（生保）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='受取人（共済）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='指定代理人変更', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='海外渡航', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='証券再発行', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='控除再発行', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='Retention', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='解約', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='返金先口座', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='アルファ付替', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='更新拒否', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='特約解約', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='特約減額', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='減額', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='更新時減額', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='減口（生保）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='減口（共済）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='更新時減口（共済）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='書類発送ケース', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='対応履歴', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='対応依頼', damageContractReference__c = dc.id));
        l.add(new Case(class__c='生命専用ケース',type__c='情報連携', damageContractReference__c = dc.id));
        l.add(new Case(class__c='損保専用ケース',type__c='住所変更', damageContractReference__c = dc.id));
        l.add(new Case(class__c='損保専用ケース',type__c='車両入替', damageContractReference__c = dc.id));
        l.add(new Case(class__c='損保専用ケース',type__c='解約（損保）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='損保専用ケース',type__c='再発行', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='少短事故受付', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='少短事故受付(賠責）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='更新変更', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='更新拒否', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='解約', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='Retention', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='保険金関連（事故受付以外）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='振込用紙再送', damageContractReference__c = dc.id));
        l.add(new Case(class__c='少短専用ケース',type__c='証券類・更新案内再送', damageContractReference__c = dc.id));
        l.add(new Case(class__c='汎用ケース',type__c='汎用（生命）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='汎用ケース',type__c='汎用（損保）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='汎用ケース',type__c='汎用（少短）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='苦情・要望',type__c='苦情・要望', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='生命_コール資料請求', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='損保_ミドル連携', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='少短_コール資料請求', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='生命・少短_比較チーム連携', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='生命_対面誘導（生命営推本部）', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='生命_WEB資料請求', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='少短_WEB資料請求', damageContractReference__c = dc.id));
        l.add(new Case(class__c='セールス専用ケース',type__c='信書回収', damageContractReference__c = dc.id));
        
        for(Case c : l){
            c.OwnerId = UserInfo.getUserId();
        }
        
        return l;
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

    private Case createCase_cc(Id lifeContractId){

        return new Case(
            Origin='電話',
            Status='CC完了',
            class__c='生命専用ケース',
            type__c='対応履歴',
            lifeContractReference__c = lifeContractId
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
}