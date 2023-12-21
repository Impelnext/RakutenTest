public with sharing class KnowledgeController {
    public KnowledgeController() {

    }
    @AuraEnabled(Cacheable=true)
    public static Knowledge__kav[] getAllKnowledes() {
        return [
            SELECT 
                Id, 
                Title, 
                Summary, 
                Question__c, 
                Answer__c 
            FROM Knowledge__kav 
            LIMIT 10
        ];
    }


    @AuraEnabled(Cacheable=true)
    public static Knowledge__kav[] searchKnowledes(String searchTerm) {
        // Return all bears when no search term
        searchTerm = searchTerm.trim();
        if (searchTerm == '') {
            return getAllKnowledes();
        }
        // Prepare query paramters
        searchTerm = '%' + searchTerm + '%';
        // Execute search query
        return [
            SELECT 
                Id, 
                Title, 
                Summary, 
                Question__c, 
                Answer__c 
            FROM Knowledge__kav 
            WHERE Title LIKE :searchTerm 
            LIMIT 10
        ];
    }
    
    @AuraEnabled
    public static Knowledge__kav[] searchKnowledeForInquiry(String inquiry, String categoryIdentify) {
        
        string categoryApinm = null;
        string faqSiteUrl = '';
        if(categoryIdentify=='life') {categoryApinm = 'CategoryGroupLife'; faqSiteUrl=System.Label.lifeFaqSiteUrl;}
        if(categoryIdentify=='gen') {categoryApinm = 'CategoryGroupInsurance'; faqSiteUrl=System.Label.SonpoFaqSiteUrl;}
        if(categoryIdentify=='pet') {categoryApinm = 'CategoryGroupPet'; faqSiteUrl=System.Label.SsiFaqSiteUrl;}
        if(categoryApinm==null) return null;

        String strKeys = inquiry.replaceAll('　', ' ');
        strKeys = strKeys.replaceAll('、', ' ');
        strKeys = strKeys.replaceAll('。', ' ');
        strKeys = strKeys.replaceAll('  ', ' ');
                
        List<String> keys = new List<String>();
        Integer count=0;
        for(String s: strKeys.split(' ')){
            keys.add(s);
            count++;
            if(count==3) break;
        }
        List<Knowledge__kav> rst = KnowledgeHelper.searchKnowledgeByCategory(keys, 3, categoryApinm);
        for(Knowledge__kav k :rst){
			k.UrlName = faqSiteUrl +  k.UrlName;
        }
        return rst;

    }
}