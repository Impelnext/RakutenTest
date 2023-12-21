({
    saveAddressChange : function(cmp, event) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.ChangedPrefecture__c = cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c;
        obj.ChangedMunicipality__c = cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c;
        obj.ChangedAddress1__c = cmp.get("v.innerCmpNewRequest").ChangedAddress1__c;
           
        obj.ChangedPostNumber__c = cmp.get("v.innerCmpNewRequest").ChangedPostNumber__c;
        obj.ChangedBuildingName__c = cmp.get("v.innerCmpNewRequest").ChangedBuildingName__c;
        obj.Tel1__c = cmp.get("v.innerCmpNewRequest").Tel1__c;
        obj.Fax__c = cmp.get("v.innerCmpNewRequest").Fax__c;
        obj.PlanRelocationDate__c = cmp.get("v.innerCmpNewRequest").PlanRelocationDate__c;
        obj.ChangedAddress2__c = cmp.get("v.innerCmpNewRequest").ChangedAddress2__c;
        obj.Tel2__c = cmp.get("v.innerCmpNewRequest").Tel2__c;
        obj.ChangeReason__c = cmp.get("v.innerCmpNewRequest").ChangeReason__c;
        obj.JuniorSpecialContract__c = cmp.get("v.innerCmpNewRequest").JuniorSpecialContract__c;
        obj.ReflectMailingAddress__c = cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
        obj.ChangeAgencyRegistration__c = cmp.get("v.innerCmpNewRequest").ChangeAgencyRegistration__c;
        obj.AGRegistrationChange__c = cmp.get("v.innerCmpNewRequest").AGRegistrationChange__c;
        obj.RecruiterRegistration__c = cmp.get("v.innerCmpNewRequest").RecruiterRegistration__c;
        if(cmp.get("v.selectedLookUpRecord").Id != undefined){
            obj.RecordingPersonInCharge__c = cmp.get("v.selectedLookUpRecord").Id;
        }
        obj.RecordingCheckDate__c = cmp.get("v.innerCmpNewRequest").RecordingCheckDate__c;
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
    },
     handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c = '';
        cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c= '';
        cmp.get("v.innerCmpNewRequest").ChangedAddress1__c='';
        helper.areaInfo(cmp, event);     
    },
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getJuniorSpecialContractPicklist(component, event);
        helper.getAgencyChangePicklist(component, event);
        helper.getRegistrationChangePicklist(component, event);
        helper.getRecruiterRegistrationPicklist(component,event);
        helper.getProcessingPickList(component,event,dependantSubject);
    },   
})