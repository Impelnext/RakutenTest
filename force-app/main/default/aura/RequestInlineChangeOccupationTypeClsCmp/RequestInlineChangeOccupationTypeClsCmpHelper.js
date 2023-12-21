({
   getChangeInformationPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangeInformation__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var ChangeInformationPickMap = [];
                for(var key in result){
                    ChangeInformationPickMap.push({key: key, value: result[key]});
                }
                component.set("v.ChangeInformationPickMap", ChangeInformationPickMap);
            }
        });
        $A.enqueueAction(action);
    }
	
})