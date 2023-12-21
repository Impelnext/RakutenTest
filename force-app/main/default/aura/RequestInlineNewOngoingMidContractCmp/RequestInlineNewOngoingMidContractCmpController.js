({
	saveInlineNewOngoingMidContract : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.DesiredProduct__c=cmp.get("v.innerCmpNewRequest").DesiredProduct__c;
		obj.ReceptionCategory__c=cmp.get("v.innerCmpNewRequest").ReceptionCategory__c;
		obj.ReturnContact__c=cmp.get("v.innerCmpNewRequest").ReturnContact__c;
		obj.DateAndTimeDesignation__c=cmp.get("v.innerCmpNewRequest").DateAndTimeDesignation__c;
		obj.YourArea_Prefecture__c=cmp.get("v.innerCmpNewRequest").YourArea_Prefecture__c;
		obj.DetailsOfOtherRequests__c=cmp.get("v.innerCmpNewRequest").DetailsOfOtherRequests__c;
		obj.CompensationItem__c=cmp.get("v.innerCmpNewRequest").CompensationItem__c;
		obj.PrefectureBuildLocated__c=cmp.get("v.innerCmpNewRequest").PrefectureBuildLocated__c;
		obj.Use__c=cmp.get("v.innerCmpNewRequest").Use__c;
		obj.PropertyWithStoreInBuildingIndustry__c=cmp.get("v.innerCmpNewRequest").PropertyWithStoreInBuildingIndustry__c;
		obj.Construction__c=cmp.get("v.innerCmpNewRequest").Construction__c;
		obj.ConstructionDate__c=cmp.get("v.innerCmpNewRequest").ConstructionDate__c;
		obj.BuildingArea__c=cmp.get("v.innerCmpNewRequest").BuildingArea__c;
		obj.InsuredPersonsDateOfBirth__c=cmp.get("v.innerCmpNewRequest").InsuredPersonsDateOfBirth__c;
		obj.Profession__c=cmp.get("v.innerCmpNewRequest").Profession__c;
		obj.SubscriptionType__c=cmp.get("v.innerCmpNewRequest").SubscriptionType__c;
		obj.ReceptionCategoryCarInsurance__c=cmp.get("v.innerCmpNewRequest").ReceptionCategoryCarInsurance__c;
		obj.Grades__c=cmp.get("v.innerCmpNewRequest").Grades__c;
		obj.AccidentCoefficientPeriod__c=cmp.get("v.innerCmpNewRequest").AccidentCoefficientPeriod__c;
		obj.InsurancePeriod__c=cmp.get("v.innerCmpNewRequest").InsurancePeriod__c;
		obj.AccidentDuringFlg__c=cmp.get("v.innerCmpNewRequest").AccidentDuringFlg__c;
		obj.MainlyUseCars__c=cmp.get("v.innerCmpNewRequest").MainlyUseCars__c;
		obj.YoungestDriver__c=cmp.get("v.innerCmpNewRequest").YoungestDriver__c;
		obj.TargetVehicle__c=cmp.get("v.innerCmpNewRequest").TargetVehicle__c;
		obj.VehicleUse__c=cmp.get("v.innerCmpNewRequest").VehicleUse__c;
		obj.DesiredCompensation__c=cmp.get("v.innerCmpNewRequest").DesiredCompensation__c;
		obj.Industry__c=cmp.get("v.innerCmpNewRequest").Industry__c;
		obj.SpecificWorkContent=cmp.get("v.innerCmpNewRequest").SpecificWorkContent;
		obj.Continue__c=cmp.get("v.innerCmpNewRequest").Continue__c;
		obj.RenewalRequested__c=cmp.get("v.innerCmpNewRequest").RenewalRequested__c;	
        obj.SpecificWorkContent__c = cmp.get("v.innerCmpNewRequest").SpecificWorkContent__c;
	},
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getReceptionCategoryPicklist(component, event);
		helper.getCompensationItemPicklist(component, event);
		helper.getUsePicklist(component, event,dependantSubject);
		helper.getConstructionPicklist(component, event);
		helper.getSubscriptionTypePicklist(component, event);
		helper.getReceptionCategoryCarInsurancePicklist(component, event);
		helper.getAccidentDuringFlgPicklist(component, event);
		helper.getTargetVehiclePicklist(component, event);
		helper.getVehicleUsePicklist(component, event);		
		
    }
})