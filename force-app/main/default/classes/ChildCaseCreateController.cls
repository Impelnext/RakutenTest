/*
 * Block comments with details of changes
 */
public class ChildCaseCreateController
{
    /** コンストラクタ */
    public ChildCaseCreateController(ApexPages.StandardController controller) 
    {
        this.objectInstance = new Case();
        dtos = new List<DTO>();
    }

    private static String INITIAL_VALUE = '';
    // 対応区分・対応種別選択リストで選択された値が格納される変数
    public Case objectInstance {get; set;}
    // キュー名選択リストで選択された値が格納される変数
    public String queueId {get; set;}
    // 親ケースの値が正しく入力されているか判定する変数
    public  boolean parentCheck {get; set;}

    /** 対応区分リスト */
    public List<SelectOption> CtrlPickListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            // 対象のオブジェクトに存在する選択リストを取得し、登録済みの選択値を取得します
            Schema.DescribeFieldResult fieldResult = Case.class__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            // 選択リストの一番上にデフォルトの選択値を設定
            options.add(new SelectOption(INITIAL_VALUE, '-- なし --'));

            for(Schema.PicklistEntry e : picklistEntries){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
    }

    /** 対応種別リスト */
    public List<SelectOption> DependentPickListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            // 選択リストの一番上にデフォルトの選択値を設定
            options.add(new SelectOption(INITIAL_VALUE, '-- なし --'));

            // 制御項目ctrlPicklistが選択されている時に連動項目depPicklistで選べる選択肢を取得する。
            if(this.objectInstance.class__c != null || this.objectInstance.class__c != INITIAL_VALUE){
                List<DepPickListCtrl.TPicklistEntry> tPicklistEntries = 
                    DepPickListCtrl.GetDependentOptions('Case','class__c','type__c').get(this.objectInstance.class__c);

                for(DepPickListCtrl.TPicklistEntry e : tPicklistEntries){
                    options.add(new SelectOption(e.value, e.label));
                }
            }
            return options;
        }
    }

    /** キュー名リスト */
    public List<SelectOption> QueueListOptions{
        get{
            List<SelectOption> options = new List<SelectOption>();

            // グループからキュー一覧を取得
            Group[] Groups 
                = [SELECT Name, Id FROM Group WHERE Type = 'Queue'];

            // 選択リストの一番上にデフォルトの選択値を設定
            options.add(new SelectOption(INITIAL_VALUE, '-- なし --'));

            // キュー一覧からリスト作成
            for(Group c : Groups) {
                options.add(new SelectOption(c.Id, c.Name));
            }

            return options;
        }
    }

    /* 画面表示用クラス */
    public class DTO {
        /* チェック有無 */
        public boolean checked {get; set;}
        /* 契約情報ID */
        public Id contractId {get; set;}
        /* 契約名称 */
        public String name {get; set;}
        /* 証券番号 */
        public String policyNumber {get; set;}
        /* 保険区分 */
        public String insuranceCategory {get; set;}
        /* ステータス */
        public String status {get; set;}
        /* 住所（請求先） */
        public String BillingAddress {get; set;}
        /* 被保険者 */
        public String insured {get; set;}
        /* 被保険体（ペット名） */
        public String insuredBody {get; set;}

        /* 契約者氏名カナ */
        public String kanaControrName {get; set;}
        /* 契約者氏名漢字 */
        public String controrName {get; set;}
        /* 被保険者氏名漢字 */
        public String insuredName {get; set;}
        /* 給付金受取人 */
        public String benefitRecipient {get; set;}

        /* 顧客番号 */
        public String customerNumber {get; set;}
        /* 契約管理番号 */
        public String contractManagementNumber {get; set;}
        /* ペット年齢 */
        public String petYear {get; set;}
        /* 保険期間 */
        public String insurancePeriod {get; set;}
        /* 支払い方法 */
        public String payment {get; set;}
        /* 契約者氏名カナ（姓） */
        public String furiganaLast {get; set;}
        /* 契約者氏名カナ（名） */
        public String furiganaForst {get; set;}
        /* 保険料 */
        public String insuranceFee {get; set;}

        /* 契約開始日 */
        public Date contractStartDate {get; set;}
        /* 契約終了日 */
        public Date contractEndDate {get; set;}
        /* 質権有無 */
        public String pledgeOrNot {get; set;}

        /* 契約ステータス */
        public String contractStatus{get; set;}
        /* 商品名 */
        public String productName{get; set;}
        /* 車両ナンバー */
        public String carNo{get; set;}
        /* 対象所在地 */
        public String subjectArea{get; set;}
        /* 電話番号 */
        public String phone{get; set;}
        /* 保険金額 */
        public String insuranceAmount{get; set;}
        /* NG代理店フラグ */
        public boolean isNGAgency{get; set;}



        /* チェックボックス選択状態クリア */
        public void ConAgree_checkClear() {
            checked = false;
        }
    }
    public List<DTO> dtos { get; set; }

    /** 状況 */
    public String Status { get; set; }
    /** ケースオブジェクトID */
    public Id caseId { get; set; }


    /** 初期処理 */
    public void view() {
        String paramId = ApexPages.currentPage().getParameters().get('id');
        try {
            caseId = paramId;
        } catch (System.StringException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ID の取得に失敗'));
        }

        Case caseObj = null;
        Id contactId = null;
        for(Case cs : [SELECT ContactId, Status, class__c, type__c FROM Case WHERE Id = :caseId]){
            caseObj = cs;
            contactId = cs.contactId;
            this.objectInstance.class__c = cs.class__c;
            this.objectInstance.type__c = cs.type__c;
        }

        if( caseObj == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '対象のケースが見つかりません'));
            return;
        }

        // 取引先から取引先責任者に紐づく取引先IDを取得（契約側との紐付け用）
        Account[] accountObj = [SELECT Id FROM Account WHERE PersonContactId = :contactId];
        Id accountId = null;
        if(accountObj.size() > 0) {
            accountId = accountObj[0].Id;
        }
        Status = caseObj.Status;

        // 契約情報（生保・損穂・少短）取得
        for( LifeContract__c c : [SELECT Id, Name, STATUS_DISPLAY__c, POL_NUM__c, PRODUCT_NAME__c, 
                                         KANJI_CONTROR_NAME__c, INSR_PERIOD__c, CONTRACT_DATE__c, 
                                         KANJI_INSURED_NAME__c, Phone__c, BENE_AMOUNT__c, 
                                         MONTHLY_PRM__c, AccountId__c, status__c, StreetAddress__c,
                                         KANA_CONTROR_NAME__c, BENEFIT_RECIPIENT__c, POLICY_MUTUAL_AID_NUMBER__c
                                  FROM   LifeContract__c
                                  WHERE  AccountId__c = :accountId
                                  ORDER BY Name LIMIT 200]) {
            dtos.add(convertLifeContractToDTO(c));
        }
        List<DamageContract__c> damageContractList = [SELECT Id, ContractStatusDisplay__c, InsuraPolicyNo__c, 
                                                            Name, AccountId__r.Name, AccountId__c, ContractTerm__c, ContractStartDate__c,
                                                            InsuredPerson__c, ContractEndDate__c, CarNo__c, SubjectArea__c,
                                                            InsuredPhoneNum__c, InsuranceFee__c, StreetAddress__c, 
                                                            TorihikisakiKana__c, PaymentType__c, PledgeOrNot__c,
                                                            AgencyCode__c
                                                    FROM   DamageContract__c
                                                    WHERE  AccountId__c = :accountId
                                                    ORDER BY Name LIMIT 200];
        Map<String, NGAgency__c> ngAgencyMap = this.makeNGAgencyList(damageContractList);
        for (DamageContract__c c : damageContractList){
            dtos.add(convertDamageContractToDTO(c, ngAgencyMap));
        }
