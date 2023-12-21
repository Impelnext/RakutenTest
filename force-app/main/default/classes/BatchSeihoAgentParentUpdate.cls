/*
* @Class Name      : BatchSeihoAgentParentUpdate
* @Description     : 生保エージェントマスタの所属エージェントをセットするバッチ
* @Created Date    : 2020.06.04
* @Created By      : SRM
* @Modified Date   : 2020.06.04
* @Modified        : SRM
*/

global class BatchSeihoAgentParentUpdate implements Database.Batchable<SObject>,Database.Stateful{

    //バッチ起動制御オブジェクトの処理IDを格納
    public String batchControlJobId{get;set;}
    //バッチ起動制御オブジェクトの処理名を格納
    public String batchJobName{get;set;}
    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}
    //バッチ対象の生保エージェントマスタレコードの総件数を格納
    public Integer seihoAgentRecordCount{get;set;}
    //更新されたレコードの総件数
    public Integer updateRecordCount{get;set;}
    
     public BatchSeihoAgentParentUpdate(String jobId, String jobName) {
        batchControlJobId = jobId;
        batchJobName = jobName;
        seihoAgentRecordCount = 0;
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
 
        String  query = 'SELECT Id,SeihoAgentParentFlag__c,BELONG_AGENT__c,SeihoAgentParent__c FROM SeihoAgentMaster__c WHERE SeihoAgentParentFlag__c = true';

        Integer seihoAgentRecordCount  = [SELECT count() FROM SeihoAgentMaster__c WHERE SeihoAgentParentFlag__c = true];

        System.debug('seihoAgentRecordCount ' + seihoAgentRecordCount);
        return Database.getQueryLocator(query);
    }

    /**
    * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param List<SeihoAgentMaster__c>
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<SeihoAgentMaster__c> seihoAgentMasterList){

        batchProcessedFlag = true;
        Set<String> belongAgentIdSet = new Set<String>(); 
        for(SeihoAgentMaster__c seihoAgent : seihoAgentMasterList){ 
            belongAgentIdSet.add(seihoAgent.BELONG_AGENT__c);
        }
      	Map<String,SeihoAgentMaster__c> SeihoAgentMasterMap = MasterHelper.getSeihoAgentMasterFromBelongAgentId(belongAgentIdSet);
        for(SeihoAgentMaster__c seihoAgent : seihoAgentMasterList){ 
            seihoAgent.SeihoAgentParent__c = SeihoAgentMasterMap.get(seihoAgent.BELONG_AGENT__c) != null ?  SeihoAgentMasterMap.get(seihoAgent.BELONG_AGENT__c).Id : null;
            seihoAgent.SeihoAgentParentFlag__c = false;  
            //system.debug('parent'+seihoAgent.SeihoAgentParentFlag__c);
            //system.debug('parent'+seihoAgent.SeihoAgentParent__c);
        }
        try {
            UPDATE seihoAgentMasterList;
           // system.debug('listParent'+[select SeihoAgentParentFlag__c,SeihoAgentParent__c from SeihoAgentMaster__c]);
            updateRecordCount += seihoAgentMasterList.size();
        } catch (Exception e) {
            batchExceptionFlag = true;
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '2', e.getMessage(), batchJobName, seihoAgentRecordCount, updateRecordCount);
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){

        if(batchProcessedFlag && !batchExceptionFlag)
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '1', null,batchJobName, seihoAgentRecordCount, updateRecordCount);
    }
}