import { api, track } from 'lwc';
import { PubsubExtentions } from 'c/pubsubExtentions';


export default class RefundBankRadio extends PubsubExtentions {

    @api itemKey;

    value = '';
    valueBankType = '';
    valueBookSymbol = '';
    valueBookNum = '';
    valueBank = '';
    valueBranch = '';
    valueDepositType = '';
    valueAccNum = '';

    existCreditCard = false;
    existRefund = false;
    creditBankType = '';
    creditBookSymbol = '';
    creditBookNum = '';
    creditBank = '';
    creditBranch = '';
    creditDepositType = '';
    creditAccNum = '';

    get options() {
        return [
            { label: '上記で入力した保険料の返金先口座と同じ', value: '上記で入力した保険料の返金先口座と同じ' },
            { label: '上記で入力した口座とは別の口座を入力する', value: '上記で入力した口座とは別の口座を入力する' },
        ];
    }
  
    // 確認画面への遷移
    confirmPhase;
  
    onRecivedMessage(that, message){
        if(message.componentName=='confirmPhase') that.confirmPhase = message.componentValue;
        if(message.componentName=='ConfRefundCard') that.existCreditCard = message.componentValue;
        if(message.componentName=='ConfRefundAccInfoBank') that.creditBank = message.componentValue;
        if(message.componentName=='ConfRefundAccInfoBranch') that.creditBranch = message.componentValue;
        if(message.componentName=='ConfRefundAccInfoDepoType') that.creditDepositType = message.componentValue;
        if(message.componentName=='ConfRefundAccInfoAccNum') that.creditAccNum = message.componentValue;
        if(message.componentName=='ConfRefundAccInfoPassbookSymbol') that.creditBookSymbol = message.componentValue;
        if(message.componentName=='ConfRefundAccInfoPassbookNum') that.creditBookNum = message.componentValue;
        if(message.componentName=='ConfRefundProductNote') {
            that.existRefund = message.componentValue;
            if (that.dispInput) {
                if (that.dispPostBank) {
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBank' ,componentValue:that.valueBankType});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:''});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:''});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:''});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:that.valueBookSymbol});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:that.valueBookNum});
                } else {
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBank' ,componentValue:that.valueBank});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:that.valueBranch});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:that.valueDepositType});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:that.valueAccNum});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:''});
                    that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:''});
                }
            } else {
                that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBank' ,componentValue:''});
                that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:''});
                that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:''});
                that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:''});
                that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:''});
                that.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:''});
            }
        }
        if(message.componentName=='CreditCardBank') that.creditBankType = message.componentValue;

    }   
      
    connectedCallback() {
        this.confirmPhase = false;
        this.subscribeToMessageChannel(this ,this.onRecivedMessage);
    }

    renderedCallback() {
        const rdo = this.template.querySelector('input[value="' + this.value + '"]');
        if (rdo) rdo.checked = true;
        const bnk = this.template.querySelector('input[value="' + this.valueBankType + '"]');
        if (bnk) bnk.checked = true;
        const slt = this.template.querySelector('select');
        if (slt) slt.value = this.valueDepositType;
    }

    get dispInput() {
        return !this.confirmPhase && this.existRefund;
    }
    get styleInput() {
      return this.dispInput ? 'display: block;' : 'display: none;'
    }

    get dispConfirm() {
        return this.confirmPhase && this.existRefund;
    }

    get dispCreditBank() {
        return this.existCreditCard;
    }
    get styleCreditBank() {
      return this.dispCreditBank ? 'display: block;' : 'display: none;'
    }

    get dispSameBank() {
        return this.value == '上記で入力した保険料の返金先口座と同じ'
    }
    

    get dispBankList() {
        return !this.existCreditCard || this.value == '上記で入力した口座とは別の口座を入力する';
    }
    get styleBankList() {
      return this.dispBankList ? 'display: block;' : 'display: none;'
    }

    get dispPostBank() {
        return this.existRefund && this.dispBankList && this.valueBankType == 'ゆうちょ銀行';
    }
    get stylePostBank() {
      return this.dispPostBank ? 'display: block;' : 'display: none;'
    }
    get disabledPostBankInputs() {
      return !this.dispPostBank;
    }

    get dispOtherBank() {
        return this.existRefund && this.dispBankList && this.valueBankType == 'その他銀行';
    }
    get styleOtherBank() {
      return this.dispOtherBank ? 'display: block;' : 'display: none;'
    }
    get disabledOtherBankInputs() {
      return !this.dispOtherBank;
    }

    get dispCreditPost() {
        return this.dispSameBank && this.creditBankType == 'ゆうちょ銀行';
    }

    get dispCreditOther() {
        return this.dispSameBank && this.creditBankType == 'その他銀行';
    }

    changeRadioHandler(event) {
        this.value = event.target.value;
        if (this.dispBankList) {
            if (this.dispPostBank) {
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBank' ,componentValue:this.valueBankType});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:this.valueBookSymbol});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:this.valueBookNum});
            } else {
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBank' ,componentValue:this.valueBank});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:this.valueBranch});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:this.valueDepositType});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:this.valueAccNum});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:''});
                this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:''});
            }
        } else {
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBank' ,componentValue:this.creditBank});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:this.creditBranch});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:this.creditDepositType});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:this.creditAccNum});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:this.creditBookSymbol});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:this.creditBookNum});
        }
    }

    changeRadioBankTypeHandler(event) {
        this.valueBankType = event.target.value;
        if (this.dispPostBank) {
            const payload = {componentName:'ConfRefundPtAccInfoBank' ,componentValue:this.valueBankType};
            this.publishToMessageChannel(payload);
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:this.valueBookSymbol});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:this.valueBookNum});
        } else {
            const payload = {componentName:'ConfRefundPtAccInfoBank' ,componentValue:''};
            this.publishToMessageChannel(payload);
            if (this.valueDepositType == '') {
                this.valueDepositType = '普通預金';
            }
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoBranch' ,componentValue:this.valueBranch});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:this.valueDepositType});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:this.valueAccNum});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:''});
            this.publishToMessageChannel({componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:''});
        }

    }

    changeValuePassbookSymbolHandler(event) {
        this.valueBookSymbol = event.target.value;
        const payload = {componentName:'ConfRefundPtAccInfoPassbookSymbol' ,componentValue:this.valueBookSymbol};
        this.publishToMessageChannel(payload);
    }

    changeValuePassbookNumHandler(event) {
        this.valueBookNum = event.target.value;
        const payload = {componentName:'ConfRefundPtAccInfoPassbookNum' ,componentValue:this.valueBookNum};
        this.publishToMessageChannel(payload);
    }

    changeValueBankNameHandler(event) {
        this.valueBank = event.target.value;
        const payload = {componentName:'ConfRefundPtAccInfoBank' ,componentValue:this.valueBank};
        this.publishToMessageChannel(payload);
    }

    changeValueBranchNameHandler(event) {
        this.valueBranch = event.target.value;
        const payload = {componentName:'ConfRefundPtAccInfoBranch' ,componentValue:this.valueBranch};
        this.publishToMessageChannel(payload);
    }

    changeValueDepositTypeHandler(event) {
        this.valueDepositType = event.target.value;
        const payload = {componentName:'ConfRefundPtAccInfoDepoType' ,componentValue:this.valueDepositType};
        this.publishToMessageChannel(payload);
    }

    changeValueAccNumHandler(event) {
        this.valueAccNum = event.target.value;
        const payload = {componentName:'ConfRefundPtAccInfoAccNum' ,componentValue:this.valueAccNum};
        this.publishToMessageChannel(payload);
    }

}