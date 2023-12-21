({
    saveSupportRequest : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;       
        obj.RequestDetails__c = cmp.get("v.innerCmpNewRequest").RequestDetails__c;
        obj.EmergencyFlag__c = cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
        obj.CallBackStartTime__c = cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
        obj.CallBackEndTime__c = cmp.get("v.innerCmpNewRequest").CallBackEndTime__c; 
        obj.ReturnName__c = cmp.get("v.innerCmpNewRequest").ReturnName__c;
        obj.ReturnContact__c = cmp.get("v.innerCmpNewRequest").ReturnContact__c;
    }   
})