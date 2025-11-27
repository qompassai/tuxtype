<!-- /qompassai/tuxtype/README.md -->
<!-- ---------------------------- -->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->

<h2> TuxType: For Teaching typing quality typing skills </h2>

<h3> Qompass AI on TuxType </h3>

![Repository Views](https://komarev.com/ghpvc/?username=qompassai-tuxtype)
![GitHub all releases](https://img.shields.io/github/downloads/qompassai/tuxtype/total?style=flat-square)

  <a href="https://tux4kids.alioth.debian.org/tuxtype/">
  <img src="https://img.shields.io/badge/TuxType-typing%20game-blue?style=for-the-badge&logo=gnu&logoColor=white" alt="TuxType">
</a>
<br>
<a href="https://tux4kids.alioth.debian.org/tuxtype/">
  <img src="https://img.shields.io/badge/TuxType_Documentation-blue?style=flat-square" alt="TuxType Documentation">
</a>
<a href="https://www.typing.com/student/lessons">
  <img src="https://img.shields.io/badge/Typing_Tutorials-green?style=flat-square" alt="Typing Tutorials">
</a>
<a href="https://www.keybr.com/">
  <img src="https://img.shields.io/badge/Typing_Practice-orange?style=flat-square" alt="Typing Practice">
</a>
<br>
  <a href="https://www.gnu.org/licenses/agpl-3.0"><img src="https://img.shields.io/badge/License-AGPL%20v3-blue.svg" alt="License: AGPL v3"></a>
  <a href="./LICENSE-QCDA"><img src="https://img.shields.io/badge/license-Q--CDA-lightgrey.svg" alt="License: Q-CDA"></a>
</p>

<details>
  <summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;">
    <strong> Qompass AI Quick Start</strong>
  </summary>
  <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace;">

```bash
bash <(curl -L https://raw.githubusercontent.com/qompassai/tuxtype/main/scripts/quickstart.sh)
```
  </div>
    <details>
      <summary style="font-size: 1em; font-weight: bold; padding: 10px; background: #e9ecef; color: #333; border-radius: 5px; cursor: pointer; margin: 10px 0;">
        <strong>📄 We advise you read the script BEFORE running it 😉</strong>
      </summary>
      <pre style="background: #fff; padding: 15px; border-radius: 5px; border: 1px solid #ddd; overflow-x: auto;">
#!/usr/bin/env bash

REPO="https://github.com/qompassai/dotfiles"
TARGET_DIR="$HOME/.local/bin/tuxtype"
if [ -d "$TARGET_DIR" ]; then
    echo "Removing existing dotfiles directory..."
    rm -rf "$TARGET_DIR"
fi
echo "Cloning Qompass AI Dotfiles..."
git clone "$REPO" "$TARGET_DIR"
echo "Setting up symlinks..."
mkdir -p "$HOME/.config/nix" "$HOME/.profile.d"
ln -sf "$TARGET_DIR/.config/nix/nix.conf" "$HOME/.config/nix/nix.conf"
ln -sf "$TARGET_DIR/.profile.d/67-nix.sh" "$HOME/.profile.d/67-nix.sh"
mkdir -p "$HOME/.config"
ln -sfn "$TARGET_DIR/home" "$HOME/.config/home" 2>/dev/null || true
ln -sfn "$TARGET_DIR/.local" "$HOME/.local" 2>/dev/null || true
ln -sf "$TARGET_DIR/flake.nix" "$HOME/.config/flake.nix" 2>/dev/null || true
source "$HOME/.profile.d/67-nix.sh" 2>/dev/null || {
    echo "WARNING: Could not source Nix profile configuration. Falling back to manual exporting"
    export NIX_CONF_DIR="$HOME/.config/nix"
    export NIX_STORE_DIR="$HOME/.nix/store"
    export NIX_STATE_DIR="$HOME/.local/state/nix"
    export NIX_LOG_DIR="$HOME/.local/state/nix/log"
    export NIX_PROFILE_DIR="$HOME/.nix-profile"
    export PATH="$NIX_PROFILE_DIR/bin:$PATH"
}
if ! command -v nix >/dev/null; then
    chown -R "$(whoami)" /.nix
    sh <(curl -L https://nixos.org/nix/install) --daemon \
        --nix-extra-conf-file "$NIX_CONF_DIR/nix.conf"
    if [ -f '/.nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/.nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
fi
echo "Setting up Nix environment..."
cd "$TARGET_DIR"
nix flake update
detect_shell() {
    case "$(ps -p $$ -o comm=)" in
        *bash*) echo "bash" ;;
        *zsh*)  echo "zsh" ;;
        *fish*) echo "fish" ;;
        *)      echo "bash" ;;
    esac
}
USER_SHELL=$(detect_shell)
echo "Detected shell: $USER_SHELL"
nix develop --command "$USER_SHELL"
      </pre>
    </details>
    <p>Or, <a href="https://github.com/qompassai/tuxtype/blob/main/scripts/quickstart.sh" target="_blank">View the quickstart script</a>.</p>
  </blockquote>
</details>

</blockquote>

