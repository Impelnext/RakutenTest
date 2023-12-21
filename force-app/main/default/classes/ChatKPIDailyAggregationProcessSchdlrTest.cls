@IsTest
public class ChatKPIDailyAggregationProcessSchdlrTest {

    public static String CRON_EXP = '0 0 * * * ?';

    @IsTest
    static void testRegistration() {
        
        Test.startTest(); 

        ChatKPIDailyAggregationProcessScheduler Sch = new ChatKPIDailyAggregationProcessScheduler();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, Sch);

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals(ChatKPIDailyAggregationProcessSchdlrTest.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}