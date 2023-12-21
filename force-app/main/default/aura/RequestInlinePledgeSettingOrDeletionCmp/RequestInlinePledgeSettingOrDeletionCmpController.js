({
	saveInlinePledgeSettingOrDeletion : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
	
        obj.SettingErasure__c= cmp.get("v.innerCmpNewRequest").SettingErasure__c;
		obj.SetDateDeleteDate__c= cmp.get("v.innerCmpNewRequest").SetDateDeleteDate__c;
		obj.SendingCompanyName__c= cmp.get("v.innerCmpNewRequest").SendingCompanyName__c;
		obj.DepartmentInCharge__c= cmp.get("v.innerCmpNewRequest").DepartmentInCharge__c;
		obj.PersonInChargeName__c= cmp.get("v.innerCmpNewRequest").PersonInChargeName__c;
		obj.MailingPostalCode__c= cmp.get("v.innerCmpNewRequest").MailingPostalCode__c;	
		obj.MailingPrefectures__c = cmp.get("v.innerCmpNewRequest").MailingPrefectures__c;		
		obj.MailingCity__c= cmp.get("v.innerCmpNewRequest").MailingCity__c;
		obj.MailingAddress1__c= cmp.get("v.innerCmpNewRequest").MailingAddress1__c;
		obj.DestinationBuildingName__c = cmp.get("v.innerCmpNewRequest").DestinationBuildingName__c;		
		obj.ReflectMailingAddress__c = cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
        obj.PhoneNumber__c = cmp.get("v.innerCmpNewRequest").PhoneNumber__c;
		obj.RequiredNumberOfCopies__c = cmp.get("v.innerCmpNewRequest").RequiredNumberOfCopies__c;
        obj.OtherInfomation__c = cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
	},
    init : function(component,event,helper){
        helper.getSettingErasurePicklist(component, event);		
    },
    handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").MailingPrefectures__c = '';
        cmp.get("v.innerCmpNewRequest").MailingCity__c= '';
        cmp.get("v.innerCmpNewRequest").MailingAddress1__c='';
        helper.areaInfo(cmp, event);             
    }
})

{!v.innerCmpNewRequest.MailingPrefectures__c}