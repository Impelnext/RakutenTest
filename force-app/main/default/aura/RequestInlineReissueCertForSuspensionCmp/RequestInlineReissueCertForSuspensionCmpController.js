({
	saveInlineReissueCertForSuspension : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.PastIssueHistory__c 			= cmp.get("v.innerCmpNewRequest").PastIssueHistory__c;		
		obj.OtherInfomation__c 				= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;		
	},
    init : function(component,event,helper){       			
		helper.getPastIssueHistoryPicklist(component, event);		
    }
         
})