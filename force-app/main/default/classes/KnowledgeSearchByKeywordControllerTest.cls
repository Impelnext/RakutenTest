@IsTest
public class KnowledgeSearchByKeywordControllerTest {
    
    @IsTest() static void testGetKnowledgeByKeywords() {
        List<KnowledgeSearchByKeywordController.InputFromBot > inputs = new List<KnowledgeSearchByKeywordController.InputFromBot >();
        KnowledgeSearchByKeywordController.InputFromBot input = new KnowledgeSearchByKeywordController.InputFromBot();
        input.keywords = 'TEST';
        input.limitSize = 1;
        input.companyName = '楽天生命';
        input.leftSize = 1;
        inputs.add(input);
        KnowledgeSearchByKeywordController.getKnowledgeByKeywords(inputs);
    }
}