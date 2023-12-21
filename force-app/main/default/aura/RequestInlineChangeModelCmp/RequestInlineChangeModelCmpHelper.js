({
	getusePicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'Use__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.usePickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.usePickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.usePickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
    },
	getseparateForPrivateAndusinessUsePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SeparateForPrivateAndusinessUse__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var separateForPrivateAndusinessUsePickMap = [];
                for(var key in result){
                    separateForPrivateAndusinessUsePickMap.push({key: key, value: result[key]});
                }
                component.set("v.separateForPrivateAndusinessUsePickMap", separateForPrivateAndusinessUsePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getprocedurePicklist: function(component, event) {
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
	gettransferDivisionPicklist: function(component, event) {
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
	getadditionalAndReturnAccountPicklist: function(component, event) {
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
	getnecessityOfReceiptPicklist: function(component, event) {
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
    },
    fetchDepValuesSub: function(component, ListOfDependentFields,listSubDependingValues) {
		// create a empty array var for store dependent picklist values for controller field  
		var dependentFields = [];
		dependentFields.push('--- None ---');
		for (var i = 0; i < ListOfDependentFields.length; i++) {
			dependentFields.push(ListOfDependentFields[i]);
		}
		// set the dependentFields variable values to store(dependent picklist field) on lightning:select
		 component.set(listSubDependingValues, dependentFields);
	}
})