/****************************************************************************************/
/* Class Name       : CollectiveAgencyAccountAlertController                            */
/* Description      : 取引先画面での集団扱い代理店アラートクラス                        */
/* @Created Date    : 2021.07.20                                                        */
/* @Created By      : Sam jeshwin raj / Geelani                                         */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public class CollectiveAgencyAccountAlertController {
    /**
     * 集団扱い代理店有り顧客取得
     * @param  String
     * @return CollectiveAgencyHelper.CollectiveAgencyList
     */
    @AuraEnabled
    public static CollectiveAgencyHelper.CollectiveAgencyList getWarningAgency(String accountId){
        return CollectiveAgencyHelper.getCollectiveAgency(accountId); 
    }
}