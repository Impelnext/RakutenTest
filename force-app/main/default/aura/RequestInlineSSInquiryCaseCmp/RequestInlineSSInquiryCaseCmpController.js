({
    saveRequestInlineSSInquiryCase : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.InquirySummaryShortTermInsurance__c=cmp.get("v.innerCmpNewRequest").InquirySummaryShortTermInsurance__c;
    },    
    init : function(component,event,helper){	
        helper.getInquirySummaryShortTermInsurancePicklist(component, event);
    }
})