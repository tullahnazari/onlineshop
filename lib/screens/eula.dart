import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;

class EULA extends StatelessWidget {
  const EULA({Key key}) : super(key: key);

  static const routeName = '/eula';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('User Terms and Conditions'),
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Html(
              data: """
    <h2>End-User License Agreement (EULA) of <span class="app_name">Halal Bazaar</span></h2>

<p>This End-User License Agreement ("EULA") is a legal agreement between you and <span class="company_name">Affordable Apps</span></p>

<p>This EULA agreement governs your acquisition and use of our <span class="app_name">Halal Bazaar</span> software ("Software") directly from <span class="company_name">Affordable Apps</span> or indirectly through a <span class="company_name">Affordable Apps</span> authorized reseller or distributor (a "Reseller").</p>

<p>Please read this EULA agreement carefully before completing the installation process and using the <span class="app_name">Halal Bazaar</span> software. It provides a license to use the <span class="app_name">Halal Bazaar</span> software and contains warranty information and liability disclaimers.</p>

<p>If you register for a free trial of the <span class="app_name">Halal Bazaar</span> software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the <span class="app_name">Halal Bazaar</span> software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.</p>

<p>If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.</p>

<p>This EULA agreement shall apply only to the Software supplied by <span class="company_name">Affordable Apps</span> herewith regardless of whether other software is referred to or described herein. The terms also apply to any <span class="company_name">Affordable Apps</span> updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply</span>.

<h3>License Grant</h3>

<p><span class="company_name">Affordable Apps</span> hereby grants you a personal, non-transferable, non-exclusive licence to use the <span class="app_name">Halal Bazaar</span> software on your devices in accordance with the terms of this EULA agreement.</p>

<p>You are permitted to load the <span class="app_name">Halal Bazaar</span> software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the <span class="app_name">Halal Bazaar</span> software.</p>

<p>You are not permitted to:</p>

<ul>
<li>Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things</li>
<li>Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose</li>
<li>Allow any third party to use the Software on behalf of or for the benefit of any third party</li>
<li>Use the Software in any way which breaches any applicable local, national or international law</li>
<li>use the Software for any purpose that <span class="company_name">Affordable Apps</span> considers is a breach of this EULA agreement</li>
</ul>

<h3>Acceptable Use Policy</h3>

<p>You are personally responsible for your use of Services and Software, and while using Services and Software you must conduct yourself in a lawful and respectful manner in accordance with our rules of conduct below. We may temporarily or permanently ban users who violate these rules, or who abuse email communications, support communications, or the community purpose of any message board areas, as determined by us and our developer partners, in our sole discretion. We and our developer partners reserve the right to disable a player’s ability to upload profile photos or edit their username at any time.</p>

<ul>
<li>Profanity, obscenities, or the use of **asterisks** or other “masking” characters to disguise such words, is not permitted.</li>
<li>You may not use or upload obscene, lewd, slanderous, pornographic, abusive, violent, insulting, indecent, threatening and harassing language of any kind, as determined by us in our sole discretion.</li>
<li>You may not commit fraud with regard to any Service.</li>
<li>You may not attempt to impersonate or deceive another user for the purposes of illicitly obtaining cards, passwords, account information etc. (aka “scamming”).</li>
</ul>

<p>Cheating, Fraud, and Abuse. In accessing or participating in Services or using the Software, you represent and warrant to us and our developer partners that you will not engage in any activity that interrupts or attempts to interrupt the operation of the Services or Software. Anyone who engages in, participates in or displays behavior that may be interpreted, in the discretion of us and our developer partners only, as unfair methods in participating in Services or using the Software, including but not limited to, the opening and/or use of multiple accounts.</p>

<h3>Intellectual Property and Ownership</h3>

<p><span class="company_name">Affordable Apps</span> shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of <span class="company_name">Affordable Apps</span>.</p>

<p><span class="company_name">Affordable Apps</span> reserves the right to grant licences to use the Software to third parties.</p>

<h3>Termination</h3>

<p>This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to <span class="company_name">Affordable Apps</span>.</p>

<p>It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.</p>

<h3>Governing Law</h3>

<p>This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of <span class="country">us</span>.</p>
  """,
            ),
          ),
        ),
      ),
    );
  }
}
