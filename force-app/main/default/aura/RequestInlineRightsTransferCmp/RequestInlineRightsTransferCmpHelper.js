({
	getchangesPicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'Changes__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.changesPickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.changesPickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.changesPickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
    },
	getrelationshipChngContractPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RelationshipChangedContractor__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var relationshipChngContractPickMap = [];
                for(var key in result){
                    relationshipChngContractPickMap.push({key: key, value: result[key]});
                }
                component.set("v.relationshipChngContractPickMap", relationshipChngContractPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getgenderAfterChangePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'GenderAfterChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var genderAfterChangePickMap = [];
                for(var key in result){
                    genderAfterChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.genderAfterChangePickMap", genderAfterChangePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getaccountCreditCardChangePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AccountCreditCardChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var accountCreditCardChangePickMap = [];
                for(var key in result){
                    accountCreditCardChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.accountCreditCardChangePickMap", accountCreditCardChangePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getrecipientChangePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RecipientChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var recipientChangePickMap = [];
                for(var key in result){
                    recipientChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.recipientChangePickMap", recipientChangePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getnenrinOnlyChangeInBeneficiaryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'NenrinOnlyChangeInBeneficiary__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var nenrinOnlyChangeInBeneficiaryPickMap = [];
                for(var key in result){
                    nenrinOnlyChangeInBeneficiaryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.nenrinOnlyChangeInBeneficiaryPickMap", nenrinOnlyChangeInBeneficiaryPickMap);
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