({
    saveStorage : function(cmp, event,helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.SeihoRequestContents__c=cmp.get("v.innerCmpNewRequest").SeihoRequestContents__c;
        obj.DetailsOfRequest__c=cmp.get("v.innerCmpNewRequest").DetailsOfRequest__c;
        obj.EmergencyFlag__c=cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
        obj.CallBackStartTime__c=cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
        obj.CallBackEndTime__c=cmp.get("v.innerCmpNewRequest").CallBackEndTime__c;
        obj.ReturnName__c=cmp.get("v.innerCmpNewRequest").ReturnName__c;
        obj.ReturnContact__c=cmp.get("v.innerCmpNewRequest").ReturnContact__c;

        console.log("obj"+JSON.stringify(obj));
    }
    
})