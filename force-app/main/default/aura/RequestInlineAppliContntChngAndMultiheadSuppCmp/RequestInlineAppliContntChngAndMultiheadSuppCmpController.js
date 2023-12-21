({
	saveRequestInlineAppliContntChngAndMultiheadSuppCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
        obj.ChangedPrefecture__c = cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c;
        obj.ChangedMunicipality__c = cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c;
        obj.ChangedAddress1__c = cmp.get("v.innerCmpNewRequest").ChangedAddress1__c;
		
        obj.Sucject__c= cmp.get("v.innerCmpNewRequest").Sucject__c;
		obj.RequestContents__c= cmp.get("v.innerCmpNewRequest").RequestContents__c;
		obj.DetailsOfOtherRequests__c= cmp.get("v.innerCmpNewRequest").DetailsOfOtherRequests__c;
		obj.OtherOrderFlag__c= cmp.get("v.innerCmpNewRequest").OtherOrderFlag__c;
		obj.OtherRequests__c= cmp.get("v.innerCmpNewRequest").OtherRequests__c;
		obj.DetailsOfOtherRequestReasons__c= cmp.get("v.innerCmpNewRequest").DetailsOfOtherRequestReasons__c;
		obj.ReturnContact__c= cmp.get("v.innerCmpNewRequest").ReturnContact__c;
		obj.ReturnDestinationName__c= cmp.get("v.innerCmpNewRequest").ReturnDestinationName__c;
		obj.EmergencyFlag__c= cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
		obj.CallBackStartTime__c= cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
		obj.CallBackEndTime__c= cmp.get("v.innerCmpNewRequest").CallBackEndTime__c;
		obj.OtherOrderDocFlag__c= cmp.get("v.innerCmpNewRequest").OtherOrderDocFlag__c;
		obj.OtherDocumentsToSend__c= cmp.get("v.lstOtherDocumentsToSend");
		obj.SendingReason__c= cmp.get("v.innerCmpNewRequest").SendingReason__c;
		obj.OtherDocumentsAndRemarks__c= cmp.get("v.innerCmpNewRequest").OtherDocumentsAndRemarks__c;
		obj.WhetherDestinationInformationChanged__c= cmp.get("v.innerCmpNewRequest").WhetherDestinationInformationChanged__c;
		obj.PersonToBeChanged__c= cmp.get("v.innerCmpNewRequest").PersonToBeChanged__c;
		obj.ChangePoint__c= cmp.get("v.innerCmpNewRequest").ChangePoint__c;
		obj.FullNameKanjiAfterChange__c= cmp.get("v.innerCmpNewRequest").FullNameKanjiAfterChange__c;
		obj.FullNameKanaAfterChange__c= cmp.get("v.innerCmpNewRequest").FullNameKanaAfterChange__c;
		obj.ChangedPostNumber__c= cmp.get("v.innerCmpNewRequest").ChangedPostNumber__c;
		obj.ChangedAddress2__c= cmp.get("v.innerCmpNewRequest").ChangedAddress2__c;
		obj.ReflectMailingAddress__c= cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
		obj.PhoneNumberAfterChange__c= cmp.get("v.innerCmpNewRequest").PhoneNumberAfterChange__c;
		obj.ChangedMailAddress__c= cmp.get("v.innerCmpNewRequest").ChangedMailAddress__c;
		obj.ChangedPetInformation__c= cmp.get("v.innerCmpNewRequest").ChangedPetInformation__c;
		obj.OtherChanges__c= cmp.get("v.innerCmpNewRequest").OtherChanges__c;
		obj.OtherRequestReason__c= cmp.get("v.innerCmpNewRequest").OtherRequestReason__c;
		obj.RefundUponCancellationFlag__c= cmp.get("v.innerCmpNewRequest").RefundUponCancellationFlag__c;
		obj.RefundAccountCreditCard__c= cmp.get("v.innerCmpNewRequest").RefundAccountCreditCard__c;
		obj.AccountHolderKana__c= cmp.get("v.innerCmpNewRequest").AccountHolderKana__c;
		obj.AccountHolderKanji__c= cmp.get("v.innerCmpNewRequest").AccountHolderKanji__c;
		obj.FinancialInstitutionSearch__c= cmp.get("v.innerCmpNewRequest").FinancialInstitutionSearch__c;
		obj.FinancialName__c= cmp.get("v.innerCmpNewRequest").FinancialName__c;
		obj.BankCode__c= cmp.get("v.innerCmpNewRequest").BankCode__c;
		obj.BranchName__c= cmp.get("v.innerCmpNewRequest").BranchName__c;
		obj.BranchCodeStoreNumber__c= cmp.get("v.innerCmpNewRequest").BranchCodeStoreNumber__c;
		obj.DepositCategory__c= cmp.get("v.innerCmpNewRequest").DepositCategory__c;
		obj.AccountNumber__c= cmp.get("v.innerCmpNewRequest").AccountNumber__c;
		obj.JapanPostSymbol__c= cmp.get("v.innerCmpNewRequest").JapanPostSymbol__c;
		obj.DirectOwnership__c= cmp.get("v.innerCmpNewRequest").DirectOwnership__c;
		obj.SpecialConsiderationPaidRefundAccount__c= cmp.get("v.innerCmpNewRequest").SpecialConsiderationPaidRefundAccount__c;
		
	},
	handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c = '';
        cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c= '';
        cmp.get("v.innerCmpNewRequest").ChangedAddress1__c='';
        helper.areaInfo(cmp, event);     
    },
	init : function(component,event,helper){
		var dependantSubject = component.get('v.dependantSubject');
		//alert('dependantSubject:'+dependantSubject);
		helper.getRequestContentsPickList(component, event,dependantSubject);
		helper.getOtherOrderFlagPicklist(component, event);
		helper.getOtherOrderDocFlagPicklist(component, event);
		helper.getSendingReasonPicklist(component, event);
		helper.getWhetherDestinationInformationChangedPicklist(component, event);
		helper.getrefundAccountCreditCardPicklist(component, event, dependantSubject);
		helper.getdepositCategoryPicklist(component, event);

		helper.getOtherRequestsPickList(component, event);
		helper.getOtherDocumentsToSendPicklist(component, event);
		helper.getPersonToBeChangedPicklist(component, event);
		helper.getChangePointPicklist(component, event);
        component.set("v.innerCmpNewRequest.OtherOrderFlag__c",'無');
        component.set("v.innerCmpNewRequest.OtherOrderDocFlag__c",'無');
        //component.set("v.innerCmpNewRequest.OtherDocumentsToSend__c",'無');
        component.set("v.innerCmpNewRequest.WhetherDestinationInformationChanged__c",'無');
	},
	openBankMasterSearch : function(component,event,helper){

		$A.createComponent("c:BankMasterSearchCmp",{"showSearchPopup" : true,"sourceScreen" : "lightningCmp"},function(responseName, status, errorMessage){
			if(status === "SUCCESS"){
				var body = component.get("v.body");
                body.push([]);
                body.push(responseName);
                component.set("v.body", body);
			}else{
				alert('ErrorMessage ' + errorMessage);
			}
		});
     },
    handleBankMasterResultCmpEvt : function(component, event, helper){

		component.set("v.innerCmpNewRequest.BankCode__c", event.getParam("bankCode")); 
		component.set("v.innerCmpNewRequest.FinancialName__c", event.getParam("bankName"));
		component.set("v.innerCmpNewRequest.BranchCodeStoreNumber__c", event.getParam("branchCode"));
		component.set("v.innerCmpNewRequest.BranchName__c", event.getParam("branchName"));
	}
})