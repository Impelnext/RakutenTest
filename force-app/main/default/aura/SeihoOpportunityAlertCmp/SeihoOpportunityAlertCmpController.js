({
    init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.getAgeInfo");
        action.setParams({ recordId: recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var ageInfoMap = response.getReturnValue();
                component.set("v.ageClassCd", ageInfoMap["ageClassCd"]);
            }
        });
        $A.enqueueAction(action);
    }
})