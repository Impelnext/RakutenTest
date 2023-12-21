({
    saveInformationLinkage : function(cmp, event) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.RequestDetails__c = cmp.get("v.innerCmpNewRequest").RequestDetails__c;
    }
})