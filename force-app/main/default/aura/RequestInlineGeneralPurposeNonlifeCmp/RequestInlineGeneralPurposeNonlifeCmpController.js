({
    saveInlineGeneralPurposeNonlife : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
			obj.DateOfChange__c=cmp.get("v.innerCmpNewRequest").DateOfChange__c;
			obj.DetailsOfRequest__c=cmp.get("v.innerCmpNewRequest").DetailsOfRequest__c;
			obj.OtherInfomation__c=cmp.get("v.innerCmpNewRequest").OtherInfomation__c;	
    }
})