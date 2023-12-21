/**
 * common.js
 *
 *  version --- 4.0
 *  updated --- 2020/10/15
 */

/* !the value of <meta name="viewport"> is replace for tablet device -------------- */
 $(window).ready(function(){
     var ua = navigator.userAgent;
     if ((ua.indexOf('iPhone') > 0) || ua.indexOf('iPod') > 0 || (ua.indexOf('Android') > 0 && ua.indexOf('Mobile') > 0)) {
         $('head>meta[name="viewport"]').replaceWith('<meta name="viewport" content="width=device-width,initial-scale=1.0">');
     } else {//SPでなければ
         $('head>meta[name="viewport"]').replaceWith('<meta name="viewport" content="width=1280,user-scalable=no">');
     }

 });

/* !stack ------------------------------------------------------------------- */
jQuery(document).ready(function($) {
    logIO();
    gnaviCurrent();
    searchFormInput();
    lstToggle();
    clipToggle();
    fixedHeader();
});
$(window).on('load', function() {
    modal();

    anchorPage();
    headerMenu();
    gnaviSearchWindow();
});

/* !isUA -------------------------------------------------------------------- */
var isUA = (function(){
    var ua = navigator.userAgent.toLowerCase();
    indexOfKey = function(key){ return (ua.indexOf(key) != -1)? true: false;}
    var o = {};
    o.ie      = function(){ return indexOfKey("msie"); }
    o.fx      = function(){ return indexOfKey("firefox"); }
    o.chrome  = function(){ return indexOfKey("chrome"); }
    o.opera   = function(){ return indexOfKey("opera"); }
    o.android = function(){ return indexOfKey("android"); }
    o.ipad    = function(){ return indexOfKey("ipad"); }
    o.ipod    = function(){ return indexOfKey("ipod"); }
    o.iphone  = function(){ return indexOfKey("iphone"); }
    return o;
})();

/* !logIn/logOut ---------------------------------------------------------------- */
var logIO = function(){
    $().ready(function(){
        var rlLogin = false;
        var name = "rllogin=";
        var ca = document.cookie.split('; ');
        for(var i=0; i<ca.length; i++) {
            var c = ca[i];
            if (c.indexOf(name) != -1) {
                rlLogin = c.substring(name.length, c.length);
                break;
            }
        }
        if(rlLogin) {
            $("#logIO").removeClass('ioDisabled');
        } else {
            $("#logIO").addClass('ioDisabled');
        }
    });
};

/* !gnaviCurrent ---------------------------------------------------------------- */
var gnaviCurrent = function() {
    var dirName = location.pathname.split('/')[1],
        href = dirName && dirName !== 'index.html' ? '/' + dirName + '/' : '/';
    if (dirName === 'life' || dirName === 'general' || dirName === 'pet' || dirName === 'media') {
        $('.jsGnavCurrent').find('a[href^="'+ href +'"]').parent('li').addClass('current');
    } else {
        $('.jsGnavCurrent').find('a[href="'+ href +'"]').parent('li').addClass('current');
    }
};

/* !fixedHeader ---------------------------------------------------------------- */
var fixedHeader = function() {
    // var unFixed = isUA.android() || isUA.ipad() || isUA.iphone() || isUA.ipod() || $('body').hasClass('unFixedHeader');
    var unFixed = isUA.android() || isUA.ipad() || isUA.iphone() || isUA.ipod() || $('body').hasClass('unFixedHeader');
    if(!unFixed) {
        var $window = $(window),
            $el = $('.jsAddFixedBar'),
            $parts = $el.find($('.jsFixedParts')),
            startHeight = 400,
            speed = 200,
            $fixed, isFixed;
        $el.append('<div class="rc-h-fixed-bar" aria-hidden="true"><div class="rc-h-inner"></div></div>');
        $fixed = $el.find($('.rc-h-fixed-bar'));
        $parts.clone(true).appendTo($fixed.children($('.rc-h-inner')));
        $fixed.find($('.rc-h-action-btn')).wrap('<div class="rc-h-action-nav"></div>');
        $fixed.hide().css('top', - $fixed.outerHeight() - 5);
        $window.on('scroll', function() {
            if($window.scrollTop() >= startHeight) {
                if(!isFixed) {
                    $fixed.show(0, function() {
                        $fixed.animate({'top' : 0}, speed);
                    });
                    isFixed = true;
                    $('body').addClass('head_sp_fixed');
                }
            } else {
                if(isFixed) {
                    $fixed.animate({'top' : - $fixed.outerHeight() - 5}, speed, function() {
                        $fixed.hide();
                    });
                    isFixed = false;
                    $('body').removeClass('head_sp_fixed');

                }
            }
        });
    }else{
        var $window = $(window),
            startHeight = 40,
            speed = 200,
            $fixed, isFixed;
            $fixed = $('#grpheader nav');
            $fixed.clone(true).appendTo($('#grpheader')).addClass('clone');
            $window.on('scroll', function() {
                if($window.scrollTop() >= startHeight) {
                    if(!isFixed) {
                        $('body').addClass('head_sp_fixed');
                        $('.jsFixedParts').css('top', '0');
                        isFixed = true;
                    }
                } else {
                    if(isFixed) {
                        isFixed = false;
                        $('body').removeClass('head_sp_fixed');
                        $('.jsFixedParts').css('top','');
                    }
                }
            });
    }

        $window.trigger('scroll');

};

