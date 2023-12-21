// =====================================================
// ■商談ライフサイクルデータパッチ
// ■パッチNo.1
// ※本番のみ実行
// ・損保商談のリスト経路設定
// =====================================================
global class Patch_OL012_SetInflowRouteAndRecordType implements Database.Batchable<SObject>, Database.Stateful{
    
    public Patch_OL012_SetInflowRouteAndRecordType() {
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        return Database.getQueryLocator([Select ID ,InflowRoute__c ,RecordTypeID ,RecordType.DeveloperName From Opportunity where RecordType.DeveloperName = 'Sonpo' and Name!='ダミー商談']);
    }
    
    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<Opportunity> scope){
        System.debug('##### Execute start');
        String query = 'SELECT ID ,InflowRoute__c ,RecordTypeID ,RecordType.DeveloperName'
                        +',(SELECT CreatedDate FROM GeneralWebApplication__r Order By CreatedDate limit 1)'
                        +',(SELECT CreatedDate FROM GeneralRequest__r Order By CreatedDate limit 1) '
                        +'FROM Opportunity '
                        +'WHERE ID = :scope';
        List<Opportunity> oppList = Database.query(query);
        // System.debug('★oppList'+oppList);

        //レコードタイプ毎にリスト経路設定
        for(Opportunity rec : oppList){

            if (rec.InflowRoute__c != null) {
                //◆リスト経路変換
                if (rec.InflowRoute__c =='0120-069-105') rec.InflowRoute__c ='TVCM';
                if (rec.InflowRoute__c =='0120-921-210') rec.InflowRoute__c ='Web入電';
                if (rec.InflowRoute__c =='0120-921-343' || rec.InflowRoute__c =='0120-977-021') rec.InflowRoute__c ='その他IB';
                if (rec.InflowRoute__c =='一次保存') rec.InflowRoute__c ='申込途中保存';
                if (rec.InflowRoute__c =='BDDM') rec.InflowRoute__c ='外部データソース';
                if (rec.InflowRoute__c =='既契約セル') rec.InflowRoute__c ='既契約クロスセル';
                if (rec.InflowRoute__c =='アップセル') rec.InflowRoute__c ='既契約アップセル';
                if (rec.InflowRoute__c =='クロスセル') rec.InflowRoute__c ='既契約クロスセル';

            //◆リーズからのリスト経路設定
            } else {
                //損保リード子リレーション
                DateTime GeneralWDate = (rec.GeneralWebApplication__r.isEmpty()) ? null: rec.GeneralWebApplication__r.get(0).CreatedDate;
                DateTime GeneralRDate = (rec.GeneralRequest__r.isEmpty()) ? null: rec.GeneralRequest__r.get(0).CreatedDate;

                //最古のリードソースを設定していくためのMap
                map<String ,DateTime> oldDateMap = new  map<String,DateTime>();
                if (rec.InflowRoute__c == null) {
                    //損保Web申込途中保存情報ありの場合
                    if (GeneralWDate != null) {
                        oldDateMap.put('申込途中保存', GeneralWDate);
                    }
                    //損保資料請求ありの場合、損保Web申込途中保存情報の日付と比較（nullは比較結果false）
                    if (GeneralRDate != null) {
                        if (isOldDate(oldDateMap, GeneralRDate)) {
                            oldDateMap.clear();
                            oldDateMap.put('資料請求', GeneralRDate);
                        }
                    }
                }

                //oldDateMapに入っている値をリードソースに設定
                if (oldDateMap.size() > 0) {
                    List<String> listStrings = new List<String>(oldDateMap.keySet());
                    rec.InflowRoute__c = listStrings.get(0);
                }
            }
        }
        
        //商談を更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(oppList, 'update', 'Patch_OL012_SetInflowRouteAndRecordType');
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