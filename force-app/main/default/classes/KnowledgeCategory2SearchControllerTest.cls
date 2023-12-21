@IsTest(SeeAllData=true)
public class KnowledgeCategory2SearchControllerTest {
    @IsTest() static void testGet1stLevelByCompanyName() {
        List<KnowledgeCategory2SearchController.CategoryInput > inputs = new List<KnowledgeCategory2SearchController.CategoryInput >();
        KnowledgeCategory2SearchController.CategoryInput input = new KnowledgeCategory2SearchController.CategoryInput();
        input.companyName = 'CategoryGroupLife';
        input.category = 'CategoryLife0101';
        inputs.add(input);
        List<KnowledgeCategory2SearchController.Category2Output> ls;
        ls = KnowledgeCategory2SearchController.get2ndLevelByDataCategory1stLevel(inputs);
        System.assertNotEquals(ls.size(), 0);
    }
}