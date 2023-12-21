({
    saveInlineRequestReduction : function(cmp, event, helper) {
        var params = event.getParam('arguments'); 
        var obj = params.parentNewRequest;
        
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction1","v.afrReduction1");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction2","v.afrReduction2");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction3","v.afrReduction3");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction4","v.afrReduction4");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction5","v.afrReduction5");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction6","v.afrReduction6");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction7","v.afrReduction7");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction8","v.afrReduction8");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction9","v.afrReduction9");
        helper.getSingleByteNumberCheck(cmp,event,"v.afterReduction10","v.afrReduction10");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction1","v.bfrReduction1");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction2","v.bfrReduction2");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction3","v.bfrReduction3");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction4","v.bfrReduction4");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction5","v.bfrReduction5");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction6","v.bfrReduction6");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction7","v.bfrReduction7");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction8","v.bfrReduction8");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction9","v.bfrReduction9");
        helper.getSingleByteNumberCheck(cmp,event,"v.beforeReduction10","v.bfrReduction10");
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
        var afrReduction1 = cmp.get("v.afrReduction1");
        var afrReduction2 = cmp.get("v.afrReduction2");
        var afrReduction3 = cmp.get("v.afrReduction3");
        var afrReduction4 = cmp.get("v.afrReduction4");
        var afrReduction5 = cmp.get("v.afrReduction5");
        var afrReduction6 = cmp.get("v.afrReduction6");
        var afrReduction7 = cmp.get("v.afrReduction7");
        var afrReduction8 = cmp.get("v.afrReduction8");
        var afrReduction9 = cmp.get("v.afrReduction9");
        var afrReduction10 = cmp.get("v.afrReduction10");
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr");
        
        var bHasError = false;
        obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
        
        if(obj.PolicyNumber1__c != ''){
            if(beforeReduction1 === '' || afterReduction1 === ''){
                cmp.set("v.PolicyNumberValidate1",true);
                if (!bHasError) { cmp.find("policyNumber1").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails1__c = "減額前:" + beforeReduction1 +"\n"+
						    		"減額後:" +afterReduction1;
            }
        }
        else{
            obj.ChangeDetails1__c = "";
        }
        
        obj.PolicyNumber2__c = cmp.get("v.innerCmpNewRequest").PolicyNumber2__c;
		 if(obj.PolicyNumber2__c != ''){
			 if(beforeReduction2 === '' || afterReduction2 === ''){
                cmp.set("v.PolicyNumberValidate2",true);
                if (!bHasError) { cmp.find("policyNumber2").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails2__c = "減額前:" + beforeReduction2 +"\n"+
								"減額後:" +afterReduction2;
			}
		 }
		 else{
            obj.ChangeDetails2__c = "";
        }
        
        obj.PolicyNumber3__c = cmp.get("v.innerCmpNewRequest").PolicyNumber3__c;
		if(obj.PolicyNumber3__c != ''){
			  if(beforeReduction3 === '' || afterReduction3 === ''){
                cmp.set("v.PolicyNumberValidate3",true);
                if (!bHasError) { cmp.find("policyNumber3").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails3__c = "減額前:" + beforeReduction3 +"\n"+
								"減額後:" +afterReduction3;
			}
		 }
		 else{
            obj.ChangeDetails3__c = "";
        }
        
        obj.PolicyNumber4__c = cmp.get("v.innerCmpNewRequest").PolicyNumber4__c;
		if(obj.PolicyNumber4__c != ''){
			 if(beforeReduction4 === '' || afterReduction4 === ''){
                cmp.set("v.PolicyNumberValidate4",true);
                if (!bHasError) { cmp.find("policyNumber4").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails4__c = "減額前:" + beforeReduction4 +"\n"+
								"減額後:" +afterReduction4;
			}
		 }
		 else{
            obj.ChangeDetails4__c = "";
        }
        
        obj.PolicyNumber5__c = cmp.get("v.innerCmpNewRequest").PolicyNumber5__c;
		if(obj.PolicyNumber5__c != ''){
			  if(beforeReduction5 === '' || afterReduction5 === ''){
                cmp.set("v.PolicyNumberValidate5",true);
                if (!bHasError) { cmp.find("policyNumber5").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails5__c = "減額前:" + beforeReduction5 +"\n"+
								"減額後:" +afterReduction5;
			}
		 }
		 else{
            obj.ChangeDetails5__c = "";
        }
        
        obj.PolicyNumber6__c = cmp.get("v.innerCmpNewRequest").PolicyNumber6__c;
		if(obj.PolicyNumber6__c != ''){
			   if(beforeReduction6 === '' || afterReduction6 === ''){
                cmp.set("v.PolicyNumberValidate6",true);
                if (!bHasError) { cmp.find("policyNumber6").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails6__c = "減額前:" + beforeReduction6 +"\n"+
								"減額後:" +afterReduction6;
			}
		 }
		 else{
            obj.ChangeDetails6__c = "";
        }
        
        obj.PolicyNumber7__c = cmp.get("v.innerCmpNewRequest").PolicyNumber7__c;
		if(obj.PolicyNumber7__c != ''){
			  if(beforeReduction7 === '' || afterReduction7 === ''){
                cmp.set("v.PolicyNumberValidate7",true);
                if (!bHasError) { cmp.find("policyNumber7").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails7__c ="減額前:" + beforeReduction7 +"\n"+
								"減額後:" +afterReduction7;
			}
		 }
		 else{
            obj.ChangeDetails7__c = "";
        }
        
        obj.PolicyNumber8__c = cmp.get("v.innerCmpNewRequest").PolicyNumber8__c;
		if(obj.PolicyNumber8__c != ''){
			  if(beforeReduction8 === '' || afterReduction8 === ''){
                cmp.set("v.PolicyNumberValidate8",true);
                if (!bHasError) { cmp.find("policyNumber8").focus(); bHasError = true; }
            }
            else{
				obj.ChangeDetails8__c = "減額前:" + beforeReduction8 +"\n"+
								"減額後:" +afterReduction8;
			}
		 }
		 else{
            obj.ChangeDetails8__c = "";
        }
        
        obj.PolicyNumber9__c = cmp.get("v.innerCmpNewRequest").PolicyNumber9__c;
		if(obj.PolicyNumber9__c != ''){
			 if(beforeReduction9 === '' || afterReduction9 === ''){
                cmp.set("v.PolicyNumberValidate9",true);
                if (!bHasError) { cmp.find("policyNumber9").focus(); bHasError = true; }
            }
            else{
				 obj.ChangeDetails9__c = "減額前:" + beforeReduction9 +"\n"+
								"減額後:" +afterReduction9;
			}
		 }
		 else{
            obj.ChangeDetails9__c = "";
        }
        
        obj.PolicyNumber10__c = cmp.get("v.innerCmpNewRequest").PolicyNumber10__c;
		if(obj.PolicyNumber10__c != ''){
			 if(beforeReduction10 === '' || afterReduction10 === ''){
                cmp.set("v.PolicyNumberValidate10",true);
                if (!bHasError) { cmp.find("policyNumber10").focus(); bHasError = true; }
            }
            else{
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
        
        var bfrReduction1 = cmp.get("v.bfrReduction1");
        var bfrReduction2 = cmp.get("v.bfrReduction2");
        var bfrReduction3 = cmp.get("v.bfrReduction3");
        var bfrReduction4 = cmp.get("v.bfrReduction4");
        var bfrReduction5 = cmp.get("v.bfrReduction5");
        var bfrReduction6 = cmp.get("v.bfrReduction6");
        var bfrReduction7 = cmp.get("v.bfrReduction7");
        var bfrReduction8 = cmp.get("v.bfrReduction8");
        var bfrReduction9 = cmp.get("v.bfrReduction9");
        var bfrReduction10 = cmp.get("v.bfrReduction10");
        
		if (bHasError ||
		    noOfCopiesErr || 
			afrReduction1  || afrReduction2 || afrReduction3 || afrReduction4 || afrReduction5  ||
			afrReduction6  || afrReduction7 || afrReduction8 || afrReduction9 || afrReduction10 || 
			bfrReduction1  || bfrReduction2 || bfrReduction3 || bfrReduction4 || bfrReduction5  ||
			bfrReduction6  || bfrReduction7 || bfrReduction8 || bfrReduction9 || bfrReduction10){
			
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
        component.find("dateOfShipmentPickMap").set("v.disabled", disableFlag);
        component.find("shippingMethodPickMap").set("v.disabled", disableFlag);
        component.find("numberOfCopies").set("v.disabled", disableFlag);

        component.find("shippingDocumentsPickList").set("v.value", '');
        component.find("dateOfShipmentPickMap").set("v.value", '');
        component.find("shippingMethodPickMap").set("v.value", '');
        component.find("numberOfCopies").set("v.value", '');
        
        component.set("v.noOfCopiesErr",false);
    },
	/*handleProcessingPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },*/
	handleShippingDocumentsPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
	handleDateOfShipmentPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
	handleShippingMethodPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
    handleAfrReduction1 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction1","v.afrReduction1");
    },
    handleAfrReduction2 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction2","v.afrReduction2");
    },
    handleAfrReduction3 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction3","v.afrReduction3");
    },
    handleAfrReduction4 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction4","v.afrReduction4");
    },
    handleAfrReduction5 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction5","v.afrReduction5");
    },
    handleAfrReduction6 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction6","v.afrReduction6");
    },
    handleAfrReduction7 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction7","v.afrReduction7");
    },
    handleAfrReduction8 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction8","v.afrReduction8");
    },
    handleAfrReduction9 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction9","v.afrReduction9");
    },
    handleAfrReduction10 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.afterReduction10","v.afrReduction10");
    },
    handleBfrReduction1 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction1","v.bfrReduction1");
    },
    handleBfrReduction2 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction2","v.bfrReduction2");
    },
    handleBfrReduction3 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction3","v.bfrReduction3");
    },
    handleBfrReduction4 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction4","v.bfrReduction4");
    },
    handleBfrReduction5 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction5","v.bfrReduction5");
    },
    handleBfrReduction6 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction6","v.bfrReduction6");
    },
    handleBfrReduction7 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction7","v.bfrReduction7");
    },
    handleBfrReduction8 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction8","v.bfrReduction8");
    },
    handleBfrReduction9 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction9","v.bfrReduction9");
    },
    handleBfrReduction10 : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.beforeReduction10","v.bfrReduction10");
    },
	handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})