#!/bin/bash
#
# Regenerates every HTML page in this site from the shared header/footer
# and the per-page bodies below.
#
# The generated pages ARE checked in — Netlify serves them directly and
# needs no build step. This script only exists so a change to the nav or
# the footer does not have to be repeated twelve times by hand.
#
#   ./_tools/build.sh      # rewrites the .html files in place
#
# Edit page content HERE, not in the generated .html, or the next run
# will overwrite it.
#
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE_URL="https://migratewp.org"

# page <outfile> <title> <description> <canonical-path> <nav-key>   ; body on stdin
page() {
  local out="$1" title="$2" desc="$3" path="$4" active="$5"
  local body; body="$(cat)"
  mkdir -p "$(dirname "$ROOT/$out")"

  aria() { [ "$1" = "$active" ] && printf ' aria-current="page"'; }

  cat > "$ROOT/$out" <<HTMLEOF
<!DOCTYPE html>
<html lang="en-GB">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${title}</title>
<meta name="description" content="${desc}">
<link rel="canonical" href="${SITE_URL}${path}">
<meta property="og:type" content="website">
<meta property="og:site_name" content="MigrateWP">
<meta property="og:title" content="${title}">
<meta property="og:description" content="${desc}">
<meta property="og:url" content="${SITE_URL}${path}">
<meta name="twitter:card" content="summary">
<link rel="icon" href="/assets/img/favicon.png" type="image/png">
<link rel="stylesheet" href="/assets/css/style.css">
<script>
/* Apply the saved theme before first paint to avoid a flash. */
(function(){try{var t=localStorage.getItem('mwp-theme');if(t==='dark'||t==='light'){document.documentElement.setAttribute('data-theme',t);}}catch(e){}})();
</script>
</head>
<body>
<a class="skip-link" href="#main">Skip to content</a>

<header class="site-header">
  <div class="wrap">
    <a class="brand" href="/" aria-label="MigrateWP — home">
      <img class="logo-light" src="/assets/img/logo.png" alt="MigrateWP" width="545" height="128">
      <img class="logo-dark" src="/assets/img/logo-dark.png" alt="MigrateWP" width="545" height="128">
    </a>

    <button id="nav-toggle" class="icon-btn" type="button" aria-expanded="false" aria-controls="primary-nav" aria-label="Toggle navigation">
      <svg viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M3 5h14M3 10h14M3 15h14" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
    </button>

    <nav id="primary-nav" class="nav" aria-label="Primary">
      <a href="/docs/"$(aria docs)>Docs</a>
      <a href="/releases/"$(aria releases)>Releases</a>
      <a href="/roadmap/"$(aria roadmap)>Roadmap</a>
      <a class="nav-cta" href="https://github.com/Tartan-Web-Design/migrateWP/releases" rel="noopener">Download</a>
    </nav>

    <button id="theme-toggle" class="icon-btn" type="button" aria-label="Switch to dark theme">
      <svg class="icon-sun" viewBox="0 0 20 20" fill="none" aria-hidden="true"><circle cx="10" cy="10" r="3.6" stroke="currentColor" stroke-width="1.7"/><path d="M10 1.6v2M10 16.4v2M18.4 10h-2M3.6 10h-2M15.9 4.1l-1.4 1.4M5.5 14.5l-1.4 1.4M15.9 15.9l-1.4-1.4M5.5 5.5L4.1 4.1" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/></svg>
      <svg class="icon-moon" viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M16.5 12.4A7 7 0 017.6 3.5a7 7 0 108.9 8.9z" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round"/></svg>
    </button>
  </div>
</header>

<main id="main">
${body}
</main>

<footer class="site-footer">
  <div class="wrap">
    <div class="footer-grid">
      <div>
        <a class="brand" href="/" aria-label="MigrateWP — home">
          <img class="logo-light" src="/assets/img/logo.png" alt="MigrateWP" width="545" height="128">
          <img class="logo-dark" src="/assets/img/logo-dark.png" alt="MigrateWP" width="545" height="128">
        </a>
        <p class="footer-blurb">Command line WordPress migration for developers. Free and open source under the GPLv2.</p>
      </div>
      <div>
        <h2>Documentation</h2>
        <ul>
          <li><a href="/docs/getting-started/">Getting started</a></li>
          <li><a href="/docs/configuration/">Configuration</a></li>
          <li><a href="/docs/commands/">Command reference</a></li>
          <li><a href="/docs/requirements/">Requirements</a></li>
        </ul>
      </div>
      <div>
        <h2>Project</h2>
        <ul>
          <li><a href="/releases/">Releases</a></li>
          <li><a href="/roadmap/">Roadmap</a></li>
          <li><a href="https://github.com/Tartan-Web-Design/migrateWP" rel="noopener">Source on GitHub</a></li>
          <li><a href="https://github.com/Tartan-Web-Design/migrateWP/issues" rel="noopener">Report an issue</a></li>
        </ul>
      </div>
      <div>
        <h2>More</h2>
        <ul>
          <li><a href="/privacy-policy/">Privacy policy</a></li>
          <li><a href="https://tartanwebdesign.net" rel="noopener">Tartan Web Design</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-base">
      <p style="margin:0">&copy; 2021&ndash;2026 Tartan Web Design. MigrateWP is released under the <a href="https://github.com/Tartan-Web-Design/migrateWP/blob/master/LICENSE" rel="noopener">GPLv2</a>.</p>
    </div>
  </div>
</footer>

<script src="/assets/js/main.js" defer></script>
</body>
</html>
HTMLEOF
  echo "wrote site/$out"
}

# ---------------------------------------------------------------- home
page "index.html" \
  "MigrateWP — WordPress migration from the command line" \
  "MigrateWP is a free, open source command line tool that pushes, pulls and rolls back WordPress sites between a macOS Local environment and a Linux server with a single command." \
  "/" "home" <<'BODY'
<section class="hero">
  <div class="wrap hero-grid">
    <div>
      <p class="eyebrow">Free &amp; open source &middot; GPLv2</p>
      <h1>Migrate WordPress without leaving the command line</h1>
      <p class="lede">MigrateWP pushes, pulls and rolls back your WordPress sites between a macOS <a href="https://localwp.com" rel="noopener">Local</a> environment and a Linux server &mdash; with a single terminal command.</p>
      <div class="hero-actions">
        <a class="btn btn-primary" href="https://github.com/Tartan-Web-Design/migrateWP/releases" rel="noopener">
          <svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true"><path d="M8 1a.75.75 0 01.75.75v6.44l2.22-2.22a.75.75 0 111.06 1.06l-3.5 3.5a.75.75 0 01-1.06 0l-3.5-3.5a.75.75 0 111.06-1.06l2.22 2.22V1.75A.75.75 0 018 1zM2.75 12a.75.75 0 01.75.75v.75h9v-.75a.75.75 0 011.5 0v1.5a.75.75 0 01-.75.75h-10.5a.75.75 0 01-.75-.75v-1.5A.75.75 0 012.75 12z"/></svg>
          Download v1.1
        </a>
        <a class="btn btn-ghost" href="/docs/getting-started/">Read the docs</a>
      </div>
      <p class="hero-note">macOS local &middot; Linux remote &middot; rsync and WP-CLI under the hood</p>
    </div>

    <div class="terminal">
      <div class="terminal-bar"><i></i><i></i><i></i><span>zsh &mdash; mwp</span></div>
      <pre><code><span class="p">$ </span>mwp push mysite

<span class="c">#######################################</span>
<span class="c">#    Starting Pre-Migration Checks    #</span>
<span class="c">#######################################</span>

mysite.local running.
Local directory found.
SSH access verified.
Remote directory found.

Backing up remote site files.
Backup complete: ./wp-content_bak
Backing up remote site database

<span class="c">#######################################</span>
<span class="c">#         Starting Migration          #</span>
<span class="c">#######################################</span>

