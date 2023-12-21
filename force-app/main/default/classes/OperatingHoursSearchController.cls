public class OperatingHoursSearchController {

    public class OperatingHoursSearchInput {
        @InvocableVariable(required=true)
        public String companyName;
    }

    @InvocableMethod(label='営業時間判定 - OperatingHoursSearchController')
    public static List<Boolean> isOperatingHours(List<OperatingHoursSearchInput> inputs) {

        String companyName = inputs[0].companyName;

        List<OperatingHours__c> isOperatingHours;

        isOperatingHours = [SELECT IsOperatingHours__c FROM OperatingHours__c WHERE Name = :companyName];

        List<Boolean> outputs = new List<Boolean>();
        outputs.add(Boolean.valueOf(isOperatingHours[0].IsOperatingHours__c));

        return outputs;
    }
}