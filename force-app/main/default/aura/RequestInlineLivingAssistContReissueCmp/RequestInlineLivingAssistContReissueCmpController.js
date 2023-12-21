({
	saveInlineLivingAssistContReissue : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.MyPageProposal__c 					= cmp.get("v.innerCmpNewRequest").MyPageProposal__c;		
		obj.ChangeHistory__c 					= cmp.get("v.innerCmpNewRequest").ChangeHistory__c;
		obj.Issue__c 							= cmp.get("v.innerCmpNewRequest").Issue__c;
		obj.OtherSecuritiesNumber1__c 			= cmp.get("v.innerCmpNewRequest").OtherSecuritiesNumber1__c;
		obj.TargetEndorsementNumber1__c 		= cmp.get("v.innerCmpNewRequest").TargetEndorsementNumber1__c;
		obj.OtherSecuritiesNumber2__c 			= cmp.get("v.innerCmpNewRequest").OtherSecuritiesNumber2__c;
		obj.TargetEndorsementNumber2__c 		= cmp.get("v.innerCmpNewRequest").TargetEndorsementNumber2__c;
		obj.OtherSecuritiesNumber3__c 			= cmp.get("v.innerCmpNewRequest").OtherSecuritiesNumber3__c;
		obj.TargetEndorsementNumber3__c 		= cmp.get("v.innerCmpNewRequest").TargetEndorsementNumber3__c;
		obj.OtherSecuritiesNumber4__c 			= cmp.get("v.innerCmpNewRequest").OtherSecuritiesNumber4__c;
		obj.TargetEndorsementNumber4__c 		= cmp.get("v.innerCmpNewRequest").TargetEndorsementNumber4__c;
		obj.OtherSecuritiesNumber5__c 			= cmp.get("v.innerCmpNewRequest").OtherSecuritiesNumber5__c;
		obj.TargetEndorsementNumber5__c 		= cmp.get("v.innerCmpNewRequest").TargetEndorsementNumber5__c;
		obj.OtherInfomation__c 					= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;		
	},
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');			
		helper.getMyPageProposalPicklist(component, event);
		helper.getChangeHistoryPicklist(component, event);		
        helper.getIssuePicklist(component, event,dependantSubject);
		
    }
   
})