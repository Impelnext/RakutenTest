@isTest
public class RequestTriggerHandlerTest{

    static List<Request__c> prepareInsertData(){
        Account a = new Account();
        a.Name='TestName';
        insert a;
        SeihoAgencyMaster__c sa = new SeihoAgencyMaster__c();
        sa.agncyno__c='we123';
        insert sa;
        Reception__c rec = new Reception__c();
        rec.Address1__c= 'Test1';
        rec.Account__c=a.Id;
        rec.SeihoAgency__c=sa.id;
        insert rec;
        List<Request__c> reqList = new List<Request__c>();
        Request__c request1 = new Request__c(Class__c='共通ケース',Type__c='住所変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request1);
        Request__c request2 = new Request__c(Class__c='共通ケース',Type__c='改姓（名義変更）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request2);
        Request__c request3 = new Request__c(Class__c='共通ケース',Type__c='電話番号変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request3);
        Request__c request4 = new Request__c(Class__c='共通ケース',Type__c='メールアドレス変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request4);
        Request__c request5 = new Request__c(Class__c='共通ケース',Type__c='対応依頼',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request5);
        Request__c request6 = new Request__c(Class__c='共通ケース',Type__c='情報連携',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request6);
        Request__c request7 = new Request__c(Class__c='共通ケース',Type__c='苦情・要望',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id,VOCType__c='苦情',InsuranceCompany__c='生命',CauseOfDivision__c='窓口応対',ComplaintSummary__c='電話が繋がらないことへの苦情');reqList.add(request7);
        Request__c request8 = new Request__c(Class__c='生命専用ケース',Type__c='保険金・給付金・共済金請求',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',PresenceeOfDocumentIncluded__c='無',Reception__c=rec.Id);reqList.add(request8);
        Request__c request9 = new Request__c(Class__c='生命専用ケース',Type__c='解約',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request9);
        Request__c request10 = new Request__c(Class__c='生命専用ケース',Type__c='受取人（生保）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request10);
        Request__c request11 = new Request__c(Class__c='生命専用ケース',Type__c='指定代理人変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request11);
        Request__c request12 = new Request__c(Class__c='生命専用ケース',Type__c='証券再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request12);
        Request__c request13 = new Request__c(Class__c='生命専用ケース',Type__c='減額',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request13);
        Request__c request14 = new Request__c(Class__c='生命専用ケース',Type__c='減口（生保）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request14);
        Request__c request15 = new Request__c(Class__c='生命専用ケース',Type__c='特約解約',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request15);
        Request__c request16 = new Request__c(Class__c='生命専用ケース',Type__c='更新時減額',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request16);
        Request__c request17 = new Request__c(Class__c='生命専用ケース',Type__c='更新時減口（共済）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request17);
        Request__c request18 = new Request__c(Class__c='生命専用ケース',Type__c='更新拒否',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request18);
        Request__c request19 = new Request__c(Class__c='生命専用ケース',Type__c='控除再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request19);
        Request__c request20 = new Request__c(Class__c='生命専用ケース',Type__c='海外渡航',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request20);
        Request__c request21 = new Request__c(Class__c='生命専用ケース',Type__c='アルファ付替',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request21);
        Request__c request22 = new Request__c(Class__c='生命専用ケース',Type__c='減口（共済）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request22);
        Request__c request23 = new Request__c(Class__c='生命専用ケース',Type__c='受取人（共済）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request23);
        Request__c request24 = new Request__c(Class__c='生命専用ケース',Type__c='返金先口座',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request24);
        Request__c request25 = new Request__c(Class__c='生命専用ケース',Type__c='Retention',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request25);
        Request__c request26 = new Request__c(Class__c='生命専用ケース',Type__c='特約減額',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request26);
        Request__c request27 = new Request__c(Class__c='生命専用ケース',Type__c='汎用（生命）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request27);
        Request__c request28 = new Request__c(Class__c='生命専用ケース',Type__c='書類発送ケース',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request28);
        Request__c request29 = new Request__c(Class__c='生命専用ケース',Type__c='問合せケース（生命）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request29);
        Request__c request30 = new Request__c(Class__c='生命専用ケース',Type__c='契約確認コール',Subject__c='契約確認コール',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request30);
        Request__c request31 = new Request__c(Class__c='損保専用ケース',Type__c='住所・対象所在地同時変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request31);
        Request__c request32 = new Request__c(Class__c='損保専用ケース',Type__c='車両入替',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request32);
        Request__c request33 = new Request__c(Class__c='損保専用ケース',Type__c='保険証券再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request33);
        Request__c request34 = new Request__c(Class__c='損保専用ケース',Type__c='承認書再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request34);
        Request__c request35 = new Request__c(Class__c='損保専用ケース',Type__c='控除証明書再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request35);
        //Request__c request35 = new Request__c(Class__c='損保専用ケース',Type__c='サイクルアシスト証券発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request35);
        Request__c request36 = new Request__c(Class__c='損保専用ケース',Type__c='リビングアシスト契約証再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request36);
        Request__c request37 = new Request__c(Class__c='損保専用ケース',Type__c='中断証明発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request37);
        Request__c request38 = new Request__c(Class__c='損保専用ケース',Type__c='中断証明再発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request38);
        Request__c request39 = new Request__c(Class__c='損保専用ケース',Type__c='解約（自動車）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request39);
        Request__c request40 = new Request__c(Class__c='損保専用ケース',Type__c='解約（火災）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request40);
        Request__c request41 = new Request__c(Class__c='損保専用ケース',Type__c='解約（傷害）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request41);
        Request__c request42 = new Request__c(Class__c='損保専用ケース',Type__c='解約（ジャンプ・積立・その他）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request42);
        Request__c request43 = new Request__c(Class__c='損保専用ケース',Type__c='対象所在地変更（火災・満期戻）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request43);
        Request__c request44 = new Request__c(Class__c='損保専用ケース',Type__c='用途車種変更（自動車）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request44);
        Request__c request45 = new Request__c(Class__c='損保専用ケース',Type__c='保険金額変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request45);
        Request__c request46 = new Request__c(Class__c='損保専用ケース',Type__c='条件変更（自動車）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request46);
        Request__c request47 = new Request__c(Class__c='損保専用ケース',Type__c='全損失効',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request47);
        Request__c request48 = new Request__c(Class__c='損保専用ケース',Type__c='構造用法面積変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request48);
        Request__c request49 = new Request__c(Class__c='損保専用ケース',Type__c='職業職種（級別）の変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request49);
        Request__c request50 = new Request__c(Class__c='損保専用ケース',Type__c='権利譲渡（名義変更）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request50);
        Request__c request51 = new Request__c(Class__c='損保専用ケース',Type__c='名義変更（保険の対象の所有者氏名変更）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request51);
        Request__c request52 = new Request__c(Class__c='損保専用ケース',Type__c='増車',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request52);
        Request__c request53 = new Request__c(Class__c='損保専用ケース',Type__c='質権設定・削除',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request53);
        Request__c request54 = new Request__c(Class__c='損保専用ケース',Type__c='等級訂正',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request54);
        Request__c request55 = new Request__c(Class__c='損保専用ケース',Type__c='被保険者変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request55);
        Request__c request56 = new Request__c(Class__c='損保専用ケース',Type__c='付保証明書発行',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request56);
        Request__c request57 = new Request__c(Class__c='損保専用ケース',Type__c='口座変更、クレカ変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request57);
        Request__c request58 = new Request__c(Class__c='損保専用ケース',Type__c='入金確認',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request58);
        Request__c request59 = new Request__c(Class__c='損保専用ケース',Type__c='新規契約・継続契約・中途更改',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request59);
        Request__c request60 = new Request__c(Class__c='損保専用ケース',Type__c='問合せケース（損保）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request60);
        Request__c request61 = new Request__c(Class__c='損保専用ケース',Type__c='汎用（損保）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request61);
        Request__c request62 = new Request__c(Class__c='少短専用ケース',Type__c='少短事故受付',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request62);
        Request__c request63 = new Request__c(Class__c='少短専用ケース',Type__c='保険金関連（事故受付以外）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request63);
        Request__c request64 = new Request__c(Class__c='少短専用ケース',Type__c='少短事故受付(賠責）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request64);
        Request__c request65 = new Request__c(Class__c='少短専用ケース',Type__c='更新変更_少短',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request65);
        Request__c request66 = new Request__c(Class__c='少短専用ケース',Type__c='更新拒否_少短',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request66);
        Request__c request67 = new Request__c(Class__c='少短専用ケース',Type__c='解約',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request67);
        Request__c request68 = new Request__c(Class__c='少短専用ケース',Type__c='Retention',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request68);
        Request__c request69 = new Request__c(Class__c='少短専用ケース',Type__c='申込内容変更・新規多頭対応',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request69);
        Request__c request70 = new Request__c(Class__c='少短専用ケース',Type__c='契約内容変更',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request70);
        Request__c request71 = new Request__c(Class__c='少短専用ケース',Type__c='証券類・更新案内再送',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request71);
        Request__c request72 = new Request__c(Class__c='少短専用ケース',Type__c='振込用紙再送',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request72);
        Request__c request73 = new Request__c(Class__c='少短専用ケース',Type__c='問合せケース（少短）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request73);
        //Request__c request74 = new Request__c(Class__c='少短専用ケース',Type__c='汎用（少短)',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request74);
        Request__c request75 = new Request__c(Class__c='セールス専用ケース',Type__c='生命_コール資料請求',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request75);
        //Request__c request76 = new Request__c(Class__c='セールス専用ケース',Type__c='損保_ミドル連携',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request76);
        Request__c request77 = new Request__c(Class__c='セールス専用ケース',Type__c='少短_コール資料請求',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request77);
        Request__c request78 = new Request__c(Class__c='セールス専用ケース',Type__c='生命・少短_比較チーム連携',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request78);
        Request__c request79 = new Request__c(Class__c='セールス専用ケース',Type__c='生命_対面誘導（生命営推本部）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request79);
        //Request__c request80 = new Request__c(Class__c='セールス専用ケース',Type__c='信書回収',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request80);
        Request__c request81 = new Request__c(Class__c='生命代サ専用ケース',Type__c='タブレット・Team Viewer',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',TabletOperation__c = TRUE,TabletPolicy__c = TRUE,TabletReserve__c = TRUE,TabletError__c = TRUE,TabletCheck__c = TRUE,TeamViewer__c = TRUE,Reception__c=rec.Id);reqList.add(request81);
        Request__c request82 = new Request__c(Class__c='生命代サ専用ケース',Type__c='収納（集金）',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request82);
        Request__c request83 = new Request__c(Class__c='生命代サ専用ケース',Type__c='新契約',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request83);
        Request__c request84 = new Request__c(Class__c='生命代サ専用ケース',Type__c='声紋認証',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Registration__c = TRUE,Busy__c = TRUE,Decline__c = TRUE,Change__c = TRUE,Delete__c = TRUE,Reception__c=rec.Id);reqList.add(request84);
        Request__c request85 = new Request__c(Class__c='生命代サ専用ケース',Type__c='問い合わせケース',Subject__c='事由',ChangeAgencyRegistration__c = '有',AGRegistrationChange__c = '有',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Reception__c=rec.Id);reqList.add(request85);
        Request__c request86= new Request__c(Class__c='生命代サ専用ケース',Type__c='Agency Support',Subject__c='事由',ChangedPostNumber__c = '100-0027',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request86);  
        Request__c request87= new Request__c(Class__c='生命代サ専用ケース',Type__c='ポイントプログラム・楽天ID連携',Subject__c='事由',ChangedPostNumber__c = '100-0028',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request87);  
        Request__c request88= new Request__c(Class__c='生命代サ専用ケース',Type__c='保全（異動）・照会',Subject__c='事由',ChangedPostNumber__c = '100-0029',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request88);
        Request__c request89= new Request__c(Class__c='生命代サ専用ケース',Type__c='フォロー対応',Subject__c='口座不備',ChangedPostNumber__c = '100-0030',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request89);  
        Request__c request90= new Request__c(Class__c='生命代サ専用ケース',Type__c='フォロー対応',Subject__c='継続フォロー',ChangedPostNumber__c = '100-0030',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request90); 
        Request__c request91= new Request__c(Class__c='生命代サ専用ケース',Type__c='フォロー対応',Subject__c='お客様対応依頼',ChangedPostNumber__c = '100-0030',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request91);      
   
  return ReqList;
    }
    
    static List<Request__c> prepareUpdateData(List<Request__c> reqList){
        List<Request__c> reqListUpdt = new List<Request__c>();
        SeihoAgencyMaster__c sa = new SeihoAgencyMaster__c();
        sa.agncyno__c='we123';
        insert sa;
        Account a = new Account();
        a.Name='TestName1';
        insert a;
        Reception__c rec = new Reception__c();
        rec.Address1__c= 'Test2';
        rec.Account__c=a.Id;
        rec.SeihoAgency__c=sa.Id;
        insert rec;
        Request__c req1 = new Request__c(); req1.id=reqList[0].id;req1.Class__c='共通ケース';req1.Type__c='改姓（名義変更）';req1.Subject__c='事由';req1.Reception__c=rec.Id;reqListUpdt.add(req1);
        Request__c req2 =new Request__c();req2.id=reqList[1].id;req2.Class__c='共通ケース';req2.Type__c='電話番号変更';req2.Subject__c='事由';req2.Reception__c=rec.Id;reqListUpdt.add(req2);
        Request__c req3 =new Request__c();req3.id=reqList[2].id;req3.Class__c='共通ケース';req3.Type__c='メールアドレス変更';req3.Subject__c='事由';req3.Reception__c=rec.Id;reqListUpdt.add(req3);
        Request__c req4 =new Request__c();req4.id=reqList[3].id;req4.Class__c='共通ケース';req4.Type__c='対応依頼';req4.Subject__c='事由';req4.Reception__c=rec.Id;reqListUpdt.add(req4);
        Request__c req5 =new Request__c();req5.id=reqList[4].id;req5.Class__c='共通ケース';req5.Type__c='情報連携';req5.Subject__c='事由';req5.Reception__c=rec.Id;reqListUpdt.add(req5);
        Request__c req6 =new Request__c();req6.id=reqList[5].id;req6.Class__c='共通ケース';req6.Type__c='苦情・要望';req6.Subject__c='事由';req6.Reception__c=rec.Id;reqListUpdt.add(req6);
        Request__c req7 =new Request__c();req7.id=reqList[6].id;req7.Class__c='生命専用ケース';req7.Type__c='保険金・給付金・共済金請求';req7.Subject__c='事由';req7.PresenceeOfDocumentIncluded__c='無';req7.Reception__c=rec.Id;reqListUpdt.add(req7);
        Request__c req8 =new Request__c();req8.id=reqList[7].id;req8.Class__c='生命専用ケース';req8.Type__c='解約';req8.Subject__c='事由';req8.Reception__c=rec.Id;reqListUpdt.add(req8);
        Request__c req9 =new Request__c();req9.id=reqList[8].id;req9.Class__c='生命専用ケース';req9.Type__c='受取人（生保）';req9.Subject__c='事由';req9.Reception__c=rec.Id;reqListUpdt.add(req9);
        Request__c req10 =new Request__c();req10.id=reqList[9].id;req10.Class__c='生命専用ケース';req10.Type__c='指定代理人変更';req10.Subject__c='事由';req10.Reception__c=rec.Id;reqListUpdt.add(req10);
        Request__c req11 =new Request__c();req11.id=reqList[10].id;req11.Class__c='生命専用ケース';req11.Type__c='証券再発行';req11.Subject__c='事由';req11.Reception__c=rec.Id;reqListUpdt.add(req11);
        Request__c req12 =new Request__c();req12.id=reqList[11].id;req12.Class__c='生命専用ケース';req12.Type__c='減額';req12.Subject__c='事由';req12.Reception__c=rec.Id;reqListUpdt.add(req12);
        Request__c req13 =new Request__c();req13.id=reqList[12].id;req13.Class__c='生命専用ケース';req13.Type__c='減口（生保）';req13.Subject__c='事由';req13.Reception__c=rec.Id;reqListUpdt.add(req13);
        Request__c req14 =new Request__c();req14.id=reqList[13].id;req14.Class__c='生命専用ケース';req14.Type__c='特約解約';req14.Subject__c='事由';req14.Reception__c=rec.Id;reqListUpdt.add(req14);
        Request__c req15 =new Request__c();req15.id=reqList[14].id;req15.Class__c='生命専用ケース';req15.Type__c='更新時減額';req15.Subject__c='事由';req15.Reception__c=rec.Id;reqListUpdt.add(req15);
        Request__c req16 =new Request__c();req16.id=reqList[15].id;req16.Class__c='生命専用ケース';req16.Type__c='更新時減口（共済）';req16.Subject__c='事由';req16.Reception__c=rec.Id;reqListUpdt.add(req16);
        Request__c req17 =new Request__c();req17.id=reqList[16].id;req17.Class__c='生命専用ケース';req17.Type__c='更新拒否';req17.Subject__c='事由';req17.Reception__c=rec.Id;reqListUpdt.add(req17);
        Request__c req18 =new Request__c();req18.id=reqList[17].id;req18.Class__c='生命専用ケース';req18.Type__c='控除再発行';req18.Subject__c='事由';req18.Reception__c=rec.Id;reqListUpdt.add(req18);
        Request__c req19 =new Request__c();req19.id=reqList[18].id;req19.Class__c='生命専用ケース';req19.Type__c='海外渡航';req19.Subject__c='事由';req19.Reception__c=rec.Id;reqListUpdt.add(req19);
        Request__c req20 =new Request__c();req20.id=reqList[19].id;req20.Class__c='生命専用ケース';req20.Type__c='アルファ付替';req20.Subject__c='事由';req20.Reception__c=rec.Id;reqListUpdt.add(req20);
        Request__c req21 =new Request__c();req21.id=reqList[20].id;req21.Class__c='生命専用ケース';req21.Type__c='減口（共済）';req21.Subject__c='事由';req21.Reception__c=rec.Id;reqListUpdt.add(req21);
        Request__c req22 =new Request__c();req22.id=reqList[21].id;req22.Class__c='生命専用ケース';req22.Type__c='受取人（共済）';req22.Subject__c='事由';req22.Reception__c=rec.Id;reqListUpdt.add(req22);
        Request__c req23 =new Request__c();req23.id=reqList[22].id;req23.Class__c='生命専用ケース';req23.Type__c='返金先口座';req23.Subject__c='事由';req23.Reception__c=rec.Id;reqListUpdt.add(req23);
        Request__c req24 =new Request__c();req24.id=reqList[23].id;req24.Class__c='生命専用ケース';req24.Type__c='Retention';req24.Subject__c='事由';req24.Reception__c=rec.Id;reqListUpdt.add(req24);
        Request__c req25 =new Request__c();req25.id=reqList[24].id;req25.Class__c='生命専用ケース';req25.Type__c='特約減額';req25.Subject__c='事由';req25.Reception__c=rec.Id;reqListUpdt.add(req25);
        Request__c req26 =new Request__c();req26.id=reqList[25].id;req26.Class__c='生命専用ケース';req26.Type__c='汎用（生命）';req26.Subject__c='事由';req26.Reception__c=rec.Id;reqListUpdt.add(req26);
        Request__c req27 =new Request__c();req27.id=reqList[26].id;req27.Class__c='生命専用ケース';req27.Type__c='書類発送ケース';req27.Subject__c='事由';req27.Reception__c=rec.Id;reqListUpdt.add(req27);
        Request__c req28 =new Request__c();req28.id=reqList[27].id;req28.Class__c='生命専用ケース';req28.Type__c='問合せケース（生命）';req28.Subject__c='事由';req28.Reception__c=rec.Id;reqListUpdt.add(req28);
        Request__c req34 =new Request__c();req34.id=reqList[33].id;req34.Class__c='生命専用ケース';req34.Type__c='契約確認コール';req34.Subject__c='契約確認コール';req34.Reception__c=rec.Id;reqListUpdt.add(req34);
        Request__c req29 =new Request__c();req29.id=reqList[28].id;req29.Class__c='損保専用ケース';req29.Type__c='住所・対象所在地同時変更';req29.Subject__c='事由';req29.Reception__c=rec.Id;reqListUpdt.add(req29);
        Request__c req30 =new Request__c();req30.id=reqList[29].id;req30.Class__c='損保専用ケース';req30.Type__c='車両入替';req30.Subject__c='事由';req30.Reception__c=rec.Id;reqListUpdt.add(req30);
        Request__c req31 =new Request__c();req31.id=reqList[30].id;req31.Class__c='損保専用ケース';req31.Type__c='保険証券再発行';req31.Subject__c='事由';req31.Reception__c=rec.Id;reqListUpdt.add(req31);
        Request__c req32 =new Request__c();req32.id=reqList[31].id;req32.Class__c='損保専用ケース';req32.Type__c='承認書再発行';req32.Subject__c='事由';req32.Reception__c=rec.Id;reqListUpdt.add(req32);
        Request__c req33 =new Request__c();req33.id=reqList[32].id;req33.Class__c='損保専用ケース';req33.Type__c='控除証明書再発行';req33.Subject__c='事由';req33.Reception__c=rec.Id;reqListUpdt.add(req33);
        Request__c req35 =new Request__c();req35.id=reqList[34].id;req35.Class__c='損保専用ケース';req35.Type__c='リビングアシスト契約証再発行';req35.Subject__c='事由';req1.Reception__c=rec.Id;reqListUpdt.add(req35);
        Request__c req36 =new Request__c();req36.id=reqList[35].id;req36.Class__c='損保専用ケース';req36.Type__c='中断証明発行';req36.Subject__c='事由';req36.Reception__c=rec.Id;reqListUpdt.add(req36);
        Request__c req37 =new Request__c();req37.id=reqList[36].id;req37.Class__c='損保専用ケース';req37.Type__c='中断証明再発行';req37.Subject__c='事由';req37.Reception__c=rec.Id;reqListUpdt.add(req37);
        Request__c req38 =new Request__c();req38.id=reqList[37].id;req38.Class__c='損保専用ケース';req38.Type__c='解約（自動車）';req38.Subject__c='事由';req38.Reception__c=rec.Id;reqListUpdt.add(req38);
        Request__c req39 =new Request__c();req39.id=reqList[38].id;req39.Class__c='損保専用ケース';req39.Type__c='解約（火災）';req39.Subject__c='事由';req39.Reception__c=rec.Id;reqListUpdt.add(req39);
        Request__c req40 =new Request__c();req40.id=reqList[39].id;req40.Class__c='損保専用ケース';req40.Type__c='解約（傷害）';req40.Subject__c='事由';req40.Reception__c=rec.Id;reqListUpdt.add(req40);
        Request__c req41 =new Request__c();req41.id=reqList[40].id;req41.Class__c='損保専用ケース';req41.Type__c='解約（ジャンプ・積立・その他）';req41.Subject__c='事由';req41.Reception__c=rec.Id;reqListUpdt.add(req41);
        Request__c req42 =new Request__c();req42.id=reqList[41].id;req42.Class__c='損保専用ケース';req42.Type__c='対象所在地変更（火災・満期戻）';req42.Subject__c='事由';req42.Reception__c=rec.Id;reqListUpdt.add(req42);
        Request__c req43 =new Request__c();req43.id=reqList[42].id;req43.Class__c='損保専用ケース';req43.Type__c='用途車種変更（自動車）';req43.Subject__c='事由';req43.Reception__c=rec.Id;reqListUpdt.add(req43);
        Request__c req44 =new Request__c();req44.id=reqList[43].id;req44.Class__c='損保専用ケース';req44.Type__c='保険金額変更';req44.Subject__c='事由';req44.Reception__c=rec.Id;reqListUpdt.add(req44);
        Request__c req45 =new Request__c();req45.id=reqList[44].id;req45.Class__c='損保専用ケース';req45.Type__c='条件変更（自動車）';req45.Subject__c='事由';req45.Reception__c=rec.Id;reqListUpdt.add(req45);
        Request__c req46 =new Request__c();req46.id=reqList[45].id;req46.Class__c='損保専用ケース';req46.Type__c='全損失効';req46.Subject__c='事由';req46.Reception__c=rec.Id;reqListUpdt.add(req46);
        Request__c req47 =new Request__c();req47.id=reqList[46].id;req47.Class__c='損保専用ケース';req47.Type__c='構造用法面積変更';req47.Subject__c='事由';req47.Reception__c=rec.Id;reqListUpdt.add(req47);
        Request__c req48 =new Request__c();req48.id=reqList[47].id;req48.Class__c='損保専用ケース';req48.Type__c='職業職種（級別）の変更';req48.Subject__c='事由';req48.Reception__c=rec.Id;reqListUpdt.add(req48);
        Request__c req49 =new Request__c();req49.id=reqList[48].id;req49.Class__c='損保専用ケース';req49.Type__c='権利譲渡（名義変更）';req49.Subject__c='事由';req49.Reception__c=rec.Id;reqListUpdt.add(req49);
        Request__c req50 =new Request__c();req50.id=reqList[49].id;req50.Class__c='損保専用ケース';req50.Type__c='名義変更（保険の対象の所有者氏名変更）';req50.Subject__c='事由';req50.Reception__c=rec.Id;reqListUpdt.add(req50);
        Request__c req51 =new Request__c();req51.id=reqList[50].id;req51.Class__c='損保専用ケース';req51.Type__c='増車';req51.Subject__c='事由';req51.Reception__c=rec.Id;reqListUpdt.add(req51);
        Request__c req52 =new Request__c();req52.id=reqList[51].id;req52.Class__c='損保専用ケース';req52.Type__c='質権設定・削除';req52.Subject__c='事由';req52.Reception__c=rec.Id;reqListUpdt.add(req52);
        Request__c req53 =new Request__c();req53.id=reqList[52].id;req53.Class__c='損保専用ケース';req53.Type__c='等級訂正';req53.Subject__c='事由';req53.Reception__c=rec.Id;reqListUpdt.add(req53);
        Request__c req54 =new Request__c();req54.id=reqList[53].id;req54.Class__c='損保専用ケース';req54.Type__c='被保険者変更';req54.Subject__c='事由';req54.Reception__c=rec.Id;reqListUpdt.add(req54);
        Request__c req55 =new Request__c();req55.id=reqList[54].id;req55.Class__c='損保専用ケース';req55.Type__c='付保証明書発行';req55.Subject__c='事由';req55.Reception__c=rec.Id;reqListUpdt.add(req55);
        Request__c req56 =new Request__c();req56.id=reqList[55].id;req56.Class__c='損保専用ケース';req56.Type__c='口座変更、クレカ変更';req56.Subject__c='事由';req56.Reception__c=rec.Id;reqListUpdt.add(req56);
        Request__c req57 =new Request__c();req57.id=reqList[56].id;req57.Class__c='損保専用ケース';req57.Type__c='入金確認';req57.Subject__c='事由';req57.Reception__c=rec.Id;reqListUpdt.add(req57);
        Request__c req58 =new Request__c();req58.id=reqList[57].id;req58.Class__c='損保専用ケース';req58.Type__c='新規契約・継続契約・中途更改';req58.Subject__c='事由';req58.Reception__c=rec.Id;reqListUpdt.add(req58);
        Request__c req59 =new Request__c();req59.id=reqList[58].id;req59.Class__c='損保専用ケース';req59.Type__c='問合せケース（損保）';req59.Subject__c='事由';req59.Reception__c=rec.Id;reqListUpdt.add(req59);
        Request__c req60 =new Request__c();req60.id=reqList[59].id;req60.Class__c='損保専用ケース';req60.Type__c='汎用（損保）';req60.Subject__c='事由';req60.Reception__c=rec.Id;reqListUpdt.add(req60);
        Request__c req61 =new Request__c();req61.id=reqList[60].id;req61.Class__c='少短専用ケース';req61.Type__c='少短事故受付';req61.Subject__c='事由';req61.Reception__c=rec.Id;reqListUpdt.add(req61);
        Request__c req62 =new Request__c();req62.id=reqList[61].id;req62.Class__c='少短専用ケース';req62.Type__c='保険金関連（事故受付以外）';req62.Subject__c='事由';req62.Reception__c=rec.Id;reqListUpdt.add(req62);
        Request__c req63 =new Request__c();req63.id=reqList[62].id;req63.Class__c='少短専用ケース';req63.Type__c='少短事故受付(賠責）';req63.Subject__c='事由';req63.Reception__c=rec.Id;reqListUpdt.add(req63);
        Request__c req64 =new Request__c();req64.id=reqList[63].id;req64.Class__c='少短専用ケース';req64.Type__c='更新変更_少短';req64.Subject__c='事由';req64.Reception__c=rec.Id;reqListUpdt.add(req64);
        Request__c req65 =new Request__c();req65.id=reqList[64].id;req65.Class__c='少短専用ケース';req65.Type__c='更新拒否_少短';req65.Subject__c='事由';req65.Reception__c=rec.Id;reqListUpdt.add(req65);
        Request__c req66 =new Request__c();req66.id=reqList[65].id;req66.Class__c='少短専用ケース';req66.Type__c='解約';req66.Subject__c='事由';req66.Reception__c=rec.Id;reqListUpdt.add(req66);
        Request__c req67 =new Request__c();req67.id=reqList[66].id;req67.Class__c='少短専用ケース';req67.Type__c='Retention';req67.Subject__c='事由';req67.Reception__c=rec.Id;reqListUpdt.add(req67);
        Request__c req68 =new Request__c();req68.id=reqList[67].id;req68.Class__c='少短専用ケース';req68.Type__c='申込内容変更・新規多頭対応';req68.Subject__c='事由';req68.Reception__c=rec.Id;reqListUpdt.add(req68);
        Request__c req69 =new Request__c();req69.id=reqList[68].id;req69.Class__c='少短専用ケース';req69.Type__c='契約内容変更';req69.Subject__c='事由';req69.Reception__c=rec.Id;reqListUpdt.add(req69);
        Request__c req70 =new Request__c();req70.id=reqList[69].id;req70.Class__c='少短専用ケース';req70.Type__c='証券類・更新案内再送';req70.Subject__c='事由';req70.Reception__c=rec.Id;reqListUpdt.add(req70);
        Request__c req71 =new Request__c();req71.id=reqList[70].id;req71.Class__c='少短専用ケース';req71.Type__c='振込用紙再送';req71.Subject__c='事由';req71.Reception__c=rec.Id;reqListUpdt.add(req71);
        Request__c req72 =new Request__c();req72.id=reqList[71].id;req72.Class__c='少短専用ケース';req72.Type__c='問合せケース（少短）';req72.Subject__c='事由';req72.Reception__c=rec.Id;reqListUpdt.add(req72);
        //Request__c req73 =new Request__c();req73.id=reqList[72].id;req73.Class__c='少短専用ケース';req73.Type__c='汎用（少短)';req73.Subject__c='事由';req73.Reception__c=rec.Id;reqListUpdt.add(req73);
        Request__c req74 =new Request__c();req74.id=reqList[73].id;req74.Class__c='セールス専用ケース';req74.Type__c='生命_コール資料請求';req74.Subject__c='事由';req74.Reception__c=rec.Id;reqListUpdt.add(req74);
        //Request__c req75 =new Request__c();req75.id=reqList[74].id;req75.Class__c='セールス専用ケース';req75.Type__c='損保_ミドル連携';req75.Subject__c='事由';req75.Reception__c=rec.Id;reqListUpdt.add(req75);
        Request__c req76 =new Request__c();req76.id=reqList[75].id;req76.Class__c='セールス専用ケース';req76.Type__c='少短_コール資料請求';req76.Subject__c='事由';req76.Reception__c=rec.Id;reqListUpdt.add(req76);
        Request__c req77 =new Request__c();req77.id=reqList[76].id;req77.Class__c='セールス専用ケース';req77.Type__c='生命・少短_比較チーム連携';req77.Subject__c='事由';req77.Reception__c=rec.Id;reqListUpdt.add(req77);
        Request__c req78 =new Request__c();req78.id=reqList[77].id;req78.Class__c='セールス専用ケース';req78.Type__c='生命_対面誘導（生命営推本部）';req78.Subject__c='事由';req78.Reception__c=rec.Id;reqListUpdt.add(req78);
        //Request__c req79 =new Request__c();req79.id=reqList[78].id;req79.Class__c='セールス専用ケース';req79.Type__c='信書回収';req79.Subject__c='事由';req79.Reception__c=rec.Id;reqListUpdt.add(req79);
        Request__c req80 =new Request__c();req80.id=reqList[79].id;req80.Class__c='共通ケース';req80.Type__c='住所変更';req80.Subject__c='事由';req80.Reception__c=rec.Id;reqListUpdt.add(req80);
        Request__c req81 =new Request__c();req81.id=reqList[80].id;req81.Class__c='生命代サ専用ケース';req81.Type__c='タブレット・Team Viewer';req81.Subject__c='事由';req81.Reception__c=rec.Id;reqListUpdt.add(req81);
        Request__c req82 =new Request__c();req82.id=reqList[81].id;req82.Class__c='生命代サ専用ケース';req82.Type__c='収納（集金）';req82.Subject__c='事由';req82.Reception__c=rec.Id;reqListUpdt.add(req82);
        Request__c req83 =new Request__c();req83.id=reqList[82].id;req83.Class__c='生命代サ専用ケース';req83.Type__c='新契約';req83.Subject__c='事由';req83.Reception__c=rec.Id;reqListUpdt.add(req83);
        Request__c req84 =new Request__c();req84.id=reqList[83].id;req84.Class__c='生命代サ専用ケース';req84.Type__c='声紋認証';req84.Subject__c='事由';req84.Reception__c=rec.Id;reqListUpdt.add(req84);
        Request__c req85 =new Request__c();req85.id=reqList[84].id;req85.Class__c='生命代サ専用ケース';req85.Type__c='問い合わせケース';req85.Subject__c='事由';req85.Reception__c=rec.Id;reqListUpdt.add(req85);
        Request__c req86 =new Request__c();req86.id=reqList[85].id;req86.Class__c='生命代サ専用ケース';req86.Type__c='Agency Support';req86.Subject__c='事由';req86.Reception__c=rec.Id;reqListUpdt.add(req86);
        Request__c req87 =new Request__c();req87.id=reqList[86].id;req87.Class__c='生命代サ専用ケース';req87.Type__c='ポイントプログラム・楽天ID連携';req87.Subject__c='事由';req87.Reception__c=rec.Id;reqListUpdt.add(req87);
        Request__c req88 =new Request__c();req88.id=reqList[87].id;req88.Class__c='生命代サ専用ケース';req88.Type__c='保全（異動）・照会';req88.Subject__c='事由';req88.Reception__c=rec.Id;reqListUpdt.add(req88);
        Request__c req89 =new Request__c();req89.id=reqList[88].id;req89.Class__c='生命代サ専用ケース';req88.Type__c='フォロー対応';req89.Subject__c='口座不備';req89.Reception__c=rec.Id;reqListUpdt.add(req89);
        Request__c req90 =new Request__c();req90.id=reqList[89].id;req90.Class__c='生命代サ専用ケース';req90.Type__c='フォロー対応';req90.Subject__c='継続フォロー';req90.Reception__c=rec.Id;reqListUpdt.add(req90);
        Request__c req91 =new Request__c();req91.id=reqList[90].id;req91.Class__c='生命代サ専用ケース';req91.Type__c='フォロー対応';req91.Subject__c='お客様対応依頼';req91.Reception__c=rec.Id;reqListUpdt.add(req91);
        return reqListUpdt;
    }
    static List<Request__c> prepareAfterInsertData(){
        SeihoAgencyMaster__c sa = new SeihoAgencyMaster__c();
        sa.agncyno__c='we123';
        insert sa;
        Account a = new Account();
        a.Name='TestName';
        insert a;
        Reception__c rec = new Reception__c();
        rec.Address1__c= 'tst1';
        rec.Account__c=a.id;
        rec.SeihoAgency__c=sa.Id;
        insert rec;
        
            

        List<Request__c> reqList = new List<Request__c>();
         Request__c request1= new Request__c(Class__c='共通ケース',Type__c='住所変更',Subject__c='事由',ChangedPostNumber__c= '100-0000',ChangedPrefecture__c= '東京都',ChangedMunicipality__c='中央区',ChangedAddress1__c='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ChangedBuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request1);
        //Request__c request2= new Request__c(Class__c='生命専用ケース',Type__c='保険金・給付金・共済金請求',Subject__c='事由',ChangedPostNumber__c= '100-0001',ChangedPrefecture__c= '東京都',ChangedMunicipality__c='中央区',ChangedAddress1__c='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ChangedBuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request2);
    Request__c request2= new Request__c(Class__c='生命専用ケース',Type__c='保険金・給付金・共済金請求',Subject__c='事由',MailingPostalCode__c = '100-0001',MailingPrefectures__c = 'test2',MailingCity__c= '中央区',MailingAddress1__c ='１－１０－２００',MailingAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',PresenceeOfDocumentIncluded__c='無');reqList.add(request2);
    Request__c request3= new Request__c(Class__c='損保専用ケース',Type__c='控除証明再発行',Subject__c='事由',DeliveryAddress_zipCode__c = '100-0002',DeliveryAddress_prefecture__c = 'test3',DeliveryAddress_city__c= '中央区',DeliveryAddress_Address1__c ='１－１０－２００',DeliveryAddress_buildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request3);
    Request__c request4= new Request__c(Class__c='損保専用ケース',Type__c='解約（火災）',Subject__c='事由',MailingPostalCode__c = '100-0003',MailingPrefectures__c = 'test4',MailingCity__c= '中央区',MailingAddress1__c ='１－１０－２００',DestinationBuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request4);
    Request__c request5= new Request__c(Class__c='損保専用ケース',Type__c='解約（火災）',Subject__c='事由',Postalcode__c = '100-0004',Prefectures__c = 'test5',City__c= '中央区',Address1__c ='１－１０－２００',BuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request5);
    Request__c request6= new Request__c(Class__c='損保専用ケース',Type__c='解約（ジャンプ・積立・その他）',Subject__c='事由',Postalcode__c = '100-0005',Prefectures__c = 'test6',City__c= '中央区',Address1__c ='１－１０－２００',BuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request6);
    Request__c request7= new Request__c(Class__c='損保専用ケース',Type__c='対象所在地変更（火災・満期戻）',Subject__c='事由',ChangedPostNumber__c = '100-0006',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedBuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request7);
    Request__c request8= new Request__c(Class__c='損保専用ケース',Type__c='全損失効',Subject__c='事由',PostalAddressWhereDocumentsAreSent__c = '100-0007',SendingDocumentsToPrefectures__c = 'test8',CityWhereTheDocumentIsSent__c= '中央区',DocumentAddress1__c ='１－１０－２００',NameOfBuildingToWhichDocumentsAreSent__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request8);
    Request__c request9= new Request__c(Class__c='損保専用ケース',Type__c='質権設定・削除',Subject__c='事由',MailingPostalCode__c = '100-0008',MailingPrefectures__c = 'test9',MailingCity__c= '中央区',MailingAddress1__c ='１－１０－２００',DestinationBuildingName__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request9);
    Request__c request10= new Request__c(Class__c='損保専用ケース',Type__c='被保険者変更',Subject__c='事由',AutoInsuredPostalCodeAfterChange__c = '100-0009',CarPrefectureOfTheInsuredAfterChange__c = 'test10',AutoInsuredCityAfterChange__c= '中央区',AutoInsuredPersonsAddressAfterChange1__c ='１－１０－２００',AutoInsuredBuildingNameAfterChange__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request10);
    Request__c request11= new Request__c(Class__c='損保専用ケース',Type__c='被保険者変更',Subject__c='事由',OtherPostCodeInsuredPersonAfterChange__c = '100-0010',OtherPrefectureOfInsuredAfterChange__c = 'test11',OtherInsuredCityAfterChange__c= '中央区',OtherInsuredPersonAddressAfterChange1__c ='１－１０－２００',OtherInsuredPersonAddressAfterChange2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request11);
    Request__c request12= new Request__c(Class__c='少短専用ケース',Type__c='少短事故受付',Subject__c='事由',ChangedPostNumber__c = '100-0011',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request12);
    Request__c request13= new Request__c(Class__c='少短専用ケース',Type__c='少短事故受付(賠責）',Subject__c='事由',ChangedPostNumber__c = '100-0012',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request13);
    Request__c request14= new Request__c(Class__c='少短専用ケース',Type__c='保険金関連（事故受付以外）',Subject__c='事由',ChangedPostNumber__c = '100-0013',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request14);
    Request__c request15= new Request__c(Class__c='少短専用ケース',Type__c='更新変更',Subject__c='事由',ChangedPostNumber__c = '100-0014',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request15);
    Request__c request16= new Request__c(Class__c='少短専用ケース',Type__c='更新拒否_少短',Subject__c='事由',ChangedPostNumber__c = '100-0015',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request16);
    Request__c request17= new Request__c(Class__c='少短専用ケース',Type__c='解約_少短',Subject__c='事由',ChangedPostNumber__c = '100-0016',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request17);
    Request__c request18= new Request__c(Class__c='少短専用ケース',Type__c='振込用紙再送',Subject__c='事由',ChangedPostNumber__c = '100-0017',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request18);
    Request__c request19= new Request__c(Class__c='少短専用ケース',Type__c='証券類・更新案内再送',Subject__c='事由',ChangedPostNumber__c = '100-0018',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request19);
    Request__c request20= new Request__c(Class__c='少短専用ケース',Type__c='申込内容変更・新規多頭対応',Subject__c='事由',ChangedPostNumber__c = '100-0019',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request20);
    Request__c request21= new Request__c(Class__c='少短専用ケース',Type__c='契約内容変更',Subject__c='事由',ChangedPostNumber__c = '100-0020',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request21);
    Request__c request22= new Request__c(Class__c='少短専用ケース',Type__c='汎用（少短）',Subject__c='事由',ChangedPostNumber__c = '100-0021',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request22);
    Request__c request23= new Request__c(Class__c='生命代サ専用ケース',Type__c='タブレット・Team Viewer',Subject__c='事由',ChangedPostNumber__c = '100-0022',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',TabletOperation__c = TRUE,TabletPolicy__c = TRUE,TabletReserve__c = TRUE,TabletError__c = TRUE,TabletCheck__c = TRUE,TeamViewer__c = TRUE);reqList.add(request23);  
    Request__c request24= new Request__c(Class__c='生命代サ専用ケース',Type__c='収納（集金）',Subject__c='事由',ChangedPostNumber__c = '100-0023',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request24);  
    Request__c request25= new Request__c(Class__c='生命代サ専用ケース',Type__c='新契約',Subject__c='事由',ChangedPostNumber__c = '100-0024',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request25);  
    Request__c request26= new Request__c(Class__c='生命代サ専用ケース',Type__c='声紋認証',Subject__c='事由',ChangedPostNumber__c = '100-0025',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有',Registration__c = TRUE,Busy__c = TRUE,Decline__c = TRUE,Change__c = TRUE,Delete__c = TRUE);reqList.add(request26);  
    Request__c request27= new Request__c(Class__c='生命代サ専用ケース',Type__c='問い合わせケース',Subject__c='事由',ChangedPostNumber__c = '100-0026',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request27);  
    Request__c request28= new Request__c(Class__c='生命代サ専用ケース',Type__c='Agency Support',Subject__c='事由',ChangedPostNumber__c = '100-0027',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request28);  
    Request__c request29= new Request__c(Class__c='生命代サ専用ケース',Type__c='ポイントプログラム・楽天ID連携',Subject__c='事由',ChangedPostNumber__c = '100-0028',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request29);  
    Request__c request30= new Request__c(Class__c='生命代サ専用ケース',Type__c='保全（異動）・照会',Subject__c='事由',ChangedPostNumber__c = '100-0029',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request30);
    Request__c request31= new Request__c(Class__c='生命代サ専用ケース',Type__c='フォロー対応',Subject__c='口座不備',ChangedPostNumber__c = '100-0030',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request31);  
    Request__c request32= new Request__c(Class__c='生命代サ専用ケース',Type__c='フォロー対応',Subject__c='継続フォロー',ChangedPostNumber__c = '100-0030',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request32); 
    Request__c request33= new Request__c(Class__c='生命代サ専用ケース',Type__c='フォロー対応',Subject__c='お客様対応依頼',ChangedPostNumber__c = '100-0030',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request33);      
    Request__c request34= new Request__c(Class__c='損保専用ケース',Type__c='控除証明書再発行',Subject__c='事由',ChangedPostNumber__c = '100-0031',ChangedPrefecture__c = '東京都',ChangedMunicipality__c= '中央区',ChangedAddress1__c ='１－１０－２００',ChangedAddress2__c='７Ｆ、第一ビル',ReflectMailingAddress__c =true,Reception__c=rec.id,ChangeAgencyRegistration__c='無',AGRegistrationChange__c='無',JuniorSpecialContract__c = '有',RecruiterRegistration__c ='有');reqList.add(request34);  
       return reqList;
    }
    
    static testMethod void beforeInsertTest(){
        
        Test.startTest();
        
        List<Request__c> reqList = prepareInsertData();
        insert(reqList);
        
        List<ID> reqListIDs = new List<ID>();
        for (Request__c req : reqList) {
            reqListIDs.add(req.Id);
        }
        
        Map<Id, Request__c> mapReq = new Map<Id, Request__c>([Select ID, recordTypeID, RecordType.Name from Request__c where ID in :reqListIDs]);
        /*for (Request__c req : reqList) {
            if(req.Class__c == '少短専用ケース' && req.Type__c == '解約'){
                System.assertEquals('住所変更', mapReq.get(req.Id).RecordType.Name);
            }else if(req.Class__c == '少短専用ケース' && req.Type__c == 'Retention'){
                System.assertEquals('Retention（少短）', mapReq.get(req.Id).RecordType.Name);
            }else if(req.Type__c == 'Retention'){
                System.assertEquals('Retention（生命）', mapReq.get(req.Id).RecordType.Name);
            } else if(req.Type__c == 'リビングアシスト契約証再発行'){
                System.assertEquals('契約証再発行（SA・LA）', mapReq.get(req.Id).RecordType.Name);
            } else if(req.Type__c == '更新変更_少短'){
                System.assertEquals('更新変更', mapReq.get(req.Id).RecordType.Name);
            }
            else{
                System.assertEquals('少短事故受付（賠責）', mapReq.get(req.Id).RecordType.Name);
            }
        }*/
        
        Test.stopTest();
    }
    static testMethod void beforeUpdateTest(){
        
        Test.startTest();
        
        List<Request__c> reqList = prepareInsertData();
        insert reqList;
        
        List<Request__c> reqListUpdt = reqList;        
        system.debug('request reqListUpdt'+reqListUpdt);
        update reqListUpdt;
        
        List<ID> reqUptListIDs = new List<ID>();       
        for (Request__c req : reqListUpdt) {
            reqUptListIDs.add(req.Id);
            
        }
             
        
        Test.stopTest();
         Map<Id, Request__c> mapReq = new Map<Id, Request__c>([Select ID, recordTypeID, RecordType.Name from Request__c where ID in :reqUptListIDs]);
        for (Request__c req : reqList) {
            /*if(req.Class__c == '少短専用ケース' && req.Type__c == '解約'){
                System.assertEquals('住所変更', mapReq.get(req.Id).RecordType.Name);
            }else if(req.Class__c == '少短専用ケース' && req.Type__c == 'Retention'){
                System.assertEquals('Retention（少短）', mapReq.get(req.Id).RecordType.Name);
            }else if(req.Type__c == 'Retention'){
                System.assertEquals('Retention（生命）', mapReq.get(req.Id).RecordType.Name);
            } else if(req.Type__c == 'リビングアシスト契約証再発行'){
                System.assertEquals('契約証再発行（SA・LA）', mapReq.get(req.Id).RecordType.Name);
            } else if(req.Type__c == '更新変更_少短'){
                System.assertEquals('更新変更', mapReq.get(req.Id).RecordType.Name);
            }
            else{
                System.assertEquals('少短事故受付（賠責）', mapReq.get(req.Id).RecordType.Name);
            }*/
        }
    }
    static testMethod void updateMethod(){
        Test.startTest();
        Account a = new Account();
        a.Name='TestName';
        insert a;
        Reception__c rec = new Reception__c();
        rec.Address1__c= 'tst1';
        rec.Account__c=a.id;
        insert rec;
        Request__c request1 = new Request__c();
        request1.Reception__c=rec.Id; 
        request1.Registration__c=true;
        request1.Class__c='共通ケース';
        request1.Type__c='住所変更';
        request1.Subject__c='住所変更';
        request1.Status__c='CC完了';
        request1.RequestStatusComment__c='Testing';
        request1.Priority__c='中';
        request1.Name='TestK';
        request1.JuniorSpecialContract__c='有';
        request1.AGRegistrationChange__c='有';
        request1.ChangeAgencyRegistration__c='有';
        request1.RecruiterRegistration__c='有';
             
        insert request1;
        Account a1 = new Account();
        a1.Name='TestName1';
        insert a1;
        Reception__c rec1 = new Reception__c();
        rec1.Address1__c= 'tst2';
        rec1.Account__c=a.id;
        insert rec1;
        request1.Reception__c=rec1.Id;
        update request1;
        Test.stopTest();
        
    }
    static testMethod void afterInsertTest(){
              
        Test.startTest();
        List<Request__c> reqList = prepareAfterInsertData();
        insert(reqList);                       
        Test.stopTest();
        
        for(Reception__c rec : [Select id,Address1__c From Reception__c]){
            System.assertEquals('１－１０－２００',rec.Address1__c);
        }
    }
     static testMethod void afterUpdateTest(){
              
        Test.startTest();
        
        List<Request__c> reqListToInsert = new List<Request__c>();
        List<Request__c> reqListToUpdate = new List<Request__c>();
        
        List<Request__c> reqList = prepareAfterInsertData();  
        for(Request__c req : reqList) {
            req.ReflectMailingAddress__c  = false;
            reqListToInsert.add(req);
        }   
        insert reqListToInsert;  
        
        for(Request__c req : reqListToInsert){
            req.ReflectMailingAddress__c  = true;
            reqListToUpdate.add(req);
        }        
        update reqListToUpdate;
        
        Test.stopTest();
        
        for(Reception__c rec : [Select id,Address1__c From Reception__c]){
            System.assertEquals('１－１０－２００',rec.Address1__c);
        }
    }
    
    //RIPCRM-142 改修テスト1（登録時 Null）
    static testMethod void ripcrm142_insert01(){
        Test.startTest();
        commonTestReceptionCreate();
        Reception__c rec = [Select id, Account__c From Reception__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        Request__c req = new Request__c();
        req.Account__c = rec.Account__c;
        req.Reception__c = rec.Id;
        req.Class__c='共通ケース';
        req.Type__c='改姓（名義変更）';
        req.Subject__c='改姓（名義変更）';
        req.OverviewOfInquirySeimei__c='バーチャル口座（月遅れ）';
        insert req;
        Test.stopTest();
        
        //結果確認
        Request__c result = new Request__c();
        result = [Select id
                        ,RequestDetails__c
                        ,RequestDetails255__c
                        ,DetailsOfOtherRequests__c
                        ,DetailsOfOtherRequests255__c
                        ,AccidentContents__c
                        ,AccidentContents255__c
                        ,Notices__c
                        ,Notices255__c
                  From Request__c
                  Where Account__r.LastName = 'CommonAccount' Limit 1];
        System.assertEquals(Null, result.RequestDetails__c);
        System.assertEquals(Null, result.RequestDetails255__c);
        System.assertEquals(Null, result.DetailsOfOtherRequests__c);
        System.assertEquals(Null, result.DetailsOfOtherRequests255__c);
        System.assertEquals(Null, result.AccidentContents__c);
        System.assertEquals(Null, result.AccidentContents255__c);
        System.assertEquals(Null, result.Notices__c);
        System.assertEquals(Null, result.Notices255__c);
    }
    
    //RIPCRM-142 改修テスト2（登録時 255文字以下）
    static testMethod void ripcrm142_insert02(){
        Test.startTest();
        commonTestReceptionCreate();
        Reception__c rec = [Select id, Account__c From Reception__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        Request__c req = new Request__c();
        req.Account__c = rec.Account__c;
        req.Reception__c = rec.Id;
        req.Class__c='共通ケース';
        req.Type__c='改姓（名義変更）';
        req.Subject__c='改姓（名義変更）';
        req.RequestDetails__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.DetailsOfOtherRequests__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.AccidentContents__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.Notices__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.OverviewOfInquirySompo__c='契約内容照会';
        insert req;
        Test.stopTest();
        
        //結果確認
        Request__c result = new Request__c();
        result = [Select id
                        ,RequestDetails__c
                        ,RequestDetails255__c
                        ,DetailsOfOtherRequests__c
                        ,DetailsOfOtherRequests255__c
                        ,AccidentContents__c
                        ,AccidentContents255__c
                        ,Notices__c
                        ,Notices255__c
                  From Request__c
                  Where Account__r.LastName = 'CommonAccount' Limit 1];
        System.assertEquals(255, result.RequestDetails__c.length());
        System.assertEquals(255, result.DetailsOfOtherRequests__c.length());
        System.assertEquals(255, result.AccidentContents__c.length());
//      System.assertEquals(result.RequestDetails__c, result.RequestDetails255__c);
        System.assertEquals(result.DetailsOfOtherRequests__c, result.DetailsOfOtherRequests255__c);
        System.assertEquals(result.AccidentContents__c, result.AccidentContents255__c);
        System.assertEquals(result.Notices__c, result.Notices255__c);
    }
    
    //RIPCRM-142 改修テスト3（登録時 256文字以上）
    static testMethod void ripcrm142_insert03(){
        Test.startTest();
        commonTestReceptionCreate();
        Reception__c rec = [Select id, Account__c From Reception__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        Request__c req = new Request__c();
        req.Account__c = rec.Account__c;
        req.Reception__c = rec.Id;
        req.Class__c='共通ケース';
        req.Type__c='改姓（名義変更）';
        req.Subject__c='改姓（名義変更）';
        req.RequestDetails__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        req.DetailsOfOtherRequests__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        req.AccidentContents__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        req.Notices__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        req.InquirySummaryShortTermInsurance__c='申込進捗確認';
        insert req;
        Test.stopTest();
        
        //結果確認
        Request__c result = new Request__c();
        result = [Select id
                        ,RequestDetails__c
                        ,RequestDetails255__c
                        ,DetailsOfOtherRequests__c
                        ,DetailsOfOtherRequests255__c
                        ,AccidentContents__c
                        ,AccidentContents255__c
                        ,Notices__c
                        ,Notices255__c
                  From Request__c
                  Where Account__r.LastName = 'CommonAccount' Limit 1];
        System.assertEquals(256, result.RequestDetails__c.length());
        System.assertEquals(256, result.DetailsOfOtherRequests__c.length());
        System.assertEquals(256, result.AccidentContents__c.length());
//      System.assertEquals(result.RequestDetails__c.substring(0, 255), result.RequestDetails255__c);
        System.assertEquals(result.DetailsOfOtherRequests__c.substring(0, 255), result.DetailsOfOtherRequests255__c);
        System.assertEquals(result.AccidentContents__c.substring(0, 255), result.AccidentContents255__c);
        System.assertEquals(result.Notices__c.substring(0, 255), result.Notices255__c);
    }
    
    //RIPCRM-142 改修テスト4（更新時 Any⇒Null）
    static testMethod void ripcrm142_insert04(){
        Test.startTest();
        commonTestReceptionCreate();
        Reception__c rec = [Select id, Account__c From Reception__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        Request__c req = new Request__c();
        req.Account__c = rec.Account__c;
        req.Reception__c = rec.Id;
        req.Class__c='共通ケース';
        req.Type__c='改姓（名義変更）';
        req.Subject__c='改姓（名義変更）';
        req.RequestDetails__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.DetailsOfOtherRequests__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.AccidentContents__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.Notices__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        req.OverviewOfInquirySeimei__c='バーチャル口座（月遅れ）';
        req.TelAcceptCompnDate__c=Null;
        insert req;
        
        Request__c updtReq = new Request__c();
        updtReq = [Select id, RequestDetails__c, DetailsOfOtherRequests__c, AccidentContents__c From Request__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        updtReq.RequestDetails__c = Null;
        updtReq.DetailsOfOtherRequests__c = Null;
        updtReq.AccidentContents__c = Null;
        updtReq.Notices__c = Null;
        updtReq.OverviewOfInquiry__c=req.OverviewOfInquirySeimei__c;
        updtReq.TelAcceptCompnDate__c= datetime.now();
        update updtReq;
        
        Test.stopTest();
        
        //結果確認
        Request__c result = new Request__c();
        result = [Select id
                        ,RequestDetails__c
                        ,RequestDetails255__c
                        ,DetailsOfOtherRequests__c
                        ,DetailsOfOtherRequests255__c
                        ,AccidentContents__c
                        ,AccidentContents255__c
                        ,Notices__c
                        ,Notices255__c
                  From Request__c
                  Where Account__r.LastName = 'CommonAccount' Limit 1];
        System.assertEquals(Null, result.RequestDetails__c);
        System.assertEquals(Null, result.RequestDetails255__c);
        System.assertEquals(Null, result.DetailsOfOtherRequests__c);
        System.assertEquals(Null, result.DetailsOfOtherRequests255__c);
        System.assertEquals(Null, result.AccidentContents__c);
        System.assertEquals(Null, result.AccidentContents255__c);
        System.assertEquals(Null, result.Notices255__c);
    }
    
    //RIPCRM-142 改修テスト5（更新時 Any⇒255文字以下）
    static testMethod void ripcrm142_insert05(){
        Test.startTest();
        commonTestReceptionCreate();
        Reception__c rec = [Select id, Account__c From Reception__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        Request__c req = new Request__c();
        req.Account__c = rec.Account__c;
        req.Reception__c = rec.Id;
        req.Class__c='共通ケース';
        req.Type__c='改姓（名義変更）';
        req.Subject__c='改姓（名義変更）';
        req.RequestDetails__c = '12345';
        req.DetailsOfOtherRequests__c = '12345';
        req.AccidentContents__c = '12345';
        req.Notices__c = '12345';
        req.OverviewOfInquirySompo__c='契約内容照会';
        req.TelAcceptCompnDate__c=Null;
        insert req;
        
        Request__c updtReq = new Request__c();
        updtReq = [Select id, RequestDetails__c, DetailsOfOtherRequests__c, AccidentContents__c From Request__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        updtReq.RequestDetails__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        updtReq.DetailsOfOtherRequests__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        updtReq.AccidentContents__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        updtReq.Notices__c = '123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345';
        updtReq.OverviewOfInquiry__c=req.OverviewOfInquirySompo__c;
        updtReq.TelAcceptCompnDate__c= datetime.now();
        update updtReq;
        
        Test.stopTest();
        
        //結果確認
        Request__c result = new Request__c();
        result = [Select id
                        ,RequestDetails__c
                        ,RequestDetails255__c
                        ,DetailsOfOtherRequests__c
                        ,DetailsOfOtherRequests255__c
                        ,AccidentContents__c
                        ,AccidentContents255__c
                        ,Notices__c
                        ,Notices255__c
                  From Request__c
                  Where Account__r.LastName = 'CommonAccount' Limit 1];
        System.assertEquals(255, result.RequestDetails__c.length());
        System.assertEquals(255, result.DetailsOfOtherRequests__c.length());
        System.assertEquals(255, result.AccidentContents__c.length());
        System.assertEquals(result.RequestDetails__c, result.RequestDetails255__c);
        System.assertEquals(result.DetailsOfOtherRequests__c, result.DetailsOfOtherRequests255__c);
        System.assertEquals(result.AccidentContents__c, result.AccidentContents255__c);
        System.assertEquals(result.Notices__c, result.Notices255__c);
    }
    
    //RIPCRM-142 改修テスト6（更新時 Any⇒255文字以上）
    static testMethod void ripcrm142_insert06(){
        Test.startTest();
        commonTestReceptionCreate();
        Reception__c rec = [Select id, Account__c From Reception__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        Request__c req = new Request__c();
        req.Account__c = rec.Account__c;
        req.Reception__c = rec.Id;
        req.Class__c='共通ケース';
        req.Type__c='改姓（名義変更）';
        req.Subject__c='改姓（名義変更）';
        req.RequestDetails__c = '12345';
        req.DetailsOfOtherRequests__c = '12345';
        req.AccidentContents__c = '12345';
        req.Notices__c = '12345';
        req.InquirySummaryShortTermInsurance__c='申込進捗確認';
        req.TelAcceptCompnDate__c=Null;
        insert req;
        
        Request__c updtReq = new Request__c();
        updtReq = [Select id, RequestDetails__c, DetailsOfOtherRequests__c, AccidentContents__c From Request__c Where Account__r.LastName = 'CommonAccount' Limit 1];
        updtReq.RequestDetails__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        updtReq.DetailsOfOtherRequests__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        updtReq.AccidentContents__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        updtReq.Notices__c = '1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456';
        updtReq.OverviewOfInquiry__c=req.InquirySummaryShortTermInsurance__c;
        updtReq.TelAcceptCompnDate__c= Datetime.now();
        update updtReq;
        
        Test.stopTest();
        
        //結果確認
        Request__c result = new Request__c();
        result = [Select id
                        ,RequestDetails__c
                        ,RequestDetails255__c
                        ,DetailsOfOtherRequests__c
                        ,DetailsOfOtherRequests255__c
                        ,AccidentContents__c
                        ,AccidentContents255__c
                        ,Notices__c
                        ,Notices255__c
                  From Request__c
                  Where Account__r.LastName = 'CommonAccount' Limit 1];
        System.assertEquals(256, result.RequestDetails__c.length());
        System.assertEquals(256, result.DetailsOfOtherRequests__c.length());
        System.assertEquals(256, result.AccidentContents__c.length());
        System.assertEquals(result.RequestDetails__c.substring(0, 255), result.RequestDetails255__c);
        System.assertEquals(result.DetailsOfOtherRequests__c.substring(0, 255), result.DetailsOfOtherRequests255__c);
        System.assertEquals(result.AccidentContents__c.substring(0, 255), result.AccidentContents255__c);
        System.assertEquals(result.Notices__c.substring(0, 255), result.Notices255__c);
    }
    
    //テストデータ作成共通メソッド
    static void commonTestReceptionCreate(){
        RecordType personAccountRecordType = [SELECT Id FROM RecordType WHERE Name = '個人取引先' and SObjectType = 'Account'];
        Account acc= new Account();
        acc.LastName = 'CommonAccount';
        acc.PersonMailingPostalCode = '123-4567';
        acc.PersonMailingState = 'TOKYO-TO';
        acc.PersonMailingCity = 'CHUO-KU';
        acc.PersonMailingStreet = '1-5-389';
        acc.RecordType = personAccountRecordType;
        insert acc;
        
        Reception__c rec = new Reception__c();
        rec.Account__c = acc.id;
        rec.Description__c = '12345';
        
        insert rec;
    }
}