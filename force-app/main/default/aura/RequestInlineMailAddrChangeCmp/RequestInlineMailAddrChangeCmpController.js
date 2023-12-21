({
    saveMailAddrChange : function(cmp, event) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.ChangedMailAddress__c = cmp.get("v.innerCmpNewRequest").ChangedMailAddress__c;
    }
})