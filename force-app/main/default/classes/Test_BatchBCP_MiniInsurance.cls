@isTest
public class Test_BatchBCP_MiniInsurance {
    /***********************************************************************/
    /* Method Name:    Test_BatchBCP_MiniInsurance                         */
    /* Description:    Test Method for BatchBCP_MiniInsurance              */
    /***********************************************************************/
    @isTest static void main(){
        //ミニ保険作成
        MiniInsurance__c mini1 = new MiniInsurance__c (name = '契約満了', entry_status__c = '契約満了',email__c = 'test1@rakuten.com');
        insert mini1;
        MiniInsurance__c mini2 = new MiniInsurance__c (name = '支払消滅', entry_status__c = '支払消滅',email__c = 'test2@rakuten.com');
        insert mini2;
        MiniInsurance__c mini3 = new MiniInsurance__c (name = '有効中', entry_status__c = '有効中',email__c = 'test3@rakuten.com');
        insert mini3;
        MiniInsurance__c mini4 = new MiniInsurance__c (name = '有効中（免責期間中）', entry_status__c = '有効中（免責期間中）',email__c = 'test4@rakuten.com');
        insert mini4;
        //加入ステータスが増えたら追記してください。    
        
        Test.startTest();
        BatchBCP_MiniInsuranceDisappearanceCSV batch = new BatchBCP_MiniInsuranceDisappearanceCSV();
        batch.executeBatchBCP_MiniInsuranceDisappearanceCSV();
        Test.stopTest();
    }
    
    /*****************************************************************************/
    /* Method Name:    testBatchSchedule                                         */
    /* Description:    Test Method  for Schedule Execute                         */
    /*****************************************************************************/
    public static testMethod void testBatchSchedule() {
        //ミニ保険作成
        MiniInsurance__c mini1 = new MiniInsurance__c (name = '契約満了', entry_status__c = '契約満了',email__c = 'test1@rakuten.com');
        insert mini1;
        MiniInsurance__c mini2 = new MiniInsurance__c (name = '支払消滅', entry_status__c = '支払消滅',email__c = 'test2@rakuten.com');
        insert mini2;
        MiniInsurance__c mini3 = new MiniInsurance__c (name = '有効中', entry_status__c = '有効中',email__c = 'test3@rakuten.com');
        insert mini3;
        MiniInsurance__c mini4 = new MiniInsurance__c (name = '有効中（免責期間中）', entry_status__c = '有効中（免責期間中）',email__c = 'test4@rakuten.com');
        insert mini4;
        //加入ステータスが増えたら追記してください。

        Test.startTest();
        BatchBCP_MiniInsuranceDisappearanceCSV batch = new BatchBCP_MiniInsuranceDisappearanceCSV();
        batch.executeBatchBCP_MiniInsuranceDisappearanceCSV();
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