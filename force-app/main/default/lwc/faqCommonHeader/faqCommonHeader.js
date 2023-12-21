import { LightningElement,  api } from 'lwc';
import siteIncResources from '@salesforce/resourceUrl/RakutenIpFAQResources';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class FaqCommonHeader extends LightningElement {

    @api siteName;
    @api logoUrl;
    faqurl;
    logo_pc;
    logo_sp;
    image_name;

    // 初期処理
    connectedCallback() {
        // CSSの読み込み
        loadStyle(this, siteIncResources + '/css/event.css');
        loadStyle(this, siteIncResources + '/css/index.css');
        // ロゴのURLとFAQのトップのURLの設定
        switch (this.siteName) {
            case 'FAQLife':
                this.image_name = '楽天生命';
                this.logo_sp = `${siteIncResources}/images/header_life/logo_sp.svg`;
                this.logo_pc = `${siteIncResources}/images/header_life/logo_pc.svg`;
                this.faqurl = '/faqlife/s/';
                break;
            case 'FAQSonpo':
                this.image_name = '楽天損保';
                this.logo_sp = `${siteIncResources}/images/header_gen/logo_sp.png`;
                this.logo_pc = `${siteIncResources}/images/header_gen/logo_pc.png`;
                this.faqurl = '/faqsonpo/s/';
                break;
            case 'FAQPet':
                this.image_name = '楽天ペット保険';
                this.logo_sp = `${siteIncResources}/images/header_pet/logo_sp.png`;
                this.logo_pc = `${siteIncResources}/images/header_pet/logo_pc.png`;
                this.faqurl = '/faqpet/s/';
                break;
            default:
                break;
        }
    }

}