/** FUNCTIONS **/
/**
 * 代理店名乗り判定
 * 　対象ページがWEB申込または資料請求かを判断し、
 * 　それぞれのページで代理店名乗りが必要かどうかを判定する。
 * @returns {boolean} true:名乗り必要 / false:名乗り不要
 */
function isNeedAgencyDescription() {
    var agencyCd = _getAgencyCd();

    if (_isCatalogOrderPage()) {
        // 資料請求ページの場合
        return _isNeedAgencyDescriptionForCatalog(agencyCd);
    }
    // WEB申込ページの場合(資料請求以外のページ)
    return _isNeedAgencyDescriptionForApply(agencyCd);
}

/**
 * 代理店名乗り判定(WEB申込用)
 * @param agencyCd 代理店コード
 * @returns {boolean} true:名乗り必要 / false:名乗り不要
 */
function _isNeedAgencyDescriptionForApply(agencyCd) {
    var AGENCY_CD_DIRECT         = "000001";       // 楽天生命

    if (agencyCd == null) {
        // 指定がない場合、新保険サービス会社の取扱いとするため名乗り必要
        return true;
    } else if (agencyCd == AGENCY_CD_DIRECT) {
        // 代理店コードが直販(楽天生命)の場合、新保険サービス会社の取扱いとするため名乗り必要
        return true; 
    }
    // 直販でない場合、名乗り不要
    return false;
}

/**
 * 代理店名乗り判定(資料請求用)
 * @param agencyCd 代理店コード
 * @returns {boolean} true:名乗り必要 / false:名乗り不要
 */
function _isNeedAgencyDescriptionForCatalog(agencyCd) {
    var specific_agency_list = new Array( "620110"  // アドバンスクリエイト
                                        , "531155"  // 価格.com
                                        , "771870"  // 楽天インシュアランスプランニング
                                        );

    if (agencyCd == null) {
        // 指定がない場合、新保険サービス会社の取扱いとするため名乗り要
        return true;
    } else if (specific_agency_list.indexOf(agencyCd) >= 0) {
        // 代理店コードが指定代理店の場合、名乗り不要
        return false; 
    }
    // 代理店コードが指定代理店以外の場合、新保険サービス会社の取扱いとするため名乗り必要
    return true;
}

/**
 * URLが資料請求のページかどうかを判定
 * @returns {boolean} true:資料請求ページ / false:資料請求でないページ
 */
function _isCatalogOrderPage() {
    var CATALOG_ORDER_URL_PATH = '/catalogOrder/';

    // リクエストパスの取得
    var urlPath = window.location.pathname;

    // URLが資料請求のページかどうかを判定
    if (urlPath != null && urlPath.indexOf(CATALOG_ORDER_URL_PATH) === 0) {
        return true;
    }
    return false;
}

/**
 * リクエストされた代理店コードの取得
 *   リクエストされた代理店コードをリクエストパラメータ、もしくは、Cookieの'algol'より取得します。
 * @returns agencyCd 代理店コード
 */
function _getAgencyCd() {
    var PARAM_NAME_AGENCY_CD     = "agencyCd";
    var PARAM_NAME_RECRUITER_NO  = "recruiterNo";
    var COOKIE_NAME_ALGOL        = "algol";

    // リクエストパラメータから代理店コードと募集人コードを取得
    var params = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        params.push(hash[0]);
        params[hash[0]] = hash[1];
    }
    var paramAgencyCd = params[PARAM_NAME_AGENCY_CD];
    var paramRecruiterNo = params[PARAM_NAME_RECRUITER_NO];

    // 代理店コードの取得
    var agencyCd = null;
    if (paramRecruiterNo != null && paramRecruiterNo.length == 9) {
        // リクエストパラムの募集人コードから代理店コードを取得
        agencyCd = paramRecruiterNo.substr(0, 6);
    } else if (paramAgencyCd != null && paramAgencyCd.length == 6) {
        // リクエストパラムの代理店コードを取得
        agencyCd = paramAgencyCd;
    } else if ($.cookie != null && $.cookie(COOKIE_NAME_ALGOL) != null) {
        // Cookie(algol)から代理店コードを取得
        var algol = $.cookie(COOKIE_NAME_ALGOL);
        if (algol.length == 9) {
            agencyCd = algol.substr(0, 6);
        } else if (algol.length == 6) {
            agencyCd = algol;
        }
    }
    // agency
    return agencyCd;
}