/*
* @Class Name      : BatchSyotanDocRequestCaseCreation 
* @Description     : 少短資料請求用のケース作成バッチ
* @Created Date    : 2019.06.20
* @Created By      : R,Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/

global class BatchSyotanDocRequestCaseCreation implements Database.Batchable<SObject>, Database.Stateful{

    //バッチ起動制御オブジェクトの処理IDを格納
    public String batchControlJobId{get;set;}
    //バッチ起動制御オブジェクトの処理名を格納
    public String batchJobName{get;set;}
    //バッチ対象の少短資料請求レコードの総件数を格納
    public Integer syotanDocumentRecordCount{get;set;}
    //新規に作られたケースの総件数
    public Integer caseCreatedCount{get;set;}
    //バッチ処理済フラグ
    public boolean batchProcessedFlag{get;set;}
    //バッチ処理中の例外発生管理フラグ
    public boolean batchExceptionFlag{get;set;}

    public BatchSyotanDocRequestCaseCreation(String jobId,String jobName) {
        System.debug('### Syotan Doc batch invoked');
        batchControlJobId = jobId;
        syotanDocumentRecordCount = 0;
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
        String query = 'SELECT ID, caseCreationFlag__c, request_id__c, Ref_Account__c, request_date__c, zip_code1__c, address_kana__c FROM SyotanDocumentRequests__c WHERE caseCreationFlag__c = true';
        List<SyotanDocumentRequests__c> syotanDocList = Database.query(query);
        if(syotanDocList != null && syotanDocList.size() > 0){
            syotanDocumentRecordCount = syotanDocList.size();
        }
        System.debug('### syotanDocumentRecordCount' +syotanDocumentRecordCount);
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<SyotanDocumentRequests__c> syotanDocRequestList){

        //ケース挿入リスト
        List<Case> insertTargetCaseList = new List<Case>();

        // ケース（資料請求（生命））のレコードタイプID
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LittleLead_Call').getRecordTypeId();

        Set<Id> accIdSet = new Set<Id>();
        for(SyotanDocumentRequests__c syotanDoc : syotanDocRequestList){
            accIdSet.add(syotanDoc.Ref_Account__c);
        }

        batchProcessedFlag = true;

        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, PersonContactId FROM Account WHERE ID IN: accIdSet]);
        for (SyotanDocumentRequests__c syotanDoc : syotanDocRequestList) {
            //ケースの新規作成
            Case targetCase = new Case();
            targetCase.RecordTypeId = caseRecordTypeId;
            targetCase.AccountId = syotanDoc.Ref_Account__c;
            targetCase.ContactId = accountMap.get(syotanDoc.Ref_Account__c).PersonContactId;
            //対応区分
            targetCase.class__c = 'セールス専用ケース';
            //対応種別
            targetCase.type__c = '少短_資料請求';
            // 発生源
            targetCase.Origin = 'Web';
            // 状況
            targetCase.Status = 'オープン';
            // 資料請求ID
            targetCase.DataRequestID__c = syotanDoc.request_id__c;
            // 郵便番号
            //20190821 誤って変更後郵便番号に設定しているためコメントアウト START
            //targetCase.PostNumber__c = syotanDoc.zip_code1__c;
            //20190821 誤って変更後郵便番号に設定しているためコメントアウト END
            // 住所（ﾌﾘｶﾞﾅ）
            targetCase.AddressKana__c = syotanDoc.address_kana__c;
            // 資料請求日時
            targetCase.DocumentRequestDateTime__c = syotanDoc.request_date__c != null ? DateTime.newInstance(syotanDoc.request_date__c.year(),syotanDoc.request_date__c.month(),syotanDoc.request_date__c.day()) : null;

            //エラー発生パターンのテストコード用ロジック
            if(Test.isRunningTest() && BatchRunControlTriggerTest.faliureCaseFlag){
                targetCase.ParentId = '5000l000003ohW8AAB';
            }

            //少短資料請求のケースフラグをOFFにする
            syotanDoc.caseCreationFlag__c = false;
            
            insertTargetCaseList.add(targetCase);
        }

        System.debug('### insertTargetCaseList' + insertTargetCaseList);
        System.debug('### syotanDocRequestList' + syotanDocRequestList);

        try{
            insert insertTargetCaseList;
            caseCreatedCount += insertTargetCaseList.size();

            System.debug('### caseCreatedCount ' + caseCreatedCount);

            //ケース作成フラグをFALSEに更新
            update syotanDocRequestList;
        }catch(Exception e){
            batchExceptionFlag = true;
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '2', e.getMessage(), batchJobName, syotanDocumentRecordCount, caseCreatedCount);
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){

        System.debug('### finish method');
        if(batchProcessedFlag && !batchExceptionFlag)
            //成功ステータスを更新
            BatchCaseCreationHelper.updateBatchRunStatus(batchControlJobId, '1', null,batchJobName, syotanDocumentRecordCount, caseCreatedCount);
    }
}