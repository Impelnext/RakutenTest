public with sharing class ReceptionTriggerHandler {
    
    // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
    // public ID sonpoQueueID = [Select Queue.Id from QueueSObject 
    //                 WHERE Queue.Type ='Queue' AND Queue.Name = 'ミドルオフィス（損保）' Limit 1].Queue.Id;
    // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
    // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
    Map<Id, String> rpMap = new Map<Id, String>();
    // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End
    
    public void createCaseandReq(List<Reception__c> recpList, Map<Id, Reception__c> oldMap){
        
        List<Request__c> requestList = new List<Request__c>();
        List<Case> caseList = new List<Case>();
        for(Reception__c recp : recpList){
        // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
        rpMap.put(recp.Id,recp.Origin__c);
        // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End
        if((oldMap.get(recp.Id) == Null || 
                recp.LF_Inquiry__c <> oldMap.get(recp.Id).LF_Inquiry__c)
                && recp.LF_Inquiry__c){
               requestList.add(createLFInquiry(recp));
            }
            
            if((oldMap.get(recp.Id) == Null || 
                recp.LT_Inquiry__c <> oldMap.get(recp.Id).LT_Inquiry__c)
                && recp.LT_Inquiry__c){
                requestList.add(createLTInquiry(recp));
            }
            
            if((oldMap.get(recp.Id) == Null || 
                recp.DM_Inquiry__c <> oldMap.get(recp.Id).DM_Inquiry__c)
                && recp.DM_Inquiry__c){
                requestList.add(createDMInquiry(recp));
            }
        }
        
        if(requestList != null && !requestList.isEmpty()){
            
            // Create New Request Records
            insert requestList;
            
            for(Request__c req : requestList) {
                caseList.add(createCase(req));
            }
            
            // Create New Case Records
            if(caseList.size()>0){
                insert caseList;
            }
        }
    }
    
    
    private Request__c createLFInquiry(Reception__c Recp){
        Request__c reqRecord = new Request__c();
        reqRecord.Class__c = '生命専用ケース';
        reqRecord.Type__c = '問合せケース（生命）';
        reqRecord.Subject__c = '問合せケース（生命）';
        reqRecord.Status__c = 'CC完了';
        reqRecord.Priority__c = '中';
        reqRecord.TelAcceptCompnDate__c = System.now();
        reqRecord.NonRelatedContractCheck__c = true;
        reqRecord.Account__c = Recp.Account__c;
        reqRecord.Reception__c = Recp.Id;
        reqRecord.OverviewOfInquirySeimei__c = Recp.LF_InquiryName__c;
        if(reqRecord.ChangeAgencyRegistration__c == null){
            reqRecord.ChangeAgencyRegistration__c = '無';
        }
        if(reqRecord.AGRegistrationChange__c == null){
            reqRecord.AGRegistrationChange__c = '無';
        }
        if(reqRecord.JuniorSpecialContract__c == null){
            reqRecord.JuniorSpecialContract__c = '無';
        }
        if(reqRecord.RecruiterRegistration__c == null){
            reqRecord.RecruiterRegistration__c = '無';
        }
        return reqRecord;
    }
    
    
    private Request__c createLTInquiry(Reception__c Recp){
        Request__c reqRecord = new Request__c();
        reqRecord.Class__c = '少短専用ケース';
        reqRecord.Type__c = '問合せケース（少短）';
        reqRecord.Subject__c = '問合せケース（少短）';
        reqRecord.Status__c = 'CC完了';
        reqRecord.Priority__c = '中';
        reqRecord.TelAcceptCompnDate__c = System.now();
        reqRecord.NonRelatedContractCheck__c = true;
        reqRecord.Account__c = Recp.Account__c;
        reqRecord.Reception__c = Recp.Id;
        reqRecord.InquirySummaryShortTermInsurance__c = Recp.LT_InquiryName__c;
        if(reqRecord.ChangeAgencyRegistration__c == null){
            reqRecord.ChangeAgencyRegistration__c = '無';
        }
        if(reqRecord.AGRegistrationChange__c == null){
            reqRecord.AGRegistrationChange__c = '無';
        }
        if(reqRecord.JuniorSpecialContract__c == null){
            reqRecord.JuniorSpecialContract__c = '無';
        }
        if(reqRecord.RecruiterRegistration__c == null){
            reqRecord.RecruiterRegistration__c = '無';
        }
        return reqRecord;
    }
    
    private Request__c createDMInquiry(Reception__c Recp){
        Request__c reqRecord = new Request__c();
        reqRecord.Class__c = '損保専用ケース';
        reqRecord.Type__c = '問合せケース（損保）';
        reqRecord.Subject__c = '問合せケース（損保）';
        reqRecord.Status__c = 'CC完了';
        reqRecord.Priority__c = '中';
        reqRecord.TelAcceptCompnDate__c = System.now();
        reqRecord.NonRelatedContractCheck__c = true;
        reqRecord.Account__c = Recp.Account__c;
        reqRecord.Reception__c = Recp.Id;
        reqRecord.OverviewOfInquirySompo__c = Recp.DM_InquiryName__c;
        if(reqRecord.ChangeAgencyRegistration__c == null){
            reqRecord.ChangeAgencyRegistration__c = '無';
        }
        if(reqRecord.AGRegistrationChange__c == null){
            reqRecord.AGRegistrationChange__c = '無';
        }
        if(reqRecord.JuniorSpecialContract__c == null){
            reqRecord.JuniorSpecialContract__c = '無';
        }
        if(reqRecord.RecruiterRegistration__c == null){
            reqRecord.RecruiterRegistration__c = '無';
        }
        return reqRecord;
    }
    
    
    public Case createCase(Request__c req){
        Id commonRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeCommon').getRecordTypeId();
        
        Case caseRecord = new Case();
        caseRecord.recordTypeId = commonRecordTypeId;
        caseRecord.AccountId = req.Account__c;
        caseRecord.Reception__c = req.Reception__c;
        caseRecord.RequestReference__c = req.Id;
        caseRecord.Priority = '中';
        caseRecord.Status = 'クローズ';
        caseRecord.Subject = req.Subject__c;
        // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　Start
        caseRecord.Origin = rpMap.get(caseRecord.Reception__c);
        // Add 2023/01/04 RIPCRM-765_次世代PTの問合せフォームに関連する改修（問合せ概要、ケース一覧） By 範　End
        
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　Start
        // if(req.Class__c == '損保専用ケース' && 
        //     req.Type__c == '問合せケース（損保）'){
        //     caseRecord.OwnerId = sonpoQueueID;
        // }
        // Delete 2022/10/18 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 邵　End
        return caseRecord;
    }
    
    
    public void receptionSetAddress(List<Reception__c> recpList,Map<Id,Reception__c> oldMap){
        
        List<Id> recpAccIds = new List<String>();
        for(Reception__c recp : recpList){
            if(recp.AdderssInputMethod__c == '取引先から引用'){
                recpAccIds.add(recp.Account__c);
            }
        }
        
        Map<Id,Account> mapRecpAcc = new Map<Id,Account>(
                            [select Id,PersonMailingStreet,PersonMailingCity,
                                PersonMailingState,Name,PersonMailingPostalCode 
                                from Account where id=: recpAccIds]);
        
        for(Reception__c recp : recpList){
            if(recp.AdderssInputMethod__c == '取引先から引用'){
                if(recp.Account__c != NULL && 
                    mapRecpAcc.containsKey(recp.Account__c)){
                    Account recpWithAccount = mapRecpAcc.get(recp.Account__c);
                    recp.Addressee__c = recpWithAccount.Name;
                    recp.MailingPostalCode__c = recpWithAccount.PersonMailingPostalCode;
                    recp.MailingState__c = recpWithAccount.PersonMailingState;
                    recp.MailingCity__c = recpWithAccount.PersonMailingCity;
                    recp.Address1__c = recpWithAccount.PersonMailingStreet;
                } 
            }
        }
        
    }

    //ロングテキストエリア項目の値をテキスト項目にコピー
    public void setLongTextToText(List<Reception__c> recpList){
        //全レコード処理
        for(Reception__c recp : recpList){
            //受付内容が256文字以上の場合
            if(String.isNotBlank(recp.Description__c) && recp.Description__c.length() > 255){
                //受付内容が256文字以上の場合は256文字以降の文字を切り捨てて255文字までの同項目にセット
                recp.Description255__c = recp.Description__c.substring(0, 255);
            }else{
                //受付内容がNull若しくは255文字以下の場合はそのままセット
                recp.Description255__c = recp.Description__c;
            }
        }
    }
    
    //Onyx-生保代理店マスタの紐づけ
        
    public void receptionSetMasterRecord(List<Reception__c> recpList,Map<Id,Reception__c> oldMap,Map<Id,Reception__c> newMap){
        
        Map<id,SeihoRecruiterMaster__c> RecruiterMap =new Map<id,SeihoRecruiterMaster__c>();
        Set<Id> RecruiterIds = new Set<Id>();
        for(Reception__c rec : recpList){    
            if(rec.SeihoRecruiter__c!=null)
                RecruiterIds.add(rec.SeihoRecruiter__c);
        }
        System.debug('RecruiterIds' + RecruiterIds);
        if(!RecruiterIds.isEmpty())
            RecruiterMap = MasterHelper.getRecruiterMap(RecruiterIds);
      
        for (Reception__c recp : recpList){        
            if(oldMap == NULL || oldMap.isEmpty()){
                if (recp.SeihoRecruiter__c != NULL && recp.SeihoAgency__c == Null && !RecruiterMap.isEmpty()) {
                    System.debug('RecruiterMap.get(SeihoRecruiter__c)'+RecruiterMap.get(recp.SeihoRecruiter__c));
                    recp.SeihoAgency__c = recp.SeihoRecruiter__c==RecruiterMap.get(recp.SeihoRecruiter__c).Id ? RecruiterMap.get(recp.SeihoRecruiter__c).SeihoAgencyMasterName__r.Id : null;
                }
            }else if(oldMap!=NULL || !oldMap.isEmpty()){
                if (recp.SeihoRecruiter__c != NULL && recp.SeihoRecruiter__c  != oldmap.get(recp.Id).SeihoRecruiter__c && !RecruiterMap.isEmpty()) {
                    System.debug('RecruiterMap.get(SeihoRecruiter__c)'+RecruiterMap.get(recp.SeihoRecruiter__c));
                    recp.SeihoAgency__c = recp.SeihoRecruiter__c==RecruiterMap.get(recp.SeihoRecruiter__c).Id ? RecruiterMap.get(recp.SeihoRecruiter__c).SeihoAgencyMasterName__r.Id : null;

                }
            }
        }   
    }
}