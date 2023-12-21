@isTest
public class CRMContentListControllerTest {
    @isTest
    static void testGetContentList() {
		CRMContentListController.getContentList(null);
    }
    
    @isTest
    static void testCreateContentDistribution() {
        
        Contentversion cv =  new Contentversion(Title = 'ABC', PathOnClient = 'test', VersionData = EncodingUtil.base64Decode('Unit Test Attachment Body'));
        insert cv;
        
        Case c = new Case(Status = 'オープン');
        insert c;
        
        String title = 'TEST';
        String ContentId = cv.id;
        String RelatedRecordId = c.Id;
        DateTime DateTimeLimit = DateTime.now() + 3;
        
		CRMContentListController.createContentDistribution(title, ContentId, RelatedRecordId, DateTimeLimit);
    }
}