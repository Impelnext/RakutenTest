/*
* @Class Name      : MasterPageButtonApexController 
* @Description     : マスタページに表示するボタンのコントラー
* @Created Date    : 2020.06.04
* @Created By      : SRM
* @Modified Date   : 2020.07.23
* @Modified        : SRM
*/

public with sharing class MasterPageButtonApexController {

    @AuraEnabled
    public static MasterWrapper fetchMasterRecords(Id masterId) {
        String objectName = masterId.getSObjectType().getDescribe().getName();
        String query = '';
        String kanaName='';
        if(ObjectName.equalsIgnoreCase('SeihoRecruiterMaster__c')){
            kanaName = 'KANA_NAME__c';
            query = 'SELECT Id,Name,'+kanaName +' FROM SeihoRecruiterMaster__c WHERE Id=:masterId LIMIT 1';
        }else{
            kanaName = 'KANA_AGENT_NAME__c';
            query = 'SELECT Id,Name,'+kanaName +' FROM SeihoAgentMaster__c WHERE Id=:masterId LIMIT 1';
        }

        List<sObject> masterList = Database.query(query);
        MasterWrapper wrapper = new MasterWrapper();
        if(!masterList.isEmpty()){
            wrapper.Name = String.valueOf(masterList[0].get('Name'));
            wrapper.objectName = objectName;
            wrapper.kanaName = kanaName == 'KANA_NAME__c' ? String.valueOf(masterList[0].get('KANA_NAME__c')) : String.valueOf(masterList[0].get('KANA_AGENT_NAME__c'));
        } 
        System.debug('wrapper'+wrapper);
        return wrapper;
    }
    
    public class MasterWrapper {
    @AuraEnabled
    public String Name{get;set;}
    @AuraEnabled
    public String objectName {get;set;}
    @AuraEnabled
    public String kanaName {get;set;}
    }
}