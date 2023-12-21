({
	saveInlineIssuanceOfSusCertificate : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.IssueDate__c 					= cmp.get("v.innerCmpNewRequest").IssueDate__c;		
		obj.OtherInfomation__c 				= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;		
	},
    init : function(component,event,helper){
        			
		helper.getIssueDatePicklist(component, event);		
    }
         
})