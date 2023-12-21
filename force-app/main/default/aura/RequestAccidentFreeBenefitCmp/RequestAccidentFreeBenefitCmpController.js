({
	saveAccidentFreeBenefit: function (cmp, event) {
		var params = event.getParam('arguments');
		var obj = params.parentNewRequest;

		obj.AccountHolderKana__c = cmp.get("v.innerCmpNewRequest").AccountHolderKana__c;
		obj.AccountHolderKanji__c = cmp.get("v.innerCmpNewRequest").AccountHolderKanji__c;
		obj.FinancialInstitutionSearch__c = cmp.get("v.innerCmpNewRequest").FinancialInstitutionSearch__c;
		obj.FinancialName__c = cmp.get("v.innerCmpNewRequest").FinancialName__c;
		obj.BankCode__c = cmp.get("v.innerCmpNewRequest").BankCode__c;
		obj.BranchName__c = cmp.get("v.innerCmpNewRequest").BranchName__c;
		obj.BranchCodeStoreNumber__c = cmp.get("v.innerCmpNewRequest").BranchCodeStoreNumber__c;
		obj.DepositCategory__c = cmp.get("v.innerCmpNewRequest").DepositCategory__c;
		obj.AccountNumber__c = cmp.get("v.innerCmpNewRequest").AccountNumber__c;
		obj.JpNumFirst5__c = cmp.get("v.innerCmpNewRequest").JpNumFirst5__c
		obj.JpNumLast8__c = cmp.get("v.innerCmpNewRequest").JpNumLast8__c
		obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
		obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
		obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
		obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
		obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
	},
	init: function (component, event, helper) {
		var dependantSubject = component.get('v.dependantSubject');
		helper.getdepositCategoryPicklist(component, event);
		helper.getProcessingPicklist(component, event, dependantSubject);
		helper.getShippingDocumentsPicklist(component, event, dependantSubject);
		helper.getDateOfShipmentPicklist(component, event);
		helper.getShippingMethodPicklist(component, event);

		component.set("v.innerCmpNewRequest.Processing__c", '手動');
	},
	openBankMasterSearch: function (component, event, helper) {

		$A.createComponent("c:BankMasterSearchCmp", { "showSearchPopup": true, "sourceScreen": "lightningCmp" }, function (responseName, status, errorMessage) {
			if (status === "SUCCESS") {
				var body = component.get("v.body");
				body.push([]);
				body.push(responseName);
				component.set("v.body", body);
			} else {
				alert('ErrorMessage ' + errorMessage);
			}
		});
	},
	handleBankMasterResultCmpEvt: function (component, event, helper) {

		component.set("v.innerCmpNewRequest.BankCode__c", event.getParam("bankCode"));
		component.set("v.innerCmpNewRequest.FinancialName__c", event.getParam("bankName"));
		component.set("v.innerCmpNewRequest.BranchCodeStoreNumber__c", event.getParam("branchCode"));
		component.set("v.innerCmpNewRequest.BranchName__c", event.getParam("branchName"));
	}
})