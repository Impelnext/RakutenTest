({
	saveInlineCancellationCarCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.CancellationReason__c= cmp.get("v.innerCmpNewRequest").CancellationReason__c;
		obj.CancellationDate__c= cmp.get("v.innerCmpNewRequest").CancellationDate__c;
		obj.InterruptionCertificateRequirement__c= cmp.get("v.innerCmpNewRequest").InterruptionCertificateRequirement__c;
		obj.CancellationPremiumYen__c= cmp.get("v.innerCmpNewRequest").CancellationPremiumYen__c;
		obj.EndorsementNumber__c= cmp.get("v.innerCmpNewRequest").EndorsementNumber__c;
		obj.TransferApprovalDate__c= cmp.get("v.innerCmpNewRequest").TransferApprovalDate__c;
		obj.PrintingSequenceNumber__c= cmp.get("v.innerCmpNewRequest").PrintingSequenceNumber__c;
		obj.OtherInfomation__c= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
		obj.ReturnAccount__c= cmp.get("v.innerCmpNewRequest").ReturnAccount__c;
		obj.RegistrationAccountConversionPropriety__c= cmp.get("v.innerCmpNewRequest").RegistrationAccountConversionPropriety__c;
		obj.PersonOneselfOrOther__c= cmp.get("v.innerCmpNewRequest").PersonOneselfOrOther__c;
		obj.AccountHolderPaymentKana__c= cmp.get("v.innerCmpNewRequest").AccountHolderPaymentKana__c;
		obj.AccountHolderPayment__c= cmp.get("v.innerCmpNewRequest").AccountHolderPayment__c;
		obj.FinancialInstitutionsName__c= cmp.get("v.innerCmpNewRequest").FinancialInstitutionsName__c;
		obj.ReturnAccountFinancialInstitutionCode__c= cmp.get("v.innerCmpNewRequest").ReturnAccountFinancialInstitutionCode__c;
		obj.BranchNamePayment__c= cmp.get("v.innerCmpNewRequest").BranchNamePayment__c;
		obj.ReturnAccountBranchCode__c= cmp.get("v.innerCmpNewRequest").ReturnAccountBranchCode__c;
		obj.DepositTypePayment__c= cmp.get("v.innerCmpNewRequest").DepositTypePayment__c;
		obj.AccountNumberPayment__c= cmp.get("v.innerCmpNewRequest").AccountNumberPayment__c;
		obj.ReturnAccountYucho_AllNumbers__c= cmp.get("v.innerCmpNewRequest").ReturnAccountYucho_AllNumbers__c;
		obj.PhoneNumberAfterChange__c= cmp.get("v.innerCmpNewRequest").PhoneNumberAfterChange__c;
		obj.ChangedMailAddress__c= cmp.get("v.innerCmpNewRequest").ChangedMailAddress__c;
		obj.OtherChanges__c= cmp.get("v.innerCmpNewRequest").OtherChanges__c;
		//obj.Notices__c= cmp.get("v.innerCmpNewRequest").Notices__c;
	},
    init : function(component,event,helper){
        helper.getcancellationReasonPicklist(component, event);
		helper.getinterruptionCertificateReqPicklist(component, event);
		helper.getcancellationPremiumYenPicklist(component, event);
		helper.getreturnAccountPicklist(component, event);
		helper.getregistAccConversionProprietyPicklist(component, event);
		helper.getpersonOneselfOrOtherPicklist(component, event);
		helper.getdepositTypePaymentPicklist(component, event);
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

		component.set("v.innerCmpNewRequest.ReturnAccountFinancialInstitutionCode__c", event.getParam("bankCode")); 
		component.set("v.innerCmpNewRequest.FinancialInstitutionsName__c", event.getParam("bankName"));
		component.set("v.innerCmpNewRequest.ReturnAccountBranchCode__c", event.getParam("branchCode"));
		component.set("v.innerCmpNewRequest.BranchNamePayment__c", event.getParam("branchName"));
	}	
})