/* !gnaviForMobile ※モバイル端末でグローバルナビのhoverを無効 ---------------------------------------------------------------- */
var gnaviForMobile = (function() {
    $(function(){
        var device = isUA.android() || isUA.ipad() || isUA.iphone() || isUA.ipod();
        if (device) {
            $('#grpheader .jsGnavCurrent li:not(.dropLink)').attr('aria-label' , 'forMobile');
        }
    });
})();

/* !alertCreate ※第一引数にモジュールの種類。第二引数に表示したいメッセージ(html可)をstringで指定 ------------------------------------------------------------- */

function alertCreate(modifier , message){
    var el = '<div class="alert" aria-hidden="false" role="alert"><i aria-hidden="true" class="rex-icon"></i><span class="alert-txt">message</span><button type="button" class="alert-btnClose" data-trigger="alertClose" aria-label="閉じる"><i aria-hidden="true" class="rex-icon x"></i></button></div>';
    switch (modifier) {

        case 'success':
        $('body')
        .append(el)
        .find('.alert').addClass('alert_success')
        .find('.rex-icon').addClass('check')
        $('[role="alert"]').find('.alert-txt').html(message);
        alertClose()
        break;

        case 'info':
        $('body')
        .append(el)
        .find('.alert').addClass('alert_info')
        .find('.rex-icon').addClass('sign-info-l')
        $('[role="alert"]').find('.alert-txt').html(message);
        alertClose()
        break;

        case 'warning':
        $('body')
        .append(el)
        .find('.alert').addClass('alert_warning')
        .find('.rex-icon').addClass('sign-info-l')
        $('[role="alert"]').find('.alert-txt').html(message);
        alertClose()
        break;

        case 'danger':
        $('body')
        .append(el)
        .find('.alert').addClass('alert_danger')
        .find('.rex-icon').addClass('sign-warning-l')
        $('[role="alert"]').find('.alert-txt').html(message);
        alertClose()
        break;

        defalut : break;
    }
}

/* !alertClose -------------------------------------------------------------- */
function alertClose(){
    $(document).on('click' , '[data-trigger="alertClose"]' ,function(){
        var $errorModule = $(this).parent('[aria-hidden]'),
            errorModuleHeight = $errorModule.outerHeight();
            $errorModule.css({
                marginTop: '-' + errorModuleHeight + 'px'
            });
            setTimeout(function(){
                $errorModule.remove();
            },200);
    });
}

/* !anchorPage ---------------------------------------------------------------- */
var anchorPage = function(){
    $('[data-trigger="pageTop"] , [data-trigger="pageTarget"]').on('click', function(){
        var speed = 600,
            headerHeight = 65;
            href= $(this).attr("href"),
            target = $(href == "#" || href == "" ? 'html' : href);
            position = target.offset().top - headerHeight;
        $("html, body").animate({scrollTop:position}, speed, "swing");
        return false;
    });
}

