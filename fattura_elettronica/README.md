# Fattura Elettronica Web App

Applicazione web Flutter progettata per semplificare la gestione delle fatture elettroniche in formato XML/P7M/EML. L'app permette di caricare intere cartelle (tipiche delle caselle PEC) e di estrarre automaticamente la vera FatturaPA, scartando ricevute e allegati non pertinenti.

## 🚀 Caratteristiche Principali

- **Selezione Cartella Nativa**: Utilizza l'API nativa del browser per selezionare intere cartelle, garantendo privacy e velocità.
- **Riconoscimento Automatico**: Analizza i file XML/P7M/EML e identifica automaticamente la FatturaPA corretta, ignorando file di metadati o ricevute (es. `daticert.xml`, `postacert.eml`).
- **Visualizzazione Dettagliata**: Mostra tutti i dati salienti della fattura (Cedente/Prestatore, Cessionario/Committente, Dati Generali, Totali).
- **Generazione PDF**: Crea una versione stampabile e leggibile della fattura in formato PDF, ideale per archiviazione o condivisione.
- **Design Pulito**: Interfaccia moderna e intuitiva basata su Material 3.

## 🛠️ Tecnologie Utilizzate

- **Flutter**: Framework di sviluppo cross-platform.
- **XML Parsing**: Librerie standard Dart per l'analisi del formato XML.
- **PDF Generation**: Libreria `pdf` per la creazione di documenti PDF.
- **Web Folder Picker**: Integrazione con API native del browser per la selezione di cartelle.

## 📦 Installazione e Avvio

1. **Clona il repository** (o scarica la cartella del progetto).
2. **Apri il progetto** con VS Code o Android Studio.
3. **Esegui il comando** per avviare l'app su Chrome:

```bash
flutter run -d chrome
```

## 📂 Struttura del Progetto

- `lib/main.dart`: Punto di ingresso dell'applicazione e UI principale.
- `lib/models/fattura.dart`: Definizione della classe `Fattura` e delle sue proprietà.
- `lib/utils/xml_parser.dart`: Logica di parsing dei file XML/P7M/EML.
- `lib/utils/folder_picker.dart`: Gestione della selezione delle cartelle (Web).
- `lib/utils/pdf_generator.dart`: Logica di generazione del PDF.
