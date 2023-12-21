({
    init : function(component, event, helper){
    	
        var PickLists = ['ShippingInput__c','DateOfShipment__c','ShippingMethod__c'];
        //console.table("addressInfoWrapper"+JSON.stringify(component.get("v.recContractWrapper")));
        var addressInfoWrapper = JSON.parse(JSON.stringify(component.get("v.recContractWrapper")));
        
        //Fetching single pick list values
        for (let i=0;i<PickLists.length;i++){
		helper.getSinglePickListvaues(component,event,PickLists,PickLists[i],addressInfoWrapper);
        }
        //Fetching dependant pick list values-->report group
        var dependantSubject = component.get("v.subjectSelected");
        helper.ReportGroupPickListValues(component,event,dependantSubject);
  
        //Setting Address values from Account or Master
        helper.setAddress(component,event,addressInfoWrapper);
    },
    onControllerFieldChange : function(component, event, helper){
        var dependantReportGroup = component.find("reportGroup").get("v.value");
        helper.ReportPickListValues(component,event,dependantReportGroup);
    },
    handleAreaInfo : function(component,event,helper){
        
        if(component.find("ShippingInput").get("v.value") == "手動入力"){
            helper.areaInfo(component, event); 
            }
        
    },
    onChangeShippingInp : function(component, event, helper){
       var selection = event.getSource().get("v.value");
        
        if(selection=="手動入力"||selection=="--- None ---"){
          component.find("Prefectures").set("v.disabled",false);
          component.find("Address1").set("v.disabled",false);
          component.find("Address2").set("v.disabled",false);
          component.find("City").set("v.disabled",false);
          component.find("DestinationAddress").set("v.disabled",false);
          component.find("PostalCode").set("v.disabled",false);
          component.set("v.innerCmpNewRequest.Prefectures__c",'');
          component.set("v.innerCmpNewRequest.Address1__c",'');
          component.set("v.innerCmpNewRequest.City__c",''); 
          component.set("v.innerCmpNewRequest.Address2__c",'');
          component.set("v.innerCmpNewRequest.Postalcode__c",'');
          component.set("v.innerCmpNewRequest.DestinationAddress__c",'');
            
        }
        else{
            var addressInfoWrapper = JSON.parse(JSON.stringify(component.get("v.recContractWrapper")));
            
           	//Setting Address values from Account or Master
          	helper.setAddress(component,event,addressInfoWrapper);
         	component.find("Prefectures").set("v.disabled",true);
          	component.find("Address1").set("v.disabled",true);
          	component.find("Address2").set("v.disabled",true);
          	component.find("City").set("v.disabled",true);
          	component.find("PostalCode").set("v.disabled",true);
            component.find("DestinationAddress").set("v.disabled",true);
        }
    
    },
         
    saveDocShipment : function(component, event, helper){
      	var params = event.getParam('arguments');
       	var obj= params.parentNewRequestFromInqTyp;
        //Saving values in parent comp 
        obj.ReportGroup__c = component.get("v.innerCmpNewRequest").ReportGroup__c;
        obj.report_agency__c = component.get("v.innerCmpNewRequest").report_agency__c;
        obj.Remarks__c = component.get("v.innerCmpNewRequest").Remarks__c;
        obj.NumberOfCopies__c = component.get("v.innerCmpNewRequest").NumberOfCopies__c;
        obj.ShippingInput__c = component.get("v.innerCmpNewRequest").ShippingInput__c;
        obj.DestinationAddress__c = component.get("v.innerCmpNewRequest").DestinationAddress__c;
        obj.Postalcode__c	 = component.get("v.innerCmpNewRequest").Postalcode__c;
        obj.Prefectures__c = component.get("v.innerCmpNewRequest").Prefectures__c;
        obj.Address1__c = component.get("v.innerCmpNewRequest").Address1__c;
        obj.Address2__c = component.get("v.innerCmpNewRequest").Address2__c;
        obj.DateOfShipment__c = component.get("v.innerCmpNewRequest").DateOfShipment__c;
        obj.ShippingMethod__c = component.get("v.innerCmpNewRequest").ShippingMethod__c;
		obj.City__c = component.get("v.innerCmpNewRequest").City__c;
    }
})