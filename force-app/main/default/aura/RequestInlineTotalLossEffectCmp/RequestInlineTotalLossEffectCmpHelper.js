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
                    component.set("v.innerCmpNewRequest.SendingDocumentsToPrefectures__c", component.get("v.getAreaInfoMap").prefecture);
                }
                if(component.get("v.getAreaInfoMap").municipality != ''){  
                    component.set("v.innerCmpNewRequest.CityWhereTheDocumentIsSent__c", component.get("v.getAreaInfoMap").municipality);
                }      
                if(component.get("v.getAreaInfoMap").chome != ''){
                    component.set("v.innerCmpNewRequest.DocumentAddress1__c", component.get("v.getAreaInfoMap").chome);
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

    getRevocationCategoryPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'RevocationCategory__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var revocationCategoryPickMap = [];
                for(var key in result){
                    revocationCategoryPickMap.push({key: key, value: result[key]});
                }
                component.set("v.revocationCategoryPickMap", revocationCategoryPickMap);
            }
        });
        $A.enqueueAction(action);
    }
})