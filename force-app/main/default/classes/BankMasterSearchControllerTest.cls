/*
* @Class Name      : BankMasterSearchControllerTest 
* @Description     : 金融機関マスタ検索のテストクラス
* @Created Date    : 2020.03.11
* @Created By      : R,Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/
@isTest
public class BankMasterSearchControllerTest {

    @IsTest
    static void searchWithBankBranchCode(){
        
        Test.startTest();
        List<BankMaster__c> bankMasterList = createBankMasterTestData();
        Test.stopTest();
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('0000', '093', 'code');
        Map<String,BankMaster__c> bankMasterMap = getBankMasterValue(bankMasterList);
        System.assertEquals(wrapper.errorDisplayFlag, 3);
        System.assertEquals(bankMasterMap.get('0000'+'093').BankName__c, wrapper.bankMasterSearchResultList.get(0).bankName);
        System.assertEquals(bankMasterMap.get('0000'+'093').BranchName__c, wrapper.bankMasterSearchResultList.get(0).branchName);
    }

    @IsTest
    static void searchWithBankCode(){
        
        Test.startTest();
        createBankMasterTestData();
        Test.stopTest();
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('0000', '', 'code');
        System.assertEquals(wrapper.errorDisplayFlag, 3);
        System.assertEquals(2, wrapper.bankMasterSearchResultList.size());
    }

    @IsTest
    static void searchWithBranchCode(){
        
        Test.startTest();
        createBankMasterTestData();
        Test.stopTest();
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('', '093', 'code');
        System.assertEquals(wrapper.errorDisplayFlag, 3);
        System.assertEquals(1, wrapper.bankMasterSearchResultList.size());
    }

    @IsTest
    static void noSearchResultForBankBranchCode(){
        
        Test.startTest();
        createBankMasterTestData();
        Test.stopTest();
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('XXXX', 'YYY', 'code');
        System.assertEquals(wrapper.errorDisplayFlag, 2);
        System.assertEquals(0, wrapper.bankMasterSearchResultList.size());
    }

    @IsTest
    static void searchWithBankBranchName(){
        
        Test.startTest();
        List<BankMaster__c> bankMasterList = createBankMasterTestData();
        Test.stopTest();
        //金融機関名を全角で入力する。
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('ニッポン', 'ホンテン', 'name');
        Map<String,BankMaster__c> bankMasterMap = getBankMasterValue(bankMasterList);
        System.assertEquals(wrapper.errorDisplayFlag, 3);
        System.assertEquals(bankMasterMap.get(wrapper.bankMasterSearchResultList.get(0).bankCode + wrapper.bankMasterSearchResultList.get(0).branchCode).BankName__c, wrapper.bankMasterSearchResultList.get(0).bankName);
        System.assertEquals(bankMasterMap.get(wrapper.bankMasterSearchResultList.get(0).bankCode + wrapper.bankMasterSearchResultList.get(0).branchCode).BranchName__c, wrapper.bankMasterSearchResultList.get(0).branchName);
        
    }

    @IsTest
    static void searchWithBankName(){
        
        Test.startTest();
        createBankMasterTestData();
        Test.stopTest();
        //金融機関名を全角で入力する。
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('オオイタケンノウキョウ', '', 'name');
        System.assertEquals(wrapper.errorDisplayFlag, 3);
        System.assertEquals(1, wrapper.bankMasterSearchResultList.size());
    }

    @IsTest
    static void searchWithBranchName(){
        
        Test.startTest();
        createBankMasterTestData();
        Test.stopTest();
        //金融機関名を全角で入力する。
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('', 'ブンゴタカタ', 'name');
        System.assertEquals(wrapper.errorDisplayFlag, 3);
        System.assertEquals(1, wrapper.bankMasterSearchResultList.size());
    }

    @IsTest
    static void noSearchResultForBankBranchName(){
        
        Test.startTest();
        createBankMasterTestData();
        Test.stopTest();
        //金融機関名を全角で入力する。
        BankMasterSearchController.BankMasterWrapper wrapper = BankMasterSearchController.searchBankMaster('ZZZZ', 'ZYXY', 'name');
        System.assertEquals(wrapper.errorDisplayFlag, 2);
        System.assertEquals(0, wrapper.bankMasterSearchResultList.size());
    }

    static List<BankMaster__c> createBankMasterTestData(){

        List<BankMaster__c> bankMasterList =  new List<BankMaster__c>();

        BankMaster__c bankMaster1 = new BankMaster__c(
            BankCode__c = '0000',
            BankName__c = '日本銀行',
            BankName_Kana__c = 'ﾆﾂﾎﾟﾝ',
            BranchCode__c = '093',
            BranchName__c = '本店',
            BranchName_Kana__c = 'ﾎﾝﾃﾝ'
        );
        bankMasterList.add(bankMaster1);

        BankMaster__c bankMaster2 = new BankMaster__c(
            BankCode__c = '0000',
            BankName__c = '日本銀行',
            BankName_Kana__c = 'ﾆﾂﾎﾟﾝ',
            BranchCode__c = '550',
            BranchName__c = '青森支店',
            BranchName_Kana__c = 'ｱｵﾓﾘ'
        );
        bankMasterList.add(bankMaster2);

        BankMaster__c bankMaster3 = new BankMaster__c(
            BankCode__c = '9104',
            BankName__c = '大分県農業協同組合',
            BankName_Kana__c = 'ｵｵｲﾀｹﾝﾉｳｷﾖｳ',
            BranchCode__c = '120',
            BranchName__c = '豊後高田支店',
            BranchName_Kana__c = 'ﾌﾞﾝｺﾞﾀｶﾀ'
        );
        bankMasterList.add(bankMaster3);
        insert bankMasterList;

        return bankMasterList;
    }

    static Map<String,BankMaster__c> getBankMasterValue(List<BankMaster__c> bankMasterList){
        
        Map<String,BankMaster__c> bankMasterMap = new Map<String,BankMaster__c>();
        for(BankMaster__c bMaster : bankMasterList){
            bankMasterMap.put(bMaster.BankCode__c + bMaster.BranchCode__c,bMaster);
        }
        return bankMasterMap;
    }
}