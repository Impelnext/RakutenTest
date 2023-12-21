@isTest
public class Test_BatchBCP_Damage {
    /***********************************************************************/
    /* Method Name:    Test_BatchBCP_Damage                                */
    /* Description:    Test Method for BatchBCP_Damage                     */
    /***********************************************************************/
    @isTest static void main(){
        Date beforeDay = system.today().addYears(-1);
        Datetime newDay1 = Datetime.newInstance(beforeDay.year(), beforeDay.month(), beforeDay.day());
        String dayStr = newDay1.format('yyyyMMdd');
        
        Date afterDay = system.today().addYears(1);
        Datetime newDay2 = Datetime.newInstance(afterDay.year(), afterDay.month(), afterDay.day());
        String dayStr2 = newDay2.format('yyyyMMdd');
        
        //取引先作成
        Account acc1 = new Account(LastName ='TEST取引先');
        insert acc1;
        Account acc2 = new Account(LastName ='TEST取引先');
        insert acc2;
        Account acc3 = new Account(LastName ='TEST取引先');
        insert acc3;
        
        //商談作成
        Id recordTypeIdOPP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('損保').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Test',ANP__c = 1234,StageName = '対応中',RecentProbability__c = '申込なし',
            CloseDate = system.today(),RecordTypeId = recordTypeIdOPP,AccountId = acc1.Id
        );
        
        //損保契約情報
        DamageContract__c damage1 = new DamageContract__c (name = '取消', ContractStatus__c = '取消',Mail__c = 'test1@rakuten.com',
                                                          ContractUniqueKey__c ='取消',AccountId__c = acc1.Id,Opportunity__c = opp.Id
                                                          );
        insert damage1;
        
        DamageContract__c damage2 = new DamageContract__c (name = '解約', ContractStatus__c = '解約',Mail__c = 'test2@rakuten.com',
                                                          ContractUniqueKey__c ='解約',AccountId__c = acc2.Id,Opportunity__c = opp.Id);
        insert damage2;
        
        DamageContract__c damage3 = new DamageContract__c (name = '新規契約', ContractStatus__c = '新規契約',Mail__c = 'test3@rakuten.com',
                                                          ContractUniqueKey__c ='新規契約',AccountId__c = acc3.Id,Opportunity__c = opp.Id,
                                                          ContractEndDate__c = dayStr2,ContractStartDate__c = dayStr2,AcceptedClassification__c = '新規契約'
                                                          );
        insert damage3;
        
        Test.startTest();
        BatchBCP_DamageCancelCSV batch = new BatchBCP_DamageCancelCSV();
        batch.executeBatchBCP_DamageCancelCSV();
        Test.stopTest();
    }
    
    /*****************************************************************************/
    /* Method Name:    testBatchSchedule                                         */
    /* Description: 4つ以上損保契約情報を作成するとDamageContractTriggerHandlerの*/ 
    /*              line 324でToo many SOQLになってしまう為、残り3つはこちらで   */
    /*              処理を記載する。                                             */
    /*****************************************************************************/
    public static testMethod void testBatchSchedule() {
        Date beforeDay = system.today().addYears(-1);
        Datetime newDay1 = Datetime.newInstance(beforeDay.year(), beforeDay.month(), beforeDay.day());
        String dayStr = newDay1.format('yyyyMMdd');
        
        Date afterDay = system.today().addYears(1);
        Datetime newDay2 = Datetime.newInstance(afterDay.year(), afterDay.month(), afterDay.day());
        String dayStr2 = newDay2.format('yyyyMMdd');
        
        //取引先作成
        Account acc4 = new Account(LastName ='TEST取引先');
        insert acc4;
        Account acc5 = new Account(LastName ='TEST取引先');
        insert acc5;
        Account acc6 = new Account(LastName ='TEST取引先');
        insert acc6;
        
        //商談作成
        Id recordTypeIdOPP = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('損保').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'Test',ANP__c = 1234,StageName = '対応中',RecentProbability__c = '申込なし',
            CloseDate = system.today(),RecordTypeId = recordTypeIdOPP,AccountId = acc4.Id
        );
        
        //損保契約情報
        DamageContract__c damage4 = new DamageContract__c (name = '満期更改', Mail__c = 'test4@rakuten.com',
                                                          ContractUniqueKey__c ='満期更改',AccountId__c = acc4.Id,Opportunity__c = opp.Id,
                                                          ContractEndDate__c =dayStr2,ContractStartDate__c= dayStr2,AcceptedClassification__c = '満期更改'
                                                          );
        insert damage4;
        
        DamageContract__c damage5 = new DamageContract__c (name = '満了', Mail__c = 'test5@rakuten.com',
                                                          ContractUniqueKey__c ='満了',AccountId__c = acc5.Id,Opportunity__c = opp.Id,
                                                          ContractEndDate__c =dayStr,ContractStartDate__c= '満了'
                                                          );
        insert damage5;
        
        DamageContract__c damage6 = new DamageContract__c (name = '有効', Mail__c = 'test6@rakuten.com',
                                                          ContractUniqueKey__c ='有効',AccountId__c = acc6.Id,Opportunity__c = opp.Id,
                                                          ContractEndDate__c = dayStr2,ContractStartDate__c = dayStr,AcceptedClassification__c = '有効'
                                                          );
        insert damage6;

        //契約ステータスが増えたら追記してください。
        
        Test.startTest();
        BatchBCP_DamageCancelCSV batch = new BatchBCP_DamageCancelCSV();
        batch.executeBatchBCP_DamageCancelCSV();
        DateTime currentTime = System.now().addSeconds(5);
        String CRON_EXP = currentTime.second() + ' '
                    + currentTime.minute() + ' '
                    + currentTime.hour() + ' '
                    + currentTime.day() + ' '
                    + currentTime.month() + ' '
                    + '? '
                    + currentTime.year();
        String jobId = System.schedule('main', CRON_EXP, batch );
        Test.stopTest();

    }
}