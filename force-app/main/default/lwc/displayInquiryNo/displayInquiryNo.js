import { LightningElement, api } from 'lwc';

export default class DisplayInquiryNo extends LightningElement {
  @api parameterName;
  inquiryNo;
  connectedCallback() {
    if(this.parameterName) this.inquiryNo = this.getUrlParamValue(window.location.href, this.parameterName);
    console.log('### inquiryNo', this.inquiryNo);
  }

  getUrlParamValue(url, key) {
    return new URL(url).searchParams.get(key);
  }
}