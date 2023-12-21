({
	saveInlineConditionChangeAutomobileCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.DateOfChange__c= cmp.get("v.innerCmpNewRequest").DateOfChange__c;
		obj.DriverAgeRequirements__c= cmp.get("v.innerCmpNewRequest").DriverAgeRequirements__c;
		obj.ChangeOfRegisteredInsuredPerson__c= cmp.get("v.innerCmpNewRequest").ChangeOfRegisteredInsuredPerson__c;
		obj.NameOfInsuredPerson__c= cmp.get("v.innerCmpNewRequest").NameOfInsuredPerson__c;
		obj.DriverLimitedConditions__c= cmp.get("v.innerCmpNewRequest").DriverLimitedConditions__c;
		obj.IntendedUse__c= cmp.get("v.innerCmpNewRequest").IntendedUse__c;
		obj.AddOrDeleteSpecialContracts__c= cmp.get("v.innerCmpNewRequest").AddOrDeleteSpecialContracts__c;
		obj.ChangedSpecialContractName__c= cmp.get("v.innerCmpNewRequest").ChangedSpecialContractName__c;
		obj.ConditionChangeOtherInformation__c= cmp.get("v.innerCmpNewRequest").ConditionChangeOtherInformation__c;
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
	},
    init : function(component,event,helper){
        helper.getdriverAgeRequirementsPicklist(component, event);
		helper.getchangeOfRegistInsuredPersonPicklist(component, event);
		helper.getdriverLimitedConditionsPicklist(component, event);
		helper.getIntendedUsePicklist(component, event);
		helper.getaddOrDeleteSpecialContractsPicklist(component, event);
		helper.getprocedurePicklist(component, event);
		helper.gettransferDivisionPicklist(component, event);
		helper.getadditionalAndReturnAccountPicklist(component, event);
		helper.getnecessityOfReceiptPicklist(component, event);
    }
})