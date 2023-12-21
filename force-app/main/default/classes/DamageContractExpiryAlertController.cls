/****************************************************************************************/
/* Class Name       : DamageContractExpiryAlertController                               */
/* Description      : 損保契約情報画面で損保有効契約の満期日アラートクラス              */
/* @Created Date    : 2022.03.25                                                        */
/* @Created By      : SRM Offshore                                                      */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public with sharing class DamageContractExpiryAlertController {
    
    @AuraEnabled
    public static boolean isMaturitySoon(String contractId){ 
        boolean isMaturitybefore2months=false;
        DamageContract__c damageConRec =[SELECT Id, 
                                                ContractEndDate__c, 
                                                ContractStatusDisplay__c 
                                         FROM DamageContract__c 
                                         WHERE Id = :contractId];
        String contractEndDateStr= damageConRec.ContractEndDate__c;
        
        if(String.isNotBlank(contractEndDateStr) && 
           contractEndDateStr.length() == 8 && 
           String.isNotBlank(damageConRec.ContractStatusDisplay__c)){
            
            Date contractEndDate = NULL;
            
            try {
                string stringDate = contractEndDateStr.left(4) 
                                    + '-' 
                                    + contractEndDateStr.mid(4,2) 
                                    + '-' 
                                    + contractEndDateStr.right(2);
                contractEndDate = date.valueOf(stringDate);
            }
            catch(Exception ex) {
                return isMaturitybefore2months;
                // NOTREACHED
            }
            
            List<String> contractActiveStatuses=(System.label.ContractSts).Split(',');
            
            //満期日の2ヵ月前のかを確認
            Date thisDate = Date.today();
            if (thisDate <= contractEndDate && 
                contractEndDate.addMonths(-2).toStartOfMonth() <= thisDate && 
                contractActiveStatuses.contains(damageConRec.ContractStatusDisplay__c)) {
                
                isMaturitybefore2months= true;
            }
        }
        
        return isMaturitybefore2months;
    }
}