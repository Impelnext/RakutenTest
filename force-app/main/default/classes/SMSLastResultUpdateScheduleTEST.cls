/**
 * Class containing tests for SMSLastResultUpdateSchedule
 */
@IsTest public with sharing class SMSLastResultUpdateScheduleTEST {
public static String CRON_EXP = '0 0 * * * ?';
    //@IsTest(SeeAllData=true) static void testRegistration() {
    @IsTest() static void testRegistration() {
        SMSLastResultUpdateScheduleTEST controllertest = new SMSLastResultUpdateScheduleTEST();
        
        Test.startTest(); 
        SMSLastResultUpdateSchedule Sch = new SMSLastResultUpdateSchedule();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, Sch);
        
        
        
        Test.stopTest();
    }
}