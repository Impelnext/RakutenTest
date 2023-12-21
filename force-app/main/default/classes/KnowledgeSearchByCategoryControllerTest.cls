@IsTest
public class KnowledgeSearchByCategoryControllerTest {
    @IsTest() static void testGetKnowledgeByCompanyNameCategoryCATEGORY_GROUP_LIFE() {
        List<KnowledgeSearchByCategoryController.CompanyNameCategoryInput > inputs = new List<KnowledgeSearchByCategoryController.CompanyNameCategoryInput >();
        KnowledgeSearchByCategoryController.CompanyNameCategoryInput input = new KnowledgeSearchByCategoryController.CompanyNameCategoryInput();
        input.companyName = FaqConstants.CATEGORY_GROUP_LABEL_LIFE;
        input.category1stLevel = '各種お手続き';
        input.category2ndLevel = '改姓・改名';
        inputs.add(input);
        List<KnowledgeSearchByCategoryController.KnowledgeOutput> ls;
        ls = KnowledgeSearchByCategoryController.getKnowledgeByCompanyNameCategory(inputs);
    }

    @IsTest() static void testGetKnowledgeByCompanyNameCategoryCATEGORY_GROUP_INSURANCE() {
        List<KnowledgeSearchByCategoryController.CompanyNameCategoryInput > inputs = new List<KnowledgeSearchByCategoryController.CompanyNameCategoryInput >();
        KnowledgeSearchByCategoryController.CompanyNameCategoryInput input = new KnowledgeSearchByCategoryController.CompanyNameCategoryInput();
        input.companyName = FaqConstants.CATEGORY_GROUP_LABEL_INSURANCE;
        input.category1stLevel = '商品・補償内容';
        input.category2ndLevel = '自動車保険';
        inputs.add(input);
        List<KnowledgeSearchByCategoryController.KnowledgeOutput> ls;
        ls = KnowledgeSearchByCategoryController.getKnowledgeByCompanyNameCategory(inputs);
    }

    @IsTest() static void testGetKnowledgeByCompanyNameCategoryCATEGORY_GROUP_PET() {
        List<KnowledgeSearchByCategoryController.CompanyNameCategoryInput > inputs = new List<KnowledgeSearchByCategoryController.CompanyNameCategoryInput >();
        KnowledgeSearchByCategoryController.CompanyNameCategoryInput input = new KnowledgeSearchByCategoryController.CompanyNameCategoryInput();
        input.companyName = FaqConstants.CATEGORY_GROUP_LABEL_PET;
        input.category1stLevel = '各種手続き';
        input.category2ndLevel = '改姓/改名';
        inputs.add(input);
        List<KnowledgeSearchByCategoryController.KnowledgeOutput> ls;
        ls = KnowledgeSearchByCategoryController.getKnowledgeByCompanyNameCategory(inputs);
    }
}