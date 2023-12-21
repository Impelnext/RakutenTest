/*
* @Class Name      : RequestController 
* @Description     : 
* @Created Date    : 2019.10.01
* @Created By      : 
* @Modified Date   : 
* @Modified        : 
*/
public with sharing class RequestController{
    public static String doubleRegex = '[\\x01-\\x7Eｦ-ﾟ]';
    
    @AuraEnabled
    public static Request__c saveRequest (Request__c req,Id receptionId,Id accountId,List<String> selectPolicyNumbers) {
        System.Debug('Req controller req:: ' + req);
        System.Debug('Req controller receptionId:: ' + receptionId);
        String msg = '';
        integer policyMatchCount = 0;
        try {
            //Id TabletTeamviewerRecordTypeId = Schema.SObjectType.Reception__c.getRecordTypeInfosByDeveloperName().get('Team_viewer').getRecordTypeId();

            if(accountId != null){
                req.Account__c = accountId;
            }
            if(receptionId != null){
                req.Reception__c = receptionId;
            }
             if(req.Class__c == '--- None ---'){
                req.Class__c = null;
            }
             if(req.Type__c == '--- None ---'){
                req.Type__c = null;
            }
            if(req.Subject__c == '--- None ---'){
                req.Subject__c = null;
            }
            if(req.ProcedureType1__c == '--- None ---'){
                req.ProcedureType1__c = null;
            }
            if(req.ProcedureType2__c == '--- None ---'){
                req.ProcedureType2__c = null;
            }
            if(req.ProcedureType3__c == '--- None ---'){
                req.ProcedureType3__c = null;
            }
            if(req.ProcedureType4__c == '--- None ---'){
                req.ProcedureType4__c = null;
            }
            if(req.ProcedureType5__c == '--- None ---'){
                req.ProcedureType5__c = null;
            }
            if(req.ProcedureType6__c == '--- None ---'){
                req.ProcedureType6__c = null;
            }
            if(req.ProcedureType7__c == '--- None ---'){
                req.ProcedureType7__c = null;
            }
            if(req.ProcedureType8__c == '--- None ---'){
                req.ProcedureType8__c = null;
            }
            if(req.ProcedureType9__c == '--- None ---'){
                req.ProcedureType9__c = null;
            }   
            if(req.ProcedureType10__c == '--- None ---'){
                req.ProcedureType10__c = null;
            }
            
            // Validate Input Policy Numbers for the Types
            // 対応区分         対応種別
            // 生命専用ケース  受取人（生保）
            //                  減額
            //                  特約解約
            //                  更新時減額
            //                  指定代理人変更
            if ('受取人（生保）'.equals(req.Type__c) ||
                '減額'.equals(req.Type__c) ||
                '特約解約'.equals(req.Type__c) ||
                '更新時減額'.equals(req.Type__c) ||
                '指定代理人変更'.equals(req.Type__c)) {
                
                if (!validatePolicyNoSelectionInInput(req, selectPolicyNumbers)) {
                    throw createAuraHandledException('PolicyNumberDoesntMatch','選択した証券番号を全て入力してください。');
                }
            }
            
            upsert req;
        }
        catch(DmlException e){
            //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            //we can get from DmlException
             
            //Get All DML Messages
            for (Integer i = 0;i < e.getNumDml();i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
             
        }catch(Exception e){
            //throw all other exception message
            throw new AuraHandledException(e.getMessage());
            //System.debug('Err'+e.getMessage());
        }
        finally {
        }
        return req;
    }
    
    
    public static Boolean validatePolicyNoSelectionInInput(Request__c req, List<String> selectPolicyNoList){
        
        List<String> inputPolicyNoList = new List<String>();
        Set<String> polSet = new Set<String>();
        for( LifeContract__c lc : [SELECT Id, POLICY_MUTUAL_AID_NUMBER__c FROM LifeContract__c WHERE POLICY_MUTUAL_AID_NUMBER__c =: selectPolicyNoList] ) {
            polSet.add(lc.POLICY_MUTUAL_AID_NUMBER__c);
        } 
        //PolicyNumber Validate
        if(req.PolicyNumber1__c != null){
            if( polSet.contains(req.PolicyNumber1__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber1__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber1__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber2__c != null){
            if( polSet.contains(req.PolicyNumber2__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber2__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber2__c, inputPolicyNoList);

            }
        }
        if(req.PolicyNumber3__c != null){
            if( polSet.contains(req.PolicyNumber3__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber3__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber3__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber4__c != null){
            if( polSet.contains(req.PolicyNumber4__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber4__c, inputPolicyNoList);
            }else{
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber4__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber5__c != null){
            if( polSet.contains(req.PolicyNumber5__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber5__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber5__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber6__c != null){
            if( polSet.contains(req.PolicyNumber6__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber6__c, inputPolicyNoList);
            }else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber6__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber7__c != null){
            if( polSet.contains(req.PolicyNumber7__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber7__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber7__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber8__c != null){
            if( polSet.contains(req.PolicyNumber8__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber8__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber8__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber9__c != null){
            if( polSet.contains(req.PolicyNumber9__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber9__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber9__c, inputPolicyNoList);
            }
        }
        if(req.PolicyNumber10__c != null){
            if( polSet.contains(req.PolicyNumber10__c) ) {
                inputPolicyNoList = addToInputPolicyNoListSeiho(req.PolicyNumber10__c, inputPolicyNoList);
            } else {
                inputPolicyNoList = addToInputPolicyNoList(req.PolicyNumber10__c, inputPolicyNoList);
            }
        }
        System.debug('inputPolicyNoList:' + inputPolicyNoList);
        System.debug('selectPolicyNoList:' + selectPolicyNoList);
        
        // Validate Input Policy Numbers
        return getPolicyNumberMatchValidate(inputPolicyNoList, selectPolicyNoList);
    }
    
    
    @AuraEnabled
    public static ContractWrapper getContractInfo(Id receptionId){
        ContractWrapper wrapper = new ContractWrapper();
        
        System.Debug('receptionId::'+receptionId);
        Reception__c reception = new Reception__c();
        String accountId = null;
        // Modify 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　Start
        // List<Reception__c> receptionList =  [SELECT Id, Name, CRMID__c, Account__c,Account__r.Name, NameOffererKana__c,Account__r.PersonMailingAddress,
		List<Reception__c> receptionList =  [SELECT Id, Name, CRMID__c, Account__c,Account__r.Name, NameOffererKana__c,Account__r.PersonMailingAddress,Account__r.furiganaForst__pc,Account__r.FirstName,
        // Modify 2023/06/06 RIPCRM-893_名義変更ケースの要件変更についての変更 By 張　End
                                                    RelationshipWithContractor__c, BilleeRelationship__c, OtherPattern__c,SeihoRecruiter__c,SeihoAgent__c, 
                                                    FullAddress__c, Description__c,SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndcityarea__c,
                                                    SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndzip__c,SeihoRecruiter__r.SeihoAgencyMasterName__r.DestinationPrefccdName__c,
                                                    SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr1__c,SeihoRecruiter__r.SeihoAgencyMasterName__r.mssgbyndaddr2__c,
                                                    SeihoAgent__r.AGENT_POST_CODE__c,SeihoAgent__r.AGENT_REGION_DISPLAY__c,SeihoAgent__r.AGENT_CITY__c,SeihoAgent__r.AGENT_ADDRESS1__c,
                                                    SeihoAgent__r.AGENT_ADDRESS2__c,SeihoAgent__r.Name,SeihoRecruiter__r.SeihoAgencyMasterName__r.Name,
                                                    SeihoRecruiter__r.SeihoAgencyMasterName__r.agncynmkj__c, SeihoRecruiter__r.SeihoAgencyMasterName__r.msgsbyndaddr3__c
                                                FROM Reception__c 
                                               WHERE Id =: receptionId];
        if(receptionList != null && receptionList.size() > 0){
            reception = receptionList.get(0);
            if(receptionList.get(0).Account__c != null)
                accountId = receptionList.get(0).Account__c;
        }    
        System.Debug('reception::'+reception );
        wrapper.reception = reception;
        
        if (String.IsNotBlank(reception.Account__c)) {
        List<LifeContract__c> lifeConList = [SELECT Id, Name, STATUS_DISPLAY__c,POLICY_MUTUAL_AID_NUMBER__c, KANJI_CONTROR_NAME__c, 
                                                    KANJI_INSURED_NAME__c, INSURANCE_TYPE_DISPLAY__c, AgencyId__r.JointRecruitmentPermissionFlag__c,
                                                    INSR_PERIOD__c, CONTR_FORMATION_DATE__c,CONTRACT_DATE__c, BENE_AMOUNT__c, MONTHLY_PRM__c 
                                               FROM LifeContract__c 
                                              WHERE AccountId__c =: reception.Account__c 
                                                AND DELETE_STATUS__c <> '1'
                                              ORDER BY StatusSequence__c];
        for(LifeContract__c lifeCon : lifeConList){
             
            ContractTable lifeContractTbl = new ContractTable();
            lifeContractTbl.Id = lifeCon.Id;
            lifeContractTbl.note = lifeCon.AgencyId__r.JointRecruitmentPermissionFlag__c ? '乗合' : '';
            lifeContractTbl.status = lifeCon.STATUS_DISPLAY__c;
            lifeContractTbl.policyNumber = lifeCon.POLICY_MUTUAL_AID_NUMBER__c;
            lifeContractTbl.contractorName = lifeCon.KANJI_CONTROR_NAME__c;
            lifeContractTbl.insurerName = lifeCon.KANJI_INSURED_NAME__c;
            lifeContractTbl.insuranceType = lifeCon.INSURANCE_TYPE_DISPLAY__c;
            lifeContractTbl.insurancePeriod = lifeCon.INSR_PERIOD__c;
            lifeContractTbl.contractEstablishedDate = lifeCon.CONTRACT_DATE__c;
            lifeContractTbl.amount = lifeCon.BENE_AMOUNT__c;
            lifeContractTbl.premium = lifeCon.MONTHLY_PRM__c;
            lifeContractTbl.insurancePurpose = '';
            lifeContractTbl.insuredDivision = '';
            lifeContractTbl.carNumber = '';
            
            wrapper.contractList.add(lifeContractTbl);
        }
        
        List<DamageContract__c> damageConList = [SELECT Id,Name, ContractStatusDisplay__c, InsuraPolicyNo__c, Torihikisakiname__c, InsuredPerson__c, SonpoInsuranceType__c,
                                                        ContractTerm__c, ContractStartDate__c, InsuranceFee__c, InsuredDiv__c, CarNo__c, AgencyCode1__c, AgencyCode2__c, AgencyCode3__c,
                                                        AgencyCode4__c,AgencyCode5__c, AgencyId1__r.JointRecruitmentPermissionFlag__c, AgencyId2__r.JointRecruitmentPermissionFlag__c,
                                                        AgencyId3__r.JointRecruitmentPermissionFlag__c, AgencyId4__r.JointRecruitmentPermissionFlag__c, AgencyId5__r.JointRecruitmentPermissionFlag__c,
                                                        AgencyCode__c, AgencyId1__c
                                                   FROM DamageContract__c 
                                                  WHERE AccountId__c =: reception.Account__c 
                                                  ORDER BY StatusSequence__c];
                                                  
        Set<String> agencyCodeSet = new Set<String>();
        List<String> agencyCodeList = new List<String>();
        for(DamageContract__c damageCon : damageConList){
            /*
            agencyCodeSet.add(!String.isEmpty(damageCon.AgencyCode1__c) ? damageCon.AgencyCode1__c : null);
            agencyCodeSet.add(!String.isEmpty(damageCon.AgencyCode2__c) ? damageCon.AgencyCode2__c : null);
            agencyCodeSet.add(!String.isEmpty(damageCon.AgencyCode3__c) ? damageCon.AgencyCode3__c : null);
            agencyCodeSet.add(!String.isEmpty(damageCon.AgencyCode4__c) ? damageCon.AgencyCode4__c : null);
            agencyCodeSet.add(!String.isEmpty(damageCon.AgencyCode5__c) ? damageCon.AgencyCode5__c : null);
            */
            
            // 代理店コードがNG代理店にいる＋損保契約情報の幹事代理店がある場合、
            // 「NG」を表示する
            if (String.IsNotBlank(damageCon.AgencyCode__c) && 
                String.IsNotBlank(damageCon.AgencyCode1__c)) {
                // 契約の代理店コードの判定
                for(String agency : damageCon.AgencyCode__c.split(',')){
                    agencyCodeSet.add(StringUtil.trim(agency));
                }
                
                agencyCodeSet.add(damageCon.AgencyCode1__c);
            }
        }
        
        agencyCodeSet.remove(null);
        agencyCodeList.addAll(agencyCodeSet);
        
        Map<String,NGAgency__c> ngAgencyMap = NgAgencyHelper.getNgAgencyMap(agencyCodeList);
        
        for(DamageContract__c damageCon : damageConList){
            
            ContractTable damageContractTbl = new ContractTable();
            damageContractTbl.Id = damageCon.Id;
            //if(ngAgencyMap.containsKey(damageCon.AgencyCode1__c) || ngAgencyMap.containsKey(damageCon.AgencyCode2__c) || ngAgencyMap.containsKey(damageCon.AgencyCode3__c) ||
            //   ngAgencyMap.containsKey(damageCon.AgencyCode4__c) || ngAgencyMap.containsKey(damageCon.AgencyCode5__c)){
            
            // 代理店コードがNG代理店にいる＋損保契約情報の幹事代理店がある場合、
            // 「NG」を表示する
            
            Boolean isNG = false;
            if (String.IsNotBlank(damageCon.AgencyCode__c) && 
                String.IsNotBlank(damageCon.AgencyCode1__c)  && 
                ngAgencyMap.containsKey(damageCon.AgencyCode1__c)) {
                // 契約の代理店コードのNGCheck
                for(String agency : damageCon.AgencyCode__c.split(',')){
                    if (ngAgencyMap.containsKey(StringUtil.trim(agency))) {
                        isNG = true;
                        break;
                        // NOTREACHED
                    }
                }
            }
            
            if (isNG) {
                damageContractTbl.note = 'NG';
            }else{
                damageContractTbl.note = '';
            }
            
            if(damageCon.AgencyId1__r.JointRecruitmentPermissionFlag__c || damageCon.AgencyId2__r.JointRecruitmentPermissionFlag__c || damageCon.AgencyId3__r.JointRecruitmentPermissionFlag__c || 
               damageCon.AgencyId4__r.JointRecruitmentPermissionFlag__c || damageCon.AgencyId5__r.JointRecruitmentPermissionFlag__c){
                damageContractTbl.note = !String.isEmpty(damageContractTbl.note) ? damageContractTbl.note + '乗合' : '乗合';
            }else{
                damageContractTbl.note = !String.isEmpty(damageContractTbl.note) ? damageContractTbl.note : '';
            }
            damageContractTbl.status = damageCon.ContractStatusDisplay__c;
            damageContractTbl.policyNumber = damageCon.InsuraPolicyNo__c;
            damageContractTbl.contractorName = damageCon.Torihikisakiname__c;
            damageContractTbl.insurerName = damageCon.InsuredPerson__c;
            damageContractTbl.insuranceType = damageCon.SonpoInsuranceType__c;
            damageContractTbl.insurancePeriod = damageCon.ContractTerm__c;
            damageContractTbl.contractEstablishedDate = damageCon.ContractStartDate__c;
            damageContractTbl.amount = '';
            damageContractTbl.premium = damageCon.InsuranceFee__c;
            damageContractTbl.insurancePurpose = '';
            damageContractTbl.insuredDivision = damageCon.InsuredDiv__c;
            damageContractTbl.carNumber = damageCon.CarNo__c;
            
            wrapper.contractList.add(damageContractTbl);
        }
        
//        List<LittleContract__c> littleConList = [SELECT Id, Name, SubscriberStatusDisply__c, SubscriberManageNo__c, SubscriberNameKanji__c, InsuredKanji__c, 
        List<LittleContract__c> littleConList = [SELECT Id, Name, SubscriberStatusLabel__c, SubscriberManageNo__c, SubscriberNameKanji__c, InsuredKanji__c, 
                                                        InsuranceType__c, AgencyId__r.JointRecruitmentPermissionFlag__c,
                                                        InsurancePeriod__c, InsuranceCommencement__c, InsurancePremium__c, InsuranceTarget_1__c 
                                                   FROM LittleContract__c 
                                                  WHERE AccountId__c =: reception.Account__c 
                                                  ORDER BY StatusSequence__c];
        for(LittleContract__c littleCon : littleConList){
            
            ContractTable littleContractTbl = new ContractTable();
            littleContractTbl.Id = littleCon.Id;
            littleContractTbl.note = littleCon.AgencyId__r.JointRecruitmentPermissionFlag__c ? '乗合' : '';
//            littleContractTbl.status = littleCon.SubscriberStatusDisply__c;
            littleContractTbl.status = littleCon.SubscriberStatusLabel__c;
            littleContractTbl.policyNumber = littleCon.SubscriberManageNo__c;
            littleContractTbl.contractorName = littleCon.SubscriberNameKanji__c;
            littleContractTbl.insurerName = littleCon.InsuredKanji__c;
            littleContractTbl.insuranceType = littleCon.InsuranceType__c;
            littleContractTbl.insurancePeriod = littleCon.InsurancePeriod__c;
            littleContractTbl.contractEstablishedDate = littleCon.InsuranceCommencement__c;
            littleContractTbl.amount = '';
            littleContractTbl.premium = littleCon.InsurancePremium__c;
            littleContractTbl.insurancePurpose = littleCon.InsuranceTarget_1__c;
            littleContractTbl.insuredDivision = '';
            littleContractTbl.carNumber = '';
            
            wrapper.contractList.add(littleContractTbl);
        }
        }
        
        wrapper.contractCountAlertFlag = wrapper.contractList.size() > 26 ? true : false;
        wrapper.accountId = accountId;
        
        return wrapper;
    }
    
    @AuraEnabled
    public static Map<String,Boolean> getReportButtonDisplay(String receptionId){
        List<Reception__c> receptionList = [SELECT Account__c FROM Reception__c WHERE Id =: receptionId];
        String accountId = receptionList.size() > 0 ? receptionList.get(0).Account__c:'';
        return ContractCount.getContractCount(accountId);
    }
    
    @AuraEnabled //get Picklist Values
    public static Map<String, String> getSinglePicklist(String objectName,String fieldName){
        Map<String, String> options = ReceptionController.getSinglePicklist(objectName,fieldName);
        return options;
    }
    
    //Dependent Picklist
    @AuraEnabled 
    public static Map<String, List<String>> getDependentMap(String objDetail, string contrfieldApiName,string depfieldApiName) {
        Map<String, List<String>> objResults = dependentPicklistCtrl.getDependentMap(objDetail, contrfieldApiName,depfieldApiName);
        System.Debug('objResults::'+objResults);
        return objResults;
    }
    
    //Dependent Picklist all based on API Names
    @AuraEnabled 
    public static Map<String,Map<String,String>> getDependentAPIMap(String objDetail, string contrfieldApiName,string depfieldApiName) {
        Map<String, Map<String,String>> objResults = dependentPicklistCtrl.getDependentAPIMap(objDetail, contrfieldApiName,depfieldApiName);
        System.Debug('objResults API::'+objResults);
        return objResults;
    }
       
    public class ContractTable{
        @AuraEnabled
        public String Id {get;set;}
        //注意
        @AuraEnabled
        public String note {get;set;}
        //ステータス
        @AuraEnabled
        public String status {get;set;}
        //証券番号・会員番号・契約管理番号
        @AuraEnabled
        public String policyNumber {get;set;}
        //契約者氏名
        @AuraEnabled
        public String contractorName {get;set;}
        //被保険者氏名
        @AuraEnabled
        public String insurerName {get;set;}
        //保険種類
        @AuraEnabled
        public String insuranceType {get;set;}
        //保険期間
        @AuraEnabled
        public String insurancePeriod {get;set;}
        //契約成立日
        @AuraEnabled
        public String contractEstablishedDate {get;set;}
        //保険金・総付金額
        @AuraEnabled
        public String amount {get;set;}
        //月払保険料
        @AuraEnabled
        public String premium {get;set;}
        //保険の目的
        @AuraEnabled
        public String insurancePurpose {get;set;}
        //保険対象区分
        @AuraEnabled
        public String insuredDivision {get;set;}
        //車両ナンバー
        @AuraEnabled
        public String carNumber {get;set;}
    }
    
    public class ContractWrapper{
        
        @AuraEnabled
        public List<ContractTable> contractList = new List<ContractTable>();
        
        @AuraEnabled
        public Reception__c reception = new Reception__c();
        
        @AuraEnabled
        public Boolean contractCountAlertFlag {get;set;}
        
        @AuraEnabled
        Public String accountId {get;set;}
    }
    
    @AuraEnabled
    public static Map<String, String> getAreaInfo(String postalCode){
        // 郵便番号APIを呼出
        Map<String, String> areaInfoMap = ZipUtil.getAreaInfo(postalCode);
        System.Debug('areaInfoMap::'+areaInfoMap );
        return areaInfoMap;
    }
    
    @AuraEnabled
    public static List <String> getMultiPiklistValues(String objectName,String fieldName) {
        List<String> plValues = new List<String>();
        System.Debug('objectName::'+objectName);
        System.Debug('fieldName::'+fieldName);
        
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
    
    //** Create Case **//
    @AuraEnabled
    public static void createCase(List<Id> contractIds, Id requestId) {
        
        List<Id> requestIdSet = new List<Id>();
        requestIdSet.add(requestId);
        
        //処理対象となるケースの親のRequestを取得
        Map<Id, Request__c> parentRequestMap = new Map<Id, Request__c>([
            Select id
                  ,Status__c
                  ,Class__c
                  ,Type__c
                  ,Subject__c
                  ,Reception__c
                  ,Account__c
                  ,Reception__r.NameOffererKana__c
                  ,Reception__r.RelationshipWithContractor__c
                  ,Reception__r.Addressee__c
                  ,Reception__r.FullAddress__c
                  ,Reception__r.Description__c
        
                 // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
                  ,Reception__r.Origin__c
                 // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End
         
            From Request__c
            Where id in :requestIdSet]
        );
        
        List<case> caseInsertList = new List<case>();
        Id seimeiRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSeimei').getRecordTypeId();
        Id sonpoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSonpo').getRecordTypeId();
        Id sytonRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSyotan').getRecordTypeId();
        Id commonRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeCommon').getRecordTypeId();
        //Onyx
        Id seimeiDaisaRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSeimeiDaisa').getRecordTypeId();
        
        //@@@@@@ ↓↓↓ prease add this code to "RequestControler". ↓↓↓
        Id seimeiCallRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SeihoLead_Call').getRecordTypeId();
        //Id sonpoMdlRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Sonpo_Middle').getRecordTypeId();
        Id littleCallRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LittleLead_Call').getRecordTypeId();
        Id compareRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Seiho_Little_Compare').getRecordTypeId();
        Id ftfRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('FacetofaceGuidedLife').getRecordTypeId();
        //Id letterCollectRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('LetterCollection').getRecordTypeId();
        //@@@@@@ ↑↑↑ prease add this code to "RequestControler". ↑↑↑
        
        
        Boolean salesCaseFlag = false;
        String reqType = parentRequestMap.get(requestId).Type__c;
    //Onyx開始
        String reqClass = parentRequestMap.get(requestId).Class__c;
    //Onyx終了
    
        ID recordTypeId = NULL;
        
        //@@@@@@ ↓↓↓ prease add this code to "RequestControler". ↓↓↓
        if (reqType == '生命_コール資料請求') {
            recordTypeId = seimeiCallRecordTypeId; //レコードタイプ
            salesCaseFlag = true;
        }
        /*
        else 
        if (reqType == '損保_ミドル連携') {
            recordTypeId = sonpoMdlRecordTypeId;
            salesCaseFlag = true;
        }
        */
        else 
        if (reqType == '少短_コール資料請求') {
            recordTypeId = littleCallRecordTypeId;
            salesCaseFlag = true;
        }
        else 
        if (reqType == '生命・少短_比較チーム連携') {
            recordTypeId = compareRecordTypeId;
            salesCaseFlag = true;
        }
        else 
        if (reqType == '生命_対面誘導（生命営推本部）') {
            recordTypeId = ftfRecordTypeId;
            salesCaseFlag = true;
        }
        /*
        else 
        if (reqType == '信書回収') {
            recordTypeId = letterCollectRecordTypeId;
            salesCaseFlag = true;
        }
        */
        //@@@@@@ ↑↑↑ prease add this code to "RequestControler". ↑↑↑
        
        if(contractIds != null && !contractIds.isEmpty() ){
            for(id conId : contractIds){
                
                Case cs = new Case();
                cs.Priority = '中';
                cs.AccountId = parentRequestMap.get(requestId).Account__c;
                cs.Reception__c = parentRequestMap.get(requestId).Reception__c;
                cs.RequestReference__c = requestId;
                cs.Status = parentRequestMap.get(requestId).Status__c;
                
                // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
                cs.Origin = parentRequestMap.get(requestId).Reception__r.Origin__c;
                 // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End

                System.Debug('conId::'+conId);
                String sobjectType = conId.getSObjectType().getDescribe().getName();
                
                if(sobjectType == 'LifeContract__c'){
                    if (!salesCaseFlag && reqClass != '生命代サ専用ケース') {
                        cs.recordTypeId = seimeiRecordTypeId;
                    } else {
                        cs.recordTypeId = seimeiDaisaRecordTypeId;
                    }
                    cs.lifeContractReference__c = conId;
                } else if(sobjectType == 'LittleContract__c'){
                    if (!salesCaseFlag) cs.recordTypeId = sytonRecordTypeId;
                    cs.littleContractReference__c = conId;
                } else if(sobjectType == 'DamageContract__c'){
                    if (!salesCaseFlag) cs.recordTypeId = sonpoRecordTypeId;
                    cs.damageContractReference__c = conId;
                }
                
                caseInsertList.add(cs);
            }
        } else{
            
            //For Common
            Case cas = new Case();
            cas.Priority = '中';
            cas.AccountId = parentRequestMap.get(requestId).Account__c;
            cas.Reception__c = parentRequestMap.get(requestId).Reception__c;
            cas.RequestReference__c = requestId;
            cas.Status = parentRequestMap.get(requestId).Status__c;
        
            // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
            cas.Origin = parentRequestMap.get(requestId).Reception__r.Origin__c;
            // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End
        
            //Onyx開始
            if(reqClass=='生命代サ専用ケース') {cas.recordTypeId = seimeiDaisaRecordTypeId;}
            //Onyx終了
            else if (!salesCaseFlag) {cas.recordTypeId = commonRecordTypeId;}
                        
            caseInsertList.add(cas);
        }
        
        if(caseInsertList!= null && !caseInsertList.isEmpty()){
            for (Case cs : caseInsertList) {
                
                //@@@@@@ ↓↓↓ prease add this code to "RequestControler". ↓↓↓
                //セールス専用ケースの場合、ローンチ時点のケースを使い続けるため他項目も設定
                if(salesCaseFlag){
                    if(String.isBlank(cs.NameOfferer__c)) cs.NameOfferer__c = parentRequestMap.get(requestId).Reception__r.NameOffererKana__c; //申出者氏名
                    if(String.isBlank(cs.RelationshipWithContractor__c)) cs.RelationshipWithContractor__c = parentRequestMap.get(requestId).Reception__r.RelationshipWithContractor__c; //契約者との続柄
                    if(String.isBlank(cs.DestinationAddress__c)) cs.DestinationAddress__c = parentRequestMap.get(requestId).Reception__r.Addressee__c; //送付先宛名
                    if(String.isBlank(cs.DeliveryAddress__c)) cs.DeliveryAddress__c = parentRequestMap.get(requestId).Reception__r.FullAddress__c; //送付先住所
                    if(String.isBlank(cs.Description)) cs.Description = parentRequestMap.get(requestId).Reception__r.Description__c; //受付内容
                    if(String.isBlank(cs.Class__c)) cs.Class__c = parentRequestMap.get(requestId).Class__c; //対応区分
                    if(String.isBlank(cs.Type__c)) cs.Type__c = parentRequestMap.get(requestId).Type__c; //対応種別
                    if(String.isBlank(cs.CaseSubject__c)) cs.CaseSubject__c = parentRequestMap.get(requestId).Subject__c; //件名
                    if(String.isBlank(cs.Subject)) cs.Subject = parentRequestMap.get(requestId).Subject__c; //件名
                    if(String.isBlank(cs.RecordTypeId)) cs.RecordTypeId = recordTypeId; //レコードタイプ
                }
                //@@@@@@ ↑↑↑ prease add this code to "RequestControler". ↑↑↑
            }
System.Debug('caseInsertList : ' + caseInsertList);
            insert caseInsertList;
System.Debug('caseInsertList(After) : ' + caseInsertList);
        }
    }
    
    /** Look Up **/
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
        String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    //public static String doubleRegex = '[\u0000-\u007F]';
    @AuraEnabled
    public static boolean checkingOtherThanDoubleByte(String givenValue) {
        boolean isOtherThanDoubleByte = false;
        Pattern regexPattern = Pattern.compile(doubleRegex);
        if(givenValue != '' && givenValue !=null ) {
            Matcher regexMatcher = regexPattern.matcher(givenValue);
            if(regexMatcher.find() ) {
                isOtherThanDoubleByte = true;
            } else {
                isOtherThanDoubleByte = false;
            }
        }
        return isOtherThanDoubleByte;
    }
    
    @AuraEnabled
    public static boolean checkingOtherThanSingleByteNumber(String givenValue) {
        boolean isOtherThanSingleByte = false;
        Pattern regexPattern = Pattern.compile(doubleRegex);
        Pattern isnumbers = Pattern.Compile('^[0-9|A-Z|a-z|-]+$');
        
        if(givenValue != '' && givenValue !=null ) {     
            //Matcher numberMatch = isnumbers.matcher(givenValue);
            //if(numberMatch.Matches()){
            if(givenValue.isNumeric()){
                 Matcher regexMatcher = regexPattern.matcher(givenValue);
                if(!(regexMatcher.find() )) {
                    isOtherThanSingleByte = true;
                } else {
                    isOtherThanSingleByte = false;
                }
            } else{
                Matcher mat = isnumbers.matcher(givenValue);
                isOtherThanSingleByte = !(mat.find());
            }
        }
        return isOtherThanSingleByte;
    }
    
    @AuraEnabled
    public static boolean checkingOtherThanSingleByte(String givenValue) {
        boolean isOtherThanSingleByte = false;
        Pattern regexPattern = Pattern.compile(doubleRegex);
        
        if(givenValue != '' && givenValue !=null ) {
            Matcher regexMatcher = regexPattern.matcher(givenValue);
            if(!(regexMatcher.find() )) {
                isOtherThanSingleByte = true;
            } else {
                isOtherThanSingleByte = false;
            }
        }
        return isOtherThanSingleByte;
    }
    
    @AuraEnabled
    public static integer getPolicyNumberValidate(String givenValue,List<String> policyNumberList,integer nonRelatedContractCheck) {
        
        integer isNotAvailable = 0;
        Map<String,String> policyMap = new Map<String,String>();
        
        List<String> givenPolicyLst = new List<String>();
         System.debug('The Given Value is :'+givenValue);
        try{
             if(givenValue != '' && givenValue != null){
                if(givenValue.Contains('/')){
                    givenPolicyLst = givenValue.split('/');
                }else{
                    
                    givenPolicyLst.add(givenValue);
                }
                System.debug('givenPolicyLst:::'+givenPolicyLst);
                System.debug('policyNumberList:::'+policyNumberList);
                
                for(String givenPol : givenPolicyLst){
                   
                   Boolean isNotSingleByte = checkingOtherThanSingleByteNumber(givenPol);
                   if(isNotSingleByte){
                        isNotAvailable = 2;
                        throw createAuraHandledException('NoSingleByte','証券番号は半角英数字、「/」で入力してください');
                   }
                    if(givenPol.length() < 8 || givenPol.length() > 15 ){
                        isNotAvailable = 1;
                        throw createAuraHandledException('8DigitError', '証券番号の桁数に誤りがあります');
                    }
                }
                for(String pol : policyNumberList){
                    policyMap.put(pol,pol);
                }
                
                System.Debug('nonRelatedContractCheck::'+nonRelatedContractCheck );
                if(nonRelatedContractCheck == 0){
                    if(policyNumberList != null && !policyNumberList.isEmpty() && isNotAvailable ==0){
                        for(String givenPolicyStr : givenPolicyLst){
                            if(!policyMap.ContainsKey(givenPolicyStr)){
                                system.debug('givenPolicyStr::'+givenPolicyStr);
                                isNotAvailable = 3;
                                throw createAuraHandledException('PolicyNumberDoesntMatch','入力した証券番号に誤りがあります。契約一覧に存在する証券番号を入力してください');
                            }
                        }
                    }
                }
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return isNotAvailable;
    }
    
    
    private static AuraHandledException createAuraHandledException(String methodName,String Message){
        AuraHandledException e = new AuraHandledException(Message);
        e.setMessage(Message);
        system.debug(methodName + e);
        return e;
    }
    
    
    @AuraEnabled
    public static integer getPolicyNumberValidateRetention(String givenValue,List<String> policyNumberList,integer nonRelatedContractCheck) {
        
        integer isNotAvailable = 0;
        Map<String,String> policyMap = new Map<String,String>();
        
        List<String> givenPolicyLst = new List<String>();
        System.debug('The Given Value is :'+givenValue);
        try{
             if(givenValue != ''  && givenValue !=null){
                if(givenValue.Contains('-')){
                    givenPolicyLst = givenValue.split('-');
                }else{
                    
                    givenPolicyLst.add(givenValue);
                }
                System.debug('givenPolicyLst:::'+givenPolicyLst);
                System.debug('policyNumberList:::'+policyNumberList);
                
                for(String givenPol : givenPolicyLst){
                   Boolean isNotSingleByte = checkingOtherThanSingleByteNumber(givenPol);
                   if(isNotSingleByte){
                        isNotAvailable = 2;
                        throw createAuraHandledException('NoSingleByte','証券番号は半角英数字、「-」で入力してください');
                   }
                }
            }
         }
         catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
        return isNotAvailable;
    }
    
    
    public static List<String> addToInputPolicyNoList(String givenValue, List<String> policyNumberList) {
        
        if (String.IsNotEmpty(givenValue) && 
            policyNumberList != null) {
            
            List<String> givenPolicyLst = new List<String>();
            
            if(givenValue.contains('/')){
                givenPolicyLst = givenValue.split('/');
            }
            else if(givenValue.contains('-')){
                givenPolicyLst = givenValue.split('-');
            }
            else {
                givenPolicyLst.add(givenValue);
            }
            
            policyNumberList.addAll(givenPolicyLst);
        }
        
        return policyNumberList;
    }

    public static List<String> addToInputPolicyNoListSeiho(String givenValue, List<String> policyNumberList) {
        
        if (String.IsNotEmpty(givenValue) && 
            policyNumberList != null) {
            
            List<String> givenPolicyLst = new List<String>();
            
            if(givenValue.contains('/')){
                givenPolicyLst = givenValue.split('/');
            } else {
                givenPolicyLst.add(givenValue);
            }
            
            policyNumberList.addAll(givenPolicyLst);
        }
        
        return policyNumberList;
    }
    
    @AuraEnabled
    public static Boolean getPolicyNumberMatchValidate(List<String> inputPolicyNoList, List<String> selectPolicyNoList){
        
        Map<String,String> inputPolicyMap = new Map<String,String>();
        for(String pol : inputPolicyNoList){
            inputPolicyMap.put(pol,pol);
        }
        
        
        if(selectPolicyNoList != null && !selectPolicyNoList.isEmpty()){
            for(String selectPolicyStr : selectPolicyNoList){
                if(!inputPolicyMap.ContainsKey(selectPolicyStr)){
                    return false;
                    // NOTREACHED
                }
            }
        }
        
        return true;
    }
    
    
    @AuraEnabled
    public static boolean hasDoubleByteSpace(String givenValue) {
        
        if(givenValue != '' && givenValue !=null ) {
            givenValue = givenValue.trim();
            
            if (givenValue.indexOf('　') > 0) {
                return true;
            }
        }
        
        return false;
    }
    
    @AuraEnabled
    public static boolean checkingDoubleByteName(String givenValue) {
        boolean isNotDoubleByteName = false;
        Pattern regexPattern = Pattern.compile(doubleRegex);
        if(givenValue != '' && givenValue !=null ) {
            givenValue = givenValue.trim();
            System.Debug('givenValue:'+givenValue);
            Matcher regexMatcher = regexPattern.matcher(givenValue);
            if(regexMatcher.find() ) {
                isNotDoubleByteName = true;
            } else {
                isNotDoubleByteName = false;
            }
        }
        else{
            isNotDoubleByteName = false;
        }
        if (!isNotDoubleByteName) {
            return !hasDoubleByteSpace(givenValue);
        }
        
        return isNotDoubleByteName;
    }
    
    @AuraEnabled
    public static boolean isNumericValidate(String givenValue) {
    boolean isNotNumeric = false;
        if(givenValue != null && givenValue != '' && !givenValue.isNumeric()){
            isNotNumeric = true;
        }
        else{
            isNotNumeric = false;
        }
        return isNotNumeric;
    }
    
    @AuraEnabled
    public static Map<String,Boolean> getAccountContract(String receptionId){
        
        List<Reception__c> receptionList = [SELECT Account__c FROM Reception__c WHERE Id =: receptionId];
        String accountId = receptionList.size() > 0 ? receptionList.get(0).Account__c : '';
        return ContractCount.getContractCount(accountId);
    }
}