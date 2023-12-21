({
    getappLicationModelPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AppLicationModel__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var appLicationModelPickMap = [];
                for(var key in result){
                    appLicationModelPickMap.push({key: key, value: result[key]});
                }
                component.set("v.appLicationModelPickMap", appLicationModelPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getfirstRegistrationDate1picklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'FirstRegistrationDate1__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var firstRegistrationDate1PickMap = [];
                for(var key in result){
                    firstRegistrationDate1PickMap.push({key: key, value: result[key]});
                }
                component.set("v.firstRegistrationDate1PickMap", firstRegistrationDate1PickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcarOwnerTypepicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CarOwnerType__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var carOwnerTypePickMap = [];
                for(var key in result){
                    carOwnerTypePickMap.push({key: key, value: result[key]});
                }
                component.set("v.carOwnerTypePickMap", carOwnerTypePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	
	getCarBodyShapePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CarBodyShape__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var carBodyShapePickMap = [];
                for(var key in result){
                    carBodyShapePickMap.push({key: key, value: result[key]});
                }
                component.set("v.carBodyShapePickMap", carBodyShapePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getafterChangedCasePicklist: function(component, event,dependantSubject) {
        var subDepAction = component.get("c.getDependentMap");
        subDepAction.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'Subject__c',
            depfieldApiName : 'AfterChangedCase__c'
        });
        subDepAction.setCallback(this, function(subDepResponse){   
            if(subDepResponse.getState() === "SUCCESS"){
                var depSubResponse = subDepResponse.getReturnValue();                
                component.set("v.afterChangedCasePickMap",depSubResponse);
                var depnedentFieldSubProcessingMap = component.get("v.afterChangedCasePickMap");
                var ListOfDependentFieldsSubProcessing = depnedentFieldSubProcessingMap[dependantSubject];
                if(ListOfDependentFieldsSubProcessing.length > 0){
                    this.fetchDepValuesSub(component, ListOfDependentFieldsSubProcessing,"v.afterChangedCasePickList");    
                }   
            }         
        });
        $A.enqueueAction(subDepAction);
    },
	getfuelTypeCarPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'FuelTypeCar__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var fuelTypeCarPickMap = [];
                for(var key in result){
                    fuelTypeCarPickMap.push({key: key, value: result[key]});
                }
                component.set("v.fuelTypeCarPickMap", fuelTypeCarPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getwelfareVehiclesPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'WelfareVehicles__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var welfareVehiclesPickMap = [];
                for(var key in result){
                    welfareVehiclesPickMap.push({key: key, value: result[key]});
                }
                component.set("v.welfareVehiclesPickMap", welfareVehiclesPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	gethybridCarPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'HybridCar__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var hybridCarPickMap = [];
                for(var key in result){
                    hybridCarPickMap.push({key: key, value: result[key]});
                }
                component.set("v.hybridCarPickMap", hybridCarPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getisElectricOrHydrogenPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'IsElectricOrHydrogen__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var isElectricOrHydrogenPickMap = [];
                for(var key in result){
                    isElectricOrHydrogenPickMap.push({key: key, value: result[key]});
                }
                component.set("v.isElectricOrHydrogenPickMap", isElectricOrHydrogenPickMap);
            }
        });
        $A.enqueueAction(action);
    },	
	getvehicleInsuranceTypePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'VehicleInsuranceType__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var vehicleInsuranceTypePickMap = [];
                for(var key in result){
                    vehicleInsuranceTypePickMap.push({key: key, value: result[key]});
                }
                component.set("v.vehicleInsuranceTypePickMap", vehicleInsuranceTypePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getvehicleNegligencePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'VehicleNegligence__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var vehicleNegligencePickMap = [];
                for(var key in result){
                    vehicleNegligencePickMap.push({key: key, value: result[key]});
                }
                component.set("v.vehicleNegligencePickMap", vehicleNegligencePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getextraordinaryLossesPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ExtraordinaryLosses__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var extraordinaryLossesPickMap = [];
                for(var key in result){
                    extraordinaryLossesPickMap.push({key: key, value: result[key]});
                }
                component.set("v.extraordinaryLossesPickMap", extraordinaryLossesPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getnewCarAcquisitionCostPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'NewCarAcquisitionCost__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var newCarAcquisitionCostPickMap = [];
                for(var key in result){
                    newCarAcquisitionCostPickMap.push({key: key, value: result[key]});
                }
                component.set("v.newCarAcquisitionCostPickMap", newCarAcquisitionCostPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getinterpersonalCompensationPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'InterpersonalCompensation__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var interpersonalCompensationPickMap = [];
                for(var key in result){
                    interpersonalCompensationPickMap.push({key: key, value: result[key]});
                }
                component.set("v.interpersonalCompensationPickMap", interpersonalCompensationPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getobjectiveCompensationPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ObjectiveCompensation__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var objectiveCompensationPickMap = [];
                for(var key in result){
                    objectiveCompensationPickMap.push({key: key, value: result[key]});
                }
                component.set("v.objectiveCompensationPickMap", objectiveCompensationPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getoverObjectiveRepairCostsPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OverObjectiveRepairCosts__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var overObjectiveRepairCostsPickMap = [];
                for(var key in result){
                    overObjectiveRepairCostsPickMap.push({key: key, value: result[key]});
                }
                component.set("v.overObjectiveRepairCostsPickMap", overObjectiveRepairCostsPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getisEarthquakeEruptionTsunamiPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'IsEarthquakeEruptionTsunami__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var isEarthquakeEruptionTsunamiPickMap = [];
                for(var key in result){
                    isEarthquakeEruptionTsunamiPickMap.push({key: key, value: result[key]});
                }
                component.set("v.isEarthquakeEruptionTsunamiPickMap", isEarthquakeEruptionTsunamiPickMap);
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
	getcarVerificationInstallationPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CarVerificationInstallation__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var carVerificationInstallationPickMap = [];
                for(var key in result){
                    carVerificationInstallationPickMap.push({key: key, value: result[key]});
                }
                component.set("v.carVerificationInstallationPickMap", carVerificationInstallationPickMap);
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