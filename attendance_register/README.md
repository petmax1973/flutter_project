# Registro Presenze

Un'applicazione gestionale sviluppata in Flutter per tenere traccia delle presenze di atleti, allievi o studenti durante gli allenamenti e le lezioni. È pensata per essere leggera, reattiva e funzionante totalmente offline.

## Funzionamento dell'App

L'applicazione offre un'interfaccia intuitiva e minimalista, suddivisa in due sezioni principali dal Menu in basso (Bottom Navigation Bar):

### 1. Calendario (Visualizzazione Appello)

Il primo approccio alla gestione. Consente di navigare fra i mesi e gestire i giorni di allenamento.

- **Giornate di Lezione**: Sotto i giorni in cui è stato registrato un appello (con almeno un presente), compare un puntino identificativo visivo automatico.
- **Appello Rapido**: Cliccando su un giorno, il sistema ti chiede per quale "Gruppo" eseguire l'appello e carica la lista delle persone associate.
- **Autosalvataggio Reattivo**: Quando si spunta/non spunta un nome durante l'appello o si naviga all'indietro, il database salva immediatamente il record in locale in background senza farti perdere tempo.

### 2. Gestione Gruppi e Partecipanti

La sezione anagrafica dove poter amministrare gli iscritti.

- **Gruppi**: Puoi creare classi divise in categorie logiche (es: "Esordienti", "Pre-Agonisti").
- **Gestione Veloce**: All'interno del gruppo vedrai la lista completa dei partecipanti in ordine alfabetico e dotata di numero progressivo (badge).
- Funzioni di amministrazione che permettono di includere al volo un nuovo utente o scorciatoie dirette per **modificare il nome** ✏️ e **rimuoverlo dal database** 🗑️ (che elimina a valanga anche il suo pregresso).

### 3. Storico Individuale (Dettaglio Partecipante)

Cliccando invece sul nome di un Partecipante, si apre lo *Storico Personale* progettato intelligentemente:
Il database non si limita a stampare date "a caso", bensì preleva **l'elenco di tutte le lezioni documentate a cui il suo Gruppo ha assistito** e fa un confronto tra chi c'era e chi non c'era, mostrandoti esplicitamente e cromaticamente:

- ✅ Le giornate in cui il partecipante vanta una Presenza.
- ❌ Le giornate della squadra in cui è risultato palesemente Assente.
  
---

*Sviluppato con Flutter | Database locale Offline tramite Sqflite*
