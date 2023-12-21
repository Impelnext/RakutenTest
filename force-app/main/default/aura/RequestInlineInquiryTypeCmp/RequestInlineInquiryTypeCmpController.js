({
	init : function(component, event, helper) {
        var dependantSubject = component.get("v.dependantSubject");
        helper.getRequestTypPickListValues(component,event,dependantSubject);
		
	},
    saveInquiryType : function(component, event, helper){
        var params = event.getParam('arguments');
       	var obj= params.parentNewRequest;
        obj.RequestType__c = component.get("v.innerCmpNewRequest").RequestType__c;
        
        //Calling Aura method in child cmp
        if(obj.RequestType__c=='情報連携・対応依頼'){
		component.get("v.body")[2].ReqContent(obj);
        }
        
        else if(obj.RequestType__c=='書類発送あり'){
		component.get("v.body")[2].DocShipment(obj);
        }

		console.log('ObjInqTypresp'+JSON.stringify(obj));
    },
    onRequestTypeChange : function(component, event, helper){
        console.log('Entering On change request type change');
        var seletedRequestType = event.getSource().get("v.value");
        console.log('seletedRequestType'+seletedRequestType);
        var innerCmpNewRequest = component.get("v.innerCmpNewRequest");
        var parentNewRequest = component.get("v.parentNewRequest");
        var dependantSubject = component.get("v.dependantSubject");
        var recContractWrapper = component.get("v.recContractWrapper");
        
        //Removing dynamic section once "None" is being selected
       	if(seletedRequestType == '--- None ---' ||seletedRequestType == '問い合わせのみ'){
        	component.set("v.body",component.get("v.body").push([]));
        }
        //情報連携・対応依頼：依頼内容セクション
        else if(seletedRequestType=='情報連携・対応依頼'){
            component.set("v.body",component.get("v.body").push([]));
            helper.createDynamicComponent(component,"c:InlineRequestContent",{"parentNewRequest":innerCmpNewRequest},"InlineRequestContent");
                    
        }
        //書類発送あり：書類発送セクション
         else if(seletedRequestType=='書類発送あり'){
             component.set("v.body",component.get("v.body").push([]));
             helper.createDynamicComponent(component,"c:RequestInlineDocumentShipmentCmp",{"parentNewRequest":innerCmpNewRequest,"subjectSelected":dependantSubject,"recContractWrapper":recContractWrapper},"InlineDocumentShipmentCmp");   
            }
    }
})