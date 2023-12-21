/*
 * Block comments with details of changes
 */
public class ContractSearchCustomController{

    /** コンストラクタ */
    public ContractSearchCustomController(){}

    public static List<String> LIFECONTRACT_SOQL_ROW 
        = new List<String>{
             'Id'
            //,'POL_NUM__c'           // 保険証券番号
            ,'POLICY_MUTUAL_AID_NUMBER__c' //保険証券番号/会員番号
            ,'APPLICATION_NUM__c'   // 契約申込番号
            ,'INSURANCE_TYPE_DISPLAY__c'    // 保険種類
            ,'Name'                 // 生保商品名
            ,'STATUS_DISPLAY__c'    // 契約ステータス
            ,'INSR_PERIOD__c'       // 保険期間
            ,'CSID__c'              // 顧客番号（CSID）
            ,'KANA_CONTROR_NAME__c' // 契約者名カナ
            ,'KANJI_CONTROR_NAME__c'    // 契約者氏名漢字
            ,'CONTROR_BIRTH_DATE__c'    // 契約者生年月日
            ,'CONTRANT_PHONE__c'    // 契約者 電話番号
            ,'CONTROR_POST_CODE__c' // 契約者 郵便番号
            ,'KANA_INSURED_NAME__c' // 被保険者氏名カナ
            ,'KANJI_INSURED_NAME__c'    // 被保険者名漢字
            ,'INSURED_BIRTH_DATE__c'    // 被保険者生年月日
            ,'AGENCY_NUM__c'        // 代理店番号
            ,'KANJI_AGENCY_NAME__c' // 代理店名
    };
    
    public static List<String> GENERACONTRACT_SOQL_ROW
        = new List<String>{
             'Id'
            ,'InsuraPolicyNo__c'    // 保険証券番号
            ,'ApplicationNumber__c' // 申込番号
            ,'InsuraType__c'        // 保険区分
            ,'Name'                 // 損保商品名
            ,'ContractStatusDisplay__c'    // ステータス
            ,'ContractTerm__c'      // 契約期間（月）
            ,'AccountId__r.CSID__pc'// 取引先．顧客番号（CSID）
            ,'TorihikisakiKana__c'  // 取引先名カナ
            ,'Torihikisakiname__c'  // 取引先名
            ,'TorihikisakiBD__c '   // 取引先生年月日
            ,'PhoneNo__c'           // 自宅電話番号
            ,'PostalCode__c'        // 郵便番号
            ,'InsuredPerson__c'     // 被保険者
            ,'CarNo__c'             // 車両ナンバー
            ,'Agency__c'            // 代理店
            ,'AgencyCode__c'        // 代理店コード
    };
    
    public static List<String> SSCONTRACT_SOQL_ROW
        = new List<String>{
             'Id'
            ,'SubscriberManageNo__c'          // 証券番号
            ,'ApplicationDocumentNo__c' // 申込書番号
            ,'InsuranceType__c'         // 保険種類
            ,'Name'                     // 少短商品名
//            ,'SubscriberStatusDisply__c'// 契約状態
            ,'SubscriberStatusLabel__c' // 契約状態
            ,'InsurancePeriod__c'       // 保険期間
            ,'AccountId__r.CSID__pc'    // 取引先．顧客番号（CSID）
            ,'SubscriberNameKana__c'    // 契約者名（カナ）
            ,'SubscriberNameKanji__c'   // 契約者名（漢字）
            ,'SubscriberBirthdate__c' // 契約者生年月日
            ,'SubscriberTel__c'                 // 電話番号
            ,'SubscriberZipcode__c'  // 契約者郵便番号
            ,'InsuredKana__c'       // 被保険者１（カナ）
            ,'InsuredKanji__c'      // 被保険者１（漢字）
            ,'InsuredBirthdate__c'      // 被保険者１_生年月日
            ,'InsuranceTarget_1__c'     // ペット名（名前）
            ,'AgencyCode__c'            // 代理店CD
            ,'AgencyName__c'        // 代理店名
    };
    
