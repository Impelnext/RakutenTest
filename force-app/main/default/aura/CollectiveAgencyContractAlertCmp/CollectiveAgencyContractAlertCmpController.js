({
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.isCollectiveAgencyContract");
        action.setParams({  contractId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var options = [];
                var isCollectiveAgencyContract = response.getReturnValue();
                if(isCollectiveAgencyContract){
                    cmp.set("v.showError", true);
                }
            }
        });
        $A.enqueueAction(action);
    }
})