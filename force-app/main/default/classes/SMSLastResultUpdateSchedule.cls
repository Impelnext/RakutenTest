global class SMSLastResultUpdateSchedule implements Schedulable{
    global SMSLastResultUpdateSchedule(){

    }

    global void execute(System.SchedulableContext ctx) {

        SMSLastUpdateResultBatch sar = new SMSLastUpdateResultBatch();
        Id putjobid;
        putjobid = Database.executeBatch(sar);
        
    }
}