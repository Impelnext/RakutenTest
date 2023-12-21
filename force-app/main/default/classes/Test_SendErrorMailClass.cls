@isTest(SeeAllData=true)
private class Test_SendErrorMailClass 
{
    static testMethod void testSendErrorMailCallList(){
        Messaging.SendEmailResult sendEmailResult = SendErrorMailClass.sendErrorMailCallList('Test Subject', 'Test Body');
        System.AssertEquals(true, sendEmailResult.isSuccess());
    }
    static testMethod void testSendErrorMailAccountList_error(){
        Messaging.SendEmailResult sendEmailResult = SendErrorMailClass.sendErrorMailAccountList('Test Subject', 'Test Body', 'error');
        System.AssertEquals(true, sendEmailResult.isSuccess());
    }

  static testMethod void testSendErrorMailAccountList_warning(){
        Messaging.SendEmailResult sendEmailResult = SendErrorMailClass.sendErrorMailAccountList('Test Subject', 'Test Body', 'warning');
        System.AssertEquals(true, sendEmailResult.isSuccess());
    }
    
    static testMethod void testSendErrorMailAccountList_success(){
        Messaging.SendEmailResult sendEmailResult = SendErrorMailClass.sendErrorMailAccountList('Test Subject', 'Test Body', 'success');
        System.AssertEquals(true, sendEmailResult.isSuccess());
    }
}