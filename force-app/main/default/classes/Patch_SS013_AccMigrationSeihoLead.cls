// =====================================================
// ■パッチNo.1-3
// 生保資料請求objと取引先objの紐づきを
// 架電IDを使用して紐づけ直すパッチ用Apexバッチ
// =====================================================
global class Patch_SS013_AccMigrationSeihoLead implements Database.Batchable<SObject>, Database.Stateful{
    Datetime targetDatetime;
    public Patch_SS013_AccMigrationSeihoLead(Datetime paramDatetime) {
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
                      +      ',Ref_Account__c '
                      +      ',Ref_Account__r.Migration_ID2__c '
                      +      ',Migration_ID2__c '
                      +'From SeihoLead__c '
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
    global void execute(Database.BatchableContext bc, List<SeihoLead__c> seihoLeadList){
        System.debug('##### Execute start');
        Map<String, Account> updAccountMap = new Map<String, Account>();
        Map<String, MigrationCalling__c> updCallingMap = new Map<String, MigrationCalling__c>();

        Set<String> callingIdSet = new Set<String>();
        Set<Id> accountIdSet = new Set<Id>();

        //処理対象となる架電IDのセットを作成
        for(SeihoLead__c rec : seihoLeadList){
            if(rec.Migration_ID2__c <> Null) callingIdSet.add(rec.Migration_ID2__c);
            if(rec.Ref_Account__c <> Null) accountIdSet.add(rec.Ref_Account__c);
        }
        
        //処理対象となる取引先を取得（架電IDをキーとして取得）
        Map<String, Account> accMap1 = new Map<String, Account>();
        for(Account rec : [Select id, Migration_ID2__c From Account Where Migration_ID2__c in :callingIdSet]){
            //取引先Mapの作成（生保資料請求側の紐づけ直し用）
            accMap1.put(rec.Migration_ID2__c, rec);
        }
        
        //処理対象となる取引先を取得（生保申資料請求のリレーションから取得）
        Map<String, Account> accMap2 = new Map<String, Account>();
        for(Account rec : [Select id, Migration_ID2__c From Account Where Id in :accountIdSet]){
            //取引先Mapの作成（取引先の移行用架電ID更新用）
            accMap2.put(rec.Id, rec);
        }

        //主処理
        for(SeihoLead__c seiho : seihoLeadList){
            //生保資料請求objの架電IDに対応する取引先の存在確認
            if(accMap1.get(seiho.Migration_ID2__c) == Null){
                //■存在しない場合
                //紐づく取引先の架電IDがNULLの場合
                if(    seiho.Ref_Account__c <> Null
                    && seiho.Ref_Account__r.Migration_ID2__c == Null){
                    //紐づく取引先に架電IDを設定
                    if(accMap2.get(seiho.Ref_Account__c) <> Null){
                        accMap2.get(seiho.Ref_Account__c).Migration_ID2__c = seiho.Migration_ID2__c;
                        updAccountMap.put(seiho.Ref_Account__c, accMap2.get(seiho.Ref_Account__c));
                        //架電IDをキーとして取得した取引先Mapにも追加
                        accMap1.put(seiho.Ref_Account__c, accMap2.get(seiho.Ref_Account__c));
                    }
                }
                //資料請求が紐づく取引先の架電IDがNULLでない場合
                else{
                    seiho.Ref_Account__c = Null;
                }
            }
            else{
                //■生保資料請求objの架電IDに対応する取引先が存在する場合
                //架電IDを使用して取引先に紐づけ
                seiho.Ref_Account__c = accMap1.get(seiho.Migration_ID2__c).Id;
            }
        }

        //更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        //生保資料請求オブジェクト（取引先との紐づ記載作成）
        pcdo.dmlOperation(seihoLeadList, 'update', 'Patch_SS013_AccMigrationSeihoLead - SeihoLead__c');
        //取引先オブジェクト（架電ID設定）
        pcdo.dmlOperation(updAccountMap.values(), 'update', 'Patch_SS013_AccMigrationSeihoLead - Account'); 

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