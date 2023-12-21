public class KnowledgeSearchByCategoryController {  
    static final Integer KNOWLEDGE_MAX_COUNT = 3;
    //インプット用変数
    public class CompanyNameCategoryInput {
        @InvocableVariable(required=true)
        public String companyName;
        @InvocableVariable(required=true)
        public String category1stLevel;
        @InvocableVariable(required=true)
        public String category2ndLevel;
    }
    
    //アウトプット用変数
    public class KnowledgeOutput {
        @InvocableVariable(required=true)
        public List<Knowledge__kav> knowledgeList;
    }
    
    /**
     * 指定した会社と第二階層カテゴリ名配下のナレッジを取得する
     * @param List<CompanyNameCategoryInput> inputs（会社名, 第一階層のカテゴリ名, 第二階層のカテゴリ名）
     * @return List<Knowledge__kav> 指定した第二階層カテゴリのナレッジ
     */
    @InvocableMethod(label='ナレッジを取得 - KnowledgeSearchByCategoryController')
    public static List<KnowledgeOutput> getKnowledgeByCompanyNameCategory(List<CompanyNameCategoryInput> inputs) {
        
        //ボットからのインプットを変数に代入
        CompanyNameCategoryInput companyNameCategory = inputs[0];
        String companyName = companyNameCategory.companyName;
        String category1stLevel = companyNameCategory.category1stLevel;
        String category2ndLevel = companyNameCategory.category2ndLevel;
        
        //ナレッジを取得
        List<Knowledge__kav> outputs = new List<Knowledge__kav>();     
        outputs = KnowledgeHelper.getKnowledgeBy2ndLvCatLabel(companyName, category1stLevel, category2ndLevel);
        
        //ナレッジが3件を超える場合、3件に絞る
        if (outputs.size() > KNOWLEDGE_MAX_COUNT) { 
            List<Knowledge__kav> outputsLimited = new List<Knowledge__kav>();
            for (Integer i = 0; i < KNOWLEDGE_MAX_COUNT; i++) {
                outputsLimited.add(outputs[i]);
            }
            outputs = setUrl(companyName, outputsLimited);
        } else {
            outputs = setUrl(companyName, outputs);
        }

        KnowledgeOutput o = new KnowledgeOutput();
        o.knowledgeList = outputs;
        List<KnowledgeOutput> rets = new List<KnowledgeOutput>();
        rets.add(o);
        
        return rets;
    } 
    
    /**
     * 楽天生命・損保・ペット用にURLを生成
     * @param List<Knowledge__kav> inputs ナレッジ（URLが未完成）
     * @return List<Knowledge__kav> 完成されたURLを含むナレッジ
     */
    private static List<Knowledge__kav> addUrl(List<Knowledge__kav> inputs, String siteUrl) {
        for (Knowledge__kav kav : inputs) {
            kav.UrlName = siteUrl + kav.UrlName;
            kav.Question__c = kav.Question__c.replace('<br>', '');
        }
        return inputs;
    }
    
    /**
     * 楽天生命・損保・ペット用にURLをセット
     * @param String companyName 会社名
     * @param List<Knowledge__kav> inputs ナレッジ
     * @return List<Knowledge__kav> 完成されたURLを含むナレッジ
     */
    private static List<Knowledge__kav> setUrl(String companyName, List<Knowledge__kav> inputs) {
        if (companyName == FaqConstants.CATEGORY_GROUP_LABEL_LIFE) {
            inputs = addUrl(inputs, System.Label.LifeFaqSiteUrl);
        } else if (companyName == FaqConstants.CATEGORY_GROUP_LABEL_INSURANCE) {
            inputs = addUrl(inputs, System.Label.SonpoFaqSiteUrl);
        } else {
            inputs = addUrl(inputs, System.Label.SsiFaqSiteUrl);
        }
        return inputs;
    }
}