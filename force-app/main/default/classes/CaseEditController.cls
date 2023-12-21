/**
 * ケースの新規登録
 */
public with sharing class CaseEditController {

    private static final String INITIAL_VALUE = '';

    public Account parentAccObj {get; set;}
    public Id parentId {get; set;}
    public Case parentCaseObj {get; set;}
    public Case caseObj {get; set;}

    /**
     * コンストラクタ
     */
    public CaseEditController(ApexPages.StandardController controller) {
        this.parentCaseObj = (case)controller.getRecord();
        this.caseObj = new Case();
        if (this.parentCaseObj != NULL && 
            this.parentCaseObj.RequestReference__c != NULL) {
            for(Request__c request : [SELECT Id, class__c, type__c FROM Request__c WHERE Id =: this.parentCaseObj.RequestReference__c]) {
                caseObj.class__c = request.class__c;
                caseObj.type__c = request.type__c; 
            }
        }
    }

    /** 対応区分リスト */
    public List<SelectOption> ctrlClassPickListOptions {
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
    public List<SelectOption> depTypePickListOptions {
        get{
            List<SelectOption> options = new List<SelectOption>();

            // 選択リストの一番上にデフォルトの選択値を設定
            options.add(new SelectOption(INITIAL_VALUE, '-- なし --'));

            // 制御項目ctrlClassPickListが選択されている時に連動項目depTypePickListで選べる選択肢を取得する。
            if(this.caseObj.class__c != null || this.caseObj.class__c != INITIAL_VALUE){
                List<DepPickListCtrl.TPicklistEntry> tPicklistEntries = 
                    DepPickListCtrl.GetDependentOptions('Case','class__c','type__c').get(this.caseObj.class__c);

                for(DepPickListCtrl.TPicklistEntry e : tPicklistEntries){
                    options.add(new SelectOption(e.value, e.label));
                }
            }
            return options;
        }
    }

    /** 発生源リスト */
    public List<SelectOption> ctrlOriginPickListOptions {
        get{
            List<SelectOption> options = new List<SelectOption>();

            // 対象のオブジェクトに存在する選択リストを取得し、登録済みの選択値を取得します
            Schema.DescribeFieldResult fieldResult = Case.Origin.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            // 選択リストの一番上にデフォルトの選択値を設定
            for(Schema.PicklistEntry e : picklistEntries){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
    }

    /** 状況リスト */
    public List<SelectOption> ctrlStatusPickListOptions {
        get{
            List<SelectOption> options = new List<SelectOption>();

            // 対象のオブジェクトに存在する選択リストを取得し、登録済みの選択値を取得します
            Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            // 選択リストの一番上にデフォルトの選択値を設定
            for(Schema.PicklistEntry e : picklistEntries){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
    }
    
    /**
     * 住所入力フラグ取得
     */
    public Boolean getInputAddressFlg() {
        if(this.caseObj.type__c != null || this.caseObj.type__c != INITIAL_VALUE){
            if(this.caseObj.type__c == '住所変更'){
                return true;
            }
        }

        return false;
    }

    /**
     * 郵便番号検索（アクションファンクション）
     */
    public PageReference searchPostalCode()
    {
        // 郵便番号APIを呼出
        Map<String, String> areaInfoMap = ZipUtil.getAreaInfo(this.caseObj.PostNumber__c);

        if(areaInfoMap != null && areaInfoMap.size() > 0){
            // 取得結果を反映
            this.caseObj.Prefecture__c = areaInfoMap.get(ZipUtil.PREFECTURE);          // 都道府県
            this.caseObj.Municipality__c = areaInfoMap.get(ZipUtil.MUNICIPALITY);      // 市区郡
            this.caseObj.Address1__c = areaInfoMap.get(ZipUtil.CHOME);                    // 町名番地
            this.caseObj.BuildingName__c = this.caseObj.BuildingName__c;               // 建物名
        }

        return null;
    }

    /**
     * 保存ボタン処理
     */
    public PageReference doSave() {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;

        if(!getInputAddressFlg()){
            // 住所入力が不要な場合、住所情報クリア
            this.caseObj.PostNumber__c = null;
            this.caseObj.Prefecture__c = null;
            this.caseObj.Municipality__c = null;
            this.caseObj.Address1__c = null;
            this.caseObj.BuildingName__c = null;
        }
            
        //契約者
        try{
            Contact con = [Select id, furiganaLast__c, furiganaForst__c, MailingPostalCode, MailingState, MailingCity, MailingStreet, Name From Contact Where AccountId = :this.parentCaseObj.AccountId];
            this.caseObj.ContactId = con.Id;
            String strFuriLastname = con.furiganaLast__c;
            String strFuriFirstName = con.furiganaForst__c;
            this.caseObj.ContractFuriName__c = '';
            if(String.isNotBlank(strFuriLastname)){
                this.caseObj.ContractFuriName__c = strFuriLastname;
            }
            if(String.isNotBlank(strFuriFirstName)){
                this.caseObj.ContractFuriName__c = this.caseObj.ContractFuriName__c + ' ' + strFuriFirstName;
            }
            String strPostCode = con.MailingPostalCode;
            String strState = con.MailingState;
            String strCity = con.MailingCity;
            String strStreet = con.MailingStreet;
            this.caseObj.DeliveryAddress__c = '';
            if(String.isNotBlank(strPostCode)){
                this.caseObj.DeliveryAddress__c = strPostCode + ' ';
            }
            if(String.isNotBlank(strState)){
                this.caseObj.DeliveryAddress__c = this.caseObj.DeliveryAddress__c + strState;
            }
            if(String.isNotBlank(strCity)){
                this.caseObj.DeliveryAddress__c = this.caseObj.DeliveryAddress__c + strCity;
            }
            if(String.isNotBlank(strStreet)){
                this.caseObj.DeliveryAddress__c = this.caseObj.DeliveryAddress__c + strStreet;
            }
            this.caseObj.DestinationAddress__c = con.Name;
            this.caseObj.NameOfferer__c = con.Name;
        }catch(Exception e){
            //none
        }
        // リクエスト情報、受付情報、レコードタイプの継承
        this.caseObj.RecordTypeId = parentCaseObj.RecordTypeId;
        this.caseObj.RequestReference__c = parentCaseObj.RequestReference__c;
        if (parentCaseObj.RequestReference__c != NULL) {
            for(Request__c req : [SELECT Id, Reception__c FROM Request__c WHERE Id =: parentCaseObj.RequestReference__c]) {
                this.caseObj.Reception__c = req.Reception__c;
                System.debug('Reception__c' + req.Reception__c);
            }
        }
        //親ケースを取得
        Id parentCaseId = this.parentCaseObj.ParentId;
        if(parentCaseId <> Null){
            //親ケースを取得
            Case parentCase = [Select id
                                     ,NameOfferer__c
                                     ,RelationshipWithContractor__c
                                     ,OtherPattern__c
                                     ,Identification__c
                                     ,IdentityVerificationOthers__c
                                     ,ContactId
                                     ,ContractFuriName__c
                                     ,Priority
                                     ,Description
                                     ,ProcedureContents__c
                                     ,DestinationAddress__c
                                     ,DeliveryAddress__c
                                     ,SuppliedEmail
                               From Case Where Id = :parentCaseId];
            
            //親ケースの申出者、続柄等を設定
            this.caseObj.ParentId = parentCaseId; //親ケース
            this.caseObj.NameOfferer__c = parentCase.NameOfferer__c; //申出者氏名
            this.caseObj.RelationshipWithContractor__c = parentCase.RelationshipWithContractor__c; //契約者との続柄
            this.caseObj.OtherPattern__c = parentCase.OtherPattern__c; //続柄その他
            this.caseObj.Identification__c = parentCase.Identification__c; //本人確認
            this.caseObj.IdentityVerificationOthers__c = parentCase.IdentityVerificationOthers__c; //本人確認（その他）
            this.caseObj.ContactId= parentCase.ContactId; //契約者氏名
            this.caseObj.ContractFuriName__c = parentCase.ContractFuriName__c; //フリガナ（契約者）
            this.caseObj.Priority = parentCase.Priority; //優先度
            this.caseObj.Description = parentCase.Description; //受付内容
            this.caseObj.ProcedureContents__c = parentCase.ProcedureContents__c; //手続き内容
            this.caseObj.DestinationAddress__c = parentCase.DestinationAddress__c; //送付先宛名
            this.caseObj.DeliveryAddress__c = parentCase.DeliveryAddress__c; //送付先住所
            this.caseObj.SuppliedEmail = parentCase.SuppliedEmail; //Webメール
        }  
        
        // ケースをインサートし結果を格納
        Database.SaveResult result = Database.insert(this.caseObj, /*allOrNone*/ false);
        // エラー判定を初期化
        integer errCount = 0;
        
        // インサート結果を取り出す
        for (Database.Error err : result.getErrors()){
            // インサート結果からエラー結果を取り出す
            for (string apiname : err.getFields()){
                
                // 取得したAPI名から()を削除
                apiname = apiname.replace('(', '');
                apiname = apiname.replace(')', '');
                
                // API名からラベル名を取得                
                DescribeSObjectResult sObjectDescribe= Case.getSObjectType().getDescribe();
                Map<String, SObjectField> fields = sObjectDescribe.fields.getMap();
                String label = fields.get(apiname).getDescribe().getlabel();
                    
                // エラーメッセージの表示
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label + ': ' + err.getMessage());
                ApexPages.addMessage(myMsg);
                
                // エラー判定をインクリメント
                errCount++;
            }
        }
        if(errCount > 0) return null;

        return new PageReference('/' + this.caseObj.Id);
    }
}