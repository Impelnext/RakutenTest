@IsTest(SeeAllData=true) 
public with sharing class KnowledgeCategory1SearchControllerTest {
    @IsTest
    public static void testGet1stLevelByCompanyName(){
        List<KnowledgeCategory1SearchController.CompanyNameInput> inputs = new List<KnowledgeCategory1SearchController.CompanyNameInput>();
        KnowledgeCategory1SearchController.CompanyNameInput company = new KnowledgeCategory1SearchController.CompanyNameInput();
        company.companyName = 'CategoryGroupLife';
        inputs.add(company);
        List<KnowledgeCategory1SearchController.Category1Output> ls;
        ls = KnowledgeCategory1SearchController.get1stLevelByCompanyName(inputs);
        System.assertNotEquals(ls.size(), 0);
    }
}