({
	saveInlineOwnerNameChangeCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
        obj.DateOfChange__c= cmp.get("v.innerCmpNewRequest").DateOfChange__c;
		obj.Changes__c= cmp.get("v.innerCmpNewRequest").Changes__c;
		obj.TheRelationshipWithTheCurrentOwner__c= cmp.get("v.innerCmpNewRequest").TheRelationshipWithTheCurrentOwner__c;
		obj.NameAfterChangeOfNameKana__c= cmp.get("v.innerCmpNewRequest").NameAfterChangeOfNameKana__c;
		obj.NameAfterChangeOfNameKanji__c= cmp.get("v.innerCmpNewRequest").NameAfterChangeOfNameKanji__c;
		obj.GenderAfterChange__c= cmp.get("v.innerCmpNewRequest").GenderAfterChange__c;
		obj.DateOfBirthAfterChange__c= cmp.get("v.innerCmpNewRequest").DateOfBirthAfterChange__c;
		obj.AccountCreditCardChange__c= cmp.get("v.innerCmpNewRequest").AccountCreditCardChange__c;
		obj.RecipientChange__c= cmp.get("v.innerCmpNewRequest").RecipientChange__c;
		obj.NenrinOnlyChangeInBeneficiary__c= cmp.get("v.innerCmpNewRequest").NenrinOnlyChangeInBeneficiary__c;
		obj.OtherInfomation__c= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
	},
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getchangesPicklist(component, event,dependantSubject);
		helper.gettheRelatnWitTheCurrOwnerPicklist(component, event);
		helper.getgenderAfterChangePicklist(component, event);
		helper.getaccountCreditCardChangePicklist(component, event);
		helper.getrecipientChangePicklist(component, event);
		helper.getnenrinOnlyChangeInBeneficiaryPicklist(component, event);
    }
})