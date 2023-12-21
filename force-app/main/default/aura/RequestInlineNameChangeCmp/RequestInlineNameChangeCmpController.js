({
    saveInlineName : function(cmp, event) {
        var params = event.getParam('arguments');
        var obj = params.parentNewRequest;
        obj.ProcedureType__c = cmp.get("v.innerCmpNewRequest").ProcedureType__c;
        obj.AfterChangedNameKanji__c = cmp.get("v.innerCmpNewRequest").AfterChangedNameKanji__c;
        obj.AfterChangedNameKana__c = cmp.get("v.innerCmpNewRequest").AfterChangedNameKana__c;
        obj.SimultaneousChanges__c = cmp.get("v.innerCmpNewRequest").SimultaneousChanges__c; 
        obj.AfterChangedNameMinorKanji__c = cmp.get("v.innerCmpNewRequest").AfterChangedNameMinorKanji__c;
        obj.AfterChangedNameMinorKana__c = cmp.get("v.innerCmpNewRequest").AfterChangedNameMinorKana__c;
        obj.Processing__c = cmp.get("v.innerCmpNewRequest").Processing__c;
    },    
    init : function(component,event,helper){
        var dependantSubject = component.get('v.dependantSubject');
        helper.getProcedureTypePicklist(component, event);
        helper.getSimultaneousChangesPicklist(component, event);
        helper.getProcessingPicklist(component, event,dependantSubject);
    },
      handleProcedureTypePick: function (component, event) {
        var selectedValues = event.getParam("value");
        // Add 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　Start
        var accountFields = component.get('v.accountFields');
        var ProcedureType = component.get('v.innerCmpNewRequest.ProcedureType__c');
        var changFirstNamekannji = accountFields.reception.Account__r.FirstName;
        var changFirstNamekana = accountFields.reception.Account__r.furiganaForst__pc ;
        if(ProcedureType == "改姓"){
            changFirstNamekannji = changFirstNamekannji == undefined ? '　' : "　" + changFirstNamekannji;
            component.set("v.innerCmpNewRequest.AfterChangedNameKanji__c", changFirstNamekannji);
            changFirstNamekana =changFirstNamekana == undefined ? '　' : "　" + changFirstNamekana;
            component.set("v.innerCmpNewRequest.AfterChangedNameKana__c", changFirstNamekana);
        }else{
            component.set("v.innerCmpNewRequest.AfterChangedNameKanji__c", null);
            component.set("v.innerCmpNewRequest.AfterChangedNameKana__c", null);
        }
        // Add 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　End
    },
	  handleSimultaneousChangesPick: function (component, event) {
        var selectedValues = event.getParam("value");
    },
	  handleProcessingPick: function (component, event) {
        var selectedValues = event.getParam("value");
    }
})