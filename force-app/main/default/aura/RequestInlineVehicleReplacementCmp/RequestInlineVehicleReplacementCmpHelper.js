({
    getInsuranceTypeAsapPapPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'InsuranceTypeAsapPap__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var insuranceTypeAsapPapPickMap = [];
                for(var key in result){
                    insuranceTypeAsapPapPickMap.push({key: key, value: result[key]});
                }
                component.set("v.insuranceTypeAsapPapPickMap", insuranceTypeAsapPapPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getCarOwnerTypePicklist: function(component, event) {
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
	getAppLicationModelPicklist: function(component, event) {
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
	getAfterChangedCasePicklist: function(component, event,dependantSubject) {
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
	getFirstRegistrationDate1Picklist: function(component, event) {
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
	getFuelTypeCarPicklist: function(component, event) {
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
		getHybridCarPicklist: function(component, event) {
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
    getWelfareVehiclesPicklist: function(component, event) {
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
    getIsElectricOrHydrogenPicklist: function(component, event) {
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
    getAutomaticBrakePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AutomaticBrake__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var automaticBrakePickMap = [];
                for(var key in result){
                    automaticBrakePickMap.push({key: key, value: result[key]});
                }
                component.set("v.automaticBrakePickMap", automaticBrakePickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getVehicleInsuranceTypePicklist: function(component, event) {
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
    getVehicleNegligencePicklist: function(component, event) {
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
    getExtraordinaryLossesPicklist: function(component, event) {
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
    getNewCarAcquisitionCostPicklist: function(component, event) {
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
    getInterpersonalCompensationPicklist: function(component, event) {
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
    getObjectiveCompensationPicklist: function(component, event) {
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
    getOverObjectiveRepairCostsPicklist: function(component, event) {
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
    getIsEarthquakeEruptionTsunamiPicklist: function(component, event) {
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
    },
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--- None ---');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
            }else{
                alert('Error:');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
})