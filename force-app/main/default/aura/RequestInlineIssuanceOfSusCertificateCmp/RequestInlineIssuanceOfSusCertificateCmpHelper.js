({
	getIssueDatePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'IssueDate__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var issueDatePickMap = [];
                for(var key in result){
                    issueDatePickMap.push({key: key, value: result[key]});
                }
                component.set("v.issueDatePickMap", issueDatePickMap);
            }
        });
        $A.enqueueAction(action);
    }
})