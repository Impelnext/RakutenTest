/*
* @Class Name      : CaseTriggerHandler 
* @Description     : ケーストリガーハンドラ
* @Created Date    : 2019.04.18
* @Created By      : 
* @Modified Version: Life Migration Project
* @Modified Date   : 2020.05.08
* @Modified By     : Valsala Kumar J
*/
public class CaseTriggerHandler {

    /**
     * コンストラクタ
     */
    public CaseTriggerHandler() {}
    
    /**
     * ケース作成後処理
     * @param List<Case>
     * @return 
     */
    public void onAfterInsertProcess(List<Case> caseList){
        //資料発送機能は6/3リリース対象外↓↓↓↓↓
        //// 生保資料発送依頼の作成用リスト
        //List<SeihoDocumentShipping__c> seihoDocShippingList = new List<SeihoDocumentShipping__c>();
        //// ケース（資料請求（生命））のレコードタイプID
        //Id caseSeihoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('MaterialRequestLife').getRecordTypeId();
        //// 作成したケース分繰り返し
        //for(Case targetCase : caseList){
        //    // ケースのレコードタイプが「資料請求（生命）」の場合
        //    if(targetCase.RecordTypeId == caseSeihoRecordTypeId){
        //        // 生保資料発送依頼の新規作成
        //      SeihoDocumentShipping__c seihoDoc = new SeihoDocumentShipping__c();
        //      // ケースIDを設定
        //      seihoDoc.ParentCaseId__c = targetCase.Id;
        //      seihoDoc.NoDM__c = targetCase.DMNotApplicableFlag__c;
        //      // 作成用リストに追加
        //      seihoDocShippingList.add(seihoDoc);
        //    }
        //}
        //// 生保資料発送依頼のInsert
        //insert seihoDocShippingList;
        //資料発送機能は6/3リリース対象外↑↑↑↑↑
    }
    
    
    /**
     * レコードタイプ設定
     * 紐づく契約が変更された場合、ケースのレコードタイプを変更する
     * 契約紐づき無→契約紐づけのみOK（トリガーで対応）
     * 元々契約に紐づくケースを別のケースに紐づけることはNG（入力規則で対応）
     * @param List<Case>, Map<Id, Case>
     * @return
     */
    public void updateCaseRecordType(List<Case> newList, Map<Id, Case> oldMap) {
        
        Id seimeiRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSeimei').getRecordTypeId();
        Id sytonRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSyotan').getRecordTypeId();
        Id sonpoRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('RecordTypeSonpo').getRecordTypeId();
        
        for(Case cs : newList){
            if (String.IsNotBlank(cs.lifeContractReference__c) && 
                (oldMap.IsEmpty() || 
                 String.IsBlank(oldMap.get(cs.Id).lifeContractReference__c))) {
                cs.recordTypeId = seimeiRecordTypeId;
            }
            else 
            if (String.IsNotBlank(cs.littleContractReference__c) && 
                (oldMap.IsEmpty() || 
                 String.IsBlank(oldMap.get(cs.Id).littleContractReference__c))) {
                cs.recordTypeId = sytonRecordTypeId;
            }
            else 
            if (String.IsNotBlank(cs.damageContractReference__c) && 
                (oldMap.IsEmpty() || 
                 String.IsBlank(oldMap.get(cs.Id).damageContractReference__c))) {
                cs.recordTypeId = sonpoRecordTypeId;
            }
        }
    }
    
    
    /**
     * レコードタイプ設定
     * @param List<Case>
     * @return
     */
    /***************************************************
    ***************** NOT USED *************************
    ****************************************************
    public void setCaseRecordType(List<Case> newList){
        //CaseのRecordTypeを取得
        List<RecordType> recordTypeList = [
            Select
                 id
                ,DeveloperName
            From RecordType
            Where SobjectType = 'Case'
            And IsActive = TRUE
        ];
        
        //RecordTypeのMap作成
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        for(RecordType rt : recordTypeList){
            recordTypeMap.put(rt.DeveloperName, rt.id);
        }
        
        for(Case cs : newList){
            if(cs.class__c == '対応履歴' && cs.type__c == '対応履歴'){ cs.CaseSubject__c = '対応履歴'; cs.Subject = '対応履歴'; cs.recordtypeid = recordTypeMap.get('CorrespondenceHistory');}
            else if(cs.class__c == '共通異動' && cs.type__c == '住所変更'){ cs.CaseSubject__c = '住所変更'; cs.Subject = '住所変更'; cs.recordtypeid = recordTypeMap.get('changeOfAddress');}
            else if(cs.class__c == '共通異動' && cs.type__c == '電話番号変更'){ cs.CaseSubject__c = '電話番号変更'; cs.Subject = '電話番号変更'; cs.recordtypeid = recordTypeMap.get('ChangePhoneNumber');}
            else if(cs.class__c == '共通異動' && cs.type__c == '改姓（名義変更）'){ cs.CaseSubject__c = '改姓（名義変更）'; cs.Subject = '改姓（名義変更）'; cs.recordtypeid = recordTypeMap.get('Surname');}
            else if(cs.class__c == '共通異動' && cs.type__c == 'メールアドレス変更'){ cs.CaseSubject__c = 'メールアドレス変更'; cs.Subject = 'メールアドレス変更'; cs.recordtypeid = recordTypeMap.get('MailChange');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '保険金・給付金・共済金請求'){ cs.CaseSubject__c = '生命保険金・給付金・共済金請求'; cs.Subject = '生命保険金・給付金・共済金請求'; cs.recordtypeid = recordTypeMap.get('InsuranceClaims');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '受取人（生保）'){ cs.CaseSubject__c = '受取人変更'; cs.Subject = '受取人変更'; cs.recordtypeid = recordTypeMap.get('ChangeRecipient');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '受取人（共済）'){ cs.CaseSubject__c = '受取人（共済）'; cs.Subject = '受取人（共済）'; cs.recordtypeid = recordTypeMap.get('BeneficiaryChangeMutualBenefit');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '指定代理人変更'){ cs.CaseSubject__c = '指定代理人変更'; cs.Subject = '指定代理人変更'; cs.recordtypeid = recordTypeMap.get('ChangeDesignated');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '海外渡航'){ cs.CaseSubject__c = '海外渡航'; cs.Subject = '海外渡航'; cs.recordtypeid = recordTypeMap.get('OverseasTravel');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '証券再発行'){ cs.CaseSubject__c = '証券再発行'; cs.Subject = '証券再発行'; cs.recordtypeid = recordTypeMap.get('ReissueSecurities');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '控除再発行'){ cs.CaseSubject__c = '控除再発行'; cs.Subject = '控除再発行'; cs.recordtypeid = recordTypeMap.get('DeductionReissue');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == 'Retention'){ cs.CaseSubject__c = 'Retention'; cs.Subject = 'Retention'; cs.recordtypeid = recordTypeMap.get('Retention');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '解約'){ cs.CaseSubject__c = '解約'; cs.Subject = '解約'; cs.recordtypeid = recordTypeMap.get('AutomaticLifeInsurance');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '返金先口座'){ cs.CaseSubject__c = '返金先口座'; cs.Subject = '返金先口座'; cs.recordtypeid = recordTypeMap.get('RefundAccount');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == 'アルファ付替'){ cs.CaseSubject__c = 'アルファ付替'; cs.Subject = 'アルファ付替'; cs.recordtypeid = recordTypeMap.get('AlphaDistribution');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '更新拒否'){ cs.CaseSubject__c = '更新拒否'; cs.Subject = '更新拒否'; cs.recordtypeid = recordTypeMap.get('RecordType');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '特約解約'){ cs.CaseSubject__c = '特約解約'; cs.Subject = '特約解約'; cs.recordtypeid = recordTypeMap.get('SurrenderCancellation');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '特約減額'){ cs.CaseSubject__c = '特約減額'; cs.Subject = '特約減額'; cs.recordtypeid = recordTypeMap.get('SurrenderReduction');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '減額'){ cs.CaseSubject__c = '減額'; cs.Subject = '減額'; cs.recordtypeid = recordTypeMap.get('Reduction');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '更新時減額'){ cs.CaseSubject__c = '更新時減額'; cs.Subject = '更新時減額'; cs.recordtypeid = recordTypeMap.get('UpdateReduction');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '減口（生保）'){ cs.CaseSubject__c = '減口（生命）'; cs.Subject = '減口（生命）'; cs.recordtypeid = recordTypeMap.get('Reduc');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '減口（共済）'){ cs.CaseSubject__c = '減口（共済）'; cs.Subject = '減口（共済）'; cs.recordtypeid = recordTypeMap.get('ReducedMutualBenefit');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '更新時減口（共済）'){ cs.CaseSubject__c = '更新時減口（共済）'; cs.Subject = '更新時減口（共済）'; cs.recordtypeid = recordTypeMap.get('ReducedMutualBenefit');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '書類発送ケース'){ cs.CaseSubject__c = '書類発送ケース'; cs.Subject = '書類発送ケース'; cs.recordtypeid = recordTypeMap.get('DocumentShipping');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '対応履歴'){ cs.CaseSubject__c = '対応履歴'; cs.Subject = '対応履歴'; cs.recordtypeid = recordTypeMap.get('CorrespondenceHistory');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '対応依頼'){ cs.CaseSubject__c = '対応依頼'; cs.Subject = '対応依頼'; cs.recordtypeid = recordTypeMap.get('CorrespondenceRequest');}
            else if(cs.class__c == '生命専用ケース' && cs.type__c == '情報連携'){ cs.CaseSubject__c = '情報連携'; cs.Subject = '情報連携'; cs.recordtypeid = recordTypeMap.get('InformationCollaboration');}
            else if(cs.class__c == '損保専用ケース' && cs.type__c == '住所変更'){ cs.CaseSubject__c = '住所変更'; cs.Subject = '住所変更'; cs.recordtypeid = recordTypeMap.get('changeOfAddressSonpo');}
            else if(cs.class__c == '損保専用ケース' && cs.type__c == '車両入替'){ cs.CaseSubject__c = '車両入替'; cs.Subject = '車両入替'; cs.recordtypeid = recordTypeMap.get('VehicleChange');}
            else if(cs.class__c == '損保専用ケース' && cs.type__c == '解約（損保）'){ cs.recordtypeid = recordTypeMap.get('CancellationPolicy');}
            else if(cs.class__c == '損保専用ケース' && cs.type__c == '再発行'){ cs.recordtypeid = recordTypeMap.get('reissue');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '少短事故受付'){ cs.CaseSubject__c = '事故受付'; cs.Subject = '事故受付'; cs.recordtypeid = recordTypeMap.get('AccidentAcceptanceShortAndShort');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '少短事故受付(賠責）'){ cs.CaseSubject__c = '事故受付(賠責）'; cs.Subject = '事故受付(賠責）'; cs.recordtypeid = recordTypeMap.get('AccidentReceptionLiability');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '更新変更'){ cs.CaseSubject__c = '更新変更'; cs.Subject = '更新変更'; cs.recordtypeid = recordTypeMap.get('UpdateRelation');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '更新拒否'){ cs.CaseSubject__c = '更新拒否'; cs.Subject = '更新拒否'; cs.recordtypeid = recordTypeMap.get('LittleUpdateDenial');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '解約'){ cs.CaseSubject__c = '解約'; cs.Subject = '解約'; cs.recordtypeid = recordTypeMap.get('LittleCancellation');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == 'Retention'){ cs.CaseSubject__c = 'Retention'; cs.Subject = 'Retention'; cs.recordtypeid = recordTypeMap.get('RetentionShort');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '保険金関連（事故受付以外）'){ cs.CaseSubject__c = '保険金関連（事故受付以外）'; cs.Subject = '保険金関連（事故受付以外）'; cs.recordtypeid = recordTypeMap.get('InsuranceRelatedTherThanAccidentReception');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '振込用紙再送'){ cs.CaseSubject__c = '保険料（コンビニ）払込票再発行'; cs.Subject = '保険料（コンビニ）払込票再発行'; cs.recordtypeid = recordTypeMap.get('TransferFormResend');}
            else if(cs.class__c == '少短専用ケース' && cs.type__c == '証券類・更新案内再送'){ cs.recordtypeid = recordTypeMap.get('SecuritiesRenewalGuidanceResend');}
            else if(cs.class__c == '汎用ケース' && cs.type__c == '汎用（生命）'){ cs.recordtypeid = recordTypeMap.get('wideUse');}
            else if(cs.class__c == '汎用ケース' && cs.type__c == '汎用（損保）'){ cs.recordtypeid = recordTypeMap.get('wideUse');}
            else if(cs.class__c == '汎用ケース' && cs.type__c == '汎用（少短）'){ cs.recordtypeid = recordTypeMap.get('GeneralPurposeSlightlyShort');}
            else if(cs.class__c == '苦情・要望' && cs.type__c == '苦情・要望'){ cs.CaseSubject__c = '苦情・要望'; cs.Subject = '苦情・要望'; cs.recordtypeid = recordTypeMap.get('ComplaintsRequests');}
            else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '生命_コール資料請求'){ cs.CaseSubject__c = '生命_コール資料請求'; cs.Subject = '生命_コール資料請求'; cs.recordtypeid = recordTypeMap.get('SeihoLead_Call');}
            //else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '損保_ミドル連携'){ cs.CaseSubject__c = '損保_ミドル連携'; cs.Subject = '損保_ミドル連携'; cs.recordtypeid = recordTypeMap.get('Sonpo_Middle');}
            else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '少短_コール資料請求'){ cs.CaseSubject__c = '少短_コール資料請求'; cs.Subject = '少短_コール資料請求'; cs.recordtypeid = recordTypeMap.get('LittleLead_Call');}
            else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '生命・少短_比較チーム連携'){ cs.CaseSubject__c = '生命・少短_比較チーム連携'; cs.Subject = '生命・少短_比較チーム連携'; cs.recordtypeid = recordTypeMap.get('Seiho_Little_Compare');}
            else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '生命_対面誘導（生命営推本部）'){ cs.CaseSubject__c = '生命_対面誘導（生命営推本部）'; cs.Subject = '生命_対面誘導（生命営推本部）'; cs.recordtypeid = recordTypeMap.get('FacetofaceGuidedLife');}
            else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '生命_WEB資料請求'){ cs.CaseSubject__c = '生命_WEB資料請求'; cs.Subject = '生命_WEB資料請求'; cs.recordtypeid = recordTypeMap.get('SeihoLead_Web');}
            else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '少短_WEB資料請求'){ cs.CaseSubject__c = '少短_WEB資料請求'; cs.Subject = '少短_WEB資料請求'; cs.recordtypeid = recordTypeMap.get('LittleLead_Web');}
            //else if(cs.class__c == 'セールス専用ケース' && cs.type__c == '信書回収'){ cs.CaseSubject__c = '信書回収'; cs.Subject = '信書回収'; cs.recordtypeid = recordTypeMap.get('LetterCollection');}
        }
    }
    */
    
