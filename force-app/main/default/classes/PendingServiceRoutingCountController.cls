public class PendingServiceRoutingCountController{

    public class OperatingQueueSearchInput {
        @InvocableVariable(required=true)
        public String sApexOutput;
    }

    @InvocableMethod(label='キュー待ち人数確認 - PendingServiceRoutingCountController')
    public static List<String> getQueueCount(List<OperatingQueueSearchInput> inputs) {

        String queueName = inputs[0].sApexOutput;
        List<Group> isQueue = [SELECT Name, DeveloperName, Id FROM Group WHERE Type = 'Queue' AND DeveloperName = :queueName];

        String queueId = isQueue[0].id;

        Integer isRouting = [SELECT COUNT() FROM PendingServiceRouting WHERE GroupId = :queueId];

        List<String> sApexOutput = new List<String>();
        sApexOutput.add(String.valueOf(isRouting));

        return sApexOutput;
    }
}