/*
* @Class Name      : BatchDeleteAgentConversionWK
* @Description     : 代理店変換WKを削除するバッチ
* @Created Date    : 2023.03.28
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/

global class BatchDeleteAgentConversionWK implements Database.Batchable<SObject>, Database.Stateful{

    public BatchDeleteAgentConversionWK() {
    }

    /**
     * BatchableインタフェースのStart関数
     ＊ @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT ID FROM agentConversionWK__c';
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc,List<agentConversionWK__c> AgentConversionWKList){
        Database.delete(AgentConversionWKList);
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){
    }

}