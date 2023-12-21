@isTest
public class AgentConversionWKDeleteControllerTest {
    
    @IsTest
    static void deleteAgentConversionWK(){
        
        Test.startTest();
        List<agentConversionWK__c> AgentConversionWKList = createAgentConversionWKTestData();
        Test.stopTest();

        Apexpages.StandardSetController stdController = new Apexpages.StandardSetController(AgentConversionWKList);
        AgentConversionWKDeleteController controller = new AgentConversionWKDeleteController(stdController);
        String initialBatchStatus = controller.getJobStatus();
        System.assertEquals('バッチ（削除）処理がまだ開始されていません。', initialBatchStatus);
        controller.deleteAgentConversionWK();
        String currentBatchStatus = controller.getJobStatus();
        if([SELECT Status FROM AsyncApexJob WHERE Id =: controller.jobId].get(0).Status != 'Completed'){
            System.assertEquals('バッチ処理中です。少々お待ちください。', currentBatchStatus);
        }else{
            System.assertEquals('バッチ処理完了されました。', currentBatchStatus);
        }
    }

    @IsTest
    static void cancelDeleteAgentConversionWK(){
        
        Test.startTest();
        List<agentConversionWK__c> AgentConversionWKList = createAgentConversionWKTestData();
        Test.stopTest();

        Apexpages.StandardSetController stdController = new Apexpages.StandardSetController(AgentConversionWKList);
        AgentConversionWKDeleteController controller = new AgentConversionWKDeleteController(stdController);
        String initialBatchStatus = controller.getJobStatus();
        System.assertEquals('バッチ（削除）処理がまだ開始されていません。', initialBatchStatus);
        controller.cancel();
    }

    static List<agentConversionWK__c> createAgentConversionWKTestData(){

        List<agentConversionWK__c> AgentConversionWKList =  new List<agentConversionWK__c>();

        agentConversionWK__c AgentConversionWK1 = new agentConversionWK__c(
            
        );
        AgentConversionWKList.add(AgentConversionWK1);

        agentConversionWK__c AgentConversionWK2 = new agentConversionWK__c(
            
        );
        AgentConversionWKList.add(AgentConversionWK2);

        agentConversionWK__c AgentConversionWK3 = new agentConversionWK__c(
           
        );
        AgentConversionWKList.add(AgentConversionWK3);
        insert AgentConversionWKList;

        return AgentConversionWKList;
    }

}