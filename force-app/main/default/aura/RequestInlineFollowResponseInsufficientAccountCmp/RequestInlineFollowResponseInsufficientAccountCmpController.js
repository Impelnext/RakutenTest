({
    init : function(component, event, helper) {
         var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'TargetContractStatus__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                console.log("PicklistResponse"+JSON.stringify(result));
                // create a empty array for store map keys(@@--->which is RequestContent picklist values) 
                var listOfkeys = [];// for store all map keys (RequestContent picklist values)
                var RequestConFields = [];// for store RequestContent picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in result) {
                    listOfkeys.push(singlekey);
                }
                
                //set the RequestContent field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    RequestConFields.push('--- None ---');
                }
                
                for (var i = 0;i < listOfkeys.length;i++) {
                    RequestConFields.push(listOfkeys[i]);
                }
                // set the RequestContent variable values (controller picklist field)
                component.set("v.TargetContractStatusPLValues", RequestConFields);
                 }
            else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('サーバーからレスポンスがありません');
            }
        });
        $A.enqueueAction(action);
		
	},
	
    saveInsufficientAccount : function(cmp, event,helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.TargetContractStatus__c=cmp.get("v.innerCmpNewRequest").TargetContractStatus__c;
        obj.IncompleteContents__c=cmp.get("v.innerCmpNewRequest").IncompleteContents__c;


        console.log("obj"+JSON.stringify(obj));
      } 
       
})