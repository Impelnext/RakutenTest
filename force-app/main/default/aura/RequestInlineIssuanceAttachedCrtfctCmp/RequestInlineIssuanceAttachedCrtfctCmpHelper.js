({
    getDesiredCertificateTypePickMap: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DesiredCertificateType__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var desiredCertificateTypePickMap = [];
                for(var key in result){
                    desiredCertificateTypePickMap.push({key: key, value: result[key]});
                }
                component.set("v.desiredCertificateTypePickMap", desiredCertificateTypePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getDesiredCertificateType2PickMap: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DesiredCertificateType2__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var desiredCertificateType2PickMap = [];
                for(var key in result){
                    desiredCertificateType2PickMap.push({key: key, value: result[key]});
                }
                component.set("v.desiredCertificateType2PickMap", desiredCertificateType2PickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getDesiredCertificateType3PickMap: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DesiredCertificateType3__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var desiredCertificateType3PickMap = [];
                for(var key in result){
                    desiredCertificateType3PickMap.push({key: key, value: result[key]});
                }
                component.set("v.desiredCertificateType3PickMap", desiredCertificateType3PickMap);
            }
        });
        $A.enqueueAction(action);
    }
})