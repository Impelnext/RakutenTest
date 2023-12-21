public with sharing class ExC_FormProcedureController {

    @AuraEnabled
    public static Boolean publishPlatformEvent(String jsonData) {
        try {
            Map<String, Object> dataMap = (Map<String, Object>)JSON.deserializeUntyped(jsonData);
            ExC_FormProcedureEvent__e evt = new ExC_FormProcedureEvent__e();

            // 契約者基本情報
            evt.InsuranceCompany__c = getString(dataMap, 'ConfCompanyName');
            evt.ProcedureType__c = getString(dataMap, 'ProcedureType');
            evt.FuriganaLastName__c = getString(dataMap, 'ConfBasicInfoFuriganaLastName');
            evt.FuriganaFirstName__c = getString(dataMap, 'ConfBasicInfoFuriganaFirstName');
            evt.LastName__c = getString(dataMap, 'ConfBasicInfoKanjiLastName');
            evt.FirstName__c = getString(dataMap, 'ConfBasicInfoKanjiFirstName');
            evt.RegisteredPhoneNumber__c = getString(dataMap, 'RegisteredPhoneNumber');
            evt.DaytimePhoneNumber__c = getString(dataMap, 'DaytimePhoneNumber');
            evt.PolicyNumber__c = getString(dataMap, 'ConfBasicInfoPolicyNum');
            evt.Birthday__c = getDate(dataMap, 'ConfBasicInfoBirthday');
            evt.Email__c = getString(dataMap, 'ConfBasicInfoEmail');

            // 住所関連（登録住所に送付、住所変更あり）
            //evt.isSendRegisteredAddress__c = getBool(dataMap, 'isSendRegisteredAddress');
            evt.isModAddress__c = getBool(dataMap, 'isModAddress');
            // 住所指定
            evt.PostCode__c = getString(dataMap, 'PostCode');
            evt.Prefectures__c = getString(dataMap, 'Prefectures');
            evt.Address__c = getString(dataMap, 'Address');
            evt.OtherAddress__c = getString(dataMap, 'OtherAddress');
            evt.MoveDay__c = getDate(dataMap, 'MoveDay');

            // 電話番号変更
            evt.ModAddHomePhoneNum__c = getString(dataMap, 'ModAddHomePhoneNum');
            evt.ModAddMobilePhoneNum__c = getString(dataMap, 'ModAddMobilePhoneNum');
            if (getBool(dataMap, 'isModAddHomephone')) {
                if (String.isBlank(evt.ModAddHomePhoneNum__c)) {
                    evt.isModAddHomephone__c = false;
                } else {
                    evt.isModAddHomephone__c = true;
                }
                if (String.isBlank(evt.ModAddMobilePhoneNum__c)) {
                    evt.isModAddMobilephone__c = false;
                } else {
                    evt.isModAddMobilephone__c = true;
                }
            }
            
            // 名前（姓）
            evt.isModLastName__c = getBool(dataMap, 'isModLastName');
            evt.ModFuriganaLastName__c = getString(dataMap, 'ModFuriganaLastName');
            evt.ModLastName__c = getString(dataMap, 'ModLastName');

            // メールアドレス
            evt.isModEmail__c = getBool(dataMap, 'isModEmail');
            evt.ModEmail__c = getString(dataMap, 'ModEmail');

            // 解約理由
            //evt.ReasonOfCancel__c = getString(dataMap, 'CancelInsuranceReason1');
            //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
              evt.Disadvantage1__c = getString(dataMap, 'disadvantageOPT1');
              evt.Disadvantage2__c = getString(dataMap, 'disadvantageOPT2');
              evt.Disadvantage3__c = getString(dataMap, 'disadvantageOPT3');
              evt.Disadvantage4__c = getString(dataMap, 'disadvantageOPT4');
              evt.Disadvantage5__c = getString(dataMap, 'disadvantageOPT5');
              evt.Disadvantage6__c = getString(dataMap, 'disadvantageOPT6');
            //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
            // 解約・変更証券番号
            evt.ModPolicyNumber1__c = getString(dataMap, 'CancelInsurance1');
            evt.ModPolicyNumber2__c = getString(dataMap, 'CancelInsurance2');
            evt.ModPolicyNumber3__c = getString(dataMap, 'CancelInsurance3');
            evt.ModPolicyNumber4__c = getString(dataMap, 'CancelInsurance4');
            evt.ModPolicyNumber5__c = getString(dataMap, 'CancelInsurance5');
            evt.ModPolicyNumber6__c = getString(dataMap, 'CancelInsurance6');
            evt.ModPolicyNumber7__c = getString(dataMap, 'CancelInsurance7');
            evt.ModPolicyNumber8__c = getString(dataMap, 'CancelInsurance8');
            evt.ModPolicyNumber9__c = getString(dataMap, 'CancelInsurance9');
            evt.ModPolicyNumber10__c = getString(dataMap, 'CancelInsurance10');
            evt.ModPolicyNumber11__c = getString(dataMap, 'CancelInsurance11');
            evt.ModPolicyNumber12__c = getString(dataMap, 'CancelInsurance12');
            evt.ModPolicyNumber13__c = getString(dataMap, 'CancelInsurance13');
            evt.ModPolicyNumber14__c = getString(dataMap, 'CancelInsurance14');
            evt.ModPolicyNumber15__c = getString(dataMap, 'CancelInsurance15');
            evt.ModPolicyNumber16__c = getString(dataMap, 'CancelInsurance16');
            evt.ModPolicyNumber17__c = getString(dataMap, 'CancelInsurance17');
            evt.ModPolicyNumber18__c = getString(dataMap, 'CancelInsurance18');
            evt.ModPolicyNumber19__c = getString(dataMap, 'CancelInsurance19');
            evt.ModPolicyNumber20__c = getString(dataMap, 'CancelInsurance20');

            // 再発行証券番号
            //evt.ReissuePolicyNumber1__c = getString(dataMap, 'ConfReissuePolicyNum1');
            //evt.ReissuePolicyNumber2__c = getString(dataMap, 'ConfReissuePolicyNum2');
            //evt.ReissuePolicyNumber3__c = getString(dataMap, 'ConfReissuePolicyNum3');
            //evt.ReissuePolicyNumber4__c = getString(dataMap, 'ConfReissuePolicyNum4');
            //evt.ReissuePolicyNumber5__c = getString(dataMap, 'ConfReissuePolicyNum5');
            //evt.ReissuePolicyNumber6__c = getString(dataMap, 'ConfReissuePolicyNum6');
            //evt.ReissuePolicyNumber7__c = getString(dataMap, 'ConfReissuePolicyNum7');
            //evt.ReissuePolicyNumber8__c = getString(dataMap, 'ConfReissuePolicyNum8');
            //evt.ReissuePolicyNumber9__c = getString(dataMap, 'ConfReissuePolicyNum9');
            //evt.ReissuePolicyNumber10__c = getString(dataMap, 'ConfReissuePolicyNum10');
            //evt.ReissuePolicyNumber11__c = getString(dataMap, 'ConfReissuePolicyNum11');
            //evt.ReissuePolicyNumber12__c = getString(dataMap, 'ConfReissuePolicyNum12');
            //evt.ReissuePolicyNumber13__c = getString(dataMap, 'ConfReissuePolicyNum13');
            //evt.ReissuePolicyNumber14__c = getString(dataMap, 'ConfReissuePolicyNum14');
            //evt.ReissuePolicyNumber15__c = getString(dataMap, 'ConfReissuePolicyNum15');
            //evt.ReissuePolicyNumber16__c = getString(dataMap, 'ConfReissuePolicyNum16');
            //evt.ReissuePolicyNumber17__c = getString(dataMap, 'ConfReissuePolicyNum17');
            //evt.ReissuePolicyNumber18__c = getString(dataMap, 'ConfReissuePolicyNum18');
            //evt.ReissuePolicyNumber19__c = getString(dataMap, 'ConfReissuePolicyNum19');
            //evt.ReissuePolicyNumber20__c = getString(dataMap, 'ConfReissuePolicyNum20');

            // 再発行年度
            List<String> yearList = new List<String>();
            String yearStr;
            for (Integer i = 1; i <= 5; i++) {
                yearStr = getString(dataMap, 'InfoReissueYear' + String.valueOf(i));
                if (!String.isBlank(yearStr)) {
                    yearList.add(yearStr + '年度');
                }
            }
            if (yearList.size() > 0) {
                evt.ReissueYears__c = String.join(yearList, ';');
            } else {
                evt.ReissueYears__c = null;
            }

            // 解約　共済商品
            List<String> productList = new List<String>();
            String productStr;
            for (Integer i = 1; i <= 6; i++) {
                productStr = getString(dataMap, 'CancelProduct' + String.valueOf(i));
                if (!String.isBlank(productStr)) {
                    productList.add(productStr);
                }
            }
            if (productList.size() > 0) {
                evt.CancelProduct__c = String.join(productList, ';');
            } else {
                evt.CancelProduct__c = null;
            }

            // 解約の理由
            evt.ReasonFee__c = getString(dataMap, 'CancelReason1');
            evt.ReasonContents__c = getString(dataMap, 'CancelReason2');
            evt.ReasonOther__c = getString(dataMap, 'CancelReason3');

            // 支払方法変更
            evt.ModPaymentMethod__c = getString(dataMap, 'ModPaymentMethod');

            // 支払口座
            //evt.ModPaymentBank__c = getString(dataMap, 'ModPaymentBank');
            //evt.ModPaymentBranch__c = getString(dataMap, 'ModPaymentBranch');
            //evt.ModPaymentDepositType__c = getString(dataMap, 'ModPaymentDepositType');
            //evt.ModPaymentAccNum__c = getString(dataMap, 'ModPaymentAccNum');
            //evt.ModPaymentPassbookSymbol__c = getString(dataMap, 'ModPaymentPassbookSymbol');
            //evt.ModPaymentPassbookNum__c = getString(dataMap, 'ModPaymentPassbookNum');
            // 支払クレジットカード
            //evt.ModPaymentCreditCardNum__c = getString(dataMap, 'ModPaymentCreditCardNum');
            //evt.ModPaymentCreditCardExpirationDate__c = getString(dataMap, 'ModPaymentCreditCardExpirationDate');
            //evt.ModPaymentCreditCardCVC__c = getString(dataMap, 'ModPaymentCreditCardCVC');

            // お知らせ送付方法
            //evt.SendNotificationsMethod__c = getString(dataMap, 'ConfDeliveryStyle');
            
            // クレジットカード払い契約あり
            evt.isExistsCreditCardPayment__c = getBool(dataMap, 'ConfRefundCard');
            // 保険料払戻口座
            evt.InsuranceFeeBank__c = getString(dataMap, 'ConfRefundAccInfoBank');
            evt.InsuranceFeeBranch__c = getString(dataMap, 'ConfRefundAccInfoBranch');
            evt.InsuranceFeeDepositType__c = getString(dataMap, 'ConfRefundAccInfoDepoType');
            evt.InsuranceFeeAccNum__c = getString(dataMap, 'ConfRefundAccInfoAccNum');
            evt.InsuranceFeePassbookSymbol__c = getString(dataMap, 'ConfRefundAccInfoPassbookSymbol');
            evt.InsuranceFeePassbookNum__c = getString(dataMap, 'ConfRefundAccInfoPassbookNum');

            // 解約払戻金あり
            evt.isExistsRefundProduct__c = getBool(dataMap, 'ConfRefundProductNote');
            // 解約払戻口座
            evt.CancelBank__c = getString(dataMap, 'ConfRefundPtAccInfoBank');
            evt.CancelBranch__c = getString(dataMap, 'ConfRefundPtAccInfoBranch');
            evt.CancelDepositType__c = getString(dataMap, 'ConfRefundPtAccInfoDepoType');
            evt.CancelAccNum__c = getString(dataMap, 'ConfRefundPtAccInfoAccNum');
            evt.CancelPassbookSymbol__c = getString(dataMap, 'ConfRefundPtAccInfoPassbookSymbol');
            evt.CancelPassbookNum__c = getString(dataMap, 'ConfRefundPtAccInfoPassbookNum');

            Database.SaveResult res = EventBus.publish(evt);
            if (res.isSuccess()) {
                return true;
            } else {
                // エラー処理
                String key = evt.InsuranceCompany__c;
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

                String msgText = 'フォーム手続き情報の登録に失敗しました。\n';
                msgText += 'フォーム手続き情報・ID：なし\n';
                msgText += 'エラー箇所：フォーム手続き情報作成\n\n';
                msgText += 'エラーメッセージ：' + res.getErrors()[0].getMessage()+'\n\n';
             
                ChatterNotificationUtility.Error(grp.Id, msgText);
             
                return false;
            }

        } catch (Exception e) {
            system.debug(e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    // 内部関数

    private static String getString(Map<String,Object> dataMap, String dataKey) {
        return getString(dataMap, dataKey, null);
    }

    private static String getString(Map<String,Object> dataMap, String dataKey, String defaultValue) {
        if (dataMap.containsKey(dataKey)) {
            return (String)dataMap.get(dataKey);
        } else {
            return defaultValue;
        }
    }
    
    private static Date getDate(Map<String,Object> dataMap, String dataKey) {
        if (dataMap.containsKey(dataKey)) {
            String data = (String)dataMap.get(dataKey);
            if (data == null || data == '') {
                return null;
            }
            return Date.parse(data);
        } else {
            return null;
        }
    }
    
    private static Boolean getBool(Map<String,Object> dataMap, String dataKey) {
        if (dataMap.containsKey(dataKey)) {
            if (dataMap.get(dataKey) instanceof Boolean) {
                return (Boolean)dataMap.get(dataKey);
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
    
    private static Integer getInt(Map<String,Object> dataMap, String dataKey) {
        if (dataMap.containsKey(dataKey)) {
            String data = (String)dataMap.get(dataKey);
            if (data == null || data == '') {
                return null;
            }
            return Integer.valueOf(data);
        } else {
            return null;
        }
    }
    
}