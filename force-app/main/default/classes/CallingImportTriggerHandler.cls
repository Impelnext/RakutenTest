/*
* @Class Name      : CallingImportTriggerHandler 
* @Description     : 架電リスト取込みマスタトリガのテストクラス
* @Created Date    : 2020.07.15
* @Created By      : SRM
* @Modified Date   : 2020.07.20
* @Modified        : SRM
* @Modified Date   : 2021.03.11
* @Modified        : SRM
* @Description     : ONYXー取引先NX番号が一致するロジックの更新
*/

public class CallingImportTriggerHandler {
    
    /**
     * 架電リスト取込み
     * @param List<CallingImport__c>
     * @return 
     */
    public void onBeforeProcess(List<CallingImport__c> callingImportList){
        
        //契約確認コール用の架電リスト取込みを格納するリスト
        List<CallingImport__c> confirmationCallImportList = new List<CallingImport__c>();
        //継続フォロー用の架電リスト取込みを格納するリスト
        List<CallingImport__c> followUpImportList = new List<CallingImport__c>();
        //口座不備用の架電リスト取込みを格納するリスト
        List<CallingImport__c>  defectAccountImportList = new List<CallingImport__c>();
        //顧客番号を格納するリスト
        List<String> customerNoList = new List<String>();

        // 継続フォロー
        // 顧客リクエスト番号を格納するリスト
        List<String> requestNoListFollow = new List<String>();
        //生保代理店番号を格納するセット
        Set<String> seihoAgencyNoSetFollow = new Set<String>();
        //生保募集人番号を格納するセット
        Set<String> seihoRecruiterNoSetFollow = new Set<String>();
        
        //口座不備
        // 顧客リクエスト番号を格納するリスト
        List<String> requestNoListDefectAccount = new List<String>();
        //生保代理店番号を格納するセット
        Set<String> seihoAgencyNoSetDefectAccount = new Set<String>();
        //生保募集人番号を格納するセット
        Set<String> seihoRecruiterNoSetDefectAccount = new Set<String>();
        
        for(CallingImport__c call : callingImportList){
            if(call.CallListType__c =='契約確認コール'){
                customerNoList.add(call.CustomerNo__c);
                confirmationCallImportList.add(call);
            }else if(call.CallListType__c =='継続フォロー'){
                requestNoListFollow.add(call.RequestNo1__c);
                seihoAgencyNoSetFollow.add(call.SeihoAgencyNo__c);
                seihoRecruiterNoSetFollow.add(call.SeihoRecruiterNo__c);
                followUpImportList.add(call);
            }else if(call.CallListType__c =='口座不備'){
                requestNoListDefectAccount.add(call.RequestNo1__c);
                seihoAgencyNoSetDefectAccount.add(call.SeihoAgencyNo__c);
                seihoRecruiterNoSetDefectAccount.add(call.SeihoRecruiterNo__c);
                defectAccountImportList.add(call);
            }
        }
        
        // 受付情報、リクエスト情報、ケースの作成
        if (confirmationCallImportList.size() > 0) {
            createReceptionRequestRecord(customerNoList,confirmationCallImportList);
        }
        
        if (followUpImportList.size() > 0) {
            CreateReceptionRequestCaseRecords('継続フォロー',requestNoListFollow,followUpImportList,seihoAgencyNoSetFollow,seihoRecruiterNoSetFollow);
        }
        
        if (defectAccountImportList.size() > 0) {
            CreateReceptionRequestCaseRecords('口座不備',requestNoListDefectAccount,defectAccountImportList,seihoAgencyNoSetDefectAccount,seihoRecruiterNoSetDefectAccount);
        }
    }
    
    
    /**
     * 受付情報、リクエスト情報を作成する
     * @param List<String>
     * @param List<CallingImport__c>
     * @return 
     */
    public void createReceptionRequestRecord(List<String> customerNoList,List<CallingImport__c> callingImportList){
        
        // 以下の順でNX番号が一致するレコードを検索し、
        // 一致する場合は取引先と紐づけを行う
        // ・生保契約情報
        // ・取引先
        // ・生保申込み
        // NX番号とCRMIDでソート順
        Map<String, MasterHelper.MasterNXNo> accmap = MasterHelper.getAllAccountsFromNXNumber(new Set<String>( customerNoList ));
        // NX番号とCRMIDでソートして、最初の1件に紐づけを行う
        
        List<Reception__c> receptionList = new List<Reception__c>();
        List<Request__c> requestList = new List<Request__c>();
        for(CallingImport__c call : callingImportList){
            
            Reception__c rec = new reception__c(
                Origin__c='電話',
                Account__c = accMap.get(call.CustomerNo__c) !=null ? accMap.get(call.CustomerNo__c).getAccountID() : null,
                 AdderssInputMethod__c = null
                
            );
            Request__c req = new request__c(
                Account__c = accMap.get(call.CustomerNo__c) !=null ? accMap.get(call.CustomerNo__c).getAccountID() :null,
                class__c = '生命専用ケース',
                type__c = '契約確認コール',
                subject__c = '契約確認コール',
                Status__c = 'CC完了',
                Priority__c = '中',
                TelAcceptCompnDate__c = call.ReceptionDatetime__c,
                Notices__c = call.Description__c
            );
            receptionList.add(rec);
            requestList.add(req); 
        }
        
        insert receptionList;
        
        Integer idx = 0;
        for (Request__c req : requestList) {
            req.Reception__c = receptionList[idx++].Id;
        }
        
        insert requestList;
    }
    
    
    /**
     * 受付情報、リクエスト情報、ケースを作成する
     * @param String
     * @param List<String>
     * @param List<CallingImport__c>
     * @param Set<String>
     * @param Set<String>
     * @return 
     */
    public void createReceptionRequestCaseRecords( String Type, 
                                                   List<String> requestNoList, 
                                                   List<CallingImport__c> callingImportList, 
                                                   Set<String> seihoAgencyNoSet, 
                                                   Set<String> seihoRecruiterNoSet ) { 

        Id recordTypeCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('生命専用ケース').getRecordTypeId();
        List<Reception__c> receptionList = new List<reception__c>();
        List<Request__c> requestList = new List<request__c>();
        List<Case> caseList = new List<Case>();

        Map<String,SeihoAgencyMaster__c> seihoAgencyMap = MasterHelper.getSeihoAgencyMasterFromAgencyNo(seihoAgencyNoSet);
        Map<String,SeihoRecruiterMaster__c> seihoRecruiterMap = MasterHelper.getSeihoRecruiterMasterFromRecruiterNo(seihoRecruiterNoSet);
        Map<String,Request__c> requestMap = MasterHelper.getRequestFromRequestNo(requestNoList);

        for(CallingImport__c call : callingImportList){

            Reception__c rec = new reception__c(
                Origin__c='電話',
                SeihoRecruiter__c = seihoRecruitermap.get(call.seihoRecruiterNo__c) !=null ? seihoRecruitermap.get(call.seihoRecruiterNo__c).Id : null,
                SeihoAgency__c = seihoAgencymap.get(call.seihoAgencyNo__c) !=null ? seihoAgencymap.get(call.seihoAgencyNo__c).Id : null,
                Identification__c = '募集人番号',
                ReceptionTeam__c = '生命ー代サ',
                Description__c = Type,
                AdderssInputMethod__c = null
            );
            Request__c req = new request__c(
                class__c = '生命代サ専用ケース',
                type__c = 'フォロー対応',
                subject__c = Type,
                Status__c = 'CC対応中',
                Priority__c = '中',
                TelAcceptCompnDate__c = call.CreatedDate,
                SupportContents__c = Type =='継続フォロー' ? '継続フォロー架電' : null,
                SeihoRecruiter__c = seihoRecruitermap.get(call.seihoRecruiterNo__c) != null ? seihoRecruitermap.get(call.seihoRecruiterNo__c).Id : null,
                SeihoAgency__c = SeihoAgencymap.get(call.seihoAgencyNo__c) != null ? SeihoAgencymap.get(call.seihoAgencyNo__c).Id : null,
                follow__c = requestMap.get(call.RequestNo1__c) != null ? requestMap.get(call.RequestNo1__c).Id : null
                
            );
            Case ca = new Case(
                status = 'CC対応中',
                priority= '中',
                recordtypeId = recordTypeCase
            );
            receptionList.add(rec);
            requestList.add(req);
            caseList.add(ca);
        }
        insert receptionList;
        
        Integer idx = 0;
        for (Request__c req : requestList) {
            req.Reception__c = receptionList[idx++].Id;
        }
        
        insert requestList;
        
        idx = 0;
        for (Case ca : caseList) {
            ca.Reception__c = receptionList[idx].Id;
            ca.RequestReference__c = requestList[idx++].Id;
        }
        insert caseList;
    }
}