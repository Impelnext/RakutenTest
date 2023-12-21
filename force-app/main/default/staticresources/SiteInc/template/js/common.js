
//パラメータ取得
function getParam(name, url) {
  if (!url) url = window.location.href;
  name = name.replace(/[\[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return '';
  return decodeURIComponent(results[2].replace(/\+/g, " "));
}

//規約スクロール判定
const getScrollVerticalPosition = e => {
  const {
    scrollHeight, scrollTop, clientHeight
  } = e.target;

  const isScrollTop = scrollTop === 0;
  const isScrollBottom = scrollHeight - clientHeight === scrollTop;
  
  if (isScrollTop) {
    return 'top';
  } else if (isScrollBottom) {
    return 'bottom';
  } else {
    return 'scrolling';
  }
}
const elem = document.querySelector('.js-scrollArea');
const check = document.querySelector('.js-agree');

if(elem) {
	elem.addEventListener('scroll', e => {
		const scrollPosition = getScrollVerticalPosition(e);

		if(scrollPosition == 'bottom') {
			check.disabled = false;
		}
	});
}

//upload file preview
function imgPreView(event, id){
  var file = event.target.files[0];
  var reader = new FileReader();
  var preview = document.getElementById("preview-"+ id);
  var previewImage = document.getElementById("previewImage-"+ id);
	var modalImg = document.querySelector('.p-modal_img');
	var modalImgimg = document.querySelector('.p-modal_img img');
   
  if(previewImage != null) {
		preview.removeChild(previewImage);
		preview.classList.remove('uploaded');
	}
	
  reader.onload = function(event) {
    var img = document.createElement("img");
    img.setAttribute("src", reader.result);
    img.setAttribute("id", "previewImage-" + id);
    preview.appendChild(img);
		preview.classList.add('uploaded');
		
		var img2 = document.createElement("img");
    img2.setAttribute("src", reader.result);
		modalImg.removeChild(modalImg.lastChild);
		modalImg.appendChild(img2);
  };
  reader.readAsDataURL(file);
}

$(function(){
	//パラメータ振り分け
	var param = getParam('company');
	if(param == 'pet') {
		$('.pet').show().siblings().remove();
		$('#CompanyName').attr('value','楽天ペット保険');
	}else if(param == 'gen') {
		$('.gen').show().siblings().remove();
		$('#CompanyName').attr('value','楽天損保');
	}else{
		$('.life').show().siblings().remove();
		$('#CompanyName').attr('value','楽天生命');
	}
	
	//QA
	$('.js-open_qa').on('click', function(){
		$(this).next('.c-list_faqBody').slideDown(200);
	});
	$('.js-close_qa').on('click', function(){
		$(this).parents('.c-list_faqBody').slideUp(200);
	});
	
	//accordion
	$('.js-accordion').on('click', function(){
		if($(this).hasClass('open')) {
			$(this).next().slideUp(200);
			$(this).removeClass('open');
		}else{
			$(this).next().slideDown(200);
			$(this).addClass('open');
		}
	});
	
	//upload file delete
	$('.js-fileDelete').on('click', function(){
		$(this).parents('li').find('input[type=file]').val('');
		$(this).parents('li').find('img').remove();
		$(this).parents('li').find('.c-form_filePreview').removeClass('uploaded');
	});
	
	//smooth scroll
	$('.js-scroll').on('click', function () {
		if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
			var $target = $(this.hash);
			$target = $target.length && $target || $('[name=' + this.hash.slice(1) + ']');
			if ($target.length) {
				var targetOffset = $target.offset().top;
				$('html,body').animate({
					scrollTop: targetOffset
				}, 500);
				return false;
			}
		}
	});
	
	if($('#js-qrcode').length) {
		var qrtext = location.href;
		var utf8qrtext = unescape(encodeURIComponent(qrtext));
		$('#js-qrcode').qrcode({width:100,height:100,text:utf8qrtext});
	}

	//upload file modal
	$('.js-fileModal').on('click',function(){
    var img = $(this).find('img').attr('src');
		var palam = $(this).prev('input').attr('onchange');
    $('.p-modal_img').html('<img src="' + img + '" alt="">');
		$('.p-modal .c-form_file input').attr('onchange', palam);
  });
	
	$('.js-fileModal').magnificPopup({
		type: 'inline',
		mainClass: 'mfp-with-zoom',
		callbacks: {
			beforeOpen: function() {
			},
			close: function() {
			}
		}
	});
});

$(function(){
	var open = $('.modal-open'),
		close = $('.modal-close'),
		container = $('.modal-container');

	open.on('click',function(){	
		container.addClass('active');
		return false;
	});

	close.on('click',function(){	
		container.removeClass('active');
	});

	$(document).on('click',function(e) {
		if(!$(e.target).closest('.modal-body').length) {
			container.removeClass('active');
		}
	});
});