/* !searchFormInput ---------------------------------------------------------------- */
var searchFormInput = function(){
    //input
    $(document).on('keydown keyup keypress change', '[data-trigger="searchFormInput"]', function(){
        var searchFormValueLength = $(this).val().length;
        if (searchFormValueLength >= 1) {
            $(this).next('[aria-selected]').attr({
                'aria-selected' : 'true'
            });
        } else if (searchFormValueLength === 0) {
            $(this).next('[aria-selected]').attr({
                'aria-selected' : 'false'
            });
        }
    });
    //reset
    $(document).on('click', '[data-trigger="searchFormReset"]', function(){
        $(this).attr({
            'aria-selected' : 'false'
        });
    });
}

/* !modal ---------------------------------------------------------------- */
var modal = function() {
    //open
    $('[data-trigger="modalOpen"]').on('click', function() {
        $(this).addClass('is-active');
        var href = $(this).attr('href'),
            el = '<div class="modalWrap" data-target="modalWrap"></div>';
            $('body').append(el);
            $.ajax({
                type: 'GET',
                url: href,
                dataType: 'html',
                success: function(data) {
                    $('[data-target="modalWrap"]').html(data);
                }
            });
        $('body').attr('aria-busy' , 'true');

        var fixScroll = (function() {
            pointY = $(window).scrollTop();

            $('body')
            .css({
                'position': 'fixed',
                'top': -pointY,
                'width': '100%'
            });
        })();

        return false;
    });
    //close
    $(document).on('click', '[data-trigger="modalClose"]', function() {
        $('[data-trigger="modalOpen"]').removeClass('is-active');
        $('body').attr('aria-busy' , 'false');
        $(this).parents('[data-target="modalWrap"]').remove();

        var scrollRelease = (function(){
            $('body').css({
                'position': '',
                'width': '',
                'top': ''
            });
        })();

        $(window).scrollTop(pointY);

        return false;
    });
}

/* !gnaviSearchWindow ---------------------------------------------------------------- */
var gnaviSearchWindow = function() {
    function gnaviSearchWindowOpen() {
        $('a.gnaviSearchWindowBtn').attr('aria-selected' , 'true');
        $('div.gnaviSearchWindow').attr('aria-hidden' , 'false');
        return false;
    }
    function gnaviSearchWindowClose() {
        $('a.gnaviSearchWindowBtn').attr('aria-selected' , 'false');
        $('div.gnaviSearchWindow').attr('aria-hidden' , 'true');
        return false;
    }
    $(document).on('click', '[data-trigger="gnaviSearchWindowOpen"]', function() {
        if($('div.gnaviSearchWindow').attr('aria-hidden')==='true') {
            gnaviSearchWindowOpen();
        } else {
            gnaviSearchWindowClose();
        }
    });
    $(document).on('click', '[data-trigger="gnaviSearchWindowClose"]', function() {
        gnaviSearchWindowClose();
    });
}

/* !lstToggle(アコーディオン) ---------------------------------------------------------------- */
var lstToggle = function() {
    $('[data-trigger="lstToggle"]').on('click', function() {
        $(this).next().slideToggle(300);
        if ($(this).attr('aria-selected') === 'false') {
            $(this).attr('aria-selected' , 'true');
            $(this).next().attr('aria-expanded' , 'true');
        } else if ($(this).attr('aria-selected') === 'true') {
            $(this).attr('aria-selected' , 'false');
            $(this).next().attr('aria-expanded' , 'false');
        }
    });
    $('[data-trigger="lstToggleClose"]').on('click', function() {
        $(this).parents('[data-target="lstToggleWrap"]').find('[aria-expanded]').attr('aria-expanded' , 'false').slideToggle(300);
        $(this).parents('[data-target="lstToggleWrap"]').find('[aria-selected]').attr('aria-selected' , 'false');
    });
}

/* !clipToggle(URLをコピー) ---------------------------------------------------------------- */
var clipToggle = function() {
    $('body').append('<input class="copy-text" type="text" style="position:fixed;left:-100%;" value="'+location.href+'" readonly  onfocus="this.select();">');
    $('[data-trigger="clipToggle"]').on('click', function() {
        var target = null;
        var p = null;
        window.getSelection().removeAllRanges();
        if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
            target = document.querySelector('.copy-text');
            target.contentEditable  = true;
            target.readOnly = false;
        } else {
            p = document.createElement('p');
            p.setAttribute('id', 'target')
            document.body.appendChild(p);
            p.innerHTML = $('.copy-text').val();
            target = document.querySelector('#target');
        }
        var range = document.createRange();
        range.selectNode(target);
        window.getSelection().addRange(range);
        document.execCommand("copy");
        if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
            target.contentEditable  = false;
            target.readOnly = true;
        } else {
            document.body.removeChild(p);
        }
        window.getSelection().removeAllRanges();
        alert("URLをコピーしました。");
    });
}




