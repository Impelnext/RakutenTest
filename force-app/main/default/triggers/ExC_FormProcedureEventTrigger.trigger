trigger ExC_FormProcedureEventTrigger on ExC_FormProcedureEvent__e (after insert) {

    ExC_FormProcedureEvent__e CurrentEvt = null;
    FormProcedureInformation__c CurrentPrc = null;

    try {
        for (ExC_FormProcedureEvent__e evt: trigger.new) {
            CurrentEvt = evt;
            // レコードタイプ取得
            RecordType recType = [
                SELECT Id
                FROM RecordType
                WHERE SobjectType = 'FormProcedureInformation__c' AND Name = :evt.ProcedureType__c
            ];
            FormProcedureInformation__c prc = new FormProcedureInformation__c();
            prc.RecordTypeId = recType.Id;

            // 契約者基本情報
            prc.InsuranceCompany__c = evt.InsuranceCompany__c;
            prc.ProcedureType__c = evt.ProcedureType__c;
            prc.FuriganaLastName__c = evt.FuriganaLastName__c;
            prc.FuriganaFirstName__c = evt.FuriganaFirstName__c;
            prc.LastName__c = evt.LastName__c;
            prc.FirstName__c = evt.FirstName__c;
            prc.PolicyNumber__c = evt.PolicyNumber__c;
            prc.Birthday__c = evt.Birthday__c;
            prc.Email__c = evt.Email__c;

            // 登録住所に送付、住所変更あり
            // prc.isSendRegisteredAddress__c = evt.isSendRegisteredAddress__c;
            prc.isModAddress__c = evt.isModAddress__c;

            // 住所指定
            prc.PostCode__c = evt.PostCode__c;
            prc.Prefectures__c = evt.Prefectures__c;
            prc.Address__c = evt.Address__c;
            prc.OtherAddress__c = evt.OtherAddress__c;
            prc.MoveDay__c = evt.MoveDay__c;
            
            // 登録電話番号変更
            prc.RegisteredPhoneNumber__c = evt.RegisteredPhoneNumber__c;
            prc.DaytimePhoneNumber__c = evt.DaytimePhoneNumber__c ;

            // 自宅電話変更
            prc.isModAddHomephone__c = evt.isModAddHomephone__c;
            prc.ModAddHomePhoneNum__c = evt.ModAddHomePhoneNum__c;

            // 携帯電話変更
            prc.isModAddMobilephone__c = evt.isModAddMobilephone__c;
            prc.ModAddMobilePhoneNum__c = evt.ModAddMobilePhoneNum__c;

            // 名前（姓）変更
            prc.isModLastName__c = evt.isModLastName__c;
            prc.ModFuriganaLastName__c = evt.ModFuriganaLastName__c;
            prc.ModLastName__c = evt.ModLastName__c;

            // メールアドレス変更
            prc.isModEmail__c = evt.isModEmail__c;
            prc.ModEmail__c = evt.ModEmail__c;

            // 解約理由
            prc.ReasonFee__c = evt.ReasonFee__c;
            prc.ReasonContents__c = evt.ReasonContents__c ;
            prc.ReasonOther__c = evt.ReasonOther__c ;
            prc.CancelProduct__c = evt.CancelProduct__c;
            //2023/10/02 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
            prc.Disadvantage1__c = evt.Disadvantage1__c;
            prc.Disadvantage2__c = evt.Disadvantage2__c;
            prc.Disadvantage3__c = evt.Disadvantage3__c;
            prc.Disadvantage4__c = evt.Disadvantage4__c;
            prc.Disadvantage5__c = evt.Disadvantage5__c;
            prc.Disadvantage6__c = evt.Disadvantage6__c;
            //2023/10/02 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
            // 変更、解約証券番号
            prc.ModPolicyNumber1__c = evt.ModPolicyNumber1__c;
            prc.ModPolicyNumber2__c = evt.ModPolicyNumber2__c;
            prc.ModPolicyNumber3__c = evt.ModPolicyNumber3__c;
            prc.ModPolicyNumber4__c = evt.ModPolicyNumber4__c;
            prc.ModPolicyNumber5__c = evt.ModPolicyNumber5__c;
            prc.ModPolicyNumber6__c = evt.ModPolicyNumber6__c;
            prc.ModPolicyNumber7__c = evt.ModPolicyNumber7__c;
            prc.ModPolicyNumber8__c = evt.ModPolicyNumber8__c;
            prc.ModPolicyNumber9__c = evt.ModPolicyNumber9__c;
            prc.ModPolicyNumber10__c = evt.ModPolicyNumber10__c;
            prc.ModPolicyNumber11__c = evt.ModPolicyNumber11__c;
            prc.ModPolicyNumber12__c = evt.ModPolicyNumber12__c;
            prc.ModPolicyNumber13__c = evt.ModPolicyNumber13__c;
            prc.ModPolicyNumber14__c = evt.ModPolicyNumber14__c;
            prc.ModPolicyNumber15__c = evt.ModPolicyNumber15__c;
            prc.ModPolicyNumber16__c = evt.ModPolicyNumber16__c;
            prc.ModPolicyNumber17__c = evt.ModPolicyNumber17__c;
            prc.ModPolicyNumber18__c = evt.ModPolicyNumber18__c;
            prc.ModPolicyNumber19__c = evt.ModPolicyNumber19__c;
            prc.ModPolicyNumber20__c = evt.ModPolicyNumber20__c;

            // 再発行証券番号
            // prc.ReissuePolicyNumber1__c = evt.ReissuePolicyNumber1__c;
            // prc.ReissuePolicyNumber2__c = evt.ReissuePolicyNumber2__c;
            // prc.ReissuePolicyNumber3__c = evt.ReissuePolicyNumber3__c;
            // prc.ReissuePolicyNumber4__c = evt.ReissuePolicyNumber4__c;
            // prc.ReissuePolicyNumber5__c = evt.ReissuePolicyNumber5__c;
            // prc.ReissuePolicyNumber6__c = evt.ReissuePolicyNumber6__c;
            // prc.ReissuePolicyNumber7__c = evt.ReissuePolicyNumber7__c;
            // prc.ReissuePolicyNumber8__c = evt.ReissuePolicyNumber8__c;
            // prc.ReissuePolicyNumber9__c = evt.ReissuePolicyNumber9__c;
            // prc.ReissuePolicyNumber10__c = evt.ReissuePolicyNumber10__c;
            // prc.ReissuePolicyNumber11__c = evt.ReissuePolicyNumber11__c;
            // prc.ReissuePolicyNumber12__c = evt.ReissuePolicyNumber12__c;
            // prc.ReissuePolicyNumber13__c = evt.ReissuePolicyNumber13__c;
            // prc.ReissuePolicyNumber14__c = evt.ReissuePolicyNumber14__c;
            // prc.ReissuePolicyNumber15__c = evt.ReissuePolicyNumber15__c;
            // prc.ReissuePolicyNumber16__c = evt.ReissuePolicyNumber16__c;
            // prc.ReissuePolicyNumber17__c = evt.ReissuePolicyNumber17__c;
            // prc.ReissuePolicyNumber18__c = evt.ReissuePolicyNumber18__c;
            // prc.ReissuePolicyNumber19__c = evt.ReissuePolicyNumber19__c;
            // prc.ReissuePolicyNumber20__c = evt.ReissuePolicyNumber20__c;

            // 再発行年度
            prc.ReissueYears__c = evt.ReissueYears__c;

            // お知らせ方法
            // prc.SendNotificationsMethod__c = evt.SendNotificationsMethod__c;
            
            // 支払方法変更
            prc.ModPaymentMethod__c = evt.ModPaymentMethod__c;
            // 支払口座
            // prc.ModPaymentBank__c = evt.ModPaymentBank__c;
            // prc.ModPaymentBranch__c = evt.ModPaymentBranch__c;
            // prc.ModPaymentDepositType__c = evt.ModPaymentDepositType__c;
            // prc.ModPaymentAccNum__c = evt.ModPaymentAccNum__c;
            // prc.ModPaymentPassbookSymbol__c = evt.ModPaymentPassbookSymbol__c;
            // prc.ModPaymentPassbookNum__c = evt.ModPaymentPassbookNum__c;
            // 支払クレジットカード
            // prc.ModPaymentCreditCardNum__c = evt.ModPaymentCreditCardNum__c;
            // prc.ModPaymentCreditCardExpirationDate__c = evt.ModPaymentCreditCardExpirationDate__c;
            // prc.ModPaymentCreditCardCVC__c = evt.ModPaymentCreditCardCVC__c;

            // クレジットカード払い契約あり
            prc.isExistsCreditCardPayment__c = evt.isExistsCreditCardPayment__c;
            // 保険料払戻口座
            prc.InsuranceFeeBank__c = evt.InsuranceFeeBank__c;
            prc.InsuranceFeeBranch__c = evt.InsuranceFeeBranch__c;
            prc.InsuranceFeeDepositType__c = evt.InsuranceFeeDepositType__c;
            prc.InsuranceFeeAccNum__c = evt.InsuranceFeeAccNum__c;
            prc.InsuranceFeePassbookSymbol__c = evt.InsuranceFeePassbookSymbol__c;
            prc.InsuranceFeePassbookNum__c = evt.InsuranceFeePassbookNum__c;

            // 解約払戻金あり
            prc.isExistsRefundProduct__c = evt.isExistsRefundProduct__c;
            // 解約払戻口座
            prc.CancelBank__c = evt.CancelBank__c;
            prc.CancelBranch__c = evt.CancelBranch__c;
            prc.CancelDepositType__c = evt.CancelDepositType__c;
            prc.CancelAccNum__c = evt.CancelAccNum__c;
            prc.CancelPassbookSymbol__c = evt.CancelPassbookSymbol__c;
            prc.CancelPassbookNum__c = evt.CancelPassbookNum__c;

            prc.Status__c = '未着手';
            insert prc;
            CurrentPrc = prc;

            // グループ判定
            String key = prc.InsuranceCompany__c;
            if (key.equals('楽天生命')) {
                key += '保全';
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
            String procLimit = '';
            if (prc.ProcedureType__c == 'ご契約の解約') {
                procLimit = '3日間、';
            } else {
                procLimit = '';
            }
            
            CollaborationGroup grp = [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];

            // 通知
            String msgText = 'お客様から新しいお手続きがあります。\n';
            msgText += 'オブジェクト：フォーム手続き情報\n';
            msgText += 'フォーム手続き情報・ID：' + prc.Id + '\n\n';
            
            ChatterNotificationUtility.Success(grp.Id, prc.Id, msgText);

            // メール
            EmailTemplate tmp = [SELECT Id, body FROM EmailTemplate WHERE DeveloperName = 'ProcedureCompleteEmailTemplate'];
            OrgWideEmailAddress fromAddr = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = :senderName];
            Messaging.SingleEmailMessage sMail = Messaging.renderStoredEmailTemplate(tmp.Id, null, prc.Id);
            sMail.setOrgWideEmailAddressId(fromAddr.Id);
            sMail.setSaveAsActivity(False);
            String body = sMail.getPlainTextBody().replace('{proc_limit}', procLimit);
            sMail.setPlainTextBody(body);
            if (prc.ModEmail__c == null || prc.ModEmail__c == '') {
                sMail.setToAddresses(new String[] {prc.Email__c});
            } else {
                sMail.setToAddresses(new String[] {prc.Email__c, prc.ModEmail__c});
            }
            Messaging.sendEmail(new Messaging.Email[] {sMail}, True);
        }

    } catch (Exception e) {
        System.debug(e.getMessage());
        if (currentEvt != null) {

            // エラー処理
            String key = currentEvt.InsuranceCompany__c;
            if (key.equals('楽天生命')) {
                key += '保全';
            }
            InsuranceCompanySet__mdt company = [
                SELECT
                ChatterGroupName__c
                FROM InsuranceCompanySet__mdt
                WHERE MasterLabel = :key
            ];
            String groupName = company.ChatterGroupName__c;
            
            CollaborationGroup grp = [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];

            String msgText = 'フォーム手続き情報の登録処理でエラーが発生しました。\n';
            if (currentPrc != null) {
                msgText += 'フォーム手続き情報・ID：' + currentPrc.Id + '\n';
            }
            msgText += 'エラー箇所：フォーム手続き情報作成・通知処理\n\n';
            msgText += 'エラーメッセージ：' + e.getMessage()+'\n\n';
            
            ChatterNotificationUtility.Error(grp.Id, msgText);
        }

    }

}