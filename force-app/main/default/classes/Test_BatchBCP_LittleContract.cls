@isTest
public class Test_BatchBCP_LittleContract {
    /***********************************************************************/
    /* Method Name:    Test_BatchBCP_LittleContract                        */
    /* Description:    Test Method for BatchBCP_LittleContract             */
    /***********************************************************************/
    @isTest static void main(){
        //少短契約情報
        LittleContract__c life1 = new LittleContract__c (name = '申込入力済', SubscriberStatus__c = '10',ContractorEmail__c = 'test1@rakuten.com');
        insert life1;
        LittleContract__c life2 = new LittleContract__c (name = '入力確定済', SubscriberStatus__c = '11',ContractorEmail__c = 'test2@rakuten.com');
        insert life2;
        LittleContract__c life3 = new LittleContract__c (name = '保険料確定済', SubscriberStatus__c = '40',ContractorEmail__c = 'test3@rakuten.com');
        insert life3;
        LittleContract__c life4 = new LittleContract__c (name = '本社受付済', SubscriberStatus__c = '50',ContractorEmail__c = 'test4@rakuten.com');
        insert life4;
        LittleContract__c life5 = new LittleContract__c (name = '有効', SubscriberStatus__c = '80',ContractorEmail__c = 'test5@rakuten.com');
        insert life5;
        LittleContract__c life6 = new LittleContract__c (name = '消滅', SubscriberStatus__c = '90',ContractorEmail__c = 'test6@rakuten.com');
        insert life6;
        //契約状態が増えたら追記してください。    
        
        Test.startTest();
        BatchBCP_LittleContractEnteredCSV batch = new BatchBCP_LittleContractEnteredCSV();
        batch.executeBatchBCP_LittleContractEnteredCSV();
        Test.stopTest();
    }
    
    /*****************************************************************************/
    /* Method Name:    testBatchSchedule                                         */
    /* Description:    Test Method  for Schedule Execute                         */
    /*****************************************************************************/
    public static testMethod void testBatchSchedule() {
        //少短契約情報
        LittleContract__c life1 = new LittleContract__c (name = '申込入力済', SubscriberStatus__c = '10',ContractorEmail__c = 'test1@rakuten.com');
        insert life1;
        LittleContract__c life2 = new LittleContract__c (name = '入力確定済', SubscriberStatus__c = '11',ContractorEmail__c = 'test2@rakuten.com');
        insert life2;
        LittleContract__c life3 = new LittleContract__c (name = '保険料確定済', SubscriberStatus__c = '40',ContractorEmail__c = 'test3@rakuten.com');
        insert life3;
        LittleContract__c life4 = new LittleContract__c (name = '本社受付済', SubscriberStatus__c = '50',ContractorEmail__c = 'test4@rakuten.com');
        insert life4;
        LittleContract__c life5 = new LittleContract__c (name = '有効', SubscriberStatus__c = '80',ContractorEmail__c = 'test5@rakuten.com');
        insert life5;
        LittleContract__c life6 = new LittleContract__c (name = '消滅', SubscriberStatus__c = '90',ContractorEmail__c = 'test6@rakuten.com');
        insert life6;
        //契約状態が増えたら追記してください。
        
        Test.startTest();
        BatchBCP_LittleContractEnteredCSV batch = new BatchBCP_LittleContractEnteredCSV();
        batch.executeBatchBCP_LittleContractEnteredCSV();
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