<span class="k">sending incremental file list</span>
wp-content/uploads/2021/09/hero.jpg
wp-content/themes/mysite/style.css

<span class="ok">Success: Made 34 replacements.</span>

<span class="c">#######################################</span>
<span class="c">#         Migration Complete          #</span>
<span class="c">#######################################</span>
</code></pre>
    </div>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="stats">
      <div class="stat"><b>95%</b><span>Faster pushes &mdash; only changed files move</span></div>
      <div class="stat"><b>4</b><span>Commands: push, pull, rollback, report</span></div>
      <div class="stat"><b>1</b><span>Config file, and you are set up</span></div>
      <div class="stat"><b>0</b><span>Logins &mdash; no wp-admin, no dashboards</span></div>
    </div>
  </div>
</section>

<section class="section section-panel">
  <div class="wrap">
    <div class="section-head">
      <h2>Why use MigrateWP?</h2>
      <p>MigrateWP was built for WordPress developers who are comfortable working on the command line. It is most useful for freelancers and agencies who manage multiple WordPress sites.</p>
    </div>

    <div class="grid grid-4">
      <div class="card">
        <div class="card-icon"><svg viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M11 2L4 11h5l-1 7 7-9h-5l1-7z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></svg></div>
        <h3>It&rsquo;s fast</h3>
        <p>MigrateWP only transfers files that have changed, reducing the time it takes to migrate a site by as much as 95%.</p>
      </div>
      <div class="card">
        <div class="card-icon"><svg viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M3 5.5h14M3 10h14M3 14.5h9" stroke="currentColor" stroke-width="1.7" stroke-linecap="round"/></svg></div>
        <h3>It&rsquo;s effortless</h3>
        <p>Migrate your WordPress sites without logging in to them. Open the terminal, run a single command. That&rsquo;s it.</p>
      </div>
      <div class="card">
        <div class="card-icon"><svg viewBox="0 0 20 20" fill="none" aria-hidden="true"><path d="M10 2.5l6 2.2v5c0 3.6-2.4 6.4-6 7.8-3.6-1.4-6-4.2-6-7.8v-5l6-2.2z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/></svg></div>
        <h3>It&rsquo;s robust</h3>
        <p>Rollback lets you undo a migration if something goes wrong. Search and replace runs through WP-CLI, so array serialisation is handled correctly.</p>
      </div>
      <div class="card">
        <div class="card-icon"><svg viewBox="0 0 20 20" fill="none" aria-hidden="true"><circle cx="7" cy="7" r="2.6" stroke="currentColor" stroke-width="1.6"/><circle cx="14" cy="13.5" r="2.6" stroke="currentColor" stroke-width="1.6"/><path d="M8.9 8.7l3.6 3.6" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/></svg></div>
        <h3>It&rsquo;s collaborative</h3>
        <p>The changelog records every migration to and from a remote site, giving teams visibility and reducing the chance of conflicts.</p>
      </div>
    </div>
  </div>
</section>

<section class="section">
  <div class="wrap">
    <div class="section-head">
      <h2>Four commands. That&rsquo;s the whole interface.</h2>
      <p>Every command takes the site name you gave it in <code>migratewp.conf</code>.</p>
    </div>

    <div class="grid grid-2">
      <div class="card cmd-card">
        <code>mwp push sitename</code>
        <h3>Push</h3>
        <p>Migrates a site from your local machine to the remote server. The remote files and database are backed up first.</p>
      </div>
      <div class="card cmd-card">
        <code>mwp pull sitename</code>
        <h3>Pull</h3>
        <p>Migrates a site from the remote server to your local machine, backing up your local copy before it starts.</p>
      </div>
      <div class="card cmd-card">
        <code>mwp rollback sitename</code>
        <h3>Rollback</h3>
        <p>Undoes the last push or pull, restoring the files and database from the backup taken at migration time.</p>
      </div>
      <div class="card cmd-card">
        <code>mwp report sitename</code>
        <h3>Report</h3>
        <p>Prints the migration history for a site, so the whole team can see who moved what, and when.</p>
      </div>
    </div>

    <p style="margin-top:1.6rem"><a href="/docs/commands/">Full command reference &rarr;</a></p>
  </div>
</section>

<section class="section section-panel">
  <div class="wrap">
    <div class="section-head">
      <h2>Up and running in three steps</h2>
      <p>No plugin to install, nothing to add to the WordPress site itself.</p>
    </div>

    <div class="grid grid-3 steps">
      <div>
        <h3>1. Download it</h3>
        <p>Grab the latest release and <code>cd</code> into the folder that holds it.</p>
        <div class="code"><pre><code><span class="c"># from the release folder</span>
<span class="p">$ </span>ls
migratewp.sh  migratewp.conf</code></pre></div>
      </div>
      <div>
        <h3>2. Alias it</h3>
        <p>Add an alias so <code>mwp</code> works from anywhere.</p>
        <div class="code"><pre><code><span class="p">$ </span>echo 'alias mwp="bash ~/mwp/migratewp.sh"' &gt;&gt; ~/.zshrc
<span class="p">$ </span>exec zsh</code></pre></div>
      </div>
      <div>
        <h3>3. Configure it</h3>
        <p>Describe each site once in <code>migratewp.conf</code>, then migrate it forever.</p>
        <div class="code"><pre><code><span class="p">$ </span>mwp push mysite</code></pre></div>
      </div>
    </div>

    <p style="margin-top:1.6rem"><a href="/docs/getting-started/">The full setup guide &rarr;</a></p>
  </div>
</section>

<section class="section cta-band">
  <div class="wrap">
    <h2>Get MigrateWP</h2>
    <p>Free, open source, and about 1,000 lines of Bash you can read end to end before you trust it with a production site.</p>
    <div class="hero-actions">
      <a class="btn btn-primary" href="https://github.com/Tartan-Web-Design/migrateWP/releases" rel="noopener">Download the latest release</a>
      <a class="btn btn-ghost" href="https://github.com/Tartan-Web-Design/migrateWP" rel="noopener">View the source</a>
    </div>
  </div>
</section>
BODY

# docpage <outfile> <title> <desc> <path> <dockey> <h1> <standfirst> ; prose on stdin
docpage() {
  local out="$1" title="$2" desc="$3" path="$4" dockey="$5" h1="$6" stand="$7"
  local prose; prose="$(cat)"
  d() { [ "$1" = "$dockey" ] && printf ' aria-current="page"'; }

  page "$out" "$title" "$desc" "$path" "docs" <<INNEREOF
<div class="page-head">
  <div class="wrap">
    <p class="breadcrumb"><a href="/">Home</a><span>/</span><a href="/docs/">Docs</a><span>/</span>${h1}</p>
    <h1>${h1}</h1>
    <p>${stand}</p>
  </div>
</div>

<div class="wrap docs-layout">
  <nav class="docs-nav" aria-label="Documentation">
    <h2>Documentation</h2>
    <ul>
      <li><a href="/docs/"$(d index)>Overview</a></li>
      <li><a href="/docs/getting-started/"$(d getting-started)>Getting started</a></li>
      <li><a href="/docs/configuration/"$(d configuration)>Configuration</a></li>
      <li><a href="/docs/commands/"$(d commands)>Command reference</a></li>
      <li><a href="/docs/requirements/"$(d requirements)>Requirements</a></li>
    </ul>
    <h2>Project</h2>
    <ul>
      <li><a href="/releases/">Releases</a></li>
      <li><a href="/roadmap/">Roadmap</a></li>
      <li><a href="https://github.com/Tartan-Web-Design/migrateWP" rel="noopener">GitHub</a></li>
    </ul>
  </nav>

  <article class="prose">
${prose}
  </article>
</div>
INNEREOF
}

# ------------------------------------------------------------ docs index
docpage "docs/index.html" \
  "Documentation — MigrateWP" \
  "How to install, configure and use MigrateWP to push, pull and roll back WordPress sites from the command line." \
  "/docs/" "index" "Documentation" \
  "Everything you need to install MigrateWP, describe your sites once, and migrate them with a single command." <<'BODY'
