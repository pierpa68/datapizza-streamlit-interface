# ui/socratic/prompts.py
# DeepAiUG v1.9.x - Template Prompt Socratici
# ============================================================================
# Prompt epistemologicamente potenziati per stimolare il "lavoro semantico".
# Ispirati al concetto di capitale semantico (Floridi/Quartarone).
# ============================================================================

# Template dei prompt socratici
SOCRATIC_PROMPTS = {
    # v1.6.1 → v1.9.x - Potenziato
    "alternatives": """Analizza la seguente risposta e produci tre tipi di alternative distinti:

1. ALTERNATIVE DI SOLUZIONE — approcci diversi che portano allo stesso obiettivo
2. ALTERNATIVE DI FRAMING — riformulazioni del problema che cambiano la prospettiva
3. ALTERNATIVE DI ASSUNZIONE — cosa cambia se il contesto o le premesse sono diversi

Per ciascuna alternativa indica brevemente perché potrebbe essere preferibile
rispetto alla risposta originale e in quale contesto decisionale avrebbe senso.

Risposta da analizzare:
{response}""",

    # v1.7.0 → v1.9.x - Potenziato
    "assumptions": """Analizza la seguente risposta classificando il suo contenuto in tre livelli epistemici:

1. FATTI — affermazioni osservabili e verificabili indipendentemente
2. INFERENZE — conclusioni probabilistiche che dipendono da dati o correlazioni
3. VALUTAZIONI — giudizi normativi che dipendono da chi decide e dal suo contesto

Per le INFERENZE più rilevanti, aggiungi: "Se questa inferenza fosse errata,
quali conclusioni della risposta sopravviverebbero? Quali cadrebbero?"

Rispondi in modo strutturato, senza punteggi o valutazioni automatiche.

Risposta da analizzare:
{response}""",

    # v1.7.0 → v1.9.x - Potenziato
    "limits": """Analizza i limiti della seguente risposta distinguendo tre categorie:

1. LIMITI DI DOMINIO — il campo trattato è intrinsecamente instabile, controverso
   o soggetto a rapida evoluzione (dove la delega alla macchina è rischiosa)
2. LIMITI DI CONTESTO — informazioni mancanti, ipotesi sul contesto dell'utente
   che potrebbero essere scorrette
3. LIMITI DEL MODELLO — il tipo di destinatario e di problema che questa risposta
   presuppone implicitamente (chi non è il destinatario ideale di questa risposta?)

Concludi con: quali parti della risposta restano valide indipendentemente dai limiti
elencati, e quali richiedono verifica prima di agire.

Risposta da analizzare:
{response}""",

    # v1.8.0 → v1.9.x - Potenziato
    "confute": """Agisci come avvocato del diavolo sulla seguente risposta su due livelli distinti:

LIVELLO 1 — CONFUTAZIONE DELLE CONCLUSIONI
Argomenta contro le affermazioni principali: quali sono le obiezioni più solide
che un esperto critico potrebbe sollevare?

LIVELLO 2 — CONFUTAZIONE DELLA STRUTTURA
Metti alla prova le premesse fondanti: se le assunzioni di base fossero false
o il contesto fosse diverso, quali parti della risposta collasserebbero?
Quali invece reggerebbero comunque?

Non cercare di bilanciare o ammorbidire. L'obiettivo è trovare i punti di cedimento,
non produrre una valutazione equilibrata.

Risposta da analizzare:
{response}""",

    # v1.8.0 → v1.9.x - Potenziato
    "reflect": """Non analizzare la risposta. Analizza la domanda che l'ha generata.

Esamina la seguente domanda su tre dimensioni:

1. PRESUPPOSIZIONI — quali credenze o assunzioni implicite la domanda porta con sé?
   Cosa deve essere già vero perché la domanda abbia senso?

2. DESTINATARIO IMPLICITO — che tipo di decisore o contesto questa domanda presuppone?
   La risposta cambierebbe significativamente se chi decide fosse diverso
   (ruolo, responsabilità, valori, vincoli)?

3. DOMANDA SOTTO LA DOMANDA — c'è un problema più profondo o più preciso
   che potrebbe essere più utile affrontare?

Non rispondere alla domanda originale. Restituisci attrito: aiuta l'utente
a capire cosa sta davvero chiedendo e perché.

Domanda dell'utente: {user_question}
Risposta ricevuta (contesto): {response}""",
}


def get_alternatives_prompt(response: str) -> str:
    """
    Genera il prompt per richiedere alternative a una risposta.
    
    Args:
        response: La risposta originale dell'AI
        
    Returns:
        Il prompt formattato per generare alternative
    """
    return SOCRATIC_PROMPTS["alternatives"].format(response=response)


def get_assumptions_prompt(response: str) -> str:
    """Genera il prompt per analizzare le assunzioni. (v1.7.0)"""
    return SOCRATIC_PROMPTS["assumptions"].format(response=response)


def get_limits_prompt(response: str) -> str:
    """Genera il prompt per identificare i limiti. (v1.7.0)"""
    return SOCRATIC_PROMPTS["limits"].format(response=response)


def get_confute_prompt(response: str) -> str:
    """Genera il prompt per confutare la risposta. (v1.8.0)"""
    return SOCRATIC_PROMPTS["confute"].format(response=response)


def get_reflect_prompt(response: str, user_question: str) -> str:
    """
    Genera il prompt per riflettere sulla DOMANDA dell'utente. (v1.8.0)

    Args:
        response: La risposta dell'AI
        user_question: La domanda originale dell'utente

    Returns:
        Il prompt formattato per stimolare riflessione critica sulla domanda
    """
    return SOCRATIC_PROMPTS["reflect"].format(
        response=response,
        user_question=user_question
    )