/****************************************************************************************/
/* Class Name       : CollectiveAgencyContractAlertController                           */
/* Description      : 損保契約情報画面での集団扱い代理店アラートクラス                  */
/* @Created Date    : 2021.07.20                                                        */
/* @Created By      : Sam jeshwin raj / Geelani                                         */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public class CollectiveAgencyContractAlertController{
    /*
     * 集団扱い代理店判断
     */
    @AuraEnabled
    public static Boolean isCollectiveAgencyContract( String contractId ) {
        return CollectiveAgencyHelper.isCollectiveAgencyContract(contractId);
    }
}