<div class="grid grid-2" style="margin-bottom:2rem">
  <a class="card" href="/docs/getting-started/">
    <h3>Getting started &rarr;</h3>
    <p>Download MigrateWP, create the <code>mwp</code> alias, set up SSH access and run your first migration.</p>
  </a>
  <a class="card" href="/docs/configuration/">
    <h3>Configuration &rarr;</h3>
    <p>Every setting in <code>migratewp.conf</code>, what it means and where to find the value.</p>
  </a>
  <a class="card" href="/docs/commands/">
    <h3>Command reference &rarr;</h3>
    <p><code>push</code>, <code>pull</code>, <code>rollback</code> and <code>report</code>, plus the flags each one accepts.</p>
  </a>
  <a class="card" href="/docs/requirements/">
    <h3>Requirements &rarr;</h3>
    <p>What has to be installed on your Mac and on the remote Linux server before you start.</p>
  </a>
</div>

<h2>How MigrateWP works</h2>

<p>MigrateWP is a single Bash script. It does not install anything into WordPress, it has no plugin, and it never asks you to log in to either site. Instead it drives tools you already have:</p>

<ul>
  <li><strong>rsync</strong> copies <code>wp-content</code> between the two machines, transferring only the files that differ.</li>
  <li><strong>WP-CLI</strong> exports the database, imports it at the other end, and runs the search and replace on the site URL &mdash; so serialised arrays survive the trip intact.</li>
  <li><strong>SSH</strong> carries everything, using the key you have already given the server.</li>
</ul>

<p>Before it moves anything, MigrateWP runs a set of pre-flight checks: that the local site is up, that both directories exist, that WP-CLI is on your path, and that the SSH user can actually log in. If any of those fail it stops before touching your data.</p>

<p>It then takes a backup of whichever side it is about to overwrite &mdash; files to <code>wp-content_bak</code>, and a dump of the database &mdash; which is what makes <a href="/docs/commands/#rollback">rollback</a> possible.</p>

<h2>A note on direction</h2>

<p>MigrateWP is built around one clear mental model: your Mac is the development environment, the Linux server is the remote. <code>push</code> always means local &rarr; remote, <code>pull</code> always means remote &rarr; local. There is no ambiguity about which way the data went, and the changelog records each move.</p>

<div class="note">
  <p><strong>New here?</strong> Start with <a href="/docs/requirements/">Requirements</a> to check your machines are ready, then work through <a href="/docs/getting-started/">Getting started</a>.</p>
</div>
BODY

# --------------------------------------------------------- getting started
docpage "docs/getting-started/index.html" \
  "Getting started — MigrateWP" \
  "Download MigrateWP, create the mwp alias, configure your sites and set up SSH access, then run your first WordPress migration." \
  "/docs/getting-started/" "getting-started" "Getting started" \
  "Four short steps: download the script, alias it, describe your sites, and give it SSH access." <<'BODY'
<h2>1. Download the latest release</h2>

<p>Releases are published on GitHub:</p>

<p><a class="btn btn-primary" href="https://github.com/Tartan-Web-Design/migrateWP/releases" rel="noopener">github.com/Tartan-Web-Design/migrateWP/releases</a></p>

<p>Unpack it somewhere sensible &mdash; anywhere you are happy to keep a script and its config file. Then open Terminal and <code>cd</code> into that folder.</p>

<div class="code"><pre><code><span class="p">$ </span>cd ~/mwp
<span class="p">$ </span>ls
LICENSE  README.md  migratewp.conf  migratewp.sh</code></pre></div>

<h2>2. Create the <code>mwp</code> alias</h2>

<p>MigrateWP is easier to live with behind a short alias. Add one to your shell profile, using the real path to the script:</p>

<div class="code"><pre><code><span class="p">$ </span>echo 'alias mwp="bash /Users/username/yourfolder/migratewp.sh"' &gt;&gt; ~/.zshrc</code></pre></div>

<p>Then restart your terminal session so the alias is picked up:</p>

<div class="code"><pre><code><span class="p">$ </span>exec zsh</code></pre></div>

<div class="note">
  <p><strong>On an older Mac?</strong> If your shell is Bash rather than Zsh, append the alias to <code>~/.bash_profile</code> instead and run <code>exec bash</code>.</p>
</div>

<p>From here on, <code>mwp</code> stands in for <code>bash migratewp.sh</code>. Everything below assumes the alias is in place.</p>

<h2>3. Describe your sites in <code>migratewp.conf</code></h2>

<p>MigrateWP reads its settings from <code>migratewp.conf</code>, which sits next to the script. Each site is one <code>case</code> block. A two-site config looks like this:</p>

<div class="code"><pre><code><span class="c">#! /bin/bash</span>

logUserName="yourNameHere"

case $site in

    site1name)
        sshUser="username@8.8.8.8"

        remoteURL="example.com"
        remotePath="/var/www/vhosts/example.com/httpdocs/wp-content/"
        localURL="example.local"
        localPath="/Users/Scott/Local Sites/example/app/public/wp-content/"

    ;;

    site2name)
        sshUser="sshUser@8.8.8.8"

        remoteURL="site2.org"
        remotePath="/var/www/vhosts/site2.org/httpdocs/wp-content/"
        localURL="site2.local"
        localPath="/Users/Scott/Local Sites/site2/app/public/wp-content/"

    ;;

  *)
      usage
      exit
    ;;

  esac</code></pre></div>

<p>In short:</p>

<ul>
  <li>Put your own name in <code>logUserName</code>. It is used to label the migrations that come from your machine in the changelog.</li>
  <li>Replace <code>site1name</code> with the name you want to type on the command line for that site.</li>
  <li>Set <code>sshUser</code> to a user with permissions over the folder holding the WordPress installation.</li>
  <li>Fill in the <code>wp-content</code> paths and site URLs for both ends.</li>
</ul>

<p>Every option is covered in detail on the <a href="/docs/configuration/">Configuration</a> page.</p>

<div class="note warn">
  <p><strong>Keep the fallback.</strong> Leave the <code>*)</code> block at the end of the <code>case</code> statement in place. It is what prints the usage message when you mistype a site name, instead of MigrateWP running against empty paths.</p>
</div>

<h2>4. Set up SSH access</h2>

<p>MigrateWP reaches the remote server several times during a migration, so it is worth adding your key to the SSH account rather than typing a password at each step.</p>

<p>Copy your public key:</p>

<div class="code"><pre><code><span class="p">$ </span>cat ~/.ssh/id_rsa.pub</code></pre></div>

<p>Then add it to the server. On Plesk:</p>

<ol>
  <li>Install the <strong>SSH Keys Manager</strong> Plesk extension.</li>
  <li>Paste the public key into the Plesk SSH keys page for the site, at <em>Subscriptions &rarr; sitename &rarr; SSH Keys</em>.</li>
  <li>Set <em>Access to the server over SSH</em> to <code>/bin/sh</code>, at <em>Subscriptions &rarr; sitename &rarr; Connection Info &rarr; Manage access</em>.</li>
</ol>

<p>The SSH user for a Plesk site is the system user for that webspace, which you will find under <em>Subscriptions &rarr; sitename &rarr; Connection Info</em>.</p>

<div class="note">
  <p><strong>No separate SSH subdomain needed.</strong> On Plesk at least, the SSH credentials are the same as those for the main domain.</p>
</div>

<h2>5. Run your first migration</h2>

<p>Start your Local site so the local database is running, then push:</p>

<div class="code"><pre><code><span class="p">$ </span>mwp push mysite</code></pre></div>

<p>MigrateWP will run its pre-flight checks, back up the remote files and database, sync <code>wp-content</code>, move the database across and run the search and replace on the site URL. If a check fails it stops before changing anything.</p>

<p>To confirm what happened, ask for the site's history:</p>

<div class="code"><pre><code><span class="p">$ </span>mwp report mysite</code></pre></div>

