public without sharing class CRMContentListController {
    @AuraEnabled
    public static List<ContentDistribution> getContentList(Id recordId){
        List<ContentDistribution> res ;
        system.debug('recordId:' + recordId);
        
        if(recordId !=null){
            res = [select Id, CreatedDate, Name ,DistributionPublicUrl, Password, ExpiryDate, ViewCount
                    from  ContentDistribution 
					where RelatedRecordId = :recordId
                    order by createddate desc
                    limit 50
            ];      
        }else{
            res = [select Id, CreatedDate, Name ,DistributionPublicUrl, Password, ExpiryDate, ViewCount
                     from  ContentDistribution 
                     order by createddate desc
                     limit 50
            ];
        }
        
        return res;
        
    }

    @AuraEnabled
    public static ContentDistribution createContentDistribution(String title, String ContentId, String RelatedRecordId, DateTime DateTimeLimit){
        ContentDistribution cD = new ContentDistribution();
        cD.Name = title;
        cD.ContentVersionId = ContentId;
        cD.PreferencesAllowOriginalDownload = true;
        cD.PreferencesAllowPDFDownload = false;
        cD.PreferencesPasswordRequired = true;
        cD.PreferencesNotifyOnVisit = true;
        cD.PreferencesExpires = true;
        cD.ExpiryDate = DateTimeLimit;
        
        cD.RelatedRecordId = RelatedRecordId;
        insert cD;
        // URL、パスワードがNULLの状態のため、再取得を行う
        cD = [SELECT Id ,Name, DistributionPublicUrl, Password FROM ContentDistribution WHERE Id = :cD.Id];
        return cD;
    }
}