    /* 画面表示用クラス */
    public class DTO {
        /* レコードID */ @AuraEnabled
        public String contractId {get; set;}
        /* 証券番号 */ @AuraEnabled
        public String insuraPolicyNo {get; set;}
        /* 申込書番号 */ @AuraEnabled
        public String applicationNumber {get; set;}
        /* 保険種目 */ @AuraEnabled
        public String insuraType {get; set;}
        /* 商品名 */ @AuraEnabled
        public String name {get; set;}
        /* ステータス */ @AuraEnabled
        public String status {get; set;}
        /* 保険期間 */ @AuraEnabled
        public String contractTerm {get; set;}
        /* 顧客ID */ @AuraEnabled
        public String CSID {get; set;}
        /* 契約者名カナ（姓名）*/ @AuraEnabled
        public String contractorNameKana {get; set;}
        /* 契約者名漢字（姓名）*/ @AuraEnabled
        public String contractorNameKanji {get; set;}
        /* 契約者生年月日（西暦）*/ @AuraEnabled
        public String subscriberDateOfBirth {get; set;}
        /* 電話番号 */ @AuraEnabled
        public String phone {get; set;}
        /* 郵便番号 */ @AuraEnabled
        public String postalCode {get; set;}
        /* 被保険者名カナ（姓名）*/ @AuraEnabled
        public String insuredNameKana {get; set;}
        /* 被保険者名漢字（姓名）*/ @AuraEnabled
        public String insuredNameKanji {get; set;}
        /* 被保険者生年月日（西暦）*/ @AuraEnabled
        public String insuredBirthdate {get; set;}
        /* 被保険体（ペット名）*/ @AuraEnabled
        public String insuredBody {get; set;}
        /* 車両ナンバー（損保）*/ @AuraEnabled
        public String carNo {get; set;}
        /* 代理店コード */ @AuraEnabled
        public String agencyCode {get; set;}
        /* 代理店名 */ @AuraEnabled
        public String agency {get; set;}
    }
    public List<DTO> dtos { get; set; }
    
    /* 検索条件値保持クラス */
    public class searchValue {
        /* 証券番号 */ @AuraEnabled
        public String insuraPolicyNo {get; set;}
        /* 申込書番号 */ @AuraEnabled
        public String applicationNumber {get; set;}
        /* 保険種目 */ @AuraEnabled
        public String insuraType {get; set;}
        /* 商品名 */ @AuraEnabled
        public String name {get; set;}
        /* ステータス */ @AuraEnabled
        public String status {get; set;}
        /* 保険期間 */ @AuraEnabled
        public String contractTerm {get; set;}
        /* 顧客ID */ @AuraEnabled
        public String CSID {get; set;}
        /* 契約者名カナ（姓名）*/ @AuraEnabled
        public String contractorNameKana {get; set;}
        /* 契約者名漢字（姓名）*/ @AuraEnabled
        public String contractorNameKanji {get; set;}
        /* 契約者生年月日（西暦）*/ @AuraEnabled
        public String subscriberDateOfBirth {get; set;}
        /* 電話番号 */ @AuraEnabled
        public String phone {get; set;}
        /* 郵便番号 */ @AuraEnabled
        public String postalCode {get; set;}
        /* 被保険者名カナ（姓名）*/ @AuraEnabled
        public String insuredNameKana {get; set;}
        /* 被保険者名漢字（姓名）*/ @AuraEnabled
        public String insuredNameKanji {get; set;}
        /* 被保険者生年月日（西暦）*/ @AuraEnabled
        public String insuredBirthdate {get; set;}
        /* 被保険体（ペット名）*/ @AuraEnabled
        public String insuredBody {get; set;}
        /* 車両ナンバー（損保）*/ @AuraEnabled
        public String carNo {get; set;}
        /* 代理店コード */ @AuraEnabled
        public String agencyCode {get; set;}
        /* 代理店名 */ @AuraEnabled
        public String agency {get; set;}
    }
    @AuraEnabled
    public searchValue sv { get; set; }
    
    /** 初期処理 */
    public void view() {
    }
    
