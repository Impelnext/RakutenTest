/*
* @Class Name      : ReceptionController 
* @Description     : 
* @Created Date    : 2019.09.23
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
public with sharing class ReceptionController{

    @AuraEnabled
    public static Reception__c saveReception (Reception__c rec,Id accountId,Map<String, String> areaInfoMap,Integer clone) {
        Reception__c rece ;
        try{
            
            if(clone != null){
                rece = rec.clone(false,true,false,false);
            }
            else if(accountId != null){
                rece=rec;
                rece.Account__c = accountId;
            }
            else{
                rece=rec;
            }
            
            if(areaInfoMap != null && areaInfoMap.size()>0){
                if(areaInfoMap.get('prefecture') != null)
                    rece.MailingState__c = areaInfoMap.get('prefecture');
                if(areaInfoMap.get('municipality') != null)
                    rece.MailingCity__c = areaInfoMap.get('municipality');
                if(areaInfoMap.get('chome') != null)
                    rece.Address1__c = areaInfoMap.get('chome');
            }
            
            upsert rece;
           
        }
        catch(Dmlexception e){
            e.getMessage();
        }
        
        return rece;
    }
    
    @AuraEnabled
    public static Account getAccDetails(id receptionAccId) {
        Account acc = new Account();
        List<Account> accList = [SELECT id,CRMID__c,Name,PersonBirthDate,PersonMailingAddress, 
                                        PersonBirthDateJp__c,PersonMailingPostalCode, PersonMailingState,PersonMailingCity, 
                                        PersonMailingStreet, furigana__c 
                                   FROM Account WHERE id =:receptionAccId];
        if(accList != null && !accList.isEmpty()){
            acc = accList[0];
        }
        return acc;
    }
   
    @AuraEnabled
    public static reception__c getAccReceptionDetails(id receptionId) {
        reception__c rec = new reception__c();
        //id accountReceptionId=[select id,account__c,crmid__c from Account where id=:receptionId][0].account__c;
        //Modify 2023/08/09 RIPCRM-967_受付情報への入力項目欄追加 By 紀　Start
        reception__c reception = [select id,Account__r.Name,MailingPostalCode__c,ReceptionTeam__c,Description__c,
                                         Account__r.furigana__c,Account__r.PersonContact.Birthdate,Account__r.PersonBirthDateJp__c,
                                         Account__r.CRMID__c,PersonBirthdate__c,PersonBirthDateJp__c,Account__r.PersonContact.MailingPostalCode,
                                         Account__r.PersonContact.MailingState,Account__r.PersonContact.MailingCity,
                                         Account__r.PersonContact.MailingStreet,RelationshipWithContractor__c,
                                         OtherPattern__c,NameOffererKana__c,Identification__c,BilleeRelationship__c,
                                         IdentityVerificationOthers__c,AdderssInputMethod__c,Addressee__c,MailingState__c,
                                         Address1__c,Address2__c,MailingCity__c,LF_Inquiry__c,LF_InquiryName__c,DM_Inquiry__c,
                                         DM_InquiryName__c,LT_Inquiry__c,LT_InquiryName__c,SeihoAgent__r.Name,SeihoRecruiter__r.Name,
                                         ForAggregation__c, No__c, NPSQuestionnaireRecipient__c, PostProcessingCheck__c 
                                    from reception__c where id=:receptionId];
        //Modify 2023/08/09 RIPCRM-967_受付情報への入力項目欄追加 By 紀　End
        if(reception != null ){
            rec = reception;
        }
        return rec;
    }
    
    @AuraEnabled
    public static Map<String,Boolean> getContractInfo(String recAccountId){
        return ContractCount.getContractCount(recAccountId);
    }
    
    @AuraEnabled
    public static List <String> getMultiPiklistValues(String objectName,String fieldName) {
        List<String> plValues = new List<String>();
        if(objectName != null && fieldName != null){
            //Get the object type from object name. 
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);             
            //Describe the sObject using its object type.
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();            
            //Get the specific field information from field name. 
            Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get(fieldName).getDescribe();          
            //Get the picklist field values.
            List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();            
            //Add the picklist values to list.
            for(Schema.PicklistEntry plv: picklistvalues) {
                plValues.add(plv.getValue());
            }
        }       
        return plValues;
    }
    @AuraEnabled //get Picklist Values
    public static Map<String, String> getSinglePicklist(String objectName,String fieldName){
        Map<String, String> options = new Map<String, String>();
        //Get the object type from object name. 
        if(objectName != null && fieldName != null){
             Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
            //Describe the sObject using its object type.
            Schema.DescribeSObjectResult objDescribe = objType.getDescribe();            
            //Get the specific field information from field name. 
            Schema.DescribeFieldResult fieldResult = objDescribe.fields.getMap().get(fieldName).getDescribe();
            //get Picklist Values
            List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry p: pList) {
                //Put Picklist Value & Label in Map
                options.put(p.getValue(), p.getLabel());
            }
        }      
        return options;
    }
    @AuraEnabled //get AreaInfo
    public static Map<String, String> getAreaInfo(String postalCode){
        // 郵便番号APIを呼出
        Map<String, String> areaInfoMap = ZipUtil.getAreaInfo(postalCode);
        return areaInfoMap ;    
    }
    @AuraEnabled
    public static Map<String,Boolean> getAccountContract(String accountId){

        return ContractCount.getContractCount(accountId);
    }
    
     //Dependent Picklist
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(String objDetail, string contrfieldApiName,string depfieldApiName) {
        Map<String, List<String>> objResults = dependentPicklistCtrl.getDependentMap(objDetail, contrfieldApiName,depfieldApiName);
        System.Debug('objResults::'+objResults);
        return objResults;
    }
    
    @AuraEnabled
    public static Map<String, String> getMasterInfo( Id masterId ){
        Map<String, String> response = new Map<String, String>();
        if( masterId.getSobjectType() == SeihoRecruiterMaster__c.getSobjectType() ) {
            for( SeihoRecruiterMaster__c recruiter : [SELECT Id, KANA_NAME__c FROM SeihoRecruiterMaster__c WHERE Id =: masterId] ) {
                response.put('Id', recruiter.Id);
                response.put('KANA_NAME', recruiter.KANA_NAME__c);
            }
        } else if( masterId.getSobjectType() == SeihoAgentMaster__c.getSobjectType() ) {
            for( SeihoAgentMaster__c agent : [SELECT Id, KANA_AGENT_NAME__c FROM SeihoAgentMaster__c WHERE Id =: masterId] ) {
                response.put('Id', agent.Id);
                response.put('KANA_NAME', agent.KANA_AGENT_NAME__c);
            }
        }
        return response;
    }
}