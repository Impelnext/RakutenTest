public class KnowledgeCategory1SearchController {
    public class CompanyNameInput {
        @InvocableVariable(required=true)
        public String companyName;
    }
    
    public class Category1Output{
        @InvocableVariable(required=true)
        public List<String> categoryList;
    }
    
    /**
     * 指定した会社の第一階層のカテゴリを取得する
     * @param List<CompanyNameInput> inputs 会社名
     * @return List<Category1Output> 第一階層のカテゴリ
     */
    @InvocableMethod(label='データカテゴリ第一階層を取得 - KnowledgeCategory1SearchController')
    public static List<Category1Output> get1stLevelByCompanyName(List<CompanyNameInput> inputs) {
        String companyName = inputs[0].companyName;
        List<String> outputs = new List<String>();
        outputs = DataCategoryHelper.getDataCategory1stLevel(companyName);
        
        Category1Output o = new Category1Output();
        o.categoryList = outputs;
        List<Category1Output> rets = new List<Category1Output>();
        rets.add(o);
        
        return rets;
    } 
}