    /*public void setCaseOwner(List<Case> newCaseList, Map<Id, Case> oldCaseMap){
        //ケースのGroupIdを格納するSetを定義
        Set<Id> groupIdSet = new Set<Id>();
        for(QueueSobject qs : [SELECT Id, QueueId FROM QueueSobject WHERE SobjectType = 'Case']){
            groupIdSet.add(qs.QueueId);
        }
        //ケースのグループを格納するマップ key：Group.DeveloperName
        Map<String, Group> caseGroupMap = new Map<String, Group>();
        for(Group gr : [SELECT ID, name, DeveloperName FRom Group WHERE ID IN :groupIdSet]){
            caseGroupMap.put(gr.DeveloperName,gr);
        }
        
        //すべてのケースを繰り返し
        for(Case targetNewCase : newCaseList){
            Case oldCase = oldCaseMap.get(targetNewCase.Id);
            //契約に紐付いている状態で状況を「CC完了」に
            if((String.isNotBlank(targetNewCase.lifeContractReference__c) || String.isNotBlank(targetNewCase.damageContractReference__c)
                || String.isNotBlank(targetNewCase.littleContractReference__c)) && oldCase.Status != targetNewCase.Status && targetNewCase.Status == 'CC完了'
              && targetNewCase.OwnerId.getSobjectType().getDescribe().getName() != 'Group'){
                    if(targetNewCase.class__c == '生命専用ケース'){
                        if(targetNewCase.type__c == '解約'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '受取人（生保）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '指定代理人変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '証券再発行'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '減額'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '減口（生保）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '特約解約'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '更新時減額'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '更新時減口（共済）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '更新拒否'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '控除再発行'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '海外渡航'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == 'アルファ付替'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '減口（共済）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '受取人（共済）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '返金先口座'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == 'Retention'){ targetNewCase.ownerId = caseGroupMap.get('CcLife').Id;}
                        else if(targetNewCase.type__c == '特約減額'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                        else if(targetNewCase.type__c == '書類発送ケース'){ targetNewCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                        else if(targetNewCase.type__c == '対応履歴'){ targetNewCase.ownerId = caseGroupMap.get('CcLife').Id;}
                        else if(targetNewCase.type__c == '保険金・給付金・共済金請求'){ targetNewCase.ownerId = caseGroupMap.get('InsuranceLife').Id;}
                    }
                     else if(targetNewCase.class__c == '損保専用ケース'){
                        if(targetNewCase.type__c == '車両入替'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                        else if(targetNewCase.type__c == '再発行'){ 
                            if(targetNewCase.CaseSubject__c == '保険証券再発行'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '承認書再発行'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;} 
                            else if(targetNewCase.CaseSubject__c == '控除証明書再発行'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;} 
                            else if(targetNewCase.CaseSubject__c == 'サイクルアシスト証券発行'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;} 
                            else if(targetNewCase.CaseSubject__c == 'リビングアシスト契約証再発行'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;} 
                            else if(targetNewCase.CaseSubject__c == '中断証明発行'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;} 
                            else if(targetNewCase.CaseSubject__c == '中断証明再発行'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                        }
                         else if(targetNewCase.type__c == '解約（損保）'){ 
                            if(targetNewCase.CaseSubject__c == 'その他'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '自動車'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;}
                        }
                    }
                     else if(targetNewCase.class__c == '汎用ケース'){
                        if(targetNewCase.type__c == '汎用（少短)'){ 
                            if(targetNewCase.CaseSubject__c == '保険金関連（事故受付以外)'){ targetNewCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '保険料（コンビニ）払込票再発行'){ targetNewCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '保険料振替口座変更'){ targetNewCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == 'クレジットカード変更'){ targetNewCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '保険証券再発行'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '更新証再発行'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '更新案内再送'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '申込キャンセル変更'){ targetNewCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == 'AP資料未着再送'){ targetNewCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == 'ペット名の変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == 'その他'){ targetNewCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                            else if(targetNewCase.CaseSubject__c == '契約者・被保険者変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                        }
                        else if(targetNewCase.type__c == '汎用（生命）'){ 
                            if(targetNewCase.CaseSubject__c == '復活'){ targetNewCase.ownerId = caseGroupMap.get('ResurrectionLife').Id;} 
                            else if(targetNewCase.CaseSubject__c == '申込・新契約'){ targetNewCase.ownerId = caseGroupMap.get('NewContractValuationLife').Id;}
                        }
                        else if(targetNewCase.type__c == '汎用（損保）'){ 
                            if(targetNewCase.CaseSubject__c == '対象所在地変更（火災・満期戻）'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '用途車種変更（自動車）'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '保険金額変更'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '条件変更'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '全損失効'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '構造用法変更'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '職業職種（級別）の変更'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '面積の変更'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '権利譲渡（名義変更）'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '名義変更（保険の対象の所有者氏名変更）'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '保険期間延長・短縮'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '増車'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '被保険者数増減'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '質権設定・削除'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '等級訂正'){ targetNewCase.ownerId = caseGroupMap.get('BackOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == '被保険者変更'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                            else if(targetNewCase.CaseSubject__c == 'その他'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                        }
                    }
                    else if(targetNewCase.class__c == '少短専用ケース'){
                            if(targetNewCase.type__c == '少短事故受付'){ targetNewCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;} 
                            else if(targetNewCase.type__c == '少短事故受付(賠責）'){ targetNewCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;} 
                            else if(targetNewCase.type__c == '更新変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;} 
                            else if(targetNewCase.type__c == '更新拒否'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;} 
                            else if(targetNewCase.type__c == '解約'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;} 
                            else if(targetNewCase.type__c == '保険金関連（事故受付以外）'){ targetNewCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;} 
                            else if(targetNewCase.type__c == 'Retention'){ targetNewCase.ownerId = caseGroupMap.get('RetentionTShort').Id;}
                            else if(targetNewCase.type__c == '振込用紙再送'){ 
                                if(targetNewCase.CaseSubject__c == '保険料（コンビニ）払込票再発行'){targetNewCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;} 
                            }
                            else if(targetNewCase.type__c == '証券類・更新案内再送'){ 
                                if(targetNewCase.CaseSubject__c  == '保険証券再発行'){targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;} 
                                else if(targetNewCase.CaseSubject__c  == '更新証再発行'){targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                                else if(targetNewCase.CaseSubject__c  == '更新案内再送'){targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                            }
                    }
                     else if(targetNewCase.class__c == '共通異動'){ 
                            if(targetNewCase.lifeContractReference__c != null){  
                                if(targetNewCase.type__c == '住所変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}  
                                else if(targetNewCase.type__c == '改姓（名義変更）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}  
                                else if(targetNewCase.type__c == '電話番号変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}  
                                else if(targetNewCase.type__c == 'メールアドレス変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                            }
                             else if(targetNewCase.littleContractReference__c != null){  
                                if(targetNewCase.type__c == '住所変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}  
                                else if(targetNewCase.type__c == '改姓（名義変更）'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}  
                                else if(targetNewCase.type__c == '電話番号変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}  
                                else if(targetNewCase.type__c == 'メールアドレス変更'){ targetNewCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                            }
                         
                     }
            }
            //セールス専用ケースの割り当て
            else if(targetNewCase.class__c == 'セールス専用ケース' && oldCase.status != targetNewCase.status && targetNewCase.status == 'CC完了'){
                if(targetNewCase.type__c == '生命_コール資料請求'){ targetNewCase.ownerId = caseGroupMap.get('DNP').Id;}
                //else if(targetNewCase.type__c == '損保_ミドル連携'){ targetNewCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                else if(targetNewCase.type__c == '少短_コール資料請求'){ targetNewCase.ownerId = caseGroupMap.get('MatsuyamaLittle').Id;}
                else if(targetNewCase.type__c == '生命・少短_比較チーム連携'){ targetNewCase.ownerId = caseGroupMap.get('InsuranceComparingTeam').Id;}
                else if(targetNewCase.type__c == '生命_対面誘導（生命営推本部）'){ targetNewCase.ownerId = caseGroupMap.get('SalesLife').Id;}
                else if(targetNewCase.type__c == '生命_WEB資料請求'){ targetNewCase.ownerId = caseGroupMap.get('DNP').Id;}
                else if(targetNewCase.type__c == '少短_WEB資料請求'){ targetNewCase.ownerId = caseGroupMap.get('MatsuyamaLittle').Id;}
                //else if(targetNewCase.type__c == '信書回収'){ targetNewCase.ownerId = caseGroupMap.get('CallCenter').Id;}
            }
        }
    }*/
    
