/*
* @Class Name      : PetFreeInsuranceTriggerHandler 
* @Description     : ペットフリー保険トリガーハンドラ
* @Created Date    : 2020.08.07
* @Created By      : Valsala Kumar
* @Modified Date   : 
* @Modified        : 
*/
public class PetFreeInsuranceTriggerHandler {

    /**
     * コンストラクタ
     */
    public PetFreeInsuranceTriggerHandler() {}
    
    
    /**
     * ペットフリー保険作成前処理
     * @param List<PetFreeInsurance__c>
     * @return 
     */
    public void onBeforeInsertProcess(List<PetFreeInsurance__c> petFreeInsList){
        // 既存取引先を取得か
        // 取引先作成
        List<Account> targetAccountList = updateAccounts(petFreeInsList, NULL);
        
        Integer idx = 0;
        // 対象取引先を繰り返す
        for(PetFreeInsurance__c petFreeIns : petFreeInsList){
            petFreeIns.AccountId__c = targetAccountList[idx].Id;
            idx++;
        }
    }
    
    
    /**
     * ペットフリー保険After処理
     * @param List<PetFreeInsurance__c>
     * @return 
     */
    public void onAfterProcess(List<PetFreeInsurance__c> petFreeInsList, Map<Id, PetFreeInsurance__c> oldMap){
        
        // Update Accounts for Update Trigger only
        // As Account is processed in Before Insert, 
        // After Insert process is not required for Account.
        if (oldMap != NULL)
            updateAccounts(petFreeInsList, oldMap);
        
    }
    
    
    /**
     * 取引先作成/更新処理
     * @param Account 作成/更新対象取引先
     * @param PetFreeInsurance__c 作成/更新元となるペットフリー保険情報
     * @return 
     */
    private List<Account> updateAccounts(List<PetFreeInsurance__c> petFreeInsList, Map<Id, PetFreeInsurance__c> oldMap){
        
        List<AccountInfo> accountInfos = new List<AccountInfo>();
        // ペットフリー保険を繰り返し
        for(PetFreeInsurance__c petFreeIns : petFreeInsList){
            AccountInfo accInfo = getAccountInfo(petFreeIns);
            PetFreeInsurance__c oldPetFreeIns = oldMap != null ? oldMap.get(petFreeIns.Id) : null;
            if(oldPetFreeIns == null 
            || petFreeIns.Birthday__c != oldPetFreeIns.Birthday__c
            || petFreeIns.Gender__c != oldPetFreeIns.Gender__c
            || petFreeIns.easyId__c != oldPetFreeIns.easyId__c
            || petFreeIns.Email__c != oldPetFreeIns.Email__c
            || petFreeIns.Phone__c != oldPetFreeIns.Phone__c
            || petFreeIns.MobilePhone__c != oldPetFreeIns.MobilePhone__c
            || petFreeIns.LastName__c != oldPetFreeIns.LastName__c
            || petFreeIns.FirstName__c != oldPetFreeIns.FirstName__c
            || petFreeIns.LastNameFurigana__c != oldPetFreeIns.LastNameFurigana__c
            || petFreeIns.FirstNameFurigana__c != oldPetFreeIns.FirstNameFurigana__c
            || petFreeIns.PostCode__c != oldPetFreeIns.PostCode__c
            || petFreeIns.Prefecture__c != oldPetFreeIns.Prefecture__c
            || petFreeIns.City__c != oldPetFreeIns.City__c
            || petFreeIns.TownName__c != oldPetFreeIns.TownName__c) {
                // If New or Existing Account, then is Account to be Updated
                accInfo.toUpdate = true;
            }
            // Get Existing Accounts OR Create New Account.
            accountInfos.add(accInfo);
        }
        
        // 既存の取引先を取得
        // 既存の取引先がない場合作成
        CommonUtility util = new CommonUtility();
        //作成情報格納用List Key:ペットフリー保険ID
        List<Account> targetAccountList = util.getAccounts(accountInfos);
        return targetAccountList;
    }
    
    
    private AccountInfo getAccountInfo(PetFreeInsurance__c petFreeIns) {
        AccountInfo src = new AccountInfo();
        // ID
        src.accountid = petFreeIns.AccountId__c;
        // 姓名情報
        src.lastname = petFreeIns.LastName__c;
        src.firstname = petFreeIns.FirstName__c;
        src.lastnamekana = petFreeIns.LastNameFurigana__c;
        src.firstnamekana = petFreeIns.FirstNameFurigana__c;
        // 姓名情報に空欄がない場合
        if (String.isNotBlank(petFreeIns.LastName__c)
            && String.isNotBlank(petFreeIns.FirstName__c) 
            && String.isNotBlank(petFreeIns.LastNameFurigana__c)
            && String.isNotBlank(petFreeIns.FirstNameFurigana__c)){
            //氏名のキー情報作成
            src.nameinfo = petFreeIns.LastName__c + petFreeIns.FirstName__c 
                        + petFreeIns.LastNameFurigana__c + petFreeIns.FirstNameFurigana__c;
            src.nameinfo = src.nameinfo.deleteWhitespace();
        }
        // 楽天会員ID
        src.easyid = petFreeIns.easyId__c;
        // 連絡先情報
        src.homephone = petFreeIns.Phone__c;
        src.mobilephone = petFreeIns.MobilePhone__c;
        // 生年月日
        src.birthdate = petFreeIns.Birthday__c;
        // 性別
        src.gender = petFreeIns.Gender__c;
        // メール
        src.email = petFreeIns.Email__c;
        // 住所情報
        src.postalcode = petFreeIns.PostCode__c;
        src.state = petFreeIns.Prefecture__c;
        src.city = petFreeIns.City__c;
        src.street = petFreeIns.TownName__c;
        
        // Other Info
        Map<String, String> params = new Map<String, String>();
        src.params = params;
        
        return src;
    }
}