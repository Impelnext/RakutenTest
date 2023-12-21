({
	init : function(component, event, helper) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SeihoRequestContents__c'
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
                component.set("v.RequestContentsPLValues", RequestConFields);
	
                /*var RequestContentsPLMap = [];
                for(var key in result){
                    RequestContentsPLMap.push({key: key, value: result[key]});
                }
                component.set("v.RequestContentsPLMap", RequestContentsPLMap);*/
               
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
    //Making fields active 
    onRequestContentChange : function(component, event, helper){
        console.log("entering Piclkist");
        var ReqConType = event.getSource().get("v.value");
        console.log("ReqConType"+ReqConType);
        var obj = component.get("v.parentNewRequest");
        console.log("params"+JSON.stringify(obj));
        obj.SeihoRequestContents__c=ReqConType;  
        if (ReqConType=="差し戻し回答依頼"){
        	component.find("CallBackStartTime").set("v.disabled",false);
            component.find("CallBackEndTime").set("v.disabled",false); 
            component.find("ReturnContact").set("v.disabled",true);
            component.find("ReturnContact").set("v.value",'');  
            
        }
      	else if (ReqConType=="コール依頼"){
        	component.find("CallBackStartTime").set("v.disabled",false);
            component.find("CallBackEndTime").set("v.disabled",false);
            component.find("ReturnContact").set("v.disabled",false);    
        }
         else{
           	component.find("CallBackStartTime").set("v.disabled",true);
            component.find("CallBackEndTime").set("v.disabled",true);
            component.find("ReturnContact").set("v.disabled",true);
            component.find("CallBackStartTime").set("v.value",'');
            component.find("CallBackEndTime").set("v.value",'');
            component.find("ReturnContact").set("v.value",'');   
            }
    },
    setParentCmpValues:function(component, event, helper){
           	console.log("Entering onchange fun");
        
        	var obj = component.get("v.parentNewRequest");
        	var FieldName=event.getSource().get("v.name");
        	var EventSource=event.getSource();
        
        	console.log("FieldName"+FieldName);
        
        	if (FieldName=="DetailsOfRequest"){
        	obj.DetailsOfRequest__c=EventSource.get("v.value");
        	console.log("obj.DetailsOfRequest__c"+obj.DetailsOfRequest__c);
            	}
        	else if (FieldName=="EmergencyFlag"){
        		obj.EmergencyFlag__c=EventSource.get("v.checked");
        		console.log("obj.DetailsOfRequest__c"+obj.EmergencyFlag__c);
            	}
        	else if (FieldName=="CallBackStartTime"){
        		obj.CallBackStartTime__c=EventSource.get("v.value");
        		//console.log("obj.DetailsOfRequest__c"+obj.CallBackStartTime__c);
            	}
        	else if (FieldName=="CallBackEndTime"){
        		obj.CallBackEndTime__c=EventSource.get("v.value");
        		//console.log("obj.DetailsOfRequest__c"+obj.CallBackEndTime__c);
            	}
        	 
        	  else if (FieldName=="ReturnContact"){
        		obj.ReturnContact__c=EventSource.get("v.value");
        		//console.log("obj.DetailsOfRequest__c"+obj.ReturnContact__c);
            	}
    }
})