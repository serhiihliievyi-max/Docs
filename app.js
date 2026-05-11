const PAGES = [
  { label: "🏠 Главная", file: "index.md" },
  { label: "📋 Обзор проекта", file: "project-overview.md" },
  { label: "🎯 MVP Scope", file: "mvp-scope.md" },
  { label: "🗄️ Сущности БД", file: "entities.md" },
  { label: "🔌 API Эндпоинты", file: "api-endpoints.md" },
  { label: "🚶 Флоу арендатора", file: "user-flow-renter.md" },
  { label: "🏠 Флоу владельца", file: "user-flow-owner.md" },
  { label: "🖥️ Страницы фронта", file: "pages-frontend.md" },
  { label: "🌿 Git Flow", file: "git-flow.md" },
];

const nav = document.getElementById("nav");
const output = document.getElementById("output");

PAGES.forEach(({ label, file }) => {
  const a = document.createElement("a");
  a.textContent = label;
  a.href = "#" + file;
  a.addEventListener("click", (e) => {
    e.preventDefault();
    loadPage(file);
    history.pushState(null, "", "#" + file);
  });
  nav.appendChild(a);
});

function setActive(file) {
  nav.querySelectorAll("a").forEach((a) => {
    a.classList.toggle("active", a.getAttribute("href") === "#" + file);
  });
}

function processCallouts(markdown) {
  return markdown.replace(
    /> \[!(info|warning|danger|note|tip)\](.*?)\n((?:>.*\n?)*)/gi,
    (_, type, title, body) => {
      const typeMap = { note: "info", tip: "info" };
      const cls = typeMap[type.toLowerCase()] || type.toLowerCase();
      const content = body.replace(/^> ?/gm, "").trim();
      const heading = title.trim() ? `**${title.trim()}**\n\n` : "";
      return `<div class="callout callout-${cls}">\n\n${heading}${content}\n\n</div>\n\n`;
    },
  );
}

function processWikilinks(html) {
  return html.replace(
    /\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g,
    (_, target, label) => {
      const file = target.trim() + ".md";
      const text = label ? label.trim() : target.trim();
      const exists = PAGES.some((p) => p.file === file);
      if (exists) {
        return `<a href="#${file}" class="wikilink" data-file="${file}">${text}</a>`;
      }
      return `<span class="wikilink-missing" title="${file} не найдено">${text}</span>`;
    },
  );
}

async function loadPage(file) {
  output.innerHTML = '<p style="color:var(--text-muted)">Загрузка...</p>';
  setActive(file);

  try {
    const res = await fetch(file);
    if (!res.ok) throw new Error(`${res.status}`);

    let text = await res.text();

    text = text.replace(/^---[\s\S]*?---\n/, "");

    text = processCallouts(text);

    let html = marked.parse(text);

    html = processWikilinks(html);

    output.innerHTML = html;
    window.scrollTo(0, 0);

    output.querySelectorAll("a.wikilink").forEach((a) => {
      a.addEventListener("click", (e) => {
        e.preventDefault();
        const f = a.dataset.file;
        loadPage(f);
        history.pushState(null, "", "#" + f);
      });
    });
  } catch (err) {
    output.innerHTML = `<p style="color:#f38ba8">Не удалось загрузить <code>${file}</code>: ${err.message}</p>`;
  }
}

function route() {
  const hash = location.hash.slice(1);
  const match = PAGES.find((p) => p.file === hash);
  loadPage(match ? match.file : PAGES[0].file);
}

window.addEventListener("popstate", route);
route();
