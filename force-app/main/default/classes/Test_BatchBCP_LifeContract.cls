@isTest
public class Test_BatchBCP_LifeContract {
    /***********************************************************************/
    /* Method Name:    Test_BatchBCP_LifeContract                          */
    /* Description:    Test Method for BatchBCP_LifeContract               */
    /***********************************************************************/
    @isTest static void main(){
        //生保契約情報
        LifeContract__c life1 = new LifeContract__c (name = '契約承諾', STATUS__c = '00',EMAIL_ADDRESS__c = 'test1@rakuten.com');
        insert life1;
        LifeContract__c life2 = new LifeContract__c (name = '有効', STATUS__c = '01',EMAIL_ADDRESS__c = 'test2@rakuten.com');
        insert life2;
        LifeContract__c life3 = new LifeContract__c (name = '入金確認待ち（併徴）', STATUS__c = '02',EMAIL_ADDRESS__c = 'test3@rakuten.com');
        insert life3;
        LifeContract__c life4 = new LifeContract__c (name = '失効', STATUS__c = '03',EMAIL_ADDRESS__c = 'test4@rakuten.com');
        insert life4;
        LifeContract__c life5 = new LifeContract__c (name = '仮更新', STATUS__c = '04',EMAIL_ADDRESS__c = 'test5@rakuten.com');
        insert life5;
        //契約ステータスが増えたら追記してください。    
        
        Test.startTest();
        BatchBCP_LifeContractAcceptanceCSV batch = new BatchBCP_LifeContractAcceptanceCSV();
        batch.executeBatchBCP_LifeContractAcceptanceCSV();
        Test.stopTest();
    }
    
    /*****************************************************************************/
    /* Method Name:    testBatchSchedule                                         */
    /* Description:    Test Method  for Schedule Execute                         */
    /*****************************************************************************/
    public static testMethod void testBatchSchedule() {
        //生保契約情報
        LifeContract__c life1 = new LifeContract__c (name = '契約承諾', STATUS__c = '00',EMAIL_ADDRESS__c = 'test1@rakuten.com');
        insert life1;
        LifeContract__c life2 = new LifeContract__c (name = '有効', STATUS__c = '01',EMAIL_ADDRESS__c = 'test2@rakuten.com');
        insert life2;
        LifeContract__c life3 = new LifeContract__c (name = '入金確認待ち（併徴）', STATUS__c = '02',EMAIL_ADDRESS__c = 'test3@rakuten.com');
        insert life3;
        LifeContract__c life4 = new LifeContract__c (name = '失効', STATUS__c = '03',EMAIL_ADDRESS__c = 'test4@rakuten.com');
        insert life4;
        LifeContract__c life5 = new LifeContract__c (name = '仮更新', STATUS__c = '04',EMAIL_ADDRESS__c = 'test5@rakuten.com');
        insert life5;
        //契約ステータスが増えたら追記してください。

        Test.startTest();
        BatchBCP_LifeContractAcceptanceCSV batch = new BatchBCP_LifeContractAcceptanceCSV();
        batch.executeBatchBCP_LifeContractAcceptanceCSV();
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