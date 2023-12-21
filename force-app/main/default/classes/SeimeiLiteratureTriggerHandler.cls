/*
* @Class Name      : SeimeiLiteratureTriggerHandler 
* @Description     : 生命発送物マスタのトリガーハンドラー
* @Created Date    : 2020.07.1
* @Created By      : SRM
* @Modified Date   : 2020.07.20
* @Modified By     : SRM
* @Modified Date   : 2021.03.12
* @Modified        : SRM
* @Description     : ONYXー取引先NX番号が一致するロジックの更新
*/
public class SeimeiLiteratureTriggerHandler {

    /**
    *　挿入・更新前処理
    * @param List<SeimeiLiterature__c>
    * @paramMap<Id,SeimeiLiterature__c>
    * @return 
    */
    
    public void onBeforeProcess(List<SeimeiLiterature__c> seimeiLiteratureList,Map<Id,SeimeiLiterature__c> oldSeimeiLiteratureMap ){
    
        //顧客番号（CSID）を格納するリスト
        List<String> csIdList = new List<String>();
        //資料コードを格納するリスト
        set<String> documentCodeList = new set<String>();
        //取引先情報を格納するマップ
        Map<String, MasterHelper.MasterNXNo> accmap = new Map<String, MasterHelper.MasterNXNo>();
        //生命資料マスタ情報を格納するマップ
        Map<String, seimeiDocumentMaster__c> seimeiDocumentMasterMap = new Map<String,seimeiDocumentMaster__c>();
        
        for (seimeiLiterature__c seimeiLiterature : seimeiLiteratureList) {
            if(oldSeimeiLiteratureMap == null || oldSeimeiLiteratureMap.get(seimeiLiterature.Id).csid__c != seimeiLiterature.csid__c){
                if(seimeiLiterature.csid__c != null){
                    csIdList.add(seimeiLiterature.csid__c);
                }
            }
            
            if(oldSeimeiLiteratureMap == null || oldSeimeiLiteratureMap.get(seimeiLiterature.Id).DocumentCode__c != seimeiLiterature.DocumentCode__c){
                if(seimeiLiterature.DocumentCode__c != null){
                    documentCodeList.add(seimeiLiterature.DocumentCode__c);
                }
            }
        }
        
        //顧客番号（CSID）に基づいて取引先情報を取得
        if(!csIdList.isempty()) {
            // 以下の順でNX番号が一致するレコードを検索し、
            // 一致する場合は取引先と紐づけを行う
            // ・生保契約情報
            // ・取引先
            // ・生保申込み
            // NX番号とCRMIDでソート順
            accmap = MasterHelper.getAllAccountsFromNXNumber(new Set<String>( csIdList ));
            // NX番号とCRMIDでソートして、最初の1件に紐づけを行う
        }
        //資料コードに基づいて生命資料マスタの検索する
        if(!documentCodeList.isempty()){        
            seimeiDocumentMasterMap = MasterHelper.getSeimeiDocumentMasterFromDocumentCode(documentCodeList);
        }
        
        for (seimeiLiterature__c seimeiLiterature : seimeiLiteratureList) {
            if(oldSeimeiLiteratureMap == null || oldSeimeiLiteratureMap.get(seimeiLiterature.Id).csid__c != seimeiLiterature.csid__c){
                seimeiLiterature.Account__c = (seimeiLiterature.csid__c != NULL && accMap.get(seimeiLiterature.csid__c) != Null)? accMap.get(seimeiLiterature.csid__c).getAccountID() : NULL;
            }
            if(oldSeimeiLiteratureMap == null || oldSeimeiLiteratureMap.get(seimeiLiterature.Id).DocumentCode__c != seimeiLiterature.DocumentCode__c){
                seimeiLiterature.SeimeiDocMaster__c = (seimeiLiterature.DocumentCode__c != NULL && seimeiDocumentMasterMap.get(seimeiLiterature.DocumentCode__c) != Null)? seimeiDocumentMasterMap.get(seimeiLiterature.DocumentCode__c).Id : NULL;
            }
        }
    }
}