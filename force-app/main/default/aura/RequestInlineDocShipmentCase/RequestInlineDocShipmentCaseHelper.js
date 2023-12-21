({ 
		getDateOfShipmentPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'DateOfShipment__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var dateOfShipmentPickMap = [];
                for(var key in result){
                    dateOfShipmentPickMap.push({key: key, value: result[key]});
                }
                component.set("v.dateOfShipmentPickMap", dateOfShipmentPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getShippingMethodPicklist: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'ShippingMethod__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var shippingMethodPickMap = [];
                for(var key in result){
                    shippingMethodPickMap.push({key: key, value: result[key]});
                }
                component.set("v.shippingMethodPickMap", shippingMethodPickMap);
            }
        });
        $A.enqueueAction(action);
    },
     fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute
                if(controllerField=='Subject__c'){
                	component.set("v.subjectDependentFieldMap",StoreResponse);
                    var depnedentFieldMap = component.get("v.subjectDependentFieldMap");
                    var controllerValueKey = component.get("v.dependantSubject");
        			if (controllerValueKey != '--- None ---') {
                        console.log('-- ' + depnedentFieldMap[controllerValueKey] + ' --');
            			var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
                    }
                    this.fetchDepValues(component,ListOfDependentFields,"SubjectDependant");
                } 
                else {
                	component.set("v.depnedentFieldMap",StoreResponse);
                	}
                }
            else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields,dependantStr) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        // dependentFields.push('--- None ---');
        if( ListOfDependentFields ) {
          for (var i = 0; i < ListOfDependentFields.length; i++) {
            if(dependantStr=='SubjectDependant'){
        	  dependentFields.push(ListOfDependentFields[i]);
            } else{
              dependentFields.push({
                label: ListOfDependentFields[i],
                value: ListOfDependentFields[i]
              });
            }    
        }

       }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        if(dependantStr=='SubjectDependant'){
        	component.set("v.listControllingValues", dependentFields);
            console.log('dependentFields'+dependentFields);
        }
        else{
        	component.set("v.listDependingValues", dependentFields);
        }
    },
	areaInfo : function(component,event){
        var receivedPostal = event.getSource().get('v.value');
        var action = component.get('c.getAreaInfo');
        action.setParams({
            postalCode : receivedPostal
        });
        action.setCallback(this,function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.getAreaInfoMap',response.getReturnValue());
            }
            var areaInfo = JSON.parse(JSON.stringify(component.get("v.getAreaInfoMap")));
            console.log("areaInfo"+JSON.stringify(areaInfo));
            if (areaInfo != ''){
              component.set("v.innerCmpNewRequest.Prefectures__c",areaInfo.prefecture);
              component.set("v.innerCmpNewRequest.City__c",areaInfo.municipality);
              component.set("v.innerCmpNewRequest.Address1__c",areaInfo.chome);
            }
        	component.set("v.innerCmpNewRequest.Address2__c",'');
        });
        $A.enqueueAction(action);
    },
    //Setting the Address section
    setAddress : function(component,event,addressInfoWrapper){
        var setAccountAddress = function(){
            if(!$A.util.isEmpty(addressInfoWrapper.reception.Account__r.PersonMailingAddress)){
                var addressFieldSet = JSON.parse(JSON.stringify(addressInfoWrapper.reception.Account__r.PersonMailingAddress));
                component.set("v.innerCmpNewRequest.Prefectures__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.state);
                component.set("v.innerCmpNewRequest.Address1__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.street);
                component.set("v.innerCmpNewRequest.City__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.city); 
                component.set("v.innerCmpNewRequest.DestinationAddress__c",addressInfoWrapper.reception.Account__r.Name);
                component.set("v.innerCmpNewRequest.Postalcode__c",addressInfoWrapper.reception.Account__r.PersonMailingAddress.postalCode);
                component.set("v.innerCmpNewRequest.Address2__c",'');
                    
            }
        };
        var setMasterAddress = function() {
            if(!$A.util.isEmpty(addressInfoWrapper.reception.SeihoRecruiter__c)){
    
                if(!$A.util.isEmpty(addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r)){
                   
                    component.set("v.innerCmpNewRequest.Prefectures__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.DestinationPrefccdName__c);
                    component.set("v.innerCmpNewRequest.Postalcode__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndzip__c);
                    component.set("v.innerCmpNewRequest.City__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndcityarea__c); 
                    component.set("v.innerCmpNewRequest.Address1__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr1__c);
                    var address2 = (addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr2__c)?addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr2__c : '';
                    var address3 = (addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.msgsbyndaddr3__c)?addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.msgsbyndaddr3__c : '';
                    component.set("v.innerCmpNewRequest.Address2__c",address2+address3);
                    component.set("v.innerCmpNewRequest.DestinationAddress__c",addressInfoWrapper.reception.SeihoRecruiter__r.SeihoAgencyMasterName__r.agncynmkj__c);
                }
                
            }
            else if(!$A.util.isEmpty(addressInfoWrapper.reception.SeihoAgent__r)){
                    
                    if(component.get("v.innerCmpNewRequest.ShippingInput__c")!='申出人から引用'){
                        component.set("v.innerCmpNewRequest.ShippingInput__c",'申出人から引用');
                        window.setTimeout(
                            $A.getCallback(function() {
                                component.set("v.selectVal",'申出人から引用');
                            }), 5
                        );
                    }
                component.set("v.innerCmpNewRequest.Prefectures__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_REGION_DISPLAY__c);
                component.set("v.innerCmpNewRequest.Address1__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_ADDRESS1__c);
                component.set("v.innerCmpNewRequest.City__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_CITY__c); 
                component.set("v.innerCmpNewRequest.Address2__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_ADDRESS2__c);
                component.set("v.innerCmpNewRequest.Postalcode__c",addressInfoWrapper.reception.SeihoAgent__r.AGENT_POST_CODE__c);
                component.set("v.innerCmpNewRequest.DestinationAddress__c",addressInfoWrapper.reception.SeihoAgent__r.Name);
            }
        };
    
        if(component.get("v.innerCmpNewRequest.ShippingInput__c")=="申出人から引用") {
            setMasterAddress();
        } else if(component.get("v.innerCmpNewRequest.ShippingInput__c")=="取引先から引用") {
            setAccountAddress();
        } else {
            if(!$A.util.isEmpty(addressInfoWrapper.reception.Account__r)){ 
            
                if(component.get("v.innerCmpNewRequest.ShippingInput__c")!='取引先から引用'){
                    component.set("v.innerCmpNewRequest.ShippingInput__c",'取引先から引用');
                       window.setTimeout(
                        $A.getCallback(function() {
                            component.set("v.selectVal",'取引先から引用');
                        }), 5
                    );
                    setAccountAddress();
                }
            } else if(component.get("v.innerCmpNewRequest.ShippingInput__c")!='申出人から引用'){
                component.set("v.innerCmpNewRequest.ShippingInput__c",'申出人から引用');
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.selectVal",'申出人から引用');
                    }), 5
                );
                setMasterAddress();
            }
        }
    },
    getShippingInputPickList : function(component,event,PickListVal,addressInfoWrapper) {
      var action = component.get("c.getSinglePicklist");
      action.setParams({
        objectName : 'Request__c',
        fieldName : PickListVal
      });

      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {                
          var result = response.getReturnValue();
          console.log("PicklistResponse"+JSON.stringify(result));
          // create a empty array for store map keys(@@--->which is RequestContent picklist values) 
          var listOfkeys = [];// for store all map keys (RequestContent picklist values)
          var PickListFields = [];// for store RequestContent picklist value to set on lightning:select. 

          // play a for loop on Return map 
          // and fill the all map key on listOfkeys variable.
          for (var singlekey in result) {
            listOfkeys.push(singlekey);
          }
          //set the PickListFields field value for lightning:select
          if (listOfkeys != undefined && listOfkeys.length > 0) {
            PickListFields.push('--- None ---');
          }
          for (var j = 0;j < listOfkeys.length;j++) {
            PickListFields.push(listOfkeys[j]);
          }

          // set the PickListFields variable values (controller picklist field)
          const indexOfAccount = PickListFields.indexOf('取引先から引用')
          if($A.util.isEmpty(addressInfoWrapper.reception.Account__r)){
            if (indexOfAccount > -1) {
              PickListFields.splice(indexOfAccount, 1);
            }
          }
          const indexOfMaster = PickListFields.indexOf('申出人から引用');
          if($A.util.isEmpty(addressInfoWrapper.reception.SeihoAgent__r) && $A.util.isEmpty(addressInfoWrapper.reception.SeihoRecruiter__r)) {
            if (indexOfMaster > -1) {
              PickListFields.splice(indexOfMaster, 1);
            }
          }
          component.set("v.shippingInputPLValues", PickListFields);
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
    }
})