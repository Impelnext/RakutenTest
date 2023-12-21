public class LifeApplicationSpecialTriggerHandler {
    //コンストラクタ
    public LifeApplicationSpecialTriggerHandler(){}
    
    //生保申込との紐付け
    public void setParentRecord(List<LifeApplicationSpecial__c> newList, Map<Id,LifeApplicationSpecial__c> oldMap){
        //取得対象となる生保申込番号のSetと処理対象のListを作成
        Set<String> parentRecordSet = new Set<String>();
        List<LifeApplicationSpecial__c> targetList = new List<LifeApplicationSpecial__c>();
        
        for(LifeApplicationSpecial__c line : newList){
            if(oldMap.size() == 0){
                if(line.Name <> Null){
                    parentRecordSet.add(line.Name);
                    targetList.add(line);
                }
            }else{
                //申込番号が変更になった場合のみSetとListに詰める
                if(   line.Name <> Null
                   && line.Name <> oldMap.get(line.Id).Name){
                    parentRecordSet.add(line.Name);
                    targetList.add(line);
                }
            }
        }
        
        //処理対象レコードが存在する場合のみ処理実行
        if(targetList.size() > 0){
            //親レコードを取得
            List<SeihoOpportunity__c> parentRecordList = [Select AppliNo__c, Id, AppliReceptionChannel__c From SeihoOpportunity__c Where AppliNo__c = :parentRecordSet];
            //親判定用Mapを作成
            Map<String, Id> parentRecMap = new Map<String, Id>();
            for(SeihoOpportunity__c rec : parentRecordList){
                if(   rec.AppliReceptionChannel__c != 'WEB' && UserInfo.getUserId() == System.Label.BATCH_USER_ID
                   || rec.AppliReceptionChannel__c == 'WEB' && UserInfo.getUserId() != System.Label.BATCH_USER_ID){
                    parentRecMap.put(rec.AppliNo__c, rec.Id);
                }
            }
            
            //処理対象レコードに対して申込IDとの参照関係を作成
            for(LifeApplicationSpecial__c target : targetList){
                target.Opportunity__c = parentRecMap.get(target.Name);
            }
        }
    }

    //生保申込に紐づいてない生保申込特約レコードを削除する
    public void deleteLifeApplicationSpecial(List<LifeApplicationSpecial__c> lifeAppliSpecialList){

        List<LifeApplicationSpecial__c> lifeAppliDeleteList = new List<LifeApplicationSpecial__c>();
        for(LifeApplicationSpecial__c life : [Select Id, Opportunity__c from LifeApplicationSpecial__c where Id IN: lifeAppliSpecialList]){
            if(life.Opportunity__c == null){
                lifeAppliDeleteList.add(life);
            }
        }
        delete lifeAppliDeleteList;
    }
}