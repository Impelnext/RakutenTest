"use strict";

(function ($) {
  var $breakpoint = 1024;
  var w = $(window).width();
  var w_resize;
  var timer = false;
  Responsive($breakpoint);
  $(window).on("orientationchange resize", function () {
    if (timer !== false) {
      clearTimeout(timer);
    }

    timer = setTimeout(function () {
      w_resize = $(window).width();

      if (w != w_resize) {
        Responsive($breakpoint);
        w = $(window).width();
      }

      setFillHeight();
    }, 200);
  });
  megaMenu('.js-trigger[data-type="mega-down"]', $breakpoint);
  headerSearch('.js-trigger[data-type="search"]');
  pullDown('.js-trigger[data-type="pull"]', $breakpoint);
  accordion('.js-trigger[data-type="acc"]');
  megaClose('.js-megaClose');
  searchClose('.js-searchClose');
  globalNav('.js-trigger[data-modal-trigger]', $breakpoint);
  escape('.js-trigger', $breakpoint);
  expect($breakpoint); //floating
  setFillHeight();

  var $floatingElm = $('.js-floating');
  $(window).on("scroll", function () {
    var $w = $(window).width();
    if ($w < $breakpoint) return;
    var $headerH = $('header[role="banner"]').height();

    if ($(this).scrollTop() > $headerH) {
      $floatingElm.addClass('is-show');
    } else {
      $floatingElm.removeClass('is-show');
    }
  }); // hover behavior

  var ua = navigator.userAgent.toLowerCase();
  var link = $('.js-trigger[data-type="acc"],.js-trigger[data-type="mega-down"],.js-trigger[data-type="pull"]');

  if (/android|ipod|ipad|iphone|macintosh/.test(ua) && 'ontouchend' in document) {
    link.on("touchstart", function () {
      $(this).addClass("is-hover");
    });
    link.on("touchend", function () {
      $(this).removeClass("is-hover");
    });
  } else {
    link.hover(function () {
      $(this).addClass("is-hover");
    }, function () {
      $(this).removeClass("is-hover");
    });
  }
})(jQuery);

function megaMenu(target, breakpoint) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $wW = $(window).width();
    var $this = $(this);
    var $megaElm = $this.next();
    var $expand = $this.attr('aria-expanded');

    if ($expand === 'false') {
      if ($wW < breakpoint) {
        $this.next().stop().slideDown(300, function () {
          $this.css('height', '');
        });
      } else {
        $elm.not($this).removeClass('is-active').attr('aria-expanded', 'false').next().removeClass('is-open').attr('aria-hidden', 'true'); // element

        var $parentElm = $this.closest('nav'); // docucent

        var $targetElmDocPosX = $this.offset().left;
        var $parentElmDocPosX = $parentElm.offset().left; // relative from parent

        var $targetElmPosX = $targetElmDocPosX - $parentElmDocPosX; //width

        var $parentElmW = $parentElm.innerWidth();
        var $megaElmW = $megaElm.width(); //ajust

        var $difX;
        var $megaElmPosX;

        if ($targetElmPosX + $megaElmW > $parentElmW) {
          $difX = $targetElmPosX + $megaElmW - $parentElmW;
          $megaElmPosX = $targetElmPosX - $difX;
        } else {
          $megaElmPosX = $targetElmPosX;
        }

        $megaElm.css('left', $megaElmPosX);
      }

      $this.addClass('is-active').attr('aria-expanded', 'true');
      $megaElm.addClass('is-open').attr('aria-hidden', 'false');
    } else {
      if ($wW < breakpoint) {
        $this.next().stop().slideUp(300);
      }

      $this.removeClass('is-active').attr('aria-expanded', 'false');
      $megaElm.removeClass('is-open').attr('aria-hidden', 'true');
    }
  });
}

