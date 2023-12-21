// =====================================================
// ■商談ライフサイクルデータパッチ
// ■パッチNo.2
// 生命SFDCの活動を取込んだ後、活動の下記を変更する
// 1.見込み確度（D→申込なし）
// 2.生保or汎用のリスト値変換(対応結果（大・中・小分類）、対話者、ステータス)
// 3.損保or少短のリスト値変換(対応結果（中・小分類））
// =====================================================
global class Patch_OL020_MigTaskChgListFieldValue implements Database.Batchable<SObject>, Database.Stateful{

    public Patch_OL020_MigTaskChgListFieldValue() {
    }

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        // 商談の活動取得
        String query = 'Select Id '
                        +      ', Probability__c'
                        +      ', what.RecordType.DeveloperName'
                        +      ',ResultType_Large__c'
                        +      ',ResultType_Middle__c'
                        +      ',ResultType_Small__c'
                        // +      ',Counter__c'
                        +      ',Status'
                        +' From Task'
                        +' Where what.type = \'Opportunity\' and (CallDateTime__c =null or CallDateTime__c > 2000-01-01T00:00:00Z)';
        return Database.getQueryLocator(query);
    }
    
    /**
     * Batchableインタフェースのexecute関数
     * @param Database.BatchableContext
     * @param SObject
     * @return 
     */
    global void execute(Database.BatchableContext bc, List<Task> taskList){
        System.debug('##### Execute start');

        for(Task rec : taskList){
            // 1.見込み確度（D→申込なし）
            if (rec.Probability__c =='D') rec.Probability__c ='申込なし';

            // 2.生保or汎用のリスト値変換(対応結果（大・中・小分類）、対話者、ステータス)
            if (rec.what.RecordType.DeveloperName == 'Seiho' || rec.what.RecordType.DeveloperName == 'Hanyo' ) {

                //大分類・中分類が設定されていなければスキップ
                if (rec.ResultType_Large__c <> null && rec.ResultType_Middle__c <> null) {
                
                    //◆対応結果（大・中・小分類）の変換
                    // 大分類の設定
                    if (rec.ResultType_Large__c == '謝絶フォロー' || rec.ResultType_Middle__c == '発信' || rec.ResultType_Middle__c == '発信(サンキュー)') {
                        rec.ResultType_Large__c = '発信';

                    } else if (rec.ResultType_Middle__c == '入電' || rec.ResultType_Middle__c == '入電(サンキュー)') {
                        rec.ResultType_Large__c = '入電';

                    }else if (rec.ResultType_Middle__c == '折TEL') {
                        rec.ResultType_Large__c = '折TEL';

                    }
                    // 中・少分類の設定
                    // 中:Web誘導
                    if (rec.ResultType_Middle__c.contains('申込了承')) {
                        rec.ResultType_Middle__c = 'Web誘導';
                        rec.ResultType_Small__c  = '了承';

                    } else if (rec.ResultType_Middle__c == '申込拒否') {
                        rec.ResultType_Middle__c = 'Web誘導';
                        rec.ResultType_Small__c  = '拒否';
                        
                    } else if (rec.ResultType_Middle__c.contains('見込作成') || rec.ResultType_Middle__c.contains('検討中')) {
                        rec.ResultType_Middle__c = 'Web誘導';
                        rec.ResultType_Small__c  = '継続検討';

                        
                    //「新契約」かつ「新契約その他」の場合、中分類「問合せ」、小分類未設定で上書き
                    } else if (rec.ResultType_Middle__c == '新契約' && rec.ResultType_Small__c == '新契約その他') {
                        rec.ResultType_Middle__c = '問合せ';
                        rec.ResultType_Small__c  = '';

                    } else if (rec.ResultType_Middle__c == '新契約'
                            || rec.ResultType_Middle__c == '通話'
                            || rec.ResultType_Middle__c == '発信'
                            || rec.ResultType_Middle__c == '入電'
                            || rec.ResultType_Middle__c == '折TEL'
                            || rec.ResultType_Middle__c == '発信(サンキュー)'
                            || rec.ResultType_Middle__c == '入電(サンキュー)') {
                        rec.ResultType_Middle__c = 'Web誘導';

                        //小分類の変換
                        if (rec.ResultType_Small__c == '申込了承') {
                            rec.ResultType_Small__c  = '了承';

                        } else if (rec.ResultType_Small__c == '検討中') {
                            rec.ResultType_Small__c  = '継続検討';

                        } else if (rec.ResultType_Small__c == '申込拒否') {
                            rec.ResultType_Small__c  = '拒否';

                        } else if (rec.ResultType_Small__c == 'アポ禁') {
                            rec.ResultType_Small__c  = '不要';

                        } else if (rec.ResultType_Small__c == 'ミニ保険保障案内済'
                                || rec.ResultType_Small__c == '資料請求案内済'
                                || rec.ResultType_Small__c == '資料到着案内済'
                                || rec.ResultType_Small__c == '見込作成'
                                || rec.ResultType_Small__c == '見込作成（時設）'
                                || rec.ResultType_Small__c == '検討中（時設）') {
                            rec.ResultType_Small__c  = '継続検討';
                        }
                        
                    }
                }

                // 中:申込後架電
                if (rec.ResultType_Middle__c == '申込済') {
                    rec.ResultType_Middle__c = '申込後架電';
                    rec.ResultType_Small__c  = '申込完了';
                }

                // 中:不通
                if (rec.ResultType_Middle__c == '多忙'
                        || rec.ResultType_Middle__c == '本人不在'
                        || rec.ResultType_Middle__c == '留守'
                        || rec.ResultType_Middle__c == '留守電'
                        || rec.ResultType_Middle__c == '電話番号不備'
                        || rec.ResultType_Middle__c == 'システム切電'
                        || rec.ResultType_Middle__c == '発信放棄呼') {
                    //中→小へコピー
                    rec.ResultType_Small__c  = rec.ResultType_Middle__c;
                    rec.ResultType_Middle__c = '不通';

                } else if (rec.ResultType_Middle__c == '話中'
                        || rec.ResultType_Middle__c == 'コール保留'
                        || rec.ResultType_Middle__c == 'アポ禁'
                        || rec.ResultType_Middle__c == 'その他'
                        || rec.ResultType_Middle__c == '次回架電予約') {
                    rec.ResultType_Middle__c = '不通';
                            
                }

                // 中:問合せ
                if (rec.ResultType_Middle__c == '維持'
                        || rec.ResultType_Middle__c == '風評'
                        || rec.ResultType_Middle__c == '楽天グループ'
                        || rec.ResultType_Middle__c == '呼損'
                        || rec.ResultType_Middle__c == '入電その他'
                        || rec.ResultType_Middle__c == '通話（未案内）'
                        || rec.ResultType_Middle__c == '折TELその他') {
                    rec.ResultType_Middle__c = '問合せ';

                }    

                // //◆対話者の変換 　＞生命SFDCからのTask投入時に変換するため不要
                // if (rec.Counter__c == '本人以外') {
                //     rec.Counter__c = 'その他';
                // }

                //◆ステータスの変換
                if (rec.Status == '未完了') {
                    rec.Status = '着手中';
                } else if (rec.Status == 'Completed') {
                    rec.Status = '完了';
                }
            }

            // 3.損保or少短のリスト値変換(対応結果（中・小分類）） ※Patch_OL070_SetCampaignDateAndMoreに類似コードあり（商談の更新）
            if (rec.what.RecordType.DeveloperName == 'Sonpo' || rec.what.RecordType.DeveloperName == 'Syotan' ) {

                //中分類が設定されていなければスキップ
                if (rec.ResultType_Middle__c <> null) {

                    if (rec.ResultType_Middle__c =='Web誘導' || rec.ResultType_Middle__c =='資料送付') {
                        if (rec.ResultType_Small__c <> null) {
                            if (rec.ResultType_Small__c =='投函済み' || rec.ResultType_Small__c =='申込了承') {
                                rec.ResultType_Small__c ='了承';
                            } else if (rec.ResultType_Small__c =='検討中') {
                                rec.ResultType_Small__c ='継続検討';
                            } else if (rec.ResultType_Small__c.contains('NG')) {
                                rec.ResultType_Small__c ='謝絶';
                            }                  
                        }
                    }
                    if (rec.ResultType_Middle__c =='即申込（初回コンタクト時）') {rec.ResultType_Middle__c='Web誘導'; rec.ResultType_Small__c ='申込完了';}
                    if (rec.ResultType_Middle__c =='問合わせ') {rec.ResultType_Middle__c='問合せ';}
                    if (rec.ResultType_Middle__c =='多忙') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='多忙';}
                    if (rec.ResultType_Middle__c =='本人不在') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='本人不在';}
                    if (rec.ResultType_Middle__c =='留守') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='留守';}
                    if (rec.ResultType_Middle__c =='留守電') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='留守電';}
                    if (rec.ResultType_Middle__c =='電話番号不備') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='電話番号不備';}
                    if (rec.ResultType_Middle__c =='架電拒否') {rec.ResultType_Middle__c='不要';}
                    if (rec.ResultType_Middle__c =='アポ禁') {rec.ResultType_Middle__c='不要';}
                    if (rec.ResultType_Middle__c =='その他') {rec.ResultType_Middle__c='不通';}
                    if (rec.ResultType_Middle__c =='システム切電') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='システム切電';}
                    if (rec.ResultType_Middle__c =='発信放棄呼') {rec.ResultType_Middle__c='不通'; rec.ResultType_Small__c ='発信放棄呼';}
                }
            }
            
        }

        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        pcdo.dmlOperation(taskList, 'update', 'Patch_OL020_MigTaskChgListFieldValue');
        // Update taskList;
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