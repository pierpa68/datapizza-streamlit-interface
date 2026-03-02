# DeepAiUG Installer - Documentazione tecnica

## Struttura cartella

```
installer/
├── INSTALLA_DeepAiUG.bat        # Installazione automatica Windows 11
├── CHECK_DeepAiUG.bat           # Diagnostica Windows
├── installa_deepaiug_linux.sh   # Installazione automatica Linux
├── installa_deepaiug_mac.sh     # Installazione automatica macOS
├── check_deepaiug.sh            # Diagnostica Linux/macOS (unificato)
├── INIZIA-QUI.txt               # Istruzioni rapide utente (tutti gli OS)
└── README_installer.md          # Questa documentazione (sviluppatori)
```

---

## Windows — INSTALLA_DeepAiUG.bat

### I 9 step

| Step | Descrizione | Dettagli |
|------|-------------|----------|
| 0 | Verifica admin | `net session` — richiede "Esegui come amministratore" |
| 1 | Disclaimer | Mostra cosa verra' installato, chiede conferma S/N |
| 2 | Check sistema | Rileva RAM (GB) e GPU via `wmic` |
| 3 | Python 3.12 | Verifica PATH e percorso fisso; se assente, scarica e installa |
| 4 | Ollama | Verifica `%LOCALAPPDATA%\Ollama\`; se assente, scarica e installa |
| 5 | Download DeepAiUG | Scarica ZIP da GitHub, estrae con `Expand-Archive`, `xcopy` |
| 6 | venv + dipendenze | Crea venv, aggiorna pip, installa `datapizza-ai` poi `requirements.txt` |
| 7 | Scelta modello | Suggerisce modello in base alla RAM, accetta input utente |
| 8 | Download modello | Avvia Ollama, esegue `ollama pull` (non bloccante se fallisce) |
| 9 | Launcher + shortcut | Crea `DeepAiUG.bat` e collegamento Desktop via VBScript |

### Variabili configurabili

Definite in cima a `INSTALLA_DeepAiUG.bat`:

| Variabile | Default | Descrizione |
|-----------|---------|-------------|
| `DEST` | `%USERPROFILE%\DeepAiUG` | Cartella di installazione |
| `VENV` | `venv` | Nome ambiente virtuale |
| `LOG` | `%USERPROFILE%\DeepAiUG_install_log.txt` | Percorso log |
| `GITHUB_ZIP` | `https://github.com/EnzoGitHub27/.../main.zip` | URL repo ZIP |
| `PYTHON_URL` | `https://www.python.org/.../python-3.12.10-amd64.exe` | Installer Python |
| `OLLAMA_URL` | `https://ollama.com/download/OllamaSetup.exe` | Installer Ollama |
| `PYTHON_EXE` | `C:\Program Files\Python312\python.exe` | Percorso Python atteso |

### Subroutine `:DownloadFile`

Funzione riutilizzabile per tutti i download. Parametri:
- `%1` — URL sorgente
- `%2` — Percorso file destinazione
- `%3` — Descrizione (per output a schermo e log)

Usa `WebClient.DownloadFileTaskAsync` con evento `DownloadProgressChanged` per mostrare una progress bar testuale: `[####............] 25%  12.3 MB / 49.2 MB`

---

## Linux — installa_deepaiug_linux.sh

### Gli 11 step

| Step | Descrizione | Dettagli |
|------|-------------|----------|
| 1 | Disclaimer | Conferma utente con `read -p` |
| 2 | Rilevamento distro | Rileva apt/dnf/pacman + RAM + GPU |
| 3 | Python | Verifica >= 3.10, installa se mancante + python3-venv |
| 4 | curl + unzip | Verifica/installa dipendenze di sistema |
| 5 | Ollama | Verifica/installa con script ufficiale |
| 6 | Download DeepAiUG | curl + unzip da GitHub ZIP |
| 7 | venv + dipendenze | `datapizza-ai` prima, poi `requirements.txt` |
| 8 | Scelta modello | Suggerimento per fascia RAM |
| 9 | Download modello | `ollama serve &` + `ollama pull` |
| 10 | Launcher | Crea `avvia_deepaiug.sh` + file `.desktop` |
| 11 | Riepilogo | Percorso, modello, come avviare |

### Variabili

| Variabile | Default | Descrizione |
|-----------|---------|-------------|
| `DEST` | `$HOME/DeepAiUG` | Cartella di installazione |
| `VENV` | `venv` | Nome ambiente virtuale |
| `LOG` | `$HOME/DeepAiUG_install_log.txt` | Percorso log |
| `GITHUB_ZIP` | `https://github.com/EnzoGitHub27/.../main.zip` | URL repo ZIP |

### Distro supportate

| Package Manager | Distro | Installazione automatica |
|-----------------|--------|--------------------------|
| `apt` | Ubuntu, Debian, Mint | Python3, python3-venv, curl, unzip |
| `dnf` | Fedora, RHEL, CentOS | Python3, python3-pip, curl, unzip |
| `pacman` | Arch, Manjaro | Python, python-pip, curl, unzip |

---

## macOS — installa_deepaiug_mac.sh

### I 12 step

