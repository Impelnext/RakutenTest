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

    getSettingErasurePicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'SettingErasure__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var settingErasurePickMap = [];
                for(var key in result){
                    settingErasurePickMap.push({key: key, value: result[key]});
                }
                component.set("v.settingErasurePickMap", settingErasurePickMap);
            }
        });
        $A.enqueueAction(action);
    }
})