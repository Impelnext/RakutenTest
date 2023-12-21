// =====================================================
// ■パッチNo.2
// 移行用架電データに対応する取引先が存在するか確認する。
// 存在する場合、移行済みフラグをTrueにする。
// =====================================================
global class  Patch_SS020_CheckExistAccount implements Database.Batchable<SObject>, Database.Stateful{

    public Patch_SS020_CheckExistAccount() {}

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        // 架電レコードを全件取得
        String query = 'Select Id '
                      +      ',MigrationCallingId__c '
                      +      ',MigratedFlag__c '
                      +      ',AccountId__c '
                      +'From MigrationCalling__c '
                      +'Where AccountId__c = Null';
        return Database.getQueryLocator(query);
    }

    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<MigrationCalling__c> callingList){
        System.debug('##### Execute start');
        Map<String, Account> accCallIdMap = new Map<String, Account>();
        Set<String> callingIdSet = new Set<String>();

        //処理対象となる移行用架電objのKeySet作成
        for(MigrationCalling__c rec : callingList){
            if(rec.MigrationCallingId__c <> Null){
                callingIdSet.add(rec.MigrationCallingId__c); //架電IDのSet
            }
        }

        //リーズからの架電ID設定、または、初期移行で作成された取引先を取得
        for(Account rec : [Select id, Migration_ID2__c From Account Where Migration_ID2__c = :callingIdSet]){
            //取引先から取得した架電IDのMapを作成
            accCallIdMap.put(rec.Migration_ID2__c, rec);
        }

        //主処理（架電IDから存在確認できるパターン）
        for(MigrationCalling__c mig : callingList){
            //既に取引先に存在している架電IDの場合
            if(accCallIdMap.get(mig.MigrationCallingId__c) <> Null){
                //架電レコードの移行済みフラグをTRUEに変更。
                mig.MigratedFlag__c = True;
                mig.AccountId__c = accCallIdMap.get(mig.MigrationCallingId__c).Id;
            }
        }

        //更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(callingList, 'update', 'Patch_SS020_CheckExistAccount - MigrationCalling__c');

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