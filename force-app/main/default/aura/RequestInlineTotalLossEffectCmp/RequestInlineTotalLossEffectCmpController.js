({
	saveInlineTotalLossEffect : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest; 
        
        obj.SendingDocumentsToPrefectures__c = cmp.get("v.innerCmpNewRequest").SendingDocumentsToPrefectures__c;
        obj.CityWhereTheDocumentIsSent__c = cmp.get("v.innerCmpNewRequest").CityWhereTheDocumentIsSent__c;
        obj.DocumentAddress1__c = cmp.get("v.innerCmpNewRequest").DocumentAddress1__c;

        obj.RevocationCategory__c= cmp.get("v.innerCmpNewRequest").RevocationCategory__c;
		obj.ExpirationDateDeathOrRecognition__c= cmp.get("v.innerCmpNewRequest").ExpirationDateDeathOrRecognition__c;
		obj.CallerName__c= cmp.get("v.innerCmpNewRequest").CallerName__c;
		obj.RelationshipWithContractor__c= cmp.get("v.innerCmpNewRequest").RelationshipWithContractor__c;
		obj.ContactName__c= cmp.get("v.innerCmpNewRequest").ContactName__c;
		obj.ContactPhoneNumber__c= cmp.get("v.innerCmpNewRequest").ContactPhoneNumber__c;	
		obj.PostalAddressWhereDocumentsAreSent__c = cmp.get("v.innerCmpNewRequest").PostalAddressWhereDocumentsAreSent__c;				
		obj.NameOfBuildingToWhichDocumentsAreSent__c = cmp.get("v.innerCmpNewRequest").NameOfBuildingToWhichDocumentsAreSent__c;
        obj.ReflectMailingAddress__c = cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
		
	},
    handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").SendingDocumentsToPrefectures__c ='';
        cmp.get("v.innerCmpNewRequest").CityWhereTheDocumentIsSent__c ='';
        cmp.get("v.innerCmpNewRequest").DocumentAddress1__c ='';
        helper.areaInfo(cmp, event);             
    },

    init : function(component,event,helper){
        helper.getRevocationCategoryPicklist(component, event);		
    }
})