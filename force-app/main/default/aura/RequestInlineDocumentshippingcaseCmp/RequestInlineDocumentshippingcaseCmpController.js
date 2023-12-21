/**
 * @File Name          : RequestInlineDocumentshippingcaseCmpController.js
 * @Description        : 
 * @Author             : SRM
 * @Group              : 
 * @Last Modified By   : SRM
 * @Last Modified On   : 12/24/2019, 7:19:12 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/24/2019   SRM     Initial Version
**/
({
    saveInlineDocumentshippingcase : function(cmp, event, helper) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;

		// Check all Number Input field once again before Save
		helper.getSingleByteNumberCheck(cmp,event,"v.numberOfCopies","v.noOfCopiesErr");	
		
        obj.ReportGroup__c = cmp.get("v.innerCmpNewRequest").ReportGroup__c;
        obj.Report__c = cmp.get("v.innerCmpNewRequest").Report__c;
        obj.Remarks__c = cmp.get("v.innerCmpNewRequest").Remarks__c;
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
        var subject = component.get("v.dependantSubject");
        helper.getReportGroupPicklist(component, event, subject);
		helper.getReportPicklist(component, event);
		helper.getDateOfShipmentPicklist(component, event);
		helper.getShippingMethodPicklist(component, event);
        helper.fetchPicklistValues(component,"Request__c","ReportGroup__c", "Report__c");
    },
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    handleNoOfCopies : function(component,event,helper) {
        helper.getSingleByteNumberCheck(component,event,"v.numberOfCopies","v.noOfCopiesErr");
    }
})