<p>And if the migration turned out to be a mistake:</p>

<div class="code"><pre><code><span class="p">$ </span>mwp rollback mysite</code></pre></div>

<div class="next-prev">
  <span><a href="/docs/requirements/">&larr; Requirements</a></span>
  <span><a href="/docs/configuration/">Configuration &rarr;</a></span>
</div>
BODY

# ------------------------------------------------------------ configuration
docpage "docs/configuration/index.html" \
  "Configuration — MigrateWP" \
  "A reference for every setting in migratewp.conf: logUserName, sshUser, remoteURL, remotePath, localURL and localPath." \
  "/docs/configuration/" "configuration" "Configuration" \
  "MigrateWP has one config file. Describe each site once, and you never type a path again." <<'BODY'
<h2>Where the config lives</h2>

<p><code>migratewp.conf</code> sits in the same folder as <code>migratewp.sh</code>, and the script sources it at the start of a run. It is a Bash file containing a single <code>case</code> statement keyed on the site name you type on the command line.</p>

<h2>Settings</h2>

<div class="table-scroll">
<table>
  <thead>
    <tr><th>Setting</th><th>Scope</th><th>What it is</th></tr>
  </thead>
  <tbody>
    <tr>
      <td><code>logUserName</code></td>
      <td>Global</td>
      <td>Your name, used to label entries in the migration changelog so a team can see who moved what.</td>
    </tr>
    <tr>
      <td><code>sshUser</code></td>
      <td>Per site</td>
      <td>The SSH user and host for the remote server, in <code>user@host</code> form, e.g. <code>username@8.8.8.8</code>. The user needs permissions over the folder holding the WordPress installation. On Plesk this is the system user for the webspace.</td>
    </tr>
    <tr>
      <td><code>remoteURL</code></td>
      <td>Per site</td>
      <td>The live site's domain, e.g. <code>example.com</code>. Used as one half of the WP-CLI search and replace.</td>
    </tr>
    <tr>
      <td><code>remotePath</code></td>
      <td>Per site</td>
      <td>Absolute path to <code>wp-content</code> on the server, e.g. <code>/var/www/vhosts/example.com/httpdocs/wp-content/</code>.</td>
    </tr>
    <tr>
      <td><code>localURL</code></td>
      <td>Per site</td>
      <td>The domain your Local site answers on, e.g. <code>example.local</code>.</td>
    </tr>
    <tr>
      <td><code>localPath</code></td>
      <td>Per site</td>
      <td>Absolute path to <code>wp-content</code> on your Mac, e.g. <code>/Users/Scott/Local Sites/example/app/public/wp-content/</code>.</td>
    </tr>
  </tbody>
</table>
</div>

<div class="note">
  <p><strong>Trailing slashes are handled for you.</strong> If <code>remotePath</code> or <code>localPath</code> is missing its trailing slash, MigrateWP adds one before running rsync.</p>
</div>

<h2>Adding a site</h2>

<p>Copy an existing block, change the name and the six values, and keep it above the <code>*)</code> fallback:</p>

<div class="code"><pre><code>    clientsite)
        sshUser="clientsite@203.0.113.10"

        remoteURL="clientsite.co.uk"
        remotePath="/var/www/vhosts/clientsite.co.uk/httpdocs/wp-content/"
        localURL="clientsite.local"
        localPath="/Users/Scott/Local Sites/clientsite/app/public/wp-content/"

    ;;</code></pre></div>

<p>From then on the site is addressed by that name:</p>

<div class="code"><pre><code><span class="p">$ </span>mwp push clientsite
<span class="p">$ </span>mwp pull clientsite
<span class="p">$ </span>mwp report clientsite</code></pre></div>

<h2>Paths with spaces</h2>

<p>Local's default site folder lives under <code>~/Local Sites/</code>, which contains a space. Keep the value in double quotes exactly as the sample config does and MigrateWP handles it correctly.</p>

<h2>Keeping the config out of version control</h2>

<p><code>migratewp.conf</code> holds server addresses and usernames for every site you manage. If you keep your copy of MigrateWP in a repository, add the config to <code>.gitignore</code> and keep the sample file as the thing that gets committed.</p>

<div class="code"><pre><code><span class="c"># .gitignore</span>
migratewp.conf
mwp.log</code></pre></div>

<div class="next-prev">
  <span><a href="/docs/getting-started/">&larr; Getting started</a></span>
  <span><a href="/docs/commands/">Command reference &rarr;</a></span>
</div>
BODY

# --------------------------------------------------------------- commands
docpage "docs/commands/index.html" \
  "Command reference — MigrateWP" \
  "Reference for the MigrateWP commands push, pull, rollback and report, and the -f, -d and -h flags." \
  "/docs/commands/" "commands" "Command reference" \
  "Four commands and three flags. Each command takes the site name you set in migratewp.conf." <<'BODY'
<h2>Syntax</h2>

<div class="code"><pre><code>mwp [flag] &lt;push|pull|rollback|report&gt; &lt;sitename&gt;</code></pre></div>

<p>Without the alias, that is <code>bash migratewp.sh [flag] &lt;action&gt; &lt;sitename&gt;</code>. Run <code>mwp</code> with no arguments, or with an action it does not recognise, and it prints the usage message.</p>

<h2 id="push">Push</h2>

<p>Migrates a site from your local machine to the remote server.</p>

<div class="code"><pre><code><span class="p">$ </span>mwp push mysite</code></pre></div>

<p>What happens, in order:</p>

<ol>
  <li><strong>Pre-flight checks.</strong> Local site running, local directory present, WP-CLI available, SSH login working, remote directory present.</li>
  <li><strong>Backup.</strong> The remote <code>wp-content</code> is copied to <code>wp-content_bak</code> on the server, and the remote database is dumped.</li>
  <li><strong>Sync.</strong> rsync copies the changed files from your Mac to the server.</li>
  <li><strong>Database.</strong> The local database is exported, moved across, imported, and WP-CLI runs a search and replace from <code>localURL</code> to <code>remoteURL</code>.</li>
  <li><strong>Log.</strong> The migration is written to the site's changelog against your <code>logUserName</code>.</li>
</ol>

<h2 id="pull">Pull</h2>

<p>Migrates a site from the remote server to your local machine.</p>

<div class="code"><pre><code><span class="p">$ </span>mwp pull mysite</code></pre></div>

<p>The same sequence in reverse: your <em>local</em> <code>wp-content</code> is backed up to <code>wp-content_bak</code> and your local database is exported to <code>db_bak.sql</code> before anything is overwritten, then the remote files and database come down and the URL is replaced with <code>localURL</code>.</p>

<div class="note warn">
  <p><strong>Pull overwrites your local site.</strong> That is the point of it &mdash; but if you have local work in <code>wp-content</code> that is not committed anywhere, it lives only in <code>wp-content_bak</code> after a pull.</p>
</div>

<h2 id="rollback">Rollback</h2>

<p>Undoes a migration, restoring from the backup taken when it ran.</p>

<div class="code"><pre><code><span class="p">$ </span>mwp rollback mysite</code></pre></div>

<p>MigrateWP asks which migration you want to roll back to before it does anything, then restores the files from <code>wp-content_bak</code> and reimports the database dump. The rollback is itself recorded in the changelog, so the history stays honest.</p>

<h2 id="report">Report</h2>

<p>Prints the migration history for a site.</p>

<div class="code"><pre><code><span class="p">$ </span>mwp report mysite</code></pre></div>

<p>The changelog (<code>mwp.log</code>) is kept alongside <code>wp-content</code> on the remote server, so every developer's pushes and pulls land in the same file. <code>report</code> fetches it over SSH and prints it. If a site has never been migrated, it reports that no report is available.</p>

<h2>Flags</h2>

