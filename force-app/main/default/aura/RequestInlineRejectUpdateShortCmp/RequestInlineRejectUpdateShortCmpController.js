({
	saveInlineRejectUpdateShort : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
        obj.ChangedPrefecture__c = cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c;
		obj.ChangedAddress1__c = cmp.get("v.innerCmpNewRequest").ChangedAddress1__c;
		obj.ChangedMunicipality__c = cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c;
        obj.Memo__c = cmp.get("v.innerCmpNewRequest").Memo__c;		
		obj.OtherOrderFlag__c = cmp.get("v.innerCmpNewRequest").OtherOrderFlag__c;
		obj.OtherRequests__c = cmp.get("v.innerCmpNewRequest").OtherRequests__c;
		obj.DetailsOfOtherRequestReasons__c = cmp.get("v.innerCmpNewRequest").DetailsOfOtherRequestReasons__c;
		obj.ReturnContact__c = cmp.get("v.innerCmpNewRequest").ReturnContact__c;
		obj.ReturnDestinationName__c = cmp.get("v.innerCmpNewRequest").ReturnDestinationName__c;
		obj.EmergencyFlag__c = cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
		obj.CallBackStartTime__c = cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
		obj.CallBackEndTime__c = cmp.get("v.innerCmpNewRequest").CallBackEndTime__c;
		obj.OtherOrderDocFlag__c = cmp.get("v.innerCmpNewRequest").OtherOrderDocFlag__c;
		obj.OtherDocumentsToSend__c = cmp.get("v.lstOtherDocumentsToSend");
		obj.SendingReason__c = cmp.get("v.innerCmpNewRequest").SendingReason__c;
		obj.OtherDocumentsAndRemarks__c = cmp.get("v.innerCmpNewRequest").OtherDocumentsAndRemarks__c;
		obj.WhetherDestinationInformationChanged__c = cmp.get("v.innerCmpNewRequest").WhetherDestinationInformationChanged__c;
		obj.PersonToBeChanged__c = cmp.get("v.innerCmpNewRequest").PersonToBeChanged__c;
		obj.ChangePoint__c = cmp.get("v.innerCmpNewRequest").ChangePoint__c;
		obj.FullNameKanjiAfterChange__c = cmp.get("v.innerCmpNewRequest").FullNameKanjiAfterChange__c;
		obj.FullNameKanaAfterChange__c = cmp.get("v.innerCmpNewRequest").FullNameKanaAfterChange__c;
		obj.ChangedPostNumber__c = cmp.get("v.innerCmpNewRequest").ChangedPostNumber__c;
		obj.ChangedAddress2__c = cmp.get("v.innerCmpNewRequest").ChangedAddress2__c;
		obj.ReflectMailingAddress__c = cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
		obj.PhoneNumberAfterChange__c = cmp.get("v.innerCmpNewRequest").PhoneNumberAfterChange__c;
		obj.ChangedMailAddress__c = cmp.get("v.innerCmpNewRequest").ChangedMailAddress__c;
		obj.ChangedPetInformation__c = cmp.get("v.innerCmpNewRequest").ChangedPetInformation__c;
		obj.OtherChanges__c = cmp.get("v.innerCmpNewRequest").OtherChanges__c;
		obj.Notices__c = cmp.get("v.innerCmpNewRequest").Notices__c;
	},
    handleAreaInfo : function(cmp,event,helper){
	
		 cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c='';
		 cmp.get("v.innerCmpNewRequest").ChangedAddress1__c='';
		 cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c='';
		helper.areaInfo(cmp, event);             
    },
    init : function(component,event,helper){	
        var dependantSubject = component.get('v.dependantSubject');	
		helper.getMemoPicklist(component, event,dependantSubject);	
		helper.getOtherOrderFlagPicklist(component, event);
		helper.getOtherOrderDocFlagPicklist(component, event);        
		helper.getSendingReasonPicklist(component, event);
		helper.getWhetherDestinationInformationChangedPicklist(component, event);		
		helper.getOtherRequestsPickList(component, event);
		helper.getOtherDocumentsToSendPicklist(component, event);
		helper.getPersonToBeChangedPicklist(component, event);
		helper.getChangePointPicklist(component, event);
        component.set("v.innerCmpNewRequest.OtherOrderFlag__c",'無');
        component.set("v.innerCmpNewRequest.OtherOrderDocFlag__c",'無');
        //component.set("v.innerCmpNewRequest.OtherDocumentsToSend__c",'無');
        component.set("v.innerCmpNewRequest.WhetherDestinationInformationChanged__c",'無');
    },
      handleMemoPick: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    
    handleOtherOrderFlagPick: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleOtherOrderDocFlagPick: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleWhetherDestinationInformationChangedPick: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleSendingReasonPick: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleOtherRequestsPickListChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleOtherDocumentsToSendPicklistChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleChangePointPicklistChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handlePersonToBeChangedPicklistChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    }
})