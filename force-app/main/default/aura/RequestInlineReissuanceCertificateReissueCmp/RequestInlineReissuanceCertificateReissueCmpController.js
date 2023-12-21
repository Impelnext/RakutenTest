({
	saveInlineReissuanceCertificateReissueCmp : function(cmp, event, helper) {
		var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;
       	obj.DeliveryAddress_prefecture__c = cmp.get("v.innerCmpNewRequest").DeliveryAddress_prefecture__c;
		obj.DeliveryAddress_city__c = cmp.get("v.innerCmpNewRequest").DeliveryAddress_city__c;
		obj.DeliveryAddress_Address1__c = cmp.get("v.innerCmpNewRequest").DeliveryAddress_Address1__c;
        obj.IssuingYear__c= cmp.get("v.innerCmpNewRequest").IssuingYear__c;
		obj.DeliveryAddress__c= cmp.get("v.innerCmpNewRequest").DeliveryAddress__c;
		obj.DeliveryAddress_zipCode__c= cmp.get("v.innerCmpNewRequest").DeliveryAddress_zipCode__c;
		obj.DeliveryAddress_buildingName__c= cmp.get("v.innerCmpNewRequest").DeliveryAddress_buildingName__c;
		obj.IsReflectDeliveryAddress__c= cmp.get("v.innerCmpNewRequest").IsReflectDeliveryAddress__c;
		obj.SendingMethod__c= cmp.get("v.innerCmpNewRequest").SendingMethod__c;
		obj.OtherInfomation__c= cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
		
	},
    handleAreaInfo : function(cmp,event,helper){
	
		cmp.get("v.innerCmpNewRequest").DeliveryAddress_prefecture__c = '';
		cmp.get("v.innerCmpNewRequest").DeliveryAddress_city__c= '';
		cmp.get("v.innerCmpNewRequest").DeliveryAddress_Address1__c='';		
        helper.areaInfo(cmp, event);             
    },
    init : function(component,event,helper){
        helper.getissuingYearPicklist(component, event);
		helper.getdeliveryAddressPicklist(component, event);
		helper.getsendingMethodPicklist(component, event);
    }
})