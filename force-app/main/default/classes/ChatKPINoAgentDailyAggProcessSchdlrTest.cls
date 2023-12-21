@IsTest
public class ChatKPINoAgentDailyAggProcessSchdlrTest {

    public static String CRON_EXP = '0 0 * * * ?';

    @IsTest
    static void testRegistration() {

        Test.startTest();

        ChatKPINoAgentDailyAggProcessScheduler Sch = new ChatKPINoAgentDailyAggProcessScheduler();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, Sch);
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals(ChatKPINoAgentDailyAggProcessSchdlrTest.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        
        Test.stopTest();
    }
}