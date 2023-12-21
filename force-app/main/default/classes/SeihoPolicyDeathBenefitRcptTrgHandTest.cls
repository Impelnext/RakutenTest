@isTest
public class SeihoPolicyDeathBenefitRcptTrgHandTest
{
    @isTest
    static void LifeContractTriggerTest_insert()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        UpdateLifeContractTestHandler triggerHandler = new UpdateLifeContractTestHandler();
        //取引先作成
        insert  triggerHandler.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        LifeContract__c contract = triggerHandler.createLifeContract(account.Id);
        insert  contract;
        
        //生保特約登録
        Test.startTest();
        insert  triggerTest.createLifeSpecialContract();
        insert  triggerTest.createLifeSpecialContractWithNoPolicyNumber();
        SeihoPolicyDeathBenefitRcpt__c polNum = [select id, LifeContract__c, INSURANCE_POLICY_NUMBER__c from SeihoPolicyDeathBenefitRcpt__c where INSURANCE_POLICY_NUMBER__c= '1234567' limit 1];
        system.assertEquals(contract.Id, polNum.LifeContract__c);
        Test.stopTest();
    }
    
    private SeihoPolicyDeathBenefitRcpt__c createLifeSpecialContract(){
        return new SeihoPolicyDeathBenefitRcpt__c(
            INSURANCE_POLICY_NUMBER__c = '1234567'
        );
    }
    
    // Test scenario Without Existing Policy Number
    
    private SeihoPolicyDeathBenefitRcpt__c createLifeSpecialContractWithOutExistingPolNumber(){
        return new SeihoPolicyDeathBenefitRcpt__c(
            INSURANCE_POLICY_NUMBER__c = '89065'
        );
    }
    
    // Test Scenario With No Policy Number
    
    private SeihoPolicyDeathBenefitRcpt__c createLifeSpecialContractWithNoPolicyNumber(){
        return new SeihoPolicyDeathBenefitRcpt__c( 
        );
    }
    
    
    @isTest
    static void SeihoPolicyDeathBenefitRcpt_Insert_KanjiKana_Relation_Test()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        String policyNo1 = '1234567';
        LifeContract__c lc = triggerTest.createLifeContract(account.Id, policyNo1);
        insert  lc;
        
        String policyNo2 = '2234567';
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id, policyNo2);
        insert  lc2;
        
        //生保特約登録
        Test.startTest();
        
        // Policy Benefit for Contract1
        SeihoPolicyDeathBenefitRcpt__c sdb1 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 1);
        SeihoPolicyDeathBenefitRcpt__c sdb2 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 2);
        SeihoPolicyDeathBenefitRcpt__c sdb3 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 5);
        
        // Policy Benefit for Contract2
        SeihoPolicyDeathBenefitRcpt__c sdb4 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb5 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 5);
        SeihoPolicyDeathBenefitRcpt__c sdb6 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 8);
        
        List<SeihoPolicyDeathBenefitRcpt__c> sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        insert sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、98%');
        
        // Add Policy Benefit
        SeihoPolicyDeathBenefitRcpt__c sdb7 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 4);
        insert sdb7;
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親4、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、94%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、98%');
        
        SeihoPolicyDeathBenefitRcpt__c sdb8 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 6);
        insert sdb8;
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親4、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、94%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        SeihoPolicyDeathBenefitRcpt__c sdb9 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 6);
        SeihoPolicyDeathBenefitRcpt__c sdb10 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 7);
        SeihoPolicyDeathBenefitRcpt__c sdb11 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb12 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 3);
        
        // Add List of PolicyBenefits
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb9);
        sdbListPolicy.add(sdb10);
        sdbListPolicy.add(sdb11);
        sdbListPolicy.add(sdb12);
        insert sdbListPolicy;
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親4、親4、親5、親6');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、94%、94%、95%、96%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎3／ﾗｸﾃﾝ ｲﾁﾛｳ3、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎7／ﾗｸﾃﾝ ｲﾁﾛｳ7、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親3、親4、親5、親6、親7、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '93%、94%、95%、96%、97%、98%');
        
        Test.stopTest();
    }
    
    @isTest
    static void SeihoPolicyDeathBenefitRcpt_Update_KanjiKana_Relation_Test()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        String policyNo1 = '1234567';
        LifeContract__c lc = triggerTest.createLifeContract(account.Id, policyNo1);
        insert  lc;
        
        String policyNo2 = '2234567';
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id, policyNo2);
        insert  lc2;
        
        //生保特約登録
        Test.startTest();
        
        // Policy Benefit for Contract1
        SeihoPolicyDeathBenefitRcpt__c sdb1 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 1);
        SeihoPolicyDeathBenefitRcpt__c sdb2 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 2);
        SeihoPolicyDeathBenefitRcpt__c sdb3 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 5);
        
        // Policy Benefit for Contract2
        SeihoPolicyDeathBenefitRcpt__c sdb4 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb5 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 5);
        SeihoPolicyDeathBenefitRcpt__c sdb6 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 8);
        SeihoPolicyDeathBenefitRcpt__c sdb7 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 6);
        
        List<SeihoPolicyDeathBenefitRcpt__c> sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        insert sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        // Change the Branch Number
        sdb1.BRANCH_NUMBER__c = '06';
        sdb3.BRANCH_NUMBER__c = '01';
        sdb4.BRANCH_NUMBER__c = '07';
        sdb6.BRANCH_NUMBER__c = '04';
        sdb7.BRANCH_NUMBER__c = '';
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親5、親2、親1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '95%、92%、91%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親6、親8、親5、親4');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '96%、98%、95%、94%');
        
        // Change KanjiName / Kana Name
        sdb3.KANJI_NAME__c = '楽天　二郎5New';
        sdb2.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ2New';
        sdb1.KANJI_NAME__c = '';
        sdb4.KANA_NAME__c = '';
        sdb5.KANJI_NAME__c = NULL;
        sdb6.KANA_NAME__c = NULL;
        sdb7.KANJI_NAME__c = NULL;
        sdb7.KANA_NAME__c = NULL;
        
        // Change Relationship
        sdb3.RELATIONSHIP_TO_INSURED__c = '親5New';
        sdb1.RELATIONSHIP_TO_INSURED__c = '';
        sdb4.RELATIONSHIP_TO_INSURED__c = '';
        sdb5.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb7.RELATIONSHIP_TO_INSURED__c = '親6';
        
        // Change SplitRatio
        sdb3.SPLIT_RATIO__c = '100%';
        sdb1.SPLIT_RATIO__c = '';
        sdb4.SPLIT_RATIO__c = '';
        sdb5.SPLIT_RATIO__c = NULL;
        sdb7.SPLIT_RATIO__c = '96%';
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎5New／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2New、／ﾗｸﾃﾝ ｲﾁﾛｳ1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親5New、親2、');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '100%、92%、');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎8／、／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎4／');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親6、親8、、');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '96%、98%、、');
        
        // Change KanjiName / Kana Name
        sdb3.KANJI_NAME__c = '楽天　二郎5';
        sdb2.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ2';
        sdb1.KANJI_NAME__c = '楽天　二郎1';
        sdb4.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ4';
        sdb5.KANJI_NAME__c = '楽天　二郎5';
        sdb6.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ8';
        sdb7.KANJI_NAME__c = '楽天　二郎6';
        sdb7.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ6';
        
        // Change Relationship
        sdb3.RELATIONSHIP_TO_INSURED__c = '親5';
        sdb1.RELATIONSHIP_TO_INSURED__c = '親1';
        sdb4.RELATIONSHIP_TO_INSURED__c = '親4';
        sdb5.RELATIONSHIP_TO_INSURED__c = '親5';
        sdb7.RELATIONSHIP_TO_INSURED__c = '親6';
        
        // Change SplitRatio
        sdb3.SPLIT_RATIO__c = '95%';
        sdb1.SPLIT_RATIO__c = '91%';
        sdb4.SPLIT_RATIO__c = '94%';
        sdb5.SPLIT_RATIO__c = '95%';
        sdb7.SPLIT_RATIO__c = '96%';
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親5、親2、親1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '95%、92%、91%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親6、親8、親5、親4');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '96%、98%、95%、94%');
        
        // Update some other Info
        sdb1.BIRTH_DATE__c = '2000-01-01';
        sdb2.BIRTH_DATE__c = '2000-01-02';
        sdb3.BIRTH_DATE__c = '2000-01-03';
        sdb4.BIRTH_DATE__c = '2000-01-04';
        sdb5.BIRTH_DATE__c = '2000-01-05';
        sdb6.BIRTH_DATE__c = '2000-01-06';
        sdb7.BIRTH_DATE__c = '2000-01-07';
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親5、親2、親1');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '95%、92%、91%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親6、親8、親5、親4');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '96%、98%、95%、94%');
        
        Test.stopTest();
    }
    
    @isTest
    static void SeihoPolicyDeathBenefitRcpt_Update_KanjiKana_Relation_Test2()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        String policyNo1 = '1234567';
        LifeContract__c lc = triggerTest.createLifeContract(account.Id, policyNo1);
        insert  lc;
        
        String policyNo2 = '2234567';
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id, policyNo2);
        insert  lc2;
        
        //生保特約登録
        Test.startTest();
        
        // Policy Benefit for Contract1
        SeihoPolicyDeathBenefitRcpt__c sdb1 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 1);
        SeihoPolicyDeathBenefitRcpt__c sdb2 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 2);
        SeihoPolicyDeathBenefitRcpt__c sdb3 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 5);
        
        // Policy Benefit for Contract2
        SeihoPolicyDeathBenefitRcpt__c sdb4 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb5 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 5);
        SeihoPolicyDeathBenefitRcpt__c sdb6 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 8);
        SeihoPolicyDeathBenefitRcpt__c sdb7 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 6);
        
        List<SeihoPolicyDeathBenefitRcpt__c> sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        insert sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        sdb4.RELATIONSHIP_TO_INSURED__c = NULL;
        update sdb4;
        
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        sdb4.SPLIT_RATIO__c = NULL;
        update sdb4;
        
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、95%、96%、98%');
        
        sdb1.KANJI_NAME__c = NULL;
        update sdb1;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、95%、96%、98%');
        
        sdb1.KANA_NAME__c = NULL;
        update sdb1;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、95%、96%、98%');
        
        sdb4.KANJI_NAME__c = NULL;
        sdb4.KANA_NAME__c = NULL;
        update sdb4;
        
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、95%、96%、98%');
        
        Test.stopTest();
    }
    
    @isTest
    static void SeihoPolicyDeathBenefitRcpt_Update_KanjiKana_Relation_Test3()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        String policyNo1 = '1234567';
        LifeContract__c lc = triggerTest.createLifeContract(account.Id, policyNo1);
        insert  lc;
        
        String policyNo2 = '2234567';
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id, policyNo2);
        insert  lc2;
        
        //生保特約登録
        Test.startTest();
        
        // Policy Benefit for Contract1
        SeihoPolicyDeathBenefitRcpt__c sdb1 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 1);
        SeihoPolicyDeathBenefitRcpt__c sdb2 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 2);
        SeihoPolicyDeathBenefitRcpt__c sdb3 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 5);
        
        // Policy Benefit for Contract2
        SeihoPolicyDeathBenefitRcpt__c sdb4 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb5 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 5);
        SeihoPolicyDeathBenefitRcpt__c sdb6 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 8);
        SeihoPolicyDeathBenefitRcpt__c sdb7 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 6);
        
        sdb1.KANJI_NAME__c = NULL;
        sdb1.KANA_NAME__c = NULL;
        sdb4.KANJI_NAME__c = NULL;
        sdb4.KANA_NAME__c = NULL;
        sdb4.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb4.SPLIT_RATIO__c = NULL;
        
        List<SeihoPolicyDeathBenefitRcpt__c> sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        insert sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、95%、96%、98%');
        
        sdb4.RELATIONSHIP_TO_INSURED__c = '親4';
        update sdb4;
        
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、95%、96%、98%');
        
        sdb4.SPLIT_RATIO__c = '94%';
        update sdb4;
        
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        sdb1.KANJI_NAME__c = '楽天　二郎1';
        update sdb1;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        sdb1.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ1';
        update sdb1;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        sdb4.KANJI_NAME__c = '楽天　二郎4';
        sdb4.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ4';
        update sdb4;
        
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        Test.stopTest();
    }
    
    @isTest
    static void SeihoPolicyDeathBenefitRcpt_Update_KanjiKana_Relation_Test4()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        String policyNo1 = '1234567';
        LifeContract__c lc = triggerTest.createLifeContract(account.Id, policyNo1);
        insert  lc;
        
        String policyNo2 = '2234567';
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id, policyNo2);
        insert  lc2;
        
        //生保特約登録
        Test.startTest();
        
        // Policy Benefit for Contract1
        SeihoPolicyDeathBenefitRcpt__c sdb1 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 1);
        SeihoPolicyDeathBenefitRcpt__c sdb2 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 2);
        SeihoPolicyDeathBenefitRcpt__c sdb3 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 5);
        
        // Policy Benefit for Contract2
        SeihoPolicyDeathBenefitRcpt__c sdb4 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb5 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 5);
        SeihoPolicyDeathBenefitRcpt__c sdb6 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 8);
        SeihoPolicyDeathBenefitRcpt__c sdb7 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 6);
        
        List<SeihoPolicyDeathBenefitRcpt__c> sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        insert sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        sdb1.KANJI_NAME__c = NULL;
        sdb2.KANJI_NAME__c = NULL;
        sdb3.KANJI_NAME__c = NULL;
        sdb4.KANJI_NAME__c = NULL;
        sdb5.KANJI_NAME__c = NULL;
        sdb6.KANJI_NAME__c = NULL;
        sdb7.KANJI_NAME__c = NULL;
        
        sdb1.KANA_NAME__c = NULL;
        sdb2.KANA_NAME__c = NULL;
        sdb3.KANA_NAME__c = NULL;
        sdb4.KANA_NAME__c = NULL;
        sdb5.KANA_NAME__c = NULL;
        sdb6.KANA_NAME__c = NULL;
        sdb7.KANA_NAME__c = NULL;
        
        sdb1.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb2.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb3.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb4.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb5.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb6.RELATIONSHIP_TO_INSURED__c = NULL;
        sdb7.RELATIONSHIP_TO_INSURED__c = NULL;
        
        sdb1.SPLIT_RATIO__c = NULL;
        sdb2.SPLIT_RATIO__c = NULL;
        sdb3.SPLIT_RATIO__c = NULL;
        sdb4.SPLIT_RATIO__c = NULL;
        sdb5.SPLIT_RATIO__c = NULL;
        sdb6.SPLIT_RATIO__c = NULL;
        sdb7.SPLIT_RATIO__c = NULL;
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、／、／');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、、');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、、');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '／、／、／、／');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '、、、');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '、、、');
        
        sdb1.KANJI_NAME__c = '楽天　二郎1';
        sdb2.KANJI_NAME__c = '楽天　二郎2';
        sdb3.KANJI_NAME__c = '楽天　二郎5';
        sdb4.KANJI_NAME__c = '楽天　二郎4';
        sdb5.KANJI_NAME__c = '楽天　二郎5';
        sdb6.KANJI_NAME__c = '楽天　二郎8';
        sdb7.KANJI_NAME__c = '楽天　二郎6';
        
        sdb1.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ1';
        sdb2.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ2';
        sdb3.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ5';
        sdb4.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ4';
        sdb5.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ5';
        sdb6.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ8';
        sdb7.KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ6';
        
        sdb1.RELATIONSHIP_TO_INSURED__c = '親1';
        sdb2.RELATIONSHIP_TO_INSURED__c = '親2';
        sdb3.RELATIONSHIP_TO_INSURED__c = '親5';
        sdb4.RELATIONSHIP_TO_INSURED__c = '親4';
        sdb5.RELATIONSHIP_TO_INSURED__c = '親5';
        sdb6.RELATIONSHIP_TO_INSURED__c = '親8';
        sdb7.RELATIONSHIP_TO_INSURED__c = '親6';
        
        sdb1.SPLIT_RATIO__c = '91%';
        sdb2.SPLIT_RATIO__c = '92%';
        sdb3.SPLIT_RATIO__c = '95%';
        sdb4.SPLIT_RATIO__c = '94%';
        sdb5.SPLIT_RATIO__c = '95%';
        sdb6.SPLIT_RATIO__c = '98%';
        sdb7.SPLIT_RATIO__c = '96%';
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        Test.stopTest();
    }
    
    @isTest
    static void SeihoPolicyDeathBenefitRcpt_Update_LifeContract_Test()
    {
        SeihoPolicyDeathBenefitRcptTrgHandTest triggerTest = new SeihoPolicyDeathBenefitRcptTrgHandTest();
        
        //取引先作成
        insert  triggerTest.createAccount();
        
        //生保契約登録
        Account account = [SELECT Id FROM Account LIMIT 1];
        
        String policyNo1 = '1234567';
        LifeContract__c lc = triggerTest.createLifeContract(account.Id, policyNo1);
        insert  lc;
        
        String policyNo2 = '2234567';
        LifeContract__c lc2 = triggerTest.createLifeContract(account.Id, policyNo2);
        insert  lc2;
        
        String policyNo3 = '3234567';
        
        //生保特約登録
        Test.startTest();
        
        // Policy Benefit for Contract1
        SeihoPolicyDeathBenefitRcpt__c sdb1 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 1);
        SeihoPolicyDeathBenefitRcpt__c sdb2 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 2);
        SeihoPolicyDeathBenefitRcpt__c sdb3 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo1, 5);
        
        // Policy Benefit for Contract2
        SeihoPolicyDeathBenefitRcpt__c sdb4 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 4);
        SeihoPolicyDeathBenefitRcpt__c sdb5 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 5);
        SeihoPolicyDeathBenefitRcpt__c sdb6 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 8);
        SeihoPolicyDeathBenefitRcpt__c sdb7 = triggerTest.createSeihoPolicyDeathBenefitRcpt(policyNo2, 6);
        
        List<SeihoPolicyDeathBenefitRcpt__c> sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        insert sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
        // Change the PolicyNumber
        sdb1.INSURANCE_POLICY_NUMBER__c = policyNo2;
        sdb3.INSURANCE_POLICY_NUMBER__c = policyNo2;
        sdb4.INSURANCE_POLICY_NUMBER__c = policyNo1;
        sdb5.INSURANCE_POLICY_NUMBER__c = NULL;
        sdb6.INSURANCE_POLICY_NUMBER__c = policyNo1;
        sdb7.INSURANCE_POLICY_NUMBER__c = policyNo3;
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc2.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc2.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, NULL);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, NULL);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親2、親4、親8');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '92%、94%、98%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親5');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、95%');
        
        // Change the PolicyNumber
        sdb1.INSURANCE_POLICY_NUMBER__c = policyNo3;
        sdb2.INSURANCE_POLICY_NUMBER__c = policyNo3;
        sdb3.INSURANCE_POLICY_NUMBER__c = policyNo3;
        sdb4.INSURANCE_POLICY_NUMBER__c = policyNo3;
        sdb5.INSURANCE_POLICY_NUMBER__c = policyNo3;
        sdb6.INSURANCE_POLICY_NUMBER__c = policyNo3;
        sdb7.INSURANCE_POLICY_NUMBER__c = policyNo3;
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, NULL);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, NULL);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, NULL);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, NULL);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, NULL);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, NULL);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, NULL);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, NULL);
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, NULL);
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, NULL);
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, NULL);
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, NULL);
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, NULL);
        
        // Change the PolicyNumber
        sdb1.INSURANCE_POLICY_NUMBER__c = policyNo1;
        sdb2.INSURANCE_POLICY_NUMBER__c = policyNo1;
        sdb3.INSURANCE_POLICY_NUMBER__c = policyNo1;
        sdb4.INSURANCE_POLICY_NUMBER__c = policyNo2;
        sdb5.INSURANCE_POLICY_NUMBER__c = policyNo2;
        sdb6.INSURANCE_POLICY_NUMBER__c = policyNo2;
        sdb7.INSURANCE_POLICY_NUMBER__c = policyNo2;
        
        sdbListPolicy = new List<SeihoPolicyDeathBenefitRcpt__c>();
        sdbListPolicy.add(sdb1);
        sdbListPolicy.add(sdb2);
        sdbListPolicy.add(sdb3);
        sdbListPolicy.add(sdb4);
        sdbListPolicy.add(sdb5);
        sdbListPolicy.add(sdb6);
        sdbListPolicy.add(sdb7);
        update sdbListPolicy;
        
        sdb1 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb1.Id);
        System.assertEquals( sdb1.LifeContract__c, lc.Id);
        sdb2 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb2.Id);
        System.assertEquals( sdb2.LifeContract__c, lc.Id);
        sdb3 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb3.Id);
        System.assertEquals( sdb3.LifeContract__c, lc.Id);
        sdb4 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb4.Id);
        System.assertEquals( sdb4.LifeContract__c, lc2.Id);
        sdb5 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb5.Id);
        System.assertEquals( sdb5.LifeContract__c, lc2.Id);
        sdb6 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb6.Id);
        System.assertEquals( sdb6.LifeContract__c, lc2.Id);
        sdb7 = triggerTest.getSeihoPolicyDeathBenefitRcptById(sdb7.Id);
        System.assertEquals( sdb7.LifeContract__c, lc2.Id);
        
        lc = triggerTest.getLifeContractById(lc.Id);
        System.assertEquals( lc.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎1／ﾗｸﾃﾝ ｲﾁﾛｳ1、楽天　二郎2／ﾗｸﾃﾝ ｲﾁﾛｳ2、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親1、親2、親5');
        System.assertEquals( lc.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '91%、92%、95%');
        
        lc2 = triggerTest.getLifeContractById(lc2.Id);
        System.assertEquals( lc2.KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c, 
                '楽天　二郎4／ﾗｸﾃﾝ ｲﾁﾛｳ4、楽天　二郎5／ﾗｸﾃﾝ ｲﾁﾛｳ5、楽天　二郎6／ﾗｸﾃﾝ ｲﾁﾛｳ6、楽天　二郎8／ﾗｸﾃﾝ ｲﾁﾛｳ8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c, '親4、親5、親6、親8');
        System.assertEquals( lc2.DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c, '94%、95%、96%、98%');
        
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
    
    private LifeContract__c createLifeContract(Id accountId, String policyNo){
        return new LifeContract__c(
            Name = 'test name',
            POL_NUM__c = policyNo,
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
    
    private SeihoPolicyDeathBenefitRcpt__c createSeihoPolicyDeathBenefitRcpt(String policyNo, Integer idx){
        return new SeihoPolicyDeathBenefitRcpt__c(
            INSURANCE_POLICY_NUMBER__c = policyNo,
            KANJI_NAME__c = '楽天　二郎' + idx,
            KANA_NAME__c = 'ﾗｸﾃﾝ ｲﾁﾛｳ' + idx,
            RELATIONSHIP_TO_INSURED__c = '親' + idx,
            SPLIT_RATIO__c = '9' + idx + '%',
            BRANCH_NUMBER__c = '0' + idx
        );
    }
    
    private LifeContract__c getLifeContractById( Id contractId ) {
        return   [ SELECT Id
                        , POL_NUM__c
                        , KANJI_KANA_DEATHBENEFIT_CLAIMANT_NAME__c
                        , DEATHBENEFIT_CLAIMANT_RELATIONSHIP__c
                        , DEATHBENEFIT_CLAIMANT_SPLIT_RATIO__c
                     FROM LifeContract__c 
                    WHERE ID = :contractId ];
    }
    
    private SeihoPolicyDeathBenefitRcpt__c getSeihoPolicyDeathBenefitRcptById( Id policyId ) {
        return  [  SELECT Id
                        , Name
                        , LifeContract__c
                        , INSURANCE_POLICY_NUMBER__c
                        , KANJI_NAME__c
                        , KANA_NAME__c
                        , RELATIONSHIP_TO_INSURED__c
                        , SPLIT_RATIO__c
                        , BRANCH_NUMBER__c
                     FROM SeihoPolicyDeathBenefitRcpt__c
                    WHERE ID = :policyId ];
    }
}