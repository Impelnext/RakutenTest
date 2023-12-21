({
    saveTabletTeamviewer : function(cmp, event,helper) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.TeamViewer__c=cmp.get("v.innerCmpNewRequest").TeamViewer__c;
        obj.TabletOperation__c=cmp.get("v.innerCmpNewRequest").TabletOperation__c;
    	obj.TabletError__c=cmp.get("v.innerCmpNewRequest").TabletError__c;
        obj.TabletCheck__c=cmp.get("v.innerCmpNewRequest").TabletCheck__c;
        obj.TabletPolicy__c=cmp.get("v.innerCmpNewRequest").TabletPolicy__c;
        obj.TabletReserve__c=cmp.get("v.innerCmpNewRequest").TabletReserve__c;
        obj.SeihoRequestContents__c=cmp.get("v.innerCmpNewRequest").SeihoRequestContents__c;
        obj.DetailsOfRequest__c=cmp.get("v.innerCmpNewRequest").DetailsOfRequest__c;
        obj.EmergencyFlag__c=cmp.get("v.innerCmpNewRequest").EmergencyFlag__c;
        obj.CallBackStartTime__c=cmp.get("v.innerCmpNewRequest").CallBackStartTime__c;
        obj.CallBackEndTime__c=cmp.get("v.innerCmpNewRequest").CallBackEndTime__c;
        obj.ReturnName__c=cmp.get("v.innerCmpNewRequest").ReturnName__c;
        obj.ReturnContact__c=cmp.get("v.innerCmpNewRequest").ReturnContact__c;

        console.log("obj"+JSON.stringify(obj));
    },

    setValues : function(cmp,event,helper){
        var selected=[],checkboxes=cmp.find("checkbox");
        console.log("checkboxes"+checkboxes);
        if(!checkboxes.length) { 
            checkboxes = [checkboxes];
            console.log('-------checkebox array----'+checkboxes);
        	}
         checkboxes
        .filter(checkbox => checkbox.get("v.checked"))    // Get only checked boxes
        .forEach(checkbox => selected.push(checkbox.get("v.label")));   // And get the labels
       // Set to Req Obj
       console.log("selected"+selected);
        if(selected.includes("TeamViewer")){
        	cmp.set("v.innerCmpNewRequest.TeamViewer__c",true);
        }
        else{
            console.log("Inside Esle");
          	cmp.set("v.innerCmpNewRequest.TeamViewer__c",false);  
        }
        if(selected.includes("タブレット 操作方法")){
            console.log("Selecting タブレット 操作方法");
            cmp.set("v.innerCmpNewRequest.TabletOperation__c",true);
        }
        else{
          	cmp.set("v.innerCmpNewRequest.TabletOperation__c",false);
        }
      	if(selected.includes("タブレット エラー障害")){
         	cmp.set("v.innerCmpNewRequest.TabletError__c",true);
      	}
        else{
          	cmp.set("v.innerCmpNewRequest.TabletError__c",false);  
        }
      	if(selected.includes("タブレット チェック定義")){
         	cmp.set("v.innerCmpNewRequest.TabletCheck__c",true);
        }
        else{
            cmp.set("v.innerCmpNewRequest.TabletCheck__c",false);
        }
      	if(selected.includes("タブレット 制度・施")){
         	cmp.set("v.innerCmpNewRequest.TabletPolicy__c",true);   
        }
        else{
          	cmp.set("v.innerCmpNewRequest.TabletPolicy__c",false);  
        }
       	if(selected.includes("タブレット 代理店控え")){    
            cmp.set("v.innerCmpNewRequest.TabletReserve__c",true);
 
     	}
        else{
           	 cmp.set("v.innerCmpNewRequest.TabletReserve__c",false);
        }
        

 	}
    
})