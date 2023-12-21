({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContractInfo");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var contractWrapper = response.getReturnValue();
                component.set('v.contractWrapper', contractWrapper);                
            }
        });
        $A.enqueueAction(action);
    }
})