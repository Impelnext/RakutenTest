// =====================================================
// ■商談ライフサイクルデータパッチ
// ■パッチNo.1
// ※本番のみ実行
// ・少短商談のリスト経路設定
// =====================================================
global class Patch_OL013_SetInflowRouteAndRecordType implements Database.Batchable<SObject>, Database.Stateful{
    
    public Patch_OL013_SetInflowRouteAndRecordType() {
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        return Database.getQueryLocator([Select ID ,InflowRoute__c ,RecordTypeID ,RecordType.DeveloperName From Opportunity where RecordType.DeveloperName ='Syotan' and Name!='ダミー商談']);
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
                        +',(SELECT CreatedDate FROM SyotankanrishiryoSyodan__r Order By CreatedDate limit 1)'
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
                //少短リード子リレーション
                DateTime SyotanDate = (rec.SyotankanrishiryoSyodan__r.isEmpty()) ? null: rec.SyotankanrishiryoSyodan__r.get(0).CreatedDate;

                //最古のリードソースを設定していくためのMap
                map<String ,DateTime> oldDateMap = new  map<String,DateTime>();
                //少短レコード
                if (rec.InflowRoute__c == null && SyotanDate != null) {
                    oldDateMap.clear();
                    oldDateMap.put('資料請求', SyotanDate);
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
        pcdo.dmlOperation(oppList, 'update', 'Patch_OL013_SetInflowRouteAndRecordType');
        // update oppList;
        System.debug('◆CPU Time ： ' + Limits.getCpuTime());      
        System.debug('##### Execute end');
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