({
    getOverviewOfInquirySompoPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OverviewOfInquirySompo__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.overviewOfInquirySompoPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    }
	
})