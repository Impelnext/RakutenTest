@IsTest
public class OperatingHoursSearchControllerTest {
    @IsTest() static void testIsOperatingHours() {
        String companyName = '楽天生命';
        OperatingHours__c opehour =  new OperatingHours__c(Name = companyName, StartTime__c = Time.newInstance(9, 0, 0, 0), EndTime__c=Time.newInstance(18, 0, 0, 0));
        insert opehour;
        
        List<OperatingHoursSearchController.OperatingHoursSearchInput > inputs = new List<OperatingHoursSearchController.OperatingHoursSearchInput >();
        OperatingHoursSearchController.OperatingHoursSearchInput input = new OperatingHoursSearchController.OperatingHoursSearchInput();
        input.companyName = companyName;
        inputs.add(input);
        OperatingHoursSearchController.isOperatingHours(inputs);
    }
}