function headerSearch(target) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $this = $(this);
    var $expand = $this.attr('aria-expanded');

    if ($expand === 'false') {
      $this.addClass('is-active').attr('aria-expanded', 'true').next().fadeIn(300, function () {
        $(this).addClass('is-open').attr('aria-hidden', 'false');
      });
    } else {
      $this.removeClass('is-active').attr('aria-expanded', 'false').next().fadeOut(300, function () {
        $(this).removeClass('is-open').attr('aria-hidden', 'true');
      });
    }
  });
}

function pullDown(target, breakpoint) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $wW = $(window).width();
    var $this = $(this);
    var $expand = $this.attr('aria-expanded');

    if ($expand === 'false') {
      if ($wW < breakpoint) {
        $this.next().stop().slideDown(300, function () {
          $this.css('height', '');
        });
      }

      $this.addClass('is-active').attr('aria-expanded', 'true').next().addClass('is-open').attr('aria-hidden', 'false');
    } else {
      if ($wW < breakpoint) {
        $this.next().stop().slideUp(300);
      }

      $this.removeClass('is-active').attr('aria-expanded', 'false').next().removeClass('is-open').attr('aria-hidden', 'true');
    }
  });
}

function accordion(target) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $this = $(this);
    var $expand = $this.attr('aria-expanded');

    if ($expand === 'false') {
      $this.addClass('is-active').attr('aria-expanded', 'true');
      $this.parent().next().addClass('is-open').attr('aria-hidden', 'false').stop().slideDown(300, function () {
        $(this).css('height', '');
      });
    } else {
      $this.removeClass('is-active').attr('aria-expanded', 'false');
      $this.parent().next().removeClass('is-open').attr('aria-hidden', 'true').stop().slideUp(300);
    }
  });
}

function megaClose(target) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $this = $(this);
    $this.closest('[id]').removeClass('is-open').attr('aria-hidden', true).prev().attr('aria-expanded', false).focus();
  });
}

function searchClose(target) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $this = $(this);
    $this.closest('[id]').removeClass('is-open').attr('aria-hidden', true).fadeOut(300).prev().attr('aria-expanded', false).focus();
  });
}

function globalNav(target, breakpoint) {
  var $elm = $(target);
  $elm.on('click', function () {
    var $wW = $(window).width();
    if ($wW >= breakpoint) return;
    var $wY = $(window).scrollTop();
    var $state = $(this).data('modal-trigger');
    var $id = '#' + $(this).data('modal-target');
    var $gnav = $($id);
    var $bnr = $('.mnoBnrArea');
    var $bh = $bnr.height();

    if ($state === 'open') {
      $gnav.attr('aria-modal', 'true').attr('role', 'dialog').removeClass('is-hide').animate({
        left: '0',
        right: '0'
      }, 300, function () {
        $gnav.addClass('is-open');
        $('#menuTitle').focus();
      });
      $('html').addClass('is-menu-open');
      // 背景をスクロールさせない
      $('body').css({
        'overflow':'hidden'
      });
    } else if ($state === 'close') {
      $gnav.removeAttr('aria-modal').removeAttr('role').removeClass('is-open').animate({
        left: '-100%',
        right: '100%'
      }, 300, function () {
        $('#main-menu').addClass('is-hide');
        $('.js-trigger[data-modal-trigger="open"]').focus();
      });
      $('html').removeClass('is-menu-open');
      window.scrollTo(0, $wY);
      // 背景をスクロールさせない解除
      $('body').css({
        'overflow':'unset'
      });
    }

    // （バナーが存在する場合）メニューの高さをバナー分引く
    if($bnr.length){
      var $target = $('.p-rf-h_gnav#main-menu');
      if($('body').hasClass('head_sp_fixed') === false){
        $target.css({
          'height':'calc((var(--vh,1vh) * 100)' + ' - ' + $bh + 'px)'
        });
      }else {
        $target.css({
          'height':'calc((var(--vh,1vh) * 100)'
        });
      }
    }
  });
  
  $('[data-modal-position="start"]').on("focus", function (e) {
    var focusElm = [];
    $('#main-menu button:visible,#main-menu a:visible').each(function () {
      focusElm.push(this);
    });
    var focusElmNum = focusElm.length - 1;
    focusElm[focusElmNum].focus();
  });
  $('[data-modal-position="end"]').on("focus", function (e) {
    $('[data-modal-trigger="close"]').focus();
  });
}