    /** 生保取引先検索 */
    @AuraEnabled
    public static List<DTO> getLifeContract(String insuraPolicyNo, String applicationNumber, String insuraType, String name, String status, String contractTerm, String CSID, String contractorNameKana, String contractorNameKanji, date subscriberDateOfBirth, String phone, String postalCode, String insuredNameKana, String insuredNameKanji, Date insuredBirthdate, String insuredBody, String carNo, String agencyCode, String agency) {
    
        searchValue sv = new searchValue();
        sv.insuraPolicyNo = insuraPolicyNo;
        sv.applicationNumber = applicationNumber;
        sv.insuraType = insuraType;
        sv.name = name;
        sv.status = status;
        sv.contractTerm = contractTerm;
        sv.CSID = CSID;
        sv.contractorNameKana = contractorNameKana;
        sv.contractorNameKanji = contractorNameKanji;
        sv.subscriberDateOfBirth = String.valueOf(subscriberDateOfBirth);
        sv.phone = phone;
        sv.postalCode = postalCode;
        sv.insuredNameKana = insuredNameKana;
        sv.insuredNameKanji = insuredNameKanji;
        sv.insuredBirthdate = String.valueOf(insuredBirthdate);
        sv.insuredBody = insuredBody;
        sv.carNo = carNo;
        sv.agencyCode = agencyCode;
        sv.agency = agency;
        
        // 検索条件取得
        List<String> whereRows = getSearchWhere('L', sv);
    
        String soql = getSoql(LIFECONTRACT_SOQL_ROW, 'LifeContract__c', whereRows, null, 200);
        LifeContract__c[] contracts = database.query(soql);
    
        List<DTO> dtos = new List<DTO>();
        for(LifeContract__c c : contracts) {
            DTO d = new DTO();
    
            d.contractId = c.Id;
            //d.insuraPolicyNo = c.POL_NUM__c;
            d.insuraPolicyNo = c.POLICY_MUTUAL_AID_NUMBER__c;
            d.applicationNumber = c.APPLICATION_NUM__c;
            d.insuraType = c.INSURANCE_TYPE_DISPLAY__c;
            d.name = c.Name;
            d.status = c.STATUS_DISPLAY__c;
            d.contractTerm = c.INSR_PERIOD__c;
            d.CSID = c.CSID__c;
            d.contractorNameKana = c.KANA_CONTROR_NAME__c;
            d.contractorNameKanji = c.KANJI_CONTROR_NAME__c;
            d.subscriberDateOfBirth = c.CONTROR_BIRTH_DATE__c;
            d.phone = c.CONTRANT_PHONE__c;
            d.postalCode = c.CONTROR_POST_CODE__c;
            d.insuredNameKana = c.KANA_INSURED_NAME__c;
            d.insuredNameKanji = c.KANJI_INSURED_NAME__c;
            d.insuredBirthdate = c.INSURED_BIRTH_DATE__c;
            d.agencyCode = c.AGENCY_NUM__c;
            d.agency = c.KANJI_AGENCY_NAME__c;
    
            dtos.add(d);
        }
    
        return dtos;
    }
    
