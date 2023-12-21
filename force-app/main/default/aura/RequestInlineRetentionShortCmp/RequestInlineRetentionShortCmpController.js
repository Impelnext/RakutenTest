({
    saveRequestInlineRetentionShort : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.ReasonForProposal__c=cmp.get("v.innerCmpNewRequest").ReasonForProposal__c;
        obj.ContinuationProposal__c=cmp.get("v.innerCmpNewRequest").ContinuationProposal__c;
        obj.ContinuationProposalComments__c=cmp.get("v.innerCmpNewRequest").ContinuationProposalComments__c;
        obj.ProposalContent__c=cmp.get("v.innerCmpNewRequest").ProposalContent__c;
        obj.OfferContentComments__c=cmp.get("v.innerCmpNewRequest").OfferContentComments__c;
        obj.CancellationReason__c=cmp.get("v.innerCmpNewRequest").CancellationReason__c;
        obj.ReasonForCancellationComment__c=cmp.get("v.innerCmpNewRequest").ReasonForCancellationComment__c;
        obj.ContentsOfGuidance__c=cmp.get("v.innerCmpNewRequest").ContentsOfGuidance__c;
        obj.RetentionSuccess__c=cmp.get("v.innerCmpNewRequest").RetentionSuccess__c;
        obj.Comment2__c=cmp.get("v.innerCmpNewRequest").Comment2__c;
        obj.ChangePlan__c=cmp.get("v.innerCmpNewRequest").ChangePlan__c;
        obj.RetentionFailure__c=cmp.get("v.innerCmpNewRequest").RetentionFailure__c;
        obj.RetentionFailureComment__c=cmp.get("v.innerCmpNewRequest").RetentionFailureComment__c;
    },    
    init : function(component,event,helper){
         var dependantSubject = component.get('v.dependantSubject');
        helper.getProposalContentPickList(component, event,dependantSubject);
        helper.getContentsOfGuidancePicklist(component, event,dependantSubject);
        helper.getChangePlanPicklist(component, event);
        helper.getRetentionFailurePicklist(component, event);
        helper.getReasonForProposalPicklist(component, event,dependantSubject);
        helper.getContinuationProposalPicklist(component, event,dependantSubject);
        helper.getRetentionSuccessPicklist(component, event);
    },
     
})