// ウィンドウの高さを取得してcssをセット
function setFillHeight() {
  var vh     = window.innerHeight * 0.01;
  $('html').attr('style','--vh:'+vh+'px');
}

function escape(target, breakpoint) {
  var $elm = $(target);
  var $this;
  var $focusElm;
  var $focusElmType;
  var $modalFlag;
  $elm.on('click', function (e) {
    $this = $(this);

    if ($this.hasClass('js-trigger') && $this.hasClass('is-active')) {
      $focusElm = $this;
      $focusElmType = $focusElm.data('type');
    } else if ($this.hasClass('js-trigger') && $this.attr('data-modal-trigger')) {
      $modalFlag = 1;
      $focusElm = '';
    }
  });
  $(window).on('keyup', function (e) {
    var $wW = $(window).width();

    if (e.keyCode === 27) {
      if ($focusElm !== '') {
        if ($focusElmType == 'search') {
          $focusElm.removeClass('is-active').attr('aria-expanded', false);
          $focusElm.next().removeClass('is-open').attr('aria-hidden', true).fadeOut(300);
          $focusElm = '';
        } else if ($focusElmType == 'mega-down' || $focusElmType == 'pull') {
          if ($wW >= breakpoint) {
            $focusElm.removeClass('is-active').attr('aria-expanded', false);
            $focusElm.next().removeClass('is-open').attr('aria-hidden', true);
          } else {
            $focusElm.removeClass('is-active').attr('aria-expanded', false);
            $focusElm.next().removeClass('is-open').attr('aria-hidden', true).slideUp(300);
          }

          $focusElm = '';
        } else if ($focusElmType == 'acc') {
          $focusElm.removeClass('is-active').attr('aria-expanded', false);
          $focusElm.parent().next().removeClass('is-open').attr('aria-hidden', 'true').stop().slideUp(300);
          $focusElm = '';
        }
      } else if ($focusElm == '' && $modalFlag == 1) {
        $('#main-menu').removeAttr('aria-modal').removeAttr('role').removeClass('is-open').animate({
          left: '-100%',
          right: '100%'
        }, 300, function () {
          $('#main-menu').addClass('is-hide');
          $('.js-trigger[data-modal-trigger="open"]').focus();
        });
        $modalFlag = 0;
      }
    }
  });
}

function expect(breakpoint) {
  $(document).on('click', function (e) {
    var $w = $(window).width(); // search

    var $searchBtn = $('.js-trigger[data-type="search"]');
    var $searchArea = $searchBtn.parent(); // pull

    var $pullBtn = $('.js-trigger[data-type="pull"]');
    var $pullArea = $pullBtn.parent(); // mega

    var $megaBtn = $('.js-trigger[data-type="mega-down"]');
    var $megaArea = $megaBtn.parent();

    if (!$(e.target).closest($pullArea).length) {
      if ($w >= breakpoint) {
        $pullBtn.removeClass('is-active').attr('aria-expanded', 'false').next().removeClass('is-open').attr('aria-hidden', 'true');
      }
    }

    if (!$(e.target).closest($megaArea).length) {
      if ($w >= breakpoint) {
        $megaBtn.removeClass('is-active').attr('aria-expanded', 'false').next().removeClass('is-open').attr('aria-hidden', 'true');
      }
    }
  });
}

function Responsive(breakpoint) {
  var $w = $(window).width();
  $('.js-trigger[data-type="mega-down"],.js-trigger[data-type="pull"]').removeClass('is-active').attr('aria-expanded', false).next().removeClass('is-open').removeAttr('style');

  if ($w >= breakpoint) {
    $('.js-trigger[data-type="acc"]').removeClass('is-active').attr('aria-expanded', false).parent().next().removeAttr('style'); // navigation

    $('[data-role="main-menu"]').removeAttr('style').removeClass('is-hide is-open');
    $('body').css({
      'height': '',
      'overflow': ''
    });
  }
}