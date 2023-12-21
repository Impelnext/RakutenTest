// =====================================================
// ■パッチNo.1-2
// ミニ保険objと取引先objの紐づきを
// 架電IDを使用して紐づけ直すパッチ用Apexバッチ
// =====================================================
global class  Patch_SS012_AccMigrationMini implements Database.Batchable<SObject>, Database.Stateful{
    Datetime targetDatetime;
    public Patch_SS012_AccMigrationMini(Datetime paramDatetime) {
        targetDatetime = paramDatetime; //前回パッチ実施日時
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        String query = 'Select Id '
                      +      ',AccountId__c '
                      +      ',AccountId__r.Migration_ID2__c '
                      +      ',Migration_ID2__c '
                      +'From MiniInsurance__c '
                      +'Where Migration_ID2__c <> null '
                      +'And LastModifieddate >= :targetDatetime '
                      +'And isTargetAccMigration__c = True';
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
        Map<String, Account> updAccountMap = new Map<String, Account>();
        Map<String, MigrationCalling__c> updCallingMap = new Map<String, MigrationCalling__c>();

        Set<String> callingIdSet = new Set<String>();
        Set<Id> accountIdSet = new Set<Id>();

        //処理対象となる架電IDのセットを作成
        for(MiniInsurance__c rec : miniList){
            if(rec.Migration_ID2__c <> Null) callingIdSet.add(rec.Migration_ID2__c);
            if(rec.Accountid__c <> Null) accountIdSet.add(rec.Accountid__c);
        }
        
        //処理対象となる取引先を取得（架電IDをキーとして取得）
        Map<String, Account> accMap1 = new Map<String, Account>();
        for(Account rec : [Select id, Migration_ID2__c From Account Where Migration_ID2__c in :callingIdSet]){
            //取引先Mapの作成（生保申込み側の紐づけ直し用）
            accMap1.put(rec.Migration_ID2__c, rec);
        }
        
        //処理対象となる取引先を取得（生保申込みのリレーションから取得）
        Map<String, Account> accMap2 = new Map<String, Account>();
        for(Account rec : [Select id, Migration_ID2__c From Account Where Id in :accountIdSet]){
            //取引先Mapの作成（取引先の移行用架電ID更新用）
            accMap2.put(rec.Id, rec);
        }

        //主処理
        for(MiniInsurance__c mini : miniList){
            //生保申込みobjの架電IDに対応する取引先の存在確認
            if(accMap1.get(mini.Migration_ID2__c) == Null){
                //■存在しない場合
                //紐づく取引先の架電IDがNULLの場合
                if(    mini.AccountId__c <> Null
                   &&  mini.AccountId__r.Migration_ID2__c == Null){
                    //紐づく取引先に架電IDを設定
                    accMap2.get(mini.AccountId__c).Migration_ID2__c = mini.Migration_ID2__c;
                    updAccountMap.put(mini.AccountId__c, accMap2.get(mini.AccountId__c));
                    //架電IDをキーとして取得した取引先Mapにも追加
                    accMap1.put(mini.AccountId__c, accMap2.get(mini.AccountId__c));
                }
                //紐づく取引先の架電IDがNULLでない場合
                else{
                    mini.AccountId__c = Null;
                }
            }
            else{
                //■生保申込みobjの架電IDに対応する取引先が存在する場合
                //架電IDを使用して取引先に紐づけ
                mini.AccountId__c = accMap1.get(mini.Migration_ID2__c).Id;
            }
        }

        //更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        //ミニ保険オブジェクト（取引先との紐づ記載作成）
        pcdo.dmlOperation(miniList, 'update', 'Patch_SS012_AccMigrationMini - MiniInsurance__c');
        //取引先オブジェクト（架電ID設定）
        pcdo.dmlOperation(updAccountMap.values(), 'update', 'Patch_SS012_AccMigrationMini - Account');  

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