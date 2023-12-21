({
    saveComplaints : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;       
        obj.DateOfCall__c = cmp.get("v.innerCmpNewRequest").DateOfCall__c;
        obj.Receptionist__c = cmp.get("v.innerCmpNewRequest").Receptionist__c;
        obj.VOCType__c = cmp.get("v.innerCmpNewRequest").VOCType__c;
        obj.ComplaintSummary__c = cmp.get("v.innerCmpNewRequest").ComplaintSummary__c;
        obj.ClosedDate__c = cmp.get("v.innerCmpNewRequest").ClosedDate__c;
        obj.ComplaintResult__c = cmp.get("v.innerCmpNewRequest").ComplaintResult__c;
        obj.ComplaintReason__c = cmp.get("v.innerCmpNewRequest").ComplaintReason__c;
        obj.PreventionOfComplaint__c = cmp.get("v.innerCmpNewRequest").PreventionOfComplaint__c;
        obj.AdditionalReasons__c = cmp.get("v.innerCmpNewRequest").AdditionalReasons__c;
        obj.CauseOfCompany__c = cmp.get("v.innerCmpNewRequest").CauseOfCompany__c;
        obj.CauseOfDivision__c = cmp.get("v.innerCmpNewRequest").CauseOfDivision__c;
        obj.CauseOfDepartment__c = cmp.get("v.innerCmpNewRequest").CauseOfDepartment__c;
        obj.Originator__c = cmp.get("v.innerCmpNewRequest").Originator__c;
        obj.InsuranceCompany__c = cmp.get("v.innerCmpNewRequest").InsuranceCompany__c;
        obj.ReceptionDepartment__c = cmp.get("v.innerCmpNewRequest").ReceptionDepartment__c;
    },
    init : function(component,event,helper){
        helper.getVOCTypePickList(component, event);
        helper.getAdditionalReasonsPickList(component, event);
        helper.getCauseOfCompanyPick(component, event);
        helper.getCauseOfDivisionPick(component, event);
        helper.getInsuranceCompanyPick(component, event);
        helper.getDivisionSummaryMap(component, event);
    },
      handleVOCTypePickListChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
	  handleAdditionalReasonsPickListChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
	  handleCauseOfCompanyPick: function (component, event) {  
        var selectedValues = event.getParam("value");
    },
    handleInsuranceCompanyPick: function(component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        helper.changeInsuranceCompany(component, event, selectedValues);
    },
    handleCauseOfDivisionPick: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        helper.changeCauseOfDivision(component, event, selectedValues);
    }
})