<div class="table-scroll">
<table>
  <thead>
    <tr><th>Flag</th><th>Meaning</th></tr>
  </thead>
  <tbody>
    <tr>
      <td><code>-f</code></td>
      <td>Full run &mdash; take backups, then migrate. This is also what happens when you pass no flag at all, so <code>mwp push mysite</code> and <code>mwp -f push mysite</code> do the same thing.</td>
    </tr>
    <tr>
      <td><code>-d</code></td>
      <td>Dry run. Reserved for the rsync dry run that reports what a migration <em>would</em> change. Not yet enabled &mdash; see the <a href="/roadmap/">roadmap</a>.</td>
    </tr>
    <tr>
      <td><code>-h</code>, <code>-?</code></td>
      <td>Print the usage message and exit.</td>
    </tr>
  </tbody>
</table>
</div>

<div class="code"><pre><code><span class="p">$ </span>mwp -h
Usage: bash migratewp.sh -d [&lt;pull|push|rollback|report&gt;] [Sitename]</code></pre></div>

<h2>What gets left behind</h2>

<div class="table-scroll">
<table>
  <thead>
    <tr><th>File</th><th>Where</th><th>What it is</th></tr>
  </thead>
  <tbody>
    <tr><td><code>wp-content_bak</code></td><td>Beside <code>wp-content</code>, on whichever side was overwritten</td><td>The file backup rollback restores from.</td></tr>
    <tr><td><code>db_bak.sql</code></td><td>Local WordPress root, after a pull</td><td>The database backup rollback restores from.</td></tr>
    <tr><td><code>mwp.log</code></td><td>Beside <code>wp-content</code> on the remote server</td><td>The shared changelog <code>report</code> reads.</td></tr>
  </tbody>
</table>
</div>

<div class="next-prev">
  <span><a href="/docs/configuration/">&larr; Configuration</a></span>
  <span><a href="/docs/requirements/">Requirements &rarr;</a></span>
</div>
BODY

# ----------------------------------------------------------- requirements
docpage "docs/requirements/index.html" \
  "Requirements — MigrateWP" \
  "System requirements and dependencies for MigrateWP: macOS locally, Linux remotely, WP-CLI 2.4.0 and rsync 2.6.9 on both ends." \
  "/docs/requirements/" "requirements" "Requirements" \
  "MigrateWP drives tools you probably already have. Here is the short list to check before your first run." <<'BODY'
<h2>System requirements</h2>

<div class="table-scroll">
<table>
  <thead><tr><th>Machine</th><th>Requirement</th></tr></thead>
  <tbody>
    <tr><td>Local</td><td>macOS, running your WordPress site under <a href="https://localwp.com" rel="noopener">Local</a></td></tr>
    <tr><td>Remote</td><td>Linux, with the WordPress site served from a path you can reach over SSH</td></tr>
  </tbody>
</table>
</div>

<h2>Dependencies</h2>

<h3>On your Mac</h3>

<ul>
  <li><strong>WP-CLI 2.4.0</strong> or later, aliased to <code>wp</code></li>
  <li><strong>rsync 2.6.9</strong> or later</li>
</ul>

<h3>On the remote server</h3>

<ul>
  <li>An <strong>SSH user</strong> with permissions over the WordPress installation folder</li>
  <li><strong>WP-CLI 2.4.0</strong> or later</li>
  <li><strong>rsync 2.6.9</strong> or later</li>
</ul>

<h2>Checking what you have</h2>

<div class="code"><pre><code><span class="p">$ </span>wp --info
<span class="p">$ </span>rsync --version
<span class="p">$ </span>ssh username@8.8.8.8 'wp --info; rsync --version'</code></pre></div>

<p>MigrateWP checks for WP-CLI itself at the start of every run. If it cannot find it, it stops and prints the install steps rather than failing halfway through a migration.</p>

<h2>Installing WP-CLI</h2>

<p>If <code>wp</code> is missing, the canonical instructions are at <a href="https://wp-cli.org/" rel="noopener">wp-cli.org</a>. The short version:</p>

<div class="code"><pre><code><span class="p">$ </span>curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
<span class="p">$ </span>php wp-cli.phar --info
<span class="p">$ </span>chmod +x wp-cli.phar
<span class="p">$ </span>sudo mv wp-cli.phar /usr/local/bin/wp
<span class="p">$ </span>wp --info</code></pre></div>

<h2>MySQL on the local machine</h2>

<p>MigrateWP works out which MySQL socket your Local site is using and puts the MySQL binaries on the path if they are not there already, so in most cases there is nothing for you to do. If <code>wp db</code> commands fail outside MigrateWP too, that is the thing to fix first.</p>

<div class="next-prev">
  <span><a href="/docs/commands/">&larr; Command reference</a></span>
  <span><a href="/docs/getting-started/">Getting started &rarr;</a></span>
</div>
BODY

# --------------------------------------------------------------- releases
page "releases/index.html" \
  "Releases — MigrateWP" \
  "Release history for MigrateWP, the command line WordPress migration tool from Tartan Web Design." \
  "/releases/" "releases" <<'BODY'
<div class="page-head">
  <div class="wrap">
    <p class="breadcrumb"><a href="/">Home</a><span>/</span>Releases</p>
    <h1>Releases</h1>
    <p>Every published version of MigrateWP. Downloads are hosted on GitHub.</p>
  </div>
</div>

<div class="wrap" style="padding:clamp(2rem,4vw,3rem) 0 4.5rem">
  <div style="max-width:52rem">

    <article class="release">
      <div class="release-head">
        <h2>MigrateWP 1.1</h2>
        <span class="tag">Latest</span>
        <time datetime="2021-09-10">10 September 2021</time>
      </div>
      <p>The current release.</p>
      <ul>
        <li>Adds a <strong>changelog</strong> of migrations to and from each site. Its contents can be displayed using the new <code>report</code> command.</li>
        <li><strong>Comments</strong> can now be added during migrations and rollbacks, and are saved to the site&rsquo;s changelog.</li>
        <li>Rollback moves into a <strong>separate <code>rollback</code> command</strong> &mdash; user testing suggested this improved usability.</li>
        <li><strong>Root access is no longer required.</strong> MigrateWP now works on any Plesk server you can SSH into.</li>
      </ul>
      <p>
        <a class="btn btn-ghost" href="https://github.com/Tartan-Web-Design/migrateWP/releases/tag/v1.1" rel="noopener">Download 1.1</a>
      </p>
    </article>

    <article class="release">
      <div class="release-head">
        <h2>MigrateWP 1.0</h2>
        <span class="tag tag-muted">Initial release</span>
        <time datetime="2021-08-31">31 August 2021</time>
      </div>
      <!-- TODO: paste the 1.0 release notes from the old WordPress site here. -->
      <p>The first public release: <code>push</code>, <code>pull</code> and <code>report</code>, driven by rsync and WP-CLI over SSH, with backups taken before every migration.</p>
      <p>
        <a class="btn btn-ghost" href="https://github.com/Tartan-Web-Design/migrateWP/releases/tag/v1.0" rel="noopener">Download 1.0</a>
      </p>
    </article>

    <div class="note">
      <p><strong>Watching for new releases?</strong> Every version is published on <a href="https://github.com/Tartan-Web-Design/migrateWP/releases" rel="noopener">the GitHub releases page</a> &mdash; watch the repository to be notified.</p>
    </div>

  </div>
</div>
BODY

# ---------------------------------------------------------------- roadmap
page "roadmap/index.html" \
  "Roadmap — MigrateWP" \
  "What is planned next for MigrateWP, the command line WordPress migration tool." \
  "/roadmap/" "roadmap" <<'BODY'
<div class="page-head">
  <div class="wrap">
    <p class="breadcrumb"><a href="/">Home</a><span>/</span>Roadmap</p>
    <h1>Roadmap</h1>
    <p>Where MigrateWP is going next. Suggestions are welcome &mdash; open an issue on GitHub.</p>
  </div>
</div>

