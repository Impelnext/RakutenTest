trigger ExC_FormInquiryEventTrigger on ExC_FormInquiryEvent__e (after insert) {

    ExC_FormInquiryEvent__e currentEvt = null;
    FormInquiryInformation__c currentInq = null;
    
    try {

        for (ExC_FormInquiryEvent__e evt: Trigger.new) {
            currentEvt = evt;
            FormInquiryInformation__c inq = new FormInquiryInformation__c();
            
            inq.SiteProcessId__c = evt.SiteProcessId__c ;
            inq.InsuranceCompany__c = evt.InsuranceCompany__c;
            inq.ContentsOfInquiry__c = evt.ContentsOfInquiry__c;
            inq.InquiryType__c = evt.InquiryType__c;
            inq.RelationshipWithContractor__c = evt.RelationshipWithContractor__c;
            inq.FuriganaLast__c = evt.FuriganaLast__c;
            inq.FuriganaFirst__c = evt.FuriganaFirst__c;
            inq.LastName__c = evt.LastName__c;
            inq.FirstName__c = evt.FirstName__c;
            inq.DaytimePhoneNumber__c = evt.DaytimePhoneNumber__c;
            inq.DaytimePhoneNumberRegistered__c = evt.DaytimePhoneNumberRegistered__c;
            
            inq.Birthday__c = evt.Birthday__c;
            inq.Email__c = evt.Email__c;
            inq.Status__c = '未着手';

            /* 2023/05/15 ADD START 問合せフォーム改修対応 Y.Yamada */
            // 追加項目のマッピング
            inq.PolicyNumber__c = evt.PolicyNumber__c;
            inq.ContractorLastName__c = evt.ContractorLastName__c;
            inq.ContractorFirstName__c = evt.ContractorFirstName__c;
            inq.ContractorLastNameKana__c = evt.ContractorLastNameKana__c;
            inq.ContractorFirstNameKana__c = evt.ContractorFirstNameKana__c;
            inq.ContractorBirthday__c = evt.ContractorBirthday__c;
            inq.ContractorRegisteredPhoneNumber__c = evt.ContractorRegisteredPhoneNumber__c;
            inq.ContractorDaytimePhoneNumber__c = evt.ContractorDaytimePhoneNumber__c;
            /* 2023/05/15 ADD END 問合せフォーム改修対応 Y.Yamada */

            insert inq;
            currentInq = inq;

            // グループ判定
            String key = inq.InsuranceCompany__c;
            if (key.equals('楽天生命')) {
                if (inq.InquiryType__c.equals('保険金・給付金のご請求')) {
                    key += '保険金';
                } else {
                    key += '保全';
                }
            }
        	InsuranceCompanySet__mdt company = [
                SELECT
                ChatterGroupName__c,
                EmailSenderName__c,
                ChatbotUrl__c
                FROM InsuranceCompanySet__mdt
            	WHERE MasterLabel = :key
            ];
            
            String groupName = company.ChatterGroupName__c;
            String senderName = company.EmailSenderName__c;
            String chatUrl = company.ChatbotUrl__c;
            
            // 通知
			String msgText = 'お客様から新しいお問合せがあります。\n';
            msgText += 'オブジェクト：フォーム問合せ情報\n';
            msgText += 'フォーム問合せ情報・ID：' + inq.Id + '\n\n';
            
            if (!Test.isRunningTest()) {
                CollaborationGroup grp = [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];
                ChatterNotificationUtility.Success(grp.Id, inq.Id, msgText);
            }

            // メール
            EmailTemplate tmp = [SELECT Id, body FROM EmailTemplate WHERE DeveloperName = 'InquiryCompleteEmailTemplate'];
            OrgWideEmailAddress fromAddr = [SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName = :senderName];
            Messaging.SingleEmailMessage sMail = Messaging.renderStoredEmailTemplate(tmp.Id, null, inq.Id);
            sMail.setOrgWideEmailAddressId(fromAddr.Id);
            sMail.setSaveAsActivity(False);
            String body = sMail.getPlainTextBody().replace('{reply_mail_address}', fromAddr.Address);
            sMail.setPlainTextBody(body);
            sMail.setToAddresses(new String[] {inq.Email__c});
            Messaging.sendEmail(new Messaging.Email[] {sMail}, True);
            
            if (Test.isRunningTest()) {
                CollaborationGroup grp = [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];
                ChatterNotificationUtility.Success(grp.Id, inq.Id, msgText);
            }
        }

    } catch (Exception e) {
        System.debug(e.getMessage());
        if (currentEvt != null) {

            // エラー処理
            String key = currentEvt.InsuranceCompany__c;
            if (key.equals('楽天生命')) {
                if (currentEvt.InquiryType__c.equals('保険金・給付金のご請求')) {
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
            
            String msgText = 'フォーム問合せ情報の登録処理でエラーが発生しました。\n';
            if (currentInq != null) {
                msgText += 'フォーム問合せ情報・ID：' + currentInq.Id + '\n';
            }
            msgText += 'エラー箇所：フォーム問合せ情報作成・通知処理\n\n';
            msgText += 'エラーメッセージ：' + e.getMessage()+'\n\n';
            
            if (!Test.isRunningTest()) {
                CollaborationGroup grp = [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];
                ChatterNotificationUtility.Error(grp.Id, msgText);
            }
            
        }

    }

}