    /**
     * ケース作成後
     * @param List<Case>
     * @return
     */
    public void setAccountOpenCaseAfterInsert(List<Case> targetCaseList){
        Set<Id> conIdSet = new Set<Id>();
        for(Case targetCase : targetCaseList){
            if(targetCase.ContactId != null && targetCase.Status == 'オープン'){
                conIdSet.add(targetCase.ContactId);
            }
        }
        List<Account> updateTargetConList = [SELECT Id,openCase__pc FROM Account WHERE PersonContactId IN :conIdSet];
        for(Account acc : updateTargetConList){
            acc.openCase__pc = 'あり';
        }
        update updateTargetConList;
    }
    
    /**
     * ケース更新、削除後
     * @param List<Case>
     * @return
     */
    public void setAccountOpenCaseAfterUpdateDelete(List<Case> targetCaseList){
        Set<Id> conIdSet = new Set<Id>();
        for(Case targetCase : targetCaseList){
            if(targetCase.ContactId != null){
                conIdSet.add(targetCase.ContactId);
            }
        }
        Map<Id, String> checkMap = new Map<Id, String>();
        for (AggregateResult ar : [SELECT ContactId, status From Case WHERE status = 'オープン' AND ContactId IN :conIdSet Group By ContactId, status])  {
            checkMap.put((Id)ar.get('ContactId'),(String)ar.get('status'));
        }
        List<Account> updateTargetConList = [SELECT Id,openCase__pc,PersonContactId FROM Account WHERE PersonContactId IN :conIdSet];
        for(Account acc : updateTargetConList){
            if(checkMap.get(acc.PersonContactId) != null){
                acc.openCase__pc = 'あり';
            }else{
                acc.openCase__pc = 'なし';
            }
        }
        update updateTargetConList;
    }
    
