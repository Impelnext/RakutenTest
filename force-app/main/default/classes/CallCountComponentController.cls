public class CallCountComponentController {
	//コンストラクタ
	public CallCountComponentController (){}
  
	@AuraEnabled
	public static Map<String, Integer> getCallCount(Id recordId) {

        Date recentDate = Date.today().addDays(-30);
        Id parentId = [SELECT AccountId FROM Opportunity WHERE Id = :recordId].AccountId;      

		/***** 20180518 修正　開始 ********/
        /*List<Task> accTaskList = [SELECT Id FROM Task WHERE WhatId = :parentId AND ResultType_Large__c = '発信' AND UlinkCallDate__c != null AND CallDateTime__c >= :recentDate];*/
		List<Task> accTaskList = [SELECT Id FROM Task WHERE AccountId = :parentId AND ResultType_Large__c = '発信' AND CallDateTime__c != null AND CallDateTime__c >= :recentDate];
		/***** 20180518 修正　開始 ********/
        List<Task> oppTaskList = [SELECT Id FROM Task WHERE WhatId = :recordId AND ResultType_Large__c = '発信' AND CallDateTime__c != null];
		
        Map<String, Integer> retMap = new Map<String, Integer>();
        
		retMap.put('totalCount',	accTaskList.size());
		retMap.put('oppCount',		oppTaskList.size());
        
		return retMap;
	}
}