//        for( LittleContract__c c : [SELECT Id, SubscriberStatusDisply__c, Name, SubscriberNameKanji__c, 
        for( LittleContract__c c : [SELECT Id, SubscriberStatusLabel__c, Name, SubscriberNameKanji__c, 
                                           InsurancePeriod__c, InsuranceCommencement__c, InsuredKanji__c, 
                                           InsuranceTarget_1__c, SubscriberManageNo__c, AccountId__c, InsuranceType__c, 
                                           SubscriberTel__c, InsurancePremium__c, SubscriberAddressKanji__c,
                                           CustomerNumber__c, PetAge__c, AccountId__r.PersonContact.furiganaLast__c,
//                                           AccountId__r.PersonContact.furiganaForst__c ,PaymentMethod__c, PaymentMethodDisplay__c 
                                           AccountId__r.PersonContact.furiganaForst__c ,PaymentMethod__c, PaymentMethodLabel__c 
                                      FROM LittleContract__c
                                      WHERE AccountId__c = :accountId
                                      ORDER BY Name LIMIT 200] ) {
            dtos.add(convertLittleContractToDTO(c));
        }

    }

    /*
     * NG代理店Map作成（key：代理店名、value：代理店オブジェクト）
     */
    private Map<String, NgAgency__c> makeNGAgencyList(List<DamageContract__c> damageContractList){
        List<String> allAgency = new List<String>();
        for(DamageContract__c damageContract : damageContractList){
            if(damageContract.AgencyCode__c != null){
                List<String> agencys = damageContract.AgencyCode__c.split(',');
                for(String agency : agencys){
                    allAgency.add(StringUtil.trim(agency));
                }
            }
        }
        return NGAgencyHelper.getNgAgencyMap(allAgency);
    }

    /*
     * 損保契約はNG代理店かを判断する
     */
    private boolean isNGAgencyContract(DamageContract__c contract , Map<String, NgAgency__c> ngAgencyMap){
        if(contract.AgencyCode__c != null){
            List<String>agencys = contract.AgencyCode__c.split(',');
            for(String agency : agencys){
                if(ngAgencyMap.containsKey(StringUtil.trim(agency))){
                    return true;
                }
            }
        }
        return false;
    }

    private DTO convertLifeContractToDTO( LifeContract__c c ) {
        DTO d = new DTO();
        d.contractId = c.Id;
        d.name = c.Name;
        d.contractStatus = c.STATUS_DISPLAY__c;
        //20190919 CC基盤強化対応 MOD START
        //d.policyNumber = c.POL_NUM__c;
        d.policyNumber = c.POLICY_MUTUAL_AID_NUMBER__c; //保険証券番号/会員番号
        //20190919 CC基盤強化対応 MOD END
        d.productName = c.PRODUCT_NAME__c;
        d.controrName = c.KANJI_CONTROR_NAME__c;        // 契約者氏名漢字
        d.insurancePeriod = c.INSR_PERIOD__c;
        d.insuranceCategory = '生保';
        Date dtStartDate = convertDate(c.CONTRACT_DATE__c);
        if(dtStartDate != Null){ // 契約開始日
            d.contractStartDate = dtStartDate;
        }
        d.insured = c.KANJI_INSURED_NAME__c;
        d.insuredBody = '';
        d.carNo = '';
        d.subjectArea = '';
        d.phone = c.Phone__c;
        d.insuranceAmount = c.BENE_AMOUNT__c;
        d.insuranceFee = c.MONTHLY_PRM__c;
        d.status = c.Status__c;
        d.BillingAddress = c.StreetAddress__c;
        d.kanaControrName = c.KANA_CONTROR_NAME__c;     // 契約者氏名カナ
        d.insuredName = c.KANJI_INSURED_NAME__c;        // 被保険者氏名漢字
        d.benefitRecipient = c.BENEFIT_RECIPIENT__c;    // 給付金受取人
        return d;
    }

    private DTO convertDamageContractToDTO( DamageContract__c c, Map<String, NGAgency__c> ngAgencyMap ) {
        DTO d = new DTO();
        d.contractId = c.Id;
        d.contractStatus = c.ContractStatusDisplay__c;
        d.policyNumber = c.InsuraPolicyNo__c;
        d.productName = c.Name;
        d.controrName = c.AccountId__r.Name;
        d.insurancePeriod = c.ContractTerm__c;
        Date dtStartDate = convertDate(c.ContractStartDate__c);
        if(dtStartDate != Null){ // 契約開始日
            d.contractStartDate = dtStartDate;
        }
        d.insured = c.InsuredPerson__c;
        d.insuredBody = '';
        d.carNo = c.CarNo__c;
        d.subjectArea = c.SubjectArea__c;
        d.phone = c.InsuredPhoneNum__c;
        d.insuranceAmount = '';
        d.insuranceFee = c.InsuranceFee__c;
        d.name = c.Name;
        d.insuranceCategory = '損保';
        d.status = c.ContractStatusDisplay__c;
        d.BillingAddress = c.StreetAddress__c;
        d.kanaControrName = c.TorihikisakiKana__c; // 取引先名カナ
        d.payment = c.PaymentType__c;              // 支払い方法
        d.pledgeOrNot = c.PledgeOrNot__c;          // 質権有無
        d.isNGAgency = this.isNGAgencyContract(c, ngAgencyMap); //NG代理店判断
        return d;
    }

    private Date convertDate(String strDt){
        Date dt = null;
        if(!String.isEmpty(strDt)) {
            List<String> tmpStrList1 = strDt.split('/');
            if(tmpStrList1.size() == 3){
                dt = Date.newInstance(Integer.valueOf(tmpStrList1.get(0)),
                                      Integer.valueOf(tmpStrList1.get(1)),
                                      Integer.valueOf(tmpStrList1.get(2)));
            }else{
                List<String> tmpStrList2 = strDt.split('-');
                if(tmpStrList2.size() == 3){
                    dt = Date.newInstance(Integer.valueOf(tmpStrList2.get(0)),
                                          Integer.valueOf(tmpStrList2.get(1)),
                                          Integer.valueOf(tmpStrList2.get(2)));
                }else{
                    if( strDt.length() == 8){
                        dt = Date.newInstance(Integer.valueOf(strDt.substring(0,4)),
                                              Integer.valueOf(strDt.substring(4,6)),
                                              Integer.valueOf(strDt.substring(6,8)));
                    } else if(strDt.length() == 10 ) {
                        dt = Date.newInstance(Integer.valueOf(strDt.substring(0,4)),
                                              Integer.valueOf(strDt.substring(5,7)),
                                              Integer.valueOf(strDt.substring(8,10)));
                    }
                }
            }
        }
        return dt;
    }

    private DTO convertLittleContractToDTO( LittleContract__c c ) {
        DTO d = new DTO();
        d.contractId = c.Id;
        d.name = c.InsuranceType__c;
//        d.contractStatus = c.SubscriberStatusDisply__c;
        d.contractStatus = c.SubscriberStatusLabel__c;
        d.policyNumber = c.SubscriberManageNo__c;
        d.productName = c.Name;
        d.controrName = c.SubscriberNameKanji__c;
        d.insurancePeriod = c.InsurancePeriod__c;
        d.contractStartDate = convertDate(c.InsuranceCommencement__c);
        d.insured = c.InsuredKanji__c;
        d.insuredBody = c.InsuranceTarget_1__c;
        d.carNo = '';
        d.subjectArea = '';
        d.phone = c.SubscriberTel__c;
        d.insuranceAmount = '';
        d.insuranceFee = c.InsurancePremium__c;
        d.insuranceCategory = '少短';
//        d.status = c.SubscriberStatusDisply__c;
        d.status = c.SubscriberStatusLabel__c;
        d.BillingAddress = c.SubscriberAddressKanji__c;
        d.customerNumber = c.CustomerNumber__c;     // 顧客番号
        d.contractManagementNumber = c.SubscriberManageNo__c;     // 契約管理番号
        d.petYear = c.petAge__c;                   // ペット年齢
        d.furiganaLast = c.AccountId__r.PersonContact.furiganaLast__c;  // 契約者氏名カナ（姓）
        d.furiganaForst = c.AccountId__r.PersonContact.furiganaForst__c;    // 契約者氏名カナ（名）
        d.kanaControrName = '';
        if(String.isNotBlank(d.furiganaLast)){
            d.kanaControrName = d.furiganaLast;
        }
        if(String.isNotBlank(d.furiganaForst)){
            d.kanaControrName = d.kanaControrName + ' ' + d.furiganaForst;
        }
        /*** 本番00090 FIX START ***/
        //d.Payment = c.PaymentMethod__c;
//        d.Payment = c.PaymentMethodDisplay__c;
        d.Payment = c.PaymentMethodLabel__c;
        /*** 本番00090 FIX END ***/
        return d;
    }

    public Double timezoneOffset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);}
    }

    /** 子ケース作成 */
    public PageReference execute() {
        
        // 親ケースデータ不正判定項目に初期値セット
        parentCheck = true;
        // チェック対象データ取得
        List<DTO> targetDataList = getCheckTargetDataList();
        Id qId = null;
        if(queueId != INITIAL_VALUE) {
            qId = queueId;
        }
        //エラー原因調査用
        System.debug(targetDataList);

        Database.DMLOptions dmo = new Database.DMLOptions();
        if(qId == null) {
            dmo.assignmentRuleHeader.useDefaultRule= true;
        }

        // 親ケース情報再取得
        Case parentCaseObj = getCaseByCaseId(caseId);

        // レコードタイプ取得
        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([
            SELECT
                 Id
                ,DeveloperName
            FROM RecordType
            WHERE SobjectType = 'case'
        ]);

        // 登録用データ準備
        List<Case> registCaseList = new List<Case>();
        for(DTO targetData : targetDataList) {
            Case registCase = new Case();

            //親ケースの値引継ぎ
            registCase = setValueParentCaseToChildCase(parentCaseObj, registCase);
            if(!parentCheck){
                return null;
            }

            //20190802 修正開始
            //親ケースのInternal Commentsを子ケースにコピー
            if(!parentCaseObj.CaseComments.isEmpty()){
                if(parentCaseObj.CaseComments[0].CommentBody != null){
                    CaseComment cComment = new CaseComment(
                        ParentId = registCase.Id,
                        CommentBody = parentCaseObj.CaseComments[0].CommentBody
                    );
                    insert cComment;
                }
            }
            //20190802 修正終了

            // 対応区分、対応種別が親ケースと異なる場合
            if(registCase.class__c != this.objectInstance.class__c || registCase.type__c != this.objectInstance.type__c){
                // 件名をクリア（親からコピーしない）
                registCase.CaseSubject__c = NULL;
            }
            // 対応区分
            registCase.class__c = this.objectInstance.class__c;
            // 対応種別
            registCase.type__c = this.objectInstance.type__c;
            // 親ケースID
            registCase.ParentId = caseId;
            // 対象契約名
            registCase.TargetContractName__c = targetData.name;
            // 件名
            if(String.isNotBlank(targetData.name)){
                    registCase.Subject = registCase.Subject + '　' + targetData.name;
            }
            // 契約参照
            if(targetData.insuranceCategory == '生保') {
                registCase.lifeContractReference__c = targetData.contractId;

                // 初期値セット　契約別
                if(registCase.DestinationAddress__c == Null) registCase.DestinationAddress__c = targetData.insuredName;   // 送付先宛名
                if(registCase.CurrentRecipientNameSurname__c == Null) registCase.CurrentRecipientNameSurname__c = targetData.benefitRecipient;    // 現受取人氏名（姓）
                if(registCase.BeforeName__c == Null) registCase.BeforeName__c = targetData.controrName;           // 契約者改姓前
                if(registCase.RefundAccount2__c == Null) registCase.RefundAccount2__c = 'あり';                       // 返金先口座
                if(registCase.ContractFuriName__c == Null) registCase.ContractFuriName__c = targetData.kanaControrName; // 契約者カナ

                // 初期値セット　レコードタイプ別
                // 「保険金・給付金・共済金請求」の場合
                if(recordTypeMap.get(registCase.RecordTypeId).DeveloperName == 'InsuranceClaims' && registCase.NameOfferer__c == Null) {
                    registCase.NameOfferer__c = targetData.kanaControrName; // 申出者氏名
                }else if(registCase.NameOfferer__c == Null){
                    registCase.NameOfferer__c = targetData.controrName;     // 申出者氏名
                }
                // 「減口」の場合
                if(recordTypeMap.get(registCase.RecordTypeId).DeveloperName == 'Reduc') {
                    if(registCase.ReductionBefore__c == Null && registCase.ReductionAfter__c == Null){
                        registCase.ReductionBefore__c = 2;  // 減口前
                        registCase.ReductionAfter__c = 1;   // 減口後
                    }
                }
                // 「改姓」の場合
                if(recordTypeMap.get(registCase.RecordTypeId).DeveloperName == 'Surname') {
                    if(registCase.BeforeName__c == Null){
                        registCase.BeforeName__c = targetData.controrName;  // 契約者改姓前
                    }
                    if(registCase.SimultaneousChanges__c == Null){
                        registCase.SimultaneousChanges__c = 'なし';         // 未成年同時変更
                    }
                }
            }
            else if(targetData.insuranceCategory == '損保') {
                registCase.damageContractReference__c = targetData.contractId;

                // 初期値セット
                if( registCase.Payment__c == Null) registCase.Payment__c = targetData.payment;                     // 支払い方法
                if( registCase.InsuranceStart__c == Null) registCase.InsuranceStart__c = targetData.contractStartDate;    // 保険始期
                if( registCase.EndOfInsurance__c == Null) registCase.EndOfInsurance__c = targetData.contractEndDate;      // 保険終期
                if( registCase.Pledge__c == Null) registCase.Pledge__c = targetData.pledgeOrNot;                  // 質権有無
                if( registCase.NonLifeInsuranceContractName__c == Null) registCase.NonLifeInsuranceContractName__c = targetData.name;   // 損保契約名
                if( registCase.ContractFuriName__c == Null) registCase.ContractFuriName__c = targetData.kanaControrName;    // 契約者カナ
            }
            else if(targetData.insuranceCategory == '少短') {
                registCase.littleContractReference__c = targetData.contractId;

                // 初期値セット
                if( registCase.PetName__c == Null ) registCase.PetName__c = targetData.insuredBody;                 // ペット名
                if( registCase.CustomerNumber__c == Null ) registCase.CustomerNumber__c = targetData.customerNumber;       // 顧客番号
                if( registCase.ContractManagementNumber__c == Null ) registCase.ContractManagementNumber__c = targetData.contractManagementNumber; // 契約管理番号
                if( registCase.PetAge__c == Null ) registCase.PetAge__c = targetData.petYear;                      // ペット年齢
                if( registCase.AccidentReceptionDate__c == Null ) registCase.AccidentReceptionDate__c = Date.today();             // 事故受付日
                if( registCase.PeriodOfInsurance__c == Null ) registCase.PeriodOfInsurance__c = targetData.insurancePeriod;   // 保険期間
                if( registCase.Payment__c == Null ) registCase.Payment__c = targetData.payment;                     // 支払い方法
                if( registCase.ContrameKanactorLastNa__c == Null ) registCase.ContrameKanactorLastNa__c = targetData.furiganaLast; // 契約者氏名カナ（姓）
                if( registCase.ContractorNameKana__c == Null ) registCase.ContractorNameKana__c = targetData.furiganaForst;    // 契約者氏名カナ（名）
                if( registCase.ContractFuriName__c == Null ) registCase.ContractFuriName__c = targetData.kanaControrName;    // 契約者カナ
                if( registCase.ProductName__c == Null ) registCase.ProductName__c = targetData.name;                    // 商品名
                if( registCase.InsuranceFee__c == Null ) registCase.InsuranceFee__c = targetData.insuranceFee;           // 保険料
                if( registCase.ReturnDestinationName__c == Null ) registCase.ReturnDestinationName__c = targetData.controrName;   // 折り返し先名
            }
            if(qId == null) {
                registCase.setOptions(dmo);
            } else {
                registCase.OwnerId = qId;
            }
            registCaseList.add(registCase);
        }

        if(registCaseList.size() > 0) {
            // ケースをインサートし結果を格納
            List<Database.SaveResult> results = Database.insert(registCaseList, /*allOrNone*/ false);
            // エラー判定を初期化
            integer errCount = 0;
            
            // インサート結果を取り出す
            for (Database.SaveResult result : results) {
                // インサート結果からエラー結果を取り出す
                for (Database.Error err : result.getErrors()){
                    // エラー発生項目のAPI名を取得
                    for (string apiname : err.getFields()){
                         
                        // 取得したAPI名から()を削除
                        apiname = apiname.replace('(', '');
                        apiname = apiname.replace(')', '');
                        
                        // API名からラベル名を取得                
                        DescribeSObjectResult sObjectDescribe= Case.getSObjectType().getDescribe();
                        Map<String, SObjectField> fields = sObjectDescribe.fields.getMap();
                        String label = fields.get(apiname).getDescribe().getlabel();
                        
                        // エラーメッセージの表示
                        if(errCount==0){
                            ApexPages.Message hdMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'コピー元ケースの以下の項目に不正な値が設定されています');
                            ApexPages.addMessage(hdMsg);
                        }
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label + ': ' + err.getMessage());
                        ApexPages.addMessage(myMsg);
                        
                        // エラー判定をインクリメント
                        errCount++;
                        // 親ケース不正判定フラグをfalseに変更
                        parentCheck = false;
                    }
                }
            }
            if(errCount > 0) return null;
        }

        String prevURL = '/' + System.currentPageReference().getParameters().get('id');
        PageReference prevPage = new PageReference(prevURL); 
        return null;
    }

    /* チェック対象データ取得 */
    private List<DTO> getCheckTargetDataList() {
        List<DTO> targetDataList = new List<DTO>();
        for(DTO d : dtos) {
            if(d.checked) {
                targetDataList.add(d);
            }
        }

        return targetDataList;
    }
    
    /* 親ケースの値引継ぎ */
    private case setValueParentCaseToChildCase(Case parentCaseObj, Case registCase){
        
        // 発生源
        registCase.Origin = parentCaseObj.Origin;
        // 状況
        registCase.Status = parentCaseObj.Status;
        // レコードタイプID
        registCase.RecordTypeId = parentCaseObj.RecordTypeId;
        // 申込者氏名
        registCase.ContactId = parentCaseObj.ContactId;
        // 優先度
        registCase.Priority = parentCaseObj.Priority;
        // 件名
        registCase.Subject = parentCaseObj.Subject;
        // フリガナ（契約者）
        registCase.Subject = parentCaseObj.Subject;
        
        //そのほかの項目もすべてセット
        registCase.class__c                                 = parentCaseObj.class__c;
        registCase.type__c                                  = parentCaseObj.type__c;
        registCase.DrinkingDay__c                           = parentCaseObj.DrinkingDay__c;
        registCase.DrinkingDate__c                          = parentCaseObj.DrinkingDate__c;
        registCase.AmountOfAlcoholConsumed__c               = parentCaseObj.AmountOfAlcoholConsumed__c;
        registCase.ThreeMajorDisease__c                     = parentCaseObj.ThreeMajorDisease__c;
        registCase.SevenDiseaseRide__c                      = parentCaseObj.SevenDiseaseRide__c;
        registCase.SevenSpecialAfter__c                     = parentCaseObj.SevenSpecialAfter__c;
        registCase.AGRegistrationChange__c                  = parentCaseObj.AGRegistrationChange__c;
        registCase.CALLFD__c                                = parentCaseObj.CALLFD__c;
        registCase.CCInputField__c                          = parentCaseObj.CCInputField__c;
        registCase.DMNotApplicableFlag__c                   = parentCaseObj.DMNotApplicableFlag__c;
        registCase.fax__c                                   = parentCaseObj.fax__c;
        registCase.ID__c                                    = parentCaseObj.ID__c;
        registCase.mgPlanChg__c                             = parentCaseObj.mgPlanChg__c;
        registCase.mgPlanSelect__c                          = parentCaseObj.mgPlanSelect__c;
        registCase.RLCRegistrationChange__c                 = parentCaseObj.RLCRegistrationChange__c;
        registCase.VOC__c                                   = parentCaseObj.VOC__c;
        registCase.SuppliedEmail                            = parentCaseObj.SuppliedEmail;
        registCase.SuppliedCompany                          = parentCaseObj.SuppliedCompany;
        registCase.SuppliedName                             = parentCaseObj.SuppliedName;
        registCase.SuppliedPhone                            = parentCaseObj.SuppliedPhone;
        registCase.WebSite__c                               = parentCaseObj.WebSite__c;
        registCase.NumberCancerSupport__c                   = parentCaseObj.NumberCancerSupport__c;
        registCase.NumberHospitalizationSupport__c          = parentCaseObj.NumberHospitalizationSupport__c;
        registCase.NumberWomenSupport__c                    = parentCaseObj.NumberWomenSupport__c;
        registCase.NumberSmart__c                           = parentCaseObj.NumberSmart__c;
        registCase.NumberSmart2__c                          = parentCaseObj.NumberSmart2__c;
        registCase.NumberSuper2000__c                       = parentCaseObj.NumberSuper2000__c;
        registCase.NumberCancerInsurance__c                 = parentCaseObj.NumberCancerInsurance__c;
        registCase.NumberToRelyOn__c                        = parentCaseObj.NumberToRelyOn__c;
        registCase.NumberSuper__c                           = parentCaseObj.NumberSuper__c;
        registCase.NumberTermInsurance__c                   = parentCaseObj.NumberTermInsurance__c;
        registCase.NumberLove__c                            = parentCaseObj.NumberLove__c;
        registCase.NumberLong__c                            = parentCaseObj.NumberLong__c;
        registCase.ApplicationNumberGeneralBrochure__c      = parentCaseObj.ApplicationNumberGeneralBrochure__c;
        registCase.ForgetfulUse__c                          = parentCaseObj.ForgetfulUse__c;
        registCase.BodyInsurancePersonalAssist__c           = parentCaseObj.BodyInsurancePersonalAssist__c;
        registCase.CancerHospitalizationride__c             = parentCaseObj.CancerHospitalizationride__c;
        registCase.AfterHospitalizationSpecialContract__c   = parentCaseObj.AfterHospitalizationSpecialContract__c;
        registCase.CancerRide__c                            = parentCaseObj.CancerRide__c;
        registCase.AfterCancerSpecialContractReduction__c   = parentCaseObj.AfterCancerSpecialContractReduction__c;
        registCase.CarInsuranceASAP__c                      = parentCaseObj.CarInsuranceASAP__c;
        registCase.CarInsurancePAP__c                       = parentCaseObj.CarInsurancePAP__c;
        registCase.consider__c                              = parentCaseObj.consider__c;
        registCase.OtherDetail2__c                          = parentCaseObj.OtherDetail2__c;
        registCase.OtherDetail__c                           = parentCaseObj.OtherDetail__c;
        registCase.DirectOwnership__c                       = parentCaseObj.DirectOwnership__c;
        registCase.JapanPostSymbol__c                       = parentCaseObj.JapanPostSymbol__c;
        registCase.ApartmentName__c                         = parentCaseObj.ApartmentName__c;
        registCase.EscalationContent__c                     = parentCaseObj.EscalationContent__c;
        registCase.EscalationDateAndTime__c                 = parentCaseObj.EscalationDateAndTime__c;
        registCase.IsEscalated                              = parentCaseObj.IsEscalated;
        registCase.CancerMedicalAnnouncement__c             = parentCaseObj.CancerMedicalAnnouncement__c;
        registCase.SourceId                                 = parentCaseObj.SourceId;
        registCase.comment2__c                              = parentCaseObj.comment2__c;
        registCase.comment3__c                              = parentCaseObj.comment3__c;
        registCase.comment4__c                              = parentCaseObj.comment4__c;
        registCase.comment5__c                              = parentCaseObj.comment5__c;
        registCase.comment__c                               = parentCaseObj.comment__c;
        registCase.JuniorRider__c                           = parentCaseObj.JuniorRider__c;
        registCase.BackOfficeEntryField__c                  = parentCaseObj.BackOfficeEntryField__c;
        registCase.FormID__c                                = parentCaseObj.FormID__c;
        registCase.ContractFuriName__c                      = parentCaseObj.ContractFuriName__c;
        registCase.PetName__c                               = parentCaseObj.PetName__c;
        registCase.PetAge__c                                = parentCaseObj.PetAge__c;
        registCase.petDeathDate__c                          = parentCaseObj.petDeathDate__c;
        registCase.PetDeathDateConfirmation__c              = parentCaseObj.PetDeathDateConfirmation__c;
        registCase.PaperlessContent__c                      = parentCaseObj.PaperlessContent__c;
        registCase.HormonalTreatment__c                     = parentCaseObj.HormonalTreatment__c;
        registCase.MicrochipNumber__c                       = parentCaseObj.MicrochipNumber__c;
        registCase.MicroChipAttached__c                     = parentCaseObj.MicroChipAttached__c;
        registCase.MiddleOfficeEntryField__c                = parentCaseObj.MiddleOfficeEntryField__c;
        registCase.EmailPermission__c                       = parentCaseObj.EmailPermission__c;
        registCase.ModuleID__c                              = parentCaseObj.ModuleID__c;
        registCase.RetentionFailure__c                      = parentCaseObj.RetentionFailure__c;
        registCase.RetentionSuccess__c                      = parentCaseObj.RetentionSuccess__c;
        registCase.LivingNeedsRide__c                       = parentCaseObj.LivingNeedsRide__c;
        registCase.LinkCode__c                              = parentCaseObj.LinkCode__c;
        registCase.Lead__c                                  = parentCaseObj.Lead__c;
        registCase.LeadRecordType__c                        = parentCaseObj.LeadRecordType__c;
        registCase.LeisureInsuranceGolfType__c              = parentCaseObj.LeisureInsuranceGolfType__c;
        registCase.LeisureInsurance__c                      = parentCaseObj.LeisureInsurance__c;
        registCase.ReportCategory2__c                       = parentCaseObj.ReportCategory2__c;
        registCase.ReportCategory1__c                       = parentCaseObj.ReportCategory1__c;
        registCase.ReportCategory3__c                       = parentCaseObj.ReportCategory3__c;
        registCase.PrimaryReceptionNumber__c                = parentCaseObj.PrimaryReceptionNumber__c;
        registCase.Chome__c                                 = parentCaseObj.Chome__c;
        registCase.LocationOfTheAccident__c                 = parentCaseObj.LocationOfTheAccident__c;
        registCase.AccidentContents__c                      = parentCaseObj.AccidentContents__c;
        registCase.AccidentReceptionDate__c                 = parentCaseObj.AccidentReceptionDate__c;
        registCase.AccidentDay__c                           = parentCaseObj.AccidentDay__c;
        registCase.AccidentTime__c                          = parentCaseObj.AccidentTime__c;
        registCase.memo__c                                  = parentCaseObj.memo__c;
        registCase.OtherSecuritiesNumber1__c                = parentCaseObj.OtherSecuritiesNumber1__c;
        registCase.OtherSecuritiesNumber2__c                = parentCaseObj.OtherSecuritiesNumber2__c;
        registCase.OtherSecuritiesNumber3__c                = parentCaseObj.OtherSecuritiesNumber3__c;
        registCase.OtherSecuritiesNumber4__c                = parentCaseObj.OtherSecuritiesNumber4__c;
        registCase.OtherSecuritiesNumber5__c                = parentCaseObj.OtherSecuritiesNumber5__c;
        registCase.AgencyAssignedDate__c                    = parentCaseObj.AgencyAssignedDate__c;
        registCase.AgencyAssignmentSituation__c             = parentCaseObj.AgencyAssignmentSituation__c;
        registCase.AgentCode__c                             = parentCaseObj.AgentCode__c;
        registCase.ChangeAgencyRegistration__c              = parentCaseObj.ChangeAgencyRegistration__c;
        if(registCase.CaseSubject__c == Null){
            registCase.CaseSubject__c                       = parentCaseObj.CaseSubject__c;
        }
        registCase.HomeInsuranceSuperJump__c                = parentCaseObj.HomeInsuranceSuperJump__c;
        registCase.HomeInsuranceHomeAssist__c               = parentCaseObj.HomeInsuranceHomeAssist__c;
        registCase.HomeInsuranceLivingAssist__c             = parentCaseObj.HomeInsuranceLivingAssist__c;
        registCase.StreetAddress__c                         = parentCaseObj.StreetAddress__c;
        registCase.Address1__c                              = parentCaseObj.Address1__c;
        registCase.Address2__c                              = parentCaseObj.Address2__c;
        registCase.AddressChangePresenceOrAbsence2__c       = parentCaseObj.AddressChangePresenceOrAbsence2__c;
        registCase.AddressChangePresenceOrAbsence__c        = parentCaseObj.AddressChangePresenceOrAbsence__c;
        registCase.AddressKana__c                           = parentCaseObj.AddressKana__c;
        registCase.InsuranceSubscription__c                 = parentCaseObj.InsuranceSubscription__c;
        registCase.InsuranceStart__c                        = parentCaseObj.InsuranceStart__c;
        registCase.InsuranceFee__c                          = parentCaseObj.InsuranceFee__c;
        registCase.PeriodOfInsurance__c                     = parentCaseObj.PeriodOfInsurance__c;
        registCase.InsuranceItem__c                         = parentCaseObj.InsuranceItem__c;
        registCase.EndOfInsurance__c                        = parentCaseObj.EndOfInsurance__c;
        registCase.Remarks__c                               = parentCaseObj.Remarks__c;
        registCase.NameOfInjuryOrIllness__c                 = parentCaseObj.NameOfInjuryOrIllness__c;
        registCase.DateOfInjuryAccidentDay__c               = parentCaseObj.DateOfInjuryAccidentDay__c;
        registCase.AdvancedMedical__c                       = parentCaseObj.AdvancedMedical__c;
        registCase.RelatedTreatmentSpecial__c               = parentCaseObj.RelatedTreatmentSpecial__c;
        registCase.HospitalizationDate__c                   = parentCaseObj.HospitalizationDate__c;
        registCase.HospitalizationDay2__c                   = parentCaseObj.HospitalizationDay2__c;
        registCase.HospitalizationRemarks__c                = parentCaseObj.HospitalizationRemarks__c;
        registCase.NumberOfHospitalDays__c                  = parentCaseObj.NumberOfHospitalDays__c;
        registCase.DateOfArrival__c                         = parentCaseObj.DateOfArrival__c;
        registCase.IncomingCallsRoute__c                    = parentCaseObj.IncomingCallsRoute__c;
        registCase.ReissueDocuments__c                      = parentCaseObj.ReissueDocuments__c;
        registCase.RetransmissionFlag__c                    = parentCaseObj.RetransmissionFlag__c;
        registCase.ResendDocuments__c                       = parentCaseObj.ResendDocuments__c;
        registCase.ResendDocumentsWeb__c                    = parentCaseObj.ResendDocumentsWeb__c;
        registCase.ResendDocumentsUpdatedNew__c             = parentCaseObj.ResendDocumentsUpdatedNew__c;
        registCase.RetransmissionReason__c                  = parentCaseObj.RetransmissionReason__c;
        registCase.firstInputYear__c                        = parentCaseObj.firstInputYear__c;
        registCase.firstInputMonth__c                       = parentCaseObj.firstInputMonth__c;
        registCase.DeleteFlag__c                            = parentCaseObj.DeleteFlag__c;
        registCase.Previous__c                              = parentCaseObj.Previous__c;
        registCase.PrerequisitCase__c                       = parentCaseObj.PrerequisitCase__c;
        registCase.PrerequisiteDateTime__c                  = parentCaseObj.PrerequisiteDateTime__c;
        registCase.RecruiterName__c                         = parentCaseObj.RecruiterName__c;
        registCase.RecruiterNumber__c                       = parentCaseObj.RecruiterNumber__c;
        registCase.RecruiterRegistration__c                 = parentCaseObj.RecruiterRegistration__c;
        registCase.Division__c                              = parentCaseObj.Division__c;
        registCase.Reason                                   = parentCaseObj.Reason;
        registCase.AntiCompanyFlag__c                       = parentCaseObj.AntiCompanyFlag__c;
        registCase.AccountId                                = parentCaseObj.AccountId;
        registCase.DealerName__c                            = parentCaseObj.DealerName__c;
        registCase.Description                              = parentCaseObj.Description;
        registCase.Receptionist__c                          = parentCaseObj.Receptionist__c;
        registCase.Jnjury__c                                = parentCaseObj.Jnjury__c;
        registCase.ReceiptRating__c                         = parentCaseObj.ReceiptRating__c;
        registCase.AccountHolderKana__c                     = parentCaseObj.AccountHolderKana__c;
        registCase.AccountHolderKanji__c                    = parentCaseObj.AccountHolderKanji__c;
        registCase.accountNumber__c                         = parentCaseObj.accountNumber__c;
        registCase.ConsentMattersuidance__c                 = parentCaseObj.ConsentMattersuidance__c;
        registCase.CancelCancellationOnTheSameDay__c        = parentCaseObj.CancelCancellationOnTheSameDay__c;
        registCase.ProductName__c                           = parentCaseObj.ProductName__c;
        registCase.Product__c                               = parentCaseObj.Product__c;
        registCase.BusinessTalk__c                          = parentCaseObj.BusinessTalk__c;
        registCase.InquirySummary__c                        = parentCaseObj.InquirySummary__c;
        registCase.InquiryContents__c                       = parentCaseObj.InquiryContents__c;
        registCase.SalesRepresentative__c                   = parentCaseObj.SalesRepresentative__c;
        registCase.BusinessHoursId                          = parentCaseObj.BusinessHoursId;
        registCase.EarthquakeInsurance__c                   = parentCaseObj.EarthquakeInsurance__c;
        registCase.Reporter__c                              = parentCaseObj.Reporter__c;
        registCase.ReporterTEL__c                           = parentCaseObj.ReporterTEL__c;
        registCase.ReporterName__c                          = parentCaseObj.ReporterName__c;
        registCase.ChangePlan__c                            = parentCaseObj.ChangePlan__c;
        registCase.beforeAddress__c                         = parentCaseObj.beforeAddress__c;
        registCase.beforePostCode__c                        = parentCaseObj.beforePostCode__c;
        registCase.Field3__c                                = parentCaseObj.Field3__c;
        registCase.ChangedPremium__c                        = parentCaseObj.ChangedPremium__c;
        registCase.FirstYearRegistrationDateAFterChang__c   = parentCaseObj.FirstYearRegistrationDateAFterChang__c;
        registCase.ChangedModel__c                          = parentCaseObj.ChangedModel__c;
        registCase.ChangedDisplacement__c                   = parentCaseObj.ChangedDisplacement__c;
        registCase.AfterUseCarModels__c                     = parentCaseObj.AfterUseCarModels__c;
        registCase.carNoAfter__c                            = parentCaseObj.carNoAfter__c;
        registCase.AFterAddingAVehicleUser__c               = parentCaseObj.AFterAddingAVehicleUser__c;
        registCase.carOwnerAfter__c                         = parentCaseObj.carOwnerAfter__c;
        registCase.carDeliveryDay__c                        = parentCaseObj.carDeliveryDay__c;
        registCase.carPriceAfter__c                         = parentCaseObj.carPriceAfter__c;
        registCase.carBodyNoAfter__c                        = parentCaseObj.carBodyNoAfter__c;
        registCase.carTypeAfter__c                          = parentCaseObj.carTypeAfter__c;
        registCase.ChangeReason__c                          = parentCaseObj.ChangeReason__c;
        registCase.ContractReference__c                     = parentCaseObj.ContractReference__c;
        registCase.ContractManagementNumber__c              = parentCaseObj.ContractManagementNumber__c;
        registCase.RelationshipWithContractor__c            = parentCaseObj.RelationshipWithContractor__c;
        registCase.ContractorReporterRelationship__c        = parentCaseObj.ContractorReporterRelationship__c;
        registCase.RelationshipWithTheOtherParty__c         = parentCaseObj.RelationshipWithTheOtherParty__c;
        registCase.AfterRenameKana__c                       = parentCaseObj.AfterRenameKana__c;
        registCase.AfterRenameKanzi__c                      = parentCaseObj.AfterRenameKanzi__c;
        registCase.ContractorNameKana__c                    = parentCaseObj.ContractorNameKana__c;
        registCase.ContrameKanactorLastNa__c                = parentCaseObj.ContrameKanactorLastNa__c;
        registCase.ContractLiabilityStartDate__c            = parentCaseObj.ContractLiabilityStartDate__c;
        registCase.AutoCreateChildCaseDateTime__c           = parentCaseObj.AutoCreateChildCaseDateTime__c;
        registCase.CorrespondenceRequest__c                 = parentCaseObj.CorrespondenceRequest__c;
        registCase.Correspondence2__c                       = parentCaseObj.Correspondence2__c;
        registCase.Correspondence__c                        = parentCaseObj.Correspondence__c;
        registCase.CorrespondenceClassificationContents__c  = parentCaseObj.CorrespondenceClassificationContents__c;
        registCase.CorrespondenceColumn1__c                 = parentCaseObj.CorrespondenceColumn1__c;
        registCase.CorrespondenceColumn2__c                 = parentCaseObj.CorrespondenceColumn2__c;
        registCase.CorrespondenceColumn3__c                 = parentCaseObj.CorrespondenceColumn3__c;
        registCase.CorrespondingFlag__c                     = parentCaseObj.CorrespondingFlag__c;
        registCase.TargetEndorsementNumber1__c              = parentCaseObj.TargetEndorsementNumber1__c;
        registCase.TargetEndorsementNumber2__c              = parentCaseObj.TargetEndorsementNumber2__c;
        registCase.TargetEndorsementNumber3__c              = parentCaseObj.TargetEndorsementNumber3__c;
        registCase.Field4TargetEndorsementNumber4__c        = parentCaseObj.Field4TargetEndorsementNumber4__c;
        registCase.TargetEndorsementNumber5__c              = parentCaseObj.TargetEndorsementNumber5__c;
        registCase.FaceConsultationIntentionFlag__c         = parentCaseObj.FaceConsultationIntentionFlag__c;
        registCase.Municipality__c                          = parentCaseObj.Municipality__c;
        registCase.CityGroupKana__c                         = parentCaseObj.CityGroupKana__c;
        registCase.Municipalities__c                        = parentCaseObj.Municipalities__c;
        registCase.Form__c                                  = parentCaseObj.Form__c;
        registCase.ReportGroup__c                           = parentCaseObj.ReportGroup__c;
        registCase.age__c                                   = parentCaseObj.age__c;
        registCase.AdCode__c                                = parentCaseObj.AdCode__c;
        registCase.BuildingName__c                          = parentCaseObj.BuildingName__c;
        registCase.InitialProposal__c                       = parentCaseObj.InitialProposal__c;
        registCase.Rear__c                                  = parentCaseObj.Rear__c;
        registCase.AcuteMyocardialInfarct__c                = parentCaseObj.AcuteMyocardialInfarct__c;
        registCase.AcuteTreatyAfterReduction__c             = parentCaseObj.AcuteTreatyAfterReduction__c;
        registCase.StartingCompany__c                       = parentCaseObj.StartingCompany__c;
        registCase.Originator__c                            = parentCaseObj.Originator__c;
        registCase.OriginationDepartment__c                 = parentCaseObj.OriginationDepartment__c;
        registCase.ProcedureContents__c                     = parentCaseObj.ProcedureContents__c;
        registCase.ProcedureType__c                         = parentCaseObj.ProcedureType__c;
        registCase.SubjectMatter__c                         = parentCaseObj.SubjectMatter__c;
        registCase.SurgeryName__c                           = parentCaseObj.SurgeryName__c;
        registCase.SurgeryDate__c                           = parentCaseObj.SurgeryDate__c;
        registCase.payChange__c                             = parentCaseObj.payChange__c;
        registCase.payMethodChange__c                       = parentCaseObj.payMethodChange__c;
        registCase.AnticancerDrugTreatment__c               = parentCaseObj.AnticancerDrugTreatment__c;
        registCase.ReturnDestinationName__c                 = parentCaseObj.ReturnDestinationName__c;
        registCase.DesiredDateForReturn__c                  = parentCaseObj.DesiredDateForReturn__c;
        registCase.Return__c                                = parentCaseObj.Return__c;
        registCase.DesignatedProxyRide__c                   = parentCaseObj.DesignatedProxyRide__c;
        registCase.NonLifeInsuranceContractName__c          = parentCaseObj.NonLifeInsuranceContractName__c;
        registCase.DegreeOfDamage__c                        = parentCaseObj.DegreeOfDamage__c;
        registCase.BranchCodeStoreNumber__c                 = parentCaseObj.BranchCodeStoreNumber__c;
        registCase.BranchName__c                            = parentCaseObj.BranchName__c;
        registCase.Payment__c                               = parentCaseObj.Payment__c;
        registCase.Radiotherapy__c                          = parentCaseObj.Radiotherapy__c;
        registCase.ReferenceNumber__c                       = parentCaseObj.ReferenceNumber__c;
        registCase.NewRecipientNominationKana__c            = parentCaseObj.NewRecipientNominationKana__c;
        registCase.NewRecipientNominationKanzi__c           = parentCaseObj.NewRecipientNominationKanzi__c;
        registCase.NewPayeeNameKana__c                      = parentCaseObj.NewPayeeNameKana__c;
        registCase.NewPayeeKanaSurname__c                   = parentCaseObj.NewPayeeKanaSurname__c;
        registCase.NewPayeeName__c                          = parentCaseObj.NewPayeeName__c;
        registCase.NewPayeeSurname__c                       = parentCaseObj.NewPayeeSurname__c;
        registCase.NewBeneficiaryBirthday__c                = parentCaseObj.NewBeneficiaryBirthday__c;
        registCase.SuppleIncident__c                        = parentCaseObj.SuppleIncident__c;
        registCase.UpdateRefusalAcceptance__c               = parentCaseObj.UpdateRefusalAcceptance__c;
        registCase.updateMonth__c                           = parentCaseObj.updateMonth__c;
        registCase.NoNeedToSendDocuments__c                 = parentCaseObj.NoNeedToSendDocuments__c;
        registCase.DocumentShippingDate__c                  = parentCaseObj.DocumentShippingDate__c;
        registCase.SendDocument__c                          = parentCaseObj.SendDocument__c;
        registCase.FinalResult__c                           = parentCaseObj.FinalResult__c;
        registCase.FinalResultReason__c                     = parentCaseObj.FinalResultReason__c;
        registCase.EndOfTheMonth__c                         = parentCaseObj.EndOfTheMonth__c;
        registCase.SimultaneousChanges__c                   = parentCaseObj.SimultaneousChanges__c;
        registCase.AfterMinorRevisionKana__c                = parentCaseObj.AfterMinorRevisionKana__c;
        registCase.AfterMinorevisionKanzi__c                = parentCaseObj.AfterMinorevisionKanzi__c;
        registCase.Identification__c                        = parentCaseObj.Identification__c;
        registCase.IdentityVerificationOthers__c            = parentCaseObj.IdentityVerificationOthers__c;
        registCase.ConditionalCancellation__c               = parentCaseObj.ConditionalCancellation__c;
        registCase.CallingID__c                             = parentCaseObj.CallingID__c;
        registCase.ConnectionStopID__c                      = parentCaseObj.ConnectionStopID__c;
        registCase.ProjectsEnd__c                           = parentCaseObj.ProjectsEnd__c;
        registCase.ContentsOfGuidance__c                    = parentCaseObj.ContentsOfGuidance__c;
        registCase.rakutenid__c                             = parentCaseObj.rakutenid__c;
        registCase.RakutenIPLinkedFlag__c                   = parentCaseObj.RakutenIPLinkedFlag__c;
        registCase.RakutenLifepluscancerSupport__c          = parentCaseObj.RakutenLifepluscancerSupport__c;
        registCase.RakutenLifeplusHospitalizationSupport__c = parentCaseObj.RakutenLifeplusHospitalizationSupport__c;
        registCase.RakutenLifeplusWomenSupport__c           = parentCaseObj.RakutenLifeplusWomenSupport__c;
        registCase.RakutenLifeToRelyOn__c                   = parentCaseObj.RakutenLifeToRelyOn__c;
        registCase.RakutenLifeSmart__c                      = parentCaseObj.RakutenLifeSmart__c;
        registCase.RakutenLifeSmart2__c                     = parentCaseObj.RakutenLifeSmart2__c;
        registCase.RakutenLifeplusSuper2000__c              = parentCaseObj.RakutenLifeplusSuper2000__c;
        registCase.RakutenLifeplusCancerInsurance__c        = parentCaseObj.RakutenLifeplusCancerInsurance__c;
        registCase.RakutenLifeplusToRelyOn__c               = parentCaseObj.RakutenLifeplusToRelyOn__c;
        registCase.RakutenLifeplusSuper__c                  = parentCaseObj.RakutenLifeplusSuper__c;
        registCase.RakutenLifeplusTermInsurance__c          = parentCaseObj.RakutenLifeplusTermInsurance__c;
        registCase.RakutenLifeLove__c                       = parentCaseObj.RakutenLifeLove__c;
        registCase.RakutenLifeLong__c                       = parentCaseObj.RakutenLifeLong__c;
        registCase.Overview__c                              = parentCaseObj.Overview__c;
        registCase.CauseOfDeath__c                          = parentCaseObj.CauseOfDeath__c;
        registCase.DeathDate__c                             = parentCaseObj.DeathDate__c;
        registCase.PresenceOrAbsenceOfDeathCertificate__c   = parentCaseObj.PresenceOrAbsenceOfDeathCertificate__c;
        registCase.ReductionBefore__c                       = parentCaseObj.ReductionBefore__c;
        registCase.ReductionAfter__c                        = parentCaseObj.ReductionAfter__c;
        registCase.BeforeReduction__c                       = parentCaseObj.BeforeReduction__c;
        registCase.AfterReduction__c                        = parentCaseObj.AfterReduction__c;
        registCase.DisasterCause__c                         = parentCaseObj.DisasterCause__c;
        registCase.SpecificDamage__c                        = parentCaseObj.SpecificDamage__c;
        registCase.CurrentRecipientName__c                  = parentCaseObj.CurrentRecipientName__c;
        registCase.CurrentRecipientNameSurname__c           = parentCaseObj.CurrentRecipientNameSurname__c;
        registCase.LifeInsuranceMutualAid__c                = parentCaseObj.LifeInsuranceMutualAid__c;
        registCase.AppLicationModel__c                      = parentCaseObj.AppLicationModel__c;
        registCase.ProposalContent__c                       = parentCaseObj.ProposalContent__c;
        registCase.ReasonForProposal__c                     = parentCaseObj.ReasonForProposal__c;
        registCase.NameOfferer__c                           = parentCaseObj.NameOfferer__c;
        registCase.ApplicationNumberIssued__c               = parentCaseObj.ApplicationNumberIssued__c;
        registCase.ApplicationTerminal__c                   = parentCaseObj.ApplicationTerminal__c;
        registCase.ApplicationElapsedDays__c                = parentCaseObj.ApplicationElapsedDays__c;
        registCase.TownName__c                              = parentCaseObj.TownName__c;
        registCase.TransferDateReceivedDate__c              = parentCaseObj.TransferDateReceivedDate__c;
        registCase.FixedSymptoms__c                         = parentCaseObj.FixedSymptoms__c;
        registCase.DevelopmentalPathways__c                 = parentCaseObj.DevelopmentalPathways__c;
        registCase.Issue__c                                 = parentCaseObj.Issue__c;
        registCase.shippingMethod__c                        = parentCaseObj.shippingMethod__c;
        registCase.DateOfShipment__c                        = parentCaseObj.DateOfShipment__c;
        registCase.RegisteredDate__c                        = parentCaseObj.RegisteredDate__c;
        registCase.PartnerName__c                           = parentCaseObj.PartnerName__c;
        registCase.ContactsOfTheOtherParty__c               = parentCaseObj.ContactsOfTheOtherParty__c;
        registCase.Heir__c                                  = parentCaseObj.Heir__c;
        registCase.Inquiry__c                               = parentCaseObj.Inquiry__c;
        registCase.ReceivedNumber__c                        = parentCaseObj.ReceivedNumber__c;
        registCase.PlanfRelocationDate__c                   = parentCaseObj.PlanfRelocationDate__c;
        registCase.Type                                     = parentCaseObj.Type;
        registCase.FundedInsuranceSuperJump__c              = parentCaseObj.FundedInsuranceSuperJump__c;
        registCase.AssetId                                  = parentCaseObj.AssetId;
        registCase.Process__c                               = parentCaseObj.Process__c;
        registCase.ContinuingDiscountRide__c                = parentCaseObj.ContinuingDiscountRide__c;
        registCase.ContinuationProposal__c                  = parentCaseObj.ContinuationProposal__c;
        registCase.OtherPattern__c                          = parentCaseObj.OtherPattern__c;
        registCase.GeneralBrochure__c                       = parentCaseObj.GeneralBrochure__c;
        registCase.ComplaintsFlag__c                        = parentCaseObj.ComplaintsFlag__c;
        registCase.ComplaintSummary__c                      = parentCaseObj.ComplaintSummary__c;
        registCase.ComplaintHistory__c                      = parentCaseObj.ComplaintHistory__c;
        registCase.NewBeneficiary__c                        = parentCaseObj.NewBeneficiary__c;
        registCase.CurrentRecipientRelationship__c          = parentCaseObj.CurrentRecipientRelationship__c;
        registCase.RelationshipWithInsured__c               = parentCaseObj.RelationshipWithInsured__c;
        registCase.ParentsLivingTogetherAndSeparated__c     = parentCaseObj.ParentsLivingTogetherAndSeparated__c;
        registCase.NameOfParentalAuthority__c               = parentCaseObj.NameOfParentalAuthority__c;
        registCase.ParentNameFullNameKana__c                = parentCaseObj.ParentNameFullNameKana__c;
        registCase.ParentalAuthorityConfirmation__c         = parentCaseObj.ParentalAuthorityConfirmation__c;
        registCase.CancellationRefund__c                    = parentCaseObj.CancellationRefund__c;
        registCase.CancellationDocumentsRequired__c         = parentCaseObj.CancellationDocumentsRequired__c;
        registCase.ReasonForCancellation2__c                = parentCaseObj.ReasonForCancellation2__c;
        registCase.CancellationType__c                      = parentCaseObj.CancellationType__c;
        registCase.AgencyName__c                            = parentCaseObj.AgencyName__c;
        registCase.BillingClassification__c                 = parentCaseObj.BillingClassification__c;
        registCase.OutOfBillingCharge__c                    = parentCaseObj.OutOfBillingCharge__c;
        registCase.ReaOnForNotCharging__c                   = parentCaseObj.ReaOnForNotCharging__c;
        registCase.BillingNumber__c                         = parentCaseObj.BillingNumber__c;
        registCase.BillingRoute__c                          = parentCaseObj.BillingRoute__c;
        registCase.TrafficAccidentPoliceNotification__c     = parentCaseObj.TrafficAccidentPoliceNotification__c;
        registCase.TrafficAccidentPoliceNotification2__c    = parentCaseObj.TrafficAccidentPoliceNotification2__c;
        registCase.PoliceSignature__c                       = parentCaseObj.PoliceSignature__c;
        registCase.DocumentReceptionDate__c                 = parentCaseObj.DocumentReceptionDate__c;
        registCase.DataRequestID__c                         = parentCaseObj.DataRequestID__c;
        registCase.InformationRequestNo__c                  = parentCaseObj.InformationRequestNo__c;
        registCase.DocumentRequestDateTime__c               = parentCaseObj.DocumentRequestDateTime__c;
        registCase.SendingMaterials__c                      = parentCaseObj.SendingMaterials__c;
        registCase.DocumentDliveryDate__c                   = parentCaseObj.DocumentDliveryDate__c;
        registCase.Pledge__c                                = parentCaseObj.Pledge__c;
        registCase.SlipIssuancePerson__c                    = parentCaseObj.SlipIssuancePerson__c;
        registCase.carNo__c                                 = parentCaseObj.carNo__c;
        registCase.AddVehicleUser__c                        = parentCaseObj.AddVehicleUser__c;
        registCase.VehicleInsurance__c                      = parentCaseObj.VehicleInsurance__c;
        registCase.carOwner__c                              = parentCaseObj.carOwner__c;
        registCase.carBodyNo__c                             = parentCaseObj.carBodyNo__c;
        registCase.carType__c                               = parentCaseObj.carType__c;
        registCase.RefundAccount2__c                        = parentCaseObj.RefundAccount2__c;
        registCase.RefundAccountCheck__c                    = parentCaseObj.RefundAccountCheck__c;
        registCase.RefundAccount__c                         = parentCaseObj.RefundAccount__c;
        registCase.AdditionalCase__c                        = parentCaseObj.AdditionalCase__c;
        registCase.DischargeHospital__c                     = parentCaseObj.DischargeHospital__c;
        registCase.DischargeHospitalSpecialContractAf__c    = parentCaseObj.DischargeHospitalSpecialContractAf__c;
        registCase.DischargeDate__c                         = parentCaseObj.DischargeDate__c;
        registCase.DischargeDayRemarks__c                   = parentCaseObj.DischargeDayRemarks__c;
        registCase.NumberOfBrochuresSent__c                 = parentCaseObj.NumberOfBrochuresSent__c;
        registCase.ShippingAddressEtc__c                    = parentCaseObj.ShippingAddressEtc__c;
        registCase.DeliveryAddress__c                       = parentCaseObj.DeliveryAddress__c;
        registCase.DestinationCategory__c                   = parentCaseObj.DestinationCategory__c;
        registCase.DestinationAddress__c                    = parentCaseObj.DestinationAddress__c;
        registCase.SendingMethod__c                         = parentCaseObj.SendingMethod__c;
        registCase.PresentationDocumentIncluded__c          = parentCaseObj.PresentationDocumentIncluded__c;
        registCase.SendingProducts__c                       = parentCaseObj.SendingProducts__c;
        registCase.NumberOfSentApplications__c              = parentCaseObj.NumberOfSentApplications__c;
        registCase.HospitalRemarks__c                       = parentCaseObj.HospitalRemarks__c;
        registCase.OutpatientRide__c                        = parentCaseObj.OutpatientRide__c;
        registCase.HospitalSpecialContractAfterReducti__c   = parentCaseObj.HospitalSpecialContractAfterReducti__c;
        registCase.CooperationContents__c                   = parentCaseObj.CooperationContents__c;
        registCase.Serialization__c                         = parentCaseObj.Serialization__c;
        registCase.contactInformation__c                    = parentCaseObj.contactInformation__c;
        registCase.WaitingForAReport__c                     = parentCaseObj.WaitingForAReport__c;
        registCase.BereavedFamilyInformation__c             = parentCaseObj.BereavedFamilyInformation__c;
        registCase.NumberOfCopies__c                        = parentCaseObj.NumberOfCopies__c;
        registCase.PostNumber__c                            = parentCaseObj.PostNumber__c;
        registCase.Prefecture__c                            = parentCaseObj.Prefecture__c;
        registCase.KanaPrefecture__c                        = parentCaseObj.KanaPrefecture__c;
        registCase.BankCode__c                              = parentCaseObj.BankCode__c;
        registCase.FinancialName__c                         = parentCaseObj.FinancialName__c;
        registCase.RecordingTarget__c                       = parentCaseObj.RecordingTarget__c;
        registCase.RecordingCheckDate__c                    = parentCaseObj.RecordingCheckDate__c;
        registCase.CollectionStatus__c                      = parentCaseObj.CollectionStatus__c;
        registCase.ScheduledCollectionDate__c               = parentCaseObj.ScheduledCollectionDate__c;
        registCase.ScheduledCollectionTime__c               = parentCaseObj.ScheduledCollectionTime__c;
        registCase.TelAcceptCompnDate__c                    = parentCaseObj.TelAcceptCompnDate__c;
        registCase.tel1__c                                  = parentCaseObj.tel1__c;
        registCase.TEL2__c                                  = parentCaseObj.TEL2__c;
        registCase.DepositCategory__c                       = parentCaseObj.DepositCategory__c;
        registCase.CustomerNumber__c                        = parentCaseObj.CustomerNumber__c;
        registCase.AlcoholConsumption__c                    = parentCaseObj.AlcoholConsumption__c;
        registCase.HighlySevereCare__c                      = parentCaseObj.HighlySevereCare__c;
        registCase.icd10__c                                 = parentCaseObj.icd10__c;
        registCase.ChangedMailAddress__c                    = parentCaseObj.ChangedMailAddress__c;
        registCase.CancellationDate__c                      = parentCaseObj.CancellationDate__c;
        registCase.RegistrationAccountConversionPropriety__c= parentCaseObj.RegistrationAccountConversionPropriety__c;
        registCase.FinancialInstitutionsName__c             = parentCaseObj.FinancialInstitutionsName__c;
        registCase.DepositTypePayment__c                    = parentCaseObj.DepositTypePayment__c;
        registCase.AccountHolderPaymentKana__c              = parentCaseObj.AccountHolderPaymentKana__c;
        registCase.InterruptionCertificateRequirement__c    = parentCaseObj.InterruptionCertificateRequirement__c;
        registCase.CancellationReason__c                    = parentCaseObj.CancellationReason__c;
        registCase.PersonConcernedOrOtherName__c            = parentCaseObj.PersonConcernedOrOtherName__c;
        registCase.BranchNamePayment__c                     = parentCaseObj.BranchNamePayment__c;
        registCase.AccountNumberPayment__c                  = parentCaseObj.AccountNumberPayment__c;
        registCase.AccountHolderPayment__c                  = parentCaseObj.AccountHolderPayment__c;

        //20190802 修正開始
        //registCase.IsClosedOnCreate                         = parentCaseObj.IsClosedOnCreate;        
        registCase.FirstSecondThird__c                      = parentCaseObj.FirstSecondThird__c;
        registCase.SevenSpecialContractFront__c             = parentCaseObj.SevenSpecialContractFront__c;
        registCase.HasNGAgency__c                           = parentCaseObj.HasNGAgency__c;
        registCase.BeforeHospitalizationSpecialContract__c  = parentCaseObj.BeforeHospitalizationSpecialContract__c;
        registCase.CancerTreaty__c                          = parentCaseObj.CancerTreaty__c; 
        registCase.PatternType__c                           = parentCaseObj.PatternType__c;
        registCase.OtherOrder__c                            = parentCaseObj.OtherOrder__c;
        registCase.OtherOrderDocFlag__c                     = parentCaseObj.OtherOrderDocFlag__c;
        registCase.OtherOrderFlag__c                        = parentCaseObj.OtherOrderFlag__c;
        registCase.AgentPostalNumber__c                     = parentCaseObj.AgentPostalNumber__c;
        registCase.AgentPrefectures__c                      = parentCaseObj.AgentPrefectures__c;
        registCase.AgentNameKana__c                         = parentCaseObj.AgentNameKana__c;
        registCase.AgentName__c                             = parentCaseObj.AgentName__c;
        registCase.AddressSearch__c                         = parentCaseObj.AddressSearch__c;
        registCase.RequestContents__c                       = parentCaseObj.RequestContents__c;
        registCase.Processing__c                            = parentCaseObj.Processing__c;
        registCase.AfterMailAddress__c                      = parentCaseObj.AfterMailAddress__c;
        registCase.AfterAddress__c                          = parentCaseObj.AfterAddress__c;
        registCase.AfterNameKana__c                         = parentCaseObj.AfterNameKana__c;
        registCase.AfterNameKanji__c                        = parentCaseObj.AfterNameKanji__c;
        registCase.AfterTel__c                              = parentCaseObj.AfterTel__c;
        registCase.Changes__c                               = parentCaseObj.Changes__c;
        registCase.AcuteTreatyBeforeDeduction_del__c        = parentCaseObj.AcuteTreatyBeforeDeduction_del__c;
        registCase.ReductionRemarks__c                      = parentCaseObj.ReductionRemarks__c;
        registCase.VoyageFrom__c                            = parentCaseObj.VoyageFrom__c;
        registCase.VoyageTo__c                              = parentCaseObj.VoyageTo__c;
        registCase.FireInsuranceLocation__c                 = parentCaseObj.FireInsuranceLocation__c;
        registCase.ChangeFireInsuranceLocation__c           = parentCaseObj.ChangeFireInsuranceLocation__c;
        registCase.FireInsuranceLocationPostNumber__c       = parentCaseObj.FireInsuranceLocationPostNumber__c;
        registCase.Notices__c                               = parentCaseObj.Notices__c;
        registCase.DiseaseNameSearch__c                     = parentCaseObj.DiseaseNameSearch__c;
        registCase.ShippingInfoChangeUser__c                = parentCaseObj.ShippingInfoChangeUser__c;
        registCase.ShippingChangeInfo__c                    = parentCaseObj.ShippingChangeInfo__c;
        registCase.DeliveryDocuments__c                     = parentCaseObj.DeliveryDocuments__c;
        registCase.SendingReason__c                         = parentCaseObj.SendingReason__c;
        registCase.FinancialInstitutionSesrch__c            = parentCaseObj.FinancialInstitutionSesrch__c;

        //20190802 修正終了
        
        return registCase;
    }
    
    /* 親ケースの全項目取得（数式項目は除外）*/
    private Case getCaseByCaseId(Id caseId){
        Case caseObj = [
            SELECT
                 ID
                ,DrinkingDay__c
                ,DrinkingDate__c
                ,AmountOfAlcoholConsumed__c
                ,ThreeMajorDisease__c
                ,SevenDiseaseRide__c
                ,SevenSpecialAfter__c
                ,AGRegistrationChange__c
                ,CALLFD__c
                ,CCInputField__c
                ,DMNotApplicableFlag__c
                ,fax__c
                ,ID__c
                ,mgPlanChg__c
                ,mgPlanSelect__c
                ,RLCRegistrationChange__c
                ,VOC__c
                ,SuppliedEmail
                ,SuppliedCompany
                ,SuppliedName
                ,SuppliedPhone
                ,WebSite__c
                ,NumberCancerSupport__c
                ,NumberHospitalizationSupport__c
                ,NumberWomenSupport__c
                ,NumberSmart__c
                ,NumberSmart2__c
                ,NumberSuper2000__c
                ,NumberCancerInsurance__c
                ,NumberToRelyOn__c
                ,NumberSuper__c
                ,NumberTermInsurance__c
                ,NumberLove__c
                ,NumberLong__c
                ,ApplicationNumberGeneralBrochure__c
                ,ForgetfulUse__c
                ,BodyInsurancePersonalAssist__c
                ,CancerHospitalizationride__c
                ,AfterHospitalizationSpecialContract__c
                ,CancerRide__c
                ,AfterCancerSpecialContractReduction__c
                ,CarInsuranceASAP__c
                ,CarInsurancePAP__c
                ,consider__c
                ,OtherDetail2__c
                ,OtherDetail__c
                ,DirectOwnership__c
                ,JapanPostSymbol__c
                ,ApartmentName__c
                ,EscalationContent__c
                ,EscalationDateAndTime__c
                ,IsEscalated
                ,CreatedDate
                ,CancerMedicalAnnouncement__c
                ,ClosedDate
                ,OwnerId
                ,SourceId
                ,RecordTypeId
                ,comment2__c
                ,comment3__c
                ,comment4__c
                ,comment5__c
                ,comment__c
                ,JuniorRider__c
                ,BackOfficeEntryField__c
                ,FormID__c
                ,ContractFuriName__c
                ,PetName__c
                ,PetAge__c
                ,petDeathDate__c
                ,PetDeathDateConfirmation__c
                ,PaperlessContent__c
                ,HormonalTreatment__c
                ,MicrochipNumber__c
                ,MicroChipAttached__c
                ,MiddleOfficeEntryField__c
                ,EmailPermission__c
                ,ModuleID__c
                ,RetentionFailure__c
                ,RetentionSuccess__c
                ,LivingNeedsRide__c
                ,LinkCode__c
                ,Lead__c
                ,LeadRecordType__c
                ,LeisureInsuranceGolfType__c
                ,LeisureInsurance__c
                ,ReportCategory2__c
                ,ReportCategory1__c
                ,ReportCategory3__c
                ,PrimaryReceptionNumber__c
                ,Chome__c
                ,LocationOfTheAccident__c
                ,AccidentContents__c
                ,AccidentReceptionDate__c
                ,AccidentDay__c
                ,AccidentTime__c
                ,memo__c
                ,OtherSecuritiesNumber1__c
                ,OtherSecuritiesNumber2__c
                ,OtherSecuritiesNumber3__c
                ,OtherSecuritiesNumber4__c
                ,OtherSecuritiesNumber5__c
                ,AgencyAssignedDate__c
                ,AgencyAssignmentSituation__c
                ,AgentCode__c
                ,ChangeAgencyRegistration__c
                ,CaseSubject__c
                ,Subject
                ,HomeInsuranceSuperJump__c
                ,HomeInsuranceHomeAssist__c
                ,HomeInsuranceLivingAssist__c
                ,StreetAddress__c
                ,Address1__c
                ,Address2__c
                ,AddressChangePresenceOrAbsence2__c
                ,AddressChangePresenceOrAbsence__c
                ,AddressKana__c
                ,IsClosedOnCreate
                ,CreatedById
                ,InsuranceSubscription__c
                ,InsuranceStart__c
                ,InsuranceFee__c
                ,PeriodOfInsurance__c
                ,InsuranceItem__c
                ,EndOfInsurance__c
                ,Remarks__c
                ,NameOfInjuryOrIllness__c
                ,DateOfInjuryAccidentDay__c
                ,Priority
                ,AdvancedMedical__c
                ,RelatedTreatmentSpecial__c
                ,HospitalizationDate__c
                ,HospitalizationDay2__c
                ,HospitalizationRemarks__c
                ,NumberOfHospitalDays__c
                ,DateOfArrival__c
                ,IncomingCallsRoute__c
                ,ReissueDocuments__c
                ,RetransmissionFlag__c
                ,ResendDocuments__c
                ,ResendDocumentsWeb__c
                ,ResendDocumentsUpdatedNew__c
                ,RetransmissionReason__c
                ,firstInputYear__c
                ,firstInputMonth__c
                ,DeleteFlag__c
                ,Previous__c
                ,PrerequisitCase__c
                ,PrerequisiteDateTime__c
                ,RecruiterName__c
                ,RecruiterNumber__c
                ,RecruiterRegistration__c
                ,Division__c
                ,Reason
                ,AntiCompanyFlag__c
                ,AccountId
                ,DealerName__c
                ,Description
                ,Receptionist__c
                ,Jnjury__c
                ,ReceiptRating__c
                ,AccountHolderKana__c
                ,AccountHolderKanji__c
                ,accountNumber__c
                ,ConsentMattersuidance__c
                ,CancelCancellationOnTheSameDay__c
                ,ProductName__c
                ,Product__c
                ,BusinessTalk__c
                ,InquirySummary__c
                ,InquiryContents__c
                ,SalesRepresentative__c
                ,BusinessHoursId
                ,EarthquakeInsurance__c
                ,Reporter__c
                ,ReporterTEL__c
                ,ReporterName__c
                ,ChangePlan__c
                ,beforeAddress__c
                ,beforePostCode__c
                ,Field3__c
                ,ChangedPremium__c
                ,FirstYearRegistrationDateAFterChang__c
                ,ChangedModel__c
                ,ChangedDisplacement__c
                ,AfterUseCarModels__c
                ,carNoAfter__c
                ,AFterAddingAVehicleUser__c
                ,carOwnerAfter__c
                ,carDeliveryDay__c
                ,carPriceAfter__c
                ,carBodyNoAfter__c
                ,carTypeAfter__c
                ,ChangeReason__c
                ,ContractReference__c
                ,ContractManagementNumber__c
                ,RelationshipWithContractor__c
                ,ContractorReporterRelationship__c
                ,RelationshipWithTheOtherParty__c
                ,AfterRenameKana__c
                ,AfterRenameKanzi__c
                ,ContactId
                ,ContractorNameKana__c
                ,ContrameKanactorLastNa__c
                ,ContractLiabilityStartDate__c
                ,AutoCreateChildCaseDateTime__c
                ,CorrespondenceRequest__c
                ,Correspondence2__c
                ,Correspondence__c
                ,class__c
                ,CorrespondenceClassificationContents__c
                ,CorrespondenceColumn1__c
                ,CorrespondenceColumn2__c
                ,CorrespondenceColumn3__c
                ,CorrespondingFlag__c
                ,type__c
                ,TargetContractName__c
                ,TargetEndorsementNumber1__c
                ,TargetEndorsementNumber2__c
                ,TargetEndorsementNumber3__c
                ,Field4TargetEndorsementNumber4__c
                ,TargetEndorsementNumber5__c
                ,FaceConsultationIntentionFlag__c
                ,littleContractReference__c
                ,Municipality__c
                ,CityGroupKana__c
                ,Municipalities__c
                ,Form__c
                ,ReportGroup__c
                ,age__c
                ,AdCode__c
                ,BuildingName__c
                ,InitialProposal__c
                ,Rear__c
                ,AcuteMyocardialInfarct__c
                ,AcuteTreatyAfterReduction__c
                ,StartingCompany__c
                ,Originator__c
                ,OriginationDepartment__c
                ,ProcedureContents__c
                ,ProcedureType__c
                ,SubjectMatter__c
                ,SurgeryName__c
                ,SurgeryDate__c
                ,payChange__c
                ,payMethodChange__c
                ,AnticancerDrugTreatment__c
                ,ReturnDestinationName__c
                ,DesiredDateForReturn__c
                ,Return__c
                ,DesignatedProxyRide__c
                ,NonLifeInsuranceContractName__c
                ,damageContractReference__c
                ,DegreeOfDamage__c
                ,BranchCodeStoreNumber__c
                ,BranchName__c
                ,Payment__c
                ,Radiotherapy__c
                ,ReferenceNumber__c
                ,NewRecipientNominationKana__c
                ,NewRecipientNominationKanzi__c
                ,NewPayeeNameKana__c
                ,NewPayeeKanaSurname__c
                ,NewPayeeName__c
                ,NewPayeeSurname__c
                ,NewBeneficiaryBirthday__c
                ,SuppleIncident__c
                ,UpdateRefusalAcceptance__c
                ,updateMonth__c
                ,NoNeedToSendDocuments__c
                ,DocumentShippingDate__c
                ,SendDocument__c
                ,LastModifiedById
                ,FinalResult__c
                ,FinalResultReason__c
                ,EndOfTheMonth__c
                ,SimultaneousChanges__c
                ,AfterMinorRevisionKana__c
                ,AfterMinorevisionKanzi__c
                ,Identification__c
                ,IdentityVerificationOthers__c
                ,ConditionalCancellation__c
                ,CallingID__c
                ,ConnectionStopID__c
                ,ProjectsEnd__c
                ,ContentsOfGuidance__c
                ,rakutenid__c
                ,RakutenIPLinkedFlag__c
                ,RakutenLifepluscancerSupport__c
                ,RakutenLifeplusHospitalizationSupport__c
                ,RakutenLifeplusWomenSupport__c
                ,RakutenLifeToRelyOn__c
                ,RakutenLifeSmart__c
                ,RakutenLifeSmart2__c
                ,RakutenLifeplusSuper2000__c
                ,RakutenLifeplusCancerInsurance__c
                ,RakutenLifeplusToRelyOn__c
                ,RakutenLifeplusSuper__c
                ,RakutenLifeplusTermInsurance__c
                ,RakutenLifeLove__c
                ,RakutenLifeLong__c
                ,Overview__c
                ,CauseOfDeath__c
                ,DeathDate__c
                ,PresenceOrAbsenceOfDeathCertificate__c
                ,ReductionBefore__c
                ,ReductionAfter__c
                ,BeforeReduction__c
                ,AfterReduction__c
                ,DisasterCause__c
                ,SpecificDamage__c
                ,Status
                ,CurrentRecipientName__c
                ,CurrentRecipientNameSurname__c
                ,LifeInsuranceMutualAid__c
                ,lifeContractReference__c
                ,AppLicationModel__c
                ,ProposalContent__c
                ,ReasonForProposal__c
                ,NameOfferer__c
                ,ApplicationNumberIssued__c
                ,ApplicationTerminal__c
                ,ApplicationElapsedDays__c
                ,TownName__c
                ,TransferDateReceivedDate__c
                ,FixedSymptoms__c
                ,Origin
                ,DevelopmentalPathways__c
                ,Issue__c
                ,shippingMethod__c
                ,DateOfShipment__c
                ,RegisteredDate__c
                ,PartnerName__c
                ,ContactsOfTheOtherParty__c
                ,Heir__c
                ,Inquiry__c
                ,ReceivedNumber__c
                ,PlanfRelocationDate__c
                ,Type
                ,FundedInsuranceSuperJump__c
                ,AssetId
                ,Process__c
                ,ContinuingDiscountRide__c
                ,ContinuationProposal__c
                ,OtherPattern__c
                ,GeneralBrochure__c
                ,ComplaintsFlag__c
                ,ComplaintSummary__c
                ,ComplaintHistory__c
                ,NewBeneficiary__c
                ,CurrentRecipientRelationship__c
                ,RelationshipWithInsured__c
                ,ParentId
                ,ParentsLivingTogetherAndSeparated__c
                ,NameOfParentalAuthority__c
                ,ParentNameFullNameKana__c
                ,ParentalAuthorityConfirmation__c
                ,CancellationRefund__c
                ,CancellationDocumentsRequired__c
                ,ReasonForCancellation2__c
                ,CancellationType__c
                ,AgencyName__c
                ,BillingClassification__c
                ,OutOfBillingCharge__c
                ,ReaOnForNotCharging__c
                ,BillingNumber__c
                ,BillingRoute__c
                ,TrafficAccidentPoliceNotification__c
                ,TrafficAccidentPoliceNotification2__c
                ,PoliceSignature__c
                ,DocumentReceptionDate__c
                ,DataRequestID__c
                ,InformationRequestNo__c
                ,DocumentRequestDateTime__c
                ,SendingMaterials__c
                ,DocumentDliveryDate__c
                ,Pledge__c
                ,SlipIssuancePerson__c
                ,carNo__c
                ,AddVehicleUser__c
                ,VehicleInsurance__c
                ,carOwner__c
                ,carBodyNo__c
                ,carType__c
                ,RefundAccount2__c
                ,RefundAccountCheck__c
                ,RefundAccount__c
                ,AdditionalCase__c
                ,DischargeHospital__c
                ,DischargeHospitalSpecialContractAf__c
                ,DischargeDate__c
                ,DischargeDayRemarks__c
                ,NumberOfBrochuresSent__c
                ,ShippingAddressEtc__c
                ,DeliveryAddress__c
                ,DestinationCategory__c
                ,DestinationAddress__c
                ,SendingMethod__c
                ,PresentationDocumentIncluded__c
                ,SendingProducts__c
                ,NumberOfSentApplications__c
                ,HospitalRemarks__c
                ,OutpatientRide__c
                ,HospitalSpecialContractAfterReducti__c
                ,CooperationContents__c
                ,Serialization__c
                ,contactInformation__c
                ,WaitingForAReport__c
                ,BereavedFamilyInformation__c
                ,NumberOfCopies__c
                ,PostNumber__c
                ,Prefecture__c
                ,KanaPrefecture__c
                ,BankCode__c
                ,FinancialName__c
                ,RecordingTarget__c
                ,RecordingCheckDate__c
                ,CollectionStatus__c
                ,ScheduledCollectionDate__c
                ,ScheduledCollectionTime__c
                ,TelAcceptCompnDate__c
                ,tel1__c
                ,TEL2__c
                ,DepositCategory__c
                ,CustomerNumber__c
                ,AlcoholConsumption__c
                ,HighlySevereCare__c
                ,icd10__c
                ,ChangedMailAddress__c
                ,CancellationDate__c
                ,RegistrationAccountConversionPropriety__c
                ,FinancialInstitutionsName__c
                ,DepositTypePayment__c
                ,AccountHolderPaymentKana__c
                ,InterruptionCertificateRequirement__c
                ,CancellationReason__c
                ,PersonConcernedOrOtherName__c
                ,BranchNamePayment__c
                ,AccountNumberPayment__c
                ,AccountHolderPayment__c
                /* 20190802 修正開始 */
                ,FirstSecondThird__c
                ,SevenSpecialContractFront__c
                ,(Select CommentBody from CaseComments)
                ,HasNGAgency__c
                ,BeforeHospitalizationSpecialContract__c
                ,CancerTreaty__c
                ,LaterAddress__c
                ,CanceDiagnosisResponsibilityStart__c
                ,PatternType__c
                ,OtherOrder__c
                ,OtherOrderDocFlag__c
                ,OtherOrderFlag__c
                ,AgentPostalNumber__c
                ,AgentPrefectures__c
                ,AgentNameKana__c
                ,AgentName__c
                ,AddressSearch__c
                ,RequestContents__c
                ,Processing__c
                ,PremiseSituation__c
                ,SubjectAreaBefore__c
                ,AfterMailAddress__c
                ,AfterAddress__c
                ,AfterNameKana__c
                ,AfterNameKanji__c
                ,AfterTel__c
                ,Changes__c
                ,City__c
                ,AcuteTreatyBeforeDeduction_del__c
                ,gender__c
                ,ReductionRemarks__c
                ,VoyageFrom__c
                ,VoyageTo__c
                ,FireInsuranceLocation__c
                ,ChangeFireInsuranceLocation__c
                ,FireInsuranceLocationPostNumber__c
                ,Notices__c
                ,DiseaseNameSearch__c
                ,ShippingInfoChangeUser__c
                ,ShippingChangeInfo__c
                ,DeliveryDocuments__c
                ,SendingReason__c
                ,FinancialInstitutionSesrch__c
                /* 20190802 修正開始 */   
            FROM Case
            WHERE Id = :caseId
        ];
        
        return caseObj;
    }
}