    /**
     * NG代理店設定
     * @param List<Case>
     * @return
     */
    public void setNGAgency(List<Case> targetCaseList){
        List<Id> damageContractIdList = new List<Id>();
        
        for(Case c : targetCaseList){
            if(c.damageContractReference__c != null){
                damageContractIdList.add(c.damageContractReference__c);
            }
        }
        
        // 代理店コードがNG代理店にいる＋損保契約情報の幹事代理店がある場合、
        // 「NG代理店フラグ」をTRUEにする
        Map<Id, DamageContract__c> damageContractMap = new Map<Id, DamageContract__c>(
                [SELECT Id,AgencyCode__c, AgencyCode1__c 
                 FROM DamageContract__c
                 WHERE Id IN :damageContractIdList 
                       AND AgencyCode__c != NULL 
                       AND AgencyCode1__c != NULL]);
        
        // NG代理店取得
        Map<String, NgAgency__c> ngAgencyMap = this.searchNGAgencyMap(damageContractMap.values());
        
        // NG代理店の場合,「ケース．NG代理店有無フラグ」= true , それ以外false
        for(Case c: targetCaseList){
            
            // 「NG代理店フラグ」を初期値に戻る
            c.HasNGAgency__c = false;
            
            if(c.damageContractReference__c != null
               && damageContractMap.containsKey(c.damageContractReference__c)){
                
                DamageContract__c damageCon = damageContractMap.get(c.damageContractReference__c);
                if(ngAgencyMap.containsKey(damageCon.AgencyCode1__c)){
                    List<String> agencys = damageCon.AgencyCode__c.split(',');
                    for(String agency : agencys){
                        if(ngAgencyMap.containsKey(StringUtil.trim(agency))){
                            c.HasNGAgency__c = true;
                        }
                    }
                }
            }
        }
        
    }
    
    /**
     * NG代理店かつ状態が「CC完了」の場合、所有者を「お客様相談部(損保)」グループに設定
     * @param List<Case>
     * @return
     */
    /*
    public void setNGAgencyGroup(List<Case> newList){
        
        List<Case> ngAgencyCaseList = new List<Case>();
        
        for(Case c : newList){
            if(c.HasNGAgency__c == true
               && c.Status == 'CC完了'){
                ngAgencyCaseList.add(c);
            }
        }
        if(ngAgencyCaseList.size() > 0){
            // 「お客様相談部(損保)」グループ
            Group guestCounselingSonpo = this.searchGroupGuestCounselingSonpo();
            
            if(guestCounselingSonpo != null){
                for(Case c : ngAgencyCaseList){
                    c.OwnerId = guestCounselingSonpo.Id;
                }
            }
        }
    }
    */
    
    /**
     * NG代理店マップを取得する
     * @param List<DamageContract__c>
     * @return
     */
    private Map<String, NgAgency__c> searchNGAgencyMap(List<DamageContract__c> damageContractList){
        
        // 代理店情報取得
        Set<String> allAgencyList = new Set<String>();
        for(DamageContract__c damageContract : damageContractList){
            if(damageContract.AgencyCode__c != null){
                List<String> agencys = damageContract.AgencyCode__c.split(',');
                for(String agency : agencys){
                    allAgencyList.add(StringUtil.trim(agency));
                }
            }
            if(damageContract.AgencyCode1__c != null){
                allAgencyList.add(damageContract.AgencyCode1__c);
            }
        }
        
        // NG代理店取得
        return NgAgencyHelper.getNgAgencyMap(new List<String>(allAgencyList));
    }
    
