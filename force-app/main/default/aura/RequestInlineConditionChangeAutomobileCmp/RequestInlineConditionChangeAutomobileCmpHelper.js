({
	getdriverAgeRequirementsPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DriverAgeRequirements__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var driverAgeRequirementsPickMap = [];
                for(var key in result){
                    driverAgeRequirementsPickMap.push({key: key, value: result[key]});
                }
                component.set("v.driverAgeRequirementsPickMap", driverAgeRequirementsPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getchangeOfRegistInsuredPersonPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangeOfRegisteredInsuredPerson__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var changeOfRegistInsuredPersonPickMap = [];
                for(var key in result){
                    changeOfRegistInsuredPersonPickMap.push({key: key, value: result[key]});
                }
                component.set("v.changeOfRegistInsuredPersonPickMap", changeOfRegistInsuredPersonPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getdriverLimitedConditionsPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DriverLimitedConditions__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var driverLimitedConditionsPickMap = [];
                for(var key in result){
                    driverLimitedConditionsPickMap.push({key: key, value: result[key]});
                }
                component.set("v.driverLimitedConditionsPickMap", driverLimitedConditionsPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getIntendedUsePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'IntendedUse__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var IntendedUsePickMap = [];
                for(var key in result){
                    IntendedUsePickMap.push({key: key, value: result[key]});
                }
                component.set("v.IntendedUsePickMap", IntendedUsePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getaddOrDeleteSpecialContractsPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AddOrDeleteSpecialContracts__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var addOrDeleteSpecialContractsPickMap = [];
                for(var key in result){
                    addOrDeleteSpecialContractsPickMap.push({key: key, value: result[key]});
                }
                component.set("v.addOrDeleteSpecialContractsPickMap", addOrDeleteSpecialContractsPickMap);
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
    }
})