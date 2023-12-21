public class ChatKPINoAgentDailyAggProcessScheduler implements Schedulable {
    private final Integer BATCH_SIZE = 1;

    public void execute(SchedulableContext ctx) {
        ChatKPINoAgentDailyAggProcessBatch batch = new ChatKPINoAgentDailyAggProcessBatch();
        Database.executeBatch(batch, BATCH_SIZE);
    }
}