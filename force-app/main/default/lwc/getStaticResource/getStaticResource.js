import { LightningElement } from 'lwc';
import siteCommonResources from '@salesforce/resourceUrl/SiteCommon';
import siteSitePrcResources from '@salesforce/resourceUrl/SitePrc';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class GetStaticResource extends LightningElement {

    connectedCallback(){
        loadStyle(this, siteCommonResources + '/template/css/style.css')
        loadStyle(this, siteSitePrcResources + '/shared/css/index.css')
    }
}