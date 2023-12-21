public with sharing class ExC_FormInquiryController {

    @AuraEnabled
    public static String publishPlatformEvent(String jsonData){
        try {
            String processid = ExC_LimitedAccessUtility.issueSiteProcessId();
            Map<String, Object> dataMap = (Map<String,Object>)JSON.deserializeUntyped(jsonData);
            ExC_FormInquiryEvent__e evt = new ExC_FormInquiryEvent__e();

            evt.SiteProcessId__c  = processid;
            evt.InsuranceCompany__c = (String)dataMap.get('CompanyName');
            evt.ContentsOfInquiry__c = (String)dataMap.get('ContentsOfInquiry');
            evt.InquiryType__c = (String)dataMap.get('InquiryType');
            
            evt.RelationshipWithContractor__c = (String)dataMap.get('RelationshipWithContractor');
            evt.FuriganaLast__c = (String)dataMap.get('FuriganaLast');
            evt.FuriganaFirst__c = (String)dataMap.get('FuriganaFirst');
            evt.LastName__c = (String)dataMap.get('LastName');
            evt.FirstName__c = (String)dataMap.get('FirstName');
            evt.DaytimePhoneNumber__c = (String)dataMap.get('DaytimePhoneNumber');
            evt.DaytimePhoneNumberRegistered__c = ((String)dataMap.get('DaytimePhoneNumberRegistered')=='On');

            evt.Birthday__c = Date.parse((String)dataMap.get('Birthday'));
            evt.Email__c = (String)dataMap.get('Email');

            /* 2023/05/15 ADD START 問合せフォーム改修対応 Y.Yamada */
            // 追加項目のマッピング
            evt.PolicyNumber__c = (String)dataMap.get('PolicyNumber');
            evt.ContractorLastName__c = (String)dataMap.get('ContractorLastName');
            evt.ContractorFirstName__c = (String)dataMap.get('ContractorFirstName');
            evt.ContractorLastNameKana__c = (String)dataMap.get('ContractorLastNameKana');
            evt.ContractorFirstNameKana__c = (String)dataMap.get('ContractorFirstNameKana');
            String contractorBirthdayText = (String)dataMap.get('ContractorBirthday');
            if (String.isNotBlank(contractorBirthdayText)) {
                evt.ContractorBirthday__c = Date.parse(contractorBirthdayText);
            }
            evt.ContractorRegisteredPhoneNumber__c = (String)dataMap.get('ContractorRegisteredPhoneNumber');
            evt.ContractorDaytimePhoneNumber__c = (String)dataMap.get('ContractorDaytimePhoneNumber');
            /* 2023/05/15 ADD END 問合せフォーム改修対応 Y.Yamada */

            Database.SaveResult res = EventBus.publish(evt);
            if (res.isSuccess()) {
                return processid;
            } else {
                // エラー処理
                String key = evt.InsuranceCompany__c;
                if (key.equals('楽天生命')) {
                    if (evt.InquiryType__c.equals('保険金・給付金のご請求')) {
                        key += '保険金';
                    } else {
                        key += '保全';
                    }
                }
                InsuranceCompanySet__mdt company = [
                    SELECT
                    ChatterGroupName__c
                    FROM InsuranceCompanySet__mdt
                    WHERE MasterLabel = :key
                ];
                String groupName = company.ChatterGroupName__c;
                
                CollaborationGroup grp = [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];

                String msgText = 'フォーム問合せ情報の登録に失敗しました。\n';
                msgText += 'フォーム問合せ情報・ID：なし\n';
                msgText += 'エラー箇所：フォーム問合せ情報作成\n\n';
                msgText += 'エラーメッセージ：' + res.getErrors()[0].getMessage()+'\n\n';
                
                ChatterNotificationUtility.Error(grp.Id, msgText);
                
                return null;
            }

        } catch (Exception e) {
            system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static String issueSiteProcessId(String jsonData){
        String processid = ExC_LimitedAccessUtility.issueSiteProcessId();
        return processid;
    }
    @AuraEnabled
    public static String checkProcess(String processId){
        system.debug('processId: '+ processId);
        String inquiryNo =  ExC_LimitedAccessUtility.getInquiryNoByProcessId(processId);
        return inquiryNo;
    }
}