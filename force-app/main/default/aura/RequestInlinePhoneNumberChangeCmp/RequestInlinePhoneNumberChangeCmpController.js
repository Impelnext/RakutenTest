({
    savePhoneNumberChange : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;       
        obj.Tel1__c = cmp.get("v.innerCmpNewRequest").Tel1__c;
        obj.Tel2__c = cmp.get("v.innerCmpNewRequest").Tel2__c;
    }
})