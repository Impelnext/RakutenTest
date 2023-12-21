({
    saveInlineReducemouth : function(cmp, event, helper) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;

		// Check all Number Input field once again before Save
        helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");
		
        var policyNumberList = params.policyNumberList;
        if(policyNumberList != ''){
        	for (var i = 0; i < policyNumberList.length; i++){  
                if(i == 0){
                    obj.PolicyNumber1__c = policyNumberList[i];
                }else{
                    obj.PolicyNumber1__c = obj.PolicyNumber1__c + "/"+policyNumberList[i];   
                }           
        	}
        }
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c; 
		obj.ShippingDocuments__c = cmp.get("v.innerCmpNewRequest").ShippingDocuments__c;
        //obj.NumberOfCopies__c = cmp.get("v.innerCmpNewRequest").NumberOfCopies__c;
        obj.DateOfShipment__c = cmp.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = cmp.get("v.innerCmpNewRequest").ShippingMethod__c;  
               
		obj.ChangeDetails1__c = "減口前:2" + "\n"+
                                "減口後:1";   

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
		helper.getshippingDocumentsPicklist(component, event,dependantSubject);
		helper.getdateOfShipmentPicklist(component, event);
		helper.getshippingMethodPicklist(component, event);
        
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
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})