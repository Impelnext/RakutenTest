@isTest
public class ReceptionTriggerTest
{

    

    @isTest
    static void ReceptionTriggerTest()
    {
        ReceptionTriggerTestHandler recptTrigHandler = new ReceptionTriggerTestHandler ();
        recptTrigHandler.insertRecptRecord();
        recptTrigHandler.updateRecpRecord();
    }
    
    
}