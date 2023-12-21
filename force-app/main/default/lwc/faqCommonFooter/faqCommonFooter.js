import { LightningElement, api } from "lwc";
import RakutenIpFAQResources from "@salesforce/resourceUrl/RakutenIpFAQResources";

export default class FaqCommonFooter extends LightningElement {
  @api siteName;
  @api ratAccountId;
  @api ratServiceId;

  imgs = {
    ico_sonpo: `${RakutenIpFAQResources}/images/footer/ico_sonpo.png`,
    ico_pet: `${RakutenIpFAQResources}/images/footer/ico_pet.png`,
    ico_ir: `${RakutenIpFAQResources}/images/footer/ico_ir.png`,
    ico_bank: `${RakutenIpFAQResources}/images/footer/ico_bank.png`,
    ico_card: `${RakutenIpFAQResources}/images/footer/ico_card.png`,
    ico_point: `${RakutenIpFAQResources}/images/footer/ico_point.png`,
    ico_seimei: `${RakutenIpFAQResources}/images/footer/ico_seimei.png`,
  }

  get isFAQLife() {
    return this.siteName === "FAQLife";
  }

  get isFAQPet() {
    return this.siteName === "FAQPet";
  }

  get isFAQSonpo() {
    return this.siteName === "FAQSonpo";
  }

  get isFAQPetOrSonpo() {
    return (this.isFAQPet || this.isFAQSonpo);
  }

  connectedCallback() {
    this.createInputElementForRAT(this);
  }
  
  //Layout rendered
  renderedCallback() {
    this.addEventClickButton();
    this.addEventHoverButton();
  }

  //event hover button mode mobile
  addEventHoverButton() {
    let style = document.createElement('style');
    style.innerHTML = '.js-trigger:hover { background-color: #ebebeb; }';
    document.getElementsByTagName('head')[0].appendChild(style);
  }

  //event click button mode mobile
  addEventClickButton() {
    let buttons = this.template.querySelectorAll('button');
    buttons.forEach(button => {
      let ddElement = button.parentElement.nextElementSibling;
      ddElement.style.transition = 'max-height 0.3s ease-out';
      button.addEventListener('click', () => {
        let ariaExpanded = button.getAttribute('aria-expanded') === 'true';
        if (ariaExpanded) {
          //Collapse content for screen mobile
          button.classList.remove('is-active');
          ddElement.style.overflow = 'hidden';
          ddElement.style.display = 'block';
          ddElement.style.maxHeight = ddElement.scrollHeight + "px";
          ddElement.style.maxHeight = '0px';
          //use for screen laptop
          setTimeout(() => {
            ddElement.style.overflow = null;
            ddElement.style.display = null;
            ddElement.style.maxHeight = null;
            ddElement.style.maxHeight = null;
          }, 300)
        } else {
          //expand content
          button.classList.add('is-active');
          ddElement.style.overflow = 'hidden';
          ddElement.style.display = 'block';
          ddElement.style.maxHeight = '0px';
          ddElement.style.maxHeight = ddElement.scrollHeight + "px";
        }
        //direction icon
        button.setAttribute('aria-expanded', !ariaExpanded);
      })
    })
  }

  //Scroll to top
  moveToTop() {
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  createInputElementForRAT(_this){
    if(!this.appendInput){
      this.appendInput = document.createElement('input');
      this.appendInput.type="hidden";
      this.appendInput.name="rat";
      this.appendInput.id="ratAccountId";
      this.appendInput.value=this.ratAccountId;

      this.appendInput2 = document.createElement('input');
      this.appendInput2.type="hidden";
      this.appendInput2.name="rat";
      this.appendInput2.id="ratServiceId";
      this.appendInput2.value=this.ratServiceId;
      
      this.template.appendChild(this.appendInput);
      this.template.appendChild(this.appendInput2);
    }
  }
}