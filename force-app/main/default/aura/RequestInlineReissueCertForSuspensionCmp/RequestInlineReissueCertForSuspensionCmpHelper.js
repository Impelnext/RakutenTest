({
	getPastIssueHistoryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PastIssueHistory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var pastIssueHistoryPickMap = [];
                for(var key in result){
                    pastIssueHistoryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.pastIssueHistoryPickMap", pastIssueHistoryPickMap);
            }
        });
        $A.enqueueAction(action);
    }
})