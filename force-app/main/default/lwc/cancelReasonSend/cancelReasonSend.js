import { api, LightningElement } from 'lwc';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';
import { loadScript } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';

export default class CancelReasonSend extends NavigationMixin(LightningElement) {

    @api cancelAmt;
    @api cancelCont;
    @api cancelAnother;

    reason;
    choice;
    choices;

    ReasonAmt;
    ReasonCont;
    ReasonAnother;
    //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携 By 張　Start
    disadvantageOPT1;
    disadvantageOPT2;
    disadvantageOPT3;
    disadvantageOPT4;
    disadvantageOPT5;
    disadvantageOPT6;
    //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携 By 張　End

    connectedCallback() {
        this.ReasonAmt = this.cancelAmt ? this.getOptionsFromArrayAmt(this.cancelAmt) : null;
        this.ReasonCont = this.cancelCont ? this.getOptionsFromArrayCont(this.cancelCont) : null;
        this.ReasonAnother = this.cancelAnother ? this.getOptionsFromArrayAnother(this.cancelAnother) : null;
    }

    renderedCallback() {
        this.loadScripts();
    }

    async loadScripts() {
        await loadScript(this, siteIncResources + '/template/js/jquery-3.4.1.min.js')
        this.initialLoad();
    };

    $(selector){
        if(selector && selector.nodeType && selector.nodeType === 1) return $(selector)
        if(selector.indexOf('#')>=0) selector = "[id^='"+selector.replace('#','')+"']"
        return $(this.template.querySelectorAll(selector))
    }

    getOptionsFromArrayAmt(str){
        let ret = []
        str.split(',').map((key, idx)=>{
            ret.push({
                label: key.includes('楽天生命以外') ? '<strong>楽天生命以外</strong>' + key.replace('楽天生命以外', '') : key,
                value: 'reason1=' + key, 
                id: 'CancellationReasonPrice' + (idx + 1),
                target: idx == 2 ? 'ConfirmationContent2' : 'ConfirmationContent1'
            })
        });
        return ret;
    }

    getOptionsFromArrayCont(str){
        let ret = []
        str.split(',').map((key, idx)=>{
            ret.push({
                label: key.includes('楽天生命以外') ? '<strong>楽天生命以外</strong>' + key.replace('楽天生命以外', '') : key,
                value: 'reason2=' + key, 
                id: 'CancellationReasonContent' + (idx + 1),
                target: idx == 0 ? 'ConfirmationContent2' : 'ConfirmationContent1'
            })
        });
        return ret;
    }

    getOptionsFromArrayAnother(str){
        let ret = []
        str.split(',').map((key, idx)=>{
            ret.push({
                label: key,
                value: 'reason3=' + key, 
                id: 'CancellationReasonOther' + (idx + 1),
                target: idx == 0 ? 'ConfirmationContent2' : 'ConfirmationContent1'
            })
        });
        return ret;
    }


    //理解したor詳しい話を聞き相談したい選択によっての判定制御
    judgeUnderstandingSelection(){
        console.log('##judgeUnderstandingSelection');
        const that = this

        that.$('.js-counseling-content').css('display', 'none');
        that.$('.js-page-submit').prop('disabled', true);
        const target1 = that.$('input[name="nmIsUnderstanding1"]:checked').data('value');
        const target2 = that.$('input[name="nmIsUnderstanding2"]:checked').data('value');
        const target3 = that.$('input[name="nmIsUnderstanding3"]:checked').data('value');
        const target4 = that.$('input[name="nmIsUnderstanding4"]:checked').data('value');
        const target5 = that.$('input[name="nmIsUnderstanding5"]:checked').data('value');
        const target6 = that.$('input[name="nmIsUnderstanding6"]:checked').data('value');
        // Modefied 2023/09/19 【RIPCRM-1012】解約フォーム_共済商品解約時「メディエイドα特約」部分の不利益同意内容の修正 By 張 Start 
         // const open6 = that.$('.js-understanding-accordion').hasClass('open');
         // if(target1 == '1' && target2 == '1' && target3 == '1' && target4 == '1' && target5 == '1' && ((open6 == true && target6 == '1') || open6 == false)) { */
         if(target1 == '1' && target2 == '1' && target3 == '1' && target4 == '1' && target5 == '1' &&  target6 == '1') {
             that.$('#CounselingContent').css('display', 'none');
             that.$('.js-page-submit').prop('disabled', false);
             //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start 
             that.disadvantageOPT1 = encodeURI(that.$('#Understand1').text());
             that.disadvantageOPT2 = encodeURI(that.$('#Understand2').text());
             that.disadvantageOPT3 = encodeURI(that.$('#Understand3').text());
             that.disadvantageOPT4 = encodeURI(that.$('#Understand4').text());
             that.disadvantageOPT5 = encodeURI(that.$('#Understand5').text());
             that.disadvantageOPT6 = encodeURI(that.$('#Understand6').text());
            //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End 
         //}else if(target1 == '0' || target2 == '0' || target3 == '0' || target4 == '0' || target5 == '0' || (open6 == true && target6 == '0')) {
         }else if(target1 == '0' || target2 == '0' || target3 == '0' || target4 == '0' || target5 == '0' || target6 == '0') {
             that.$('#CounselingContent').css('display', 'block');
             that.$('.js-page-submit').prop('disabled', true);
         } 
        // Modefied 2023/09/19 【RIPCRM-1012】解約フォーム_共済商品解約時「メディエイドα特約」部分の不利益同意内容の修正 By 張 End 
    }


