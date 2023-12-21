({
	saveInlineChangeModelCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.RelocationDate__c= cmp.get("v.innerCmpNewRequest").RelocationDate__c;
		obj.Use__c= cmp.get("v.innerCmpNewRequest").Use__c;
		obj.SeparateForPrivateAndusinessUse__c= cmp.get("v.innerCmpNewRequest").SeparateForPrivateAndusinessUse__c;
		obj.VehicleAfterChangeOtherInformation__c= cmp.get("v.innerCmpNewRequest").VehicleAfterChangeOtherInformation__c;
		obj.Procedure__c= cmp.get("v.innerCmpNewRequest").Procedure__c;
		obj.AdditionalRefundPremiumYen__c= cmp.get("v.innerCmpNewRequest").AdditionalRefundPremiumYen__c;
		obj.TransferDivision__c= cmp.get("v.innerCmpNewRequest").TransferDivision__c;
		obj.AdditionalAndReturnAccount__c= cmp.get("v.innerCmpNewRequest").AdditionalAndReturnAccount__c;
		obj.VirtualAccountPaymentDueDate__c= cmp.get("v.innerCmpNewRequest").VirtualAccountPaymentDueDate__c;
		obj.BillingMonth__c= cmp.get("v.innerCmpNewRequest").BillingMonth__c;
		obj.NecessityOfReceipt__c= cmp.get("v.innerCmpNewRequest").NecessityOfReceipt__c;
		obj.PrintingSequenceNumber__c= cmp.get("v.innerCmpNewRequest").PrintingSequenceNumber__c;
		obj.EndorsementNumber__c= cmp.get("v.innerCmpNewRequest").EndorsementNumber__c;
		obj.TransferApprovalDate__c= cmp.get("v.innerCmpNewRequest").TransferApprovalDate__c;
		obj.ProcedureMethodOtherInfo__c= cmp.get("v.innerCmpNewRequest").ProcedureMethodOtherInfo__c;
        obj.AppLicationModelFreeText__c = cmp.get("v.innerCmpNewRequest").AppLicationModelFreeText__c;
	},
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getusePicklist(component, event,dependantSubject);
		helper.getseparateForPrivateAndusinessUsePicklist(component, event);
		helper.getprocedurePicklist(component, event);
		helper.gettransferDivisionPicklist(component, event);
		helper.getadditionalAndReturnAccountPicklist(component, event);
		helper.getnecessityOfReceiptPicklist(component, event);
    }
})