    /**
     * 「お客様相談部(損保)」グループを取得する
     * @param Case
     * @return
     */
    private Group searchGroupGuestCounselingSonpo(){
        List<Group> gs = [SELECT Id
                          FROM Group
                          WHERE Type = 'Queue'
                          AND Name = 'お客様相談部（損保）'];
        if(gs.size() > 0){
            return gs[0];
        }else{
            return null;
        }
    }
    
    
    public void setCaseOwner(List<Case> newCaseList, Map<Id, Case> oldCaseMap){
        
        Set<Id> requestIdSet = new Set<Id>();
        Set<Id> requestAllIdSet = new Set<Id>();
        for(Case newCase : newCaseList){
            if ((oldCaseMap.IsEmpty() || 
                 oldCaseMap.get(newCase.Id).Status != newCase.Status) && 
                newCase.Status == 'CC完了') {
                
                if (newCase.RequestReference__c != NULL) {
                    requestIdSet.add(newCase.RequestReference__c);
                }
            }
            
            //Onyx開始
            if(oldCaseMap.IsEmpty() || oldCaseMap.get(newCase.Id).RequestReference__c != newCase.RequestReference__c){
            
                  if (newCase.RequestReference__c != NULL) {
                    requestAllIdSet.add(newCase.RequestReference__c);
                }
            }
            //Onyx終了
        }
        //Onyx開始
        if(!requestAllIdSet.isEmpty()){   
            Map<Id, Request__c> mapAllCaseRequest =new Map<Id, Request__c>([SELECT Id,SeihoRecruiter__r.KANJI_NAME__c,SeihoAgent__r.KANJI_AGENT_NAME__c
                                                        FROM Request__c 
                                                        WHERE Id IN :requestAllIdSet]);
            System.Debug('mapAllCaseRequest::'+mapAllCaseRequest); 
            
         for(Case newCase : newCaseList){
            
            //Adding values for SeihoAgentName__c,SeihoRecruiterName__c field in  case obj as it is hitting SFDC limt while creating it as formula field
            if(!mapAllCaseRequest.isEmpty()){
                    newCase.SeihoRecruiterName__c = mapAllCaseRequest.get(newCase.RequestReference__c).SeihoRecruiter__r.KANJI_NAME__c!=null?mapAllCaseRequest.get(newCase.RequestReference__c).SeihoRecruiter__r.KANJI_NAME__c:null;
                    newCase.SeihoAgentName__c=  mapAllCaseRequest.get(newCase.RequestReference__c).SeihoAgent__r.KANJI_AGENT_NAME__c!=null?mapAllCaseRequest.get(newCase.RequestReference__c).SeihoAgent__r.KANJI_AGENT_NAME__c :null;
                }
           
             }
         }
         //Onyx終了
        // No Case records to set OwnerId
        if (requestIdSet.IsEmpty()) {
                System.Debug('Entered null Request');
            return;
            // NOTREACHED
        }
        
        
        //ケースのGroupIdを格納するSetを定義
        Set<Id> groupIdSet = new Set<Id>();
        for(QueueSobject qs : [SELECT Id, QueueId FROM QueueSobject WHERE SobjectType = 'Case']){
            groupIdSet.add(qs.QueueId);
        }
        
        //ケースのグループを格納するマップ key：Group.DeveloperName
        Map<String, Group> caseGroupMap = new Map<String, Group>();
        for(Group gr : [SELECT ID, name, DeveloperName FRom Group WHERE ID IN :groupIdSet]){
            caseGroupMap.put(gr.DeveloperName,gr);
        }
        
        // Get Request Records Parent to Case Records
        Map<Id, Request__c> mapCaseRequest = new Map<Id, Request__c>(
                                                [SELECT Id, Class__c, Type__c, Subject__c,
                                                    SeihoRequestContents__c,RequestType__c,ReportGroup__c,
                                                    CreatedById 
                                                    FROM Request__c 
                                                    WHERE Id IN :requestIdSet]);
        System.Debug('mapCaseRequest::'+mapCaseRequest);
 
        
        // *** Change the OwnerId of Case Records in the BEFORE Action of Insert / Update of Case ***/
        for(Case newCase : newCaseList){
            if(newCase.HasNGAgency__c){
                
                // Default Owner for NGAgency
                newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;
                
                if (newCase.RequestReference__c != NULL && 
                    mapCaseRequest.containsKey(newCase.RequestReference__c)) {
                    
                    Request__c req = mapCaseRequest.get(newCase.RequestReference__c);
                    if(req.Class__c == '損保専用ケース'){
                        if(req.Type__c == '住所・対象所在地同時変更'  && req.Subject__c == '住所・対象所在地同時変更 CC完結'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '住所・対象所在地同時変更'  && req.Subject__c == '住所・対象所在地同時変更 MO連携'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '車両入替' && req.Subject__c == '車両入替_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '車両入替' && req.Subject__c == '車両入替_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '保険証券再発行'  && req.Subject__c == '保険証券再発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '保険証券再発行'  && req.Subject__c == '保険証券再発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '承認書再発行'  && req.Subject__c == '承認書再発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '承認書再発行'  && req.Subject__c == '承認書再発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '控除証明書再発行'  && req.Subject__c == '控除証明書再発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == 'サイクルアシスト証券発行'  && req.Subject__c == 'サイクルアシスト証券発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == 'サイクルアシスト証券発行'  && req.Subject__c == 'サイクルアシスト証券発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == 'リビングアシスト契約証再発行'  && req.Subject__c == 'リビングアシスト契約証再発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == 'リビングアシスト契約証再発行'  && req.Subject__c == 'リビングアシスト契約証再発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '中断証明発行'  && req.Subject__c == '中断証明発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '中断証明再発行'  && req.Subject__c == '中断証明再発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '解約（自動車）'  && req.Subject__c == '解約（自動車）_TEL受け'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '解約（自動車）'  && req.Subject__c == '解約（自動車）_書面または未定'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '解約（火災）'  && req.Subject__c == '解約（火災）_TEL受け'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '解約（火災）'  && req.Subject__c == '解約（火災）_書面または未定'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '解約（傷害）'  && req.Subject__c == '解約（傷害）_TEL受け'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '解約（傷害）'  && req.Subject__c == '解約（傷害）_書面または未定'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '解約（ジャンプ・積立・その他）'  && req.Subject__c == '解約（ジャンプ・積立・その他）'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '対象所在地変更（火災・満期戻）'  && req.Subject__c == '対象所在地変更（火災・満期戻）_CC完結'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '対象所在地変更（火災・満期戻）'  && req.Subject__c == '対象所在地変更（火災・満期戻）_MO連携'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '用途車種変更（自動車）'  && req.Subject__c == '用途車種変更（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '用途車種変更（自動車）'  && req.Subject__c == '用途車種変更（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '登録番号変更（自動車）'  && req.Subject__c == '登録番号変更（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '登録番号変更（自動車）'  && req.Subject__c == '登録番号変更（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '保険金額変更'  && req.Subject__c == '保険金額変更_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '保険金額変更'  && req.Subject__c == '保険金額変更_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '条件変更（自動車）'  && req.Subject__c == '条件変更（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '条件変更（自動車）'  && req.Subject__c == '条件変更（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '全損失効'  && req.Subject__c == '全損失効'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '構造用法面積変更'  && req.Subject__c == '構造用法面積変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '職業職種（級別）の変更'  && req.Subject__c == '職業職種（級別）の変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '権利譲渡（名義変更）'  && req.Subject__c == '権利譲渡（名義変更）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '名義変更（保険の対象の所有者氏名変更）'  && req.Subject__c == '名義変更（保険の対象の所有者氏名変更）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '増車'  && req.Subject__c == '増車'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '質権設定・削除'  && req.Subject__c == '質権設定・削除'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '等級訂正'  && req.Subject__c == '等級訂正'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '被保険者変更'  && req.Subject__c == '被保険者変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '付保証明書発行'  && req.Subject__c == '付保証明書発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '口座変更、クレカ変更'  && req.Subject__c == '口座変更、クレカ変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '入金確認'  && req.Subject__c == '入金確認'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '新規契約・継続契約・中途更改'  && req.Subject__c == '新規契約・継続契約・中途更改'){ newCase.ownerId = caseGroupMap.get('GuestCounselingSonpo').Id;}
                        else if(req.Type__c == '問合せケース（損保）'  && req.Subject__c == '問合せケース（損保）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                        else if(req.Type__c == '汎用（損保）'  && req.Subject__c == '汎用（損保）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    
                    
                    // Modify 2022/10/04 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 範　Start
                    }else if(req.Class__c == '共通ケース'){
                        if(req.Type__c == '住所変更' && req.Subject__c == '住所変更' ){newCase.ownerId = newCase.CreatedById;}
                        else if(req.Type__c == '改姓（名義変更）' && req.Subject__c == '改姓（名義変更）' ){newCase.ownerId = newCase.ownerId = newCase.CreatedById;}
                        else if(req.Type__c == '電話番号変更' && req.Subject__c == '電話番号変更' ){newCase.ownerId = newCase.ownerId = newCase.CreatedById;}
                        else if(req.Type__c == 'メールアドレス変更' && req.Subject__c == 'メールアドレス変更' ){newCase.ownerId = newCase.ownerId = newCase.CreatedById;}
                        else if(req.Type__c == '対応依頼' && req.Subject__c == '対応依頼'){newCase.ownerId = newCase.CreatedById;}
                        else if(req.Type__c == '情報連携' && req.Subject__c == '情報連携'){newCase.ownerId = newCase.CreatedById;}
                        else if(req.Type__c == '苦情・要望' && req.Subject__c == '苦情・要望' ){newCase.ownerId = newCase.CreatedById;}
                    }
                    // Modify 2022/10/04 RIPCRM-737_キューの名称変更・削除・追加とケース設定所有者の変更 By 範 End
                }
            }else if (newCase.RequestReference__c != NULL && 
                      mapCaseRequest.containsKey(newCase.RequestReference__c)) {
                
                Request__c req = mapCaseRequest.get(newCase.RequestReference__c);
                if(req.Class__c == '共通ケース'){
                    if(req.Type__c == '住所変更' && req.Subject__c == '住所変更' && newCase.lifeContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '住所変更' && req.Subject__c == '住所変更' && newCase.littleContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '住所変更' && req.Subject__c == '住所変更' && newCase.damageContractReference__c != null){/*NO CHANGE*/}
                    else if(req.Type__c == '改姓（名義変更）' && req.Subject__c == '改姓（名義変更）' && newCase.lifeContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '改姓（名義変更）' && req.Subject__c == '改姓（名義変更）' && newCase.littleContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '改姓（名義変更）' && req.Subject__c == '改姓（名義変更）' && newCase.damageContractReference__c != null){/*NO CHANGE*/}
                    else if(req.Type__c == '電話番号変更' && req.Subject__c == '電話番号変更' && newCase.lifeContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '電話番号変更' && req.Subject__c == '電話番号変更' && newCase.littleContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '電話番号変更' && req.Subject__c == '電話番号変更' && newCase.damageContractReference__c != null){/*NO CHANGE*/}
                    else if(req.Type__c == 'メールアドレス変更' && req.Subject__c == 'メールアドレス変更' && newCase.lifeContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == 'メールアドレス変更' && req.Subject__c == 'メールアドレス変更' && newCase.littleContractReference__c != null){newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == 'メールアドレス変更' && req.Subject__c == 'メールアドレス変更' && newCase.damageContractReference__c != null){/*NO CHANGE*/}
                    else if(req.Type__c == '対応依頼' && req.Subject__c == '対応依頼'){/*NO CHANGE*/}
                    else if(req.Type__c == '情報連携' && req.Subject__c == '情報連携'){/*NO CHANGE*/}
                    else if(req.Type__c == '苦情・要望' && req.Subject__c == '苦情・要望' && newCase.lifeContractReference__c != null){/*NO CHANGE*/}
                    else if(req.Type__c == '苦情・要望' && req.Subject__c == '苦情・要望' && newCase.littleContractReference__c != null){newCase.ownerId = caseGroupMap.get('VOCSyotan').Id;}
                    else if(req.Type__c == '苦情・要望' && req.Subject__c == '苦情・要望' && newCase.damageContractReference__c != null){/*NO CHANGE*/}
                }
                else if(req.Class__c == '生命専用ケース'){
                    if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_給付金請求'){ newCase.ownerId = caseGroupMap.get('InsuranceLife').Id;}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_保険金請求'){ newCase.ownerId = caseGroupMap.get('InsuranceLife').Id;}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_その他発送・対応依頼'){ newCase.ownerId = caseGroupMap.get('InsuranceLife').Id;}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_請求書類記入方法'){/*NO CHANGE*/}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_査定進捗確認'){/*NO CHANGE*/}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_不備内容問い合わせ'){/*NO CHANGE*/}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_支払・判例・例定事例'){/*NO CHANGE*/}
                    else if(req.Type__c == '保険金・給付金・共済金請求' && req.Subject__c == '請求_保険金・給付金その他'){/*NO CHANGE*/}
                    else if(req.Type__c == '解約' && req.Subject__c == '解約'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '解約' && req.Subject__c == '解約(条解)'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '受取人（生保）' && req.Subject__c == '受取人（生保）'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '指定代理人変更' && req.Subject__c == '指定代理人変更'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    //else if(req.Type__c == '証券再発行' && req.Subject__c == '証券再発行'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '保険証券・証書再発行' && req.Subject__c == '保険証券・証書再発行'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '減額' && req.Subject__c == '減額'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '減口（生保）' && req.Subject__c == '減口（生保）'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '特約解約' && req.Subject__c == '特約解約'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '更新時減額' && req.Subject__c == '更新時減額'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '更新時減口（共済）' && req.Subject__c == '更新時減口（共済）'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '更新拒否' && req.Subject__c == '更新拒否'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '控除再発行' && req.Subject__c == '控除再発行'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '海外渡航' && req.Subject__c == '海外渡航'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == 'アルファ付替' && req.Subject__c == 'アルファ付替'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '減口（共済）' && req.Subject__c == '減口（共済）'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '受取人（共済）' && req.Subject__c == '受取人（共済）'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '返金先口座' && req.Subject__c == '返金先口座'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == 'Retention' && req.Subject__c == 'Retention（生命）'){/*NO CHANGE*/}
                    else if(req.Type__c == '特約減額' && req.Subject__c == '特約減額'){ newCase.ownerId = caseGroupMap.get('MaintenanceLife').Id;}
                    else if(req.Type__c == '汎用（生命）' && req.Subject__c == '汎用（生命）'){/*NO CHANGE*/}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_住所・電話番号変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_解約'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_特約解約'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_名義変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_口座変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_クレカ変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_契約者変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_減額'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_特約減額'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_証券再発行'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_海外渡航'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_復活'){ newCase.ownerId = caseGroupMap.get('ResurrectionLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_種類変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_端数減口種類変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_指定代理人'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_受取人変更'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_控除再発行'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_更新拒否'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_アルファ付替'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_返金先口座'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_減口（生保）'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_減口（共済）'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_更新時減額'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_更新時減口（共済）'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_加入状況表・契約内容のお知らせ'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_パンフレット'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_約款'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_念書'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_掛金表'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_試算シート'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_証明書'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_手続き完了通知'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_更新（更新案内）'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_更新（更新完了通知）'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_満了通知'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_継続割引'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_不備レター・督促レター・返信用封筒・その他'){/*NO CHANGE*/}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_【生保】オーファン関連'){ newCase.ownerId = caseGroupMap.get('SalesPlanningLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_代理店・AG関連'){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_ジュニア関連'){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_新契約関連'){ newCase.ownerId = caseGroupMap.get('NewContractValuationLife').Id;}
                    else if(req.Type__c == '書類発送ケース' && req.Subject__c == '書類発送_無事故給付受取口座変更'){ newCase.ownerId = caseGroupMap.get('InsuranceLife').Id;}
                    else if(req.Type__c == '口座変更（無事故給付金）' && req.Subject__c == '口座変更（無事故給付金）'){ newCase.ownerId = caseGroupMap.get('InsuranceLife').Id;}
                    else if(req.Type__c == '問合せケース（生命）'){/*NO CHANGE*/}
                }
                else if(req.Class__c == '損保専用ケース'){
                    if(req.Type__c == '住所・対象所在地同時変更'  && req.Subject__c == '住所・対象所在地同時変更 CC完結'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '住所・対象所在地同時変更'  && req.Subject__c == '住所・対象所在地同時変更 MO連携'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '車両入替' && req.Subject__c == '車両入替_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '車両入替' && req.Subject__c == '車両入替_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '保険証券再発行'  && req.Subject__c == '保険証券再発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '保険証券再発行'  && req.Subject__c == '保険証券再発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '承認書再発行'  && req.Subject__c == '承認書再発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '承認書再発行'  && req.Subject__c == '承認書再発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '控除証明書再発行'  && req.Subject__c == '控除証明書再発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == 'サイクルアシスト証券発行'  && req.Subject__c == 'サイクルアシスト証券発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == 'サイクルアシスト証券発行'  && req.Subject__c == 'サイクルアシスト証券発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == 'リビングアシスト契約証再発行'  && req.Subject__c == 'リビングアシスト契約証再発行_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == 'リビングアシスト契約証再発行'  && req.Subject__c == 'リビングアシスト契約証再発行_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '中断証明発行'  && req.Subject__c == '中断証明発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '中断証明再発行'  && req.Subject__c == '中断証明再発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（自動車）'  && req.Subject__c == '解約（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（自動車）'  && req.Subject__c == '解約（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（火災）'  && req.Subject__c == '解約（火災）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（火災）'  && req.Subject__c == '解約（火災）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（傷害）'  && req.Subject__c == '解約（傷害）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（傷害）'  && req.Subject__c == '解約（傷害）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '解約（ジャンプ・積立・その他）'  && req.Subject__c == '解約（ジャンプ・積立・その他）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '対象所在地変更（火災・満期戻）'  && req.Subject__c == '対象所在地変更（火災・満期戻）_CC完結'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '対象所在地変更（火災・満期戻）'  && req.Subject__c == '対象所在地変更（火災・満期戻）_MO連携'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '用途車種変更（自動車）'  && req.Subject__c == '用途車種変更（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '用途車種変更（自動車）'  && req.Subject__c == '用途車種変更（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '登録番号変更（自動車）'  && req.Subject__c == '登録番号変更（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '登録番号変更（自動車）'  && req.Subject__c == '登録番号変更（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '保険金額変更'  && req.Subject__c == '保険金額変更_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '保険金額変更'  && req.Subject__c == '保険金額変更_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '条件変更（自動車）'  && req.Subject__c == '条件変更（自動車）_TEL受け'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '条件変更（自動車）'  && req.Subject__c == '条件変更（自動車）_書面または未定'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '全損失効'  && req.Subject__c == '全損失効'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '構造用法面積変更'  && req.Subject__c == '構造用法面積変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '職業職種（級別）の変更'  && req.Subject__c == '職業職種（級別）の変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '権利譲渡（名義変更）'  && req.Subject__c == '権利譲渡（名義変更）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '名義変更（保険の対象の所有者氏名変更）'  && req.Subject__c == '名義変更（保険の対象の所有者氏名変更）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '増車'  && req.Subject__c == '増車'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '質権設定・削除'  && req.Subject__c == '質権設定・削除'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '等級訂正'  && req.Subject__c == '等級訂正'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '被保険者変更'  && req.Subject__c == '被保険者変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '付保証明書発行'  && req.Subject__c == '付保証明書発行'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '口座変更、クレカ変更'  && req.Subject__c == '口座変更、クレカ変更'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '入金確認'  && req.Subject__c == '入金確認'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '新規契約・継続契約・中途更改'  && req.Subject__c == '新規契約・継続契約・中途更改'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '問合せケース（損保）'  && req.Subject__c == '問合せケース（損保）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                    else if(req.Type__c == '汎用（損保）'  && req.Subject__c == '汎用（損保）'){ newCase.ownerId = newCase.CreatedById != null ? newCase.CreatedById : req.CreatedById;}
                }
                else if(req.Class__c == '少短専用ケース'){
                    if(req.Type__c == '少短事故受付' && req.Subject__c == '少短事故受付'){ newCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;}
                    else if(req.Type__c == '保険金関連（事故受付以外）' && req.Subject__c == '保険金関連（事故受付以外）'){ newCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;}
                    else if(req.Type__c == '少短事故受付(賠責）' && req.Subject__c == '少短事故受付(賠責）'){ newCase.ownerId = caseGroupMap.get('InsuranceTShort').Id;}
                    //RIPCRM-175 修正開始　20200401
                    //else if(req.Type__c == '更新変更_少短' && req.Subject__c == '更新変更_少短'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '更新変更_少短' && req.Subject__c == '更新変更'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    //RIPCRM-175 修正完了　20200401
                    else if(req.Type__c == '更新拒否_少短' && req.Subject__c == '更新拒否_少短'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '解約_少短' && req.Subject__c == '解約_少短'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == 'Retention（少短）' && req.Subject__c == 'Retention解約希望'){ newCase.ownerId = caseGroupMap.get('RetentionTShort').Id;}
                    else if(req.Type__c == 'Retention（少短）' && req.Subject__c == 'Retention更新拒否希望'){ newCase.ownerId = caseGroupMap.get('RetentionTShort').Id;}
                    else if(req.Type__c == 'Retention（少短）' && req.Subject__c == 'Retentionプラン変更希望'){ newCase.ownerId = caseGroupMap.get('RetentionTShort').Id;}
                    else if(req.Type__c == '申込内容変更・新規多頭対応' && req.Subject__c == '申込キャンセル'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    else if(req.Type__c == '申込内容変更・新規多頭対応' && req.Subject__c == '申込内容変更'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    //RIPCRM-175 修正開始　20200401
                    //else if(req.Type__c == '申込内容変更・新規多頭対応' && req.Subject__c == 'AP/MGパンフ送付'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    else if(req.Type__c == '申込内容変更・新規多頭対応' && req.Subject__c == 'パンフ送付'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    //RIPCRM-175 修正完了　20200401
                    else if(req.Type__c == '申込内容変更・新規多頭対応' && req.Subject__c == '申込遅延・承諾書対応'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    else if(req.Type__c == '申込内容変更・新規多頭対応' && req.Subject__c == 'その他引受け対応'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    else if(req.Type__c == '契約内容変更' && req.Subject__c == '契約者(名変)・被保険者変更'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '契約内容変更' && req.Subject__c == '契約者・被保険者その他情報変更'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '契約内容変更' && req.Subject__c == '払込方法変更'){ newCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                    else if(req.Type__c == '契約内容変更' && req.Subject__c == '直接振込口座案内'){ newCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                    else if(req.Type__c == '契約内容変更' && req.Subject__c == 'ペット情報変更'){ newCase.ownerId = caseGroupMap.get('UnderwritingTShort').Id;}
                    else if(req.Type__c == '証券類・更新案内再送' && req.Subject__c == '保険証券再発行'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '証券類・更新案内再送' && req.Subject__c == '更新証再発行'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '証券類・更新案内再送' && req.Subject__c == '更新案内再送'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '証券類・更新案内再送' && req.Subject__c == '証券発行'){ newCase.ownerId = caseGroupMap.get('MaintenanceTShort').Id;}
                    else if(req.Type__c == '振込用紙再送' && req.Subject__c == 'コンビニ払込票再送'){ newCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                    else if(req.Type__c == '振込用紙再送' && req.Subject__c == 'コンビニ払込番号再通知'){ newCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;}
                    else if(req.Type__c == '問合せケース（少短）' && req.Subject__c == '問合せケース（少短）'){/*NO CHANGE*/}
                    else if(req.Type__c == '汎用（少短)'&& req.Subject__c == '汎用（少短)'){newCase.ownerId = caseGroupMap.get('ReceiptTShort').Id;} 
                }
                else if(req.Class__c == 'セールス専用ケース'){
                    if(req.Type__c == '生命_コール資料請求' && req.Subject__c == '生命_コール資料請求'){ newCase.ownerId = caseGroupMap.get('DNP').Id;}
                    //else if(req.Type__c == '損保_ミドル連携' && req.Subject__c == '損保_ミドル連携'){ newCase.ownerId = caseGroupMap.get('MiddleOfficeSonpo').Id;}
                    else if(req.Type__c == '少短_コール資料請求' && req.Subject__c == '少短_コール資料請求'){ newCase.ownerId = caseGroupMap.get('MatsuyamaLittle').Id;}
                    else if(req.Type__c == '生命・少短_比較チーム連携' && req.Subject__c == '生命・少短_比較チーム連携'){ newCase.ownerId = caseGroupMap.get('InsuranceComparingTeam').Id;}
                    else if(req.Type__c == '生命_対面誘導（生命営推本部）' && req.Subject__c == '生命_対面誘導（生命営推本部）'){ newCase.ownerId = caseGroupMap.get('SalesLife').Id;}
                    //else if(req.Type__c == '信書回収' && req.Subject__c == '信書回収'){ newCase.ownerId = caseGroupMap.get('CallCenter').Id;}
                }
                else if(req.class__c == '生命代サ専用ケース'){
                  if(req.type__c == '声紋認証' && string.isNotBlank(req.SeihoRequestContents__c) ){ newCase.ownerId = caseGroupMap.get('CCAgencySupportLife').Id;}
                  else if(req.type__c == '新契約' && (string.isNotBlank(req.SeihoRequestContents__c)  && req.SeihoRequestContents__c != '対応依頼') ){ newCase.ownerId = caseGroupMap.get('NewContractValuationLife').Id;}
                  else if(req.type__c == '保全（異動）・照会' && (req.RequestType__c == '書類発送あり'&& req.ReportGroup__c != '郵便物誤配'&& string.isNotBlank(req.ReportGroup__c)) ){ 
                    if(req.ReportGroup__c == '復活') {
                      newCase.ownerId = caseGroupMap.get('ResurrectionLife').Id;
                    } else {
                      newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;
                    }
                  }
                  else if(req.type__c == '更新' && ( req.RequestType__c == '書類発送あり'&& string.isNotBlank(req.ReportGroup__c )) ){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                  else if(req.type__c == '書類発送ケース_代サ' )
                  {
                        if(req.Subject__c == '書類発送_新契約関連' ){ newCase.ownerId = caseGroupMap.get('NewContractValuationLife').Id;}
                        else if(req.Subject__c == '書類発送_返金指図書' ){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                        else if(req.Subject__c == '書類発送_更新案内' ){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                        else if(req.Subject__c == '書類発送_更新完了' ){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                        else if(req.Subject__c == '書類発送_楽天ID連携チラシ' ){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                        else if(req.Subject__c == '書類発送_念書' ){ newCase.ownerId = caseGroupMap.get('DeliveryLife').Id;}
                        else if(req.Subject__c == '書類発送_不備レター・督促レター・返信用封筒・その他' ){/*NO CHANGE*/}
                        else if(req.Subject__c == '書類発送_代理店登録事項変更連絡書' ){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                        else if(req.Subject__c == '書類発送_手数料振込先口座変更届'){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                        else if(req.Subject__c == '書類発送_AG登録事項変更届'  ){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                        else if(req.Subject__c == '書類発送_AG業務委任契約解約届' ){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                        else if(req.Subject__c == '書類発送_AG地位承継・相続のお手続きに関する書類'  ){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                        else if(req.Subject__c == '書類発送_業務委任/委託証明書'  ){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                        else if(req.Subject__c == '書類発送_支払調書・証明書'  ){ newCase.ownerId = caseGroupMap.get('AgencyLife').Id;}
                  }
                }
            }
        }
    }
    
    /**
     *生保契約が紐づいている時に、契約者氏名(ケース作成時)に生保契約の契約者氏名漢字をセット
     * @param List<Case>
     * @return
    */
    public void setLfCntContractorBeforeNameKanji(List<Case> targetCaseList){
        Set<Id> lifeContractIdSet = new Set<Id>();
        
        for(Case cs : targetCaseList){
            //生保契約に紐づき、契約者氏名(ケース作成時)に値が未設定の場合
            if(   cs.lifeContractReference__c != Null
               && cs.LfCntContractorBeforeNameKanji__c == Null){
                   //対象の生保契約のIDを取得
                   lifeContractIdSet.add(cs.lifeContractReference__c);
               }
        }
        
        //ケースにセットされている生保契約のIDを基に生保契約から生保契約者名漢字を取得
        Map<Id, String> lifeContractMap = new Map<Id, String>();
        
        //ケースに紐づいていた生保契約を取得
        for(LifeContract__c lc : [SELECT Id, KANJI_CONTROR_NAME__c FROM LifeContract__c WHERE  Id IN :lifeContractIdSet]){
            //生保契約IDと契約者名のMapを生成
            lifeContractMap.put(lc.id, lc.KANJI_CONTROR_NAME__c);
        }
        
        for(Case cs : targetCaseList){
            //生保契約に紐づき、契約者氏名(ケース作成時)に値が未設定の場合
            if(   cs.lifeContractReference__c != Null
               && cs.LfCntContractorBeforeNameKanji__c == Null){
                //契約者名を設定
                cs.LfCntContractorBeforeNameKanji__c = lifeContractMap.get(cs.lifeContractReference__c);
            }
        }
    }
    
    /**
     * Life Migration Project
     * For New Case, link it to Existing Account or Create New Account.
     * @param List<Case>
     * @return
    */
    public void setSeimeiCaseAccounts(List<Case> caseList, Map<Id, Case> oldMap) {
        
        String CDetails='';
        String ExceptionDetails='';
        Integer AccountListsInserted = 0;
        Integer AccountListsUpdated = 0;
        Integer CpuTime=0;
        
        List<Case> caseAccountUpdates = new List<Case>();
        List<AccountInfo> accountInfos = new List<AccountInfo>();
        try
        {
            Map<ID,Schema.RecordTypeInfo> rt_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();
            
            for (Case cse : caseList)
            {
                Case oldcse = (oldMap != NULL && oldMap.size() > 0) ? 
                                                        oldMap.get(cse.Id) : NULL;
                Boolean keyfieldChanged = false;
                
                if(rt_map.get(cse.recordTypeID).getName().containsIgnoreCase('ご意見・ご要望') 
                    || rt_map.get(cse.recordTypeID).getName().containsIgnoreCase('ネットお問い合わせ') 
                    || rt_map.get(cse.recordTypeID).getName().containsIgnoreCase('ネットチャットのお問い合わせ'))
                {
                
                    CDetails = 'CaseId : ' + cse.Id 
                            + ', Rakuten Id : ' + cse.EasyId__c 
                            + ', Customer Name : ' + cse.SuppliedName;
                    
                    
                    if(String.isNotBlank(cse.UserAgent__c)) {
                        if (oldcse == NULL) {
                            cse.AccessCount__c = 1;
                        }
                        else if (oldcse != NULL && 
                                 oldcse.last_access_time__c != cse.last_access_time__c) {
                            cse.AccessCount__c = cse.AccessCount__c + 1;
                        }
                    }
                    
                    if (oldcse == NULL) {
                        if(cse.SuppliedName == null)
                            cse.SuppliedName = cse.Custom_Name__c;
                        else
                            cse.Custom_Name__c = cse.SuppliedName;
                        
                        if(cse.SuppliedPhone == null)
                            cse.SuppliedPhone = cse.Custom_Phone__c;
                        else
                            cse.Custom_Phone__c = cse.SuppliedPhone;
                    }
                    else {
                        // Check for matching key fields changed
                        if(oldcse != NULL && 
                           (oldcse.SuppliedName != cse.SuppliedName || 
                            oldcse.NameKana__c != cse.NameKana__c || 
                            oldcse.SuppliedPhone != cse.SuppliedPhone || 
                            oldcse.EasyId__c != cse.EasyId__c || 
                            oldcse.Custom_Name__c != cse.Custom_Name__c || 
                            oldcse.Custom_Phone__c != cse.Custom_Phone__c || 
                            oldcse.Birthday__c != cse.Birthday__c || 
                            oldcse.Gender__c != cse.Gender__c || 
                            oldcse.SuppliedEmail != cse.SuppliedEmail || 
                            oldcse.PostalCode__c != cse.PostalCode__c || 
                            oldcse.StateCity__c != cse.StateCity__c || 
                            oldcse.Apart__c != cse.Apart__c || 
                            oldcse.VideoChatStopFlg__c != cse.VideoChatStopFlg__c))
                        {
                            System.debug(
                                'CaseUpdate: Change in matching key fields for this update operation'
                                + cse.AccountId);
                            keyfieldChanged = true;
                        }
                        
                        if(oldcse.SuppliedName != cse.SuppliedName)
                            cse.Custom_Name__c = cse.SuppliedName;
                        if(oldcse.Custom_Name__c != cse.Custom_Name__c)
                            cse.SuppliedName = cse.Custom_Name__c;
                        
                        if(oldcse.SuppliedPhone != cse.SuppliedPhone)
                            cse.Custom_Phone__c = cse.SuppliedPhone;
                        if(oldcse.Custom_Phone__c != cse.Custom_Phone__c)
                            cse.SuppliedPhone = cse.Custom_Phone__c;
                    }
                    
                    if(AccountListHelper.existValidFields(cse.SuppliedName, '', 
                                                            cse.NameKana__c, '', 
                                                            cse.SuppliedPhone, '', 
                                                            cse.Birthday__c,
                                                            cse.EasyId__c,
                                                            cse.Gender__c))
                    {
                        // Case is inserted and Origin, Subject matches
                        if (oldcse == NULL && 
                            cse.Origin == 'Web' && 
                            (cse.Subject == '代理店ご意見・ご要望' || cse.Subject == 'WEBフォームお問い合わせ'))
                        {
                            cse.CallListCreateFlag__c = False;
                        }
                        // Case is updated and CallListCreateFlag__c = false
                        else if (oldcse != NULL && 
                                cse.CallListCreateFlag__c == False) {
                                continue;
                                // NOTREACHED
                        }
                        else if (oldcse == NULL || 
                                oldcse.AccountId == NULL || 
                                keyfieldChanged) {
                            
                            // Check if there is name and phone number
                            if (!AccountListHelper.existNameAndPhone(cse.SuppliedName, '', 
                                                                    cse.NameKana__c, '', 
                                                                    cse.SuppliedPhone, ''))
                            {
                                // Do not create a Account
                                // Clear the Account Link to Case
                                cse.AccountId = NULL;
                                break;
                                // NOTREACHED
                            }
                            
                            AccountInfo accInfo = getAccountInfo(cse);
                            // If New or Existing Account, then is Account to be Updated
                            // keyfieldChanged is changed
                            accInfo.toUpdate = true;
                            // Get Existing Accounts OR Create New Account.
                            accountInfos.add(accInfo);
                            // Add Case to List for Account Update
                            caseAccountUpdates.add(cse);
                        }
                    }
                }
            }
            
            // Get Existing Accounts for the Case Info
            // If Account doesnt Exist then create New Account with Case Info
            CommonUtility util = new CommonUtility();
            List<Account> accountList = util.getAccounts(accountInfos);
            
            Integer idx = 0;
            for (Case cse : caseAccountUpdates) {
                // Set the AccountId to Case
                // Populate this case with AccountID
                cse.AccountId = accountList[idx].Id;
                idx++;
                CDetails += ', Account List : ' + cse.AccountId;
                AccountListsUpdated++;
                
                // CPU Time elapsed
                CpuTime = CpuTime + Limits.getCpuTime();
            }
        }
        catch(Exception ex)
        {
            ExceptionDetails += CDetails + '\n     (Error message : '
                            + ex.getMessage() + ' at '+ ex.getStackTraceString() + ')\n';
            String emailBody = 'The execution of Case Insert Trigger has finished.' +
                            'Result    \n\n    '+
                            '   Account Lists Processed : '+ AccountListsUpdated + '\n'+
                            '   Total Execution Time : ' + CpuTime + ' milliseconds\n\n'+
                            'Error Description : System error/Exception \n'+     
                            '    \n'+ExceptionDetails+'\n\n';
            SendErrorMailClass.sendErrorMailAccountList(
                            '[Salesforce][Rakuten Life Insurance][Error] Case Insert Account List Trigger', 
                            emailBody, 'error');
        }
    }
    
    
    // 姓名情報
    private void inputName( AccountInfo src , Case cse ) {
        List<String> namesplit = new List<String>();
        List<String> kananamesplit = new List<String>();
        if(!String.isBlank(cse.SuppliedName))
            namesplit = cse.SuppliedName.split(' ');
        if(!String.isBlank(cse.NameKana__c))
            kananamesplit = cse.NameKana__c.split(' ');
        
        if(namesplit.size() > 1) {
            src.lastname = namesplit[0];
            src.firstname = namesplit[1];
        }
        else {
            src.lastname = cse.SuppliedName;
            src.firstname = '';
        }
        if(kananamesplit.size() > 1) {
            src.lastnamekana = kananamesplit[0];
            src.firstnamekana = kananamesplit[1];
        }
        else {
            src.lastnamekana = cse.NameKana__c;
            src.firstnamekana = '';
        }
    }
    
    
    private AccountInfo getAccountInfo(Case cse) {
        AccountInfo src = new AccountInfo();
        // 姓名情報
        inputName(src, cse);
        src.nameinfo =  (String.IsNotBlank(cse.SuppliedName) ? cse.SuppliedName : '') + 
                        (String.IsNotBlank(cse.NameKana__c) ? cse.NameKana__c : '');
        src.nameinfo = src.nameinfo.deleteWhitespace();
        // 楽天会員ID
        src.easyid = cse.EasyId__c;
        // 連絡先情報
        src.mobilephone = cse.SuppliedPhone;
        // 生年月日
        src.birthdate = cse.Birthday__c;
        // 性別
        src.gender = cse.Gender__c;
        // メール
        src.email = cse.SuppliedEmail;
        // 住所情報
        src.postalcode = cse.PostalCode__c;
        src.state = cse.StateCity__c;
        src.street = cse.Apart__c;
        
        // Other Info
        Map<String, String> params = new Map<String, String>();
        // VideoChat Flag
        params.put('VideoChatFlag__c', 
                   '禁止'.equals(cse.VideoChatStopFlg__c) ? 
                   'true' : 'false');
        src.params = params;
        
        return src;
    }
}