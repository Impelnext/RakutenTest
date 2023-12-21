/****************************************************************************************/
/* Class Name       : LinkNGAgencyContractAlertController                               */
/* Description      : 損保契約情報画面での保全禁止連携代理店アラートクラス              */
/* @Created Date    : 2021.03.11                                                        */
/* @Created By      : Valsala Kumar J                                                   */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public class LinkNGAgencyContractAlertController {
    /*
     * 連携NG代理店判断
     */
    @AuraEnabled
    public static Boolean isNGAgencyContract( String contractId ) {
        return LinkNgAgencyHelper.isNGAgencyContract(contractId);
    }
}