({
    saveInlineAccountCrecaChange : function(cmp, event) {
        var params = event.getParam('arguments');        
        var obj = params.parentNewRequest;   
            obj.Changes__c=cmp.get("v.innerCmpNewRequest").Changes__c;
			obj.DateOfChange__c=cmp.get("v.innerCmpNewRequest").DateOfChange__c;
			obj.DesignatedAccount__c=cmp.get("v.innerCmpNewRequest").DesignatedAccount__c;
			obj.OtherInfomation__c=cmp.get("v.innerCmpNewRequest").OtherInfomation__c;	
    }, 
     init : function(component,event,helper){
         var dependantSubject = component.get('v.dependantSubject');
         helper.getChangesPickList(component, event,dependantSubject);
    },
    handleDesignated : function (component, event,helper) { 
        var disableFlag;
        var dependantValue = component.find("changesPickList").get("v.value");
        if(dependantValue != '' && dependantValue !='--- None ---' && dependantValue == '口座'){
            helper.getDesignatedAccountPickList(component, event,dependantValue);
            disableFlag = false;
        }else{
            disableFlag = true;
        }
        component.find("designatedAccountPickList").set("v.disabled", disableFlag);
        component.find("designatedAccountPickList").set("v.value", '')
	}
})