({
   saveInlineInsuranceAmountChange : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;  
		obj.DateOfChange__c=cmp.get("v.innerCmpNewRequest").DateOfChange__c;
		obj.VehicleInsuranceAmount__c=cmp.get("v.innerCmpNewRequest").VehicleInsuranceAmount__c;
		obj.Interpersonal__c=cmp.get("v.innerCmpNewRequest").Interpersonal__c;
		obj.Objective__c=cmp.get("v.innerCmpNewRequest").Objective__c;
		obj.Disclaimer__c=cmp.get("v.innerCmpNewRequest").Disclaimer__c;
		obj.PersonalInjury__c=cmp.get("v.innerCmpNewRequest").PersonalInjury__c;
		obj.PersonalInjuryExternalCompensation__c=cmp.get("v.innerCmpNewRequest").PersonalInjuryExternalCompensation__c;
		obj.PassengerInjuryDaysPartDoublePayment__c=cmp.get("v.innerCmpNewRequest").PassengerInjuryDaysPartDoublePayment__c;
		obj.PassengerInjuryInsuranceAmount__c=cmp.get("v.innerCmpNewRequest").PassengerInjuryInsuranceAmount__c;
		obj.PassengerInjuryDayOfHospitalization__c=cmp.get("v.innerCmpNewRequest").PassengerInjuryDayOfHospitalization__c;
		obj.PassengerInjuryDailyFee__c=cmp.get("v.innerCmpNewRequest").PassengerInjuryDailyFee__c;
		obj.ChangeInsuranceAmountOtherInformation__c=cmp.get("v.innerCmpNewRequest").ChangeInsuranceAmountOtherInformation__c;
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
	    helper.getPersonalInjuryExternalCompensationPicklist(component, event);
		helper.getProcedurePicklist(component, event);
		helper.getTransferDivisionPicklist(component, event);
		helper.getAdditionalAndReturnAccountPicklist(component, event);
		helper.getNecessityOfReceiptPicklist(component, event);
	}
})