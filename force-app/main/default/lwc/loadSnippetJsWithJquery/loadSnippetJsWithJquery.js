import { LightningElement,api } from 'lwc';
import siteIncResources from '@salesforce/resourceUrl/SiteInc';
import jqueryCookie from '@salesforce/resourceUrl/jqueryCookie';
import { loadScript } from 'lightning/platformResourceLoader';

export default class LoadSnippetJsWithJquery extends LightningElement {
  @api jsSource;

  async connectedCallback() {
    await loadScript(this, siteIncResources + '/template/js/jquery-3.4.1.min.js')
    await loadScript(this, jqueryCookie)

    var _this = this
    window._snapinsSnippetSettingsFile = (function() {
      try {
        if(_this.jsSource){
          _this.jsSource.split(',').forEach( function(js){
            var el = document.createElement('script');
            el.src = js;
            document.body.appendChild(el);
            console.log('load snipped js');
          })

        }
      } catch (e) {
        console.error(e);
      }
    })();
  }
}