
var cookie_name             = "algol";

$(function(){
    $().ready(function(){

        var params = getUrlParams();
        var agencycd = params['agencyCd'];
        var recruiterno = params['recruiterNo'];

        if (recruiterno != null && recruiterno.length == 9) {
            $.cookie(cookie_name, recruiterno, { expires: 7,path: '/' });
        } else if (agencycd != null && agencycd.length == 6) {
            $.cookie(cookie_name, agencycd, { expires: 7,path: '/' });
        }
    });
});

function getUrlParams()
{
    var params = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        params.push(hash[0]);
        params[hash[0]] = hash[1];
    }
    return params;
}