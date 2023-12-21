({
	 areaInfo : function(component,event){
        var receivedPostal = event.getSource().get('v.value'); 
        var action = component.get("c.getAreaInfo");
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {                 
                component.set('v.getAreaInfoMap',response.getReturnValue());
				if(component.get("v.getAreaInfoMap").prefecture != ''){
                    component.set("v.innerCmpNewRequest.MailingPrefectures__c", component.get("v.getAreaInfoMap").prefecture);
                }
                if(component.get("v.getAreaInfoMap").municipality != ''){  
                    component.set("v.innerCmpNewRequest.MailingCity__c", component.get("v.getAreaInfoMap").municipality);
                }      
                if(component.get("v.getAreaInfoMap").chome != ''){
                    component.set("v.innerCmpNewRequest.MailingAddress1__c", component.get("v.getAreaInfoMap").chome);
                }
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
	areaInfo2 : function(component,event){
        var receivedPostal = event.getSource().get('v.value'); 
        var action = component.get("c.getAreaInfo");
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {                 
                component.set('v.getAreaInfoMap2',response.getReturnValue());
				if(component.get("v.getAreaInfoMap2").prefecture != ''){
                    component.set("v.innerCmpNewRequest.Prefectures__c", component.get("v.getAreaInfoMap2").prefecture);
                }
                if(component.get("v.getAreaInfoMap2").municipality != ''){  
                    component.set("v.innerCmpNewRequest.City__c", component.get("v.getAreaInfoMap2").municipality);
                }      
                if(component.get("v.getAreaInfoMap2").chome != ''){
                    component.set("v.innerCmpNewRequest.Address1__c", component.get("v.getAreaInfoMap2").chome);
                }
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
    getCancellationPremiumYenPicklist: function(component, event) {
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
    getExsistenceOfPledgePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ExsistenceOfPledge__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var exsistenceOfPledgePickMap = [];
                for(var key in result){
                    exsistenceOfPledgePickMap.push({key: key, value: result[key]});
                }
                component.set("v.exsistenceOfPledgePickMap", exsistenceOfPledgePickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getReturnAccountPicklist: function(component, event) {
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
	getRegistAccConversionProprietyPicklist: function(component, event) {
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
	getPersonOneselfOrOtherPicklist: function(component, event) {
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
	getDepositTypePaymentPicklist: function(component, event) {
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