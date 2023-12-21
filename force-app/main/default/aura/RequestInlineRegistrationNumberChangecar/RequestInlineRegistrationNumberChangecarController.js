({
   saveInlineRegistrationNumberChangecar : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;  
		obj.DateOfChange__c=cmp.get("v.innerCmpNewRequest").DateOfChange__c;
		obj.RegistrationNumberAfterChange__c=cmp.get("v.innerCmpNewRequest").RegistrationNumberAfterChange__c;
		obj.PrintingSequenceNumber__c=cmp.get("v.innerCmpNewRequest").PrintingSequenceNumber__c;
		obj.EndorsementNumber__c=cmp.get("v.innerCmpNewRequest").EndorsementNumber__c;
		obj.TransferApprovalDate__c=cmp.get("v.innerCmpNewRequest").TransferApprovalDate__c;
		obj.OtherInfomation__c=cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
    },
    init : function(component,event,helper){
        
    }
})