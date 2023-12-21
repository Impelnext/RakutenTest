import { LightningElement,  api } from "lwc";
//import { CurrentPageReference } from "lightning/navigation";
import siteIncResources from "@salesforce/resourceUrl/RakutenIpFAQResources";
import { loadStyle } from "lightning/platformResourceLoader";

export default class HeaderInsuranceSogo extends LightningElement {
  @api dispFAQTop;
  @api faqSite;
  @api logo_url;
  faqurl;
  logo_pc;
  logo_sp;
  image_name;

  connectedCallback() {
    // CSSの読み込み
    loadStyle(this, siteIncResources + "/css/event.css");
    loadStyle(this, siteIncResources + "/css/index.css");
    //ロゴのURLとFAQのトップのURLの設定
    if (this.faqSite === "FAQLife") {
        this.logo_sp = `${siteIncResources}/images/header_life/logo_sp.svg`;
        this.logo_pc = `${siteIncResources}/images/header_life/logo_pc.svg`;
        this.image_name = "楽天生命";
        this.faqurl = "/faqlife/s/";
    } else {
      if (this.faqSite === "FAQSongo") {
        this.logo_sp = `${siteIncResources}/images/header_gen/logo_sp.png`;
        this.logo_pc = `${siteIncResources}/images/header_gen/logo_pc.png`;
        this.image_name = "楽天保険";
        this.faqurl = "/faqsongo/s/";
      } else {
        this.logo_sp = `${siteIncResources}/images/header_pet/logo_sp.png`;
        this.logo_pc = `${siteIncResources}/images/header_pet/logo_pc.png`;
        this.image_name = "楽天ペット保険";
        this.faqurl = "/faqpet/s/";
      }
    }

  }


}