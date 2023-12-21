
var cookie_name_linkCd             = "algolLinkCd";

$(function(){
    $().ready(function(){
        
        var params = getUrlParams();
        var linkCd = params['scid'];
        if(linkCd == null|| linkCd == ""){
            linkCd = params['sclid'];
        }
        $.cookie(cookie_name_linkCd, linkCd, { expires: 7,path: '/' });
    });
});
