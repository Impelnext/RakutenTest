/*
* @Class Name      : BatchLifeContractBankNameUpdate
* @Description     : 生保契約の金融機関名を更新するバッチ
* @Created Date    : 2020.03.15
* @Created By      : R,Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/

global class BatchLifeContractBankNameUpdate implements Database.Batchable<SObject>,Database.Stateful{

    //バッチ起動制御オブジェクトの処理IDを格納
    public String batchControlJobId{get;set;}
    //バッチ起動制御オブジェクトの処理名を格納
    public String batchJobName{get;set;}
    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}
    //バッチ対象の生保契約レコードの総件数を格納
    public Integer lifeContractRecordCount{get;set;}
    //更新されたレコードの総件数
    public Integer updateRecordCount{get;set;}

    public BatchLifeContractBankNameUpdate(String jobId, String jobName) {
        batchControlJobId = jobId;
        batchJobName = jobName;
        lifeContractRecordCount = 0;
        updateRecordCount = 0;
        batchProcessedFlag = false;
        batchExceptionFlag = false;
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){

        String query = 'SELECT Id, FNANCIAL_CODE__c, FNANCIAL_NAME__c, FINANCIAL_BRANCH_CODE__c, FINANCIAL_BRANCH_NAME__c, TOTAL_INS_FINANCIAL_CODE__c, TOTAL_INS_FINANCIAL_NAME__c, TOTAL_INS_FINANCIAL_BRANCH_CODE__c, TOTAL_INS_FINANCIAL_BRANCH_NAME__c, ';
               query += 'setBankNameFlag__c FROM LifeContract__c WHERE setBankNameFlag__c = true';

        Integer lifeContractRecordCount  = [SELECT count() FROM LifeContract__c WHERE setBankNameFlag__c = true];

        System.debug('lifeContractRecordCount ' + lifeContractRecordCount);
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param List<LifeContract__c>
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<LifeContract__c> lifeContractList){

        batchProcessedFlag = true;
        //生保契約の金融機関コードを格納
        Set<String> bankCodeSet = new Set<String>();
        //生保契約の金融機関支店コードを格納
        Set<String> branchCodeSet = new Set<String>();
        //生保契約の支払先金融機関コードを格納
        Set<String> totalInsBankCode = new Set<String>();
        //生保契約の支払先金融機関支店コードを格納
        Set<String> totalInsBranchCode = new Set<String>();
        Map<String,BankMaster__c> bankMasterMap = new Map<String,BankMaster__c>();
        for(LifeContract__c life : lifeContractList){
            bankCodeSet.add(life.FNANCIAL_CODE__c);
            branchCodeSet.add(life.FINANCIAL_BRANCH_CODE__c);
            //totalInsBankCode.add(life.TOTAL_INS_FINANCIAL_CODE__c);
            //totalInsBranchCode.add(life.TOTAL_INS_FINANCIAL_BRANCH_CODE__c);
            bankCodeSet.add(life.TOTAL_INS_FINANCIAL_CODE__c);
            branchCodeSet.add(life.TOTAL_INS_FINANCIAL_BRANCH_CODE__c);
        }

        for(BankMaster__c bankMaster : [SELECT BankCode__c, BranchCode__c, BankName__c, BranchName__c FROM BankMaster__c WHERE BankCode__c IN: bankCodeSet AND BranchCode__c IN: branchCodeSet]){
            bankMasterMap.put(bankMaster.BankCode__c + bankMaster.BranchCode__c, bankMaster);
        }

        for(LifeContract__c lifeCon : lifeContractList){
            //金融機関名称をセットする
            lifeCon.FNANCIAL_NAME__c = bankMasterMap.get(lifeCon.FNANCIAL_CODE__c + lifeCon.FINANCIAL_BRANCH_CODE__c) != null ? bankMasterMap.get(lifeCon.FNANCIAL_CODE__c + lifeCon.FINANCIAL_BRANCH_CODE__c).BankName__c : null;
            lifeCon.FINANCIAL_BRANCH_NAME__c = bankMasterMap.get(lifeCon.FNANCIAL_CODE__c + lifeCon.FINANCIAL_BRANCH_CODE__c) != null ? bankMasterMap.get(lifeCon.FNANCIAL_CODE__c + lifeCon.FINANCIAL_BRANCH_CODE__c).BranchName__c : null;
            //支払先金融機関名称をセットする
            lifeCon.TOTAL_INS_FINANCIAL_NAME__c = bankMasterMap.get(lifeCon.TOTAL_INS_FINANCIAL_CODE__c + lifeCon.TOTAL_INS_FINANCIAL_BRANCH_CODE__c) != null ? bankMasterMap.get(lifeCon.TOTAL_INS_FINANCIAL_CODE__c + lifeCon.TOTAL_INS_FINANCIAL_BRANCH_CODE__c).BankName__c : null;
            lifeCon.TOTAL_INS_FINANCIAL_BRANCH_NAME__c = bankMasterMap.get(lifeCon.TOTAL_INS_FINANCIAL_CODE__c + lifeCon.TOTAL_INS_FINANCIAL_BRANCH_CODE__c) != null ? bankMasterMap.get(lifeCon.TOTAL_INS_FINANCIAL_CODE__c + lifeCon.TOTAL_INS_FINANCIAL_BRANCH_CODE__c).BranchName__c : null;
            lifeCon.setBankNameFlag__c = false;
        }

        try {
            UPDATE lifeContractList;
            updateRecordCount += lifeContractList.size();
        } catch (Exception e) {
            batchExceptionFlag = true;
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '2', e.getMessage(), batchJobName, lifeContractRecordCount, updateRecordCount);
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){

        if(batchProcessedFlag && !batchExceptionFlag)
            //成功ステータスを更新
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '1', null,batchJobName, lifeContractRecordCount, updateRecordCount);
    }    
}