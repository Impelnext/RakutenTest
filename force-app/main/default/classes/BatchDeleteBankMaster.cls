/*
* @Class Name      : BatchDeleteBankMaster
* @Description     : 金融機関マスタを削除するバッチ
* @Created Date    : 2020.01.21
* @Created By      : R.Karthikeyan
* @Modified Date   : 
* @Modified        : 
*/

global class BatchDeleteBankMaster implements Database.Batchable<SObject>, Database.Stateful{

    public BatchDeleteBankMaster() {
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT ID FROM BankMaster__c';
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc,List<BankMaster__c> bankMasterList){
        Database.delete(bankMasterList);
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){
    }

}