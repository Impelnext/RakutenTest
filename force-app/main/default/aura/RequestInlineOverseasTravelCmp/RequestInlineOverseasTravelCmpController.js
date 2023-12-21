({
    saveInlineOverseasTravel : function(cmp, event, helper) {
        var params = event.getParam('arguments');
        
		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
        var obj = params.parentNewRequest;   
        obj.AgentPrefectures__c = cmp.get("v.innerCmpNewRequest").AgentPrefectures__c;
        obj.VoyageFrom__c = cmp.get("v.innerCmpNewRequest").VoyageFrom__c;
        obj.VoyageTo__c = cmp.get("v.innerCmpNewRequest").VoyageTo__c;
        obj.AgentNameKana__c = cmp.get("v.innerCmpNewRequest").AgentNameKana__c;
        obj.AgentNameKanji__c = cmp.get("v.innerCmpNewRequest").AgentNameKanji__c;
        obj.RelationWithContractorForOverseasTravel__c = cmp.get("v.innerCmpNewRequest").RelationWithContractorForOverseasTravel__c;
        obj.AgentContactNo__c = cmp.get("v.innerCmpNewRequest").AgentContactNo__c;		
        obj.AgentPostalNumber__c=cmp.get("v.innerCmpNewRequest").AgentPostalNumber__c; 
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
		obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c; 
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;

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
    handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").AgentPrefectures__c ='';
        helper.areaInfo(cmp, event);             
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})