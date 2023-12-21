public class ChatKPIDailyAggregationProcessScheduler implements Schedulable {
    private final Integer BATCH_SIZE = 5;

    public void execute(SchedulableContext ctx) {
        ChatKPIDailyAggregationProcessBatch batch = new ChatKPIDailyAggregationProcessBatch();
        Database.executeBatch(batch, BATCH_SIZE);
    }
}