/* 文字省略 ※/shared/js/lib.jsに依存-------------------------------------------------------- */
$(function(){
    var winW = $(window).width();
    var devW = 767;
    if (winW <= devW) {
        //sp
        $('.articleCard-ttl').trunk8({
            lines: 2
        });
        $('.articleBox-txt').trunk8({
            lines: 2
        });
    } else {
        //pc
    }
});



/* PRバナー(カルーセル) ※/shared/js/slick.jsに依存 ------------------------------------------------------- */
$(window).on('load', function() {
    $('#prCarouseContainer').slick({
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        dots: false,
        autoplay: true,
        arrows: true,
        autoplaySpeed: 3500
    });
    $('#prCarouseContainer').css('display', 'block');
});

$(window).on('load', function() {
    $('#sp-prCarouselBox .slider').slick({
        arrows: false,
        autoplay: true,
        autoplaySpeed:4000,
        dots: false,
        //dotsClass: 'slick-dots',
        infinite: true,
        initialSlide: 0,
        slidesToShow: 3,
        slidesToScroll: 1,
    });
});

/* !headerMenu -------------------------------------------------------------- */
var headerMenu = (function() {
    $('[data-trigger="headerMenuOpen"]').on('click', function() {
        $(this).attr('aria-selected' , 'false');
        $('[data-target="headerMenuClose"]').attr('aria-selected' , 'true');
        $('[data-target="headerMenu"]').attr('aria-expanded' , 'true');
        $('[data-target="header"]').attr('aria-expanded' , 'true');
        $('html , body').attr('aria-hidden' , 'true');
    });
    $('[data-trigger="headerMenuClose"]').on('click', function() {
        $('[data-target="headerMenuClose"]').attr('aria-selected' , 'false');
        $('[data-target="headerMenuOpen"]').attr('aria-selected' , 'true');
        $('[data-target="headerMenu"]').attr('aria-expanded' , 'false');
        $('[data-target="header"]').attr('aria-expanded' , 'false');
        $('html , body').removeAttr('aria-hidden');
    });
});

/* 高さ揃え ※/shared/js/lib.jsに依存------------------------------------------ */
$(function () {
    $('.columnRowList').matchHeight();
    $('.productbox').matchHeight();
    $(".sectionInner").matchHeight();
    $(".containerWrap-item").matchHeight();
    $('.matchHeight').matchHeight();
})

/* タブ切り替え -------------------------------------------------------------- */
$(function () {
    $('.tabBoxWrap').each(function(){//最初のボックスにcurを付与
        $(this).find('.tabTitle').find('li.tabBtn').eq(0).addClass("cur");
        $(this).find('.tabContents').find('li.tabContentsList').eq(0).addClass("cur");
    });
    $('.tabBoxWrap').find('.tabTitle').find('li').click(function(){//クリックでcur切り替え
        var i = $(this).index();
        $(this).siblings().removeClass('cur');
        $(this).addClass('cur');
        $(this).closest('.tabBoxWrap').find('.tabContents').find('.tabContentsList').siblings().removeClass('cur');
        $(this).closest('.tabBoxWrap').find('.tabContents').find('.tabContentsList').eq(i).addClass('cur');
    });
});

/* カードポップアップ --------------------------------------------------------- */
$(function () {
    $('.consumerBox-btn , [data-target="cardPopBtn"]').find('[data-trigger="cardPop"]').click(function(){
        $(this).closest('.consumerBox-btn , [data-target="cardPopBtn"]').siblings('.consumerBox-pop , [data-target="cardPopContent"]').fadeIn();
        var el = '<div class="card-overlay" data-trigger="cardPopClose"></div>';
        $(this).closest('.consumerBox-btn , [data-target="cardPopBtn"]').append(el);
        return false;
    });
    $(document).on('click', '[data-trigger="cardPopClose"]', function() {
        $(this).closest('.consumerBox-btn , [data-target="cardPopBtn"]').siblings('.consumerBox-pop , [data-target="cardPopContent"]').fadeOut();
        $(this).fadeOut();
        return false;
	});
});

