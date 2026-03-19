# Piano di Implementazione: Fattura Elettronica

Questo documento descrive i 5 passi per realizzare l'applicazione web in Flutter per la lettura, visualizzazione, salvataggio e stampa delle fatture elettroniche.

## Passo 1: Inizializzazione del Progetto e Configurazione Git

- Creazione del progetto Flutter con supporto specifico per la piattaforma Web (`flutter create --platforms web fattura_elettronica`).
- Inizializzazione del repository Git locale all'interno della cartella di progetto (`git init`).
- Creazione del file `.gitignore` e primo commit di base del codice sorgente generato dal framework.

## Passo 2: Selezione Cartella e Lettura File XML

- Utilizzo del pacchetto `file_picker` (o analoghi compatibili col web) per permettere all'utente di selezionare una directory o direttamente i file delle fatture.
- Sviluppo di un modulo per la lettura dei file XML conformi al tracciato standard della FatturaPA italiana.
- Creazione di classi Dart/modelli dati (es. `FatturaElettronica`, `CedentePrestatore`, `DatiGenerali`, `DatiBeniServizi`) per effettuare il parsing strutturato del contenuto (tramite pacchetti come `xml`).

## Passo 3: Sviluppo dell'Interfaccia di Visualizzazione (UI)

- Sviluppo dell'interfaccia utente web-responsive in Flutter.
- Creazione di una schermata riassuntiva che presenti in modo leggibile i dati essenziali:
  - Anagrafica del mittente e del destinatario.
  - Dati generali del documento (numero, data, causale).
  - Tabella delle righe di dettaglio (beni/servizi, quantità, prezzi).
  - Totali e riepiloghi IVA.

## Passo 4: Implementazione Generazione PDF e Stampa

- Integrazione dei pacchetti dart `pdf` e `printing`.
- Creazione di un layout grafico per il PDF che rispecchi l'interfaccia di visualizzazione o una formattazione classica "uso bollo" per fatture di cortesia.
- Sviluppo della funzionalità per consentire all'utente di scaricare/salvare il file in formato `.pdf` e di invocare la finestra di stampa nativa del browser web.

## Passo 5: Test, Revisione e Commit Finale

- Test della web app nel browser per verificare che la lettura dell'XML (incluso l'esempio `IT..._0021M.xml`) avvenga correttamente e che la stampa/generazione PDF siano perfette.
- Pulizia del codice (linting, rimozione codice di default).
- Push/Commit definitivo sul repository Git ed eventuale configurazione del repository remoto (es. GitHub/GitLab).
