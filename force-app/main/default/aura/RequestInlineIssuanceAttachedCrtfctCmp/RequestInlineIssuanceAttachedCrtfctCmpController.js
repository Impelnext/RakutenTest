({
    saveInlineIssuanceAttachedCrtfct : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
            obj.ChangeDate__c=cmp.get("v.innerCmpNewRequest").ChangeDate__c;
			obj.DesiredCertificateType__c=cmp.get("v.innerCmpNewRequest").DesiredCertificateType__c;
			obj.TargetSecuritiesNumber2__c=cmp.get("v.innerCmpNewRequest").TargetSecuritiesNumber2__c;
			obj.DesiredCertificateType2__c=cmp.get("v.innerCmpNewRequest").DesiredCertificateType2__c;
			obj.TargetSecuritiesNumber3__c=cmp.get("v.innerCmpNewRequest").TargetSecuritiesNumber3__c;
			obj.DesiredCertificateType3__c=cmp.get("v.innerCmpNewRequest").DesiredCertificateType3__c;
			obj.OtherInfomation__c=cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
			obj.TargetSecuritiesNumber1__c = cmp.get("v.innerCmpNewRequest").TargetSecuritiesNumber1__c
    }, 
     init : function(component,event,helper){
				helper.getDesiredCertificateTypePickMap(component, event);
				helper.getDesiredCertificateType2PickMap(component, event);
				helper.getDesiredCertificateType3PickMap(component, event);
				
    }
})