    /** 損保取引先検索 */
    @AuraEnabled
    public static List<DTO> getDamageContract(String insuraPolicyNo, String applicationNumber, String insuraType, String name, String status, String contractTerm, String CSID, String contractorNameKana, String contractorNameKanji, date subscriberDateOfBirth, String phone, String postalCode, String insuredNameKana, String insuredNameKanji, Date insuredBirthdate, String insuredBody, String carNo, String agencyCode, String agency) {
    
        searchValue sv = new searchValue();
        sv.insuraPolicyNo = insuraPolicyNo;
        sv.applicationNumber = applicationNumber;
        sv.insuraType = insuraType;
        sv.name = name;
        sv.status = status;
        sv.contractTerm = contractTerm;
        sv.CSID = CSID;
        sv.contractorNameKana = contractorNameKana;
        sv.contractorNameKanji = contractorNameKanji;
        sv.subscriberDateOfBirth = String.valueOf(subscriberDateOfBirth);
        sv.phone = phone;
        sv.postalCode = postalCode;
        sv.insuredNameKana = insuredNameKana;
        sv.insuredNameKanji = insuredNameKanji;
        sv.insuredBirthdate = String.valueOf(insuredBirthdate);
        sv.insuredBody = insuredBody;
        sv.carNo = carNo;
        sv.agencyCode = agencyCode;
        sv.agency = agency;
    
        // 検索条件取得
        List<String> whereRows = getSearchWhere('G', sv);
    
        String soql = getSoql(GENERACONTRACT_SOQL_ROW, 'DamageContract__c', whereRows, null, 200);
        DamageContract__c[] contracts = database.query(soql);
    
        List<DTO> dtos = new List<DTO>();
    
        for(DamageContract__c c : contracts) {
            DTO d = new DTO();
    
            d.contractId = c.Id;
            d.insuraPolicyNo = c.InsuraPolicyNo__c;
            d.applicationNumber = c.ApplicationNumber__c;
            d.insuraType = c.InsuraType__c;
            d.name = c.Name;
            d.status = c.ContractStatusDisplay__c;
            d.contractTerm = c.ContractTerm__c;
            d.CSID = c.AccountId__r.CSID__pc;
            d.contractorNameKana = c.TorihikisakiKana__c;
            d.contractorNameKanji = c.Torihikisakiname__c;
            d.subscriberDateOfBirth = c.TorihikisakiBD__c ;
            d.phone = c.PhoneNo__c;
            d.postalCode = c.PostalCode__c;
            d.insuredNameKanji = c.InsuredPerson__c;
            d.carNo = c.CarNo__c;
            d.agency = c.Agency__c;
            d.agencyCode = c.AgencyCode__c;
    
            dtos.add(d);
        }
    
        return dtos;
    }
    
    /** 少短取引先検索 */
    @AuraEnabled
    public static List<DTO> getLittleContract(String insuraPolicyNo, String applicationNumber, String insuraType, String name, String status, String contractTerm, String CSID, String contractorNameKana, String contractorNameKanji, date subscriberDateOfBirth, String phone, String postalCode, String insuredNameKana, String insuredNameKanji, Date insuredBirthdate, String insuredBody, String carNo, String agencyCode, String agency) {
    
        searchValue sv = new searchValue();
        sv.insuraPolicyNo = insuraPolicyNo;
        sv.applicationNumber = applicationNumber;
        sv.insuraType = insuraType;
        sv.name = name;
        sv.status = status;
        sv.contractTerm = contractTerm;
        sv.CSID = CSID;
        sv.contractorNameKana = contractorNameKana;
        sv.contractorNameKanji = contractorNameKanji;
        sv.subscriberDateOfBirth = String.valueOf(subscriberDateOfBirth);
        sv.phone = phone;
        sv.postalCode = postalCode;
        sv.insuredNameKana = insuredNameKana;
        sv.insuredNameKanji = insuredNameKanji;
        sv.insuredBirthdate = String.valueOf(insuredBirthdate);
        sv.insuredBody = insuredBody;
        sv.carNo = carNo;
        sv.agencyCode = agencyCode;
        sv.agency = agency;
    
        // 検索条件取得
        List<String> whereRows = getSearchWhere('S', sv);
    
        String soql = getSoql(SSCONTRACT_SOQL_ROW, 'LittleContract__c', whereRows, null, 200);
        LittleContract__c[] contracts = database.query(soql);
    
        List<DTO> dtos = new List<DTO>();
    
        for(LittleContract__c c : contracts) {
            DTO d = new DTO();
    
            d.contractId = c.Id;
            d.insuraPolicyNo = c.SubscriberManageNo__c;
            d.applicationNumber = c.ApplicationDocumentNo__c;
            d.insuraType = c.InsuranceType__c;
            d.name = c.Name;
//            d.status = c.SubscriberStatusDisply__c;
            d.status = c.SubscriberStatusLabel__c;
            d.contractTerm = c.InsurancePeriod__c;
            d.CSID = c.AccountId__r.CSID__pc;
            d.contractorNameKana = c.SubscriberNameKana__c;
            d.contractorNameKanji = c.SubscriberNameKanji__c;
            d.subscriberDateOfBirth = String.valueOf(c.SubscriberBirthdate__c);
            d.phone = c.SubscriberTel__c;
            d.postalCode = c.SubscriberZipcode__c;
            d.insuredNameKana = c.InsuredKana__c;
            d.insuredNameKanji = c.InsuredKanji__c;
            d.insuredBirthdate = c.InsuredBirthdate__c;
            d.insuredBody = c.InsuranceTarget_1__c;
            d.agencyCode = c.AgencyCode__c;
            d.agency = c.AgencyName__c;
    
            dtos.add(d);
        }
    
        return dtos;
    }
    
