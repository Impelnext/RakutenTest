({
    doInit : function(cmp, event, helper){
        var action = cmp.get("c.getContractInfo");
        action.setParams({  accountId : cmp.get("v.recordId")  });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var contractCountMap = response.getReturnValue();
                cmp.set('v.contractCountMap', contractCountMap);
                if(contractCountMap['msgDisplayFlag'] != 3){
					cmp.set("v.showJointAgencyMsg", true);
                }
            }
        });
        $A.enqueueAction(action);
    }
})