| Step | Descrizione | Dettagli |
|------|-------------|----------|
| 1 | Disclaimer | Conferma utente con `read -p` |
| 2 | Check sistema | RAM (`sysctl hw.memsize`), GPU/Chip, macOS version |
| 3 | Xcode CLI Tools | Verifica/installa `xcode-select` |
| 4 | Homebrew | Verifica/installa (opzionale, chiede conferma) |
| 5 | Python | Verifica >= 3.10, installa via brew o .pkg diretto |
| 6 | Ollama | Verifica/installa via brew, curl, o .zip diretto |
| 7 | Download DeepAiUG | curl + unzip da GitHub ZIP |
| 8 | venv + dipendenze | `datapizza-ai` prima, poi `requirements.txt` |
| 9 | Scelta modello | Suggerimento per fascia RAM |
| 10 | Download modello | `ollama serve &` + `ollama pull` |
| 11 | Launcher | Crea `DeepAiUG.command` + nota Gatekeeper |
| 12 | Riepilogo | Percorso, modello, come avviare |

---

## Diagnostica — check_deepaiug.sh (Linux/macOS)

Script bash unico che rileva il sistema operativo con `uname -s`.

| Check | Linux | macOS |
|-------|-------|-------|
| Python3 >= 3.10 | `python3 --version` | `python3 --version` |
| Ollama | `command -v ollama` | `command -v ollama` + `/Applications/Ollama.app` |
| Cartella DeepAiUG | `$HOME/DeepAiUG` | `$HOME/DeepAiUG` |
| venv | `venv/bin/python` | `venv/bin/python` |
| requirements.txt | Check esistenza | Check esistenza |
| Modelli Ollama | `ollama list` | `ollama list` |
| Log | `tail -20` | `tail -20` |

---

## Modelli consigliati per RAM (tutti gli OS)

| RAM | Default | Alternative | Dimensione |
|-----|---------|-------------|------------|
| < 8 GB | `phi3:mini` | `tinyllama` | ~1.1 - 2.3 GB |
| 8-15 GB | `llama3.2:3b` | `phi3`, `phi3:mini` | ~2.0 - 2.3 GB |
| 16-31 GB | `mistral:7b` | `llama3.2:3b`, `gemma2:9b` | ~2.0 - 5.4 GB |
| >= 32 GB | `llama3.1:8b` | `mistral:7b`, `gemma2:9b` | ~4.1 - 5.4 GB |

---

## Log file

| OS | Posizione | Lettura rapida |
|----|-----------|----------------|
| Windows | `%USERPROFILE%\DeepAiUG_install_log.txt` | `CHECK_DeepAiUG.bat` o PowerShell `Get-Content -Tail 20` |
| Linux/macOS | `$HOME/DeepAiUG_install_log.txt` | `check_deepaiug.sh` o `tail -20` |

Formato: ogni riga e' prefissata con `[CATEGORIA]` (es. `[OK]`, `[PYTHON]`, `[DOWNLOAD]`, `[ERRORE]`). Su Linux/macOS le righe includono anche un timestamp.

---

## Note per sviluppatori

### Ordine installazione pip

**Importante:** `datapizza-ai` deve essere installato PRIMA di `requirements.txt` perche' `datapizza-ai-clients-openai-like` (in requirements.txt) dipende da `datapizza-ai`. Questo ordine e' rispettato in tutti e 3 gli script.

### Windows — Esecuzione come Admin

Lo script richiede privilegi di amministratore per:
- Installazione Python con `InstallAllUsers=1` (in `C:\Program Files\`)
- Installazione Ollama con `/silent`

Se l'utente non esegue come admin, lo step 0 blocca subito con messaggio chiaro.

### Windows — PowerShell Execution Policy

Lo script usa PowerShell inline (`powershell -Command "..."`) e non esegue file `.ps1`, quindi **non richiede modifiche alla Execution Policy**.

### macOS — Gatekeeper

Il file `.command` creato dallo script non e' firmato. La prima volta l'utente deve:
1. Tasto destro > "Apri"
2. Confermare nella finestra di sicurezza

Le volte successive il doppio click funziona normalmente.

### Linux/macOS — Permessi chmod

Gli script `.sh` devono avere il permesso di esecuzione:
```bash
chmod +x installa_deepaiug_linux.sh
chmod +x installa_deepaiug_mac.sh
chmod +x check_deepaiug.sh
```

I launcher creati dagli script (`avvia_deepaiug.sh`, `DeepAiUG.command`) ricevono `chmod +x` automaticamente durante l'installazione.

---

## Come testare

### Windows 11 (VM)
1. Creare VM Windows 11 (Hyper-V, VirtualBox, o VMware)
2. Assicurarsi che la VM abbia accesso a Internet
3. Copiare la cartella `installer/` nella VM
4. Tasto destro su `INSTALLA_DeepAiUG.bat` > "Esegui come amministratore"
5. Al termine, verificare con `CHECK_DeepAiUG.bat`

### Linux (VM)
1. Creare VM Ubuntu 22.04+ o Fedora 38+ o Arch
2. Copiare `installer/` nella VM
3. `chmod +x installa_deepaiug_linux.sh && ./installa_deepaiug_linux.sh`
4. Al termine: `bash check_deepaiug.sh`

### macOS (nativo o VM)
1. Copiare `installer/` sulla macchina
2. `bash installa_deepaiug_mac.sh`
3. Al termine: `bash check_deepaiug.sh`

### Scenari da testare (tutti gli OS)
- Installazione pulita (nessun Python/Ollama pre-installato)
- Installazione con Python gia' presente nel PATH
- Installazione con Ollama gia' presente
- Annullamento al disclaimer (Step 1)
- Installazione senza connessione Internet (deve fallire con messaggio chiaro)
- VM con < 8 GB RAM (deve suggerire `phi3:mini`)
