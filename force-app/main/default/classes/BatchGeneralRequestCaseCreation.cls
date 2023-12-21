/*
* @Class Name      : BatchSyotanDocRequestCaseCreation 
* @Description     : 少短資料請求用のケース作成バッチ
* @Created Date    : 2019.06.20
* @Created By      : R,Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/

global class BatchGeneralRequestCaseCreation implements Database.Batchable<SObject>, Database.Stateful{
    
    //バッチ起動制御オブジェクトの処理IDを格納
    public String batchControlJobId{get;set;}
    //バッチ起動制御オブジェクトの処理名を格納
    public String batchJobName{get;set;}
    //バッチ対象の少短資料請求レコードの総件数を格納
    public Integer generalRequestRecordCount{get;set;}
    //新規に作られたケースの総件数
    public Integer caseCreatedCount{get;set;}
    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}
    
    public BatchGeneralRequestCaseCreation(String jobId,String jobName) {
        batchControlJobId = jobId;
        generalRequestRecordCount = 0;
        caseCreatedCount = 0;
        batchJobName = jobName;
        batchProcessedFlag = false;
        batchExceptionFlag = false;
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT ID, caseCreationFlag__c, Name, Ref_Account__c, address__c FROM GeneralRequest__c WHERE caseCreationFlag__c = TRUE';
        List<GeneralRequest__c> generalReqList = Database.query(query);
        if(generalReqList != null && generalReqList.size() > 0){
            generalRequestRecordCount = generalReqList.size();
        }
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<GeneralRequest__c> generalRequestList){

        //ケース挿入リスト
        List<Case> insertTargetCaseList = new List<Case>();

        // ケース（損保_ミドル連携）のレコードタイプID
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sonpo_Middle').getRecordTypeId();

        Set<Id> accIdSet = new Set<Id>();
        for(GeneralRequest__c generalReq : generalRequestList){
            accIdSet.add(generalReq.Ref_Account__c);
        }

        batchProcessedFlag = true;

        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, PersonContactId FROM Account WHERE ID IN: accIdSet]);
        for (GeneralRequest__c generalReq : generalRequestList) {
            //ケースの新規作成
            Case targetCase = new Case();
            targetCase.RecordTypeId = caseRecordTypeId;
            targetCase.AccountId = generalReq.Ref_Account__c;
            targetCase.ContactId = accountMap.get(generalReq.Ref_Account__c).PersonContactId;
            //対応区分
            targetCase.class__c = 'セールス専用ケース';
            //対応種別
            targetCase.type__c = '損保_ミドル連携';
            // 発生源
            targetCase.Origin = 'Web';
            // 状況
            targetCase.Status = 'オープン';
            // 資料請求ID
            targetCase.DataRequestID__c = generalReq.Name;
            // 住所（ﾌﾘｶﾞﾅ）
            targetCase.AddressKana__c = generalReq.address__c;

            //エラー発生パターンのテストコード用ロジック
            if(Test.isRunningTest() && BatchRunControlTriggerTest.faliureCaseFlag){
                targetCase.ParentId = '5000l000003ohW8AAB';
            }
            
            //少短資料請求のケースフラグをOFFにする
            generalReq.caseCreationFlag__c = false;
            
            insertTargetCaseList.add(targetCase);
        }

        try{
            insert insertTargetCaseList;
            caseCreatedCount += insertTargetCaseList.size();

            //ケース作成フラグをFALSEに更新
            update generalRequestList;
        }catch(Exception e){
            batchExceptionFlag = true;
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '2', e.getMessage(), batchJobName, generalRequestRecordCount, caseCreatedCount);
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
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '1', null,batchJobName, generalRequestRecordCount, caseCreatedCount);
    }
}