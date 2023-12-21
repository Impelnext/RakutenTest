/* ------------------------------------------
    carousel
------------------------------------------ */
/* ------------ Key Visual ------------ */
$('#hero-carousel').ready(function () {
    var elSlideNav = '<div class="hero-carouselNav" data-target="heroCarouselNav"></div>';
    $('#hero-carousel').parents('[data-target="hero"]').append(elSlideNav);
    $('#hero-carousel').slick({
        arrows: true,
        autoplay: true,
        autoplaySpeed: 12000,
        swipeToSlide: true,
        dots: true,
        dotsClass: 'slick-dots',
        appendDots: $('[data-target="heroCarouselNav"]'),
        infinite: true,
        slidesToShow: 1,
        slidesToScroll: 1
    });
    $('#hero-carousel').css('display', 'block');
});

/* ------------ Promotion ------------ */
$('#productsCarousel').ready(function () {
    $('#productsCarousel').slick({
        initialSlide: 1,
        arrows: true,
        appendArrows: $('[data-target="productsCarouselWrap"]'),
        autoplay: false,
        autoplaySpeed: 6000,
        swipeToSlide: true,
        dots: true,
        dotsClass: 'slick-dots',
        appendDots: $('[data-target="productsLstWrap"]'),
        infinite: true,
        slidesToShow: 1,
        slidesToScroll: 1,
        touchMove: false,
        swipe: false
    });
    $('#productsCarousel').css('display', 'block');

    var carouselCustom = (function(){
        $('[data-target="productsLst"] .productsLst-itemLnk').on('click' , function(){
            var panelNum = $(this).parent('.productsLst-item').index();
            $('[data-target="productsLstWrap"] .slick-dots li').eq(panelNum).click();
        });

        $('[data-target="productsLstWrap"] .slick-dots li').on('click' , function() {
            var dotsNum = $(this).index();
            $('[data-target="productsLst"] .productsLst-itemLnk').attr('aria-selected' , 'false');
            $('[data-target="productsLst"] .productsLst-itemLnk').eq(dotsNum).attr('aria-selected' , 'true');
        });

        $('[data-target="productsCarouselWrap"] .slick-arrow').on('click' , function() {
            var activedotsIndex = $('[data-target="productsLstWrap"] .slick-dots li.slick-active').index();
            $('[data-target="productsLst"] .productsLst-itemLnk').attr('aria-selected' , 'false');
            $('[data-target="productsLst"] .productsLst-itemLnk').eq(activedotsIndex).attr('aria-selected' , 'true');
        });
    })();

});

/* ------------ PR ------------ */
$('#prCarouseContainer').ready(function(){
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

$(function() {
    $('#prCarouselBox .slider').slick({
        arrows: false,
        autoplay: true,
        autoplaySpeed:4000,
        //dots: true,
        dotsClass: 'slick-dots',
        infinite: true,
        initialSlide: 0,
        slidesToShow: 3,
        slidesToScroll: 1,
    });

    setTimeout( function(){
        setCarouselWidth('#prCarouselBox');
    }, 0001);

    function setCarouselWidth(carouselID){
        var $track_halfWidth = $(carouselID + ' .slick-slide').width() / 2;
        var $track_totalWidth = 500;
        var $displayWidth = $(window).width() - 20; // margin 10px * 2
        if($(window).width() < 500){
            // slide
            $track_totalWidth = $('.carouselWrap').width() + $track_halfWidth;
            // dots
            $(carouselID + ' .slick-dots').width($displayWidth);
        }
    $(carouselID).width($track_totalWidth);
    }
});

/* ------------ LeadWire Campaign ------------ */
$('#cpCarouseContainer').ready(function(){
    $('#cpCarouseContainer').slick({
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        dots: false,
        autoplay: false,
        arrows: false,
        lazyLoad: 'progressive',
        autoplaySpeed: 3500
    });        
});

$(function() {    
    var w = $(window).width();
    if(w > 320){
        $('#cpCarouselBox .slider').slick({
            centerMode: true,
            centerPadding: '116px',
            lazyLoad: 'progressive',
            arrows: true,
            autoplay: true,
            autoplaySpeed:4000,
            dots: true,
            dotsClass: 'slick-dots',
            infinite: true,
            initialSlide: 0,
            slidesToShow: 1,
            fade: false,
            slidesToScroll: 1,
            prevArrow: '<div class="slick-prev slick-arrow"><i aria-hidden="true" class="rex-icon chevron-left"></i></div>',
            nextArrow: '<div class="slick-next slick-arrow"><i aria-hidden="true" class="rex-icon chevron-right"></i></div>',
         });
    }
    if(w == 320){
        $('#cpCarouselBox .slider').slick({
            centerMode: true,
            centerPadding: '100px',
            lazyLoad: 'progressive',
            arrows: true,
            autoplay: true,
            autoplaySpeed:4000,
            dots: true,
            dotsClass: 'slick-dots',
            infinite: true,
            initialSlide: 0,
            slidesToShow: 1,
            fade: false,
            slidesToScroll: 1,
            prevArrow: '<div class="slick-prev slick-arrow"><i aria-hidden="true" class="rex-icon chevron-left"></i></div>',
            nextArrow: '<div class="slick-next slick-arrow"><i aria-hidden="true" class="rex-icon chevron-right"></i></div>',
         });        
    }
});

/* 年代別カルーセル（SPのみ）　*/
$(function() {
    if (window.matchMedia('(max-width: 756px)').matches) {
        $('#byAgeMenu .slider').slick({
            arrows: false,
            autoplay: false,
            autoplaySpeed:4000,
            //dots: true,
            swipe: true,
            infinite: true,
            initialSlide: 0,
            slidesToShow: 3,
            slidesToScroll: 1,
            centerMode: true,
            initialSlide:2,
            swipeToSlide: true
        });
    }
});


$(function () {
  $('.slider').animate({opacity: '1'}, 1500);
  $('.grdText').animate({opacity: '1'}, 1500);
});

/* 高さ揃え ※/shared/js/lib.jsに依存------------------------------------------ */
$(function () {
    $('.container_card').matchHeight();
    $('.matchHeight').matchHeight();
})

/* 代理店コードチェック------------------------------------------ */
$(function () {
    var agencyCd = _getAgencyCd();
    var $diagnosis = $('.diagnosis');

    isDiagnosis(agencyCd)?$diagnosis.show():$diagnosis.remove();

    function isDiagnosis(agencyCd) {
        var checkList = new Array( '000001',  // life
                                   '584625',  // chatbot
                                   '417259',  // ip-ins
                                   '771870',  // hikaku
                                   '630100'   // ip-ins
                                 );

        if (agencyCd == null || checkList.indexOf(agencyCd) >= 0) {
            return true;
        }
        return false;
    }
})

