import { LightningElement } from 'lwc';

export default class FooterInsuaranceSogo extends LightningElement {

  connectedCallback() {
    this.createInputElementForRAT(this);
  }

  createInputElementForRAT(_this){
    if(!this.appendInput){
      this.appendInput = document.createElement('input');
      this.appendInput.type="hidden";
      this.appendInput.name="rat";
      this.appendInput.id="ratAccountId";
      this.appendInput.value="1009";

      this.appendInput2 = document.createElement('input');
      this.appendInput2.type="hidden";
      this.appendInput2.name="rat";
      this.appendInput2.id="ratServiceId";
      this.appendInput2.value="1";
      
      this.template.appendChild(this.appendInput);
      this.template.appendChild(this.appendInput2);
    }
  }
}