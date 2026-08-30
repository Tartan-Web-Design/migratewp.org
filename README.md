# migratewp.org

The [migratewp.org](https://migratewp.org) website: a dependency-free static
rebuild of what used to be a WordPress site, deployed on Netlify. No build
step, no framework, no CMS — twelve HTML files, one stylesheet, one small
script.

The MigrateWP tool itself lives in
[Tartan-Web-Design/migrateWP](https://github.com/Tartan-Web-Design/migrateWP).

```
.
├── index.html                     home
├── docs/                          overview + 4 documentation pages
├── releases/  roadmap/            project pages
├── privacy-policy/
├── 404.html
├── assets/{css,js,img}
├── _redirects                     legacy WordPress URL → static URL 301s
├── netlify.toml                   publish settings, security + cache headers
├── robots.txt  sitemap.xml
└── _tools/build.sh                regenerates the HTML (optional, see below)
```

## Deploying to Netlify

1. In Netlify: **Add new site → Import an existing project**, and pick this
   repository. Netlify asks for GitHub access to private repositories the
   first time; grant it for the `Tartan-Web-Design` organisation.
2. Accept the defaults — `netlify.toml` already sets them:
   - **Base directory**: *(empty)*
   - **Build command**: *(empty — there is no build step)*
   - **Publish directory**: `.`
3. Deploy. `netlify.toml` supplies the headers and `_redirects` the 301s.

Every push to `main` redeploys. Pull requests get their own deploy preview.

### Custom domain

Point `migratewp.org` at Netlify once the deploy preview looks right. Netlify
issues the Let's Encrypt certificate automatically. Keep the WordPress host
running until DNS has propagated, then cancel it.

## Editing the site

The HTML files are checked in and served as-is, so you can edit any page
directly and Netlify will publish it.

The catch is that the header, nav and footer are repeated in every page.
`_tools/build.sh` exists so a change to those does not have to be made twelve
times:

```sh
./_tools/build.sh      # rewrites every .html file in place
```

Page bodies live inside that script. **If you use it, edit content there** —
running it overwrites hand edits to the generated HTML. If you would rather
not use it at all, delete `_tools/` and edit the HTML by hand; nothing else
depends on it.

## Local preview

```sh
python3 -m http.server 8000     # then open http://localhost:8000
```

Or `npx netlify dev` from this folder to exercise the redirects and form
handling as they will behave in production.

## Still to do

The rebuild was written from the project README, the `migratewp.sh` source and
the live site's URL structure. A few things need your eyes before launch:

- **Release notes** — `releases/index.html` has a summary for 1.0 and 1.1, but
  the full notes from the old `/releases/` page have not been ported. Look for
  the `TODO` comments.
- **Roadmap** — `roadmap/index.html` lists items derived from the source
  (the unfinished `-d` dry run, the `TODO`s in the script). Reconcile it with
  whatever the old roadmap page said.
- **Images** — nothing from `/wp-content/uploads/` has been carried over,
  including the `migrate-1.1-push.gif` demo the old home page used. Drop the
  files into `assets/img/`, reference them, and add rules to `_redirects` if
  any of the old upload URLs are linked from elsewhere.
- **Privacy policy** — rewritten to describe this static site accurately
  (no cookies, no analytics, Netlify Forms). Check it against your own
  obligations before publishing.
- **Old URLs** — `_redirects` sends `/contact-migratewp/` to the home page
  and covers the usual WordPress plumbing. Pull the top pages out of Search Console or the old
  server's access logs and add anything else that still gets traffic.
