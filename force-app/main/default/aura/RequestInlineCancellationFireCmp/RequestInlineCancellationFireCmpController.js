({
	saveInlineCancellationFire : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
        
        obj.MailingPrefectures__c = cmp.get("v.innerCmpNewRequest").MailingPrefectures__c;
        obj.MailingCity__c = cmp.get("v.innerCmpNewRequest").MailingCity__c;
        obj.MailingAddress1__c = cmp.get("v.innerCmpNewRequest").MailingAddress1__c;
        obj.Prefectures__c = cmp.get("v.innerCmpNewRequest").Prefectures__c;
        obj.City__c = cmp.get("v.innerCmpNewRequest").City__c;
        obj.Address1__c = cmp.get("v.innerCmpNewRequest").Address1__c;
		        
        obj.CancellationReasonFree__c= cmp.get("v.innerCmpNewRequest").CancellationReasonFree__c;
		obj.CancellationDate__c= cmp.get("v.innerCmpNewRequest").CancellationDate__c;
		obj.CancellationPremiumYen__c= cmp.get("v.innerCmpNewRequest").CancellationPremiumYen__c;
		obj.EndorsementNumberTelephoneOnly__c= cmp.get("v.innerCmpNewRequest").EndorsementNumberTelephoneOnly__c;
		obj.TransferApprovalDateTELServiceOnly__c= cmp.get("v.innerCmpNewRequest").TransferApprovalDateTELServiceOnly__c;
		obj.OtherInfomation__c= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;	
		obj.ExsistenceOfPledge__c = cmp.get("v.innerCmpNewRequest").ExsistenceOfPledge__c;		
		obj.MailingPostalCode__c = cmp.get("v.innerCmpNewRequest").MailingPostalCode__c;		
		obj.DestinationBuildingName__c = cmp.get("v.innerCmpNewRequest").DestinationBuildingName__c;
		obj.ReflectCancellationReceptionInfo__c= cmp.get("v.innerCmpNewRequest").ReflectCancellationReceptionInfo__c;
		obj.FinancialInstitutionOfTheInvoice__c= cmp.get("v.innerCmpNewRequest").FinancialInstitutionOfTheInvoice__c;
		obj.DepartmentInCharge__c = cmp.get("v.innerCmpNewRequest").DepartmentInCharge__c;		
		obj.PersonInChargeName__c = cmp.get("v.innerCmpNewRequest").PersonInChargeName__c;
		obj.Postalcode__c= cmp.get("v.innerCmpNewRequest").Postalcode__c;
			
		obj.BuildingName__c = cmp.get("v.innerCmpNewRequest").BuildingName__c;
		obj.ReflectMailingAddress__c= cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
		obj.PhoneNumber__c= cmp.get("v.innerCmpNewRequest").PhoneNumber__c;
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
		
	},
    handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").MailingPrefectures__c ='';
        cmp.get("v.innerCmpNewRequest").MailingCity__c ='';
        cmp.get("v.innerCmpNewRequest").MailingAddress1__c ='';
        helper.areaInfo(cmp, event);             
    },
	handleAreaInfo2 : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").Prefectures__c ='';
        cmp.get("v.innerCmpNewRequest").City__c ='';
        cmp.get("v.innerCmpNewRequest").Address1__c ='';
        helper.areaInfo2(cmp, event);             
    },
    init : function(component,event,helper){
		helper.getCancellationPremiumYenPicklist(component, event);
		helper.getExsistenceOfPledgePicklist(component, event);
		helper.getReturnAccountPicklist(component, event);
		helper.getRegistAccConversionProprietyPicklist(component, event);
		helper.getPersonOneselfOrOtherPicklist(component, event);
		helper.getDepositTypePaymentPicklist(component, event);
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