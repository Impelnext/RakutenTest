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
                    component.set("v.innerCmpNewRequest.DeliveryAddress_prefecture__c", component.get("v.getAreaInfoMap").prefecture);
                }
                if(component.get("v.getAreaInfoMap").municipality != ''){  
                    component.set("v.innerCmpNewRequest.DeliveryAddress_city__c", component.get("v.getAreaInfoMap").municipality);
                }      
                if(component.get("v.getAreaInfoMap").chome != ''){
                    component.set("v.innerCmpNewRequest.DeliveryAddress_Address1__c", component.get("v.getAreaInfoMap").chome);
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

    getissuingYearPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'IssuingYear__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var issuingYearPickMap = [];
                for(var key in result){
                    issuingYearPickMap.push({key: key, value: result[key]});
                }
                component.set("v.issuingYearPickMap", issuingYearPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getdeliveryAddressPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DeliveryAddress__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var deliveryAddressPickMap = [];
                for(var key in result){
                    deliveryAddressPickMap.push({key: key, value: result[key]});
                }
                component.set("v.deliveryAddressPickMap", deliveryAddressPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getsendingMethodPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SendingMethod__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var sendingMethodPickMap = [];
                for(var key in result){
                    sendingMethodPickMap.push({key: key, value: result[key]});
                }
                component.set("v.sendingMethodPickMap", sendingMethodPickMap);
            }
        });
        $A.enqueueAction(action);
    }
})