    initialLoad() {
        console.log('##initialLoad');
        const that = this

        // ご解約の理由ボタン
        that.$('.js-cancellation-reason').on('change',function(){
            that.$('.js-confirmation-content').css('display', 'none');
            const target = that.$(this).data('target');

            console.log('##target', target);
            that.$('#' + that.$(this).data('target')).css('display', 'block');

            that.reason = that.$('input[name="nmCancellationReason"]:checked').data('value');
            if(that.reason) {
                that.choices = that.reason.split('=');
                that.choice = encodeURI(that.choices[1]);
            }
        })
        
        //3点お伺いボタン
        that.$('.js-circumstance').on('change',function(){
            that.$('.js-attention-content').css('display', 'none');
            that.$('.js-attention-submit').prop('disabled', true);
            const target1 = that.$('input[name="nmIsCircumstance1"]:checked').data('value');
            const target2 = that.$('input[name="nmIsCircumstance2"]:checked').data('value');
            const target3 = that.$('input[name="nmIsCircumstance3"]:checked').data('value');
            if(target1 == '1' || target2 == '1' || target3 == '1') {
                that.$('#AttentionContent1').css('display', 'block');
            }else if(target1 == '0' && target2 == '0' && target3 == '0'){
                that.$('#AttentionContent2').css('display', 'block');
            }
            const check1 = that.$('input[name="nmIsCircumstance1"]:checked').is(':checked');
            const check2 = that.$('input[name="nmIsCircumstance2"]:checked').is(':checked');
            const check3 = that.$('input[name="nmIsCircumstance3"]:checked').is(':checked');
            if(check1 == true && check2 == true && check3 == true){
                that.$('.js-attention-submit').prop('disabled', false);
            }
        })
        
        //ここまでで問題ないのでさらにページを進むボタン
        that.$('.js-attention-submit').on('click',function(event){
            event.preventDefault();
            const target = that.$(this).data('target');
            that.$('#' + that.$(this).data('target')).css('display', 'block');
        })
        
        //理解したor詳しい話を聞き相談したいボタン
        that.$('.js-understanding').on('change',function(){
            console.log('##js-understanding')
            that.judgeUnderstandingSelection();
        })
        // Delete 2023/09/19 【RIPCRM-1012】解約フォーム_共済商品解約時「メディエイドα特約」部分の不利益同意内容の修正 By 張 Start 
        //理解したor詳しい話を聞き相談したいアコーディオン
        /* that.$('.js-understanding-accordion').on('click', function(){
            if(that.$(this).hasClass('open')){
                that.$(this).next().slideUp(200);
                that.$(this).removeClass('open');
                that.$('input[name="nmIsUnderstanding6"]:checked').prop('checked', false);
            }else{
                that.$(this).next().slideDown(200);
                that.$(this).addClass('open');
            }
            that.judgeUnderstandingSelection();
        }); */
        // Delete 2023/09/19 【RIPCRM-1012】解約フォーム_共済商品解約時「メディエイドα特約」部分の不利益同意内容の修正 By 張 End 
        //相談コンテンツの閉じるボタン
        that.$('.js-counseling-close').on('click',function(){
            const target = that.$(this).data('target');
            that.$('#' + target).css('display', 'none');
        })
        
        //お手続きページへ進むボタン
        that.$('.js-page-submit').on('click',function(){
            if(that.choices[0] == 'reason1') {
                that[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'custom_cancel_contract__c'
                    },
                    state:  {
                       reason1: that.choice,
                       //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
                       disadvantageOPT1 : that.disadvantageOPT1,
                       disadvantageOPT2 : that.disadvantageOPT2,
                       disadvantageOPT3 : that.disadvantageOPT3,
                       disadvantageOPT4 : that.disadvantageOPT4,
                       disadvantageOPT5 : that.disadvantageOPT5,
                       disadvantageOPT6 : that.disadvantageOPT6
                       //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　End
                    }
                });
            } else if (that.choices[0] == 'reason2') {
                that[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'custom_cancel_contract__c'
                    },
                    state:  {
                        reason2: that.choice,
                        //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携  By 張　Start
                        disadvantageOPT1 : that.disadvantageOPT1,
                        disadvantageOPT2 : that.disadvantageOPT2,
                        disadvantageOPT3 : that.disadvantageOPT3,
                        disadvantageOPT4 : that.disadvantageOPT4,
                        disadvantageOPT5 : that.disadvantageOPT5,
                        disadvantageOPT6 : that.disadvantageOPT6
                        //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携 By 張　End
                    }
                });
            } else if (that.choices[0] == 'reason3') {
                that[NavigationMixin.Navigate]({
                    type: 'comm__namedPage',
                    attributes: {
                        name: 'custom_cancel_contract__c'
                    },
                    state:  {
                        reason3: that.choice,
                        //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携 By 張　Start
                        disadvantageOPT1 : that.disadvantageOPT1,
                        disadvantageOPT2 : that.disadvantageOPT2,
                        disadvantageOPT3 : that.disadvantageOPT3,
                        disadvantageOPT4 : that.disadvantageOPT4,
                        disadvantageOPT5 : that.disadvantageOPT5,
                        disadvantageOPT6 : that.disadvantageOPT6
                        //2023/10/10 Add 不利益事項のチェック内容のオブジェクト連携 By 張　End
                    }
                });
            }
        })
    }
}