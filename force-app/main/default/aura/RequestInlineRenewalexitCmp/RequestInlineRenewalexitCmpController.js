/**
 * @File Name          : RequestInlineRenewalexitCmpController.js
 * @Description        : 
 * @Author             : SRM
 * @Group              : 
 * @Last Modified By   : SRM
 * @Last Modified On   : 12/23/2019, 3:34:21 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/23/2019   SRM     Initial Version
**/
({
    saveInlineRequestInlineRenewalexit : function(cmp, event, helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
		
		// Check all Number Input field once again before Save
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction1","v.afterOpeningMouth1");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction2","v.afterOpeningMouth2");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction3","v.afterOpeningMouth3");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction4","v.afterOpeningMouth4");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction5","v.afterOpeningMouth5");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction6","v.afterOpeningMouth6");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction7","v.afterOpeningMouth7");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction8","v.afterOpeningMouth8");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction9","v.afterOpeningMouth9");
        helper.getSingleByteDecimalCheck(cmp,event,"v.afterMouthReduction10","v.afterOpeningMouth10");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening1","v.beforeOpeningMouth1");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening2","v.beforeOpeningMouth2");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening3","v.beforeOpeningMouth3");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening4","v.beforeOpeningMouth4");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening5","v.beforeOpeningMouth5");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening6","v.beforeOpeningMouth6");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening7","v.beforeOpeningMouth7");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening8","v.beforeOpeningMouth8");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening9","v.beforeOpeningMouth9");
        helper.getSingleByteDecimalCheck(cmp,event,"v.beforeOpening10","v.beforeOpeningMouth10");
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
        //obj.PolicyNumber1__c = cmp.get("v.innerCmpNewRequest").PolicyNumber1__c;
        var beforeOpening1 = cmp.get("v.beforeOpening1") == null ? "" : cmp.get("v.beforeOpening1");
		var beforeOpening2 = cmp.get("v.beforeOpening2") == null ? "" : cmp.get("v.beforeOpening2");
		var beforeOpening3 = cmp.get("v.beforeOpening3") == null ? "" : cmp.get("v.beforeOpening3");
		var beforeOpening4 = cmp.get("v.beforeOpening4") == null ? "" : cmp.get("v.beforeOpening4");
		var beforeOpening5 = cmp.get("v.beforeOpening5") == null ? "" : cmp.get("v.beforeOpening5");
		var beforeOpening6 = cmp.get("v.beforeOpening6") == null ? "" : cmp.get("v.beforeOpening6");
		var beforeOpening7 = cmp.get("v.beforeOpening7") == null ? "" : cmp.get("v.beforeOpening7");
		var beforeOpening8 = cmp.get("v.beforeOpening8") == null ? "" : cmp.get("v.beforeOpening8");
		var beforeOpening9 = cmp.get("v.beforeOpening9") == null ? "" : cmp.get("v.beforeOpening9");
		var beforeOpening10 = cmp.get("v.beforeOpening10") == null ? "" : cmp.get("v.beforeOpening10");
        var afterMouthReduction1 = cmp.get("v.afterMouthReduction1") == null ? "" : cmp.get("v.afterMouthReduction1");
		var afterMouthReduction2 = cmp.get("v.afterMouthReduction2") == null ? "" : cmp.get("v.afterMouthReduction2");
		var afterMouthReduction3 = cmp.get("v.afterMouthReduction3") == null ? "" : cmp.get("v.afterMouthReduction3");
		var afterMouthReduction4 = cmp.get("v.afterMouthReduction4") == null ? "" : cmp.get("v.afterMouthReduction4");
		var afterMouthReduction5 = cmp.get("v.afterMouthReduction5") == null ? "" : cmp.get("v.afterMouthReduction5");
		var afterMouthReduction6 = cmp.get("v.afterMouthReduction6") == null ? "" : cmp.get("v.afterMouthReduction6");
		var afterMouthReduction7 = cmp.get("v.afterMouthReduction7") == null ? "" : cmp.get("v.afterMouthReduction7");
		var afterMouthReduction8 = cmp.get("v.afterMouthReduction8") == null ? "" : cmp.get("v.afterMouthReduction8");
		var afterMouthReduction9 = cmp.get("v.afterMouthReduction9") == null ? "" : cmp.get("v.afterMouthReduction9");
		var afterMouthReduction10 = cmp.get("v.afterMouthReduction10") == null ? "" : cmp.get("v.afterMouthReduction10");
        var bHasError = false;
        if(cmp.get("v.productName1") != '' && cmp.get("v.productName1") !='-- None --'){
			if (beforeOpening1 === '' || 
				afterMouthReduction1 === '' ){
				cmp.set("v.prod1",true);
				if (!bHasError) { cmp.find("productName1").focus(); bHasError = true; }
            }
			else {
				
				obj.ChangeDetails1__c = "商品名:" +cmp.get("v.productName1")+"\n"+
								"減口前:" +cmp.get("v.beforeOpening1")+"\n"+
								"減口後:" +cmp.get("v.afterMouthReduction1")+"\n"+
								"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements1");
			}
		}
		else{
			obj.ChangeDetails1__c = "";
		}
        if(cmp.get("v.productName2") != '' && cmp.get("v.productName2") !='-- None --'){
		if (beforeOpening2 === '' || 
				afterMouthReduction2 === ''){
				cmp.set("v.prod2",true);
				if (!bHasError) { cmp.find("productName2").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails2__c = "商品名:" +cmp.get("v.productName2")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening2")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction2")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements2");
		}
		}
		else{
			obj.ChangeDetails2__c = "";
		}
        if(cmp.get("v.productName3") != '' && cmp.get("v.productName3") !='-- None --'){
		if (beforeOpening3 === '' || 
				afterMouthReduction3 === '' ){
				cmp.set("v.prod3",true);
				if (!bHasError) { cmp.find("productName3").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails3__c = "商品名:" +cmp.get("v.productName3")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening3")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction3")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements3");
		}
		}
		else{
			obj.ChangeDetails3__c = "";
		}
        if(cmp.get("v.productName4") != '' && cmp.get("v.productName4") !='-- None --'){
		if (beforeOpening4 === '' || 
				afterMouthReduction4 === ''){
				cmp.set("v.prod4",true);
				if (!bHasError) { cmp.find("productName4").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails4__c = "商品名:" +cmp.get("v.productName4")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening4")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction4")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements4");
		}
		}
		else{
			obj.ChangeDetails4__c = "";
		}
		if(cmp.get("v.productName5") != '' && cmp.get("v.productName5") !='-- None --'){
		if (beforeOpening5 === '' || 
				afterMouthReduction5 === ''){
				cmp.set("v.prod5",true);
				if (!bHasError) { cmp.find("productName5").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails5__c = "商品名:" +cmp.get("v.productName5")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening5")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction5")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements5");
		}
		}
		else{
			obj.ChangeDetails5__c = "";
		}
        if(cmp.get("v.productName6") != '' && cmp.get("v.productName6") !='-- None --'){
		if (beforeOpening6 === '' || 
				afterMouthReduction6 === ''){
				cmp.set("v.prod6",true);
				if (!bHasError) { cmp.find("productName6").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails6__c = "商品名:" +cmp.get("v.productName6")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening6")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction6")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements6");
		}
		}
		else{
			obj.ChangeDetails6__c = "";
		}
        if(cmp.get("v.productName7") != '' && cmp.get("v.productName7") !='-- None --'){
		if (beforeOpening7 === '' || 
				afterMouthReduction7 === ''){
				cmp.set("v.prod7",true);
				if (!bHasError) { cmp.find("productName7").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails7__c = "商品名:" +cmp.get("v.productName7")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening7")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction7")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements7");
		}
		}
		else{
			obj.ChangeDetails7__c = "";
		}
        if(cmp.get("v.productName8") != '' && cmp.get("v.productName8") !='-- None --'){
		if (beforeOpening8 === '' || 
				afterMouthReduction8 === ''){
				cmp.set("v.prod8",true);
				if (!bHasError) { cmp.find("productName8").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails8__c = "商品名:" +cmp.get("v.productName8")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening8")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction8")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements8");
		}
		}
		else{
			obj.ChangeDetails8__c = "";
		}
        if(cmp.get("v.productName9") != '' && cmp.get("v.productName9") !='-- None --'){
		if (beforeOpening9 === '' || 
				afterMouthReduction9 === ''){
				cmp.set("v.prod9",true);
				if (!bHasError) { cmp.find("productName9").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails9__c = "商品名:" +cmp.get("v.productName9")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening9")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction9")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements9");
		}
		}
		else{
			obj.ChangeDetails9__c = "";
		}
        if(cmp.get("v.productName10") != '' && cmp.get("v.productName10") !='-- None --'){
		if (beforeOpening10 === '' || 
				afterMouthReduction10 === ''){
				cmp.set("v.prod10",true);
				if (!bHasError) { cmp.find("productName10").focus(); bHasError = true; }
        }
		else {
			
			obj.ChangeDetails10__c = "商品名:" +cmp.get("v.productName10")+"\n"+
							"減口前:" +cmp.get("v.beforeOpening10")+"\n"+
							"減口後:" +cmp.get("v.afterMouthReduction10")+"\n"+
							"減口その他補足:" +cmp.get("v.reducingMouthAndOtherSupplements10");
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
		
        var afterMouth1 = cmp.get("v.afterOpeningMouth1");
        var afterMouth2 = cmp.get("v.afterOpeningMouth2");
        var afterMouth3 = cmp.get("v.afterOpeningMouth3");
        var afterMouth4 = cmp.get("v.afterOpeningMouth4");
        var afterMouth5 = cmp.get("v.afterOpeningMouth5");
        var afterMouth6 = cmp.get("v.afterOpeningMouth6");
        var afterMouth7 = cmp.get("v.afterOpeningMouth7");
        var afterMouth8 = cmp.get("v.afterOpeningMouth8");
        var afterMouth9 = cmp.get("v.afterOpeningMouth9");
        var afterMouth10 = cmp.get("v.afterOpeningMouth10");
        var beforeMouth1 = cmp.get("v.beforeOpeningMouth1");
        var beforeMouth2 = cmp.get("v.beforeOpeningMouth2");
        var beforeMouth3 = cmp.get("v.beforeOpeningMouth3");
        var beforeMouth4 = cmp.get("v.beforeOpeningMouth4");
        var beforeMouth5 = cmp.get("v.beforeOpeningMouth5");
        var beforeMouth6 = cmp.get("v.beforeOpeningMouth6");
        var beforeMouth7 = cmp.get("v.beforeOpeningMouth7");
        var beforeMouth8 = cmp.get("v.beforeOpeningMouth8");
        var beforeMouth9 = cmp.get("v.beforeOpeningMouth9");
        var beforeMouth10 = cmp.get("v.beforeOpeningMouth10");
		
		var numberOfCopies = cmp.get("v.numberOfCopies") == null ? "" : cmp.get("v.numberOfCopies");
		var noOfCopiesErr = cmp.get("v.noOfCopiesErr"); 

        if(bHasError || afterMouth1   || afterMouth2  || afterMouth3  || afterMouth4  || afterMouth5  ||
           afterMouth6  || afterMouth7  || afterMouth8  || afterMouth9  || afterMouth10 ||
           beforeMouth1 || beforeMouth2 || beforeMouth3 || beforeMouth4 || beforeMouth5 ||
           beforeMouth6 || beforeMouth7 || beforeMouth8 || beforeMouth9 || beforeMouth10 || noOfCopiesErr){
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
	handleProcessingPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
	handleShippingDocumentsPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
	handleDateOfShipmentPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
	handleShippingMethodPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
    handleProductName1Pick: function (component, event) {
        var selectedValues = component.find("productName1").get("v.value");
		component.set("v.productName1",selectedValues);
    },
	handleProductName2Pick: function (component, event) {
        var selectedValues = component.find("productName2").get("v.value");
		component.set("v.productName2",selectedValues);
    },
	handleProductName3Pick: function (component, event) {
        var selectedValues = component.find("productName3").get("v.value");
		component.set("v.productName3",selectedValues);
    },
	handleProductName4Pick: function (component, event) {
        var selectedValues = component.find("productName4").get("v.value");
		component.set("v.productName4",selectedValues);
    },
	handleProductName5Pick: function (component, event) {
        var selectedValues = component.find("productName5").get("v.value");
		component.set("v.productName5",selectedValues);
    },
	handleProductName6Pick: function (component, event) {
        var selectedValues = component.find("productName6").get("v.value");
		component.set("v.productName6",selectedValues);
    },
	handleProductName7Pick: function (component, event) {
        var selectedValues = component.find("productName7").get("v.value");
		component.set("v.productName7",selectedValues);
    },
	handleProductName8Pick: function (component, event) {
        var selectedValues = component.find("productName8").get("v.value");
		component.set("v.productName8",selectedValues);
    },
	handleProductName9Pick: function (component, event) {
        var selectedValues = component.find("productName9").get("v.value");
		component.set("v.productName9",selectedValues);
    },
	handleProductName10Pick: function (component, event) {
        var selectedValues = component.find("productName10").get("v.value");
		component.set("v.productName10",selectedValues);
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
    handleafterOpeningMouth1 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction1","v.afterOpeningMouth1");
    },
    handleafterOpeningMouth2 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction2","v.afterOpeningMouth2");
    },
    handleafterOpeningMouth3 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction3","v.afterOpeningMouth3");
    },
    handleafterOpeningMouth4 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction4","v.afterOpeningMouth4");
    },
    handleafterOpeningMouth5 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction5","v.afterOpeningMouth5");
    },
    handleafterOpeningMouth6 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction6","v.afterOpeningMouth6");
    },
    handleafterOpeningMouth7 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction7","v.afterOpeningMouth7");
    },
    handleafterOpeningMouth8 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction8","v.afterOpeningMouth8");
    },
    handleafterOpeningMouth9 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction9","v.afterOpeningMouth9");
    },
    handleafterOpeningMouth10 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.afterMouthReduction10","v.afterOpeningMouth10");
    },
    handlebeforeOpeningMouth1 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening1","v.beforeOpeningMouth1");
    },
    handlebeforeOpeningMouth2 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening2","v.beforeOpeningMouth2");
    },
    handlebeforeOpeningMouth3 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening3","v.beforeOpeningMouth3");
    },
    handlebeforeOpeningMouth4 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening4","v.beforeOpeningMouth4");
    },
    handlebeforeOpeningMouth5 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening5","v.beforeOpeningMouth5");
    },
    handlebeforeOpeningMouth6 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening6","v.beforeOpeningMouth6");
    },
    handlebeforeOpeningMouth7 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening7","v.beforeOpeningMouth7");
    },
    handlebeforeOpeningMouth8 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening8","v.beforeOpeningMouth8");
    },
    handlebeforeOpeningMouth9 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening9","v.beforeOpeningMouth9");
    },
    handlebeforeOpeningMouth10 : function(component,event,helper) {
        helper.getSingleByteDecimalCheck(component,event,"v.beforeOpening10","v.beforeOpeningMouth10");
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})