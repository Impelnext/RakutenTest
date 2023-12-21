({
	saveInlineGradeCorrectionCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.CorrectionDetails__c= cmp.get("v.innerCmpNewRequest").CorrectionDetails__c;
		obj.TargetSecuritiesNumber1__c= cmp.get("v.innerCmpNewRequest").TargetSecuritiesNumber1__c;
		obj.TargetSecuritiesNumber2__c= cmp.get("v.innerCmpNewRequest").TargetSecuritiesNumber2__c;
		obj.TargetSecuritiesNumber3__c= cmp.get("v.innerCmpNewRequest").TargetSecuritiesNumber3__c;
		obj.OtherInfomation__c= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
	}
})