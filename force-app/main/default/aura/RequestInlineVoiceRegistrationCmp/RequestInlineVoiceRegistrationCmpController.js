({
    init: function(component, event, helper) {
         var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CorrespondenceRequest__c'
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
                component.set("v.CorrespondenceRequestPLValues", RequestConFields);
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
    saveVoiceRegistration : function(cmp, event,helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.Registration__c=cmp.get("v.innerCmpNewRequest").Registration__c;
        obj.Busy__c=cmp.get("v.innerCmpNewRequest").Busy__c;
    	obj.Decline__c=cmp.get("v.innerCmpNewRequest").Decline__c;
        obj.Change__c=cmp.get("v.innerCmpNewRequest").Change__c;
        obj.ChangeNewNumber__c=cmp.get("v.innerCmpNewRequest").ChangeNewNumber__c;
        obj.CorrespondenceRequest__c=cmp.get("v.innerCmpNewRequest").CorrespondenceRequest__c;
        obj.Delete__c=cmp.get("v.innerCmpNewRequest").Delete__c;
        obj.SeihoRequestContents__c=cmp.get("v.innerCmpNewRequest").SeihoRequestContents__c;
        obj.DetailsOfRequest__c=cmp.get("v.innerCmpNewRequest").DetailsOfRequest__c;
        obj.EmergencyFlag__c=cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
        obj.CallBackStartTime__c=cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
        obj.CallBackEndTime__c=cmp.get("v.innerCmpNewRequest").CallBackEndTime__c;
        obj.ReturnName__c=cmp.get("v.innerCmpNewRequest").ReturnName__c;
        obj.ReturnContact__c=cmp.get("v.innerCmpNewRequest").ReturnContact__c;


        console.log("obj"+JSON.stringify(obj));
    },

    setValues : function(cmp,event,helper){
        var selected=[],checkboxes=cmp.find("checkbox");
        console.log("checkboxes"+checkboxes);
        if(!checkboxes.length) { 
            checkboxes = [checkboxes];
            console.log(checkboxes);
        	}
         checkboxes
        .filter(checkbox => checkbox.get("v.checked"))    // Get only checked boxes
        .forEach(checkbox => selected.push(checkbox.get("v.label")));   // And get the labels
       // Set to Req Obj
       console.log("selected"+selected);
        if(selected.includes("登録")){
        	cmp.set("v.innerCmpNewRequest.Registration__c",true);
        }
        else{
            console.log("Inside Esle");
          	cmp.set("v.innerCmpNewRequest.Registration__c",false);  
        }
        if(selected.includes("多忙")){
            console.log("Selecting 多忙");
            cmp.set("v.innerCmpNewRequest.Busy__c",true);
        }
        else{
          	cmp.set("v.innerCmpNewRequest.Busy__c",false);
        }
      	if(selected.includes("辞退")){
         	cmp.set("v.innerCmpNewRequest.Decline__c",true);
      	}
        else{
          	cmp.set("v.innerCmpNewRequest.Decline__c",false);  
        }
      	if(selected.includes("変更")){
         	cmp.set("v.innerCmpNewRequest.Change__c",true);
        }
        else{
            cmp.set("v.innerCmpNewRequest.Change__c",false);
        }
      	if(selected.includes("削除")){
         	cmp.set("v.innerCmpNewRequest.Delete__c",true);   
        }
        else{
          	cmp.set("v.innerCmpNewRequest.Delete__c",false);  
        }
       
        

 	}
    
})