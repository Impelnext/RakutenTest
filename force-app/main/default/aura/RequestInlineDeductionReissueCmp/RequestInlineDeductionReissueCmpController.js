({
    saveDeductionReissue : function(cmp, event, helper) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;

		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
        obj.IsHandMade__c = cmp.get("v.innerCmpNewRequest").IsHandMade__c;
        obj.Note__c = cmp.get("v.innerCmpNewRequest").Note__c;
        obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c; 
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
		
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
        helper.getIsHandMadePicklist(component, event);
        helper.getShippingDocumentsPicklist(component, event,dependantSubject);
        helper.getDateOfShipmentPicklist(component, event);
        helper.getShippingMethodPicklist(component, event);
        helper.getProcessingPicklist(component,event,dependantSubject);
        //default set
        component.set("v.innerCmpNewRequest.Processing__c",'手動');
        component.find("shippingDocumentsPickList").set("v.disabled", true);
        component.find("dateOfShipmentPickList").set("v.disabled", false);
        component.find("shippingMethodPickList").set("v.disabled", false);
        //component.find("numberOfCopies").set("v.disabled", true);
    },
    handleProcessingPick : function(component, event, helper) {
        var processingInput = component.get("v.innerCmpNewRequest.Processing__c");
        if(processingInput == "書類発送"){
            component.find("shippingDocumentsPickList").set("v.disabled", false);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", false);
        }else if (processingInput == "手動") {
            component.find("shippingDocumentsPickList").set("v.disabled", true);
            component.find("dateOfShipmentPickList").set("v.disabled", false);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", true);
        }else if (processingInput == "自動") {
            component.find("shippingDocumentsPickList").set("v.disabled", true);
            component.find("dateOfShipmentPickList").set("v.disabled", true);
            component.find("shippingMethodPickList").set("v.disabled", false);
            component.find("numberOfCopies").set("v.disabled", true);
        }else{
            component.find("shippingDocumentsPickList").set("v.disabled", true);
            component.find("dateOfShipmentPickList").set("v.disabled", true);
            component.find("shippingMethodPickList").set("v.disabled", true);
            component.find("numberOfCopies").set("v.disabled", true);
        }
        
        component.find("shippingDocumentsPickList").set("v.value", '');
        component.find("dateOfShipmentPickList").set("v.value", '');
        component.find("shippingMethodPickList").set("v.value", '');
        component.find("numberOfCopies").set("v.value", '');
        
		component.set("v.noOfCopiesErr",false);
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})