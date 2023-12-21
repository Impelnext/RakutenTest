/*
* @Class Name      : Patch_Onyx_UpdateAccount
* @Description     : 生保契約
* @Created Date    : 2020.07.07
* @Created By      : SRM
* @Modified Date   : 
* @Modified        : 
*/

global class Patch_Onyx_UpdateAccount implements Database.Batchable<SObject>,Database.Stateful{
    
    public Patch_Onyx_UpdateAccount() {}
    
    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id,AccountId__c FROM LifeContract__c WHERE AccountId__c != Null';
        return Database.getQueryLocator(query);
    }
    
    
    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param List<LifeContract__c>
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<LifeContract__c> lifeContractList){
        Set<Id> accountIds = new Set<Id>();
        for(LifeContract__c life : lifeContractList){
            accountIds.add(life.AccountId__c);
        }
        
        List<Account> accountList = [SELECT Id,seihoAccoutType__c FROM Account WHERE Id IN: accountIds];
        for(Account acc : accountList){
            if(acc.SeihoAccoutType__c != null){
                if(!acc.seihoAccoutType__c.containsIgnoreCase('生保契約者')){
                    acc.seihoAccoutType__c = acc.seihoAccoutType__c+';'+'生保契約者';
                }
            }else{
                acc.seihoAccoutType__c = '生保契約者';
            }
        }
        
        update accountList;
    }
    
    
    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){
    }
}