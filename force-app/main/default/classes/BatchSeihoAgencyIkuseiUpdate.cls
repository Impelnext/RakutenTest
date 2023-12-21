/*
* @Class Name      : BatchSeihoAgencyIkuseiUpdate
* @Description     : 生保代理店に所属管下代理店をセットするバッチ
* @Created Date    : 2020.06.04
* @Created By      : SRM
* @Modified Date   : 
* @Modified        : 
*/

global class BatchSeihoAgencyIkuseiUpdate implements Database.Batchable<SObject>,Database.Stateful{

    //バッチ起動制御オブジェクトの処理IDを格納
    public String batchControlJobId{get;set;}
    //バッチ起動制御オブジェクトの処理名を格納
    public String batchJobName{get;set;}
    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}
    //バッチ対象の生保代理店レコードの総件数を格納
    public Integer seihoAgencyRecordCount{get;set;}
    //更新されたレコードの総件数
    public Integer updateRecordCount{get;set;}
    
     public BatchSeihoAgencyIkuseiUpdate(String jobId, String jobName) {
        batchControlJobId = jobId;
        batchJobName = jobName;
        seihoAgencyRecordCount = 0;
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

        String  query = 'SELECT Id,AgencyNameFlag__c,tantoupbragncyno__c,SeihoAgencyIkusei__c,agncyno__c FROM SeihoAgencyMaster__c WHERE AgencyNameFlag__c = true';

        Integer SeihoAgencyRecordCount  = [SELECT count() FROM SeihoAgencyMaster__c WHERE AgencyNameFlag__c = true];

        System.debug('SeihoAgencyRecordCount ' + SeihoAgencyRecordCount);
        return Database.getQueryLocator(query);
    }
    
    /** 
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param List<SeihoAgencyMaster__c>
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<seihoAgencyMaster__c> seihoAgencyMasterList){

        batchProcessedFlag = true;
        Set<String> tantoupbrAgncynoSet = new Set<String>();
        for(SeihoAgencyMaster__c seihoAgency : seihoAgencyMasterList){
            tantoupbrAgncynoSet.add(seihoAgency.tantoupbragncyno__c);
        }
        Map<String,seihoAgencyMaster__c> seihoAgencyMasterMap = MasterHelper.getSeihoAgencyMasterFromAgencyNo(tantoupbrAgncynoSet);
        for(seihoAgencyMaster__c seihoAgency : seihoAgencyMasterList){
            seihoAgency.seihoAgencyIkusei__c = seihoAgencyMasterMap.get(seihoAgency.tantoupbragncyno__c) != null ?  seihoAgencyMasterMap.get(seihoAgency.tantoupbragncyno__c).Id : null;
            seihoAgency.AgencyNameFlag__c = false;
        }
        try {
            UPDATE seihoAgencyMasterList;
            updateRecordCount += seihoAgencyMasterList.size();
        } catch (Exception e) {
            batchExceptionFlag = true;
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '2', e.getMessage(), batchJobName, seihoAgencyRecordCount, updateRecordCount);
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){

        if(batchProcessedFlag && !batchExceptionFlag)
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '1', null,batchJobName, seihoAgencyRecordCount, updateRecordCount);
    }
}