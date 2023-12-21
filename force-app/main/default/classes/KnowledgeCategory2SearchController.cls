public class KnowledgeCategory2SearchController { 
    public class CategoryInput {
        @InvocableVariable(required=true)
        public String companyName;
        @InvocableVariable(required=true)
        public String category;
    }
    
    public class Category2Output{
        @InvocableVariable(required=true)
        public List<String> categoryList;
    }
    
    /**
     * 指定した会社と第一階層カテゴリ名配下の第二階層カテゴリを取得する
     * @param List<CategoryInput> inputs （会社名、第一階層カテゴリ）
     * @return List<Category2Output> 第二階層のカテゴリ
     */
    @InvocableMethod(label='データカテゴリ第二階層を取得 - KnowledgeCategory2SearchController')
    public static List<Category2Output> get2ndLevelByDataCategory1stLevel(List<CategoryInput> inputs) {
        CategoryInput companyNameCategory = inputs[0];
        String companyName = companyNameCategory.companyName;
        String category = companyNameCategory.category;
        List<String> outputs = new List<String>();
        outputs = DataCategoryHelper.getDataCategory2ndLevel(companyName, category);
        
        Category2Output o = new Category2Output();
        o.categoryList = outputs;
        List<Category2Output> rets = new List<Category2Output>();
        rets.add(o);
        
        return rets;
    } 
}