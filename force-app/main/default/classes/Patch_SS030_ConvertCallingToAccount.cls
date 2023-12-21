// =====================================================
// ■パッチNo.3
// 対応する取引先が見つかっていない移行用架電データを
// 使用し取引先を作成or探し出す。
// =====================================================
global class Patch_SS030_ConvertCallingToAccount implements Database.Batchable<SObject>, Database.Stateful{

    public Patch_SS030_ConvertCallingToAccount() {}

    /**
     * BatchableインタフェースのStart関数
     * @param Database.BatchableContext
     * @return 
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('##### Start');
        // 移行用架電のうち対応する取引先が見つかっていないレコードを取得
        String query = 'Select Id '
                      +      ',Name '
                      +      ',MigratedFlag__c '
                      +      ',FirstName_BD2M__c '
                      +      ',LastName_BD2M__c '
                      +      ',FirstNameKana__c '
                      +      ',LastNameKana__c '
                      +      ',Phone__c '
                      +      ',MobilePhone__c '
                      +      ',Birthdate_BD2M__c '
                      +      ',Gender_BD2M__c '
                      +'From MigrationCalling__c '
                      +'Where MigratedFlag__c = False';
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
        Map<String, Account> accNameMap = new Map<String, Account>();
        Map<String,List<Account>> existNameInfoAccountMap = new Map<String,List<Account>>();
        Set<String> callingNameSet = new Set<String>();
        Map<Id, Account> updAccountMap = new Map<Id, Account>();
        List<Account> insAccount = new List<Account>();

        //処理対象となる移行用架電objのフリガナ姓名のSet作成
        for(MigrationCalling__c rec : callingList){
            if(   rec.LastNameKana__c <> Null
               || rec.FirstNameKana__c <> Null){
                //架電オブジェクトの名前
                callingNameSet.add(rec.LastNameKana__c + rec.FirstNameKana__c); 
            }
        }
        
        for(Account rec : [Select id, Migration_ID2__c, SysAccountNameKana__pc, PersonHomePhone, PersonMobilePhone, PersonBirthdate
                           From Account Where SysAccountNameKana__pc in :callingNameSet And Migration_ID2__c = Null]){
            if(existNameInfoAccountMap.get(rec.SYSAccountNameKana__pc) == NULL){
                List<Account> accList = new List<Account>();
                accList.add(rec);
                existNameInfoAccountMap.put(rec.SYSAccountNameKana__pc,accList);
            }else{
                existNameInfoAccountMap.get(rec.SYSAccountNameKana__pc).add(rec);
            }
        }

        //主処理（架電IDから存在確認できるパターン）
        for(MigrationCalling__c mig : callingList){
            String nameKey = mig.LastNameKana__c + mig.FirstNameKana__c;
            //既に取引先に存在している架電IDの場合
            if(existNameInfoAccountMap.get(nameKey) <> Null){
                // 姓名情報が一致するレコードを繰り返す
                List<Account> accList = existNameInfoAccountMap.get(nameKey);
                if(accList <> NULL){
                    for(Account acc : existNameInfoAccountMap.get(nameKey)){
                        // 固定電話番号か携帯電話番号のいずれか一致する
                        if(    (   mig.Phone__c <> Null
                                && acc.PersonHomePhone <> Null
                                && mig.Phone__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                            || (   mig.MobilePhone__c <> Null
                                && acc.PersonMobilePhone <> Null
                                && mig.MobilePhone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))
                            || (   mig.Phone__c <> Null
                                && acc.PersonMobilePhone <> Null
                                && mig.Phone__c.replace('-','').equals(acc.PersonMobilePhone.replace('-','')))
                            || (   mig.MobilePhone__c <> Null
                                && acc.PersonHomePhone <> Null
                                && mig.MobilePhone__c.replace('-','').equals(acc.PersonHomePhone.replace('-','')))
                        ){
                            mig.MigratedFlag__c = True;
                            mig.AccountId__c = acc.Id;
                            acc.Migration_ID2__c = mig.Name;
                            acc.MigrationCalling__c = mig.Id;
                            if(updAccountMap.get(acc.id) == Null){
                                updAccountMap.put(acc.id, acc);
                            }
                            
                            break;
                        }
                        // 生年月日かつ性別が一致する
                        else if(   mig.Birthdate_BD2M__c <> Null
                                && acc.PersonBirthdate <> Null
                                && mig.Birthdate_BD2M__c == acc.PersonBirthdate){ 
                            mig.MigratedFlag__c = True;
                            mig.AccountId__c = acc.Id;
                            acc.Migration_ID2__c = mig.Name;
                            acc.MigrationCalling__c = mig.Id;
                            if(updAccountMap.get(acc.id) == Null){
                                updAccountMap.put(acc.id, acc);
                            }
                            break;
                        }
                    }
                }
            }
        }

        for(MigrationCalling__c mig : callingList){
            //取引先に存在しない架電の場合
            if(mig.MigratedFlag__c == False){
                Account tmpAcc = new Account();
                tmpAcc.Migration_ID2__c = mig.Name;
                tmpAcc.firstname = mig.FirstName_BD2M__c;
                tmpAcc.firstname__pc = mig.FirstName_BD2M__c;
                tmpAcc.LastName = mig.LastName_BD2M__c;
                tmpAcc.LastName__pc = mig.LastName_BD2M__c;
                tmpAcc.furiganaForst__pc = mig.FirstNameKana__c;
                tmpAcc.furiganaLast__pc = mig.LastNameKana__c;
                tmpAcc.PersonHomePhone = mig.Phone__c;
                tmpAcc.PersonMobilePhone = mig.MobilePhone__c;
                tmpAcc.PersonBirthdate = mig.Birthdate_BD2M__c;
                tmpAcc.Gender__pc = mig.Gender_BD2M__c;
                tmpAcc.MigrationCalling__c = mig.Id;
                if(tmpAcc.firstname == Null){
                    tmpAcc.firstname = mig.FirstNameKana__c;
                    tmpAcc.firstname__pc = mig.FirstNameKana__c;
                }
                if(tmpAcc.LastName == Null){
                    tmpAcc.LastName = mig.LastNameKana__c;
                    tmpAcc.LastName__pc = mig.LastNameKana__c;
                }
                if(tmpAcc.LastName == Null){
                    tmpAcc.LastName = '不明';
                    tmpAcc.LastName__pc = '不明';
                }
                insAccount.add(tmpAcc);
                mig.MigratedFlag__c = True;
            }
        }

        //登録更新
        Patch_CommonDmlOperation pcdo = new Patch_CommonDmlOperation();
        //架電オブジェクト（取引先との紐づ記載作成）
        pcdo.dmlOperation(callingList, 'update', 'Patch_SS030_ConvertCallingToAccount - SeihoLead__c');
        //取引先オブジェクト（架電ID設定）
        pcdo.dmlOperation(updAccountMap.values(), 'update', 'Patch_SS030_ConvertCallingToAccount - Update Account'); 
        pcdo.dmlOperation(insAccount, 'insert', 'Patch_SS030_ConvertCallingToAccount - Insert Account'); 

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