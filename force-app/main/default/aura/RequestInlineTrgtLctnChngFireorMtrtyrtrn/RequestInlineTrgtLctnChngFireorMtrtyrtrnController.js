({
   saveInlineTargetLocationChangeFireorMaturityreturn : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest; 
        
        obj.ChangedPrefecture__c = cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c;
        obj.ChangedAddress1__c = cmp.get("v.innerCmpNewRequest").ChangedAddress1__c;
        obj.ChangedMunicipality__c = cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c;
		
		obj.RelocationDate__c=cmp.get("v.innerCmpNewRequest").RelocationDate__c;
		obj.ChangedPostNumber__c=cmp.get("v.innerCmpNewRequest").ChangedPostNumber__c;
		obj.ChangedBuildingName__c=cmp.get("v.innerCmpNewRequest").ChangedBuildingName__c;
		obj.ChangedAddress__c=cmp.get("v.innerCmpNewRequest").ChangedAddress__c;
		obj.ReflectMailingAddress__c=cmp.get("v.innerCmpNewRequest").ReflectMailingAddress__c;
		obj.Use__c=cmp.get("v.innerCmpNewRequest").Use__c;
		obj.Industry__c=cmp.get("v.innerCmpNewRequest").Industry__c;
		obj.Construction__c=cmp.get("v.innerCmpNewRequest").Construction__c;
		obj.Area_m2__c=cmp.get("v.innerCmpNewRequest").Area_m2__c;
		obj.AgeOfAbuilding__c=cmp.get("v.innerCmpNewRequest").AgeOfAbuilding__c;
		obj.AppLetterShipGuidance__c=cmp.get("v.innerCmpNewRequest").AppLetterShipGuidance__c;
		obj.OtherInfomation__c=cmp.get("v.innerCmpNewRequest").OtherInfomation__c;
    },
    handleAreaInfo : function(cmp,event,helper){
		cmp.get("v.innerCmpNewRequest").ChangedPrefecture__c ='';
        cmp.get("v.innerCmpNewRequest").ChangedAddress1__c ='';
        cmp.get("v.innerCmpNewRequest").ChangedMunicipality__c ='';
        helper.areaInfo(cmp, event);             
    },

	init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getUsePicklist(component, event,dependantSubject);
        helper.getConstructionPicklist(component, event);
        helper.getAppLetterShipGuidancePicklist(component, event);
	}
})