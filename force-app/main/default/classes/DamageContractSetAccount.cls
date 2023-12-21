/*
 * @Class Name      : DamageContractSetAccount 
 * @Description     : 損保契約情報トリガービジネスクラス：取引先情報の更新処理を行う
 * @Created Date    : 2023.08.17
 * @Created By      : Ban
 * @Modified Date   : 2023.08.17
 * @Modified By     : Ban
*/
public without sharing class DamageContractSetAccount {
    /**
     * 損保契約情報更新後処理
     * @param newList<DamageContract__c>
     * @param OldMap<Id, DamageContract__c>
     * @return
    */
    public void setAccountAfterUpdate(List<DamageContract__c> damageContractList, Map<Id, DamageContract__c> oldMap){
        
        //損保契約情報に関連する取引先IDセット  AccId => DamageContract__c
        Map<Id, String> accountIdPhonefaxMap = new Map<Id, String>();

        //更新対象取引先リスト
        List<Account> accountUpdateList = new List<Account>();

        for (DamageContract__c sonpo : damageContractList){
            if (String.IsNotBlank(sonpo.AccountId__c) 
            && String.isNotBlank(sonpo.ContractorPhoneFax__c)
            && oldMap.get(sonpo.Id).ContractorPhoneFax__c != sonpo.ContractorPhoneFax__c
            ) {
                accountIdPhonefaxMap.put(sonpo.AccountId__c, sonpo.ContractorPhoneFax__c);
            }
        }

        // 関連のAccount情報
        List<Account> relationAccountList = [SELECT Id, ContractorPhoneFax__pc FROM Account WHERE Id IN:accountIdPhonefaxMap.keySet() ];

        if(relationAccountList.size() > 0){
            for (Account tempAccount : relationAccountList) {
                // Accountの損保携帯（FAX含む）が損保契約情報の損保携帯（FAX含む）と異なる場合
                if(tempAccount.ContractorPhoneFax__pc != accountIdPhonefaxMap.get(tempAccount.Id)){
                    tempAccount.ContractorPhoneFax__pc = accountIdPhonefaxMap.get(tempAccount.Id);
                    accountUpdateList.add(tempAccount);
                }
            }
    
            if(accountUpdateList.size() > 0){
                update accountUpdateList;
            }
        }
    }
}