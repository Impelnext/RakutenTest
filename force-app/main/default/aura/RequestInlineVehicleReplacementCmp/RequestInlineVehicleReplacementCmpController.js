({
    saveInlineVehicleReplacement : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.InsuranceTypeAsapPap__c=cmp.get("v.innerCmpNewRequest").InsuranceTypeAsapPap__c;
		obj.DeliveryDate__c=cmp.get("v.innerCmpNewRequest").DeliveryDate__c;
		obj.CarOwnerType__c=cmp.get("v.innerCmpNewRequest").CarOwnerType__c;
		obj.CarOwnerKana__c=cmp.get("v.innerCmpNewRequest").CarOwnerKana__c;
		obj.CarOwnerKanji__c=cmp.get("v.innerCmpNewRequest").CarOwnerKanji__c;
		obj.AppLicationModel__c=cmp.get("v.innerCmpNewRequest").AppLicationModel__c;
		obj.MaximumLoadingCapacity__c=cmp.get("v.innerCmpNewRequest").MaximumLoadingCapacity__c;
		obj.CarBodyShape__c=cmp.get("v.innerCmpNewRequest").CarBodyShape__c;
		obj.CarBOdyShapeOther__c=cmp.get("v.innerCmpNewRequest").CarBOdyShapeOther__c;
		obj.AfterChangedCase__c=cmp.get("v.innerCmpNewRequest").AfterChangedCase__c;
		obj.CarNumberShikyokuKanji__c=cmp.get("v.innerCmpNewRequest").CarNumberShikyokuKanji__c;
		obj.CarNumberShikyokuKana__c=cmp.get("v.innerCmpNewRequest").CarNumberShikyokuKana__c;
		obj.CarNumberBunrui__c=cmp.get("v.innerCmpNewRequest").CarNumberBunrui__c;
		obj.CarNumberKana__c=cmp.get("v.innerCmpNewRequest").CarNumberKana__c;
		obj.CarNumberNumber__c=cmp.get("v.innerCmpNewRequest").CarNumberNumber__c;
		obj.FirstRegistrationDate1__c=cmp.get("v.innerCmpNewRequest").FirstRegistrationDate1__c;
		obj.FirstRegistrationDate2__c=cmp.get("v.innerCmpNewRequest").FirstRegistrationDate2__c;
		obj.CarBodyNoLeft__c=cmp.get("v.innerCmpNewRequest").CarBodyNoLeft__c;
		obj.CarBodyNoRight__c=cmp.get("v.innerCmpNewRequest").CarBodyNoRight__c;
		obj.Model__c=cmp.get("v.innerCmpNewRequest").Model__c;
		obj.Displacement__c=cmp.get("v.innerCmpNewRequest").Displacement__c;
		obj.FuelTypeCar__c=cmp.get("v.innerCmpNewRequest").FuelTypeCar__c;
		obj.FuelTypeCarOther__c=cmp.get("v.innerCmpNewRequest").FuelTypeCarOther__c;
		obj.AddVehicleUserKana__c=cmp.get("v.innerCmpNewRequest").AddVehicleUserKana__c;
		obj.AddVehicleUserKanji__c=cmp.get("v.innerCmpNewRequest").AddVehicleUserKanji__c;
		obj.HybridCar__c=cmp.get("v.innerCmpNewRequest").HybridCar__c;
		obj.CarName__c=cmp.get("v.innerCmpNewRequest").CarName__c;
		obj.TotalAmount__c=cmp.get("v.innerCmpNewRequest").TotalAmount__c;
		obj.WelfareVehicles__c=cmp.get("v.innerCmpNewRequest").WelfareVehicles__c;
		obj.IsElectricOrHydrogen__c=cmp.get("v.innerCmpNewRequest").IsElectricOrHydrogen__c;
		obj.AutomaticBrake__c=cmp.get("v.innerCmpNewRequest").AutomaticBrake__c;
		obj.VehicleInsuranceType__c=cmp.get("v.innerCmpNewRequest").VehicleInsuranceType__c;
		obj.VehicleInsuranceAmountPer10K__c=cmp.get("v.innerCmpNewRequest").VehicleInsuranceAmountPer10K__c;
		obj.ExemptionAmount1st__c=cmp.get("v.innerCmpNewRequest").ExemptionAmount1st__c;
		obj.ExemptionAmount2nd__c=cmp.get("v.innerCmpNewRequest").ExemptionAmount2nd__c;
		obj.VehicleNegligence__c=cmp.get("v.innerCmpNewRequest").VehicleNegligence__c;
		obj.ExtraordinaryLosses__c=cmp.get("v.innerCmpNewRequest").ExtraordinaryLosses__c;
		obj.NewCarAcquisitionCost__c=cmp.get("v.innerCmpNewRequest").NewCarAcquisitionCost__c;
		obj.InterpersonalCompensation__c=cmp.get("v.innerCmpNewRequest").InterpersonalCompensation__c;
		obj.ObjectiveCompensation__c=cmp.get("v.innerCmpNewRequest").ObjectiveCompensation__c;
		obj.OverObjectiveRepairCosts__c=cmp.get("v.innerCmpNewRequest").OverObjectiveRepairCosts__c;
		obj.IsEarthquakeEruptionTsunami__c=cmp.get("v.innerCmpNewRequest").IsEarthquakeEruptionTsunami__c;
		obj.RequestForCompensationOtherInfo__c=cmp.get("v.innerCmpNewRequest").RequestForCompensationOtherInfo__c;
		obj.Procedure__c=cmp.get("v.innerCmpNewRequest").Procedure__c;
		obj.AdditionalRefundPremiumYen__c=cmp.get("v.innerCmpNewRequest").AdditionalRefundPremiumYen__c;
		obj.TransferDivision__c=cmp.get("v.innerCmpNewRequest").TransferDivision__c;
		obj.AdditionalAndReturnAccount__c=cmp.get("v.innerCmpNewRequest").AdditionalAndReturnAccount__c;
		obj.VirtualAccountPaymentDueDate__c=cmp.get("v.innerCmpNewRequest").VirtualAccountPaymentDueDate__c;
		obj.BillingMonth__c=cmp.get("v.innerCmpNewRequest").BillingMonth__c;
		obj.NecessityOfReceipt__c=cmp.get("v.innerCmpNewRequest").NecessityOfReceipt__c;
		obj.PrintingSequenceNumber__c=cmp.get("v.innerCmpNewRequest").PrintingSequenceNumber__c;
		obj.EndorsementNumber__c=cmp.get("v.innerCmpNewRequest").EndorsementNumber__c;
		obj.TransferApprovalDate__c=cmp.get("v.innerCmpNewRequest").TransferApprovalDate__c;
		obj.ProcedureMethodOtherInfo__c=cmp.get("v.innerCmpNewRequest").ProcedureMethodOtherInfo__c;


    },    
    init : function(component,event,helper){
		helper.fetchPicklistValues(component,'Request__c','InsuranceTypeAsapPap__c', 'AppLicationModel__c');
        var dependantSubject = component.get('v.dependantSubject');
				helper.getInsuranceTypeAsapPapPicklist(component, event);
				helper.getCarOwnerTypePicklist(component, event);
				helper.getAppLicationModelPicklist(component, event);
				helper.getCarBodyShapePicklist(component, event);
				helper.getAfterChangedCasePicklist(component, event,dependantSubject);
				helper.getFirstRegistrationDate1Picklist(component, event);
				helper.getFuelTypeCarPicklist(component, event);
				helper.getHybridCarPicklist(component, event);
				helper.getWelfareVehiclesPicklist(component, event);
				helper.getIsElectricOrHydrogenPicklist(component, event);
				helper.getAutomaticBrakePicklist(component, event);
				helper.getVehicleInsuranceTypePicklist(component, event);
				helper.getVehicleNegligencePicklist(component, event);
				helper.getExtraordinaryLossesPicklist(component, event);
				helper.getNewCarAcquisitionCostPicklist(component, event);
				helper.getInterpersonalCompensationPicklist(component, event);
				helper.getObjectiveCompensationPicklist(component, event);
				helper.getOverObjectiveRepairCostsPicklist(component, event);
				helper.getIsEarthquakeEruptionTsunamiPicklist(component, event);
				helper.getProcedurePicklist(component, event);
				helper.getTransferDivisionPicklist(component, event);
				helper.getAdditionalAndReturnAccountPicklist(component, event);
				helper.getNecessityOfReceiptPicklist(component, event);
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
})