    /**
     * 検索条件取得
     * 各条件からWhere句リストを作成し返却する。
     * @param searchType 検索区分（L=生保、G=損保=、S=少短)
     * @return List<String> Where句リスト
    **/
    public static List<String> getSearchWhere(String searchType, searchValue sv) {
        List<String> whereRows = new List<String>();
        if(searchType == 'L') {
            if(String.isNotBlank(sv.insuraPolicyNo)){
                // 証券番号
                String insuraPolicyNo = String.escapeSingleQuotes(sv.insuraPolicyNo);
                //whereRows.add('POL_NUM__c = \'' + insuraPolicyNo + '\'');
                whereRows.add('POLICY_MUTUAL_AID_NUMBER__c = \'' + insuraPolicyNo + '\'');                
            }
            if(String.isNotBlank(sv.applicationNumber)) {
                // 申込者番号
                String applicationNumber = String.escapeSingleQuotes(sv.applicationNumber);
                whereRows.add('APPLICATION_NUM__c = \'' + applicationNumber + '\'');
            }
            if(String.isNotBlank(sv.insuraType)) {
                // 保険種目
                String insuraType = String.escapeSingleQuotes(sv.insuraType);
                /*** 本番00090 FIX START ***/
                //whereRows.add('INSURANCE_TYPE__c like \'' + insuraType + '%\'');
                whereRows.add('INSURANCE_TYPE_DISPLAY__c like \'' + insuraType + '%\'');
                /*** 本番00090 FIX END ****/
            }
            if(String.isNotBlank(sv.name)) {
                // 商品名
                String name = String.escapeSingleQuotes(sv.name);
                whereRows.add('name = \'' + name + '\'');
            }
            if(String.isNotBlank(sv.status)) {
                // ステータス
                String status = String.escapeSingleQuotes(sv.status);
                whereRows.add('STATUS_DISPLAY__c = \'' + status + '\'');
            }
            if(String.isNotBlank(sv.contractTerm)) {
                // 保険期間
                String contractTerm = String.escapeSingleQuotes(sv.contractTerm);
                whereRows.add('INSR_PERIOD__c = \'' + contractTerm + '\'');
            }
            if(String.isNotBlank(sv.CSID)) {
                // 顧客ID
                String CSID = String.escapeSingleQuotes(sv.CSID);
                whereRows.add('CSID__c = \'' + CSID + '\'');
            }
            if(String.isNotBlank(sv.contractorNameKana)) {
                // 契約者名カナ（姓名）
                String contractorNameKana = String.escapeSingleQuotes(sv.contractorNameKana);
                whereRows.add('KANA_CONTROR_NAME__c like \'' + contractorNameKana + '%\'');
            }
            if(String.isNotBlank(sv.contractorNameKanji)) {
                // 契約者名漢字（姓名）
                String contractorNameKanji = String.escapeSingleQuotes(sv.contractorNameKanji);
                whereRows.add('KANJI_CONTROR_NAME__c like \'' + contractorNameKanji + '%\'');
            }
            if(String.isNotBlank(sv.subscriberDateOfBirth)) {
                // 契約者生年月日（西暦）
                String subscriberDateOfBirth = String.escapeSingleQuotes(sv.subscriberDateOfBirth);
                whereRows.add('CONTROR_BIRTH_DATE__c = \'' + subscriberDateOfBirth + '\'');
            }
            if(String.isNotBlank(sv.phone)) {
                // 電話番号
                String phone = String.escapeSingleQuotes(sv.phone);
                whereRows.add('CONTRANT_PHONE__c = \'' + phone + '\'');
            }
            if(String.isNotBlank(sv.postalCode)) {
                // 郵便番号
                String postalCode = String.escapeSingleQuotes(sv.postalCode);
                whereRows.add('CONTROR_POST_CODE__c = \'' + postalCode + '\'');
            }
            if(String.isNotBlank(sv.insuredNameKana)) {
                // 被保険者名カナ（姓名）
                String insuredNameKana = String.escapeSingleQuotes(sv.insuredNameKana);
                whereRows.add('KANA_INSURED_NAME__c like \'' + insuredNameKana + '%\'');
            }
            if(String.isNotBlank(sv.insuredNameKanji)) {
                // 被保険者名漢字（姓名）
                String insuredNameKanji = String.escapeSingleQuotes(sv.insuredNameKanji);
                whereRows.add('KANJI_INSURED_NAME__c like \'' + insuredNameKanji + '%\'');
            }
            if(String.isNotBlank(sv.insuredBirthdate)) {
                // 被保険者生年月日（西暦）
                String insuredBirthdate = String.escapeSingleQuotes(sv.insuredBirthdate);
                whereRows.add('INSURED_BIRTH_DATE__c = \'' + insuredBirthdate + '\'');
            }
            if(String.isNotBlank(sv.agencyCode)) {
                // 代理店コード
                String agencyCode = String.escapeSingleQuotes(sv.agencyCode);
                whereRows.add('AGENCY_NUM__c = \'' + agencyCode + '\'');
            }
            if(String.isNotBlank(sv.agency)) {
                // 代理店名
                String agency = String.escapeSingleQuotes(sv.agency);
                whereRows.add('KANJI_AGENCY_NAME__c like \'' + agency + '%\'');
            }
        }
        if(searchType == 'G') {
            if(String.isNotBlank(sv.insuraPolicyNo)){
                // 証券番号
                String insuraPolicyNo = String.escapeSingleQuotes(sv.insuraPolicyNo);
                whereRows.add('InsuraPolicyNo__c = \'' + insuraPolicyNo + '\'');
            }
            if(String.isNotBlank(sv.applicationNumber)) {
                // 申込者番号
                String applicationNumber = String.escapeSingleQuotes(sv.applicationNumber);
                whereRows.add('ApplicationNumber__c = \'' + applicationNumber + '\'');
            }
            if(String.isNotBlank(sv.insuraType)) {
                // 保険種目
                String insuraType = String.escapeSingleQuotes(sv.insuraType);
                whereRows.add('InsuraType__c like \'' + insuraType + '%\'');
            }
            if(String.isNotBlank(sv.name)) {
                // 商品名
                String name = String.escapeSingleQuotes(sv.name);
                whereRows.add('Name = \'' + name + '\'');
            }
            if(String.isNotBlank(sv.status)) {
                // ステータス
                String status = String.escapeSingleQuotes(sv.status);
                whereRows.add('ContractStatusDisplay__c = \'' + status + '\'');
            }
            if(String.isNotBlank(sv.contractTerm)) {
                // 保険期間
                String contractTerm = String.escapeSingleQuotes(sv.contractTerm);
                whereRows.add('ContractTerm__c = \'' + contractTerm + '\'');
            }
            if(String.isNotBlank(sv.CSID)) {
                // 顧客ID
                String CSID = String.escapeSingleQuotes(sv.CSID);
                whereRows.add('AccountId__r.CSID__pc = \'' + CSID + '\'');
            }
            if(String.isNotBlank(sv.contractorNameKana)) {
                // 契約者名カナ（姓名）
                String contractorNameKana = String.escapeSingleQuotes(sv.contractorNameKana);
                whereRows.add('TorihikisakiKana__c like \'' + contractorNameKana + '%\'');
            }
            if(String.isNotBlank(sv.contractorNameKanji)) {
                // 契約者名漢字（姓名）
                String contractorNameKanji = String.escapeSingleQuotes(sv.contractorNameKanji);
                whereRows.add('Torihikisakiname__c like \'' + contractorNameKanji + '%\'');
            }
            if(String.isNotBlank(sv.subscriberDateOfBirth)) {
                // 契約者生年月日（西暦）
                String subscriberDateOfBirth = String.escapeSingleQuotes(sv.subscriberDateOfBirth);
                whereRows.add('TorihikisakiBD__c = \'' + subscriberDateOfBirth + '\'');
            }
            if(String.isNotBlank(sv.phone)) {
                // 電話番号
                String phone = String.escapeSingleQuotes(sv.phone);
                whereRows.add('PhoneNo__c = \'' + phone + '\'');
            }
            if(String.isNotBlank(sv.postalCode)) {
                // 郵便番号
                String postalCode = String.escapeSingleQuotes(sv.postalCode);
                whereRows.add('PostalCode__c = \'' + postalCode + '\'');
            }
            if(String.isNotBlank(sv.insuredNameKanji)) {
                // 被保険者名漢字（姓名）
                String insuredNameKanji = String.escapeSingleQuotes(sv.insuredNameKanji);
                whereRows.add('InsuredPerson__c like \'' + insuredNameKanji + '%\'');
            }
            if(String.isNotBlank(sv.carNo)) {
                // 車両ナンバー（損保）
                String carNo = String.escapeSingleQuotes(sv.carNo);
                whereRows.add('CarNo__c = \'' + carNo + '\'');
            }
            if(String.isNotBlank(sv.agency)) {
                // 代理店名
                String agency = String.escapeSingleQuotes(sv.agency);
                whereRows.add('Agency__c like \'' + agency + '%\'');
            }
            /*** UAT00250 FIX START */
            if(String.isNotBlank(sv.agencyCode)){
                System.debug('#### sv.agencyCode ' + sv.agencyCode);
                //代理店コード
                String agencyCode = String.escapeSingleQuotes(sv.agencyCode);
                whereRows.add('AgencyCode__c like \'%' + agencyCode + '%\'');
            }
            /*** UAT00250 FIX END */
        }
        if(searchType == 'S') {
            if(String.isNotBlank(sv.insuraPolicyNo)){
                // 証券番号
                String insuraPolicyNo = String.escapeSingleQuotes(sv.insuraPolicyNo);
                whereRows.add('SubscriberManageNo__c = \'' + insuraPolicyNo + '\'');
            }
            if(String.isNotBlank(sv.applicationNumber)) {
                // 申込者番号
                String applicationNumber = String.escapeSingleQuotes(sv.applicationNumber);
                whereRows.add('ApplicationDocumentNo__c = \'' + applicationNumber + '\'');
            }
            if(String.isNotBlank(sv.insuraType)) {
                // 保険種目
                String insuraType = String.escapeSingleQuotes(sv.insuraType);
                whereRows.add('InsuranceType__c like \'' + insuraType + '%\'');
            }
            if(String.isNotBlank(sv.name)) {
                // 商品名
                String name = String.escapeSingleQuotes(sv.name);
                whereRows.add('Name = \'' + name + '\'');
            }
            if(String.isNotBlank(sv.status)) {
                // ステータス
                String status = String.escapeSingleQuotes(sv.status);
//                whereRows.add('SubscriberStatusDisply__c = \'' + status + '\'');
                whereRows.add('SubscriberStatusLabel__c = \'' + status + '\'');
            }
            if(String.isNotBlank(sv.contractTerm)) {
                // 保険期間
                String contractTerm = String.escapeSingleQuotes(sv.contractTerm);
                whereRows.add('InsurancePeriod__c = \'' + contractTerm + '\'');
            }
            if(String.isNotBlank(sv.CSID)) {
                // 顧客ID
                String CSID = String.escapeSingleQuotes(sv.CSID);
                whereRows.add('AccountId__r.CSID__pc = \'' + CSID + '\'');
            }
            if(String.isNotBlank(sv.contractorNameKana)) {
                // 契約者名カナ（姓名）
                String contractorNameKana = String.escapeSingleQuotes(sv.contractorNameKana);
                whereRows.add('SubscriberNameKana__c like \'' + contractorNameKana + '%\'');
            }
            if(String.isNotBlank(sv.contractorNameKanji)) {
                // 契約者名漢字（姓名）
                String contractorNameKanji = String.escapeSingleQuotes(sv.contractorNameKanji);
                whereRows.add('SubscriberNameKanji__c like \'' + contractorNameKanji + '%\'');
            }
            if(String.isNotBlank(sv.subscriberDateOfBirth)) {
                // 契約者生年月日（西暦）
                String subscriberDateOfBirth = String.escapeSingleQuotes(sv.subscriberDateOfBirth);
                whereRows.add('SubscriberBirthdate__c = \'' + subscriberDateOfBirth + '\'');
            }
            if(String.isNotBlank(sv.phone)) {
                // 電話番号
                String phone = String.escapeSingleQuotes(sv.phone);
                whereRows.add('SubscriberTel__c = \'' + phone + '\'');
            }
            if(String.isNotBlank(sv.postalCode)) {
                // 郵便番号
                String postalCode = String.escapeSingleQuotes(sv.postalCode);
                whereRows.add('SubscriberZipcode__c = \'' + postalCode + '\'');
            }
            if(String.isNotBlank(sv.insuredNameKana)) {
                // 被保険者名カナ（姓名）
                String insuredNameKana = String.escapeSingleQuotes(sv.insuredNameKana);
                whereRows.add('InsuredKana__c like \'' + insuredNameKana + '%\'');
            }
            if(String.isNotBlank(sv.insuredNameKanji)) {
                // 被保険者名漢字（姓名）
                String insuredNameKanji = String.escapeSingleQuotes(sv.insuredNameKanji);
                whereRows.add('InsuredKanji__c like \'' + insuredNameKanji + '%\'');
            }
            if(String.isNotBlank(sv.insuredBirthdate)) {
                // 被保険者生年月日（西暦）
                String insuredBirthdate = String.escapeSingleQuotes(sv.insuredBirthdate);
                whereRows.add('InsuredBirthdate__c = \'' + insuredBirthdate + '\'');
            }
            if(String.isNotBlank(sv.insuredBody)) {
                // 被保険体（ペット名）
                String insuredBody = String.escapeSingleQuotes(sv.insuredBody);
                whereRows.add('InsuranceTarget_1__c like \'' + insuredBody + '%\'');
            }
            if(String.isNotBlank(sv.agencyCode)) {
                // 代理店コード
                String agencyCode = String.escapeSingleQuotes(sv.agencyCode);
                whereRows.add('AgencyCode__c = \'' + agencyCode + '\'');
            }
            if(String.isNotBlank(sv.agency)) {
                // 代理店名
                String agency = String.escapeSingleQuotes(sv.agency);
                whereRows.add('AgencyName__c like \'' + agency + '%\'');
            }
        }
System.debug('***********WhereRows'+whereRows);
        return whereRows;
    }
    
