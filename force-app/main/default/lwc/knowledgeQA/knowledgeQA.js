import { LightningElement ,api } from 'lwc';
import sitePrcResources from '@salesforce/resourceUrl/SitePrc';

export default class KnowledgeQA extends LightningElement {

    @api question;

    /* Params from Url */
    _faqContentUrl = null;
    linkIcon = `${sitePrcResources}/template/images/icon_link.svg`;

    @api
    set answerHtmlValue(value) {
        if (this.answerDiv) {
            this.answerDiv.innerHTML = value;
        }
        this._answerHtmlValue = value;
    }

    get answerHtmlValue() {
        return this._answerHtmlValue;
    }

    /**
     * 回答のURL名を設定
     * @param {string} value
     */
    @api
    set urlName(value) {
        this._faqContentUrl = value
    }

    /**
     * 回答のURL名を取得
     * @return {null | string}
     */
    get urlName() {
        return this._urlName;
    }

    renderedCallback() {
        this.answerDiv = this.template.querySelector('.answer');
        this.answerDiv.innerHTML = this.answerHtmlValue;
    }
}