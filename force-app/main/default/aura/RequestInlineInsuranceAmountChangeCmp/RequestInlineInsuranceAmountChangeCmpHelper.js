({
   getPersonalInjuryExternalCompensationPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PersonalInjuryExternalCompensation__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var personalInjuryExternalCompensationPickMap = [];
                for(var key in result){
                    personalInjuryExternalCompensationPickMap.push({key: key, value: result[key]});
                }
                component.set("v.personalInjuryExternalCompensationPickMap", personalInjuryExternalCompensationPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	  getProcedurePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Procedure__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var procedurePickMap = [];
                for(var key in result){
                    procedurePickMap.push({key: key, value: result[key]});
                }
                component.set("v.procedurePickMap", procedurePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getTransferDivisionPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'TransferDivision__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var transferDivisionPickMap = [];
                for(var key in result){
                    transferDivisionPickMap.push({key: key, value: result[key]});
                }
                component.set("v.transferDivisionPickMap", transferDivisionPickMap);
            }
        });
        $A.enqueueAction(action);
    },
		getAdditionalAndReturnAccountPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AdditionalAndReturnAccount__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var additionalAndReturnAccountPickMap = [];
                for(var key in result){
                    additionalAndReturnAccountPickMap.push({key: key, value: result[key]});
                }
                component.set("v.additionalAndReturnAccountPickMap", additionalAndReturnAccountPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     getNecessityOfReceiptPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'NecessityOfReceipt__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var necessityOfReceiptPickMap = [];
                for(var key in result){
                    necessityOfReceiptPickMap.push({key: key, value: result[key]});
                }
                component.set("v.necessityOfReceiptPickMap", necessityOfReceiptPickMap);
            }
        });
        $A.enqueueAction(action);
    }
	
})