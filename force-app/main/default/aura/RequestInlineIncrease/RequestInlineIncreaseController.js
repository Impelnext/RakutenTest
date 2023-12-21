({
    saveInlineIncrease : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
            obj.DeliveryDate__c=cmp.get("v.innerCmpNewRequest").DeliveryDate__c;
			obj.AppLicationModel__c=cmp.get("v.innerCmpNewRequest").AppLicationModel__c;
			obj.MaximumLoadingCapacity__c=cmp.get("v.innerCmpNewRequest").MaximumLoadingCapacity__c;
			obj.CarBodyShape__c=cmp.get("v.innerCmpNewRequest").CarBodyShape__c;
			obj.AfterChangedCase__c=cmp.get("v.innerCmpNewRequest").AfterChangedCase__c;
			obj.CarNo__c=cmp.get("v.innerCmpNewRequest").CarNo__c;
			obj.FirstRegistrationDate1__c=cmp.get("v.innerCmpNewRequest").FirstRegistrationDate1__c;
			obj.FirstRegistrationDate2__c=cmp.get("v.innerCmpNewRequest").FirstRegistrationDate2__c;
			obj.CarBodyNoRight__c=cmp.get("v.innerCmpNewRequest").CarBodyNoRight__c;
			obj.Model__c=cmp.get("v.innerCmpNewRequest").Model__c;
			obj.Displacement__c=cmp.get("v.innerCmpNewRequest").Displacement__c;
			obj.FuelTypeCar__c=cmp.get("v.innerCmpNewRequest").FuelTypeCar__c;
			obj.CarOwnerType__c=cmp.get("v.innerCmpNewRequest").CarOwnerType__c;
            obj.CarBodyNoLeft__c=cmp.get("v.innerCmpNewRequest").CarBodyNoLeft__c;
			obj.TotalAmountCarAndAccessoryPrice__c=cmp.get("v.innerCmpNewRequest").TotalAmountCarAndAccessoryPrice__c;
			obj.WelfareVehicles__c=cmp.get("v.innerCmpNewRequest").WelfareVehicles__c;
			obj.HybridCar__c=cmp.get("v.innerCmpNewRequest").HybridCar__c;
			obj.IsElectricOrHydrogen__c=cmp.get("v.innerCmpNewRequest").IsElectricOrHydrogen__c;
			obj.AdditionalVehicleInformation__c=cmp.get("v.innerCmpNewRequest").AdditionalVehicleInformation__c;
			obj.VehicleInsuranceAmountPer10K__c=cmp.get("v.innerCmpNewRequest").VehicleInsuranceAmountPer10K__c;
			obj.VehicleInsuranceType__c=cmp.get("v.innerCmpNewRequest").VehicleInsuranceType__c;
			obj.ExemptionAmount1st__c=cmp.get("v.innerCmpNewRequest").ExemptionAmount1st__c;
			obj.ExemptionAmount2nd__c=cmp.get("v.innerCmpNewRequest").ExemptionAmount2nd__c;
			obj.VehicleNegligence__c=cmp.get("v.innerCmpNewRequest").VehicleNegligence__c;
			obj.ExtraordinaryLosses__c=cmp.get("v.innerCmpNewRequest").ExtraordinaryLosses__c;
			obj.NewCarAcquisitionCost__c=cmp.get("v.innerCmpNewRequest").NewCarAcquisitionCost__c;
			obj.InterpersonalCompensation__c=cmp.get("v.innerCmpNewRequest").InterpersonalCompensation__c;
			obj.ObjectiveCompensation__c=cmp.get("v.innerCmpNewRequest").ObjectiveCompensation__c;
			obj.OverObjectiveRepairCosts__c=cmp.get("v.innerCmpNewRequest").OverObjectiveRepairCosts__c;
			obj.IsEarthquakeEruptionTsunami__c=cmp.get("v.innerCmpNewRequest").IsEarthquakeEruptionTsunami__c;
			obj.CompensationDetailsOtherInformation__c=cmp.get("v.innerCmpNewRequest").CompensationDetailsOtherInformation__c;
			obj.Procedure__c=cmp.get("v.innerCmpNewRequest").Procedure__c;
			obj.AdditionalRefundPremiumYen__c=cmp.get("v.innerCmpNewRequest").AdditionalRefundPremiumYen__c;
			obj.TransferDivision__c=cmp.get("v.innerCmpNewRequest").TransferDivision__c;
			obj.AdditionalAndReturnAccount__c=cmp.get("v.innerCmpNewRequest").AdditionalAndReturnAccount__c;
			obj.VirtualAccountPaymentDueDate__c=cmp.get("v.innerCmpNewRequest").VirtualAccountPaymentDueDate__c;
			obj.BillingMonth__c=cmp.get("v.innerCmpNewRequest").BillingMonth__c;
			obj.CarVerificationInstallation__c=cmp.get("v.innerCmpNewRequest").CarVerificationInstallation__c;
			obj.NecessityOfReceipt__c=cmp.get("v.innerCmpNewRequest").NecessityOfReceipt__c;
			obj.PrintingSequenceNumber__c=cmp.get("v.innerCmpNewRequest").PrintingSequenceNumber__c;
			obj.ProcedureMethodOtherInfo__c=cmp.get("v.innerCmpNewRequest").ProcedureMethodOtherInfo__c;
        	obj.AddVehicleUserKanji__c=cmp.get("v.innerCmpNewRequest").AddVehicleUserKanji__c;
            obj.CarName__c=cmp.get("v.innerCmpNewRequest").CarName__c;
        	obj.AppLicationModelFreeText__c = cmp.get("v.innerCmpNewRequest").AppLicationModelFreeText__c;
    },    
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getappLicationModelPicklist(component, event);
        helper.getCarBodyShapePicklist(component, event);
        helper.getafterChangedCasePicklist(component, event,dependantSubject);
        helper.getfuelTypeCarPicklist(component, event);
        helper.getwelfareVehiclesPicklist(component, event);
        helper.gethybridCarPicklist(component, event);
        helper.getisElectricOrHydrogenPicklist(component, event);
        helper.getvehicleInsuranceTypePicklist(component, event);
        helper.getvehicleNegligencePicklist(component, event);
        helper.getextraordinaryLossesPicklist(component, event);
        helper.getnewCarAcquisitionCostPicklist(component, event);
        helper.getinterpersonalCompensationPicklist(component, event);
        helper.getobjectiveCompensationPicklist(component, event);
        helper.getoverObjectiveRepairCostsPicklist(component, event);
        helper.getisEarthquakeEruptionTsunamiPicklist(component, event);
        helper.getprocedurePicklist(component, event);
        helper.gettransferDivisionPicklist(component, event);
        helper.getadditionalAndReturnAccountPicklist(component, event);
        helper.getcarVerificationInstallationPicklist(component, event);
        helper.getnecessityOfReceiptPicklist(component, event);
		helper.getfirstRegistrationDate1picklist(component, event);
		helper.getcarOwnerTypepicklist(component, event);
		
    }
})