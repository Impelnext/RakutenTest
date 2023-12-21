({
    saveInlineRefundAccount : function(cmp, event, helper) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;       
		
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");

        obj.RefundAccountCheck__c = cmp.get("v.innerCmpNewRequest").RefundAccountCheck__c;
        obj.AccountHolderKana__c = cmp.get("v.innerCmpNewRequest").AccountHolderKana__c;
        obj.AccountHolderKanji__c = cmp.get("v.innerCmpNewRequest").AccountHolderKanji__c;
        obj.FinancialInstitutionSearch__c = cmp.get("v.innerCmpNewRequest").FinancialInstitutionSearch__c; 
        obj.FinancialName__c = cmp.get("v.innerCmpNewRequest").FinancialName__c;
        obj.BankCode__c = cmp.get("v.innerCmpNewRequest").BankCode__c;
        obj.BranchName__c = cmp.get("v.innerCmpNewRequest").BranchName__c; 
		obj.BranchCodeStoreNumber__c = cmp.get("v.innerCmpNewRequest").BranchCodeStoreNumber__c; 
		obj.DepositCategory__c = cmp.get("v.innerCmpNewRequest").DepositCategory__c; 
		obj.AccountNumber__c = cmp.get("v.innerCmpNewRequest").AccountNumber__c; 
		obj.DirectOwnership__c = cmp.get("v.innerCmpNewRequest").DirectOwnership__c; 
		obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c; 
		obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;  
        obj.RefundType__c = cmp.get("v.innerCmpNewRequest").RefundType__c;	
        obj.RefundTypeOtherComment__c = cmp.get("v.innerCmpNewRequest").RefundTypeOtherComment__c;
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
        
        obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");

        if (noOfCopiesErr){
			var events = cmp.getEvent("ReqStopSaveComponentEvent");
			events.setParams({"param": true});
			events.fire();
		}
		else{
			var events = cmp.getEvent("ReqStopSaveComponentEvent");
			events.setParams({"param": false});
			events.fire();
		}
		
    },    
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getrefundAccountCheckPicklist(component, event);
        helper.getdepositCategoryPicklist(component, event);
        helper.getProcessingPicklist(component, event,dependantSubject);
		helper.getshippingDocumentsPicklist(component, event,dependantSubject);
		helper.getdateOfShipmentPicklist(component, event);
		helper.getshippingMethodPicklist(component, event);
        helper.getrefundTypePickList(component, event);
        
        component.set("v.innerCmpNewRequest.Processing__c",'手動');
    },
    handleProcessingPick : function(component, event, helper) {
        var disableFlag;
        var processingInput = component.get("v.innerCmpNewRequest.Processing__c");
        if(processingInput == "書類発送"){
            disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("shippingDocumentsPickList").set("v.disabled", disableFlag);
        component.find("dateOfShipmentPicklist").set("v.disabled", disableFlag);
        component.find("shippingMethodPicklist").set("v.disabled", disableFlag);
        component.find("numberOfCopies").set("v.disabled", disableFlag);

        component.find("shippingDocumentsPickList").set("v.value", '');
        component.find("dateOfShipmentPicklist").set("v.value", '');
        component.find("shippingMethodPicklist").set("v.value", '');
        component.find("numberOfCopies").set("v.value", '');
        
        component.set("v.noOfCopiesErr",false);
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
	 },
     handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
     }
})