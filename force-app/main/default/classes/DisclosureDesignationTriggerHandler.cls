/*
 * @Class Name      : DisclosureDesignationTriggerHandler
 * @Description     : 開示指定者トリガーハンドラー
 * @Created Date    : 2021.06.24
 * @Created By      : Takasumi Ito
 * @Modified Date   : 2021.01.04
 * @Modified By     : Sam jeshwin raj
 */
public class DisclosureDesignationTriggerHandler {

    public DisclosureDesignationTriggerHandler() {}

    public void checkExistDiscDesPer(List<DisclosureDesignation__c> disclosureDesignationList) {

        Set<Id> accountIdSet = new Set<Id>();
        for (DisclosureDesignation__c disclosureDesignation : disclosureDesignationList) {
            accountIdSet.add(disclosureDesignation .Account__c);
        }

        Set<Id> existAccountIdSet = new Set<Id>();
        for (DisclosureDesignation__c disclosureDesignation :
            [SELECT Account__c FROM DisclosureDesignation__c WHERE Account__c IN: accountIdSet]) {
                existAccountIdSet.add(disclosureDesignation.Account__c);
        }

        for (DisclosureDesignation__c disclosureDesignation : disclosureDesignationList) {
            if (existAccountIdSet.contains(disclosureDesignation.Account__c)) {
                disclosureDesignation.addError('取引先に紐づく開示指定者情報が既に存在しています。');
            }
        }
    }

    public void editByStatus(List<DisclosureDesignation__c> disclosureDesignationList) {

        for (DisclosureDesignation__c disclosureDesignation : disclosureDesignationList) {

            if ('停止'.equals(disclosureDesignation.Status__c)||'レコード削除'.equals(disclosureDesignation.Status__c) ) {//'レコード削除'追加
            //【統合CRM】RIPDEV-170_損保家族登録開始
                disclosureDesignation.Counter__c = null;
                disclosureDesignation.section__c = null;
             //【統合CRM】RIPDEV-170_損保家族登録終了   
                disclosureDesignation.NameKana__c = null;
                disclosureDesignation.NameKanji__c = null;
                disclosureDesignation.Relationship__c = null;
                disclosureDesignation.Birthday__c = null;
                disclosureDesignation.PhoneNumber__c = null;
            }
            //【統合CRM】RIPDEV-170_損保家族登録開始
            if ('停止'.equals(disclosureDesignation.Status2__c)||'レコード削除'.equals(disclosureDesignation.Status2__c)) {//'レコード削除'追加
                disclosureDesignation.section2__c = null;
                disclosureDesignation.Counter2__c = null;
                disclosureDesignation.NameKana2__c = null;
                disclosureDesignation.NameKanji2__c = null;
                disclosureDesignation.Relationship2__c = null;
                disclosureDesignation.Birthday2__c = null;
                disclosureDesignation.PhoneNumber2__c = null;
            }
            //【統合CRM】RIPDEV-170_損保家族登録終了
        }
       
    }

    public void createDisclosureDesignationHistory(List<DisclosureDesignation__c> disclosureDesignationList) {

        List<DisclosureDesignationHistory__c> disclosureDesignationHistoryList = new List<DisclosureDesignationHistory__c>();
        for (DisclosureDesignation__c disclosureDesignation : disclosureDesignationList) {
            DisclosureDesignationHistory__c disclosureDesignationHistory = new DisclosureDesignationHistory__c();
            disclosureDesignationHistory .DisclosureDesignation__c = disclosureDesignation.Id;
            disclosureDesignationHistory .Counter__c = disclosureDesignation.Counter__c;
            disclosureDesignationHistory .Status__c = disclosureDesignation.Status__c;
            disclosureDesignationHistory .NameKana__c = disclosureDesignation.NameKana__c;
            disclosureDesignationHistory .NameKanji__c = disclosureDesignation.NameKanji__c;
            disclosureDesignationHistory .Relationship__c = disclosureDesignation.Relationship__c;
            if (disclosureDesignation.Birthday__c <> null) {
                disclosureDesignationHistory.Birthday__c =
                Datetime.newInstance(disclosureDesignation.Birthday__c, Time.newInstance(0, 0, 0, 0)).format('yyyy/MM/dd');
            } else {
                disclosureDesignationHistory.Birthday__c = null;
            }
            disclosureDesignationHistory.PhoneNumber__c = disclosureDesignation.PhoneNumber__c;
            //【統合CRM】RIPDEV-170_損保家族登録開始
            disclosureDesignationHistory.section__c= disclosureDesignation.section__c;
            disclosureDesignationHistory .Counter2__c = disclosureDesignation.Counter2__c;
            disclosureDesignationHistory .Status2__c = disclosureDesignation.Status2__c;
            disclosureDesignationHistory .NameKana2__c = disclosureDesignation.NameKana2__c;
            disclosureDesignationHistory .NameKanji2__c = disclosureDesignation.NameKanji2__c;
            disclosureDesignationHistory .Relationship2__c = disclosureDesignation.Relationship2__c;
            if (disclosureDesignation.Birthday2__c <> null) {
                disclosureDesignationHistory.Birthday2__c =
                Datetime.newInstance(disclosureDesignation.Birthday2__c, Time.newInstance(0, 0, 0, 0)).format('yyyy/MM/dd');
            } else {
                disclosureDesignationHistory.Birthday2__c = null;
            }
            disclosureDesignationHistory.section2__c= disclosureDesignation.section2__c;
            disclosureDesignationHistory.PhoneNumber2__c = disclosureDesignation.PhoneNumber2__c;
            //【統合CRM】RIPDEV-170_損保家族登録終了
            disclosureDesignationHistoryList.add(disclosureDesignationHistory);
            }
        
        insert disclosureDesignationHistoryList;
        }
    }