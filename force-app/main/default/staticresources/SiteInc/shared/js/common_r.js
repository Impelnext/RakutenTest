/**
 * common_r.js
 *
 *  version --- 0.1
 *  updated --- 2021/11/10
 */
$(function() {

'use strict';

/* !the value of <meta name="viewport"> is replace for tablet device -------------- */
    var ua = navigator.userAgent;
    if ((ua.indexOf('iPhone') > 0) || ua.indexOf('iPod') > 0 || (ua.indexOf('Android') > 0 && ua.indexOf('Mobile') > 0)) {
        $('head>meta[name="viewport"]').replaceWith('<meta name="viewport" content="width=device-width,initial-scale=1.0">');
    } else {//SPでなければ
        $('head>meta[name="viewport"]').replaceWith('<meta name="viewport" content="width=1280,user-scalable=no">');
    }

/* !logIn/logOut ---------------------------------------------------------------- */
    var rlLogin = false;
    var name = 'rllogin=';
    var ca = document.cookie.split('; ');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        if(c.indexOf(name) != -1) {
            rlLogin = c.substring(name.length, c.length);
            break;
        }
    }
    if(rlLogin) {
        $('.logIO, .logout').show();
    } else {
        $('.logIO, .logout').hide();
    }

/* !gnaviCurrent ---------------------------------------------------------------- */
    var dirName = location.pathname.split('/')[1],
        href = dirName && dirName !== 'index.html' ? '/' + dirName + '/' : '/';

    var dirList = {
                       recommend:  '/recommend/',
                       products:   '/products/all.html',
                       life:       '/products/all.html',
                       medical:    '/products/all.html',
                       cancer:     '/products/all.html',
                       disaster:   '/products/all.html',
                       dementia:   '/products/all.html',
                       super2000:  '/products/all.html',
                       contractor: '/contractor/',
                       agent_consulting: 'https://partner.rakuten-life.co.jp/agent/',
                  };
    if(dirList[dirName]) {
        $('.jsGnavCurrent').find('a[href^="' + dirList[dirName] + '"]').parent('li').addClass('current');
    } else {
        $('.jsGnavCurrent').find('a[href="'+ href +'"]').parent('li').addClass('current');
    }

/* !ページ内リンク ---------------------------------------------------------------- */
    // スムーススクロールさせたくない箇所には notSwing クラスを指定してください
    $('a[href^="#"]:not([data-trigger="modal-open"])').on('click', function(){
        if( !$(this).hasClass('notSwing') ){
            var speed = 500; //移動完了までの時間(sec)を指定
            var href= $(this).attr('href');
            var target = $(href == '#' || href == '' ? 'html' : href);
            var position = target.offset().top;
            $('html, body').animate({scrollTop:position}, speed, 'swing');
            return false;
        }
    });

/* !searchFormInput ---------------------------------------------------------------- */
    //input
    $('[data-trigger="searchFormInput"]').on('keydown keyup keypress change', function(){
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
    $('[data-trigger="searchFormReset"]').on('click', function(){
        $(this).attr({
            'aria-selected' : 'false'
        });
    });

/* !lstToggle(アコーディオン) ---------------------------------------------------------------- */
    $('[data-trigger="lstToggle"]').on('click', function() {
        $(this).next().slideToggle(300);
        if ($(this).attr('aria-selected') === 'false') {
            $(this).attr('aria-selected' , 'true');
            $(this).next().attr('aria-expanded' , 'true');
        } else if ($(this).attr('aria-selected') === 'true') {
            var _this = this;
            setTimeout( function() {
                $(_this).next().attr('aria-expanded' , 'false');
                $(_this).attr('aria-selected' , 'false');
            }, 300);
        }
    });
    $('[data-trigger="lstToggleClose"]').on('click', function() {
        var pos = $(this).closest('[data-target="lstToggleWrap"]').offset().top;
        if(pos < $(window).scrollTop()) {
            $("html, body").animate({ scrollTop: pos }, 300, 'swing');
        }
        $(this).parents('[data-target="lstToggleWrap"]').find('[data-trigger="lstToggle"]').triggerHandler('click');
    });

/* !headerMenu ---------------------------------------------------------------- */
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

/* モーダル ------------------------------------------------------------------ */
    // modal
    $.fn.modal  = function (callback){
        var href = $(this).attr('href');
        var html = $(href).html();
        var hideClose = $(href).hasClass('hideClose');

        var options = { title: $(href).data('title'),
                        full: $(href).hasClass('full'),
                        fade: $(href).hasClass('fade'),
                        closeButton: !hideClose,
                        className: $(href).data('class')
                      }
        if(html){
            RLImodal.show(html, options);
        }

        if(typeof(callback) === 'function') callback();
    }

    /* modal */
    $('[data-trigger=modal-open]').on('click', function () {
        $(this).modal();

        return false;
    });
});
