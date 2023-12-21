@isTest
public class ExC_FileDownloadControllerTest {
    
    @isTest
    static void testCheckPassword() {
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ExC_MockHttpResponse());
            ExC_FileDownloadController.checkPassword('', '');
            
        Test.stopTest();
    }
}