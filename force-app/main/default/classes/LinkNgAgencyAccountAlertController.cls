/****************************************************************************************/
/* Class Name       : LinkNgAgencyAccountAlertController                                */
/* Description      : 保全禁止連携代理店アラートクラス                                  */
/* @Created Date    : 2021.03.09                                                        */
/* @Created By      : Valsala Kumar J                                                   */
/* @Modified Date   :                                                                   */
/* @Modified By     :                                                                   */
/****************************************************************************************/
public class LinkNgAgencyAccountAlertController {
    /**
     * 保全禁止連携代理店有り顧客取得
     * @param  String
     * @return LinkNgAgencyHelper.LinkNgAgencyList
     */
    @AuraEnabled
    public static LinkNgAgencyHelper.LinkNgAgencyList getWarningAgency(String accountId){
        return LinkNgAgencyHelper.getNgAgency(accountId); 
    }
}