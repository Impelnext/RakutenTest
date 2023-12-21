({
    saveRequestInlineInquirycase : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;       
        obj.OverviewOfInquirySeimei__c = cmp.get("v.innerCmpNewRequest").OverviewOfInquirySeimei__c;
    },
    init : function(component,event,helper){	
        component.set("v.isDoneRendering", true);
        helper.getOverviewOfInquirySeimeiPickList(component, event);
    }
})