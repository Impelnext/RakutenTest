({
	saveInlineStructuralUsageAreaChngCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.DateOfChange__c= cmp.get("v.innerCmpNewRequest").DateOfChange__c;
		obj.Use__c= cmp.get("v.innerCmpNewRequest").Use__c;
		obj.PropertyWithStoreInBuildingIndustry__c= cmp.get("v.innerCmpNewRequest").PropertyWithStoreInBuildingIndustry__c;
		obj.Construction__c= cmp.get("v.innerCmpNewRequest").Construction__c;
		obj.Area_m2__c= cmp.get("v.innerCmpNewRequest").Area_m2__c;
		obj.OtherInfomation__c= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
	},
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getUsePicklist(component, event,dependantSubject);
		helper.getconstructionPicklist(component, event);
    }
})