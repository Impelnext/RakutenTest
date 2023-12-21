({
	doInit: function(component, event, helper) {
		var action = component.get("c.getCallCount");
        action.setParams({"recordId": component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.retMap", response.getReturnValue());
            } else {
                console.log('Response state: ' + state);
            }
            // スピナーOFF
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
	}
})