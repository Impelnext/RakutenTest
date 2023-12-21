({
    fetchMasterRecords: function (cmp,event) {
		var masterId = cmp.get("v.recordId");
		var action = cmp.get("c.fetchMasterRecords");
        action.setParams ({
                masterId : masterId
        });
		action.setCallback(this,function(response){
       	var state = response.getState();
       	if (state === "SUCCESS") {
            var masterRecord = response.getReturnValue();
            console.log('@@@masterRecord'+JSON.stringify(masterRecord));
            if(JSON.stringify(masterRecord).length > 0){
                var pageReference = {
                        type: 'standard__component',
                        attributes: {
                            componentName: 'c__ReceptionAccountDisplayCmp',
                        },
                        state: {
                            "c__accountId": '',
                            "c__MasterRecordId" : masterId,
                            "c__masterName"     : masterRecord.Name,
                            "c__objName"        : masterRecord.objectName,
                            "c__kanaName"       : masterRecord.kanaName
                        }
                };
            }
            cmp.set("v.pageReference",pageReference);
       	}
        else if (state === "INCOMPLETE") {
            console.log("State"+state)
        }
        else if (state === "ERROR") {
            var errors = response.getError();
            if (errors && errors.length > 0 ) {
                console.log("Error message: " + errors[0].message);
            }else {
                console.log("Unknown error");
            }
        }
		});
    $A.enqueueAction(action);
   	}     	                                                 
})