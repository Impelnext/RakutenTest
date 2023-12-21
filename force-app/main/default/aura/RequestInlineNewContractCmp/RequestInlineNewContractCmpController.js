({
    saveNewcontract : function(cmp, event,helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.ApplicationNumber_c__c=cmp.get("v.innerCmpNewRequest").ApplicationNumber_c__c;
        obj.SupportMailReactionFlag_c__c=cmp.get("v.innerCmpNewRequest").SupportMailReactionFlag_c__c;
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
        
       
        
        var checked=event.getSource().get("v.checked"); 
       
        if(checked == true){
        	cmp.set("v.innerCmpNewRequest.SupportMailReactionFlag_c__c",true);
        }
        else{
            console.log("Inside Esle");
          	cmp.set("v.innerCmpNewRequest.SupportMailReactionFlag_c__c",false);  
        }
        

 	}
    
})