@isTest
public class KnowledgeControllerTest {

    @isTest
    static void testGetAllKnowledes() {
        KnowledgeController.getAllKnowledes();
    }
    @isTest
    static void testSearchKnowledes() {
        KnowledgeController.searchKnowledes('');
    }
    @isTest
    static void testSearchKnowledeForInquiry() {
        String inquiry = 'TEST';
        String category = 'life';
        KnowledgeController.searchKnowledeForInquiry(inquiry, category);
    }
}