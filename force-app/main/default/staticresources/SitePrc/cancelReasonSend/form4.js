
//理解したor詳しい話を聞き相談したい選択によっての判定制御
function judgeUnderstandingSelection(){
    $('.js-counseling-content').css('display', 'none');
    $('.js-page-submit').prop('disabled', true);
    const target1 = $('input[name="nmIsUnderstanding1"]:checked').data('value');
    const target2 = $('input[name="nmIsUnderstanding2"]:checked').data('value');
    const target3 = $('input[name="nmIsUnderstanding3"]:checked').data('value');
    const target4 = $('input[name="nmIsUnderstanding4"]:checked').data('value');
    const target5 = $('input[name="nmIsUnderstanding5"]:checked').data('value');
    const target6 = $('input[name="nmIsUnderstanding6"]:checked').data('value');
    const open6 = $('.js-understanding-accordion').hasClass('open');
    if(target1 == '1' && target2 == '1' && target3 == '1' && target4 == '1' && target5 == '1' && ((open6 == true && target6 == '1') || open6 == false)) {
      $('#CounselingContent').css('display', 'none');
      $('.js-page-submit').prop('disabled', false);
    }else if(target1 == '0' || target2 == '0' || target3 == '0' || target4 == '0' || target5 == '0' || (open6 == true && target6 == '0')) {
      $('#CounselingContent').css('display', 'block');
    $('.js-page-submit').prop('disabled', true);
    }
  }
  
  $(function(){
    // ご解約の理由ボタン
    $('.js-cancellation-reason').on('change',function(){
      $('.js-confirmation-content').css('display', 'none');
      const target = $(this).data('target');
      $('#' + $(this).data('target')).css('display', 'block');
    })
    
    //3点お伺いボタン
    $('.js-circumstance').on('change',function(){
      $('.js-attention-content').css('display', 'none');
      $('.js-attention-submit').prop('disabled', true);
      const target1 = $('input[name="nmIsCircumstance1"]:checked').data('value');
      const target2 = $('input[name="nmIsCircumstance2"]:checked').data('value');
      const target3 = $('input[name="nmIsCircumstance3"]:checked').data('value');
      if(target1 == '1' || target2 == '1' || target3 == '1') {
        $('#AttentionContent1').css('display', 'block');
      }else if(target1 == '0' && target2 == '0' && target3 == '0'){
        $('#AttentionContent2').css('display', 'block');
      }
      const check1 = $('input[name="nmIsCircumstance1"]:checked').is(':checked');
      const check2 = $('input[name="nmIsCircumstance2"]:checked').is(':checked');
      const check3 = $('input[name="nmIsCircumstance3"]:checked').is(':checked');
      if(check1 == true && check2 == true && check3 == true){
        $('.js-attention-submit').prop('disabled', false);
      }
    })
    
    //ここまでで問題ないのでさらにページを進むボタン
    $('.js-attention-submit').on('click',function(){
      const target = $(this).data('target');
      $('#' + $(this).data('target')).css('display', 'block');
    })
    
    //理解したor詳しい話を聞き相談したいボタン
    $('.js-understanding').on('change',function(){
      judgeUnderstandingSelection();
    })
    
    //理解したor詳しい話を聞き相談したいアコーディオン
    $('.js-understanding-accordion').on('click', function(){
      if($(this).hasClass('open')){
        $(this).next().slideUp(200);
        $(this).removeClass('open');
        $('input[name="nmIsUnderstanding6"]:checked').prop('checked', false);
      }else{
        $(this).next().slideDown(200);
        $(this).addClass('open');
      }
      judgeUnderstandingSelection();
    });
    
    //相談コンテンツの閉じるボタン
    $('.js-counseling-close').on('click',function(){
      const target = $(this).data('target');
      $('#' + $(this).data('target')).css('display', 'none');
    })
    
    //お手続きページへ進むボタン
    $('.js-page-submit').on('click',function(){
      const target = $('input[name="nmCancellationReason"]:checked').data('value');
      location.href = 'https://procedure.rakuten-insurance.co.jp/procedure/s/life-cancel-contract/?' + target;
    })
  });