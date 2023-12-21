({
    saveInlineRequestReductionatRenewal : function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction1","v.beforeReduction1Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction1","v.afterReduction1Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction2","v.beforeReduction2Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction2","v.afterReduction2Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction3","v.beforeReduction3Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction3","v.afterReduction3Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction4","v.beforeReduction4Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction4","v.afterReduction4Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction5","v.beforeReduction5Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction5","v.afterReduction5Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction6","v.beforeReduction6Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction6","v.afterReduction6Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction7","v.beforeReduction7Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction7","v.afterReduction7Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction8","v.beforeReduction8Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction8","v.afterReduction8Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction9","v.beforeReduction9Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction9","v.afterReduction9Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction10","v.beforeReduction10Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction10","v.afterReduction10Err");
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
        
        var beforeReduction1 = cmp.get("v.beforeReduction1") == null ? "" : cmp.get("v.beforeReduction1");
		var beforeReduction2 = cmp.get("v.beforeReduction2") == null ? "" : cmp.get("v.beforeReduction2");
		var beforeReduction3 = cmp.get("v.beforeReduction3") == null ? "" : cmp.get("v.beforeReduction3");
		var beforeReduction4 = cmp.get("v.beforeReduction4") == null ? "" : cmp.get("v.beforeReduction4");
		var beforeReduction5 = cmp.get("v.beforeReduction5") == null ? "" : cmp.get("v.beforeReduction5");
		var beforeReduction6 = cmp.get("v.beforeReduction6") == null ? "" : cmp.get("v.beforeReduction6");
		var beforeReduction7 = cmp.get("v.beforeReduction7") == null ? "" : cmp.get("v.beforeReduction7");
		var beforeReduction8 = cmp.get("v.beforeReduction8") == null ? "" : cmp.get("v.beforeReduction8");
		var beforeReduction9 = cmp.get("v.beforeReduction9") == null ? "" : cmp.get("v.beforeReduction9");
		var beforeReduction10 = cmp.get("v.beforeReduction10") == null ? "" : cmp.get("v.beforeReduction10");
        var afterReduction1 = cmp.get("v.afterReduction1") == null ? "" : cmp.get("v.afterReduction1");
		var afterReduction2 = cmp.get("v.afterReduction2") == null ? "" : cmp.get("v.afterReduction2");
		var afterReduction3 = cmp.get("v.afterReduction3") == null ? "" : cmp.get("v.afterReduction3");
		var afterReduction4 = cmp.get("v.afterReduction4") == null ? "" : cmp.get("v.afterReduction4");
		var afterReduction5 = cmp.get("v.afterReduction5") == null ? "" : cmp.get("v.afterReduction5");
		var afterReduction6 = cmp.get("v.afterReduction6") == null ? "" : cmp.get("v.afterReduction6");
		var afterReduction7 = cmp.get("v.afterReduction7") == null ? "" : cmp.get("v.afterReduction7");
		var afterReduction8 = cmp.get("v.afterReduction8") == null ? "" : cmp.get("v.afterReduction8");
		var afterReduction9 = cmp.get("v.afterReduction9") == null ? "" : cmp.get("v.afterReduction9");
		var afterReduction10 = cmp.get("v.afterReduction10") == null ? "" : cmp.get("v.afterReduction10");
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");

		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
		var beforeReduction1Err = cmp.get("v.beforeReduction1Err");
		var afterReduction1Err = cmp.get("v.afterReduction1Err");
		var beforeReduction2Err = cmp.get("v.beforeReduction2Err");
		var afterReduction2Err = cmp.get("v.afterReduction2Err");
		var beforeReduction3Err = cmp.get("v.beforeReduction3Err");
		var afterReduction3Err = cmp.get("v.afterReduction3Err");
		var beforeReduction4Err = cmp.get("v.beforeReduction4Err");
		var afterReduction4Err = cmp.get("v.afterReduction4Err");
		var beforeReduction5Err = cmp.get("v.beforeReduction5Err");
		var afterReduction5Err = cmp.get("v.afterReduction5Err");
		var beforeReduction6Err = cmp.get("v.beforeReduction6Err");
		var afterReduction6Err = cmp.get("v.afterReduction6Err");
		var beforeReduction7Err = cmp.get("v.beforeReduction7Err");
		var afterReduction7Err = cmp.get("v.afterReduction7Err");
		var beforeReduction8Err = cmp.get("v.beforeReduction8Err");
		var afterReduction8Err = cmp.get("v.afterReduction8Err");
		var beforeReduction9Err = cmp.get("v.beforeReduction9Err");
		var afterReduction9Err = cmp.get("v.afterReduction9Err");
		var beforeReduction10Err = cmp.get("v.beforeReduction10Err");
		var afterReduction10Err = cmp.get("v.afterReduction10Err");
        
        obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
		var bSetErrorFocus = false;
		if(obj.PolicyNumber1__c != ''){
			if (beforeReduction1 === '' || afterReduction1 === ''){
				cmp.set("v.PolicyNumberValidate1",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber1").focus(); bSetErrorFocus = true; }
			}
			else {
                obj.ChangeDetails1__c = "減額前:" + beforeReduction1 +"\n"+
										"減額後:" +afterReduction1;
			}
		}
		else{
			obj.ChangeDetails1__c = "";
		}
		
        obj.PolicyNumber2__c = cmp.get("v.innerCmpNewRequest").PolicyNumber2__c;
		if(obj.PolicyNumber2__c != ''){
			if (beforeReduction2 === '' || afterReduction2 === '' ){
				cmp.set("v.PolicyNumberValidate2",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber2").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails2__c = "減額前:" + beforeReduction2 +"\n"+
										"減額後:" +afterReduction2;
			}
		}
		else{
			obj.ChangeDetails2__c = "";
		}
		
        obj.PolicyNumber3__c = cmp.get("v.innerCmpNewRequest").PolicyNumber3__c;
		if(obj.PolicyNumber3__c != ''){
			if (beforeReduction3 === '' || afterReduction3 === ''){
				cmp.set("v.PolicyNumberValidate3",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber3").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails3__c = "減額前:" + beforeReduction3 +"\n"+
										"減額後:" +afterReduction3;
			}
		}
		else{
			obj.ChangeDetails3__c = "";
		}
		
        obj.PolicyNumber4__c = cmp.get("v.innerCmpNewRequest").PolicyNumber4__c;
        if(obj.PolicyNumber4__c != ''){
			if (beforeReduction4 === '' || afterReduction4 === ''){
				cmp.set("v.PolicyNumberValidate4",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber4").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails4__c = "減額前:" + beforeReduction4 +"\n"+
										"減額後:" +afterReduction4
			}
		}
		else{
			obj.ChangeDetails4__c = "";
		}
		
        obj.PolicyNumber5__c = cmp.get("v.innerCmpNewRequest").PolicyNumber5__c; 
        if(obj.PolicyNumber5__c != ''){
			if (beforeReduction5 === '' || afterReduction5 === ''){
				cmp.set("v.PolicyNumberValidate5",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber5").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails5__c = "減額前:" + beforeReduction5 +"\n"+
										"減額後:" +afterReduction5;
			}
		}
		else{
			obj.ChangeDetails5__c = "";
		}
		
        obj.PolicyNumber6__c = cmp.get("v.innerCmpNewRequest").PolicyNumber6__c;
        if(obj.PolicyNumber6__c != ''){
			if (beforeReduction6 === '' || afterReduction6 === ''){
				cmp.set("v.PolicyNumberValidate6",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber6").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails6__c = "減額前:" + beforeReduction6 +"\n"+
										"減額後:" +afterReduction6;
			}
		}
		else{
			obj.ChangeDetails6__c = "";
		}
		
        obj.PolicyNumber7__c = cmp.get("v.innerCmpNewRequest").PolicyNumber7__c;
        if(obj.PolicyNumber7__c != ''){
			if (beforeReduction7 === '' || afterReduction7 === ''){
				cmp.set("v.PolicyNumberValidate7",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber7").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails7__c = "減額前:" + beforeReduction7 +"\n"+
										"減額後:" +afterReduction7;
			}
		}
		else{
			obj.ChangeDetails7__c = "";
		}
		
        obj.PolicyNumber8__c = cmp.get("v.innerCmpNewRequest").PolicyNumber8__c;
        if(obj.PolicyNumber8__c != ''){
			if (beforeReduction8 === '' || afterReduction8 === ''){
				cmp.set("v.PolicyNumberValidate8",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber8").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails8__c = "減額前:" + beforeReduction8 +"\n"+
										"減額後:" +afterReduction8;
			}
		}
		else{
			obj.ChangeDetails8__c = "";
		}
		
        obj.PolicyNumber9__c = cmp.get("v.innerCmpNewRequest").PolicyNumber9__c;
        if(obj.PolicyNumber9__c != ''){
			if (beforeReduction9 === '' || afterReduction9 === ''){
				cmp.set("v.PolicyNumberValidate9",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber9").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails9__c = "減額前:" + beforeReduction9 +"\n"+
										"減額後:" +afterReduction9;
			}
		}
		else{
			obj.ChangeDetails9__c = "";
		}
		
        obj.PolicyNumber10__c = cmp.get("v.innerCmpNewRequest").PolicyNumber10__c; 
        if(obj.PolicyNumber10__c != ''){
			if (beforeReduction10 === '' || afterReduction10 === ''){
				cmp.set("v.PolicyNumberValidate10",true);
				if (!bSetErrorFocus) { cmp.find("policyNumber10").focus(); bSetErrorFocus = true; }
			}
			else {
				obj.ChangeDetails10__c = "減額前:" + beforeReduction10 +"\n"+
										"減額後:" +afterReduction10;
			}
		}
		else{
			obj.ChangeDetails10__c = "";
		}
		
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
        obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
		obj.NumberOfCopies__c = cmp.get("v.numberOfCopies");
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c; 
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
		
		if (bSetErrorFocus || noOfCopiesErr || 
			beforeReduction1Err || afterReduction1Err || beforeReduction2Err || afterReduction2Err || 
			beforeReduction3Err || afterReduction3Err || beforeReduction4Err || afterReduction4Err || 
			beforeReduction5Err || afterReduction5Err || beforeReduction6Err || afterReduction6Err || 
			beforeReduction7Err || afterReduction7Err || beforeReduction8Err || afterReduction8Err || 
			beforeReduction9Err || afterReduction9Err || beforeReduction10Err || afterReduction10Err){
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
        helper.getProcessingPicklist(component, event,dependantSubject);
        helper.getShippingDocumentsPicklist(component, event,dependantSubject);
        helper.getDateOfShipmentPicklist(component, event);
		helper.getShippingMethodPicklist(component, event);
        
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
        component.find("dateOfShipmentPickList").set("v.disabled", disableFlag);
        component.find("shippingMethodPickList").set("v.disabled", disableFlag);
        component.find("numberOfCopies").set("v.disabled", disableFlag);
        
        component.find("shippingDocumentsPickList").set("v.value", '');
        component.find("dateOfShipmentPickList").set("v.value", '');
        component.find("shippingMethodPickList").set("v.value", '');
        component.find("numberOfCopies").set("v.value", '');
		
		component.set("v.noOfCopiesErr",false);
    },
    handleBeforeReduction1 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction1","v.beforeReduction1Err");
    },
    handleAfterReduction1 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction1","v.afterReduction1Err");
    },
    handleBeforeReduction2 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction2","v.beforeReduction2Err");
    },
    handleAfterReduction2 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction2","v.afterReduction2Err");
    },
    handleBeforeReduction3 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction3","v.beforeReduction3Err");
    },
    handleAfterReduction3 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction3","v.afterReduction3Err");
    },
    handleBeforeReduction4 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction4","v.beforeReduction4Err");
    },
    handleAfterReduction4 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction4","v.afterReduction4Err");
    },
    handleBeforeReduction5 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction5","v.beforeReduction5Err");
    },
    handleAfterReduction5 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction5","v.afterReduction5Err");
    },
    handleBeforeReduction6 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction6","v.beforeReduction6Err");
    },
    handleAfterReduction6 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction6","v.afterReduction6Err");
    },
    handleBeforeReduction7 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction7","v.beforeReduction7Err");
    },
    handleAfterReduction7 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction7","v.afterReduction7Err");
    },
    handleBeforeReduction8: function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction8","v.beforeReduction8Err");
    },
    handleAfterReduction8 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction8","v.afterReduction8Err");
    },
    handleBeforeReduction9 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction9","v.beforeReduction9Err");
    },
    handleAfterReduction9 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction9","v.afterReduction9Err");
    },
    handleBeforeReduction10 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction10","v.beforeReduction10Err");
    },
    handleAfterReduction10 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction10","v.afterReduction10Err");
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})