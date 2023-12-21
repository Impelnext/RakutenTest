({
   saveInlineChangeOccupationTypeCls : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;  
		obj.DateOfChange__c=cmp.get("v.innerCmpNewRequest").DateOfChange__c;
		obj.ChangeInformation__c=cmp.get("v.innerCmpNewRequest").ChangeInformation__c;
		obj.OtherInfomation__c=cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
		obj.CurrentJob__c=cmp.get("v.innerCmpNewRequest").CurrentJob__c;
		obj.WorkAfterChange__c=cmp.get("v.innerCmpNewRequest").WorkAfterChange__c;
    },
	init : function(component,event,helper){
	    helper.getChangeInformationPicklist(component, event);
	}
})