/* !carouselBox ------------------------------------------------------------- */
$(function() {
    $('#hero-carouselContainer').slick({
        arrows: false,
        autoplay: true,
        autoplaySpeed:4000,
        centerMode: true,
        centerPadding: '6.4vw',
        dots: true,
        dotsClass: 'hero-carouselDots',
        infinite: true,
        initialSlide: 0,
        slidesToShow: 1,
        slidesToScroll: 1,
    });
    var slideMenu = function(target) {
        var elSlideIndicator = '<div class="slideIndicator" data-target="slideIndicator"></div>';
        $(target).parents('[data-target="slideMenuWrap"]').append(elSlideIndicator);
        $(target).slick({
            arrows: true,
            autoplay: false,
            swipeToSlide: false,
            draggable: false,
            dots: true,
            dotsClass: 'slick-dots',
            appendDots: $('[data-target="slideIndicator"]'),
            infinite: true,
            slidesToShow: 3,
            slidesToScroll: 1,
            variableWidth: true,
            slidesToShow: 2
        });
    }
    slideMenu('[data-target="slideMenu"]');
});

$(window).load(function () {
  $('#hero-carouselContainer').animate({opacity: '1'}, 500);
});

/* CV測定 ---------------- */
{
  $.getScript("https://www.rakuten-insurance.co.jp/shared/js/rat/rat.js");
};

/* fixedHeader for SP ------------------------------------------------------ */
// var startPos = 0;
// var scrollTop = 0;
// $(window).on('scroll', function () {
//         $(window).scroll(function () {
//           scrollTop = $(window).scrollTop();
//             if( scrollTop > startPos ){
//                     if(scrollTop > 200){
//                         $('header').addClass('cur');
//                         $('header').removeClass('up');
//                         $('.page-barba').addClass('cur');
//                         $('.page-barba').removeClass('up');
//                     }else{
//                         $('header').removeClass('cur');
//                         $('header').removeClass('up');
//                         $('.page-barba').removeClass('cur');
//                         $('.page-barba').removeClass('up');

//                     }
//                 }else if(startPos > scrollTop){
//                     if(startPos > 200){
//                         $('header').addClass('up');
//                         $('.page-barba').addClass('up');
//                     }else{
//                         $('header').removeClass('up');
//                         $('header').removeClass('cur');
//                         $('.page-barba').removeClass('up');
//                         $('.page-barba').removeClass('cur');
//                     }
//                 }
//                 startPos = scrollTop;
//         });
// });

/* articleCardモジュールのクリティカブルエリア制御 ※サムネイルクリック時でも遷移させる(タイトルのtarget属性に応じて遷移方法分岐) ------------------------------------------------------ */
$(function() {
    $('div.articleCard .articleCard-img').click(function() {
        if($(this).closest('.articleCard').find('.articleCard-ttl a').attr('target') == '_blank'){
            window.open($(this).closest('.articleCard').find('.articleCard-ttl a').attr('href'), '_blank');
        }else{
            location.href = $(this).closest('.articleCard').find('.articleCard-ttl a').attr('href');
        }
        return false;
    });
});

///* scroll ------------------------------------------------------ */
//$(function() {
//	if(window.matchMedia( '(max-width: 756px)' ).matches){
//		$("html").easeScroll({
//		  frameRate: 60,
//		  animationTime: 1000,
//		  stepSize: 120,
//		  pulseAlgorithm: 1,
//		  pulseScale: 8,
//		  pulseNormalize: 1,
//		  accelerationDelta: 20,
//		  accelerationMax: 1,
//		  keyboardSupport: true,
//		  arrowScroll: 50,
//		  touchpadSupport: true,
//		  fixedBackground: true
//		});
//	}
//});
$(function(){
    var mnoHeight = $('.mnoBnrArea').height();
    var plusHeight = mnoHeight + 57;
    var divH = $(window).height();
    var gNaviHeight = (divH - plusHeight) + 'px';
    var gNaviTopMargin = plusHeight + 'px';
    $('.gnaviDropBox').css({'height': gNaviHeight,'margin-top': gNaviTopMargin});
});
