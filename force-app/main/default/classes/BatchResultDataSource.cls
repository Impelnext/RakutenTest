global class BatchResultDataSource implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            SELECT Id, Data_Source__c, AccountId__c
            FROM Work1__c
            WHERE Data_Source__c != null AND AccountId__c != null
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Work1__c> scope){
        Map<Id, Integer> lifeCountMap = new Map<Id, Integer>();
        Map<Id, Integer> damageCountMap = new Map<Id, Integer>();
        Map<Id, Integer> littleCountMap = new Map<Id, Integer>();
        
        // Calculate counts per AccountId
        for(Work1__c w : scope){
            Id accountId = w.AccountId__c;
            String source = w.Data_Source__c;
            
            if(source == 'Life'){
                lifeCountMap.put(accountId, lifeCountMap.containsKey(accountId) ? lifeCountMap.get(accountId) + 1 : 1);
            } else if(source == 'Damage'){
                damageCountMap.put(accountId, damageCountMap.containsKey(accountId) ? damageCountMap.get(accountId) + 1 : 1);
            } else if(source == 'little'){
                littleCountMap.put(accountId, littleCountMap.containsKey(accountId) ? littleCountMap.get(accountId) + 1 : 1);
            }
            system.debug('CountLife'+ lifeCountMap);
            system.debug('CountDamage'+ damageCountMap);
            system.debug('CountLittle'+ littleCountMap);
        }
        
        // Prepare Result records
        List<Result__c> resultsToUpsert = new List<Result__c>();
        for(Id accountId : lifeCountMap.keySet()){
            Result__c result = new Result__c();
            result.AccountId__c = accountId;
            result.CountLife__c = lifeCountMap.get(accountId) != null ? lifeCountMap.get(accountId) : 0;
            system.debug('CountLife__c'+ result.CountLife__c);
            result.CountDamage__c = damageCountMap.get(accountId) != null ? damageCountMap.get(accountId) : 0;
            system.debug('CountDamage__c'+ result.CountDamage__c);
            result.CountLittle__c = littleCountMap.get(accountId) != null ? littleCountMap.get(accountId) : 0;
            system.debug('CountLittle__c'+ result.CountLittle__c);
            
            resultsToUpsert.add(result);
        }
        
        // Insert
        insert resultsToUpsert;
    }
    
    global void finish(Database.BatchableContext BC){}
}