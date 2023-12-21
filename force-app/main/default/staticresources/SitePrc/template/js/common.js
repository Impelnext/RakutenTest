
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
  const isScrollBottom = scrollHeight - clientHeight <= scrollTop + 10;

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
const submit = document.querySelector('.js-submit-btn');

if(elem) {
	elem.addEventListener('scroll', e => {
		const scrollPosition = getScrollVerticalPosition(e);

		if(scrollPosition == 'bottom') {
			check.disabled = false;
		}
	});

	check.addEventListener('change', e => {
		submit.disabled = !check.checked;
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

$(function(){
	// 表示・非表示切り替え
	$('.js-toggle-display').change (function() {
		$('#' + $(this).data('target')).css('display', $(this).data('display'))
	})

	// 証券番号の追加
	$('.js-add-number').click (function() {
		const number = $('.js-number-list input').length + 1
		$('.js-number-list').append(`
			<div class="number-list__item js-number-list-item mt5">
				<label for="Number">証券番号<span class="js-number-text">${number}</span></label>
				<div class="c-number-form">
                  <input type="text" name="nmNumber[]" id="Number" class="c-form_text">
                  <button type="button" class="c-btn_remove center js-remove-number">
                    <span>削除</span>
                  </button>
                </div>
            </div>`)
		// 追加できるのは20件まで
		if (number === 20){
			$(this).fadeOut()
		}
	})
	// 証券番号の削除
	$(document).on('click', '.js-remove-number' , function() {
		$(this).parents('.js-number-list-item').remove()
		// ラベルの番号を振り直し
		$('.js-number-text').each(function (i) {
			i = i + 1;
			$(this).text(i);
		})
	})

	// 解約する契約種別の表示切り替え
	$('.js-cancellation-type').change (function() {
		// 一旦全て非表示
		$('.js-cancellation-content').css('display', 'none')
		const target = $(this).data('target')
		if (target === 'Both') {
			$('.js-cancellation-content').css('display', 'block')
		} else {
			$('#' + $(this).data('target')).css('display', 'block')
		}
	})

	// お支払い口座の表示切り替え
	$('.js-bank-1').change (function() {
		$('.js-bank-content-1').css('display', 'none')
		$('#' + $(this).data('target')).css('display', 'block')
	})
	$('.js-bank-2').change (function() {
		$('.js-bank-content-2').css('display', 'none')
		$('#' + $(this).data('target')).css('display', 'block')
	})

	toggleRegisterPhone()
	// 楽天生命に電話番号の登録はありますかの表示切り替え
	$('.js-register-phone').change (function() {
		toggleRegisterPhone()
	})

	// 解約払戻金のあるご契約の確認の表示切り替え
	$('.js-toggle-refund-bank').change (function() {
		toggleRefundBank()
	})
	$('.js-credit-contract').change (function() {
		toggleRefundBank()
	})
	// 解約払戻金のお支払い先口座を選択の表示切り替え
	$('.js-is-same-refund-bank').change (function() {
		toggleRefundBankInfo()
	})


	/**
	 * 登録電話番号関連の表示・非表示
	 */
	function toggleRegisterPhone() {
		if ($('.js-register-phone:checked').data('value') == '1') {
			$('.js-is-same-phone').css('display', 'block')
			$('.js-input-phone').css('display', 'none')
		} else {
			$('.js-is-same-phone').css('display', 'none')
			$('.js-input-phone').css('display', 'block')
		}
	}

	// クレジットカードの支払い契約の口座情報変更時
	$('.js-bank-1').change (function() {
		toggleRefundBankInfo()
	})
	$('.js-bank-content-1 input').change (function() {
		toggleRefundBankInfo()
	})
	$('.js-bank-content-1 select').change (function() {
		toggleRefundBankInfo()
	})

	/**
	 * 解約時の保険料の返金について
	 * 解約払戻金のお支払い先口座が「上記で入力した保険料の返金先口座と同じ」場合
	 * クレジット契約で入力された口座情報を表示
	 */
	function toggleRefundBankInfo() {
		$('.js-refund-bank-info').text('')
		if ($('.js-register-phone:checked').data('value') == '1') {
			// ゆうちょ
			if ($('.js-bank-1:checked').data('value') == '1') {
				const bank_number = $('.js-japan-post-bank-number-1').val() + 'ー' + $('.js-japan-post-bank-number-2').val()
				$('.js-refund-bank-info').html(`<div><span class="weight4">記号: </span>${bank_number}<div>`)
			}
			if ($('.js-bank-1:checked').data('value') == '2') {
				const bank_name = $('.js-other-bank-name').val()
				const branch_name = $('.js-other-bank-branch-name').val()
				const bank_type = $('.js-other-bank-type option:selected').text()
				const bank_number = $('.js-other-bank-number').val()
				$('.js-refund-bank-info').html(`
					<div><span class="weight4">金融機関: </span>${bank_name}</div>
					<div><span class="weight4">支店名: </span>${branch_name}</div>
					<div><span class="weight4">預金種別: </span>${bank_type}</div>
					<div><span class="weight4">口座番号: </span>${bank_number}</div>`)
			}
			// その他
		}
	}

	/**
	 * 解約払戻金関連の表示・非表示
	 */
	function toggleRefundBank() {
		$('.js-refund-content').css('display', 'block')
		// 解約払戻金のあるご契約がある場合
		if ($('.js-toggle-refund-bank:checked').length !== 0 && $('.js-toggle-refund-bank:checked').data('value') == '1') {
			// クレジット契約がある場合
			if ($('.js-credit-contract:checked').length !== 0 && $('.js-credit-contract:checked').data('value') == '1') {
				$('.js-refund-select-form').css('display', 'block')
				$('.js-refund-bank-form').css('display', 'none')
			// クレジット契約がない場合
			} else {
				$('.js-refund-select-form').css('display', 'none')
				$('.js-refund-bank-form').css('display', 'block')
				$('.js-refund-select-form input').prop('checked', false)
			}
		// 解約払戻金のあるご契約がない場合
		} else {
			$('.js-refund-select-form').css('display', 'none')
			$('.js-refund-bank-form').css('display', 'none')
			$('.js-refund-select-form input').prop('checked', false)
		}
	}

	// モーダル表示
	const open = $('.js-modal-open'),
		close = $('.js-modal-close')
	open.on('click', function () {
		$('#' + $(this).data('target')).addClass('active')
		return false
	})
	close.on('click', function () {
		$('#' + $(this).data('target')).removeClass('active')
		return false
	})
	$(document).on('click', function (e) {
		if (!$(e.target).closest('.modal-body').length) {
			$('#' + $(this).data('target')).removeClass('active')
		}
	})

	// 電話番号変更の選択肢変更時
	$('.js-change-phone').change (function() {
		checkChangePhone()
	})
	$('.js-change-phone-2').change (function() {
		checkChangePhone()
	})

	function checkChangePhone() {
		$('.js-change-phone-error').text('').fadeOut()

		// ご自宅電話番号携帯電話番号も「利用なし」の場合
		if ($('.js-change-phone:checked').val() == '0000000000' && $('.js-change-phone-2:checked').val() == '0000000000') {
			$('.js-change-phone-error').text('電話番号はどちらか必ず変更、または変更なしにしてください。').fadeIn()
		}
	}
});