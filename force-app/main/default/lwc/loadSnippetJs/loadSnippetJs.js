import { LightningElement,api } from 'lwc';

export default class LoadSnippetJs extends LightningElement {
  @api jsSource;

  connectedCallback() {
    var _this = this
    window._snapinsSnippetSettingsFile = (function() {
      try {
        if(_this.jsSource){
          var el = document.createElement('script');
          el.src = _this.jsSource;
          document.body.appendChild(el);
          console.log('load snipped js');
        }
      } catch (e) {
        console.error(e);
      }
    })();
  }
}