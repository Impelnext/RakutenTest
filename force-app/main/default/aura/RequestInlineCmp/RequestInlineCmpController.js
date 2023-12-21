({
    onInit : function(c, e, h) {
        //ケースIDの取得
        var caseId = c.get("v.recordId");
        var incId = "";
        var action = c.get("c.getRequestId");
        c.set("v.divHeight", "300");
        // Apexコントローラへ処理対象のCaseID渡し
        action.setParams({ recordId : caseId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                incId = response.getReturnValue();
                const pathToVFPage = '/apex/RequestInlinePage?Id=' + incId;
                c.set('v.url', pathToVFPage);
            }else{
                incId = "";
            }
        });
        
        $A.enqueueAction(action);
    }
})