<div class="wrap" style="padding:clamp(2rem,4vw,3rem) 0 4.5rem">
  <div style="max-width:52rem">

    <!-- TODO: reconcile this list against the roadmap on the old WordPress site. -->

    <div class="grid grid-2" style="margin-bottom:2rem">
      <div class="card">
        <span class="tag">In progress</span>
        <h3 style="margin-top:.7rem">Dry run</h3>
        <p>The <code>-d</code> flag is wired up and the rsync dry run behind it is written, but it is not yet switched on. It will report exactly which files a push or pull would change, before you commit to it.</p>
      </div>
      <div class="card">
        <span class="tag tag-muted">Planned</span>
        <h3 style="margin-top:.7rem">Better error handling</h3>
        <p>rsync failures are not yet caught individually. Catching them lets MigrateWP stop and explain itself rather than carrying on to the next step.</p>
      </div>
      <div class="card">
        <span class="tag tag-muted">Planned</span>
        <h3 style="margin-top:.7rem">Remote database health check</h3>
        <p>Pre-flight checks confirm the local database is up, but not the remote one. Adding that closes the last gap in the checks.</p>
      </div>
      <div class="card">
        <span class="tag tag-muted">Planned</span>
        <h3 style="margin-top:.7rem">Wider host support</h3>
        <p>Setup is documented for Plesk today. The tool itself only needs SSH, WP-CLI and rsync, so the goal is guidance for other control panels and plain servers.</p>
      </div>
    </div>

    <div class="note">
      <p><strong>Want something on this list?</strong> <a href="https://github.com/Tartan-Web-Design/migrateWP/issues" rel="noopener">Open an issue on GitHub</a> and say so.</p>
    </div>

  </div>
</div>
BODY



# --------------------------------------------------------- privacy policy
page "privacy-policy/index.html" \
  "Privacy policy — MigrateWP" \
  "How Tartan Web Design Ltd collects, uses and retains personal data in connection with this website and our services." \
  "/privacy-policy/" "privacy" <<'BODY'
<div class="page-head">
  <div class="wrap">
    <p class="breadcrumb"><a href="/">Home</a><span>/</span>Privacy policy</p>
    <h1>Privacy policy</h1>
    <p>How Tartan Web Design Ltd collects, uses and retains personal data.</p>
  </div>
</div>

