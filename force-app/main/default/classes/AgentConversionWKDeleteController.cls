public with sharing class AgentConversionWKDeleteController {

    ApexPages.StandardSetController stdController;

    BatchDeleteAgentConversionWK AgentConversionWKDel;

    public String message{get;set;}
    public boolean batchStarted{get;set;}
    public String jobId{get;set;} 

    public AgentConversionWKDeleteController(ApexPages.StandardSetController sc) {
        this.AgentConversionWKDel = new BatchDeleteAgentConversionWK();
        this.stdController = sc;
        batchStarted = false;
    }

    public String getJobStatus(){
        if(batchStarted){
            List<AsyncApexJob> batchJob = [SELECT Id, Status FROM AsyncApexJob WHERE ID =: jobId];
            if(batchJob != null && batchJob.size() > 0){
                if(batchJob.get(0).Status != 'Completed'){
                    message = 'バッチ処理中です。少々お待ちください。';
                }else if(batchJob.get(0).Status != 'Failed'){
                    message = 'バッチ処理にエラーが発生されました。';
                }else{
                    message = 'バッチ処理完了されました。';
                }
            }
        }else{
            message = 'バッチ（削除）処理がまだ開始されていません。';
        }
        return message;
    }

    public Pagereference deleteAgentConversionWK(){
        AgentConversionWKDel = new BatchDeleteAgentConversionWK();
        jobId = Database.executeBatch(AgentConversionWKDel,200);
        if(jobId != '000000000000000')
            batchStarted = true;

        return null;
    }

    public Pagereference cancel(){
        return stdController.cancel();
    }
}