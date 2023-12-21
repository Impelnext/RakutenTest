@IsTest
public class PendingServiceRoutingCountControllerTest {
    @IsTest() static void testIsOperatingHours() {
        String queueName = 'queue_Seimei_Initial';
        List<PendingServiceRoutingCountController.OperatingQueueSearchInput > inputs = new List<PendingServiceRoutingCountController.OperatingQueueSearchInput >();
        PendingServiceRoutingCountController.OperatingQueueSearchInput input = new PendingServiceRoutingCountController.OperatingQueueSearchInput();
        input.sApexOutput = queueName;
        inputs.add(input);
        PendingServiceRoutingCountController.getQueueCount(inputs);
    }
}