<div class="wrap" style="padding:clamp(2rem,4vw,3rem) 0 4.5rem">
  <article class="prose legal">

    <nav class="toc" aria-label="Sections">
      <h2>Sections</h2>
      <ol>
        <li><span>1</span><a href="#s1">Introduction</a></li>
        <li><span>2</span><a href="#s2">Credit</a></li>
        <li><span>3</span><a href="#s3">The personal data that we collect</a></li>
        <li><span>4</span><a href="#s4">Purposes of processing and legal bases</a></li>
        <li><span>5</span><a href="#s5">Providing your personal data to others</a></li>
        <li><span>6</span><a href="#s6">International transfers of your personal data</a></li>
        <li><span>7</span><a href="#s7">Retaining and deleting personal data</a></li>
        <li><span>8</span><a href="#s8">Your rights</a></li>
        <li><span>9</span><a href="#s9">About cookies</a></li>
        <li><span>10</span><a href="#s10">Cookies that we use</a></li>
        <li><span>11</span><a href="#s11">Cookies used by our service providers</a></li>
        <li><span>12</span><a href="#s12">Managing cookies</a></li>
        <li><span>13</span><a href="#s13">Amendments</a></li>
        <li><span>14</span><a href="#s14">Our details</a></li>
        <li><span>15</span><a href="#s15">Data protection officer</a></li>
      </ol>
    </nav>

    <h2 id="s1"><span class="num">1.</span>Introduction</h2>

    <p class="clause"><span class="num">1.1</span><span>We are committed to safeguarding the privacy of our website visitors, service users, individual customers and customer personnel.</span></p>

    <p class="clause"><span class="num">1.2</span><span>This policy applies where we are acting as a data controller with respect to the personal data of such persons; in other words, where we determine the purposes and means of the processing of that personal data.</span></p>

    <p class="clause"><span class="num">1.3</span><span>Our website incorporates privacy controls which affect how we will process your personal data. By using the privacy controls, you can specify whether you would like to receive marketing communications and limit the collection, sharing and publication of your personal data. You can access the privacy controls via the website.</span></p>

    <p class="clause"><span class="num">1.4</span><span>We use cookies on our website. Insofar as those cookies are not strictly necessary for the provision of our website and services, we will ask you to consent to our use of cookies when you first visit our website.</span></p>

    <p class="clause"><span class="num">1.5</span><span>In this policy, &ldquo;we&rdquo;, &ldquo;us&rdquo; and &ldquo;our&rdquo; refer to Tartan Web Design Ltd. For more information about us, see Section 14.</span></p>

    <h2 id="s2"><span class="num">2.</span>Credit</h2>

    <p class="clause"><span class="num">2.1</span><span>This document was created using a template from Docular (<a href="https://seqlegal.com/free-legal-documents/privacy-policy" rel="noopener">https://seqlegal.com/free-legal-documents/privacy-policy</a>).</span></p>

    <h2 id="s3"><span class="num">3.</span>The personal data that we collect</h2>

    <p class="clause"><span class="num">3.1</span><span>In this Section 3 we have set out the general categories of personal data that we process and, in the case of personal data that we did not obtain directly from you, information about the source and specific categories of that data.</span></p>

    <p class="clause"><span class="num">3.2</span><span>We may process data enabling us to get in touch with you (&ldquo;<dfn>contact data</dfn>&rdquo;). The contact data may include your name, email address, telephone number, postal address and/or social media account identifiers. The source of the contact data is you. If you log into our website using a social media account, we will obtain elements of the contact data from the relevant social media account provider.</span></p>

    <p class="clause"><span class="num">3.3</span><span>We may process your website user account data (&ldquo;<dfn>account data</dfn>&rdquo;). The account data may include your account identifier, name, email address, business name, account creation and modification dates, website settings and marketing preferences. The primary source of the account data is you, although some elements of the account data may be generated by our website. If you log into our website using a social media account, we will obtain elements of the account data from the relevant social media account provider.</span></p>

    <p class="clause"><span class="num">3.4</span><span>We may process information relating to transactions, including purchases of goods and/or services, that you enter into with us and/or through our website (&ldquo;<dfn>transaction data</dfn>&rdquo;). The transaction data may include your name, your contact details, your payment card details (or other payment details) and the transaction details. The source of the transaction data is you and/or our payment services provider.</span></p>

    <p class="clause"><span class="num">3.5</span><span>We may process information contained in or relating to any communication that you send to us or that we send to you (&ldquo;<dfn>communication data</dfn>&rdquo;). The communication data may include the communication content and metadata associated with the communication. Our website will generate the metadata associated with communications made using the website contact forms.</span></p>

    <p class="clause"><span class="num">3.6</span><span>We may process data about your use of our website and services (&ldquo;<dfn>usage data</dfn>&rdquo;). The usage data may include your IP address, geographical location, browser type and version, operating system, referral source, length of visit, page views and website navigation paths, as well as information about the timing, frequency and pattern of your service use. The source of the usage data is our analytics tracking system.</span></p>

    <h2 id="s4"><span class="num">4.</span>Purposes of processing and legal bases</h2>

    <p class="clause"><span class="num">4.1</span><span>In this Section 4, we have set out the purposes for which we may process personal data and the legal bases of the processing.</span></p>

    <p class="clause"><span class="num">4.2</span><span><dfn>Operations</dfn> &ndash; We may process your personal data for the purposes of operating our website, the processing and fulfilment of orders, providing our services, supplying our goods, generating invoices, bills and other payment-related documentation, and credit control. The legal basis for this processing is our legitimate interests, namely the proper administration of our website, services and business</span></p>

    <p class="clause"><span class="num">4.3</span><span><dfn>Publications</dfn> &ndash; We may process data for the purposes of publishing such data on our website and elsewhere through our services. The legal basis for this processing is our legitimate interests, namely the publication of content in the ordinary course of our operations.</span></p>

    <p class="clause"><span class="num">4.4</span><span><dfn>Relationships and communications</dfn> &ndash; We may process contact data, account data, transaction data and/or communication data for the purposes of managing our relationships, communicating with you (excluding communicating for the purposes of direct marketing) by email, SMS, post, fax and/or telephone, providing support services and complaint handling. The legal basis for this processing is our legitimate interests, namely communications with our website visitors, service users, individual customers and customer personnel, the maintenance of relationships, and the proper administration of our website, services and business.</span></p>

    <p class="clause"><span class="num">4.5</span><span><dfn>Direct marketing</dfn> &ndash; We may process contact data, account data and/or transaction data for the purposes of creating, targeting and sending direct marketing communications by email, SMS, post and/or fax and making contact by telephone for marketing-related purposes]. The legal basis for this processing is consent.</span></p>

    <p class="clause"><span class="num">4.6</span><span><dfn>Research and analysis</dfn> &ndash; We may process usage data and/or transaction data for the purposes of researching and analysing the use of our website and services, as well as researching and analysing other interactions with our business. The legal basis for this processing is our legitimate interests, namely monitoring, supporting, improving and securing our website, services and business generally.</span></p>

    <p class="clause"><span class="num">4.7</span><span><dfn>Record keeping</dfn> &ndash; We may process your personal data for [the purposes of creating and maintaining our databases, back-up copies of our databases and our business records generally. The legal basis for this processing is our legitimate interests, namely ensuring that we have access to all the information we need to properly and efficiently run our business in accordance with this policy.</span></p>

    <p class="clause"><span class="num">4.8</span><span><dfn>Security</dfn> &ndash; We may process your personal data for the purposes of security and the prevention of fraud and other criminal activity. The legal basis of this processing is our legitimate interests, namely the protection of our website, services and business, and the protection of others.</span></p>

    <p class="clause"><span class="num">4.9</span><span><dfn>Insurance and risk management</dfn> &ndash; We may process your personal data where necessary for the purposes of obtaining or maintaining insurance coverage, managing risks and/or obtaining professional advice. The legal basis for this processing is our legitimate interests, namely the proper protection of our business against risks.</span></p>

    <p class="clause"><span class="num">4.10</span><span><dfn>Legal claims</dfn> &ndash; We may process your personal data where necessary for the establishment, exercise or defence of legal claims, whether in court proceedings or in an administrative or out-of-court procedure. The legal basis for this processing is our legitimate interests, namely the protection and assertion of our legal rights, your legal rights and the legal rights of others.</span></p>

    <p class="clause"><span class="num">4.11</span><span><dfn>Legal compliance and vital interests</dfn> &ndash; We may also process your personal data where such processing is necessary for compliance with a legal obligation to which we are subject or in order to protect your vital interests or the vital interests of another natural person.</span></p>

    <h2 id="s5"><span class="num">5.</span>Providing your personal data to others</h2>

    <p class="clause"><span class="num">5.1</span><span>We may disclose your personal data to our insurers and/or professional advisers insofar as reasonably necessary for the purposes of obtaining or maintaining insurance coverage, managing risks, obtaining professional advice.</span></p>

    <p class="clause"><span class="num">5.2</span><span>Your personal data held in our website database will be stored on the servers of our hosting services providers.</span></p>

    <p class="clause"><span class="num">5.3</span><span>We may disclose personal data category or categories to our suppliers or subcontractors insofar as reasonably necessary for providing you services.</span></p>

    <p class="clause"><span class="num">5.4</span><span>Financial transactions relating to our website and services may be handled by our payment services providers, Stripe. We will share transaction data with our payment services providers only to the extent necessary for the purposes of processing your payments, refunding such payments and dealing with complaints and queries relating to such payments and refunds. You can find information about the payment services providers&rsquo; privacy policies and practices at their website.</span></p>

    <p class="clause"><span class="num">5.5</span><span>In addition to the specific disclosures of personal data set out in this Section 5, we may disclose your personal data where such disclosure is necessary for compliance with a legal obligation to which we are subject, or in order to protect your vital interests or the vital interests of another natural person. We may also disclose your personal data where such disclosure is necessary for the establishment, exercise, or defence of legal claims, whether in court proceedings or in an administrative or out-of-court procedure.</span></p>

    <h2 id="s6"><span class="num">6.</span>International transfers of your personal data</h2>

    <p class="clause"><span class="num">6.1</span><span>In this Section 6, we provide information about the circumstances in which your personal data may be transferred to countries outside the United Kingdom and the European Economic Area (EEA).</span></p>

    <p class="clause"><span class="num">6.2</span><span>The hosting facilities for our website are situated in the United Kingdom.</span></p>

    <p class="clause"><span class="num">6.3</span><span>You acknowledge that personal data that you submit for publication through our website or services may be available, via the internet, around the world. We cannot prevent the use (or misuse) of such personal data by others.</span></p>

    <h2 id="s7"><span class="num">7.</span>Retaining and deleting personal data</h2>

    <p class="clause"><span class="num">7.1</span><span>This Section 7 sets out our data retention policies and procedures, which are designed to help ensure that we comply with our legal obligations in relation to the retention and deletion of personal data.</span></p>

    <p class="clause"><span class="num">7.2</span><span>Personal data that we process for any purpose or purposes shall not be kept for longer than is necessary for that purpose or those purposes.</span></p>

    <p class="clause"><span class="num">7.3</span><span>We will retain your personal data as follows:</span></p>

    <p class="sub"><span class="num">(a)</span><span>contact data will be retained for a minimum period of 1 year following the date of the most recent contact between you and us, and for a maximum period of ten years following that date];</span></p>

    <p class="sub"><span class="num">(b)</span><span>account data will be retained for a minimum period of 6 months following the date of closure of the relevant account, and for a maximum period of ten years following that date];</span></p>

    <p class="sub"><span class="num">(c)</span><span>transaction data will be retained for a minimum period of of 1 year following the date of the transaction, and for a maximum period of ten years following that date];</span></p>

    <p class="sub"><span class="num">(d)</span><span>communication data will be retained for a minimum period of of 1 year following the date of the communication in question, and for a maximum period of ten years following that date];</span></p>

    <p class="sub"><span class="num">(e)</span><span>usage data will be retained for up to 10 years following the date of collection; and</span></p>

    <p class="clause"><span class="num">7.4</span><span>Notwithstanding the other provisions of this Section 7, we may retain your personal data where such retention is necessary for compliance with a legal obligation to which we are subject, or in order to protect your vital interests or the vital interests of another natural person.</span></p>

    <h2 id="s8"><span class="num">8.</span>Your rights</h2>

    <p class="clause"><span class="num">8.1</span><span>In this Section 8, we have listed the rights that you have under data protection law.</span></p>

    <p class="clause"><span class="num">8.2</span><span>Your principal rights under data protection law are:</span></p>

    <p class="sub"><span class="num">(a)</span><span>the right to access &ndash; you can ask for copies of your personal data;</span></p>
    <p class="sub"><span class="num">(b)</span><span>the right to rectification &ndash; you can ask us to rectify inaccurate personal data and to complete incomplete personal data;</span></p>
    <p class="sub"><span class="num">(c)</span><span>the right to erasure &ndash; you can ask us to erase your personal data;</span></p>
    <p class="sub"><span class="num">(d)</span><span>the right to restrict processing &ndash; you can ask us to restrict the processing of your personal data;</span></p>
    <p class="sub"><span class="num">(e)</span><span>the right to object to processing &ndash; you can object to the processing of your personal data;</span></p>
    <p class="sub"><span class="num">(f)</span><span>the right to data portability &ndash; you can ask that we transfer your personal data to another organisation or to you;</span></p>
    <p class="sub"><span class="num">(g)</span><span>the right to complain to a supervisory authority &ndash; you can complain about our processing of your personal data; and</span></p>
    <p class="sub"><span class="num">(h)</span><span>the right to withdraw consent &ndash; to the extent that the legal basis of our processing of your personal data is consent, you can withdraw that consent.</span></p>

    <p class="clause"><span class="num">8.3</span><span>These rights are subject to certain limitations and exceptions. You can learn more about the rights of data subjects by visiting <a href="https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/individual-rights/" rel="noopener">the ICO&rsquo;s guide to individual rights</a>.</span></p>

    <p class="clause"><span class="num">8.4</span><span>You may exercise any of your rights in relation to your personal data by written notice to us, using the contact details set out below.</span></p>

    <h2 id="s9"><span class="num">9.</span>About cookies</h2>

    <p class="clause"><span class="num">9.1</span><span>A cookie is a file containing an identifier (a string of letters and numbers) that is sent by a web server to a web browser and is stored by the browser. The identifier is then sent back to the server each time the browser requests a page from the server.</span></p>

    <p class="clause"><span class="num">9.2</span><span>Cookies may be either &ldquo;persistent&rdquo; cookies or &ldquo;session&rdquo; cookies: a persistent cookie will be stored by a web browser and will remain valid until its set expiry date, unless deleted by the user before the expiry date; a session cookie, on the other hand, will expire at the end of the user session, when the web browser is closed.</span></p>

    <p class="clause"><span class="num">9.3</span><span>Cookies may not contain any information that personally identifies a user, but personal data that we store about you may be linked to the information stored in and obtained from cookies.</span></p>

    <h2 id="s10"><span class="num">10.</span>Cookies that we use</h2>

    <p class="clause"><span class="num">10.1</span><span>We use cookies for the following purposes:</span></p>

    <p class="sub"><span class="num">(a)</span><span>authentication and status &ndash; we use cookies [to identify you when you visit our website and as you navigate our website, and to help us determine if you are logged into our website.</span></p>
    <p class="sub"><span class="num">(b)</span><span>shopping cart &ndash; we use cookies to maintain the state of your shopping cart as you navigate our website</span></p>
    <p class="sub"><span class="num">(c)</span><span>personalisation &ndash; we use cookies to store information about your preferences and to personalise our website for you</span></p>
    <p class="sub"><span class="num">(d)</span><span>security &ndash; we use cookies as an element of the security measures used to protect user accounts, including preventing fraudulent use of login credentials, and to protect our website and services generally</span></p>
    <p class="sub"><span class="num">(e)</span><span>advertising &ndash; we use cookies to help us to display advertisements that will be relevant to you</span></p>
    <p class="sub"><span class="num">(f)</span><span>analysis &ndash; we use cookies to help us to analyse the use and performance of our website and services</span></p>
    <p class="sub"><span class="num">(g)</span><span>cookie consent &ndash; we use cookies to store your preferences in relation to the use of cookies more generally</span></p>

    <h2 id="s11"><span class="num">11.</span>Cookies used by our service providers</h2>

    <p class="clause"><span class="num">11.1</span><span>Our service providers use cookies and those cookies may be stored on your computer when you visit our website.</span></p>

    <p class="clause"><span class="num">11.2</span><span>We use Google Analytics. Google Analytics gathers information about the use of our website by means of cookies. The information gathered is used to create reports about the use of our website. You can find out more about Google&rsquo;s use of information by visiting <a href="https://www.google.com/policies/privacy/partners/" rel="noopener">https://www.google.com/policies/privacy/partners/</a> and you can review Google&rsquo;s privacy policy at <a href="https://policies.google.com/privacy" rel="noopener">https://policies.google.com/privacy</a>.</span></p>

    <h2 id="s12"><span class="num">12.</span>Managing cookies</h2>

    <p class="clause"><span class="num">12.1</span><span>Most browsers allow you to refuse to accept cookies and to delete cookies. The methods for doing so vary from browser to browser, and from version to version. You can however obtain up-to-date information about blocking and deleting cookies via these links:</span></p>

    <p class="sub"><span class="num">(a)</span><span><a href="https://support.google.com/chrome/answer/95647" rel="noopener">https://support.google.com/chrome/answer/95647</a> (Chrome);</span></p>
    <p class="sub"><span class="num">(b)</span><span><a href="https://support.mozilla.org/en-US/kb/enable-and-disable-cookies-website-preferences" rel="noopener">https://support.mozilla.org/en-US/kb/enable-and-disable-cookies-website-preferences</a> (Firefox);</span></p>
    <p class="sub"><span class="num">(c)</span><span><a href="https://help.opera.com/en/latest/security-and-privacy/" rel="noopener">https://help.opera.com/en/latest/security-and-privacy/</a> (Opera);</span></p>
    <p class="sub"><span class="num">(d)</span><span><a href="https://support.microsoft.com/en-gb/help/17442/windows-internet-explorer-delete-manage-cookies" rel="noopener">https://support.microsoft.com/en-gb/help/17442/windows-internet-explorer-delete-manage-cookies</a> (Internet Explorer);</span></p>
    <p class="sub"><span class="num">(e)</span><span><a href="https://support.apple.com/en-gb/guide/safari/manage-cookies-and-website-data-sfri11471/mac" rel="noopener">https://support.apple.com/en-gb/guide/safari/manage-cookies-and-website-data-sfri11471/mac</a> (Safari); and</span></p>
    <p class="sub"><span class="num">(f)</span><span><a href="https://privacy.microsoft.com/en-us/windows-10-microsoft-edge-and-privacy" rel="noopener">https://privacy.microsoft.com/en-us/windows-10-microsoft-edge-and-privacy</a> (Edge).</span></p>

    <p class="clause"><span class="num">12.2</span><span>Blocking all cookies will have a negative impact upon the usability of many websites.</span></p>

    <p class="clause"><span class="num">12.3</span><span>If you block cookies, you will not be able to use all the features on our website.</span></p>

    <h2 id="s13"><span class="num">13.</span>Amendments</h2>

    <p class="clause"><span class="num">13.1</span><span>We may update this policy from time to time by publishing a new version on our website.</span></p>

    <p class="clause"><span class="num">13.2</span><span>You should check this page occasionally to ensure you are happy with any changes to this policy.</span></p>

    <p class="clause"><span class="num">13.3</span><span>We may notify you significant changes to this policy by email.</span></p>

    <h2 id="s14"><span class="num">14.</span>Our details</h2>

    <p class="clause"><span class="num">14.1</span><span>This website is owned and operated by Tartan Web Design Ltd.</span></p>

    <p class="clause"><span class="num">14.2</span><span>We are registered in Scotland under registration number sc661135, and our registered office is at 4-5 Mitchell Street, Edinburgh.</span></p>

    <p class="clause"><span class="num">14.4</span><span>You can contact us:</span></p>

    <p class="sub"><span class="num">(b)</span><span>using our website contact form;</span></p>
    <p class="sub"><span class="num">(c)</span><span>by telephone, on the contact number published on our website; or</span></p>
    <p class="sub"><span class="num">(d)</span><span>by email, using the email address published on our website.</span></p>

    <h2 id="s15"><span class="num">15.</span>Data protection officer</h2>

    <p class="clause"><span class="num">15.1</span><span>Our data protection officer&rsquo;s contact details are as above.</span></p>

  </article>
</div>
BODY

# -------------------------------------------------------------------- 404
page "404.html" \
  "Page not found — MigrateWP" \
  "That page does not exist." \
  "/404" "none" <<'BODY'
<div class="wrap error-page">
  <p class="code-num">404</p>
  <h1>That page has migrated</h1>
  <p class="measure" style="margin-inline:auto;color:var(--ink-soft)">The page you asked for is not here. It may have moved when this site was rebuilt as static HTML.</p>
  <div class="hero-actions" style="justify-content:center;margin-top:1.6rem">
    <a class="btn btn-primary" href="/">Home</a>
    <a class="btn btn-ghost" href="/docs/">Documentation</a>
  </div>
</div>
BODY