    /**
     * SOQL取得
     * 各条件からSOQL文を作成し返却する。
     * @param columns 取得列のリスト
     * @param objectName オブジェクト名
     * @param whereRows 条件のリスト（設定しない場合はnull）
     * @param orderByColumns ソートのリスト（設定しない場合はnull）
     * @param limitNum 取得制限値（設定しない場合は-1） 
     * @return String SOQL文
    **/
    public static String getSoql(List<String> columns, String objectName, List<String> whereRows, List<String> orderByColumns, Integer limitNum) {
        String soql = '';
    
        // 入力チェック
        if (columns.size() == 0) return soql;
        if (String.isEmpty(objectName)) return soql;
        if (whereRows == null)  whereRows = new List<String>();
        if (orderByColumns == null)  orderByColumns = new List<String>();
    
        // 基本SOQL
        soql += 'SELECT ';
        soql += string.join(columns, ', ');
        soql += ' From ' + objectName;
    
        // 抽出条件が存在する場合
        if (whereRows.size() > 0) {
            soql += ' WHERE ';
            soql += string.join(whereRows, ' AND ');
        }
        // 並替条件が存在する場合
        if (orderByColumns.size() > 0) {
            soql += ' ORDER BY ';
            soql += string.join(orderByColumns, ', ');
        }
        // Limit が設定されている場合
        if (limitNum >= 0) {
            soql += ' LIMIT ' + limitNum;
        }
    
        return soql;
    }
}