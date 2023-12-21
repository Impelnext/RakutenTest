({
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.isMaturitySoon");
        action.setParams({  contractId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var isMaturitySoonContrct = response.getReturnValue();
                if(isMaturitySoonContrct){
                    cmp.set("v.showError", true);
                }
            }
		console.log("isMaturitySoonContrct"+isMaturitySoonContrct);
        });
        $A.enqueueAction(action);
    }
})