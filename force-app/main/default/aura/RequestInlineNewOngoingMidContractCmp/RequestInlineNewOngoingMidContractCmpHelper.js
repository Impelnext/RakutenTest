({
	getReceptionCategoryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ReceptionCategory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var receptionCategoryPickMap = [];
                for(var key in result){
                    receptionCategoryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.receptionCategoryPickMap", receptionCategoryPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getCompensationItemPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CompensationItem__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var compensationItemPickMap = [];
                for(var key in result){
                    compensationItemPickMap.push({key: key, value: result[key]});
                }
                component.set("v.compensationItemPickMap", compensationItemPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getUsePicklist: function(component, event,dependantSubject) {
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
	getConstructionPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'Construction__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var constructionPickMap = [];
                for(var key in result){
                    constructionPickMap.push({key: key, value: result[key]});
                }
                component.set("v.constructionPickMap", constructionPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getSubscriptionTypePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SubscriptionType__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var subscriptionTypePickMap = [];
                for(var key in result){
                    subscriptionTypePickMap.push({key: key, value: result[key]});
                }
                component.set("v.subscriptionTypePickMap", subscriptionTypePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getReceptionCategoryCarInsurancePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ReceptionCategoryCarInsurance__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var receptionCategoryCarInsurancePickMap = [];
                for(var key in result){
                    receptionCategoryCarInsurancePickMap.push({key: key, value: result[key]});
                }
                component.set("v.receptionCategoryCarInsurancePickMap", receptionCategoryCarInsurancePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getAccidentDuringFlgPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AccidentDuringFlg__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var accidentDuringFlgPickMap = [];
                for(var key in result){
                    accidentDuringFlgPickMap.push({key: key, value: result[key]});
                }
                component.set("v.accidentDuringFlgPickMap", accidentDuringFlgPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getTargetVehiclePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'TargetVehicle__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var targetVehiclePickMap = [];
                for(var key in result){
                    targetVehiclePickMap.push({key: key, value: result[key]});
                }
                component.set("v.targetVehiclePickMap", targetVehiclePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getVehicleUsePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'VehicleUse__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var vehicleUsePickMap = [];
                for(var key in result){
                    vehicleUsePickMap.push({key: key, value: result[key]});
                }
                component.set("v.vehicleUsePickMap", vehicleUsePickMap);
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