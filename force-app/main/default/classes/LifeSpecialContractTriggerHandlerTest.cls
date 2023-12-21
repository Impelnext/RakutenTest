@isTest
public class LifeSpecialContractTriggerHandlerTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        insert  triggerTest.createLifeContract(account.Id);
        
        //生保特約登録
        Test.startTest();
        insert  triggerTest.createLifeSpecialContract();
        Test.stopTest();
    }
    
    @isTest
    static void LifeContract_Insert_Flag_Test()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract();
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '先進医療特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, '有');
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '先進医療特約２０１８';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, '有（2018）');
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = 'がん特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = 'がん特則';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = 'がん特約Ⅱ';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有（Ⅱ）／10000');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '急性心筋梗塞・脳卒中特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '限定告知型急性心筋梗塞・脳卒中特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        Test.stopTest();
    }
    
    @isTest
    static void LifeContract_Insert_Flag_Test2()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract();
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '通院特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '限定告知型通院特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '７疾病特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '退院・通院特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '３大疾病保険料払込免除特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, '有／10000');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, '有');
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = 'がん特約';
        lsc.BENEFIT_AMOUNT__c = NULL;
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = 'がん特約';
        lsc.BENEFIT_AMOUNT__c = '';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        Test.stopTest();
    }

    @isTest
    static void LifeContract_Insert_Flag_Test3()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        List<LifeSpecialContract__c> lscList = new List<LifeSpecialContract__c>();
        lscList.add(triggerTest.createLifeSpecialContract('12345671', '先進医療特約', '1000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345672', 'がん特約', '2000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345673', '急性心筋梗塞・脳卒中特約', '3000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345674', '通院特約', '4000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345675', '７疾病特約', '5000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345676', '退院・通院特約', '6000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345677', '３大疾病保険料払込免除特約', '7000'));
        lscList.add(triggerTest.createLifeSpecialContract('12345678', '指定代理請求特約', '8000'));
        insert  lscList;
        
        String contractId = '';
        for( LifeSpecialContract__c lsc : lscList ) {
            lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
            contractId = lsc.LifeContract__c;
            System.assertEquals( lsc.LifeContract__c, lc.Id);    
        }
        
        lc = triggerTest.getLifeContractById(contractId);
        System.assertEquals( '有', lc.Advanced_Contract_Flag__c );
        System.assertEquals( '有／2000', lc.Cancer_Contract_Amount__c);
        System.assertEquals( '有／3000', lc.Emergency_Contract_Amount__c );
        System.assertEquals( '有／4000', lc.Outpatient_Contract_Amount__c);
        System.assertEquals( '有／5000', lc.Sick7_Contract_Amount__c);
        System.assertEquals( '有／6000', lc.Discharge_Outpatient_Contract_Amount__c);
        System.assertEquals( '有／7000', lc.MajorSick3_Exemp_Contract__c);
        System.assertEquals( '有', lc.AUTHORIZED_CLAIMANT_CONTRACT__c);

        Test.stopTest();
    }

    @isTest
    static void LifeContract_Update_Flag_Test()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract();
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '先進医療特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, '有');
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '先進医療特約２０１８';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, '有（2018）');
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = 'がん特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = 'がん特則';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = 'がん特約Ⅱ';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有（Ⅱ）／10000');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '急性心筋梗塞・脳卒中特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '限定告知型急性心筋梗塞・脳卒中特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        Test.stopTest();
    }
    
    @isTest
    static void LifeContract_Update_Flag_Test2()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract();
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '通院特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '限定告知型通院特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '７疾病特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '退院・通院特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, '有／10000');
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '３大疾病保険料払込免除特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, '有／10000');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = '指定代理請求特約';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, '有');
        
        lsc.Name = 'がん特約';
        lsc.BENEFIT_AMOUNT__c = NULL;
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        lsc.Name = 'がん特約';
        lsc.BENEFIT_AMOUNT__c = '';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, '有／');
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        
        Test.stopTest();
    }
    
    @isTest
    static void LifeContract_Update_Flag_Test3()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id);
        lc2.POL_NUM__c = '1234568';
        insert lc2;
        
        LifeSpecialContract__c lsc1_1 = triggerTest.createLifeSpecialContract('12345671', '先進医療特約', '1000');
        LifeSpecialContract__c lsc1_2 = triggerTest.createLifeSpecialContract('12345672', '先進医療特約', '1100');
        LifeSpecialContract__c lsc2_1 = triggerTest.createLifeSpecialContract('12345673', 'がん特約', '2000');
        LifeSpecialContract__c lsc2_2 = triggerTest.createLifeSpecialContract('12345674', 'がん特約', '2100');
        LifeSpecialContract__c lsc3_1 = triggerTest.createLifeSpecialContract('12345675', '急性心筋梗塞・脳卒中特約', '3000');
        LifeSpecialContract__c lsc3_2 = triggerTest.createLifeSpecialContract('12345676', '急性心筋梗塞・脳卒中特約', '3100');
        LifeSpecialContract__c lsc4_1 = triggerTest.createLifeSpecialContract('12345677', '通院特約', '4000');
        LifeSpecialContract__c lsc4_2 = triggerTest.createLifeSpecialContract('12345678', '通院特約', '4100');
        LifeSpecialContract__c lsc5_1 = triggerTest.createLifeSpecialContract('12345679', '７疾病特約', '5000');
        LifeSpecialContract__c lsc5_2 = triggerTest.createLifeSpecialContract('12345680', '７疾病特約', '5100');
        LifeSpecialContract__c lsc6_1 = triggerTest.createLifeSpecialContract('12345681', '退院・通院特約', '6000');
        LifeSpecialContract__c lsc6_2 = triggerTest.createLifeSpecialContract('12345682', '退院・通院特約', '6100');
        LifeSpecialContract__c lsc7_1 = triggerTest.createLifeSpecialContract('12345683', '３大疾病保険料払込免除特約', '7000');
        LifeSpecialContract__c lsc7_2 = triggerTest.createLifeSpecialContract('12345684', '３大疾病保険料払込免除特約', '7100');
        LifeSpecialContract__c lsc8_1 = triggerTest.createLifeSpecialContract('12345685', '指定代理請求特約', '8000');
        LifeSpecialContract__c lsc8_2 = triggerTest.createLifeSpecialContract('12345686', '指定代理請求特約', '8100');
        List<LifeSpecialContract__c> insertList = new List<LifeSpecialContract__c>{
            lsc1_1, lsc1_2, lsc2_1, lsc2_2,
            lsc3_1, lsc3_2, lsc4_1, lsc4_2,
            lsc5_1, lsc5_2, lsc6_1, lsc6_2,
            lsc7_1, lsc7_2, lsc8_1, lsc8_2
        };
        insert  insertList;

        // 生保特約Update
        Test.startTest();
        lsc1_2.POL_NUM__c = '1234568';
        lsc2_2.POL_NUM__c = '1234568';
        lsc3_2.POL_NUM__c = '1234568';
        lsc4_2.POL_NUM__c = '1234568';
        lsc5_2.POL_NUM__c = '1234568';
        lsc6_2.POL_NUM__c = '1234568';
        lsc7_2.POL_NUM__c = '1234568';
        lsc8_2.POL_NUM__c = '1234568';
        List<LifeSpecialContract__c> updateList = new List<LifeSpecialContract__c>{
            lsc1_2, lsc2_2, lsc3_2, lsc4_2,
            lsc5_2, lsc6_2, lsc7_2, lsc8_2
        };
        update updateList;
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( '有', lc.Advanced_Contract_Flag__c );
        System.assertEquals( '有／2000', lc.Cancer_Contract_Amount__c);
        System.assertEquals( '有／3000', lc.Emergency_Contract_Amount__c );
        System.assertEquals( '有／4000', lc.Outpatient_Contract_Amount__c);
        System.assertEquals( '有／5000', lc.Sick7_Contract_Amount__c);
        System.assertEquals( '有／6000', lc.Discharge_Outpatient_Contract_Amount__c);
        System.assertEquals( '有／7000', lc.MajorSick3_Exemp_Contract__c);
        System.assertEquals( '有', lc.AUTHORIZED_CLAIMANT_CONTRACT__c);

        Test.stopTest();
    }

    @isTest
    static void LifeContract_Update_Flag_Test4()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id);
        lc2.POL_NUM__c = '1234568';
        insert lc2;
        
        LifeSpecialContract__c lsc1_1 = triggerTest.createLifeSpecialContract('12345671', '先進医療特約', '1000');
        LifeSpecialContract__c lsc1_2 = triggerTest.createLifeSpecialContract('12345672', '先進医療特約', '1100');
        LifeSpecialContract__c lsc2_1 = triggerTest.createLifeSpecialContract('12345673', 'がん特約', '2000');
        LifeSpecialContract__c lsc2_2 = triggerTest.createLifeSpecialContract('12345674', 'がん特約', '2100');
        LifeSpecialContract__c lsc3_1 = triggerTest.createLifeSpecialContract('12345675', '急性心筋梗塞・脳卒中特約', '3000');
        LifeSpecialContract__c lsc3_2 = triggerTest.createLifeSpecialContract('12345676', '急性心筋梗塞・脳卒中特約', '3100');
        LifeSpecialContract__c lsc4_1 = triggerTest.createLifeSpecialContract('12345677', '通院特約', '4000');
        LifeSpecialContract__c lsc4_2 = triggerTest.createLifeSpecialContract('12345678', '通院特約', '4100');
        LifeSpecialContract__c lsc5_1 = triggerTest.createLifeSpecialContract('12345679', '７疾病特約', '5000');
        LifeSpecialContract__c lsc5_2 = triggerTest.createLifeSpecialContract('12345680', '７疾病特約', '5100');
        LifeSpecialContract__c lsc6_1 = triggerTest.createLifeSpecialContract('12345681', '退院・通院特約', '6000');
        LifeSpecialContract__c lsc6_2 = triggerTest.createLifeSpecialContract('12345682', '退院・通院特約', '6100');
        LifeSpecialContract__c lsc7_1 = triggerTest.createLifeSpecialContract('12345683', '３大疾病保険料払込免除特約', '7000');
        LifeSpecialContract__c lsc7_2 = triggerTest.createLifeSpecialContract('12345684', '３大疾病保険料払込免除特約', '7100');
        LifeSpecialContract__c lsc8_1 = triggerTest.createLifeSpecialContract('12345685', '指定代理請求特約', '8000');
        LifeSpecialContract__c lsc8_2 = triggerTest.createLifeSpecialContract('12345686', '指定代理請求特約', '8100');
        List<LifeSpecialContract__c> insertList = new List<LifeSpecialContract__c>{
            lsc1_1, lsc1_2, lsc2_1, lsc2_2,
            lsc3_1, lsc3_2, lsc4_1, lsc4_2,
            lsc5_1, lsc5_2, lsc6_1, lsc6_2,
            lsc7_1, lsc7_2, lsc8_1, lsc8_2
        };
        insert  insertList;


        Test.startTest();
        // 生保特約Update(全ての特約を外す)
        List<LifeSpecialContract__c> updateList = new List<LifeSpecialContract__c>();
        for( LifeSpecialContract__c ls : insertList ) {
            ls.POL_NUM__c = '1234568';
            updateList.add(ls);
        }
        update updateList;
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( NULL, lc.Advanced_Contract_Flag__c );
        System.assertEquals( NULL, lc.Cancer_Contract_Amount__c);
        System.assertEquals( NULL, lc.Emergency_Contract_Amount__c );
        System.assertEquals( NULL, lc.Outpatient_Contract_Amount__c);
        System.assertEquals( NULL, lc.Sick7_Contract_Amount__c);
        System.assertEquals( NULL, lc.Discharge_Outpatient_Contract_Amount__c);
        System.assertEquals( NULL, lc.MajorSick3_Exemp_Contract__c);
        System.assertEquals( NULL, lc.AUTHORIZED_CLAIMANT_CONTRACT__c);

        Test.stopTest();
    }

    @isTest
    static void LifeContract_Insert_KanjiKana_Relation_Test()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '本人';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人');
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = NULL;
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = NULL;
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, NULL);
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = '';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '本人１';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人１');
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = NULL;
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = 'Test';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, 'Test');
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = '';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '12345';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '12345');
        
        delete lsc;
        lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = NULL;
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = NULL;
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = 'ﾗｸﾃﾝ';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, 'ﾗｸﾃﾝ');
        
        Test.stopTest();
    }
    
    @isTest
    static void LifeContract_Update_KanjiKana_Relation_Test()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract();
        lsc.Name = '指定代理請求特約';
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '本人';
        insert  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人');
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, NULL);
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = NULL;
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = NULL;
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, NULL);
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = '';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '本人１';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人１');
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = NULL;
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = 'Test';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, 'Test');
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = '';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '12345';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '12345');
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = NULL;
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = NULL;
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = 'ﾗｸﾃﾝ';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '／');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, 'ﾗｸﾃﾝ');
        
        lsc.KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎';
        lsc.KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ';
        lsc.AUTHORIZED_CLMANT_RELATIONSHIP__c = '本人';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人');
        
        Test.stopTest();
    }
    
    @isTest
    static void LifeContract_Update_LifeContract_Test()
    {
        LifeSpecialContractTriggerHandlerTest triggerTest = new LifeSpecialContractTriggerHandlerTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        LifeContract__c lc = triggerTest.createLifeContract(account.Id);
        insert  lc;
        
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id);
        lc2.POL_NUM__c = '2234567';
        insert  lc2;
        
        //生保特約登録
        Test.startTest();
        
        LifeSpecialContract__c lsc = triggerTest.createLifeSpecialContract('1234567', '先進医療特約', '10000');
        LifeSpecialContract__c lsc2 = triggerTest.createLifeSpecialContract('1234568', '指定代理請求特約', '10000');
        insert  lsc;
        insert  lsc2;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, '有');
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, '有');
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人');
        
        // Change PolicyNum from LifeContract(1) to different LifeContract(2)
        lsc.POL_NUM__c = '2234567';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, '有');
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人');
        
        lc2 = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc2.Advanced_Contract_Flag__c, '有');
        System.assertEquals( lc2.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc2.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc2.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        System.assertEquals( lc2.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, NULL);
        System.assertEquals( lc2.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, NULL);
        
        // Change PolicyNum from LifeContract(2) to NULL
        lsc.POL_NUM__c = NULL;
        update  lsc;        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, NULL);
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.Advanced_Contract_Flag__c, NULL);
        System.assertEquals( lc2.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc2.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc2.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc2.AUTHORIZED_CLAIMANT_CONTRACT__c, NULL);
        System.assertEquals( lc2.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, NULL);
        System.assertEquals( lc2.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, NULL);
        
        // Change PolicyNum from NULL to different LifeContract(1)
        lsc.POL_NUM__c = '1234567';
        update  lsc;
        
        lsc = triggerTest.getLifeSpecialContractById(lsc.Id);
        System.assertEquals( lsc.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lsc.LifeContract__c);
        System.assertEquals( lc.Advanced_Contract_Flag__c, '有');
        System.assertEquals( lc.Cancer_Contract_Amount__c, NULL);
        System.assertEquals( lc.Emergency_Contract_Amount__c, NULL);
        System.assertEquals( lc.Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.Sick7_Contract_Amount__c, NULL);
        System.assertEquals( lc.Discharge_Outpatient_Contract_Amount__c, NULL);
        System.assertEquals( lc.MajorSick3_Exemp_Contract__c, NULL);
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_CONTRACT__c, '有');
        System.assertEquals( lc.KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c, '楽天　二郎／ﾗｸﾃﾝ ｲﾁﾛｳ');
        System.assertEquals( lc.AUTHORIZED_CLAIMANT_RELATIONSHIP__c, '本人');
        
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
    
    private LifeSpecialContract__c createLifeSpecialContract(){
        return createLifeSpecialContract('1234567', 'test name', '10000');
    }

    private LifeSpecialContract__c createLifeSpecialContract( String foreignKey, String name, String amount ){
        return new LifeSpecialContract__c(
            Name = name,
            POL_NUM__c = '1234567',
            ForeignKey_LifeSpecialContract__c = foreignKey,
            KANJI_AUTHORIZED_CLMANT_NAME__c = '楽天　二郎',
            KANA_AUTHORIZED_CLAIMANT_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ',
            AUTHORIZED_CLMANT_RELATIONSHIP__c = '本人',
            BENEFIT_AMOUNT__c = amount
        );
    }

    
    private LifeContract__c getLifeContractById( Id contractId ) {
        return   [ SELECT Id
                        , POL_NUM__c
                        , KANJI_KANA_AUTHORIZED_CLAIMANT_NAME__c
                        , AUTHORIZED_CLAIMANT_RELATIONSHIP__c
                        , Advanced_Contract_Flag__c
                        , Cancer_Contract_Amount__c
                        , Emergency_Contract_Amount__c
                        , Outpatient_Contract_Amount__c
                        , Sick7_Contract_Amount__c
                        , Discharge_Outpatient_Contract_Amount__c
                        , MajorSick3_Exemp_Contract__c
                        , AUTHORIZED_CLAIMANT_CONTRACT__c
                     FROM LifeContract__c 
                    WHERE ID = :contractId ];
    }
    
    private LifeSpecialContract__c getLifeSpecialContractById( Id specialId ) {
        return   [ SELECT Id
                        , Name
                        , LifeContract__c
                        , POL_NUM__c
                        , ForeignKey_LifeSpecialContract__c
                        , KANJI_AUTHORIZED_CLMANT_NAME__c
                        , KANA_AUTHORIZED_CLAIMANT_NAME__c
                        , AUTHORIZED_CLMANT_RELATIONSHIP__c
                        , BENEFIT_AMOUNT__c
                     FROM LifeSpecialContract__c 
                    WHERE ID = :specialId ];
    }
}