<div align="center">
  <p>Matthew A. Porter<br>
  Former Intelligence Officer<br>
  Educator & Learner<br>
  DeepTech Founder & CEO</p>
</div>

<h3>Publications</h3>
  <p>
    <a href="https://orcid.org/0000-0002-0302-4812">
      <img src="https://img.shields.io/badge/ORCID-0000--0002--0302--4812-green?style=flat-square&logo=orcid" alt="ORCID">
    </a>
    </a>
    <a href="https://zenodo.org/communities/qompassai">
      <img src="https://img.shields.io/badge/Zenodo-Publications-blue?style=flat-square&logo=zenodo" alt="Zenodo">
    </a>
  </p>

<h3>Developer Programs</h3>

[![HackerOne](https://img.shields.io/badge/-HackerOne-%23494649?style=for-the-badge\&logo=hackerone\&logoColor=white)](https://hackerone.com/phaedrusflow)
[![HuggingFace](https://img.shields.io/badge/HuggingFace-qompass-yellow?style=flat-square\&logo=huggingface)](https://huggingface.co/qompass)
  <p>
    <a href="https://www.linkedin.com/in/matt-a-porter-103535224/">
      <img src="https://img.shields.io/badge/LinkedIn-Matt--Porter-blue?style=flat-square&logo=linkedin" alt="Personal LinkedIn">
    </a>
    <a href="https://www.linkedin.com/company/95058568/">
      <img src="https://img.shields.io/badge/LinkedIn-Qompass--AI-blue?style=flat-square&logo=linkedin" alt="Startup LinkedIn">
    </a>
  </p>

<h3>Social Media</h3>
  <p>
    <a href="https://twitter.com/PhaedrusFlow">
      <img src="https://img.shields.io/badge/Twitter-@PhaedrusFlow-blue?style=flat-square&logo=twitter" alt="X/Twitter">
    </a>
    </a>
    <a href="https://www.youtube.com/@qompassai">
      <img src="https://img.shields.io/badge/YouTube-QompassAI-red?style=flat-square&logo=youtube" alt="Qompass AI YouTube">
    </a>
  </p>

</blockquote>
</details>

<details>

<tr>
<th align="center">🏛️ Qompass AI Pre-Seed Funding 2023-2025</th>
<th align="center">🏆 Amount</th>
<th align="center">📅 Date</th>
</tr>
<tr>
<td><a href="https://github.com/qompassai/r4r" title="RJOS/Zimmer Biomet Research Grant Repository">RJOS/Zimmer Biomet Research Grant</a></td>
<td align="center">$30,000</td>
<td align="center">March 2024</td>
</tr>
<tr>
<td><a href="https://github.com/qompassai/PathFinders" title="GitHub Repository">Pathfinders Intern Program</a><br>
<td align="center">$2,000</td>
<td align="center">October 2024</td>
</tr>
</table>

<br>
<h4>🤝 How To Support Our Mission</h4>

[![Patreon](https://img.shields.io/badge/Patreon-Support-F96854?style=for-the-badge\&logo=patreon\&logoColor=white)](https://patreon.com/qompassai)
[![Liberapay](https://img.shields.io/badge/Liberapay-Donate-F6C915?style=for-the-badge\&logo=liberapay\&logoColor=black)](https://liberapay.com/qompassai)

<details markdown="1">
<summary><strong>🔐 Cryptocurrency Donations</strong></summary>

**Monero (XMR):**

<div align="center">
  <img src="./assets/monero-qr.png" alt="Monero QR Code" width="180">
</div>

<div style="margin: 10px 0;">
    <code>42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH</code>
  </div>

    📋 Copy Address
  </button>
<p><i>Funding helps us continue our research at the intersection of AI, healthcare, and education</i></p>

</blockquote>
</details>
</details>

<details id="FAQ">
  <summary><strong>Frequently Asked Questions</strong></summary>

### Q: How do you mitigate against bias?

**TLDR - we do math to make AI ethically useful**


### AI Math at a glance

## Forward Propagation Algorithm

$$
y = w_1x_1 + w_2x_2 + ... + w_nx_n + b
$$

Where:

- $y$ represents the model output
- $(x_1, x_2, ..., x_n)$ are input features
- $(w_1, w_2, ..., w_n)$ are feature weights
- $b$ is the bias term

$$
z = \\sum\_{i=1}^{n} w_ix_i + b

Where:

### Attention Mechanism- aka what makes the Transformer (The "T" in ChatGPT) powerful

- [Attention High level overview video](https://www.youtube.com/watch?v=fjJOgb-E41w)
The Attention mechanism equation is:

$$

- $Q$ represents the Query matrix
- $K$ represents the Key matrix
- $V$ represents the Value matrix
- $d_k$ is the dimension of the key vectors
- $\\text{softmax}(\\cdot)$ normalizes scores to sum to 1

- Windows users can use Windows Subsystem for Linux [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
- Mac users can use [Homebrew](https://brew.sh/)
- The code-base instructions were developed with both beginners and advanced users in mind.


- [Huggingface](https://docs.google.com/presentation/d/1IkzESdOwdmwvPxIELYJi8--K3EZ98_cL6c5ZcLKSyVg/edit#slide=id.p)

</details>

<details id="Dual-License Notice">
### Protection for Vulnerable Populations

### Preventing Malicious Use

The AGPL-3.0 license ensures that any modifications to the software remain open source, preventing bad actors from creating closed-source variants that could be used for
 exploitation. This is especially crucial given the rising threats to vulnerable communities, including children in educational settings. The attack on Minneapolis Publi
c Schools, which resulted in the leak of 300,000 files and a $1 million ransom demand, highlights the importance of transparency and security<sup><a href="#ref8">[8]</a>
</sup>.

### Addressing Cybersecurity in Critical Sectors

The commercial license option allows for tailored solutions in critical sectors such as healthcare, which has seen significant impacts from cyberattacks. For example, th
e recent Change Healthcare attack<sup><a href="#ref4">[4]</a></sup> affected millions of Americans and caused widespread disruption for hospitals and other providers. In
 January 2025, CISA<sup><a href="#ref2">[2]</a></sup> and FDA<sup><a href="#ref3">[3]</a></sup> jointly warned of critical backdoor vulnerabilities in Contec CMS8000 pat
ient monitors, revealing how medical devices could be compromised for unauthorized remote access and patient data manipulation.

### Supporting Cybersecurity Awareness

The dual licensing model supports initiatives like the Cybersecurity and Infrastructure Security Agency (CISA) efforts to improve cybersecurity awareness<sup><a href="#r
ef7">[7]</a></sup> in "target rich" sectors, including K-12 education<sup><a href="#ref5">[5]</a></sup>. By allowing both open-source and commercial use, we aim to facil
itate the development of tools that support these critical awareness and protection efforts.

### Bridging the Digital Divide

The unfortunate reality is that too many individuals and organizations have gone into a frenzy in every facet of our daily lives<sup><a href="#ref6">[6]</a></sup>. These
 unfortunate folks identify themselves with their talk of "10X" returns and building towards Artificial General Intelligence aka "AGI" while offering GPT wrappers. Our d
ual licensing approach aims to acknowledge this deeply concerning predatory paradigm with clear eyes while still operating to bring the best parts of the open-source com
munity with our services and solutions.

### Recent Cybersecurity Attacks

Recent attacks underscore the importance of robust cybersecurity measures:

- The Change Healthcare cyberattack in February 2024 affected millions of Americans and caused significant disruption to healthcare providers.
- The White House and Congress jointly designated October 2024 as Cybersecurity Awareness Month. This designation comes with over 100 actions that align the Federal gove
rnment and public/private sector partners are taking to help every man, woman, and child to safely navigate the age of AI.
                                                                                                                                                       335,13        92%
By offering both open source and commercial licensing options, we strive to create a balance that promotes innovation and accessibility. We address the complex cybersecu
rity challenges faced by vulnerable populations and critical infrastructure sectors as the foundation of our solutions, not an afterthought.

### References

<div id="footnotes">
<p id="ref1"><strong>[1]</strong> <a href="https://www.whitehouse.gov/briefing-room/statements-releases/2024/10/02/international-counter-ransomware-initiative-2024-joint
-statement/">International Counter Ransomware Initiative 2024 Joint Statement</a></p>

<p id="ref2"><strong>[2]</strong> <a href="https://www.cisa.gov/sites/default/files/2025-01/fact-sheet-contec-cms8000-contains-a-backdoor-508c.pdf">Contec CMS8000 Contai
ns a Backdoor</a></p>

<p id="ref3"><strong>[3]</strong> <a href="https://www.aha.org/news/headline/2025-01-31-cisa-fda-warn-vulnerabilities-contec-patient-monitors">CISA, FDA warn of vulnerab
ilities in Contec patient monitors</a></p>

<p id="ref4"><strong>[4]</strong> <a href="https://www.chiefhealthcareexecutive.com/view/the-top-10-health-data-breaches-of-the-first-half-of-2024">The Top 10 Health Dat
a Breaches of the First Half of 2024</a></p>

<p id="ref5"><strong>[5]</strong> <a href="https://www.cisa.gov/K12Cybersecurity">CISA's K-12 Cybersecurity Initiatives</a></p>

<p id="ref6"><strong>[6]</strong> <a href="https://www.ftc.gov/business-guidance/blog/2024/09/operation-ai-comply-continuing-crackdown-overpromises-ai-related-lies">Fede
ral Trade Commission Operation AI Comply: continuing the crackdown on overpromises and AI-related lies</a></p>

<p id="ref7"><strong>[7]</strong> <a href="https://www.whitehouse.gov/briefing-room/presidential-actions/2024/09/30/a-proclamation-on-cybersecurity-awareness-month-2024/">A Proclamation on Cybersecurity Awareness Month, 2024</a></p>

<p id="ref8"><strong>[8]</strong> <a href="https://therecord.media/minneapolis-schools-say-data-breach-affected-100000/">Minneapolis school district says data breach affected more than 100,000 people</a></p>
</div>
</details>
