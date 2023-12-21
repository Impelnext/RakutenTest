public class KnowledgeSearchByKeywordController {
    //インプット用変数
    public class InputFromBot {
        @InvocableVariable(required=true)
        public String keywords;
        @InvocableVariable(required=true)
        public Integer limitSize;
        @InvocableVariable(required=true)
        public String companyName;
        @InvocableVariable(required=true)
        public Integer leftSize;
    }
    
    //アウトプット用変数
    public class KnowledgeOutput {
        @InvocableVariable(required=true)
        public List<Knowledge__kav> knowledgeList;
    }
    
    /**
     * 会社を指定してキーワード検索でナレッジを取得する
     * @param List<InputFromBot> inputs（検索キーワード, 最大取得件数, 会社名, チャットボットに表示する質問の最大表示文字数）
     * @return List<Knowledge__kav> 指定したキーワードに関連するナレッジ
     */
    @InvocableMethod(label='キーワードからナレッジを取得 - KnowledgeSearchByKeywordController')
    public static List<KnowledgeOutput> getKnowledgeByKeywords(List<InputFromBot> inputs) {
        
        //ボットからのインプットを変数に代入
        InputFromBot inputFromBot = inputs[0];
        Integer limitSize = inputFromBot.limitSize;
        String companyName = inputFromBot.companyName;
        Integer leftSize = inputFromBot.leftSize;
        
        //キーワードをパース
        List<String> keywords = inputFromBot.keywords.split('[　\\s]');

        //ナレッジを取得
        List<Knowledge__kav> outputs = new List<Knowledge__kav>();
        outputs = KnowledgeHelper.searchKnowledgeByCompany(keywords, limitSize, companyName, leftSize);
        
        //URLを再セット
        if (companyName == FaqConstants.CATEGORY_GROUP_LABEL_LIFE) {
            outputs = addUrl(outputs, System.Label.LifeFaqSiteUrl);
        } else if (companyName == FaqConstants.CATEGORY_GROUP_LABEL_INSURANCE) {
            outputs = addUrl(outputs, System.Label.SonpoFaqSiteUrl);
        } else {
            outputs = addUrl(outputs, System.Label.SsiFaqSiteUrl);
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
}