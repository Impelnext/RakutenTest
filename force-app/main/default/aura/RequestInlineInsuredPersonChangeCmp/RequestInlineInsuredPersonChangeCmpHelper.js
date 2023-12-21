({
	 areaInfo : function(component,event,getAreaInfoMap){
        var receivedPostal = event.getSource().get('v.value'); 
        var action = component.get("c.getAreaInfo");
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {                 
                component.set(getAreaInfoMap,response.getReturnValue());  
            }else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (status === "INCOMPLETE") {
                alert('サーバーからレスポンスがありません');
            }
        });
            $A.enqueueAction(action);
    },

    getautoInsuredAfterChangePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AutoInsuredAfterChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var autoInsuredAfterChangePickMap = [];
                for(var key in result){
                    autoInsuredAfterChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.autoInsuredAfterChangePickMap", autoInsuredAfterChangePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getautoGenderOfInsuredAfterChangePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AutoGenderOfInsuredAfterChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var autoGenderOfInsuredAfterChangePickMap = [];
                for(var key in result){
                    autoGenderOfInsuredAfterChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.autoGenderOfInsuredAfterChangePickMap", autoGenderOfInsuredAfterChangePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getinsurPersonsLicenseColorAftChngPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'InsuredPersonsLicenseColorAfterChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var insurPersonsLicenseColorAftChngPickMap = [];
                for(var key in result){
                    insurPersonsLicenseColorAftChngPickMap.push({key: key, value: result[key]});
                }
                component.set("v.insurPersonsLicenseColorAftChngPickMap", insurPersonsLicenseColorAftChngPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getrelatshpInsPersonBeforeChnPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RelationshipInsuredPersonBeforeChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var relatshpInsPersonBeforeChnPickMap = [];
                for(var key in result){
                    relatshpInsPersonBeforeChnPickMap.push({key: key, value: result[key]});
                }
                component.set("v.relatshpInsPersonBeforeChnPickMap", relatshpInsPersonBeforeChnPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcarDriverAgeConditionChngPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CarDriverAgeConditionChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var carDriverAgeConditionChngPickMap = [];
                for(var key in result){
                    carDriverAgeConditionChngPickMap.push({key: key, value: result[key]});
                }
                component.set("v.carDriverAgeConditionChngPickMap", carDriverAgeConditionChngPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getchngOfAutoDriverLtdCatgryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ChangeOfAutoDriverLimitedCategory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var chngOfAutoDriverLtdCatgryPickMap = [];
                for(var key in result){
                    chngOfAutoDriverLtdCatgryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.chngOfAutoDriverLtdCatgryPickMap", chngOfAutoDriverLtdCatgryPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getotherInsuredPersonAfterChangePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherInsuredPersonAfterChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var otherInsuredPersonAfterChangePickMap = [];
                for(var key in result){
                    otherInsuredPersonAfterChangePickMap.push({key: key, value: result[key]});
                }
                component.set("v.otherInsuredPersonAfterChangePickMap", otherInsuredPersonAfterChangePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getotherGenOfInsAfrChngPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherGenderOfInsuredAfterChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var otherGenOfInsAfrChngPickMap = [];
                for(var key in result){
                    otherGenOfInsAfrChngPickMap.push({key: key, value: result[key]});
                }
                component.set("v.otherGenOfInsAfrChngPickMap", otherGenOfInsAfrChngPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getotherRelatnInsBefChngPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'OtherRelationshipInsuredBeforeChange__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var otherRelatnInsBefChngPickMap = [];
                for(var key in result){
                    otherRelatnInsBefChngPickMap.push({key: key, value: result[key]});
                }
                component.set("v.otherRelatnInsBefChngPickMap", otherRelatnInsBefChngPickMap);
            }
        });
        $A.enqueueAction(action);
    }
})