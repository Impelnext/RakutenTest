// =====================================================
// ■パッチNo.4-2
// 取引先との紐づきを解除したミニ保険objに対して再度
// 架電IDを使用して取引先と紐づけ直すパッチ用Apexバッチ
// =====================================================
global class  Patch_SS042_AccMigrationMiniReLink implements Database.Batchable<SObject>, Database.Stateful{

    public Patch_SS042_AccMigrationMiniReLink() {    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        // 架電IDが設定されていて、取引先に関連していないミニ保険のみ取得
        String query = 'Select Id '
                      +      ',AccountId__c '
                      +      ',AccountId__r.Migration_ID2__c '
                      +      ',Migration_ID2__c '
                      +'From MiniInsurance__c '
                      +'Where Migration_ID2__c <> null '
                      +'And AccountId__c = Null';
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<MiniInsurance__c> miniList){
        System.debug('##### Execute start');
        Map<String, MigrationCalling__c> updCallingMap = new Map<String, MigrationCalling__c>();

        Set<String> callingIdSet = new Set<String>();

        //処理対象となる架電IDのセットを作成
        for(MiniInsurance__c rec : miniList){
            if(rec.Migration_ID2__c <> Null){
                callingIdSet.add(rec.Migration_ID2__c);
            }
        }
        
        //処理対象となる取引先を取得（架電IDをキーとして取得）
        Map<String, Account> accMap = new Map<String, Account>();
        for(Account rec : [Select id, Migration_ID2__c From Account Where Migration_ID2__c in :callingIdSet]){
            //取引先Mapの作成（ミニ保険側の紐づけ直し用）
            accMap.put(rec.Migration_ID2__c, rec);
        }

        //主処理
        for(MiniInsurance__c mini : miniList){
            //ミニ保険objの架電IDに対応する取引先の存在確認
            if(accMap.get(mini.Migration_ID2__c) == Null){
                //■存在しない場合
                // none （そのようなデータは存在しないはず）
            }
            else{
                //■ミニ保険objの架電IDに対応する取引先が存在する場合
                //架電IDを使用して取引先に紐づけ
                mini.AccountId__c = accMap.get(mini.Migration_ID2__c).Id;
            }
        }

        //更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        //ミニ保険オブジェクト（取引先との紐づ記載作成）
        pcdo.dmlOperation(miniList, 'update', 'Patch_SS042_AccMigrationMiniReLink - MiniInsurance__c');

        System.debug(Logginglevel.error, '◆CPU Time ： ' + Limits.getCpuTime());
        System.debug('##### Execute End');
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