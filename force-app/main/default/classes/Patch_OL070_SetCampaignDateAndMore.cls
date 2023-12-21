// =====================================================
// ■商談ライフサイクルデータパッチ
// ■パッチNo.7
// 損保・少短の商談に対し下記を更新
// 1.誘導商品のチェックボックス値を、商品種別／商品名に変換
// 2.作成日をキャンペーン日時に設定(未設定の場合のみ)
// 3.商談ステータス「未対応」の変更
// 4.対応結果（中・小分類）の選択リスト変更パッチ
// =====================================================
global class Patch_OL070_SetCampaignDateAndMore implements Database.Batchable<SObject>, Database.Stateful{
    //完了予定日抽出条件
    public Map<Id, User> adminUserMap {get;set;}

    public Patch_OL070_SetCampaignDateAndMore() {

        //システム管理者のUserMap
        adminUserMap = new Map<Id, User> ([SELECT Id FROM User WHERE Profile.Name='System Administrator' or Profile.Name='システム管理者']);

        //本番移行のみで考える！！！

        // ※param　1：事前移行　※抽出条件：完了予定日が２月末まで
        // ※param　2：本番移行　※抽出条件：完了予定日が事前移行データ抽出時以降
        // //事前移行
        // if (param.equals('1')) {
        //     CloseDateCondition = '<2020-03-01';
        // }
        // //本番移行
        // if (param.equals('2')) {
        //     CloseDateCondition = '>=2020-03-01';
        // }
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        // 商談を取得
        String query = 'SELECT ID ,prodtype_multilist__c ,ProdctName__c'
                            +',CampaignDateTime__c ,CreatedDate'
                            +',StageName ,OwnerId'
                            +',IsAnshinPet__c'
                            +',IsOther_Little__c'
                            +',IsFree__c'
                            // +',IsSuper2000__c'
                            // +',IsAnshinPlus_JoseiSupport__c'
                            // +',IsSuperIryou__c'
                            // +',IsAnshinPlus_GanSupport__c'
                            // +',IsSuperTayoreruIryou__c'
                            // +',IsAnshinPlus_NyuinSupport__c'
                            // +',IsSuperGan__c'
                            // +',IsMini__c'
                            // +',IsSuperTeiki__c'
                            // +',IsOther_Life__c'
                            +',IsCycleAssist__c'
                            +',IsDriveAssist__c'
                            +',IsGolfAssist__c'
                            +',Is1Day__c'
                            +',IsHomeAssist__c'
                            +',IsOther_Damage__c'
                            +',IsLivingAssist__c'
                            +',IsTravelAssist_Global__c'
                            +',IsTravelAssist_Domestic__c'
                            +',IsJitensha__c'
                            +',IsMochimonoSupport__c'
                            +',IsJitensha_Child__c'
                            +',IsRentalSupport__c'
                            +',IsGolfer__c'
                            +',IsNichijouBaisyou__c'
                            +',IsOutdoor__c'
                            +',IsChintaiAnshin__c'
                            +',IsSports__c'
                            +',IsKajiDaikou__c'
                            +',IsHareyakaSedai__c'
                            +',IsPapaMamma__c'
                            +',IsOkaimonoAnshin__c'
                            +',IsJosei__c'
                            +',IsOther_BerryEasy__c'
                            +',RecordType.DeveloperName'
                            +',RecentResultType_Middle__c'
                            +',RecentResultType_Small__c'
                        +' From Opportunity'
                        +' Where (RecordType.DeveloperName = \'Sonpo\' or RecordType.DeveloperName = \'Syotan\') and Name!=\'ダミー商談\'';
        return Database.getQueryLocator(query);
    }
    
    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<Opportunity> oppList){
        System.debug('##### Execute start');
        
        for(Opportunity rec : oppList){
            // 1.誘導商品のチェックボックス値を、商品種別／商品名に変換
            Set<String> productTypeSet = new Set<String>();
            List<String> productList = new List<String>();
            if (rec.IsAnshinPet__c) {productList.add('あんしんペット保険'); productTypeSet.add('ペット');}
            if (rec.IsOther_Little__c) {productList.add('その他商品_少短'); productTypeSet.add('その他');}
            if (rec.IsFree__c) {productList.add('フリー保険'); productTypeSet.add('その他');}
            // if (rec.IsSuper2000__c) {productList.add('楽天生命スーパー2000'); productTypeSet.add('総合保障');}
            // if (rec.IsAnshinPlus_JoseiSupport__c) {productList.add('楽天生命あんしんプラス（女性サポート）'); productTypeSet.add('一時金保障（ガン有）');}
            // if (rec.IsSuperIryou__c) {productList.add('楽天生命スーパー医療保険'); productTypeSet.add('医療（ガン有）');}
            // if (rec.IsAnshinPlus_GanSupport__c) {productList.add('楽天生命あんしんプラス（がんサポート）'); productTypeSet.add('一時金保障（ガン有）');}
            // if (rec.IsSuperTayoreruIryou__c) {productList.add('楽天生命スーパーたよれる医療保険'); productTypeSet.add('医療（ガン有）');}
            // if (rec.IsAnshinPlus_NyuinSupport__c) {productList.add('楽天生命あんしんプラス（入院サポート）'); productTypeSet.add('一時金保障');}
            // if (rec.IsSuperGan__c) {productList.add('楽天生命スーパーがん保険'); productTypeSet.add('医療（ガン有）');}
            // if (rec.IsMini__c) {productList.add('ミニ保険'); productTypeSet.add('医療（ガン有）');}
            // if (rec.IsSuperTeiki__c) {productList.add('楽天生命スーパー定期保険'); productTypeSet.add('死亡');}
            // if (rec.IsOther_Life__c) {productList.add('その他商品_生命'); productTypeSet.add('その他');}
            if (rec.IsCycleAssist__c) {productList.add('サイクルアシスト（傷害総合保険）'); productTypeSet.add('自転車');}
            if (rec.IsDriveAssist__c) {productList.add('ドライブアシスト（自動車保険）'); productTypeSet.add('自動車');}
            if (rec.IsGolfAssist__c) {productList.add('ゴルフアシスト（傷害総合保険）'); productTypeSet.add('レジャー');}
            if (rec.Is1Day__c) {productList.add('1日保険シリーズ'); productTypeSet.add('レジャー');}
            if (rec.IsHomeAssist__c) {productList.add('ホームアシスト（家庭総合保険）'); productTypeSet.add('住宅');}
            if (rec.IsOther_Damage__c) {productList.add('その他商品_損保'); productTypeSet.add('その他');}
            if (rec.IsLivingAssist__c) {productList.add('リビングアシスト（リビングアシスト総合保険）'); productTypeSet.add('住宅');}
            if (rec.IsTravelAssist_Global__c) {productList.add('トラベルアシスト（海外旅行保険）'); productTypeSet.add('レジャー');}
            if (rec.IsTravelAssist_Domestic__c) {productList.add('トラベルアシスト（国内旅行傷害保険）'); productTypeSet.add('レジャー');}
            if (rec.IsJitensha__c) {productList.add('自転車保険プラン'); productTypeSet.add('自転車');}
            if (rec.IsMochimonoSupport__c) {productList.add('持ち物サポートプラン'); productTypeSet.add('その他');}
            if (rec.IsJitensha_Child__c) {productList.add('自転車保険プラン(子供コース)'); productTypeSet.add('自転車');}
            if (rec.IsRentalSupport__c) {productList.add('レンタル品サポートプラン'); productTypeSet.add('その他');}
            if (rec.IsGolfer__c) {productList.add('ゴルファー保険プラン'); productTypeSet.add('レジャー');}
            if (rec.IsNichijouBaisyou__c) {productList.add('日常賠償プラン'); productTypeSet.add('その他');}
            if (rec.IsOutdoor__c) {productList.add('アウトドアプラン'); productTypeSet.add('レジャー');}
            if (rec.IsChintaiAnshin__c) {productList.add('賃貸あんしんプラン'); productTypeSet.add('住宅');}
            if (rec.IsSports__c) {productList.add('スポーツプラン'); productTypeSet.add('レジャー');}
            if (rec.IsKajiDaikou__c) {productList.add('家事代行プラン'); productTypeSet.add('その他');}
            if (rec.IsHareyakaSedai__c) {productList.add('晴れやか世代プラン'); productTypeSet.add('その他');}
            if (rec.IsPapaMamma__c) {productList.add('パパママプラン'); productTypeSet.add('その他');}
            if (rec.IsOkaimonoAnshin__c) {productList.add('お買い物あんしんプラン'); productTypeSet.add('その他');}
            if (rec.IsJosei__c) {productList.add('女性プラン'); productTypeSet.add('その他');}
            if (rec.IsOther_BerryEasy__c) {productList.add('その他商品_超かんたん保険'); productTypeSet.add('その他');}
                        
            //商品種類を設定（複数選択リスト）
            // System.debug('★'+ productTypeSet);
            rec.prodtype_multilist__c = String.join(new List<String>(productTypeSet),';');

            //商品名を改行つなぎ
            for (String product : productList) {
                if (rec.ProdctName__c != null) {
                    rec.ProdctName__c += '\n'+ product;
                } else {
                    rec.ProdctName__c = product;
                }
            }

            // 2.作成日をキャンペーン日時に設定
            if (rec.CampaignDateTime__c == null) rec.CampaignDateTime__c = rec.CreatedDate;

            // 3.商談ステータス「未対応」の変更
            //OwnerIdがシステム管理者の場合、商談ステータス「未割当」に変更
            if (adminUserMap.get(rec.OwnerId) != NULL && rec.StageName == '未対応') rec.StageName = '未割当'; 

            // // 4.対応結果（中・小分類）の選択リスト変更パッチ　＞ダミー活動削除時の活動トリガーで設定されるため、不要
            // //中分類が設定されていなければスキップ
            // if (rec.RecentResultType_Middle__c <> null) {

            //     if (rec.RecentResultType_Middle__c =='Web誘導' || rec.RecentResultType_Middle__c =='資料送付') {
            //         if (rec.RecentResultType_Small__c <> null) {

            //             if (rec.RecentResultType_Small__c =='投函済み' || rec.RecentResultType_Small__c =='申込了承') {
            //                 rec.RecentResultType_Small__c ='了承';
            //             } else if (rec.RecentResultType_Small__c =='検討中') {
            //                 rec.RecentResultType_Small__c ='継続検討';
            //             } else if (rec.RecentResultType_Small__c.contains('NG')) {
            //                 rec.RecentResultType_Small__c ='謝絶';
            //             }                  
            //         }
            //     }

            //     if (rec.RecentResultType_Middle__c =='即申込（初回コンタクト時）') {rec.RecentResultType_Middle__c='Web誘導'; rec.RecentResultType_Small__c ='申込完了';}
            //     if (rec.RecentResultType_Middle__c =='問合わせ') {rec.RecentResultType_Middle__c='問合せ';}
            //     if (rec.RecentResultType_Middle__c =='多忙') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='多忙';}
            //     if (rec.RecentResultType_Middle__c =='本人不在') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='本人不在';}
            //     if (rec.RecentResultType_Middle__c =='留守') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='留守';}
            //     if (rec.RecentResultType_Middle__c =='留守電') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='留守電';}
            //     if (rec.RecentResultType_Middle__c =='電話番号不備') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='電話番号不備';}
            //     if (rec.RecentResultType_Middle__c =='架電拒否') {rec.RecentResultType_Middle__c='不要';}
            //     if (rec.RecentResultType_Middle__c =='アポ禁') {rec.RecentResultType_Middle__c='不要';}
            //     if (rec.RecentResultType_Middle__c =='その他') {rec.RecentResultType_Middle__c='不通';}
            //     if (rec.RecentResultType_Middle__c =='システム切電') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='システム切電';}
            //     if (rec.RecentResultType_Middle__c =='発信放棄呼') {rec.RecentResultType_Middle__c='不通'; rec.RecentResultType_Small__c ='発信放棄呼';}
            // }
        }
        
        //商談を更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(oppList, 'update', 'Patch_OL070_SetCampaignDateAndMore');
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