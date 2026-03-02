#!/bin/bash
# ============================================================
#  check_deepaiug.sh
#  Diagnostica automatica installazione DeepAiUG
#  Funziona su Linux e macOS (rileva OS con uname)
# ============================================================

DEST="$HOME/DeepAiUG"
LOG="$HOME/DeepAiUG_install_log.txt"
ERRORI=0
OS_TYPE=$(uname -s)

# --- COLORI ANSI ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${BOLD}============================================================${NC}"
echo -e "${BOLD}     DeepAiUG - Diagnostica installazione${NC}"
echo -e "${BOLD}============================================================${NC}"
echo ""

if [[ "$OS_TYPE" == "Darwin" ]]; then
    echo -e "  Sistema: ${CYAN}macOS $(sw_vers -productVersion 2>/dev/null)${NC}"
else
    echo -e "  Sistema: ${CYAN}Linux $(uname -r)${NC}"
fi
echo ""

# --- 1. Python3 ---
echo "  1. Python3"

PY_OK=0
if command -v python3 &>/dev/null; then
    PY_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
    if [[ "$PY_MAJOR" -ge 3 && "$PY_MINOR" -ge 10 ]]; then
        PY_OK=1
        echo -e "     ${GREEN}[OK]${NC} Python $PY_VERSION trovato (>= 3.10)"
    else
        echo -e "     ${RED}[ERRORE]${NC} Python $PY_VERSION trovato ma serve >= 3.10"
        echo -e "     ${YELLOW}Soluzione:${NC} Aggiorna Python a 3.10 o superiore"
        ((ERRORI++))
    fi
elif command -v python &>/dev/null; then
    PY_VERSION=$(python --version 2>&1 | awk '{print $2}')
    PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
    PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
    if [[ "$PY_MAJOR" -ge 3 && "$PY_MINOR" -ge 10 ]]; then
        PY_OK=1
        echo -e "     ${GREEN}[OK]${NC} Python $PY_VERSION trovato (>= 3.10)"
    else
        echo -e "     ${RED}[ERRORE]${NC} Python $PY_VERSION trovato ma serve >= 3.10"
        echo -e "     ${YELLOW}Soluzione:${NC} Aggiorna Python a 3.10 o superiore"
        ((ERRORI++))
    fi
fi

if [[ $PY_OK -eq 0 && $ERRORI -eq 0 ]]; then
    echo -e "     ${RED}[ERRORE]${NC} Python non trovato"
    echo -e "     ${YELLOW}Soluzione:${NC} Installa Python 3.10+ da https://www.python.org/downloads/"
    ((ERRORI++))
fi
echo ""

# --- 2. Ollama ---
echo "  2. Ollama"

if command -v ollama &>/dev/null; then
    echo -e "     ${GREEN}[OK]${NC} Ollama trovato nel PATH"
elif [[ "$OS_TYPE" == "Darwin" && -d /Applications/Ollama.app ]]; then
    echo -e "     ${GREEN}[OK]${NC} Ollama trovato in /Applications/"
else
    echo -e "     ${RED}[ERRORE]${NC} Ollama non trovato"
    echo -e "     ${YELLOW}Soluzione:${NC} Installa da https://ollama.com/download"
    ((ERRORI++))
fi
echo ""

# --- 3. Cartella DeepAiUG ---
echo "  3. Cartella DeepAiUG"

if [[ -d "$DEST" ]]; then
    echo -e "     ${GREEN}[OK]${NC} Cartella trovata: $DEST"
else
    echo -e "     ${RED}[ERRORE]${NC} Cartella non trovata: $DEST"
    echo -e "     ${YELLOW}Soluzione:${NC} Esegui nuovamente lo script di installazione"
    ((ERRORI++))
fi
echo ""

# --- 4. Virtual Environment ---
echo "  4. Ambiente virtuale (venv)"

if [[ -f "$DEST/venv/bin/python" ]]; then
    echo -e "     ${GREEN}[OK]${NC} venv trovato: $DEST/venv/"
else
    echo -e "     ${RED}[ERRORE]${NC} venv non trovato in: $DEST/venv/"
    echo -e "     ${YELLOW}Soluzione:${NC} Esegui nuovamente lo script di installazione"
    ((ERRORI++))
fi
echo ""

# --- 5. requirements.txt ---
echo "  5. requirements.txt"

if [[ -f "$DEST/requirements.txt" ]]; then
    echo -e "     ${GREEN}[OK]${NC} requirements.txt trovato"
else
    echo -e "     ${RED}[ERRORE]${NC} requirements.txt non trovato in: $DEST/"
    echo -e "     ${YELLOW}Soluzione:${NC} Esegui nuovamente lo script di installazione"
    ((ERRORI++))
fi
echo ""

# --- 6. Modelli Ollama ---
echo "  6. Modelli Ollama installati"
echo ""

if command -v ollama &>/dev/null; then
    if ollama list 2>/dev/null; then
        true
    else
        echo -e "     ${YELLOW}[ATTENZIONE]${NC} Ollama non raggiungibile. Verifica che sia in esecuzione."
        if [[ "$OS_TYPE" == "Darwin" ]]; then
            echo -e "     ${YELLOW}Soluzione:${NC} Apri l'app Ollama da /Applications/"
        else
            echo -e "     ${YELLOW}Soluzione:${NC} Esegui: ollama serve"
        fi
    fi
else
    echo -e "     ${YELLOW}[ATTENZIONE]${NC} Impossibile elencare i modelli. Ollama non trovato."
fi
echo ""

# --- 7. Log installazione ---
echo "  7. Log installazione"

if [[ -f "$LOG" ]]; then
    echo -e "     ${GREEN}[OK]${NC} Log trovato: $LOG"
    echo ""
    echo "     Ultime 20 righe del log:"
    echo "     --------------------------------------------------------"
    tail -20 "$LOG" | while IFS= read -r line; do
        echo "       $line"
    done
    echo ""
    echo "     --------------------------------------------------------"
else
    echo -e "     ${CYAN}[INFO]${NC} Log installazione non trovato."
    echo "     Il log viene creato durante l'installazione: $LOG"
fi
echo ""

# --- Riepilogo ---
echo -e "${BOLD}============================================================${NC}"
if [[ $ERRORI -eq 0 ]]; then
    echo -e "  ${GREEN}RISULTATO: Tutti i controlli superati!${NC}"
    echo "  DeepAiUG dovrebbe funzionare correttamente."
else
    echo -e "  ${RED}RISULTATO: Trovati $ERRORI problemi.${NC}"
    echo "  Segui le indicazioni sopra per risolverli."
fi
echo -e "${BOLD}============================================================${NC}"
echo ""
