({
	getcancellationReasonPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CancellationReason__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var cancellationReasonPickMap = [];
                for(var key in result){
                    cancellationReasonPickMap.push({key: key, value: result[key]});
                }
                component.set("v.cancellationReasonPickMap", cancellationReasonPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getcancellationPremiumYenPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CancellationPremiumYen__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var cancellationPremiumYenPickMap = [];
                for(var key in result){
                    cancellationPremiumYenPickMap.push({key: key, value: result[key]});
                }
                component.set("v.cancellationPremiumYenPickMap", cancellationPremiumYenPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getreturnAccountPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ReturnAccount__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var returnAccountPickMap = [];
                for(var key in result){
                    returnAccountPickMap.push({key: key, value: result[key]});
                }
                component.set("v.returnAccountPickMap", returnAccountPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getregistAccConversionProprietyPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RegistrationAccountConversionPropriety__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var registAccConversionProprietyPickMap = [];
                for(var key in result){
                    registAccConversionProprietyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.registAccConversionProprietyPickMap", registAccConversionProprietyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getpersonOneselfOrOtherPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'PersonOneselfOrOther__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var personOneselfOrOtherPickMap = [];
                for(var key in result){
                    personOneselfOrOtherPickMap.push({key: key, value: result[key]});
                }
                component.set("v.personOneselfOrOtherPickMap", personOneselfOrOtherPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getdepositTypePaymentPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DepositTypePayment__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var depositTypePaymentPickMap = [];
                for(var key in result){
                    depositTypePaymentPickMap.push({key: key, value: result[key]});
                }
                component.set("v.depositTypePaymentPickMap", depositTypePaymentPickMap);
            }
        });
        $A.enqueueAction(action);
    }
})