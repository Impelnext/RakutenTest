@isTest
public class Test_BatchBCP_GeneralPresent {
    /***********************************************************************/
    /* Method Name:    Test_BatchBCP_GeneralPresent                        */
    /* Description:    Test Method for BatchBCP_GeneralPresent             */
    /***********************************************************************/
    @isTest static void main(){
        //損保プレゼント保険
        GeneralPresentInsurance__c general = new GeneralPresentInsurance__c (name = '加入中', EntryStatus__c = '加入中',Email__c = 'test1@rakuten.com');
        insert general;
        //加入ステータスが増えたら追記してください。  
        
        Test.startTest();
        BatchBCP_GeneralPresentSubscriptionCSV batch = new BatchBCP_GeneralPresentSubscriptionCSV();
        batch.executeBatchBCP_GeneralPresentSubscriptionCSV();
        Test.stopTest();
    }
    
    /*****************************************************************************/
    /* Method Name:    testBatchSchedule                                         */
    /* Description:    Test Method  for Schedule Execute                         */
    /*****************************************************************************/
    public static testMethod void testBatchSchedule() {
        //損保プレゼント保険
        GeneralPresentInsurance__c general = new GeneralPresentInsurance__c (name = '加入中', EntryStatus__c = '加入中',Email__c = 'test1@rakuten.com');
        insert general;
        //加入ステータスが増えたら追記してください。

        Test.startTest();
        BatchBCP_GeneralPresentSubscriptionCSV batch = new BatchBCP_GeneralPresentSubscriptionCSV();
        batch.executeBatchBCP_GeneralPresentSubscriptionCSV();
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