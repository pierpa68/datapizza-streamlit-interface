# config/branding.py
# DeepAiUG v1.10.0 - Branding personalizzabile
# ============================================================================
# Carica branding.yaml dalla root del progetto.
# Fallback silenzioso ai valori default se il file manca o è malformato.
# ============================================================================

from .constants import BASE_DIR

try:
    import yaml
    _YAML_AVAILABLE = True
except ImportError:
    _YAML_AVAILABLE = False

# Path file branding nella root del progetto
_BRANDING_FILE = BASE_DIR / "branding.yaml"

# Valori default (identici ai valori hardcoded originali)
_DEFAULTS: dict = {
    "app": {
        "title": "DeepAiUG Chat",
        "icon": "\U0001f9e0",
        "subtitle": "",
    },
    "news_banner": {
        "enabled": True,
        "text": "Modalità Socratica - Scegli la profondità di analisi!",
        "version": "1.10.0",
    },
}


def load_branding() -> dict:
    """
    Carica configurazione branding da branding.yaml.

    Se il file non esiste, yaml non è disponibile, o il file è malformato,
    ritorna i valori default senza errori.

    Returns:
        Dict con sezioni 'app' e 'news_banner'
    """
    if not _YAML_AVAILABLE or not _BRANDING_FILE.exists():
        return _DEFAULTS

    try:
        with open(_BRANDING_FILE, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
    except Exception:
        return _DEFAULTS

    if not isinstance(data, dict):
        return _DEFAULTS

    # Merge: i campi mancanti nel YAML prendono il valore default
    result: dict = {}
    for section_key, section_defaults in _DEFAULTS.items():
        user_section = data.get(section_key, {})
        if not isinstance(user_section, dict):
            user_section = {}
        result[section_key] = {**section_defaults, **user_section}

    return result


# ============================================================================
# Costanti di modulo — calcolate una sola volta all'import
# ============================================================================

_branding = load_branding()

APP_TITLE: str = _branding["app"]["title"]
APP_ICON: str = _branding["app"]["icon"]
APP_SUBTITLE: str = _branding["app"]["subtitle"]

NEWS_BANNER_ENABLED: bool = _branding["news_banner"]["enabled"]
NEWS_BANNER_TEXT: str = _branding["news_banner"]["text"]
NEWS_BANNER_VERSION: str = _branding["news_banner"]["version"]
