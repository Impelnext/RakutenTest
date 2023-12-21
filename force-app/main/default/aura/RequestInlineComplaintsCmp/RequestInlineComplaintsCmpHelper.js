({
    getVOCTypePickList: function(component, event) {
/*        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'VOCType__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.vocTypePickList", plValues);
            }
        });
        $A.enqueueAction(action);*/
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'VOCType__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var vocTypePickMap = [];
                console.log("---- getVocTypePick ----");
                for(var key in result){
                    console.log(key + "," + result[key]);
                    vocTypePickMap.push({key: key, value: result[key]});
                }
                component.set("v.vocTypePickMap", vocTypePickMap);
            }
        });
        $A.enqueueAction(action);

    },
	getAdditionalReasonsPickList: function(component, event) {
        var action = component.get("c.getMultiPiklistValues");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'AdditionalReasons__c'
		});
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.additionalReasonsPickList", plValues);
            }
        });
        $A.enqueueAction(action);
    },
	
	getCauseOfCompanyPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CauseOfCompany__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfCompanyPickMap = [];
                console.log("---- getCauseOfCompanyPick ----");
                for(var key in result){
                    console.log(key + "," + result[key]);
                    causeOfCompanyPickMap.push({key: key, value: result[key]});
                }
                component.set("v.causeOfCompanyPickMap", causeOfCompanyPickMap);
            }
        });
        $A.enqueueAction(action);
    },
	getCauseOfDivisionPick: function(component, event) {
        var action = component.get("c.getSinglePicklist");
		action.setParams({
			objectName : 'Request__c',
			fieldName : 'CauseOfDivision__c'
		});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var result = response.getReturnValue();
                var causeOfDivisionPickMap = [];
                console.log("---- getCauseOfDivisionPick ----");
                for(var key in result){
                    causeOfDivisionPickMap.push({key: key, value: result[key]});
                }
                console.log(causeOfDivisionPickMap);
                component.set("v.causeOfDivisionPickMap", causeOfDivisionPickMap);
            }
        });
        $A.enqueueAction(action);
    },
    getInsuranceCompanyPick : function(component, event) {
        var action = component.get('c.getDependentMap');
        action.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'InsuranceCompany__c', 
            depfieldApiName : 'CauseOfDivision__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                var insuranceCompanyPickMap = [];
                console.log('---- getInsuranceCompanyPick ----');
                for(var key in result){
                    insuranceCompanyPickMap.push({key: key, value: key});
                }
                console.log(insuranceCompanyPickMap);
                component.set("v.insuranceCompanyPickMap", insuranceCompanyPickMap);
                component.set("v.comDivisionPickMap", result);
            }
        });
        $A.enqueueAction(action);
    },
    getDivisionSummaryMap: function(component, event) {
        var action = component.get('c.getDependentMap');
        action.setParams({
            objDetail : 'Request__c',
            contrfieldApiName : 'CauseOfDivision__c',
            depfieldApiName : 'ComplaintSummary__c'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS'){
                var result=response.getReturnValue();
                console.log('---- getDivisionSummaryMap ----');
                console.log(result);
                component.set('v.divSummaryMap',result);
            }
        });
        $A.enqueueAction(action);
    },
    changeInsuranceCompany: function(component, event, selectedValues){
        // 起因領域/苦情概要のクリア
        component.set('v.innerCmpNewRequest.ComplaintSummary__c','');
        component.set('v.innerCmpNewRequest.CauseOfDivision__c','');
        // 起因領域PickListの設定
        if( selectedValues != '' ) {
            var comDivisionPickMap = component.get('v.comDivisionPickMap');
            var causeOfDivisionPick = [];
            var divisionList = comDivisionPickMap[selectedValues];
            var l = divisionList.length;
            for(var cnt=0;cnt<l;cnt++){
                causeOfDivisionPick.push({key:divisionList[cnt],value:divisionList[cnt]});
            }
            component.set("v.causeOfDivisionPickMap",causeOfDivisionPick);
            component.find('causeOfDivisionPicklist').set('v.disabled',false);
            var summaryDesabled = true;
            if(selectedValues === 'IP') {
                summaryDesabled = false;
                component.set('v.innerCmpNewRequest.CauseOfDivision__c','その他(IP)');
                this.changeCauseOfDivision(component, event, 'その他(IP)');
                component.set('v.innerCmpNewRequest.ComplaintSummary__c','その他');
            }
            component.find('ComplaintSummaryPicklist').set('v.disabled',summaryDesabled);
        }else{
            component.find('causeOfDivisionPicklist').set('v.disabled',true);
            component.find('ComplaintSummaryPicklist').set('v.disabled',true);
        }
    },
    changeCauseOfDivision: function(component, event, selectedValues){
        // 苦情概要のクリア
        component.set('v.innerCmpNewRequest.ComplaintSummary__c','');
        // 苦情概要PickListの設定
        if( selectedValues != '' ) {
            var divSummaryMap = component.get('v.divSummaryMap');
            var complaintSummaryPickMap = [];
            var summaryList = divSummaryMap[selectedValues];
            var l = summaryList.length;
            for(var cnt=0;cnt<l;cnt++){
                complaintSummaryPickMap.push({key:summaryList[cnt],value:summaryList[cnt]});
            }
            component.set("v.complaintSummaryPickMap",complaintSummaryPickMap);
            component.find('ComplaintSummaryPicklist').set('v.disabled',false);
        }else{
            component.find('ComplaintSummaryPicklist').set('v.disabled',true);
        }
    }

})