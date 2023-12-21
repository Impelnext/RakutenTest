({
    saveInlineInquiryCaseNonlife : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
			obj.OverviewOfInquirySompo__c=cmp.get("v.innerCmpNewRequest").OverviewOfInquirySompo__c;
     },
	 init : function(component,event,helper){
				helper.getOverviewOfInquirySompoPickList(component, event);
	},
	handleOverviewOfInquirySompoPickListChange: function (component, event) {  
        var selectedValues = event.getParam("value");
    }
})