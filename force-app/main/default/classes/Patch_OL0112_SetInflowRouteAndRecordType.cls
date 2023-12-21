// =====================================================
// ■商談ライフサイクルデータパッチ
// ■パッチNo.1
// ※本番のみ実行
// ・生保商談のリスト経路設定
// =====================================================
global class Patch_OL0112_SetInflowRouteAndRecordType implements Database.Batchable<SObject>, Database.Stateful{
    public Id hanyoRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('汎用').getRecordTypeId();
    public Date today = date.newInstance(2020, 3, 28);
    public Patch_OL0112_SetInflowRouteAndRecordType() {
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        return Database.getQueryLocator([Select ID ,InflowRoute__c ,RecordTypeID ,RecordType.DeveloperName
                                         From Opportunity
                                         where RecordType.DeveloperName = 'seiho' and Name!='ダミー商談' and account.Migration_Id2__c >= '200000']);
    }
    
    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        System.debug('##### Execute start');
        String query = 'SELECT ID ,InflowRoute__c ,RecordTypeID ,RecordType.DeveloperName,Name,CampaignDateTime__c,StageName,CloseDate'
                        +',(SELECT CreatedDate FROM OpportunityMiniInsurance__r Order By LastModifiedDate desc limit 1)'
                        +',(SELECT CreatedDate FROM SeihoLeads__r Order By CreatedDate limit 1)'
                        +',(SELECT CreatedDate FROM Syodan_Seihomousikomi__r Order By CreatedDate limit 1)'
                        +',(SELECT Id FROM Tasks Limit 1)'
                        +'FROM Opportunity '
                        +'WHERE ID = :scope';
                        // +'WHERE ID = \'0060l00000A2IqsAAF\'';
        List<Opportunity> oppList = Database.query(query);
        // System.debug('★oppList'+oppList);
        // System.debug('★oppList.size'+oppList.size());

        //レコードタイプ毎にリスト経路設定
        for(Opportunity rec : oppList){
            DateTime miniDate = (rec.OpportunityMiniInsurance__r.isEmpty()) ? null: rec.OpportunityMiniInsurance__r.get(0).CreatedDate;
            DateTime SeihoLDate = (rec.SeihoLeads__r.isEmpty()) ? null: rec.SeihoLeads__r.get(0).CreatedDate;
            DateTime SeihoODate = (rec.Syodan_Seihomousikomi__r.isEmpty()) ? null: rec.Syodan_Seihomousikomi__r.get(0).CreatedDate;

            if (rec.InflowRoute__c != null) {
                //◆リスト経路変換
                if (rec.InflowRoute__c =='0120-069-105') {rec.InflowRoute__c ='TVCM';}
                else if (rec.InflowRoute__c =='0120-921-210') {rec.InflowRoute__c ='Web入電';}
                else if (rec.InflowRoute__c =='0120-921-343' || rec.InflowRoute__c =='0120-977-021') {rec.InflowRoute__c ='その他IB';}
                else if (rec.InflowRoute__c =='一次保存') {rec.InflowRoute__c ='申込途中保存';}
                else if (rec.InflowRoute__c =='BDDM') {rec.InflowRoute__c ='外部データソース';}
                else if (rec.InflowRoute__c =='既契約セル') {rec.InflowRoute__c ='既契約クロスセル';}
                else if (rec.InflowRoute__c =='アップセル（ミニ開始30日以内）') {rec.InflowRoute__c ='ミニ保険';}
                else if (rec.InflowRoute__c =='アップセル（ミニ開始90日以内）') {rec.InflowRoute__c ='ミニ保険';}
                else if (rec.InflowRoute__c =='アップセル（ミニ開始8カ月前）') {rec.InflowRoute__c ='ミニ保険';}
                else if (rec.InflowRoute__c =='アップセル（ミニ終了3カ月前）') {rec.InflowRoute__c ='ミニ保険';}
                else if (rec.InflowRoute__c =='ミニ_サンキューコール') {rec.InflowRoute__c ='ミニ保険';}

            //◆リーズからのリスト経路設定
            } else {

                //最古のリードソースを設定していくためのMap
                map<String ,DateTime> oldDateMap = new  map<String,DateTime>();
                //１．生保・汎用レコード

                //1.作成日が最も古いリードの判定
                //生保Web資料請求ありの場合
                if (SeihoLDate != null) {
                    oldDateMap.put('資料請求', SeihoLDate);
                }
                //生保申込みありの場合
                if (SeihoODate != null) {
                    if (isOldDate(oldDateMap, SeihoODate)) {
                        oldDateMap.clear();
                        oldDateMap.put('申込途中保存', SeihoODate);
                    }
                }
                //ミニ保険ありの場合
                if (miniDate != null) {
                    if (isOldDate(oldDateMap, miniDate)) {
                        oldDateMap.clear();
                        oldDateMap.put('ミニ保険', miniDate);
                    }
                }
                // System.debug('★oldDateMap'+oldDateMap);

                //oldDateMapに入っている値をリードソースに設定
                if (oldDateMap.size() > 0) {
                    List<String> listStrings = new List<String>(oldDateMap.keySet());
                    rec.InflowRoute__c = listStrings.get(0);
                }
            }
            //商談にToDoが紐づくか確認
            Boolean existTask = (rec.Tasks.isEmpty()) ? False : True;
            if(   SeihoLDate == Null
               && SeihoODate == Null
               && miniDate   <> Null
               && existTask  == False){
                rec.RecordTypeID = hanyoRecTypeId;
                rec.name = rec.name.replace('生保', '汎用');
            }

            //ミニ保険ありの場合
            if (miniDate <> null) {
                //ミニ保険が紐づく商談の場合は完了予定日を、更に1か月後の月末に変更（生保商談Insert時、1か月後の月末に設定）
                //生保商談Insert時、キャンペーン日時＝Nullのため、完了予定日3/28で設定したデータは対象外
                if(rec.CloseDate <> today){
                    rec.CloseDate = Date.newInstance(rec.CloseDate.year(), rec.CloseDate.month() ,1).addMonths(2).addDays(-1);
                }
            }
            // System.debug('★rec.CloseDate'+rec.CloseDate);
            // System.debug('★today'+today);
            //完了予定日が過去日の場合、商談クローズ
            if(rec.CloseDate <= today){
                rec.StageName = '対応終了';
            }
        }
        
        //商談を更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(oppList, 'update', 'Patch_OL0112_SetInflowRouteAndRecordType');
        // update oppList;
        System.debug('◆CPU Time ： ' + Limits.getCpuTime());      
        System.debug('##### Execute end');
    }

    //古い日付かどうかを判断
    private boolean isOldDate(map<String,DateTime> compareMap, DateTime comparedate) {
        //compareMapの値がある場合
        if(compareMap.size() > 0){
            if (compareMap.values().get(0) > comparedate) {
               return true; 
            } else {
               return false;
            }
        //compareMapの値がない場合、最も古いのは引数のcomparedateになる
        }else{
            return true;
        }
    }

    /**
     * Batchableインタフェースのfinish関数
     * @param Database.BatchableContext
     * @return 
     */
    global void finish(Database.BatchableContext bc){

        System.debug('### finish method');
    }
}