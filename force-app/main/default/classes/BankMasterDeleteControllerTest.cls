@isTest
public class BankMasterDeleteControllerTest {
    
    @IsTest
    static void deleteBankMaster(){
        
        Test.startTest();
        List<BankMaster__c> bankMasterList = createBankMasterTestData();
        Test.stopTest();

        Apexpages.StandardSetController stdController = new Apexpages.StandardSetController(bankMasterList);
        BankMasterDeleteController controller = new BankMasterDeleteController(stdController);
        String initialBatchStatus = controller.getJobStatus();
        System.assertEquals('バッチ（削除）処理がまだ開始されていません。', initialBatchStatus);
        controller.deleteBankMaster();
        String currentBatchStatus = controller.getJobStatus();
        if([SELECT Status FROM AsyncApexJob WHERE Id =: controller.jobId].get(0).Status != 'Completed'){
            System.assertEquals('バッチ処理中です。少々お待ちください。', currentBatchStatus);
        }else{
            System.assertEquals('バッチ処理完了されました。', currentBatchStatus);
        }
    }

    @IsTest
    static void cancelDeleteBankMaster(){
        
        Test.startTest();
        List<BankMaster__c> bankMasterList = createBankMasterTestData();
        Test.stopTest();

        Apexpages.StandardSetController stdController = new Apexpages.StandardSetController(bankMasterList);
        BankMasterDeleteController controller = new BankMasterDeleteController(stdController);
        String initialBatchStatus = controller.getJobStatus();
        System.assertEquals('バッチ（削除）処理がまだ開始されていません。', initialBatchStatus);
        controller.cancel();
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

}