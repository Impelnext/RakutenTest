({
	fetchReceptionRecords: function (cmp, query) {
        return new Promise(function (resolve, reject) {
            var action = cmp.get("c.executeSoql");
            var receptionId = cmp.get("v.recordId");
            action.setParams({soql: query});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log("response"+response.getReturnValue());
                    resolve(response.getReturnValue());
                }
                else if (state === "INCOMPLETE") {
                    console.log("State"+state)
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors && errors.length > 0 ) {
                        console.log("query"+query);
                        console.log("Error message: " +
                                    errors[0].message);
                        reject(errors[0].message);
                    } else {
                        console.log("Unknown error");
                        reject("Unknown error")
                    }
                }
            });
            $A.enqueueAction(action);   
		});
	}                                                 
})